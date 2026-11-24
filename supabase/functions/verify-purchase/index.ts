// verify-purchase: checks a Google Play subscription with Google and, if it is
// active, gives the signed-in reader Premium until it expires.
//
// Needs one secret in Supabase (Edge Functions > Secrets):
//   GOOGLE_SERVICE_ACCOUNT = the whole JSON key file of a Google Cloud service
//   account that has access to this app in Play Console.
// SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY are provided by Supabase.
import { createClient } from "npm:@supabase/supabase-js@2";

const PACKAGE_NAME = "com.assampedia.app";
const PRODUCT_ID = "assampedia_premium";
// Still paid up until the expiry time in these states.
const ACTIVE_STATES = new Set([
  "SUBSCRIPTION_STATE_ACTIVE",
  "SUBSCRIPTION_STATE_IN_GRACE_PERIOD",
  "SUBSCRIPTION_STATE_CANCELED",
]);

const json = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { "Content-Type": "application/json" } });

function b64url(bytes: Uint8Array): string {
  let s = "";
  for (const b of bytes) s += String.fromCharCode(b);
  return btoa(s).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

async function googleAccessToken(sa: { client_email: string; private_key: string }): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const enc = new TextEncoder();
  const header = b64url(enc.encode(JSON.stringify({ alg: "RS256", typ: "JWT" })));
  const claim = b64url(enc.encode(JSON.stringify({
    iss: sa.client_email,
    scope: "https://www.googleapis.com/auth/androidpublisher",
    aud: "https://oauth2.googleapis.com/token",
    iat: now,
    exp: now + 3600,
  })));
  const pem = sa.private_key.replace(/-----[^-]+-----/g, "").replace(/\s/g, "");
  const der = Uint8Array.from(atob(pem), (c) => c.charCodeAt(0));
  const key = await crypto.subtle.importKey("pkcs8", der, { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" }, false, ["sign"]);
  const sig = new Uint8Array(await crypto.subtle.sign("RSASSA-PKCS1-v1_5", key, enc.encode(`${header}.${claim}`)));
  const res = await fetch("https://oauth2.googleapis.com/token", {
    method: "POST",
    headers: { "Content-Type": "application/x-www-form-urlencoded" },
    body: new URLSearchParams({
      grant_type: "urn:ietf:params:oauth:grant-type:jwt-bearer",
      assertion: `${header}.${claim}.${b64url(sig)}`,
    }),
  });
  if (!res.ok) throw new Error(`Google sign-in failed (${res.status})`);
  return (await res.json()).access_token;
}

Deno.serve(async (req) => {
  if (req.method !== "POST") return json({ error: "Use POST" }, 405);

  const admin = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!);
  const jwt = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "");
  const { data: auth } = await admin.auth.getUser(jwt);
  const user = auth?.user;
  if (!user) return json({ error: "Please sign in first." }, 401);

  let purchaseToken = "";
  try {
    purchaseToken = String((await req.json()).purchaseToken ?? "");
  } catch (_) {
    // handled below
  }
  if (!purchaseToken) return json({ error: "Missing purchase token." }, 400);

  const rawKey = Deno.env.get("GOOGLE_SERVICE_ACCOUNT");
  if (!rawKey) return json({ error: "Server is not set up yet (GOOGLE_SERVICE_ACCOUNT missing)." }, 500);

  let sub: any;
  try {
    const token = await googleAccessToken(JSON.parse(rawKey));
    const res = await fetch(
      `https://androidpublisher.googleapis.com/androidpublisher/v3/applications/${PACKAGE_NAME}` +
        `/purchases/subscriptionsv2/tokens/${encodeURIComponent(purchaseToken)}`,
      { headers: { Authorization: `Bearer ${token}` } },
    );
    if (!res.ok) return json({ error: `Google Play could not check this purchase (${res.status}).` }, 502);
    sub = await res.json();
  } catch (e) {
    return json({ error: `Could not reach Google Play: ${(e as Error).message}` }, 502);
  }

  // The app tags each purchase with the reader's account, so a purchase
  // cannot be used to unlock someone else's account.
  const owner = sub.externalAccountIdentifiers?.obfuscatedExternalAccountId;
  if (owner && owner !== user.id) return json({ error: "This purchase belongs to another account." }, 403);

  const items = (sub.lineItems ?? []).filter((i: any) => i.productId === PRODUCT_ID);
  if (items.length === 0) return json({ error: "This is not an ASSAMPEDIA Premium purchase." }, 400);
  const expiry = new Date(Math.max(...items.map((i: any) => Date.parse(i.expiryTime ?? "") || 0)));
  const active = ACTIVE_STATES.has(sub.subscriptionState) && expiry.getTime() > Date.now();

  const { data: other } = await admin
    .from("premium_access")
    .select("user_id")
    .eq("purchase_token", purchaseToken)
    .neq("user_id", user.id)
    .maybeSingle();
  if (other) return json({ error: "This purchase is already linked to another account." }, 409);

  const { error } = await admin.from("premium_access").upsert({
    user_id: user.id,
    expires_at: (active ? expiry : new Date()).toISOString(),
    product_id: PRODUCT_ID,
    purchase_token: purchaseToken,
    source: "google_play",
    updated_at: new Date().toISOString(),
  });
  if (error) return json({ error: `Could not save: ${error.message}` }, 500);

  return json({ premium: active, expires_at: expiry.toISOString(), state: sub.subscriptionState });
});
