# Setting up the ASSAMPEDIA database

Do this once, in the Supabase dashboard.

1. Open your project and go to **SQL Editor → New query**.
2. Copy everything in `migrations/0001_content.sql`, paste it, and press **Run**.
   It creates the tables, the security rules, the `media` storage folder and the
   12 Assam GK categories.
3. Sign up in the app with your email (Me tab → Sign in → Create account).
4. Back in **SQL Editor**, make that account the admin (put your email in):

   ```sql
   update public.profiles set role = 'admin'
   where id = (select id from auth.users where email = 'your@email.com');
   ```

5. Close and reopen the app. The **Admin panel** appears on the Me tab.

## How content is stored

- `content`: one row per chapter, shared by both languages.
- `content_versions`: the Assamese (`as`) and English (`en`) title, summary,
  sources and status. Each language is published separately.
- `content_blocks`: paragraphs and boxes. `block_key` is the same in both
  languages, which is how the app keeps your place when you switch.

Readers can only read published versions. Only admin accounts can change content.

## Testing the security rules locally

`tests/local_stub.sql` stands in for Supabase's auth and storage on plain
PostgreSQL; `tests/rls_test.sql` checks who can read and write what.
