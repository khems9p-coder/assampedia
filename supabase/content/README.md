# Chapter content

Each group of GK chapters has two SQL files, made by `content/build_sql.py`
from the chapter text in `content/gk/`:

- `NN_group.sql` adds the chapters (English + Assamese) and their dictionary words as **drafts**.
- `NN_group_publish.sql` publishes the whole group. Run it only after checking the drafts in Admin
  (or publish chapters one by one in Admin instead).

Run the groups in number order (later groups reuse dictionary words from earlier ones).
Run each file on its own in Supabase SQL Editor (New query). Both are safe to run again.
Sources for every chapter are saved in its `sources` field; lines marked "TO VERIFY" must be
checked before publishing.
