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
3. Concentration/formulation matters **only where the vocab actually splits on it**. The splits to know:
   - fluids: `albumin_5` vs `albumin_25`; `dextrose_5_water` / `dextrose_10_water` / `dextrose_50` / `dextrose_other`, and the carrier combos `dextrose_5_lactated_ringers`, `dextrose_5_sodium_chloride_0_9_pct`, `dextrose_10_sodium_chloride_0_45_pct`, etc. (`dextrose_other` is only for strengths with no row of their own, never for D5/D10 in a listed carrier)
   - sodium chloride by strength: `sodium_chloride_0_45_pct`, `_0_9_pct`, `_2_pct`, `_3_pct`, `_5_pct`, `_7_pct`, `_20_pct`, `_23_4_pct`, else `sodium_chloride_other` (e.g., 7.5%). Hypertonic saline raw names go here — there is no `hypertonic_saline_*` category any more.
   - sodium bicarbonate: continuous `sodium_bicarbonate_150_meq` (the standard 150 mEq/L drip, any carrier) vs `sodium_bicarbonate_other`; intermittent `sodium_bicarbonate_8_4_pct` for amps/pushes
   - insulin: continuous has only `insulin_regular`; intermittent splits by product (`insulin_regular`, `insulin_aspart`, `insulin_lispro`, `insulin_glulisine`, `insulin_glargine`, `insulin_detemir`, `insulin_degludec`, `insulin_nph`, premixed/other → `insulin_other`)
   - calcium, magnesium, phosphate, potassium: one category per salt (`calcium_chloride` vs `calcium_gluconate`, `potassium_chloride` vs `potassium_phosphate`, …); the `*_repletion` names are `med_group` labels, not categories
   - release formulation only where listed: `nifedipine_er` vs `nifedipine_ir`, `metoprolol_succinate` vs `metoprolol_tartrate`. `hydromorphone` is one category now (no `_er`/`_ir`)
   Extract the strength from the raw string; if the strength is absent and the vocab distinguishes on it, pick the best-supported row, set `needs_review = TRUE`, and say what evidence you used. Where the vocab has a single category for the drug, a missing concentration is not a problem and does not warrant a flag.
4. If the sheet has a dose-unit column, compare against the vocab's `med_dose_unit`. A mismatch (e.g., sheet says `units/hr` but the matched category expects `mcg`) sets `needs_review = TRUE` and gets a `mapping_note` naming both units. Which side is suspect determines the confidence:
   - If the raw drug name corroborates the vocab's unit (e.g., name says "HEPARIN 25000 UNITS" and the vocab expects units, but the sheet's unit column says `mcg`), the *sheet's unit column* is the suspect datum: keep the mapping confidence as-is and flag the row as a likely source-data unit error.
   - If nothing corroborates the mapping, downgrade confidence one level — a unit mismatch is often the clue that the wrong category, or the wrong table, was chosen. Recheck the mapping before flagging.
5. **Combination products** — the category description states the rule, and it is one of two:
   - *"Combination product: map to this single category; do not split"* — fixed-dose combos with their own row: `amoxicillin_clavulanate`, `ampicillin_sulbactam`, `buprenorphine_naloxone`, `ceftazidime_avibactam`, `ceftazidime_clavulanate`, `ceftolozane_tazobactam`, `imipenem_relebactam`, `meropenem_vaborbactam`, `nirmatrelvir_ritonavir`, `piperacillin_tazobactam`, `quinupristin_dalfopristin`, `sacubitril_valsartan`, `sulbactam_durlobactam`, `sulfadiazine_trimethoprim`, `ticarcillin_clavulanate`, `trimethoprim_sulfamethoxazole`. Map to that one category, `high`.
   - *"Combination products map to each component category"* — everything else (lisinopril-HCTZ, amlodipine-olmesartan, BiDil, Aggrenox, Synjardy, DuoNeb, Advair, Humalog 70/30 excepted → `insulin_other`). The raw name gets **one `clif_vocab` row per component**, each carrying the full `n`; the in-place review column lists the components joined with ` | `; `needs_review = TRUE` with note "combination product: split into N component rows; site must assign the per-component dose in ETL". Confidence is the weakest component's. Never pick a "primary" agent and drop the rest. See `output-format.md` for the exact layout.
   - Fluids with additives ("D5W with 20 mEq KCl", "LR + 2 g magnesium") follow the same fan-out: the base fluid row plus one row per additive agent, flagged.
6. **Cross-table pointers.** Several descriptions say where the other form of the same drug lives ("Pushes map to medication_admin_intermittent sodium_bicarbonate_8_4_pct"; "Continuous nebulization maps to medication_admin_continuous albuterol"; "Intermittent doses map to medication_admin_intermittent insulin_regular"). Quote that pointer in `mapping_note` when rule 1 sends a row to the other table, instead of working out the destination category yourself.
7. **Retired categories in a prior mapping.** The 2026-11 vocab retired 5 continuous and 39 intermittent categories (concentration splits, combos now fanned out, renames such as `pitocin` → `oxytocin`). `med-category-crosswalk.md` gives the replacement for each; apply it at layer 3 of the cascade and mark the row `prior_mapping_retired`.
