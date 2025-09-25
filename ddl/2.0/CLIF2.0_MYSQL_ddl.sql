
-- -----------------------------------------------------
-- Table: adt
-- -----------------------------------------------------
CREATE TABLE adt (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  hospital_id VARCHAR COMMENT '{"description": "Assign a unique ID to each hospital within a healthsystem", "permissible": "No restriction"}',
  hospital_type VARCHAR COMMENT '{"description": "Maps *`hospital_id`* to a standardized list of hospital types", "permissible": "[academic, community](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/adt/clif_adt_hospital_type.csv)"}',
  in_dttm DATETIME COMMENT '{"description": "Start date and time at a particular location. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  out_dttm DATETIME COMMENT '{"description": "End date and time at a particular location. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  location_name VARCHAR COMMENT '{"description": "Location of the patient inside the hospital. This field is used to store the patient location from the source data. It is not used for analysis.", "permissible": "No restriction"}',
  location_category VARCHAR COMMENT '{"description": "Maps location_name to a standardized list of ADT location categories", "permissible": "[ed, ward, stepdown, icu, procedural, l&d, hospice, psych, rehab, radiology, dialysis, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/adt/clif_adt_location_categories.csv)"}'
);

-- -----------------------------------------------------
-- Table: code_status
-- -----------------------------------------------------
CREATE TABLE code_status(
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  start_dttm DATETIME COMMENT '{"description": "The date and time when the specific code status was initiated", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  code_status_name VARCHAR COMMENT '{"description": "The name/description of the code status", "permissible": "No restriction"}',
  code_status_category VARCHAR COMMENT '{"description": "Categorical variable specifying the code status during the hospitalization", "permissible": "[DNR, DNAR, UDNR, DNR/DNI, DNAR/DNI, AND, Full, Presume Full, Other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/tree/main/mCIDE/code_status/clif_code_status_categories.csv)"}',
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- -----------------------------------------------------
-- Table: crrt_therapy
-- -----------------------------------------------------
CREATE TABLE crrt_therapy (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  device_id VARCHAR COMMENT '{"description": "Unique identifier for dialysis machine", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Timestamp when CRRT parameters were recorded", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  crrt_mode_name VARCHAR COMMENT '{"description": "Name of CRRT mode (e.g., CVVHDF)", "permissible": "No restriction"}',
  crrt_mode_category VARCHAR COMMENT '{"description": "Standardized CRRT mode categories", "permissible": "[scuf, cvvh, cvvhd, cvvhdf, avvh](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/crrt_therapy/clif_crrt_therapy_mode_categories.csv)"}',
  dialysis_machine_name VARCHAR COMMENT '{"description": "Brand name for the dialysis machine", "permissible": "No restriction"}',
  blood_flow_rate FLOAT COMMENT '{"description": "Rate of blood flow through the CRRT circuit (mL/min)", "permissible": "[150-350](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  pre_filter_replacement_fluid_rate FLOAT COMMENT '{"description": "Rate of pre-filter replacement fluid infusion (mL/hr)", "permissible": "[0-10000](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  post_filter_replacement_fluid_rate FLOAT COMMENT '{"description": "Rate of post-filter replacement fluid infusion (mL/hr)", "permissible": "[0-10000](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  dialysate_flow_rate FLOAT COMMENT '{"description": "Flow rate of dialysate solution (mL/hr)", "permissible": "[0-10000](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  ultrafiltration_out FLOAT COMMENT '{"description": "Net ultrafiltration output (mL/hr)", "permissible": "[0-500](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}'
);

-- -----------------------------------------------------
-- Table: ecmo_mcs
-- -----------------------------------------------------
CREATE TABLE ecmo_mcs (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the device settings and/or measurement was recorded", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  device_name VARCHAR COMMENT '{"description": "Name of the ECMO/MCS device used including brand information, e.g. Centrimag", "permissible": "No restriction"}',
  device_category VARCHAR COMMENT '{"description": "Maps device_name to a standardized mCIDE", "permissible": "[List of device categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/ecmo/clif_ecmo_mcs_groups.csv)"}',
  mcs_group VARCHAR COMMENT '{"description": "Maps device_category to a standardized mCIDE of MCS types", "permissible": "[List of MCS groups in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/ecmo/clif_ecmo_mcs_groups.csv)"}',
  device_metric_name VARCHAR COMMENT '{"description": "String that captures the measure of work rate of the device, e.g., RPMs", "permissible": "No restriction"}',
  device_rate FLOAT COMMENT '{"description": "Numeric value of work rate, e.g., 3000 RPMs", "permissible": "Numeric values"}',
  sweep FLOAT COMMENT '{"description": "Gas flow rate in L/min", "permissible": "Numeric values in L/min"}',
  flow FLOAT COMMENT '{"description": "Blood flow in L/min", "permissible": "Numeric values in L/min"}',
  fdO2 FLOAT COMMENT '{"description": "Fraction of delivered oxygen", "permissible": "Numeric values (0-1)"}'
);

-- -----------------------------------------------------
-- Table: hospitalization
-- -----------------------------------------------------
CREATE TABLE hospitalization (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  hospitalization_joined_id VARCHAR COMMENT '{"description": "Unique identifier for each continuous inpatient stay in a health system which may span different hospitals (Optional)", "permissible": "No restriction"}',
  admission_dttm DATETIME COMMENT '{"description": "Date and time the patient is admitted to the hospital. All datetime variables must be timezone-aware and set to UTC", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  discharge_dttm DATETIME COMMENT '{"description": "Date and time the patient is discharged from the hospital. All datetime variables must be timezone-aware and set to UTC", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  age_at_admission INT COMMENT '{"description": "Age of the patient at the time of admission, in years", "permissible": "No restriction"}',
  admission_type_name VARCHAR COMMENT '{"description": "Type of inpatient admission. Original string from the source data", "permissible": "e.g. Direct admission, Transfer, Pre-op surgical"}',
  admission_type_category VARCHAR COMMENT '{"description": "Admission disposition mapped to mCIDE categories", "permissible": "[List of admission type categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/hospitalization/clif_hospitalization_admission_type_categories.csv)"}',
  discharge_name VARCHAR COMMENT '{"description": "Original discharge disposition name string recorded in the raw data", "permissible": "No restriction, e.g. home"}',
  discharge_category VARCHAR COMMENT '{"description": "Maps discharge_name to a standardized list of discharge categories", "permissible": "[Home, Skilled Nursing Facility (SNF), Expired, Acute Inpatient Rehab Facility, Hospice, Long Term Care Hospital (LTACH), Acute Care Hospital, Group Home, Chemical Dependency, Against Medical Advice (AMA), Assisted Living, Still Admitted, Missing, Other, Psychiatric Hospital, Shelter, Jail](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/hospitalization/clif_hospitalization_discharge_categories.csv)"}',
  zipcode_nine_digit VARCHAR COMMENT '{"description": "Patient 9 digit zip code, used to link with other indices such as ADI and SVI", "permissible": "No restriction"}',
  zipcode_five_digit VARCHAR COMMENT '{"description": "Patient 5 digit zip code, used to link with other indices such as ADI and SVI", "permissible": "No restriction"}',
  census_block_code VARCHAR COMMENT '{"description": "[15 digit FIPS code](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)", "permissible": "No restriction"}',
  census_block_group_code VARCHAR COMMENT '{"description": "[12 digit FIPS code](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)", "permissible": "No restriction"}',
  census_tract VARCHAR COMMENT '{"description": "[Full 11 digit FIPS code](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html). Eg. 13089022404 `census_tract` is the state (13) + the county (089) + the census tract (022404).", "permissible": "No restriction"}',
  state_code VARCHAR COMMENT '{"description": "[2 digit FIPS code](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html)", "permissible": "No restriction"}',
  county_code VARCHAR COMMENT '{"description": "[Full 5 digit FIPS code](https://www.census.gov/programs-surveys/geography/guidance/geo-identifiers.html). Eg. 13089 `county_code` is the state (13) + the county (089).", "permissible": "No restriction"}',
  fips_version VARCHAR COMMENT '{"description": "Year of the Census geography definitions used for the FIPS codes (e.g., 2010, 2020), indicating the tract and boundary set in effect at that time", "permissible": "2000,2010, 2020"}',
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- -----------------------------------------------------
-- Table: hospital_diagnosis
-- -----------------------------------------------------
CREATE TABLE hospital_diagnosis (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "Must match a hospitalization_id in the hospitalization table"}',
  diagnosis_code VARCHAR COMMENT '{"description": "ICD diagnosis code", "permissible": "Valid ICD-9-CM or ICD-10-CM code"}',
  diagnosis_code_format VARCHAR COMMENT '{"description": "Format of the code", "permissible": "ICD10CM or ICD9CM"}',
  diagnosis_primary INT COMMENT '{"description": "Type of diagnosis: 1 = primary, 0 = secondary. If diagnoses are ranked, any rank of 2 or above is considered secondary.", "permissible": "0, 1"}',
  poa_present INT COMMENT '{"description": "Indicator if the diagnosis was present on admission. Only two options are allowed: 1 = Yes (present on admission), 0 = No (not present on admission). No other values (such as Exempt, Unknown, or Unspecified) are permitted.", "permissible": "0, 1"}'
);


-- -----------------------------------------------------
-- Table: labs
-- -----------------------------------------------------
CREATE TABLE labs (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  lab_order_dttm DATETIME COMMENT '{"description": "Date and time when the lab is ordered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  lab_collect_dttm DATETIME COMMENT '{"description": "Date and time when the specimen is collected. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  lab_result_dttm DATETIME COMMENT '{"description": "Date and time when the lab results are available. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  lab_order_name VARCHAR COMMENT '{"description": "Procedure name for the lab, e.g. \"Complete blood count w/ diff\"", "permissible": "No restriction"}',
  lab_order_category VARCHAR COMMENT '{"description": "Maps lab_order_name to standardized list of common lab order names, e.g. \"CBC\"", "permissible": "[List of lab order categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/labs/clif_labs_order_categories.csv)"}',
  lab_name VARCHAR COMMENT '{"description": "Original lab component as recorded in the raw data, e.g. \"AST (SGOT)\".", "permissible": "No restriction"}',
  lab_category VARCHAR COMMENT '{"description": "Maps lab_name to a minimum set of standardized labs identified by the CLIF consortium as minimum necessary labs for the study of critical illness.", "permissible": "[List of lab categories in CLIF](https://github.com/clif-consortium/CLIF/blob/main/mCIDE/labs/clif_lab_categories.csv)"}',
  lab_value VARCHAR COMMENT '{"description": "Recorded value corresponding to a lab. Lab values are often strings that can contain non-numeric results (e.g. \"> upper limit of detection\").", "permissible": "No restriction"}',
  lab_value_numeric DOUBLE COMMENT '{"description": "Parse out numeric part of the lab_value variable (optional).", "permissible": "Numeric"}',
  reference_unit VARCHAR COMMENT '{"description": "Unit of measurement for that lab.", "permissible": "Permissible reference values for each lab_category listed [here](https://github.com/clif-consortium/CLIF/blob/main/mCIDE/labs/clif_lab_categories.csv)"}',
  lab_specimen_name VARCHAR COMMENT '{"description": "Original fluid or tissue name the lab was collected from as given in the source data", "permissible": "No restriction"}',
  lab_specimen_category VARCHAR COMMENT '{"description": "Fluid or tissue the lab was collected from, analogous to the LOINC \"system\" component.", "permissible": "working CDE c(blood/plasma/serum, urine, csf, other)"}',
  lab_loinc_code VARCHAR COMMENT '{"description": "[LOINC](https://loinc.org/get-started/loinc-term-basics/) code for the lab", "permissible": "No restrictions"}'
);

-- -----------------------------------------------------
-- Table: medication-admin-continuous
-- -----------------------------------------------------
CREATE TABLE medication_admin_continuous (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  med_order_id VARCHAR COMMENT '{"description": "Medication order ID. Foreign key to link this table to other medication tables", "permissible": "No restriction"}',
  admin_dttm DATETIME COMMENT '{"description": "Date and time when the medicine was administered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  med_name VARCHAR COMMENT '{"description": "Original med name string recorded in the raw data which often contains concentration e.g. NOREPInephrine 8 mg/250 mL", "permissible": "No restriction"}',
  med_category VARCHAR COMMENT '{"description": "Maps med_name to a limited set of active ingredients for important ICU medications, e.g. norepinephrine", "permissible": "[List of continuous medication categories in CLIF](https://github.com/clif-consortium/CLIF/blob/main/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv) "}',
  med_group VARCHAR COMMENT '{"description": "Limited number of ICU medication groups identified by the CLIF consortium, e.g. vasoactives", "permissible": "[List of continuous medication groups in CLIF](https://github.com/clif-consortium/CLIF/blob/main/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv)   "}',
  med_route_name VARCHAR COMMENT '{"description": "Medicine delivery route", "permissible": "e.g. IV, enteral"}',
  med_route_category VARCHAR COMMENT '{"description": "Maps med_route_name to a standardized list of medication delivery routes. Refer to notes.", "permissible": "[List of continuous route categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_route_categories.csv)"}',
  med_dose FLOAT COMMENT '{"description": "Quantity taken in dose", "permissible": "Numeric"}',
  med_dose_unit VARCHAR COMMENT '{"description": "Unit of dose. It must be a rate, e.g. mcg/min. Boluses should be mapped to med_admin_intermittent", "permissible": "No restriction"}',
  mar_action_name VARCHAR COMMENT '{"description": "MAR (medication administration record) action, e.g. stopped", "permissible": "No restriction"}',
  mar_action_category VARCHAR COMMENT '{"description": "Maps mar_action_name to a standardized list of MAR actions", "permissible": "Under-development"}'
);


-- -----------------------------------------------------
-- Table: microbiology-culture
-- -----------------------------------------------------
CREATE TABLE microbiology_culture (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  organism_id VARCHAR COMMENT '{"description": "Distinct numerical identifier that each site creates which links a unique, non-missing organism_category that has a distinct patient_id, hospitalization_id, lab_order_dttm, lab_collect_dttm, lab_result_dttm, and fluid_category with its method_category == culture from the microbiology_culture table to an antibiotic_category and susceptibility_category from the microbiology_susceptibility table", "permissible": "No restriction"}',
  order_dttm DATETIME COMMENT '{"description": "Date and time when the test is ordered.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  collect_dttm DATETIME COMMENT '{"description": "Date and time when the specimen is collected.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  result_dttm DATETIME COMMENT '{"description": "Date and time when the results are available.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  fluid_name VARCHAR COMMENT '{"description": "Fluid name string from the raw data.", "permissible": "No restriction. [Check this file for examples](https://github.com/clif-consortium/CLIF/blob/main/mCIDE/mCIDE_mapping_examples/00_mCIDE_mapping_examples/clif_vocab_microbiology_culture_fluid_ucmc.csv)"}',
  fluid_category VARCHAR COMMENT '{"description": "Fluid categories defined according to the NIH common data elements.", "permissible": "[CDE NIH Infection Site](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_culture/clif_microbiology_culture_fluid_category.csv)"}',
  method_name VARCHAR COMMENT '{"description": "Original method names from the source data.", "permissible": "No restriction"}',
  method_category VARCHAR COMMENT '{"description": "Maps method_name to a standardized list of method categories.", "permissible": "[culture, gram stain, smear](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_culture/clif_microbiology_culture_method_categories.csv)"}',
  organism_name VARCHAR COMMENT '{"description": "Organism name from the raw data.", "permissible": "No restriction."}',
  organism_category VARCHAR COMMENT '{"description": "Maps organism_name to the standardized list of organisms under the structure of genus species.", "permissible": "Organism species. [Check this file for examples](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_culture/clif_microbiology_culture_organism_categories.csv)."}',
  organism_group VARCHAR COMMENT '{"description": "Maps organism_category to the standardized list of organisms under the NIH CDE structure.", "permissible": "[CDE NIH Organism](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_culture/clif_microbiology_culture_organism_groups.csv)"}',
  lab_loinc_code VARCHAR COMMENT '{"description": "LOINC code.", "permissible": "No restriction"}'
);


-- -----------------------------------------------------
-- Table: microbiology-non-culture
-- -----------------------------------------------------
CREATE TABLE microbiology_nonculture(
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  result_dttm DATETIME COMMENT '{"description": "Date and time when the non-culture result was obtained. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  collect_dttm DATETIME COMMENT '{"description": "Date and time when the sample was collected. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  order_dttm DATETIME COMMENT '{"description": "Date and time when the test was ordered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  fluid_name VARCHAR COMMENT '{"description": "Name of the fluid sample.", "permissible": "No restriction"}',
  fluid_category VARCHAR COMMENT '{"description": "Fluid categories defined according to the NIH common data elements.", "permissible": "[CDE NIH Infection Site](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_fluid_category.csv)"}',
  method_name VARCHAR COMMENT '{"description": "Original method names from the source data.", "permissible": "No restriction"}',
  method_category VARCHAR COMMENT '{"description": "Maps method_name to a standardized list of method categories.", "permissible": "[pcr](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_method_category.csv)"}',
  micro_order_name VARCHAR COMMENT '{"description": "String name of microbiology non-culture test.", "permissible": "No restriction"}',
  organism_category VARCHAR COMMENT '{"description": "Maps organism_name to the standardized list of organisms under the structure of genus species.", "permissible": "Organism species. [Check this file for examples](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_organism_category.csv)."}',
  organism_group VARCHAR COMMENT '{"description": "Maps organism_category to the standardized list of organisms under the NIH CDE structure.", "permissible": "[CDE NIH Organism](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_organism_category.csv)"}',
  result_name VARCHAR COMMENT '{"description": "Result name from the raw data.", "permissible": "No restriction"}',
  result_category VARCHAR COMMENT '{"description": "Category of the test result.", "permissible": "[Check list of result categories](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_result_category.csv)"}',
  reference_low DOUBLE COMMENT '{"description": "Reference low value.", "permissible": "No restriction"}',
  reference_high DOUBLE COMMENT '{"description": "Reference high value.", "permissible": "No restriction"}',
  result_units VARCHAR COMMENT '{"description": "Unit of the test result.", "permissible": "No restriction"}',
  lab_loinc_code VARCHAR COMMENT '{"description": "LOINC code.", "permissible": "No restriction"}'
);


-- -----------------------------------------------------
-- Table: patient-assessments
-- -----------------------------------------------------
CREATE TABLE patient_assessments (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "The exact date and time when the assessment was recorded, ensuring temporal accuracy. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  assessment_name VARCHAR COMMENT '{"description": "Assessment Tool Name. The primary name of the assessment tool used (e.g., GCS, NRS, SAT Screen).", "permissible": "No restriction"}',
  assessment_category VARCHAR COMMENT '{"description": "Maps assessment_name to a standardized list of patient assessments", "permissible": "[List of permissible assessment categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/patient_assessments/clif_patient_assessment_categories.csv)"}',
  assessment_group VARCHAR COMMENT '{"description": "Broader Assessment Group. This groups the assessments into categories such as Sedation, Neurologic, Pain, etc.", "permissible": "[List of permissible assessment groups in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/patient_assessments/clif_patient_assessment_categories.csv)"}',
  numerical_value DOUBLE COMMENT '{"description": "Numerical Assessment Result. The numerical result or score from the assessment component.", "permissible": "Applicable for assessments with numerical outcomes (e.g., 0-10, 3-15)"}',
  categorical_value VARCHAR COMMENT '{"description": "Categorical Assessment Result. The categorical outcome from the assessment component.", "permissible": "Applicable for assessments with categorical outcomes (e.g., Pass/Fail, Yes/No)"}',
  text_value VARCHAR COMMENT '{"description": "Textual Assessment Result. The textual explanation or notes from the assessment component.", "permissible": "Applicable for assessments requiring textual data"}'
);

-- -----------------------------------------------------
-- Table: patient
-- -----------------------------------------------------
CREATE TABLE patient (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  race_name VARCHAR COMMENT '{"description": "Patient race string from source data", "permissible": "No restriction"}',
  race_category VARCHAR COMMENT '{"description": "A standardized CDE description of patient race per the US Census", "permissible": "[Black or African American, White, American Indian or Alaska Native, Asian, Native Hawaiian or Other Pacific Islander, Unknown, Other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/patient/clif_patient_race_categories.csv)"}',
  ethnicity_name VARCHAR COMMENT '{"description": "Patient ethnicity string from source data", "permissible": "No restriction"}',
  ethnicity_category VARCHAR COMMENT '{"description": "Description of patient ethnicity per the US census definition", "permissible": "[Hispanic, Non-Hispanic, Unknown](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/patient/clif_patient_ethnicity_categories.csv)"}',
  sex_name VARCHAR COMMENT '{"description": "Patient biological sex as given in the source data", "permissible": "No restriction"}',
  sex_category VARCHAR COMMENT '{"description": "Patient biological sex", "permissible": "[Male, Female, Unknown](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/patient/clif_patient_sex_categories.csv)"}',
  birth_date DATE COMMENT '{"description": "Patient’s date of birth", "permissible": "Date format should be YYYY-MM-DD"}',
  death_dttm DATETIME COMMENT '{"description": "Patient’s death date, including time", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  language_name VARCHAR COMMENT '{"description": "Patient’s preferred language", "permissible": "Original string from the source data"}',
  language_category VARCHAR COMMENT '{"description": "Maps language_name to a standardized list of spoken languages", "permissible": "[List of language categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/patient/clif_patient_language_categories.csv)"}'
);

-- -----------------------------------------------------
-- Table: position
-- -----------------------------------------------------
CREATE TABLE position (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the vital is recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  position_name VARCHAR COMMENT '{"description": "Description of the position from the source data. This field is not used for analysis.", "permissible": "No restriction"}',
  position_category VARCHAR COMMENT '{"description": "Maps position_name to either prone or not prone.", "permissible": "[prone, not_prone](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/tree/main/mCIDE/postion/clif_position_categories.csv)"}'
);


-- -----------------------------------------------------
-- Table: resp
-- -----------------------------------------------------
CREATE TABLE respiratory_support (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the device settings and/or measurement was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  device_name VARCHAR COMMENT '{"description": "Raw string of the device. Not used for analysis.", "permissible": "No restriction"}',
  device_category VARCHAR COMMENT '{"description": "Maps device_name to a standardized list of respiratory support device categories", "permissible": "[IMV, NIPPV, CPAP, High Flow NC, Face Mask, Trach Collar, Nasal Cannula, Room Air, Other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/respiratory_support/clif_respiratory_support_device_categories.csv)"}',
  vent_brand_name VARCHAR COMMENT '{"description": "Ventilator model name when device_category is IMV or NIPPV", "permissible": "Optional"}',
  mode_name VARCHAR COMMENT '{"description": "Raw string of ventilation mode (e.g., CMV volume control)", "permissible": "No restriction"}',
  mode_category VARCHAR COMMENT '{"description": "Standardized list of modes of mechanical ventilation", "permissible": "[Assist Control-Volume Control, Pressure Control, Pressure-Regulated Volume Control, SIMV, Pressure Support/CPAP, Volume Support, Blow by, Other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/respiratory_support/clif_respiratory_support_mode_categories.csv)"}',
  tracheostomy INT COMMENT '{"description": "Indicates if tracheostomy is present", "permissible": "0 = No, 1 = Yes"}',
  fio2_set FLOAT COMMENT '{"description": "Fraction of inspired oxygen set (e.g., 0.21)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  lpm_set FLOAT COMMENT '{"description": "Liters per minute set", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  tidal_volume_set FLOAT COMMENT '{"description": "Tidal volume set (in mL)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  resp_rate_set FLOAT COMMENT '{"description": "Respiratory rate set (in bpm)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  pressure_control_set FLOAT COMMENT '{"description": "Pressure control set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  pressure_support_set FLOAT COMMENT '{"description": "Pressure support set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  flow_rate_set FLOAT COMMENT '{"description": "Flow rate set", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  peak_inspiratory_pressure_set FLOAT COMMENT '{"description": "Peak inspiratory pressure set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  inspiratory_time_set FLOAT COMMENT '{"description": "Inspiratory time set (in seconds)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  peep_set FLOAT COMMENT '{"description": "Positive-end-expiratory pressure set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  tidal_volume_obs FLOAT COMMENT '{"description": "Observed tidal volume (in mL)", "permissible": "No restriction"}',
  resp_rate_obs FLOAT COMMENT '{"description": "Observed respiratory rate (in bpm)", "permissible": "No restriction"}',
  plateau_pressure_obs FLOAT COMMENT '{"description": "Observed plateau pressure (in cmH2O)", "permissible": "No restriction"}',
  peak_inspiratory_pressure_obs FLOAT COMMENT '{"description": "Observed peak inspiratory pressure (in cmH2O)", "permissible": "No restriction"}',
  peep_obs FLOAT COMMENT '{"description": "Observed PEEP (in cmH2O)", "permissible": "No restriction"}',
  minute_vent_obs FLOAT COMMENT '{"description": "Observed minute ventilation (in liters)", "permissible": "No restriction"}',
  mean_airway_pressure_obs FLOAT COMMENT '{"description": "Observed mean airway pressure", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: Vitals
-- -----------------------------------------------------

CREATE TABLE vitals (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the vital is recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  vital_name VARCHAR COMMENT '{"description": "Description of the flowsheet measure from the source data. Not used for analysis.", "permissible": "No restriction"}',
  vital_category VARCHAR COMMENT '{"description": "Maps vital_name to a list of standard vital sign categories.", "permissible": "[temp_c, heart_rate, sbp, dbp, spo2, respiratory_rate, map, height_cm, weight_kg](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/vitals/clif_vitals_categories.csv)"}',
  vital_value FLOAT COMMENT '{"description": "Recorded value of the vital. Measurement unit should match the vital category.", "permissible": "temp_c = Celsius, height_cm = Centimeters, weight_kg = Kg, map = mmHg, spo2 = %. No unit for heart_rate, sbp, dbp, respiratory_rate"}',
  meas_site_name VARCHAR COMMENT '{"description": "Site where the vital is recorded. Optional field with no associated category.", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: intake_output
-- -----------------------------------------------------
CREATE TABLE intake_output (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  intake_dttm DATETIME COMMENT '{"description": "Date and time of intake. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  fluid_name VARCHAR COMMENT '{"description": "Name of the fluid administered.", "permissible": "No restriction"}',
  amount DOUBLE COMMENT '{"description": "Amount of fluid administered (in mL)", "permissible": "Numeric values in mL"}',
  in_out_flag INT COMMENT '{"description": "Indicator for intake or output (1 for intake, 0 for output)", "permissible": "0 = Output, 1 = Intake"}'
);

-- -----------------------------------------------------
-- Table: invasive_hemodynamics
-- -----------------------------------------------------
CREATE TABLE invasive_hemodynamics (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "The date and time when the measurement was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  measure_name VARCHAR COMMENT '{"description": "Description of the site or context of the invasive hemodynamic measurement.", "permissible": "Free text (e.g., Right Atrium)"}',
  measure_category VARCHAR COMMENT '{"description": "Categorical variable specifying the type of invasive hemodynamic measurement.", "permissible": "[cvp, ra, rv, pa_systolic, pa_diastolic, pa_mean, pcwp, cardiac_output_thermodilution , cardiac_output_fick](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/invasive_hemodynamics/clif_invasive_hemodynamics_measure_categories.csv)"}',
  measure_value DOUBLE COMMENT '{"description": "The numerical value of the invasive hemodynamic measurement in mmHg.", "permissible": "Positive decimal values (e.g., 5.00, 25.65)"}'
);

-- -----------------------------------------------------
-- Table: key_icu_orders
-- -----------------------------------------------------
CREATE TABLE key_icu_orders (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  order_dttm DATETIME COMMENT '{"description": "Date and time when the order was placed. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  order_name VARCHAR COMMENT '{"description": "Name of the specific order (e.g., PT Evaluation, OT Treatment).", "permissible": "No restriction"}',
  order_category VARCHAR COMMENT '{"description": "Category of the order.", "permissible": "Under-development. Some examples include: [pt_evaluation, pt_treat, ot_evaluation, ot_treat](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/key_icu_orders/clif_key_icu_orders_categories.csv)"}',
  order_status_name VARCHAR COMMENT '{"description": "Status of the order.", "permissible": "sent, completed"}'
);

-- -----------------------------------------------------
-- Table: medication_admin_intermittent
-- -----------------------------------------------------
CREATE TABLE medication_admin_intermittent (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  med_order_id VARCHAR COMMENT '{"description": "Medication order ID. Foreign key to link this table to other medication tables", "permissible": "No restriction"}',
  admin_dttm DATETIME COMMENT '{"description": "Date and time when the medicine was administered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  med_name VARCHAR COMMENT '{"description": "Original med name string recorded in the raw data which often contains concentration e.g. NOREPInephrine 8 mg/250 mL", "permissible": "No restriction"}',
  med_category VARCHAR COMMENT '{"description": "Maps med_name to a limited set of active ingredients for important ICU medications, e.g. norepinephrine", "permissible": "[List of medication categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv)"}',
  med_group VARCHAR COMMENT '{"description": "Limited number of ICU medication groups identified by the CLIF consortium, e.g. vasoactives", "permissible": "[List of medication groups in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv)"}',
  med_route_name VARCHAR COMMENT '{"description": "Medicine delivery route", "permissible": "e.g. IV, enteral"}',
  med_route_category VARCHAR COMMENT '{"description": "Maps med_route_name to a standardized list of medication delivery routes", "permissible": "[List of intermittent route categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_route_categories.csv)"}',
  med_dose FLOAT COMMENT '{"description": "Quantity taken in dose", "permissible": "Numeric"}',
  med_dose_unit VARCHAR COMMENT '{"description": "Unit of dose. It must be a rate, e.g. mcg/min. Boluses should be mapped to med_admin_intermittent", "permissible": "No restriction"}',
  mar_action_name VARCHAR COMMENT '{"description": "MAR (medication administration record) action, e.g. stopped", "permissible": "No restriction"}',
  mar_action_category VARCHAR COMMENT '{"description": "Maps mar_action_name to a standardized list of MAR actions", "permissible": "Under-development"}'
);

-- -----------------------------------------------------
-- Table: medication_orders
-- -----------------------------------------------------
CREATE TABLE medication_orders (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  med_order_id VARCHAR COMMENT '{"description": "Unique identifier for each medication order", "permissible": "No restriction"}',
  order_start_dttm DATETIME COMMENT '{"description": "Date and time when the medication order was initiated. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  order_end_dttm DATETIME COMMENT '{"description": "Date and time when the medication order ended or was discontinued. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  ordered_dttm DATETIME COMMENT '{"description": "Date and time when the medication was actually ordered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  med_name VARCHAR COMMENT '{"description": "Name of the medication ordered", "permissible": "No restriction"}',
  med_category VARCHAR COMMENT '{"description": "Maps med_name to a list of permissible medication names", "permissible": "Combined CDE of medication_admin_continuous and medication_admin_intermittent"}',
  med_group VARCHAR COMMENT '{"description": "Limited number of medication groups identified by the CLIF consortium", "permissible": "No restriction"}',
  med_order_status_name VARCHAR COMMENT '{"description": "Status of the medication order, e.g. held, given", "permissible": "No restriction"}',
  med_order_status_category VARCHAR COMMENT '{"description": "Maps med_order_status_name to a standardized list of medication order statuses", "permissible": "Under-development"}',
  med_route_name VARCHAR COMMENT '{"description": "Route of administration for the medication", "permissible": "No restriction. Examples include Oral, Intravenous"}',
  med_dose DOUBLE COMMENT '{"description": "Dosage of the medication ordered", "permissible": "Numeric"}',
  med_dose_unit VARCHAR COMMENT '{"description": "Unit of measurement for the medication dosage", "permissible": "Examples include mg, mL, units"}',
  med_frequency VARCHAR COMMENT '{"description": "Frequency with which the medication is administered, as per the order", "permissible": "Examples include Once Daily, Every 6 hours"}',
  prn BOOLEAN COMMENT '{"description": "Indicates whether the medication is to be given as needed (PRN)", "permissible": "0 = No, 1 = Yes"}'
);

-- -----------------------------------------------------
-- Table: patient_diagnosis
-- -----------------------------------------------------
CREATE TABLE patient_diagnosis (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  diagnosis_code VARCHAR COMMENT '{"description": "ICD-10-CM from clinical documentation", "permissible": "Valid ICD-10-CM code"}',
  diagnosis_code_format VARCHAR COMMENT '{"description": "ICD10CM (clinical data typically ICD-10 only)", "permissible": "ICD10CM"}',
  source_type VARCHAR COMMENT '{"description": "Source of diagnosis: problem_list, medical_history, encounter_dx (optional)", "permissible": "problem_list, medical_history, encounter_dx"}',
  start_dttm DATETIME COMMENT '{"description": "When condition started (user-defined)", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  end_dttm DATETIME COMMENT '{"description": "When condition ended (NULL if ongoing)", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}'
);

-- -----------------------------------------------------
-- Table: patient_procedures
-- -----------------------------------------------------
CREATE TABLE patient_procedures (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  billing_provider_id VARCHAR COMMENT '{"description": "Uniquely identifies the billingprovider associated with the procedure.", "permissible": "No restriction"}',
  performing_provider_id VARCHAR COMMENT '{"description": "Uniquely identifies the performing provider associated with the procedure.", "permissible": "No restriction"}',
  procedure_code VARCHAR COMMENT '{"description": "Encoded procedure identifier.", "permissible": "Valid CPT, ICD-10-PCS OR HCPCS code"}',
  procedure_code_format VARCHAR COMMENT '{"description": "Code format used.", "permissible": "CPT, ICD10PCS, HCPCS"}',
  procedure_billed_dttm DATETIME COMMENT '{"description": "Date and time the procedure was billed (may differ from actual procedure time). All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}'
);

-- -----------------------------------------------------
-- Table: provider
-- -----------------------------------------------------
CREATE TABLE provider (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  provider_id VARCHAR COMMENT '{"description": "Unique identifier for each provider. This represents individual healthcare providers", "permissible": "No restriction"}',
  start_dttm DATETIME COMMENT '{"description": "Date and time when the provider’s care or involvement in the patient’s case began. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  stop_dttm DATETIME COMMENT '{"description": "Date and time when the provider’s care or involvement in the patient’s case ended. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  provider_role_name VARCHAR COMMENT '{"description": "The original string describing the role or specialty of the provider during the hospitalization", "permissible": "No restriction"}',
  provider_role_category VARCHAR COMMENT '{"description": "Maps provider_role_name to list of standardized provider roles", "permissible": "Under development"}'
);

-- -----------------------------------------------------
-- Table: sensitivity
-- -----------------------------------------------------
CREATE TABLE sensitivity (
  culture_id VARCHAR COMMENT '{"description": "Unique identifier linking to the culture from which the sensitivity test was performed", "permissible": "No restriction"}',
  antibiotic VARCHAR COMMENT '{"description": "Name of the antibiotic tested for sensitivity", "permissible": "Examples include Penicillin, Vancomycin"}',
  sensitivity VARCHAR COMMENT '{"description": "The result of the sensitivity test, indicating the organism’s resistance or susceptibility", "permissible": "Resistant, Intermediate, Susceptible"}',
  mic DOUBLE COMMENT '{"description": "Minimum Inhibitory Concentration (MIC) value, which measures the lowest concentration of an antibiotic needed to inhibit growth", "permissible": "Numeric"}'
);

-- -----------------------------------------------------
-- Table: therapy_details
-- -----------------------------------------------------
CREATE TABLE therapy_details (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  session_start_dttm DATETIME COMMENT '{"description": "Date and time when the therapy session started. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  therapy_element_name VARCHAR COMMENT '{"description": "Name of the therapy element.", "permissible": "No restriction"}',
  therapy_element_category VARCHAR COMMENT '{"description": "Category of the therapy element.", "permissible": "No restriction"}',
  therapy_element_value VARCHAR COMMENT '{"description": "Value associated with the therapy element.", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: transfusion
-- -----------------------------------------------------
CREATE TABLE transfusion (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  transfusion_start_dttm DATETIME COMMENT '{"description": "The date and time the transfusion of the blood component began. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  transfusion_end_dttm DATETIME COMMENT '{"description": "The date and time the transfusion of the blood component ended. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  component_name VARCHAR COMMENT '{"description": "The name of the blood component transfused.", "permissible": "E.g., Red Blood Cells, Plasma, Platelets"}',
  attribute_name VARCHAR COMMENT '{"description": "Attributes describing modifications to the component.", "permissible": "E.g., Leukocyte Reduced, Irradiated"}',
  volume_transfused DOUBLE COMMENT '{"description": "The volume of the blood component transfused.", "permissible": "Numeric, e.g., 300"}',
  volume_units VARCHAR COMMENT '{"description": "The unit of measurement for the transfused volume.", "permissible": "E.g., mL"}',
  product_code VARCHAR COMMENT '{"description": "ISBT 128 Product Description Code representing the specific blood product.", "permissible": "E.g., E0382"}'
);
