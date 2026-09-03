#!/usr/bin/env bash
# Build the mcide-mapper Claude Skill zip from the live mCIDE CSVs.
#
# Usage:
#   ./build_skill.sh          rebuild; repackage the zip only if the content changed
#   ./build_skill.sh --force  repackage even when the content is unchanged
#   ./build_skill.sh --check  report whether the committed zip is current (exit 1 if stale)
#
# Output: skills/mcide-mapper.zip — committed to the repo so any site can download and
# upload it to their Claude account without running this script.
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
SRC="$REPO/mCIDE"
SKILL="$REPO/skills/mcide-mapper"
ZIP="$REPO/skills/mcide-mapper.zip"
MODE="${1:-}"

# Hash of everything that affects the skill: the mCIDE source CSVs and the hand-written
# skill docs. Deliberately excludes the build date and git SHA, so an unrelated commit
# never makes a current zip look stale.
content_hash() {
    SRC="$SRC" SKILL="$SKILL" python3 -c '
import hashlib, os
from pathlib import Path
src, skill = Path(os.environ["SRC"]), Path(os.environ["SKILL"])
h = hashlib.sha256()
files = sorted(src.glob("*/*.csv")) + [skill / "SKILL.md"] + sorted(
    p for p in (skill / "reference").glob("*.md") if p.name != "INDEX.md")
for p in files:
    h.update(p.name.encode())
    h.update(p.read_bytes())
print(h.hexdigest()[:8])
'
}

zip_hash() {
    [ -f "$ZIP" ] || return 1
    unzip -p "$ZIP" mcide-mapper/VERSION 2>/dev/null | tr -d '\n' | sed 's/.*+//'
}

HASH="$(content_hash)"

if [ "$MODE" = "--check" ]; then
    if ! ZH="$(zip_hash)"; then
        echo "STALE: $ZIP is missing — run ./build_skill.sh" >&2
        exit 1
    fi
    if [ "$ZH" != "$HASH" ]; then
        echo "STALE: committed zip is $ZH but current sources hash to $HASH." >&2
        echo "       Run ./build_skill.sh and commit the updated zip." >&2
        exit 1
    fi
    echo "Current: committed zip matches the mCIDE and skill sources ($HASH)"
    exit 0
fi

rm -rf "$SKILL/vocab" "$SKILL/reference/INDEX.md" "$SKILL/VERSION"

VERSION="$(date +%Y.%m.%d)+$HASH"
echo "$VERSION" > "$SKILL/VERSION"

SRC="$SRC" SKILL="$SKILL" python3 - <<'PYEOF'
import csv, io, os, sys
from pathlib import Path

SRC = Path(os.environ["SRC"])
SKILL = Path(os.environ["SKILL"])
VOCAB = SKILL / "vocab"

# Hand-maintained notes keyed by path relative to mCIDE/. Everything mechanical
# (row counts, column names) is derived from the files themselves.
QUIRKS = {
    "labs/clif_lab_categories.csv":
        "lab_category NOT unique — disambiguate with reference_unit + lab_specimen_category (see disambiguation.md); lab_order_category and lab_specimen_category are slash-delimited when multi-valued (bmp/poc) — resolve to one value per row; no description column",
    "medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv":
        "has med_dose_unit + volume_infusion_rate_units — cross-check units (see disambiguation.md)",
    "medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv":
        "LARGE — read med_index.md first; has med_dose_unit — cross-check units (see disambiguation.md)",
    "microbiology_culture/clif_microbiology_culture_organism_categories.csv":
        "LARGE — read organism_index.md first; many descriptions empty",
    "labs/clif_labs_order_categories.csv": "examples column is 'example labs'",
    "invasive_hemodynamics/clif_invasive_hemodynamics_measure_categories.csv":
        "non-standard layout: 'Maps from' column holds source names",
    "patient_attributes/clif_patient_attributes_attribute_value_categories.csv":
        "values keyed by applicable_attribute_categories, no examples",
}

# Lookup aids / code lists — never map raw names directly onto these.
NOT_TARGETS = {
    "patient_procedures/clif_patient_procedure_codes.csv": "procedure code list",
    "microbiology_culture/clif_microbiology_culture_organism_groups.csv": "group lookup aid",
    "microbiology_nonculture/clif_microbiology_nonculture_organism_groups.csv": "group lookup aid",
    "patient_attributes/clif_patient_attributes_attribute_groups.csv": "group lookup aid",
    "input/clif_input_group.csv": "group lookup aid",
}

sources = sorted(SRC.glob("*/*.csv"))
records = []
for src in sources:
    rel = src.relative_to(SRC)
    text = src.read_text(encoding="utf-8-sig")  # strips BOM
    rows = list(csv.reader(io.StringIO(text)))
    header = [h.strip() for h in rows[0]]
    rows[0] = header

    dst = VOCAB / rel
    dst.parent.mkdir(parents=True, exist_ok=True)
    with open(dst, "w", encoding="utf-8", newline="") as f:
        csv.writer(f, lineterminator="\n").writerows(rows)

    examples_col = next((h for h in header if "example" in h.lower()), "(none)")
    records.append({
        "rel": str(rel), "table": rel.parts[0], "file": rel.name,
        "n": len(rows) - 1, "category_col": header[0], "examples_col": examples_col,
        "header": header, "rows": rows[1:],
    })

if len(records) != len(sources):
    sys.exit("BUILD FAILED: vocab CSV count mismatch")
print(f"Normalized {len(records)} CSVs")

# --- reference/INDEX.md ---
lines = [
    "# Vocabulary Index",
    "",
    "One row per bundled vocab file. Find your variable, read ONLY that file.",
    "Files marked 'NOT a mapping target' are lookup aids or code lists.",
    "",
    "| CLIF table | Vocab file | Rows | Category column | Examples column | Notes |",
    "|---|---|---|---|---|---|",
]
for r in records:
    notes = []
    if r["rel"] in NOT_TARGETS:
        notes.append(f"NOT a mapping target ({NOT_TARGETS[r['rel']]})")
    if r["rel"] in QUIRKS:
        notes.append(QUIRKS[r["rel"]])
    if r["examples_col"] == "(none)" and r["rel"] not in NOT_TARGETS:
        notes.append("no examples column — match on category + description, be conservative")
    lines.append(
        f"| {r['table']} | vocab/{r['rel']} | {r['n']} | {r['category_col']} "
        f"| {r['examples_col']} | {'; '.join(notes)} |"
    )
(SKILL / "reference" / "INDEX.md").write_text("\n".join(lines) + "\n", encoding="utf-8")
print("Generated reference/INDEX.md")

def digest(rel, key_fn, title, intro):
    rec = next(r for r in records if r["rel"] == rel)
    idx = {h: i for i, h in enumerate(rec["header"])}
    groups = {}
    for row in rec["rows"]:
        if not row or not row[0].strip():
            continue
        groups.setdefault(key_fn(row, idx), []).append(row[0].strip())
    out = [f"# {title}", "", intro, ""]
    for g in sorted(groups):
        out.append(f"- **{g}**: {', '.join(groups[g])}")
    path = VOCAB / Path(rel).parent / (title.split()[0].lower() + "_index.md")
    path.write_text("\n".join(out) + "\n", encoding="utf-8")
    print(f"Generated {path.relative_to(SKILL)} ({len(groups)} groups)")

digest(
    "microbiology_culture/clif_microbiology_culture_organism_categories.csv",
    lambda row, idx: row[0].strip().split("_")[0],
    "Organism categories by genus",
    "Shortlist the genera present in the user's data, then read only the matching "
    "rows of clif_microbiology_culture_organism_categories.csv.",
)
digest(
    "medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv",
    lambda row, idx: row[idx["med_group"]].strip() or "(ungrouped)",
    "Med categories by group (intermittent)",
    "Shortlist candidate groups for the user's meds, then confirm against "
    "clif_medication_admin_intermittent_med_categories.csv.",
)

# --- sanity checks ---
skill_md = (SKILL / "SKILL.md").read_text(encoding="utf-8")
if not skill_md.startswith("---"):
    sys.exit("BUILD FAILED: SKILL.md missing frontmatter")
front = skill_md.split("---")[1]
fields = {}
for line in front.strip().splitlines():
    if ":" in line:
        k, v = line.split(":", 1)
        fields[k.strip()] = v.strip()
if "name" not in fields or "description" not in fields:
    sys.exit("BUILD FAILED: SKILL.md frontmatter needs name and description")
if len(fields["description"]) > 1024:
    sys.exit("BUILD FAILED: description exceeds 1024 chars")
index_text = (SKILL / "reference" / "INDEX.md").read_text(encoding="utf-8")
for r in records:
    if f"vocab/{r['rel']}" not in index_text:
        sys.exit(f"BUILD FAILED: {r['rel']} missing from INDEX.md")
    if not (VOCAB / r["rel"]).exists():
        sys.exit(f"BUILD FAILED: vocab/{r['rel']} was not written")
print("Sanity checks passed")
PYEOF

if [ "$MODE" != "--force" ] && [ "$(zip_hash || true)" = "$HASH" ]; then
    echo "Content unchanged ($HASH) — kept the existing zip. Use --force to repackage."
    exit 0
fi

rm -f "$ZIP"
(cd "$REPO/skills" && zip -rq "$ZIP" mcide-mapper -x "*.DS_Store")

SIZE=$(du -k "$ZIP" | cut -f1)
if [ "$SIZE" -gt 5120 ]; then
    echo "BUILD FAILED: zip exceeds 5MB (${SIZE}KB)" >&2
    exit 1
fi

echo "Built $ZIP (${SIZE}KB, version $VERSION)"
echo "Commit this zip so sites can download it directly from the repo."
