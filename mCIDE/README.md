# mCIDE: minimum Common ICU Data Elements for CLIF

The CLIF format and federated research approach aspires to adhere to the [2023 NIH Data Management and Sharing Policy](https://sharing.nih.gov/data-management-and-sharing-policy/about-data-management-and-sharing-policies/data-management-and-sharing-policy-overview#after) and the [FAIR (Findable Accessible Interoperable Resuable) data principles](https://www.go-fair.org/fair-principles/).

Common Data Element (CDEs) "are data elements (or variables) that are defined and used the same way across multiple studies, to standardize the way data is collected"

We have constructed a minimum set of Common ICU Data Elements (mCIDE) with following features:

1.  represents a precisely defined clinical entity
2.  limited set of permissible values

`*_category` variables are CIDEs. For more details, explore the [CLIF Website](https://clif-consortium.github.io/website/mCIDE.html).

### Reference Materials
- **`00_mCIDE_mapping_examples/`** - Example mapping files for different institutions
- **`01_archives/`** - Archived vocabulary files and legacy mappings 

Each subfolder contains mCIDE category files corresponding to the category variables in the respective CLIF table:

- **`adt/`** 
    - hospital_type
    - location_category
    - location_type
- **`code_status/`**  
    - code_status_category
- **`crrt_therapy/`** 
    - crrt_mode_category
- **`ecmo/`** 
    - device_category
- **`hospitalization/`** 
    - admission_type_category
    - discharge_category
- **`invasive_hemodynamics/`** 
    - measure_category
- **`key_icu_orders/`** 
    - order_category
- **`labs/`** 
    - lab_category
- **`medication_admin_continuous/`** 
    - med_category
    - med_route_category (under-development)
    - mar_action_category (under-development)
- **`medication_admin_intermittent/`** 
    - med_category
    - med_route_category (under-development)
    - mar_action_category (under-development)
- **`microbiology_culture/`** 
    - fluid_category
    - method_category
    - organism_category
    - organism_group
- **`microbiology_nonculture/`** 
     (under-development)
- **`patient/`**
    - race_category
    - ethnicity_category
    - sex_category
    - language_category
- **`patient_assessments/`** 
    - assessment_category
- **`postion/`** 
    - Position_category
- **`respiratory_support/`** 
    - device_category
    - mode_category
- **`vitals/`** 
    - vital_category


