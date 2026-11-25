"""Builds the ready-made mock tests that Admin > Import mock tests reads.

Run from the repository root:  python3 content/mock/build_mock.py
Writes supabase/content/mock/<slug>.json and supabase/content/mock/index.json.
"""

import importlib.util
import json
import pathlib

ROOT = pathlib.Path(__file__).resolve().parents[2]
SRC = pathlib.Path(__file__).resolve().parent
OUT = ROOT / "supabase" / "content" / "mock"

# Test files, in the order they appear in Admin.
TESTS = ["assam_gk_mock_1"]


def load(name):
    spec = importlib.util.spec_from_file_location(name, SRC / f"{name}.py")
    mod = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(mod)
    return mod


def build(mod):
    questions = []
    for i, (t_en, t_as, q_en, q_as, o_en, o_as, x_en, x_as) in enumerate(mod.QUESTIONS):
        assert len(o_en) == len(o_as), q_en
        # The right answer is written first; move it to a different place in
        # each question so it is not always A.
        right = i * 3 % len(o_en)
        order = list(range(1, len(o_en)))
        order.insert(right, 0)
        questions.append({
            "topic_en": t_en, "topic_as": t_as,
            "question_en": q_en, "question_as": q_as,
            "options_en": [o_en[k] for k in order],
            "options_as": [o_as[k] for k in order],
            "correct_index": right,
            "explanation_en": x_en, "explanation_as": x_as,
        })
    return {"slug": mod.SLUG, "set": mod.SET, "questions": questions}


def main():
    OUT.mkdir(parents=True, exist_ok=True)
    index = []
    for name in TESTS:
        data = build(load(name))
        file = f"{data['slug']}.json"
        (OUT / file).write_text(json.dumps(data, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
        index.append({"file": file, "name": data["set"]["title_en"], "questions": len(data["questions"])})
        print(f"{file}: {len(data['questions'])} questions")
    (OUT / "index.json").write_text(json.dumps({"tests": index}, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
