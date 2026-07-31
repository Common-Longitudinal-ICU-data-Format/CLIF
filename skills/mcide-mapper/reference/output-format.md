# Output Format Specification

Two outputs are always produced: review columns in the user's sheet, and a canonical mapping sheet.

## 1. In-place review columns

Appended immediately to the right of the user's existing columns, one row per original row:

| Column | Values | Notes |
|---|---|---|
| `<var>_category` | a category from the vocab CSV, or `no_match` | verbatim from the vocab file — exact case and spelling |
| `mapping_confidence` | `high` \| `medium` \| `low` \| `none` | `none` only with `no_match` |
| `mapping_source` | `prior_mapping` \| `prior_mapping_retired` \| `new_mcide` | include ONLY when the site supplied a prior mapping (see `prior-mappings.md`); omit the column entirely otherwise |
| `needs_review` | `TRUE` \| `FALSE` | TRUE when confidence is `low` or `none`, or when a disambiguation rule fired |
| `mapping_note` | short free text | why a medium/low/no_match call was made, or what a flag means (e.g., "brand name Levophed → norepinephrine"; "unit mismatch: sheet says mcg, name and vocab say units"); blank for unflagged high-confidence rows |

Formatting: bold the header row; yellow fill on rows where `needs_review = TRUE`. Do not touch the user's original cells.

## 2. Canonical clif_vocab mapping sheet

This is the format CLIF sites exchange and feed into ETL (matches the consortium's
`CIDE_mapping_generator` output).

- **Sheet/file name:** `clif_vocab_<table_name>_<variable_name>_<site>`, where `<variable_name>` is the category column with the `_category` suffix removed (`med_category` → `med`, `vital_category` → `vital`, `device_category` → `device`)
  e.g., `clif_vocab_vitals_vital_RUSH`, `clif_vocab_labs_lab_UCMC`
- **Every unique raw value gets a row, including `no_match` rows** — the sheet is the site's complete vocabulary record, and downstream ETL needs to see what was unmapped and how often it occurs.
- The canonical sheet keeps exactly these four columns even when a prior mapping was used — `mapping_source` lives in the review columns only, so the exchange format stays identical across sites. This sheet supersedes the site's prior mapping file and becomes the input for their next round.
- **Columns, in this exact order:** `<var>_category, <var>_name, n, site`
  - `<var>_category` — the mapped mCIDE category (or `no_match`)
  - `<var>_name` — the site's raw EHR string, exactly as it appears in their data
  - `n` — frequency of that raw string (carried through from the user's count column if the sheet has one; otherwise counted during dedup; 1 only for a deduplicated list with no counts)
  - `site` — the site short name if known, otherwise the literal `SITE`. This is a provenance label for pooling mapping files across the consortium; it never affects which category is chosen, so never hold up a mapping run waiting for it.
- **Sort:** by `<var>_category` ascending, then `n` descending.
- One row per unique raw value.

### Excel sheet-name length

Excel caps sheet names at 31 characters, which several CLIF table names exceed. Use these fixed abbreviations so names stay consistent across sites — do not invent your own:

| Table | Abbreviation |
|---|---|
| medication_admin_continuous | med_cont |
| medication_admin_intermittent | med_intermit |
| respiratory_support | resp_support |
| microbiology_culture | micro_cx |
| microbiology_nonculture | micro_noncx |
| microbiology_susceptibility | micro_susc |
| renal_replacement_therapy | rrt |
| patient_assessments | pt_assess |
| patient_attributes | pt_attr |
| patient_procedures | pt_proc |
| invasive_hemodynamics | invasive_hemo |
| clinical_notes_facts | notes_facts |
| misc_icu_orders | misc_orders |
| ed_encounter | ed_enc |

So `clif_vocab_medication_admin_continuous_med_UCMC` becomes the sheet `clif_vocab_med_cont_med_UCMC`. Always state the untruncated name in your report. If a name still exceeds 31 characters after abbreviation, drop the `clif_vocab_` prefix from the sheet name only, and say so.

### Worked example

Source column (`device_name`, with a count column) for site RUSH:

| device_name | → | device_category | device_name | n | site |
|---|---|---|---|---|---|
| Endotracheal Tube Ventilation | | imv | Endotracheal Tube Ventilation | 1204 | RUSH |
| BIPAP MASK | | nippv | BIPAP MASK | 233 | RUSH |
| RA | | room_air | RA | 98 | RUSH |
| DEVICE NOT DOCUMENTED | | no_match | DEVICE NOT DOCUMENTED | 12 | RUSH |

## CSV fallback

When the user is working with a plain CSV rather than an Excel workbook:

- Write the mapping as `clif_vocab_<table>_<variable>_<site>.csv` — the 31-character sheet-name limit does **not** apply, so use the full untruncated name.
- Write the review columns as `<original_filename>_mapped.csv`, where `<original_filename>` is the input file's name with its extension stripped (`raw_meds.csv` → `raw_meds_mapped.csv`). It contains the user's original columns plus the review columns (four, or five when `mapping_source` applies).
- Cell formatting (bold headers, yellow fill) is not possible in CSV — skip it and say so in your report, directing the user to filter on `needs_review = TRUE` instead.
