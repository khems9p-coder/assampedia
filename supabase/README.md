# Setting up the ASSAMPEDIA database

Do this once, in the Supabase dashboard.

1. Open your project and go to **SQL Editor → New query**.
2. Copy everything in `migrations/0001_content.sql`, paste it, and press **Run**.
   It creates the tables, the security rules, the `media` storage folder and the
   12 Assam GK categories.
3. Sign up in the app with your email (Me tab → Sign in → Create account).
4. Back in **SQL Editor**, make that account the admin (put your email in):

   ```sql
   insert into public.profiles (id, role)
   select id, 'admin' from auth.users where email = 'your@email.com'
   on conflict (id) do update set role = 'admin';
   ```

5. In the app, sign out and sign in again. The **Admin panel** appears on the Me tab.

## Updates (run each file once, in order, each in its own New query)

- `migrations/0002_terms.sql` (Phase 3): the dictionary of tappable terms and faster search.
- `migrations/0003_api_access.sql`: lets the app read and write the tables (newer Supabase projects need this).
- `migrations/0004_exams_careers.sql` (Phase 4): exam and career groups, official links, and the "suggested, not official" box style.
- `migrations/0005_current_affairs_jobs.sql` (Phase 5): current-affairs groups and event dates, and the job vacancies table.

## How content is stored

- `content`: one row per chapter, shared by both languages.
- `content_versions`: the Assamese (`as`) and English (`en`) title, summary,
  sources and status. Each language is published separately.
- `content_blocks`: paragraphs and boxes. `block_key` is the same in both
  languages, which is how the app keeps your place when you switch.

Readers can only read published versions. Only admin accounts can change content.

## Testing the security rules locally

`tests/local_stub.sql` stands in for Supabase's auth and storage on plain
PostgreSQL; `tests/rls_test.sql` checks who can read and write what, and
`tests/terms_test.sql` does the same for the dictionary.
