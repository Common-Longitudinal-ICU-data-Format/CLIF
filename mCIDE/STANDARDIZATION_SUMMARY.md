# mCIDE CSV Standardization Summary

## Overview
All CSV files in the mCIDE folder have been standardized to follow a consistent documentation format as specified in issue requirements.

## Standardized Format

All mCIDE CSV files now follow this structure:

| Column | Name | Description |
|--------|------|-------------|
| 1 | `<variable>_category` | Level of category variable (e.g., "start", "stop", "going") |
| 2 | `description` | Short description of the clinical category being defined |
| 3 | `<variable>_name_examples` | Up to 5 representative `<variable>_name` values that map to this category (currently empty, to be populated by individual sites) |
| 4 | `<variable>_group` (optional) | Group classification if defined for this variable |

### Example: Medication Action Categories
```csv
mar_action_category,description,mar_action_name_examples
dose_change,dose change for a continuous medication,
going,ongoing administration of a continuous medication (e.g. a bag change),
start,starting a continuous medication,
stop,stopping a continuous medication,
```

### Example with Group Column: ECMO Device Categories
```csv
device_category,description,device_name_examples,device_group
Impella_2.5,,,temporary_LVAD
Impella_CP,,,temporary_LVAD
Impella_5.0,,,temporary_LVAD
```

## Changes Applied

### All Files (37 total)
- ✅ Standardized column names to consistent format
- ✅ Added `<variable>_name_examples` column to all files (currently empty)
- ✅ Ensured `description` column exists in all files
- ✅ Removed BOM (Byte Order Mark) characters from affected files
- ✅ Removed extraneous columns (e.g., "Note", "added/modified", "comments")
- ✅ Cleaned up inconsistent naming (e.g., "Description and Examples" → "description")

### Files with Group Column (5 files)
1. `ecmo/clif_ecmo_mcs_groups.csv` - device_group
2. `medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv` - med_group
3. `medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv` - med_group
4. `microbiology_nonculture/clif_microbiology_nonculture_organism_category.csv` - organism_group
5. `patient_assessments/clif_patient_assessment_categories.csv` - assessment_group

## Statistics
- **Total files standardized**: 37
- **Total category rows**: 1,543
- **Files with group column**: 5
- **Files without group column**: 32

## Next Steps for Sites

Individual sites should populate the `<variable>_name_examples` column with representative examples from their EHR systems. These examples help document how local EHR values map to the standardized CLIF categories.

### How to Populate Examples
1. Use the CIDE mapping generator tools to create site-specific mappings
2. Select up to 5 representative examples for each category
3. Add these examples to the appropriate `<variable>_name_examples` column
4. Examples should illustrate the variety of source values that map to each category

### Example of Populated Data
Based on site-specific mapping files, the `mar_action_name_examples` column might contain:
```csv
mar_action_category,description,mar_action_name_examples
start,starting a continuous medication,"restarted, started, started during downtime, mar unhold, begin"
```

## Files Affected

### ADT
- clif_adt_hospital_type.csv
- clif_adt_location_categories.csv
- clif_adt_location_type.csv

### Code Status
- clif_code_status_categories.csv

### CRRT Therapy
- clif_crrt_therapy_mode_categories.csv

### ECMO
- clif_ecmo_mcs_groups.csv

### Hospitalization
- clif_hospitalization_admission_type_categories.csv
- clif_hospitalization_discharge_categories.csv

### Invasive Hemodynamics
- clif_invasive_hemodynamics_measure_categories.csv

### Key ICU Orders
- clif_key_icu_orders_categories.csv

### Labs
- clif_lab_categories.csv
- clif_labs_order_categories.csv

### Medication Administration (Continuous)
- clif_medication_admin_continuous_action_categories.csv
- clif_medication_admin_continuous_med_categories.csv
- clif_medication_admin_continuous_med_route_categories.csv

### Medication Administration (Intermittent)
- clif_medication_admin_intermittent_action_categories.csv
- clif_medication_admin_intermittent_med_categories.csv
- clif_medication_admin_intermittent_med_route_categories.csv

### Microbiology (Culture)
- clif_microbiology_culture_fluid_category.csv
- clif_microbiology_culture_method_categories.csv
- clif_microbiology_culture_organism_categories.csv
- clif_microbiology_culture_organism_groups.csv

### Microbiology (Non-Culture)
- clif_microbiology_nonculture_fluid_category.csv
- clif_microbiology_nonculture_method_category.csv
- clif_microbiology_nonculture_organism_category.csv
- clif_microbiology_nonculture_result_category.csv

### Microbiology (Susceptibility)
- clif_microbiology_susceptibility_antibiotics_category.csv
- clif_microbiology_susceptibility_category.csv

### Patient
- clif_patient_ethinicity_categories.csv
- clif_patient_language_categories.csv
- clif_patient_race_categories.csv
- clif_patient_sex_categories.csv

### Patient Assessments
- clif_patient_assessment_categories.csv

### Position
- clif_position_categories.csv

### Respiratory Support
- clif_respiratory_support_device_categories.csv
- clif_respiratory_support_mode_categories.csv

### Vitals
- clif_vitals_categories.csv

## References
- Original issue: [Improving consistency of mCIDE documentation]
- CLIF mCIDE folder: https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/tree/main/mCIDE
- Example mapping files: mCIDE/00_mCIDE_mapping_examples/
