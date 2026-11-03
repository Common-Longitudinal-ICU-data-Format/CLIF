# Medication category crosswalk (2026-11 vocabulary update)

The November 2026 mCIDE update replaced both medication category files (continuous 77 → 95 rows, intermittent 336 → 417 rows), expanded `med_route_category` to 20 shared routes, and added a unified `med_group` roll-up. Forty-four categories were retired. Use this table when a site's prior mapping carries one of them: resolve to the replacement at layer 3 of the Step 3 cascade, mark the row `mapping_source = prior_mapping_retired`, `needs_review = TRUE`, and note both values.

Where the replacement depends on the raw name (strength, component), read the raw string — do not pick the first option. "Split" means the combination-product fan-out of `disambiguation.md` rule 5: one `clif_vocab` row per component.

## medication_admin_continuous

| Retired category | Current category | How to choose |
|---|---|---|
| `angiotensin` | `angiotensin_ii` | rename |
| `insulin` | `insulin_regular` | rename (only insulin infusion category) |
| `pitocin` | `oxytocin` | brand → generic |
| `sodium_bicarbonate` | `sodium_bicarbonate_150_meq` or `sodium_bicarbonate_other` | 150 mEq/L drip (150 mEq in 1 L D5W, sterile water, or 1/2NS) → `_150_meq`; any other concentration → `_other`; strength absent → `_150_meq`, flag |
| `sodium_chloride` | `sodium_chloride_0_9_pct`, `_0_45_pct`, `_2_pct`, `_3_pct`, `_5_pct`, `_7_pct`, `_20_pct`, `_23_4_pct`, or `sodium_chloride_other` | by strength in the raw name; "normal saline"/"NS" → `_0_9_pct`; "1/2NS" → `_0_45_pct`; unlisted strength (7.5%, 1.5%) → `_other`; strength absent → flag |

Unit changes on surviving categories (recheck any prior mapping that cross-checked units): `epoprostenol` is now `ng/kg/min` (was `mcg/kg/min`); `terbutaline` is now `mcg/kg/min` (was `mg`).

## medication_admin_intermittent

### Renames and merges

| Retired category | Current category | How to choose |
|---|---|---|
| `hydromorphone_er`, `hydromorphone_ir` | `hydromorphone` | merged |
| `isavuconazonium` | `isavuconazole` | prodrug → active drug; the description notes the 372 mg : 200 mg dose relationship |
| `micafungin_posaconazole_voriconazole` | `micafungin`, `posaconazole`, or `voriconazole` | by the drug actually named; it was never a real combination |
| `hypertonic_saline_3` | `sodium_chloride_3_pct` | |
| `hypertonic_saline_5` | `sodium_chloride_5_pct` | |
| `hypertonic_saline_7` | `sodium_chloride_7_pct` | |
| `hypertonic_saline_7.5` | `sodium_chloride_other` | 7.5% has no row of its own |
| `hypertonic_saline_20` | `sodium_chloride_20_pct` | |
| `hypertonic_saline_23.4` | `sodium_chloride_23_4_pct` | |

### Combination categories now split into components

| Retired category | Split into |
|---|---|
| `amlodipine_olmesartan` | `amlodipine` + `olmesartan` |
| `azilsartan_chlorthalidone` | `azilsartan` + `chlorthalidone` |
| `benazepril_amlodipine` | `benazepril` + `amlodipine` |
| `benazepril_hctz` | `benazepril` + `hydrochlorothiazide` |
| `bisoprolol_hctz` | `bisoprolol` + `hydrochlorothiazide` |
| `candesartan_hctz` | `candesartan` + `hydrochlorothiazide` |
| `enalapril_hctz` | `enalapril` + `hydrochlorothiazide` |
| `fosinopril_hctz` | `fosinopril` + `hydrochlorothiazide` |
| `hydralazine_isosorbide` | `hydralazine` + `isosorbide_dinitrate` |
| `irbesartan_hctz` | `irbesartan` + `hydrochlorothiazide` |
| `lisinopril_hctz` | `lisinopril` + `hydrochlorothiazide` |
| `losartan_hctz` | `losartan` + `hydrochlorothiazide` |
| `metoprolol_succinate_hctz` | `metoprolol_succinate` + `hydrochlorothiazide` |
| `metoprolol_tartrate_hctz` | `metoprolol_tartrate` + `hydrochlorothiazide` |
| `olmesartan_hctz` | `olmesartan` + `hydrochlorothiazide` |
| `perindopril_amlodipine` | `perindopril` + `amlodipine` |
| `ramipril_amlodipine` | `ramipril` + `amlodipine` |
| `spironolactone_hctz` | `spironolactone` + `hydrochlorothiazide` |
| `telmisartan_amlodipine` | `telmisartan` + `amlodipine` |
| `telmisartan_hctz` | `telmisartan` + `hydrochlorothiazide` |
| `triamterene_hctz` | `triamterene` + `hydrochlorothiazide` |
| `valsartan_amlodipine` | `valsartan` + `amlodipine` |
| `valsartan_hctz` | `valsartan` + `hydrochlorothiazide` |
| `dipyridamole_aspirin` | `dipyridamole` + `aspirin` |
| `canagliflozin_metformin` | `canagliflozin` + `metformin` |
| `dapagliflozin_metformin` | `dapagliflozin` + `metformin` |
| `dapagliflozin_saxagliptin` | `dapagliflozin` + `saxagliptin` |
| `empagliflozin_linagliptin` | `empagliflozin` + `linagliptin` |
| `empagliflozin_metformin` | `empagliflozin` + `metformin` |

## med_group renames

`med_group` is not a mapping target, so prior mapping files are unaffected. For anyone comparing old and new group labels: `anti_hypertensive` → `antihypertensive`, `cardiac_glycoside` → `antiarrhythmic`, `contrast_agent` → `contrast`, `diabetes` → `endocrine`, `diuretics` → `diuretic`, `others` → `other`, `paralytics` → `paralytic`, `pulmonary_vasodilators_iv` and `pulmonary_vasodilators_inhaled` → `pulmonary_vasodilator`, `vasoactives` and `vasopressor` → `vasoactive`, `inhaled` → `respiratory`, `anxiolytic` → `sedation`, `cardiac` → split across `antiarrhythmic` / `antihypertensive` / `vasoactive`.
