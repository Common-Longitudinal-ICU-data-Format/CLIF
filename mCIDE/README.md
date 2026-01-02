# mCIDE: minimum Common ICU Data Elements for CLIF

_To learn more about the CLIF mCIDE, explore the [About mCIDE](https://clif-icu.com/mCIDE) page on the [CLIF website](https://clif-icu.com/)._

Each subfolder contains mCIDE category files corresponding to the category variables in the respective v2.1 CLIF Beta tables:


  <details>
  <summary><code>adt/</code></summary>

  - hospital_type
  - location_category
  - location_type
  </details>

  <details>
  <summary><code>code_status/</code></summary>

  - code_status_category
  </details>

  <details>
  <summary><code>crrt_therapy/</code></summary>

  - crrt_mode_category
  </details>

  <details>
  <summary><code>hospitalization/</code></summary>

  - admission_type_category
  - discharge_category
  </details>

  <details>
  <summary><code>hospital_diagnosis/</code></summary>

  - NA
  </details>

  <details>
  <summary><code>labs/</code></summary>

  - lab_category
  - lab_order_category
  </details>

  <details>
  <summary><code>medication_admin_continuous/</code></summary>

  - med_category
  - med_route_category
  - mar_action_category
  - mar_action_group
  </details>

  <details>
  <summary><code>medication_admin_intermittent/</code></summary>

  - med_category
  - med_route_category
  - mar_action_category
  - mar_action_group
  </details>

  <details>
  <summary><code>microbiology_culture/</code></summary>

  - fluid_category
  - method_category
  - organism_category
  - organism_group
  </details>

  <details>
  <summary><code>microbiology_susceptibility/</code></summary>

  - antimicrobial_category
  - susceptibility_category
  </details>

  <details>
  <summary><code>patient/</code></summary>

  - race_category
  - ethnicity_category
  - sex_category
  - language_category
  </details>

  <details>
  <summary><code>patient_assessments/</code></summary>

  - assessment_category
  </details>

  <details>
  <summary><code>patient_procedures/</code></summary>

  - procedure_code_format
  - procedure_code
  - proc_name
  </details>

  <details>
  <summary><code>position/</code></summary>

  - position_category
  </details>

  <details>
  <summary><code>respiratory_support/</code></summary>

  - device_category
  - mode_category
  </details>

  <details>
  <summary><code>vitals/</code></summary>

  - vital_category
  </details>



## Standardized Format
All CSV files in the mCIDE folder have been standardized to follow a consistent documentation format as specified in issue requirements. mCIDE CSV files now follow this structure:

| Column | Name | Description |
|--------|------|-------------|
| 1 | `<variable>_category` | Level of category variable (e.g., "start", "stop", "going") |
| 2 | `description` | Short description of the clinical category being defined |
| 3 | `<variable>_name_examples` | Up to 3 representative `<variable>_name` values that map to this category |
| 4 | `<variable>_group` (optional) | Group classification if defined for this variable |
