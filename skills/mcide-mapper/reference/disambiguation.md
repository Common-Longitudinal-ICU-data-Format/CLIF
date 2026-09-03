# Disambiguation Rules

Rules for the two highest-risk vocabularies. Apply these on top of the general workflow.

## Labs (`labs/clif_lab_categories.csv`)

`lab_category` is **not unique**. The same analyte appears in multiple rows distinguished by specimen and unit, e.g.:

| lab_category | reference_unit | lab_specimen_category |
|---|---|---|
| albumin | g/dl | plasma_blood/peritoneal/pleural |
| albumin | mg/dl | urine |

Rules:

1. Identify the specimen for each raw lab name. Evidence, in priority order:
   - a specimen column in the user's sheet
   - specimen words embedded in the raw name itself ("URINE ALBUMIN", "PLEURAL FLUID LDH", "CSF GLUCOSE")
   - a result-unit column matched against `reference_unit`
2. Pick the vocab row whose `lab_specimen_category` matches the identified specimen. The mapped value is still just `lab_category`, but record the resolved specimen in `mapping_note` (e.g., "resolved to urine albumin, mg/dl").
3. If the analyte is specimen-ambiguous in the vocab AND no specimen evidence exists, still map the category but set `needs_review = TRUE` with note "specimen ambiguous — verify against source data". If the entire sheet lacks specimen/unit columns, say so explicitly in the final report.
4. A unit that contradicts every vocab row for that analyte → downgrade confidence one level and flag.
5. `lab_order_category` and `lab_specimen_category` cells are **slash-delimited** when the analyte is valid for more than one panel or specimen (`bmp/poc`, `plasma_blood/peritoneal/pleural`). The list is what the analyte *permits*, not what a given result *is* — resolve to exactly one value per row, never fan a raw name out across the list. Point-of-care is carried by `lab_order_category = poc`, not by a separate `lab_category`: a potassium off a BMP is `potassium` + `bmp`, a POC/iSTAT potassium is `potassium` + `poc`. Commas inside `lab_name_type_examples` and `notes` are not delimiters.

## Medications (continuous and intermittent med categories)

The vocab lists the expected dose unit per category (`med_dose_unit`, and `volume_infusion_rate_units` for continuous infusions).

Rules:

1. **Continuous vs intermittent is a table-level decision, not per-row.** If the user's list mixes infusions and scheduled/PRN meds:
   - If only a handful of rows (roughly <10%) look misplaced, map against the table the user named, set those rows to `no_match`, `needs_review = TRUE`, and note the reason plus the category they would map to in the other table (e.g., "PO/PRN administration — belongs in medication_admin_intermittent, where it maps to acetaminophen").
   - If a substantial share of the list belongs to the other table, stop and ask the user whether to split the list into two mapping passes. If no user is available to ask, map against the table they named, flag every misplaced row, and lead the report with the recommendation to split.
2. Brand→generic matches are expected and legitimate (`medium` confidence): Levophed → norepinephrine, Precedex → dexmedetomidine, Nimbex → cisatracurium, Cardene → nicardipine, Neo-Synephrine → phenylephrine, etc.
3. Concentration/formulation matters **only where the vocab actually splits on it** — e.g., `albumin_5` vs `albumin_25`, `dextrose_5_water` vs `dextrose_10_water`. Extract the strength from the raw string; if the strength is absent and the vocab distinguishes on it, pick the best-supported row, set `needs_review = TRUE`, and say what evidence you used. Where the vocab has a single category for the drug (e.g., insulin), a missing concentration is not a problem and does not warrant a flag.
4. If the sheet has a dose-unit column, compare against the vocab's `med_dose_unit`. A mismatch (e.g., sheet says `units/hr` but the matched category expects `mcg`) sets `needs_review = TRUE` and gets a `mapping_note` naming both units. Which side is suspect determines the confidence:
   - If the raw drug name corroborates the vocab's unit (e.g., name says "HEPARIN 25000 UNITS" and the vocab expects units, but the sheet's unit column says `mcg`), the *sheet's unit column* is the suspect datum: keep the mapping confidence as-is and flag the row as a likely source-data unit error.
   - If nothing corroborates the mapping, downgrade confidence one level — a unit mismatch is often the clue that the wrong category, or the wrong table, was chosen. Recheck the mapping before flagging.
5. Combination products and fluids with additives (e.g., "D5W with 20 mEq KCl") map to the primary agent when the vocab has no combination category; note the additive and flag for review.
