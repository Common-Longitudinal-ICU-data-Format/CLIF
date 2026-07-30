---
name: mcide-mapper
description: Maps raw EHR source values in Excel spreadsheets to standardized CLIF mCIDE category values, optionally reusing a site's previous mapping file so only new names are mapped fresh. Use when a CLIF consortium site needs to map local medication names, lab names, vital sign names, respiratory device or mode names, organism names, assessment names, or any other raw EHR string column to its mCIDE *_category (e.g., med_category, lab_category, vital_category, device_category, organism_category). Triggers on requests to "map to mCIDE", "map to CLIF categories", "standardize EHR names", "update our existing CLIF mapping", "create a clif_vocab mapping", or CLIF ETL vocabulary mapping work in Excel or CSV files.
---

# mCIDE Mapper

Maps site-specific raw EHR names to CLIF mCIDE controlled-vocabulary categories, producing a reviewable mapping with confidence levels and the canonical `clif_vocab` output used across the CLIF consortium.

Vocabulary version: see the bundled `VERSION` file. Always state this version in your final report.

## When to Use

- The user has an Excel/CSV column of raw EHR names (medication names, lab names, vitals, devices, ventilator modes, organisms, locations, assessments, etc.) and wants the corresponding mCIDE categories.
- The user mentions CLIF, mCIDE, `clif_vocab`, category mapping, or ETL vocabulary standardization.

## Workflow (follow in order)

### Step 1 — Identify the target variable

- Determine which CLIF table + category variable the user's column represents (e.g., "continuous infusion meds" → `medication_admin_continuous` / `med_category`). Infer from column headers and data content; ask the user if unclear.
- Look the variable up in `reference/INDEX.md` to get the exact vocab CSV path, its column layout, row count, and quirks. Read ONLY the vocab file you need — do not load others.
- If the choice between tables is ambiguous (e.g., meds could be continuous infusions vs intermittent administrations — these have DIFFERENT category sets), ask the user before mapping.
- Files marked "not a mapping target" in INDEX.md (code lists, group lookup aids) must not be used as mapping targets.

### Step 2 — Collect the raw values

- Read the user's column and work on UNIQUE values only. Determine `n`, the frequency of each unique value:
  - If the sheet already has a count/frequency column (common — sites often export a pre-aggregated extract; the column may be named `n`, `count`, `freq`, `n_admin`, or similar), carry those values through unchanged. If a raw name appears on several rows that each carry a count, sum them.
  - Otherwise count occurrences yourself while deduplicating.
  - Only if the sheet is a deduplicated list with no count column, use n = 1.
- Note any companion columns that help mapping (dose units, specimen, result units) — you will need them in Step 4.

### Step 2b — Load prior mappings (whenever the site has them)

Sites usually have mappings they made in an earlier round. Reusing them keeps categories stable across ETL runs and cuts review work to the genuinely new names.

- Ask whether the site has a prior mapping file or sheet **before** you start mapping, unless they already supplied one. Look for an existing `clif_vocab_*` sheet in the open workbook. With no user available to ask, use any prior mapping you can find in the workbook or working directory; if there is none, map everything fresh and say so.
- Read `reference/prior-mappings.md` for the accepted input formats, the matching rules, and how to handle prior categories that are no longer valid. Core rules:
  - Match each raw value against the prior mapping by exact string first, then by a normalized comparison (trim, collapse internal whitespace, case-insensitive). Do not fuzzy-match beyond that — a near-miss is a new mapping, not a reused one.
  - Every reused row carries `mapping_source = prior_mapping`; everything you map yourself carries `mapping_source = new_mcide`.
  - Validate every reused category against the current vocab CSV. A prior category that no longer exists gets remapped, flagged, and marked `prior_mapping_retired`.

### Step 3 — Map each unique value

- If Step 2b matched this value to a prior mapping, reuse that category — do not re-derive it. Skip to the next value. Only unmatched values are mapped from scratch here.
- A raw value may ONLY be assigned a category string that appears verbatim in the vocab CSV. NEVER invent, pluralize, re-case, abbreviate, or "improve" a category value.
- Use the `description` and `*_name_examples` columns as matching evidence. Examples are sparse (≤3 per category) — treat them as anchors, not an exhaustive list; use clinical knowledge for synonyms and brand↔generic matches.
- Assign a confidence level to every row:
  - `high` — exact or near-exact match to the category name or a listed name example
  - `medium` — clear clinical synonym or brand→generic match (e.g., Levophed → norepinephrine, Precedex → dexmedetomidine)
  - `low` — plausible but uncertain; requires site reviewer sign-off
- If there is no defensible match, set category = `no_match` and confidence = `none`. Never force the closest category.
- Set `needs_review = TRUE` whenever confidence is `low` or `none`, **or** whenever a disambiguation rule in Step 4 fired (unit mismatch, unresolved specimen, missing concentration, wrong-table row, additive product) — even if confidence is otherwise high or medium, and even on a row reused from a prior mapping.
- If the vocab file has no examples column (see INDEX.md), rely on the category value and description only, and be conservative with confidence.
- If you are running without a user to ask (an automated or batch context), do not stall: proceed with the most defensible interpretation, flag the affected rows, and state the assumption you made in the Step 6 report.

### Step 4 — Domain-specific disambiguation

Read `reference/disambiguation.md` before mapping **labs** or **medications** — it holds the operative rules, and where it is more specific than the summary below, it wins. Summary:

- **Labs**: `lab_category` is NOT unique — the same analyte appears in multiple rows for different specimens (e.g., albumin serum vs urine). Use the workbook's specimen and result-unit columns together with the vocab file's `reference_unit` and `lab_specimen_category` columns to pick the correct row. If the sheet has no specimen or unit column, flag ALL specimen-ambiguous labs as `needs_review` and say so in the report.
- **Medications**: the vocab lists the expected `med_dose_unit` (and `volume_infusion_rate_units` for continuous infusions). If the sheet has a dose-unit column, cross-check it; a mismatch sets `needs_review = TRUE` with an explanatory note, and whether it also downgrades confidence depends on which side is corroborated — see `disambiguation.md` rule 4.

### Step 5 — Write results back to Excel (produce BOTH outputs)

See `reference/output-format.md` for the full spec. In brief:

1. **In-place review columns** appended to the right of the user's sheet (never overwrite or reorder their columns):
   `<var>_category | mapping_confidence | mapping_source | needs_review | mapping_note`
   `mapping_source` is `prior_mapping`, `prior_mapping_retired`, or `new_mcide`. Include this column only when the site supplied a prior mapping; otherwise omit it (everything would be `new_mcide`).
   `mapping_note` is a short justification for medium/low/no_match calls and for any flagged row; leave blank for unflagged high-confidence rows.
2. **Canonical mapping sheet**: a new sheet named `clif_vocab_<table>_<variable>_<site>` with columns `<var>_category, <var>_name, n, site`, sorted by category then descending n. Ask the user for their site short name (e.g., RUSH, UCMC) if not stated; in a batch context with no site available, use `SITE` as a placeholder and say so in the report. Long table names need the fixed abbreviations in `output-format.md` to fit Excel's 31-character sheet-name limit.
- Apply light formatting: bold header rows; highlight `needs_review = TRUE` rows with a yellow fill.
- If working with plain CSVs instead of an Excel workbook, follow the CSV fallback section of `output-format.md`.

### Step 6 — Report

Summarize for the user:
- Counts by confidence level (high / medium / low / no_match)
- When a prior mapping was used: how many rows were reused vs newly mapped, which prior categories were retired and what they became, any prior mapping you disagreed with (and what you would have chosen), and any prior entries that no longer appear in the current data
- The full list of `no_match` values
- Every row flagged `needs_review = TRUE` that is not already covered by the `no_match` list, with the reason
- Any systematic issues (e.g., "your lab sheet has no specimen column, so all specimen-ambiguous analytes were flagged"; "your list mixes infusions with PRN oral meds")
- The mCIDE vocabulary version, quoted verbatim from the `VERSION` file, and a reminder to have a clinician or data manager review every flagged row before using the mapping in ETL.

## Handling large vocabularies

- **Organisms** (microbiology_culture, 541 categories): read `vocab/microbiology_culture/organism_index.md` first, shortlist the genera present in the user's data, then read only the matching rows of the full CSV. Read the full CSV only if the sheet has >100 unique organisms.
- **Intermittent meds** (271 categories): read `vocab/medication_admin_intermittent/med_index.md` first to shortlist by medication group, then confirm against the full CSV.

## Hard rules

- Never emit a category that is absent from the bundled vocab CSV.
- Never delete, overwrite, or reorder the user's original data.
- Unmatched values are `no_match`, never a guess.
- Always produce the review columns AND the clif_vocab sheet, and always tell the user which rows need human review.
