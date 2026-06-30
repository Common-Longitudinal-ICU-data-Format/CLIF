# mCIDE: minimum Common ICU Data Elements for CLIF

_To learn more about the CLIF mCIDE, explore the [About mCIDE](https://clif-icu.com/mCIDE) page on the [CLIF website](https://clif-icu.com/)._

Each subfolder contains mCIDE category files corresponding to the category variables in the respective v2.1 CLIF Beta tables:


  <details>
  <summary><code>adt/</code></summary>

  - hospital_type_category
  - location_category
  - location_type
  </details>

  <details>
  <summary><code>airway/</code></summary>

  - airway_category
  </details>

  <details>
  <summary><code>clinical_notes_facts/</code></summary>

  - note_type_category
  </details>

  <details>
  <summary><code>code_status/</code></summary>

  - code_status_category
  </details>

  <details>
  <summary><code>renal_replacement_therapy/</code></summary>

  - mode_category
  </details>

  <details>
  <summary><code>drain/</code></summary>

  - drain_category
  </details>

  <details>
  <summary><code>ed_encounter/</code></summary>

  - arrival_mode_category
  - triage_system_category
  - triage_acuity_category
  - ed_disposition_category
  - ed_destination_category
  </details>

  <details>
  <summary><code>mcs/</code></summary>

  - support_category
  - device_category
  - configuration_category
  - setting_category
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
  <summary><code>input/</code></summary>

  - input_category
  - input_group
  </details>

  <details>
  <summary><code>invasive_hemodynamics/</code></summary>

  - measurement_category
  </details>

  <details>
  <summary><code>consult_orders/</code></summary>

  - order_category
  - order_status_category
  </details>

  <details>
  <summary><code>misc_icu_orders/</code></summary>

  - order_category
  - order_status_category
  </details>

  <details>
  <summary><code>labs/</code></summary>

  - lab_category
  - lab_order_category
  - lab_specimen_category
  </details>

  <details>
  <summary><code>line/</code></summary>

  - line_category
  - line_site
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
  <summary><code>output/</code></summary>

  - output_category
  - output_group
  </details>

  <details>
  <summary><code>microbiology_culture/</code></summary>

  - fluid_category
  - method_category
  - organism_category
  - organism_group
  </details>

  <details>
  <summary><code>microbiology_nonculture/</code></summary>

  - fluid_category
  - method_category
  - organism_category
  - organism_group
  - result_category
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
  <summary><code>patient_attributes/</code></summary>

  - attribute_category
  - attribute_group
  - attribute_value_category
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
  <summary><code>radiology/</code></summary>

  - iv_contrast_category
  - radiology_location_category
  - radiology_modality_category
  - radiology_region_category
  </details>

  <details>
  <summary><code>respiratory_support/</code></summary>

  - device_category
  - mode_category
  </details>

  <details>
  <summary><code>transfusion/</code></summary>

  - component_category
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
