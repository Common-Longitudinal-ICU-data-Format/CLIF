# labs mCIDE

Three files define the labs vocabulary:

| File | Defines |
|------|---------|
| `clif_lab_categories.csv` | `lab_category` — the analyte, plus its CLIF `reference_unit` |
| `clif_labs_order_categories.csv` | `lab_order_category` — the panel or ordering context |
| `clif_lab_specimen_categories.csv` | `lab_specimen_category` — the fluid or tissue analyzed |

## Grain of `clif_lab_categories.csv`

**One row per `lab_category` + `reference_unit`** — 112 rows covering 106 analytes. A few
analytes appear twice because the same name is reported in different units depending on the
specimen (`albumin` is `g/dl` in blood and fluid, `mg/dl` in urine).


## How to ETL a multi-value cell

**Emit exactly one CLIF row per lab result, choosing the single applicable value from each
list.** 

### Point-of-care example

POC and central-lab measurements of the same analyte can differ in analytic accuracy, and
some studies will want to hold them apart. CLIF keeps them separable **without** a separate
`lab_category`: the panel lives in `lab_order_category`.

The `potassium` row permits `bmp/poc`, so a site resolves each result to one of them:

| Source result | `lab_category` | `lab_order_category` | `lab_specimen_category` |
|---|---|---|---|
| Potassium resulted off a BMP | `potassium` | `bmp` | `plasma_blood` |
| POC / iSTAT potassium | `potassium` | `poc` | `plasma_blood` |

Both are one row each. A study that wants only central-lab chemistry filters on
`lab_order_category = bmp`; a study that wants every potassium ignores the column and gets
both. 

### Body-fluid example

For fluid panels the analyte name stays bare in `lab_category` and the fluid is carried by
`lab_specimen_category`. The `albumin` row permits
`lft/peritoneal_fluid_panel/pleural_fluid_panel` and `plasma_blood/peritoneal/pleural`:

| Source result | `lab_category` | `lab_order_category` | `lab_specimen_category` |
|---|---|---|---|
| Serum albumin on an LFT panel | `albumin` | `lft` | `plasma_blood` |
| Ascites albumin | `albumin` | `peritoneal_fluid_panel` | `peritoneal` |
| Pleural fluid albumin | `albumin` | `pleural_fluid_panel` | `pleural` |

Pick the panel and the specimen that actually produced the result; do not emit all three.

## Reference units

Every value loaded into `labs.lab_value` must already be converted to the analyte's CLIF
`reference_unit`. Only the listed unit is permissible for that `lab_category` — see the
`reference_unit` column here and the ETL guide at
<https://clif-icu.com/etl-guide/etl-guide-3.0.0>.
