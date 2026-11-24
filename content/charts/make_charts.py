"""Draws the simple charts used in GK chapters, as PNG files.

Every number here is copied from the chapter text in content/gk/, which gives the source.
Usage:  python3 content/charts/make_charts.py
Writes  supabase/content/images/charts/<name>.png
"""
import pathlib

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt  # noqa: E402

OUT = pathlib.Path(__file__).resolve().parents[2] / "supabase" / "content" / "images" / "charts"
GREEN = "#1E6B3C"   # app tea green
INK = "#1F2A24"
MUTED = "#5F6B64"
BG = "#FFFFFF"


def bars(name, title, note, labels, values, fmt):
    """Horizontal bar chart, one colour, value written at the end of each bar."""
    fig, ax = plt.subplots(figsize=(8, 0.75 * len(labels) + 1.6), dpi=150)
    fig.patch.set_facecolor(BG)
    ax.set_facecolor(BG)
    y = range(len(labels))[::-1]
    ax.barh(list(y), values, color=GREEN, height=0.6)
    top = max(values)
    for yi, v in zip(y, values):
        ax.text(v + top * 0.015, yi, fmt(v), va="center", ha="left", fontsize=13, color=INK)
    ax.set_yticks(list(y), labels, fontsize=13, color=INK)
    ax.set_xlim(0, top * 1.22)
    ax.xaxis.set_visible(False)
    for side in ("top", "right", "bottom"):
        ax.spines[side].set_visible(False)
    ax.spines["left"].set_color("#C9D1CC")
    ax.tick_params(axis="y", length=0, pad=8)
    fig.suptitle(title, x=0.02, ha="left", fontsize=16, fontweight="bold", color=INK)
    fig.text(0.02, 0.02, note, ha="left", fontsize=10, color=MUTED)
    fig.tight_layout(rect=(0, 0.06, 1, 0.95))
    OUT.mkdir(parents=True, exist_ok=True)
    fig.savefig(OUT / f"{name}.png", facecolor=BG)
    plt.close(fig)


def lakh(n):
    return f"{n / 100000:.2f} lakh"


def main():
    # 01_introduction.py, assam-at-a-glance: literacy rate.
    bars("literacy-2011", "Literacy rate of Assam, 2011", "Source: Census of India 2011",
         ["Total", "Males", "Females"], [72.19, 77.85, 66.27], lambda v: f"{v:.2f}%")
    # 01_introduction.py, assam-at-a-glance: rural and urban population.
    bars("rural-urban-2011", "Where the people of Assam live, 2011", "Source: Census of India 2011",
         ["Villages (rural)", "Towns (urban)"], [26807034, 4398542], lakh)
    # 08_society.py, population-census-2011: religion (Buddhist 0.18 + Jain 0.08 + Sikh 0.07 = 0.33).
    bars("religion-2011", "Religions in Assam, 2011 (% of people)", "Source: Census of India 2011",
         ["Hindu", "Muslim", "Christian", "Buddhist, Jain, Sikh"], [61.47, 34.22, 3.74, 0.33],
         lambda v: f"{v:.2f}%")
    # 05_wildlife.py, one-horned-rhinoceros: wild rhinos in India and Nepal together.
    bars("rhino-count", "Wild one-horned rhinos in the world", "Counts for India and Nepal together",
         ["2006", "2025"], [2577, 4075], lambda v: f"{v:,}")


if __name__ == "__main__":
    main()
