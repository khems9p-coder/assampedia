"""Turns a chapter data file (content/gk/NN_name.py) into SQL for the Supabase SQL Editor.

Usage:  python3 content/build_sql.py content/gk/01_introduction.py
Writes  supabase/content/NN_name.sql          (adds the chapters as drafts)
and     supabase/content/NN_name_publish.sql  (publishes the whole group after checking)
"""
import importlib.util
import pathlib
import re
import sys

TERM = re.compile(r"\{\{term:([a-z0-9-]+)(?:\|[^}]*)?\}\}")
LANGS = ("en", "as")
TYPES = {"heading", "paragraph", "fact_box", "list", "image"}
STYLES = {"normal", "definition", "verified_fact", "event", "personality",
          "exam_fact", "geography", "heritage", "suggested"}


def q(text):
    """Dollar-quote a string so quotes and apostrophes need no escaping."""
    if text is None:
        return "null"
    assert "$t$" not in text
    return f"$t${text}$t$"


def load(path):
    spec = importlib.util.spec_from_file_location("chapters", path)
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def check(mod):
    known = {t["slug"] for t in mod.TERMS} | set(getattr(mod, "EXISTING_TERMS", ()))
    used = set()
    for t in mod.TERMS:
        assert re.fullmatch(r"[a-z0-9]+(-[a-z0-9]+)*", t["slug"]), t["slug"]
    for ch in mod.CHAPTERS:
        keys = {lang: [b[0] for b in ch["blocks"][lang]] for lang in LANGS}
        if keys["en"] != keys["as"]:
            sys.exit(f"{ch['slug']}: English and Assamese blocks differ: {keys}")
        for lang in LANGS:
            assert ch["title"][lang] and ch["summary"][lang]
            for key, btype, style, body in ch["blocks"][lang]:
                assert btype in TYPES and style in STYLES, (ch["slug"], key)
                assert "{{" not in TERM.sub("", body), (ch["slug"], key, "broken term marker")
                assert "\ufffd" not in body, (ch["slug"], key, "garbled character")
                for slug in TERM.findall(body):
                    if slug not in known:
                        sys.exit(f"{ch['slug']}: unknown term {slug}")
                    used.add(slug)
    unused = {t["slug"] for t in mod.TERMS} - used
    if unused:
        sys.exit(f"terms defined but never used: {sorted(unused)}")


def build(mod):
    out = [
        f"-- ASSAMPEDIA content: {mod.CATEGORY_NAME}",
        "-- Adds the chapters below as DRAFTS (readers cannot see them yet).",
        "-- Run once in Supabase SQL Editor (New query), on its own. Safe to run again:",
        "-- anything already there is left untouched.",
        "begin;",
        "",
        "-- Dictionary words used in these chapters (readers tap them to see the meaning).",
    ]
    for t in mod.TERMS:
        out.append(
            "insert into public.terms (slug, term_en, term_as, meaning_en, meaning_as) values "
            f"({q(t['slug'])}, {q(t['en'])}, {q(t['as'])}, {q(t['meaning_en'])}, {q(t['meaning_as'])}) "
            "on conflict (slug) do nothing;"
        )
    for ch in mod.CHAPTERS:
        slug = ch["slug"]
        sel = f"from public.content where slug = {q(slug)}"
        out += ["", f"-- Chapter {ch['position']}: {ch['title']['en']}"]
        out.append(
            "insert into public.content (slug, kind, category_id, position) "
            f"select {q(slug)}, 'gk_chapter', id, {ch['position']} from public.categories "
            f"where slug = {q(mod.CATEGORY_SLUG)} on conflict (slug) do nothing;"
        )
        for lang in LANGS:
            out.append(
                "insert into public.content_versions (content_id, lang, title, summary, status, sources, last_checked) "
                f"select id, '{lang}', {q(ch['title'][lang])}, {q(ch['summary'][lang])}, 'draft', "
                f"{q(ch['sources'])}, date '{mod.LAST_CHECKED}' {sel} on conflict do nothing;"
            )
            for pos, (key, btype, style, body) in enumerate(ch["blocks"][lang], start=1):
                out.append(
                    "insert into public.content_blocks (content_id, lang, block_key, position, block_type, style, body) "
                    f"select id, '{lang}', '{key}', {pos}, '{btype}', '{style}', {q(body)} {sel} "
                    "on conflict do nothing;"
                )
    out += ["", "commit;", ""]
    return "\n".join(out)


def build_publish(mod):
    slugs = ", ".join(q(ch["slug"]) for ch in mod.CHAPTERS)
    return "\n".join([
        f"-- ASSAMPEDIA: publish {mod.CATEGORY_NAME} (both languages).",
        "-- Run this ONLY after you have checked the drafts in Admin.",
        "update public.content_versions set status = 'published', updated_at = now()",
        f"where content_id in (select id from public.content where slug in ({slugs}));",
        "",
    ])


if __name__ == "__main__":
    src = pathlib.Path(sys.argv[1])
    mod = load(src)
    check(mod)
    dest = pathlib.Path(__file__).resolve().parent.parent / "supabase" / "content"
    dest.mkdir(parents=True, exist_ok=True)
    (dest / f"{src.stem}.sql").write_text(build(mod), encoding="utf-8")
    (dest / f"{src.stem}_publish.sql").write_text(build_publish(mod), encoding="utf-8")
    print(f"wrote {src.stem}.sql and {src.stem}_publish.sql: {len(mod.CHAPTERS)} chapters, {len(mod.TERMS)} terms")
