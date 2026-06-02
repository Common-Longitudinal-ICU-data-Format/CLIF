
-- -----------------------------------------------------
-- Table: adt
-- -----------------------------------------------------
CREATE TABLE adt (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  hospital_id VARCHAR COMMENT '{"description": "Assign a unique ID to each hospital within a healthsystem", "permissible": "No restriction"}',
  hospital_type VARCHAR COMMENT '{"description": "Maps *`hospital_id`* to a standardized list of hospital types", "permissible": "[academic, community, ltach](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/adt/clif_adt_hospital_type.csv)"}',
  in_dttm DATETIME COMMENT '{"description": "Start date and time at a particular location. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  out_dttm DATETIME COMMENT '{"description": "End date and time at a particular location. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  location_name VARCHAR COMMENT '{"description": "Location of the patient inside the hospital. This field is used to store the patient location from the source data. It is not used for analysis.", "permissible": "No restriction"}',
  location_category VARCHAR COMMENT '{"description": "Maps location_name to a standardized list of ADT location categories", "permissible": "[ed, ward, stepdown, icu, procedural, l_and_d, hospice, psych, rehab, radiology, dialysis, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/adt/clif_adt_location_categories.csv)"}',
  location_type VARCHAR COMMENT '{"description": "Maps ICU type to a standardized list of ICU categories", "permissible": "[List of ICU categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/adt/clif_adt_location_type.csv)"}',
  room_id VARCHAR COMMENT '{"description": "Free-text identifier for the room the patient was assigned to during this ADT segment. Not standardized across sites.", "permissible": "No restriction"}',
  bed_id VARCHAR COMMENT '{"description": "Free-text identifier for the bed the patient was assigned to during this ADT segment. Not standardized across sites.", "permissible": "No restriction"}',
  FOREIGN KEY (hospitalization_id) REFERENCES hospitalization(hospitalization_id)
);

-- -----------------------------------------------------
-- Table: code_status
-- -----------------------------------------------------
CREATE TABLE code_status(
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  start_dttm DATETIME COMMENT '{"description": "The date and time when the specific code status was initiated", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  code_status_name VARCHAR COMMENT '{"description": "The name/description of the code status", "permissible": "No restriction"}',
  code_status_category VARCHAR COMMENT '{"description": "Categorical variable specifying the code status during the hospitalization", "permissible": "[dnr, dnar, udnr, dnr_or_dni, dnar_or_dni, dni_only, and, full, presume_full, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/code_status/clif_code_status_categories.csv)"}',
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- -----------------------------------------------------
-- Table: crrt_therapy
-- -----------------------------------------------------
CREATE TABLE crrt_therapy (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  device_id VARCHAR COMMENT '{"description": "Unique ID of the individual dialysis machine used (e.g., machine ACZ3RV91). Distinct from dialysis_machine_name, which stores the brand/model.", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Timestamp when CRRT parameters were recorded", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  crrt_mode_name VARCHAR COMMENT '{"description": "Name of CRRT mode (e.g., CVVHDF)", "permissible": "No restriction"}',
  crrt_mode_category VARCHAR COMMENT '{"description": "Standardized CRRT mode categories", "permissible": "[scuf, cvvh, cvvhd, cvvhdf, avvh](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/crrt_therapy/clif_crrt_therapy_mode_categories.csv)"}',
  dialysis_machine_name VARCHAR COMMENT '{"description": "Brand name for the dialysis machine", "permissible": "No restriction"}',
  blood_flow_rate FLOAT COMMENT '{"description": "Rate of blood flow through the CRRT circuit (mL/min)", "permissible": "[150-350](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  pre_filter_replacement_fluid_rate FLOAT COMMENT '{"description": "Rate of pre-filter replacement fluid infusion (mL/hr)", "permissible": "[0-10000](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  post_filter_replacement_fluid_rate FLOAT COMMENT '{"description": "Rate of post-filter replacement fluid infusion (mL/hr)", "permissible": "[0-10000](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  dialysate_flow_rate FLOAT COMMENT '{"description": "Flow rate of dialysate solution (mL/hr)", "permissible": "[0-10000](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}',
  ultrafiltration_out FLOAT COMMENT '{"description": "Net ultrafiltration output (mL/hr)", "permissible": "[0-500](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_crrt_modes.csv)"}'
);

-- -----------------------------------------------------
-- Table: intermittent_dialysis
-- -----------------------------------------------------
CREATE TABLE intermittent_dialysis (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  device_id VARCHAR COMMENT '{"description": "Unique ID of the individual physical device used.", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Timestamp of the recorded measurement during the dialysis session. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  blood_flow_rate FLOAT COMMENT '{"description": "Blood flow rate in mL/min. The first recorded value can indicate session start time.", "permissible": "Numeric values in mL/min"}',
  dialysate_flow_rate FLOAT COMMENT '{"description": "Dialysate flow rate in mL/min.", "permissible": "Numeric values in mL/min"}',
  net_ultrafiltration_out FLOAT COMMENT '{"description": "Net ultrafiltration output in mL.", "permissible": "Numeric values in mL"}',
  FOREIGN KEY (hospitalization_id) REFERENCES hospitalization(hospitalization_id)
);

-- -----------------------------------------------------#
-- Table: mcs
-- -----------------------------------------------------#
CREATE TABLE mcs (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the device settings and/or measurement was recorded", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  support_name VARCHAR COMMENT '{"description": "Unstandardized name of the mechanical support type recorded in the raw data", "permissible": "No restriction"}',
  support_category VARCHAR COMMENT '{"description": "Standardized category of support type which reports the measurement_value", "permissible": "[List of support categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/mcs/clif_mcs_support_category.csv)"}',
  device_name VARCHAR COMMENT '{"description": "Unstandardized name of the device recorded in the raw data", "permissible": "No restriction"}',
  device_category VARCHAR COMMENT '{"description": "Standardized category of device brand reporting the measurement_value", "permissible": "[List of device categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/mcs/clif_mcs_device_category.csv)"}',
  config_name VARCHAR COMMENT '{"description": "Unstandardized name of the device configuration recorded in the raw data", "permissible": "No restriction"}',
  config_category VARCHAR COMMENT '{"description": "Standardized category of MCS configuration. Permissible values are conditional on support_category and device_category (e.g., cp/2_5/2_5_or_cp/5/5_5/rp/rp_flex apply to lvad & impella, heartware/heartmate2/heartmate3 apply to lvad, central applies to lvad or rvad).", "permissible": "[List of configuration categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/mcs/clif_mcs_configuration_category.csv)"}',
  setting_name VARCHAR COMMENT '{"description": "Unstandardized name of the device setting or measurement recorded in the raw data", "permissible": "No restriction"}',
  setting_category VARCHAR COMMENT '{"description": "Standardized category of reported setting or measurement", "permissible": "[List of setting categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/mcs/clif_mcs_setting_category.csv)"}',
  setting_value FLOAT COMMENT '{"description": "Numeric value of the reported setting or measurement, interpreted in the units defined by setting_category", "permissible": "Numeric"}'
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
  admission_type_category VARCHAR COMMENT '{"description": "Admission disposition mapped to mCIDE categories", "permissible": "[List of admission type categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/hospitalization/clif_hospitalization_admission_type_categories.csv)"}',
  discharge_name VARCHAR COMMENT '{"description": "Original discharge disposition name string recorded in the raw data", "permissible": "No restriction, e.g. home"}',
  discharge_category VARCHAR COMMENT '{"description": "Maps discharge_name to a standardized list of discharge categories", "permissible": "[home, snf, expired, acute_ip_rehab, hospice, ltach, acute_care_hosp, group_home, chemical_dependency, ama, assisted_living, still_admitted, missing, other, mental_health_hosp, shelter, jail](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/hospitalization/clif_hospitalization_discharge_categories.csv)"}',
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
  lab_order_category VARCHAR COMMENT '{"description": "Maps lab_order_name to standardized list of common lab order names, e.g. \"CBC\"", "permissible": "[List of lab order categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/labs/clif_labs_order_categories.csv)"}',
  lab_name VARCHAR COMMENT '{"description": "Original lab component as recorded in the raw data, e.g. \"AST (SGOT)\".", "permissible": "No restriction"}',
  lab_category VARCHAR COMMENT '{"description": "Maps lab_name to a minimum set of standardized labs identified by the CLIF consortium as minimum necessary labs for the study of critical illness.", "permissible": "[List of lab categories in CLIF](https://github.com/clif-consortium/CLIF/blob/3.0/mCIDE/labs/clif_lab_categories.csv)"}',
  lab_value VARCHAR COMMENT '{"description": "Recorded value corresponding to a lab. Lab values are often strings that can contain non-numeric results (e.g. \"> upper limit of detection\").", "permissible": "No restriction"}',
  lab_value_numeric DOUBLE COMMENT '{"description": "Parse out numeric part of the lab_value variable (optional).", "permissible": "Numeric"}',
  reference_unit VARCHAR COMMENT '{"description": "Unit of measurement for that lab.", "permissible": "Permissible reference values for each lab_category listed [here](https://github.com/clif-consortium/CLIF/blob/3.0/mCIDE/labs/clif_lab_categories.csv)"}',
  lab_specimen_name VARCHAR COMMENT '{"description": "Original fluid or tissue name the lab was collected from as given in the source data", "permissible": "No restriction"}',
  lab_specimen_category VARCHAR COMMENT '{"description": "Fluid or tissue the lab was collected from, analogous to the LOINC \"system\" component.", "permissible": "working CDE c(blood/plasma/serum, urine, csf, other)"}',
  lab_loinc_code VARCHAR COMMENT '{"description": "[LOINC](https://loinc.org/get-started/loinc-term-basics/) code for the lab", "permissible": "No restrictions"}',
  loinc_version VARCHAR COMMENT '{"description": "Version or release of the LOINC coding system used for lab_loinc_code, e.g. 1.0 or 1.1.", "permissible": "[LOINC version history](https://loinc.org/history/)"}'
);

-- -----------------------------------------------------
-- Table: medication-admin-continuous
-- -----------------------------------------------------
CREATE TABLE medication_admin_continuous (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  med_order_id VARCHAR COMMENT '{"description": "Medication order ID. Foreign key to link this table to other medication tables", "permissible": "No restriction"}',
  administering_provider_id VARCHAR COMMENT '{"description": "Uniquely identifies the provider who administered the medication.", "permissible": "No restriction"}',
  admin_dttm DATETIME COMMENT '{"description": "Date and time when the medicine was administered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  med_name VARCHAR COMMENT '{"description": "Original med name string recorded in the raw data which often contains concentration e.g. NOREPInephrine 8 mg/250 mL", "permissible": "No restriction"}',
  med_category VARCHAR COMMENT '{"description": "Maps med_name to a limited set of active ingredients for important ICU medications, e.g. norepinephrine", "permissible": "[List of continuous medication categories in CLIF](https://github.com/clif-consortium/CLIF/blob/3.0/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv) "}',
  med_group VARCHAR COMMENT '{"description": "Limited number of ICU medication groups identified by the CLIF consortium, e.g. vasoactives", "permissible": "[List of continuous medication groups in CLIF](https://github.com/clif-consortium/CLIF/blob/3.0/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv)   "}',
  med_route_name VARCHAR COMMENT '{"description": "Medicine delivery route", "permissible": "e.g. IV, enteral"}',
  med_route_category VARCHAR COMMENT '{"description": "Maps med_route_name to a standardized list of medication delivery routes. Refer to notes.", "permissible": "[List of continuous route categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_route_categories.csv)"}',
  med_dose FLOAT COMMENT '{"description": "Quantity of active drug delivered per unit time", "permissible": "Numeric"}',
  med_dose_unit VARCHAR COMMENT '{"description": "Unit of dose in the format [active ingredient quantity]/[time] (e.g., mcg/min, mg/hr, units/hr, mcg/kg/min). Units are not standardized across drugs, and can be weight-based (e.g., mcg/kg/min). Boluses should be mapped to med_admin_intermittent", "permissible": "No restriction"}',
  rx_norm_code VARCHAR COMMENT '{"description": "RxNorm RXCUI code identifying the specific drug formulation (active ingredient, strength, dose form, and route) for this administration. Resolved from the combination of med_name, med_route_name, med_dose, and med_dose_unit.", "permissible": "[RxNorm RXCUI](https://www.nlm.nih.gov/research/umls/rxnorm/index.html)"}',
  volume_infusion_rate FLOAT COMMENT '{"description": "Absolute amount of volume administered over time, measured in [volume]/[time] (e.g., mL/hr). In contrast to med_dose which measures [quantity of drug]/[time] or [quantity of drug]/([time]*[body_weight])", "permissible": "Numeric"}',
  volume_infusion_rate_unit VARCHAR COMMENT '{"description": "Standardized unit of volume infusion rate per med_category in the format [volume]/[time] (e.g., mL/hr, mL/min).", "permissible": "[List of continuous medication categories with standardized volume_infusion_rate_unit in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv)"}',
  mar_action_name VARCHAR COMMENT '{"description": "MAR (medication administration record) action, e.g. stopped", "permissible": "No restriction"}',
  mar_action_category VARCHAR COMMENT '{"description": "Maps mar_action_name to a standardized list of MAR actions", "permissible": "[List of continuous action categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_action_categories.csv)"}',
  mar_action_group VARCHAR COMMENT '{"description": "Maps mar_action_category to whether the action means the medication was administered or not.", "permissible": "[administered, not_administered, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_continuous/clif_medication_admin_continuous_action_categories.csv)"}'
);

-- -----------------------------------------------------
-- Table: microbiology-culture
-- -----------------------------------------------------


CREATE TABLE microbiology_culture (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  organism_id VARCHAR COMMENT '{"description": "A key that links microbiology culture table to microbiology susceptibility table", "permissible": "No restriction"}',
  order_dttm DATETIME COMMENT '{"description": "Date and time when the test is ordered.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  collect_dttm DATETIME COMMENT '{"description": "Date and time when the specimen is collected.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  result_dttm DATETIME COMMENT '{"description": "Date and time when the result was reported. For positive cultures and positive gram stains, keep every interval/processing-step row as the EHR records it. For negative results, keep only one row per workup — the final no-growth row for cultures (method_category = culture), and the first no-bacteria-seen row for gram stains (method_category = gram stain).", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  fluid_name VARCHAR COMMENT '{"description": "Fluid name string from the raw data.", "permissible": "No restriction."}',
  fluid_category VARCHAR COMMENT '{"description": "Fluid categories defined according to the NIH common data elements.", "permissible": "[CDE NIH Infection Site](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_culture/clif_microbiology_culture_fluid_category.csv)"}',
  method_name VARCHAR COMMENT '{"description": "Original method names from the source data.", "permissible": "No restriction"}',
  method_category VARCHAR COMMENT '{"description": "Maps method_name to a standardized list of method categories.", "permissible": "[culture, gram_stain, smear](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_culture/clif_microbiology_culture_method_categories.csv)"}',
  organism_name VARCHAR COMMENT '{"description": "Organism name from the raw data.", "permissible": "No restriction."}',
  organism_category VARCHAR COMMENT '{"description": "Maps organism_name to the standardized list of organisms under the structure of genus species.", "permissible": "Organism species. [Check this file for examples](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_culture/clif_microbiology_culture_organism_categories.csv)."}',
  organism_group VARCHAR COMMENT '{"description": "Maps organism_category to the standardized list of organisms under the NIH CDE structure.", "permissible": "[CDE NIH Organism](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_culture/clif_microbiology_culture_organism_groups.csv)"}',
  lab_loinc_code VARCHAR COMMENT '{"description": "LOINC code.", "permissible": "No restriction"}'
);


-- -----------------------------------------------------
-- Table: microbiology-non-culture
-- -----------------------------------------------------
CREATE TABLE microbiology_nonculture(
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  result_dttm DATETIME COMMENT '{"description": "Date and time when the non-culture result was reported. All datetime variables must be timezone-aware and set to UTC. For positive results, keep every interval/processing-step row as the EHR records it. For negative results, keep only the final negative-result row — one row per order.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  collect_dttm DATETIME COMMENT '{"description": "Date and time when the sample was collected. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  order_dttm DATETIME COMMENT '{"description": "Date and time when the test was ordered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  fluid_name VARCHAR COMMENT '{"description": "Name of the fluid sample.", "permissible": "No restriction"}',
  fluid_category VARCHAR COMMENT '{"description": "Fluid categories defined according to the NIH common data elements.", "permissible": "[CDE NIH Infection Site](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_fluid_category.csv)"}',
  method_name VARCHAR COMMENT '{"description": "Original method names from the source data.", "permissible": "No restriction"}',
  method_category VARCHAR COMMENT '{"description": "Maps method_name to a standardized list of method categories.", "permissible": "[pcr](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_method_category.csv)"}',
  micro_order_name VARCHAR COMMENT '{"description": "String name of microbiology non-culture test.", "permissible": "No restriction"}',
  organism_category VARCHAR COMMENT '{"description": "Maps the organism name in micro_order_name to the standardized list of organisms under the structure of genus species.", "permissible": "Organism species. [Check this file for examples](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_organism_category.csv)."}',
  organism_group VARCHAR COMMENT '{"description": "Maps organism_category to the standardized list of organisms under the NIH CDE structure.", "permissible": "[CDE NIH Organism](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_organism_groups.csv)"}',
  result_name VARCHAR COMMENT '{"description": "Result name from the raw data.", "permissible": "No restriction"}',
  result_category VARCHAR COMMENT '{"description": "Category of the test result.", "permissible": "[Check list of result categories](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_nonculture/clif_microbiology_nonculture_result_category.csv)"}',
  reference_low DOUBLE COMMENT '{"description": "Reference low value.", "permissible": "No restriction"}',
  reference_high DOUBLE COMMENT '{"description": "Reference high value.", "permissible": "No restriction"}',
  result_unit VARCHAR COMMENT '{"description": "Unit of the test result.", "permissible": "No restriction"}',
  lab_loinc_code VARCHAR COMMENT '{"description": "LOINC code.", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: patient-assessments
-- -----------------------------------------------------
CREATE TABLE patient_assessments (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  administering_provider_id VARCHAR COMMENT '{"description": "Uniquely identifies the provider who administered or recorded the assessment.", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "The exact date and time when the assessment was recorded, ensuring temporal accuracy. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  assessment_name VARCHAR COMMENT '{"description": "Assessment Tool Name. The primary name of the assessment tool used (e.g., GCS, NRS, SAT Screen).", "permissible": "No restriction"}',
  assessment_category VARCHAR COMMENT '{"description": "Maps assessment_name to a standardized list of patient assessments", "permissible": "[List of permissible assessment categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient_assessments/clif_patient_assessment_categories.csv)"}',
  assessment_group VARCHAR COMMENT '{"description": "Broader Assessment Group. This groups the assessments into categories such as Sedation, Neurologic, Pain, etc.", "permissible": "[List of permissible assessment groups in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient_assessments/clif_patient_assessment_categories.csv)"}',
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
  race_category VARCHAR COMMENT '{"description": "A standardized CDE description of patient race per the US Census", "permissible": "[black_or_african_american, white, american_indian_or_alaska_native, asian, native_hawaiian_or_other_pacific_islander, middle_eastern_or_north_african, unknown, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient/clif_patient_race_categories.csv)"}',
  ethnicity_name VARCHAR COMMENT '{"description": "Patient ethnicity string from source data", "permissible": "No restriction"}',
  ethnicity_category VARCHAR COMMENT '{"description": "Description of patient ethnicity per the US census definition", "permissible": "[hispanic, non_hispanic, unknown](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient/clif_patient_ethinicity_categories.csv)"}',
  sex_name VARCHAR COMMENT '{"description": "Patient’s biological sex as given in the source data", "permissible": "No restriction"}',
  sex_category VARCHAR COMMENT '{"description": "Patient biological sex", "permissible": "[male, female, unknown](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient/clif_patient_sex_categories.csv)"}',
  birth_date DATE COMMENT '{"description": "Patient’s date of birth", "permissible": "Date format should be YYYY-MM-DD"}',
  death_dttm DATETIME COMMENT '{"description": "Patient’s death date, including time. Can be sourced from hospital records, or external sources like state vital records registries", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  language_name VARCHAR COMMENT '{"description": "Patient’s preferred language", "permissible": "Original string from the source data"}',
  language_category VARCHAR COMMENT '{"description": "Maps language_name to a standardized list of spoken languages", "permissible": "[List of language categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient/clif_patient_language_categories.csv)"}',
  language_interpreter INT COMMENT '{"description": "Binary indicator for whether the patient requires a medical interpreter (1 = yes, 0 = no). Captures the patient-level interpreter need flag from the source EHR, independent of language_category.", "permissible": "0, 1"}'
);

-- -----------------------------------------------------
-- Table: position
-- -----------------------------------------------------
CREATE TABLE position (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the vital is recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  position_name VARCHAR COMMENT '{"description": "Description of the position from the source data. This field is not used for analysis.", "permissible": "No restriction"}',
  position_category VARCHAR COMMENT '{"description": "Maps position_name to either prone or not prone.", "permissible": "[prone, not_prone](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/postion/clif_position_categories.csv)"}'
);


-- -----------------------------------------------------
-- Table: resp
-- -----------------------------------------------------
CREATE TABLE respiratory_support (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the device settings and/or measurement was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00"}',
  device_name VARCHAR COMMENT '{"description": "Raw string of the device.", "permissible": "No restriction"}',
  device_id VARCHAR COMMENT '{"description": "Unique ID of the individual physical device used (e.g. ventilator ACZ3RV91), enables linkage to continuous waveform data. Distinct from vent_brand_name, which stores the brand or model.", "permissible": "No restriction"}',
  device_category VARCHAR COMMENT '{"description": "Maps device_name to a standardized list of respiratory support device categories", "permissible": "[imv, nippv, cpap, hfnc, face_mask, trach_collar, t_piece, nasal_cannula, room_air, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/respiratory_support/clif_respiratory_support_device_categories.csv)"}',
  vent_brand_name VARCHAR COMMENT '{"description": "Ventilator model name when device_category is IMV or NIPPV", "permissible": "Optional"}',
  mode_name VARCHAR COMMENT '{"description": "Raw string of ventilation mode (e.g., CMV volume control)", "permissible": "No restriction"}',
  mode_category VARCHAR COMMENT '{"description": "Standardized list of modes of mechanical ventilation", "permissible": "[acvc, pressure_control, prvc, simv, ps_or_cpap, volume_support, aprv, t_piece, blow_by, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/respiratory_support/clif_respiratory_support_mode_categories.csv)"}',
  tracheostomy INT COMMENT '{"description": "Indicates if tracheostomy is present", "permissible": "0 = No, 1 = Yes"}',
  fio2_set FLOAT COMMENT '{"description": "Fraction of inspired oxygen set (e.g., 0.21)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  lpm_set FLOAT COMMENT '{"description": "Liters per minute of supplemental oxygen set for patients NOT on positive pressure ventilation", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  tidal_volume_set FLOAT COMMENT '{"description": "Tidal volume set (in mL)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  resp_rate_set FLOAT COMMENT '{"description": "Respiratory rate set (in bpm)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  pressure_control_set FLOAT COMMENT '{"description": "Pressure control set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  pressure_support_set FLOAT COMMENT '{"description": "Pressure support set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  flow_rate_set FLOAT COMMENT '{"description": "Flow rate of air delivered to patients on non-invasive devives (in lpm)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  peak_inspiratory_pressure_set FLOAT COMMENT '{"description": "Peak inspiratory pressure set (in cmH2O). This is equivalent to inspiratory positive airway pressure (IPAP) in non-invasive ventilation modes, and is not used in invasive ventilation modes.", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  inspiratory_time_set FLOAT COMMENT '{"description": "Inspiratory time set (in seconds)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  peep_set FLOAT COMMENT '{"description": "Positive-end-expiratory pressure set (in cmH2O)", "permissible": "No restriction, see [Expected _set values for each device_category and mode_category](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/main/outlier-handling/outlier_thresholds_respiratory_support.csv)"}',
  tidal_volume_obs FLOAT COMMENT '{"description": "Observed tidal volume (in mL)", "permissible": "No restriction"}',
  resp_rate_obs FLOAT COMMENT '{"description": "Observed respiratory rate (in bpm), as measured and recorded by the ventilator or non-invasive device. This value should not be pulled from the general vitals table, but should reflect measurements from the respiratory support device itself.", "permissible": "No restriction"}',
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
  measured_dttm DATETIME COMMENT '{"description": "Date and time the vital sign was actually measured at the bedside, which may differ from recorded_dttm when there is a delay between measurement and EHR entry (e.g., manual entry at shift change). Optional -- sites that do not distinguish measurement time from entry time may leave this null. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  vital_name VARCHAR COMMENT '{"description": "Description of the flowsheet measure from the source data. Not used for analysis.", "permissible": "No restriction"}',
  vital_category VARCHAR COMMENT '{"description": "Maps vital_name to a list of standard vital sign categories.", "permissible": "[dbp, heart_rate, height_cm, intracranial_pressure, map, pulse_pressure_variation, respiratory_rate, sbp, spo2, temp_c, weight_kg](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/vitals/clif_vitals_categories.csv)"}',
  vital_value FLOAT COMMENT '{"description": "Recorded value of the vital. Measurement unit should match the vital category.", "permissible": "temp_c = Celsius, height_cm = Centimeters, weight_kg = Kg, map = mmHg, spo2 = %. No unit for heart_rate, sbp, dbp, respiratory_rate"}',
  meas_site_name VARCHAR COMMENT '{"description": "Site where the vital is recorded. Optional field with no associated category.", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: input
-- -----------------------------------------------------
CREATE TABLE input (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the input was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  input_name VARCHAR COMMENT '{"description": "Name of the fluid recorded as patient input.", "permissible": "No restriction"}',
  input_category VARCHAR COMMENT '{"description": "Maps input_name to a set of permissible input categories.", "permissible": "[List of input categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/input/clif_input_category.csv)"}',
  input_group VARCHAR COMMENT '{"description": "Maps input_category to a smaller set of source groups.", "permissible": "[iv_fluids, blood_products, nutrition, medication_fluids, renal_replacement_fluids, flush_irrigation, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/input/clif_input_group.csv)"}',
  input_volume FLOAT COMMENT '{"description": "Volume of input fluid in mL. Must be a positive number.", "permissible": "Numeric. Should not be negative."}'
);

-- -----------------------------------------------------
-- Table: output
-- -----------------------------------------------------
CREATE TABLE output (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the output was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  output_name VARCHAR COMMENT '{"description": "Name of the fluid recorded as patient output.", "permissible": "Examples: urine, SPC output, emesis"}',
  output_category VARCHAR COMMENT '{"description": "Maps output_name to a set of permissible output categories.", "permissible": "[List of output categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/output/clif_output_categories.csv)"}',
  output_group VARCHAR COMMENT '{"description": "Maps output_category to a smaller set of source groups.", "permissible": "[urine, ultrafiltration, drains, gi, procedure, blood_loss, respiratory, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/output/clif_output_groups.csv)"}',
  output_volume FLOAT COMMENT '{"description": "Volume of output fluid in mL. Must be a positive number.", "permissible": "Numeric. Should not be negative."}',
  FOREIGN KEY (hospitalization_id) REFERENCES hospitalization(hospitalization_id)
);

-- -----------------------------------------------------
-- Table: invasive_hemodynamics
-- -----------------------------------------------------
CREATE TABLE invasive_hemodynamics (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time when the device settings and/or measurement was recorded", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  measurement_name VARCHAR COMMENT '{"description": "Source unstandardized raw flowsheet name for invasive hemodynamic measurement", "permissible": "No restriction"}',
  measurement_category VARCHAR COMMENT '{"description": "Individual hemodynamic parameter measurements reported by the device", "permissible": "[cvp, rv_systolic, rv_diastolic, pa_systolic, pa_diastolic, pa_mean, pcwp, cco, cardiac_output_thermodilution, cardiac_index, cardiac_output_fick, stroke_volume, ppv, svv, svi, svr, svri, evlw, evlwi, ef, itbi, gedv, lvswi, tfcd0, tfc, do2](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/invasive_hemodynamics/clif_invasive_hemodynamics_measure_categories.csv)"}',
  measurement_value FLOAT COMMENT '{"description": "Numeric value of the measurement_category", "permissible": "Positive values"}'
);

-- -----------------------------------------------------
-- Table: key_icu_orders
-- -----------------------------------------------------
CREATE TABLE key_icu_orders (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  order_dttm DATETIME COMMENT '{"description": "Date and time when the order was placed. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  order_name VARCHAR COMMENT '{"description": "Name of the specific order from source EHR data (e.g., PT Evaluation, Social Work Consult, Nutrition Consult).", "permissible": "No restriction"}',
  order_category VARCHAR COMMENT '{"description": "Maps order_name to a standardized list of ICU consult/order categories (MIMIC-IV-aligned).", "permissible": "[pt, social_work, ot, nutrition, swallowing, respiratory, interpreter, skin_care, pain_services, addiction_nurse, speech, pastoral_services, palliative_care, psych_liaison_nurse, et_nurse, eeg, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/key_icu_orders/clif_key_icu_orders_categories.csv)"}',
  order_status_category VARCHAR COMMENT '{"description": "Standardized status of the order.", "permissible": "[sent, completed, resulted, canceled](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/key_icu_orders/clif_key_icu_orders_order_status_categories.csv)"}'
);

-- -----------------------------------------------------
-- Table: medication_admin_intermittent
-- -----------------------------------------------------
CREATE TABLE medication_admin_intermittent (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  med_order_id VARCHAR COMMENT '{"description": "Medication order ID. Foreign key to link this table to other medication tables", "permissible": "No restriction"}',
  administering_provider_id VARCHAR COMMENT '{"description": "Uniquely identifies the provider who administered the medication.", "permissible": "No restriction"}',
  admin_dttm DATETIME COMMENT '{"description": "Date and time when the medicine was administered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  med_name VARCHAR COMMENT '{"description": "Original med name string recorded in the raw data which often contains concentration e.g. NOREPInephrine 8 mg/250 mL", "permissible": "No restriction"}',
  med_category VARCHAR COMMENT '{"description": "Maps med_name to a limited set of active ingredients for important ICU medications, e.g. norepinephrine", "permissible": "[List of medication categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv)"}',
  med_group VARCHAR COMMENT '{"description": "Limited number of ICU medication groups identified by the CLIF consortium, e.g. vasoactives", "permissible": "[List of medication groups in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv)"}',
  med_route_name VARCHAR COMMENT '{"description": "Medicine delivery route", "permissible": "e.g. IV, enteral"}',
  med_route_category VARCHAR COMMENT '{"description": "Maps med_route_name to a standardized list of medication delivery routes", "permissible": "[List of intermittent route categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_route_categories.csv)"}',
  med_dose FLOAT COMMENT '{"description": "Quantity taken in dose", "permissible": "Numeric"}',
  med_dose_unit VARCHAR COMMENT '{"description": "Standardized unit of dose for the med_category. Raw doses should be converted into the category-specific unit.", "permissible": "[List of intermittent med_dose_units in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv)"}',
  rx_norm_code VARCHAR COMMENT '{"description": "RxNorm RXCUI code identifying the specific drug formulation (active ingredient, strength, dose form, and route) for this administration. Resolved from the combination of med_name, med_route_name, med_dose, and med_dose_unit.", "permissible": "[RxNorm RXCUI](https://www.nlm.nih.gov/research/umls/rxnorm/index.html)"}',
  mar_action_name VARCHAR COMMENT '{"description": "MAR (medication administration record) action, e.g. stopped", "permissible": "No restriction"}',
  mar_action_category VARCHAR COMMENT '{"description": "Maps mar_action_name to a standardized list of MAR actions", "permissible": "[List of intermittent action categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_action_categories.csv)"}',
  mar_action_group VARCHAR COMMENT '{"description": "Maps mar_action_category to whether the action means the medication was administered or not.", "permissible": "[administered, not_administered, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/medication_admin_intermittent/clif_medication_admin_intermittent_action_categories.csv)"}'
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
  rx_norm_code VARCHAR COMMENT '{"description": "RxNorm RXCUI code identifying the specific drug formulation (active ingredient, strength, dose form, and route) for this order. Resolved from the combination of med_name, med_route_name, med_dose, and med_dose_unit.", "permissible": "[RxNorm RXCUI](https://www.nlm.nih.gov/research/umls/rxnorm/index.html)"}',
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
-- Table: place_based_index
-- -----------------------------------------------------
CREATE TABLE place_based_index (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter", "permissible": "No restriction"}',
  index_name VARCHAR COMMENT '{"description": "The name of the index (e.g., Area Deprivation Index, Social Vulnerability Index).", "permissible": "No restriction"}',
  index_value DOUBLE COMMENT '{"description": "The numerical value of the index for the given hospitalization.", "permissible": "Numeric"}',
  index_version VARCHAR COMMENT '{"description": "Version of the index used (e.g., ADI 2019, SVI 2020).", "permissible": "No restriction"}'
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
-- Table: microbiology_susceptibility
-- -----------------------------------------------------
CREATE TABLE microbiology_susceptibility (
  organism_id VARCHAR COMMENT '{"description": "A key that links microbiology culture table to microbiology susceptibility table", "permissible": "No restriction"}',
  antimicrobial_name VARCHAR COMMENT '{"description": "Name of the antimicrobial", "permissible": "No restriction"}',
  antimicrobial_category VARCHAR COMMENT '{"description": "Category or class of the antimicrobial tested", "permissible": "[List of antimicrobial categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_susceptibility/clif_microbiology_susceptibility_antibiotics_category.csv)"}',
  sensitivity_name VARCHAR COMMENT '{"description": "Name of the test result used to determine susceptibility (e.g., value of mcg/mL or MIC)", "permissible": "No restriction"}',
  susceptibility_name VARCHAR COMMENT '{"description": "Name of the sensitivity interpretation", "permissible": "No restriction"}',
  susceptibility_category VARCHAR COMMENT '{"description": "Standardized category of susceptibility.", "permissible": "[susceptible, non_susceptible, indeterminate, na](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/microbiology_susceptibility/clif_microbiology_susceptibility_category.csv)"}'
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
  component_category VARCHAR COMMENT '{"description": "Maps component_name to a standardized list of blood component categories.", "permissible": "[cryoprecipitate, plasma, platelets, prbc, whole_blood](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/transfusion/clif_transfusion_component_categories.csv)"}',
  attribute_name VARCHAR COMMENT '{"description": "Attributes describing modifications to the component.", "permissible": "E.g., Leukocyte Reduced, Irradiated"}',
  volume_transfused DOUBLE COMMENT '{"description": "The volume of the blood component transfused.", "permissible": "Numeric, e.g., 300"}',
  volume_unit VARCHAR COMMENT '{"description": "The unit of measurement for the transfused volume.", "permissible": "E.g., mL"}',
  product_code VARCHAR COMMENT '{"description": "ISBT 128 Product Description Code representing the specific blood product.", "permissible": "E.g., E0382"}'
);

-- -----------------------------------------------------
-- Table: clinical_trial
-- -----------------------------------------------------
CREATE TABLE clinical_trial (
  participant_id VARCHAR COMMENT '{"description": "Unique identifier for each clinical trial participant from clinical trial management software, used for pipelines to electronic data capture software. NOT the same as patient_id", "permissible": "No restriction"}',
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient, presumed to be a distinct individual.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  trial_id VARCHAR COMMENT '{"description": "Unique identifier for the clinical trial (e.g., institutional trial ID, NCT number).", "permissible": "No restriction"}',
  trial_name VARCHAR COMMENT '{"description": "Descriptive name of the clinical trial.", "permissible": "No restriction"}',
  arm_id VARCHAR COMMENT '{"description": "Identifier indicating which arm of the trial the participant was enrolled in.", "permissible": "No restriction"}',
  consent_dttm DATETIME COMMENT '{"description": "Timestamp of participant consent for the clinical trial. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  enrollment_dttm DATETIME COMMENT '{"description": "Timestamp of participant enrollment in the clinical trial. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  randomized_dttm DATETIME COMMENT '{"description": "Timestamp of participant randomization in the clinical trial. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  withdrawal_dttm DATETIME COMMENT '{"description": "Timestamp of trial withdrawal if applicable. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}'
);

-- -----------------------------------------------------
-- Table: clinical_notes_facts
-- -----------------------------------------------------
CREATE TABLE clinical_notes_facts (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  provider_id VARCHAR COMMENT '{"description": "Unique identifier for the authoring provider.", "permissible": "No restriction"}',
  note_id VARCHAR COMMENT '{"description": "Source note identifier from the EHR system.", "permissible": "No restriction"}',
  note_type VARCHAR COMMENT '{"description": "Note type code from the source data (e.g., Progress Note, Discharge Summary, H&P).", "permissible": "No restriction"}',
  note_type_category VARCHAR COMMENT '{"description": "Maps note_type to a standardized list of note type categories.", "permissible": "[h_and_p_note, progress_note, consult_note, procedure_note, discharge_summary, transfer_note, therapy_note, nutrition_note, pharmacy_note, nursing_note, case_management_note, death_pronouncement, patient_instructions](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/clinical_notes_facts/clif_clinical_notes_facts_note_type_categories.csv)"}',
  note_status VARCHAR COMMENT '{"description": "Status of the note at the time of this revision.", "permissible": "signed, addendum, incomplete, co-signed"}',
  cosigner_specialty VARCHAR COMMENT '{"description": "Specialty of the co-signing provider, if applicable (e.g., Attending co-signing a resident note).", "permissible": "No restriction"}',
  note_author_specialty VARCHAR COMMENT '{"description": "Specialty of the note author (e.g., Critical Care, Infectious Diseases, Physical Therapy). Useful for distinguishing note provenance such as PT/OT notes from physician notes.", "permissible": "No restriction"}',
  revision_id VARCHAR COMMENT '{"description": "Unique revision identifier, rank-ordered per (hospitalization_id, note_id) by revision_dttm.", "permissible": "No restriction"}',
  creation_dttm DATETIME COMMENT '{"description": "Date and time when the note was first created. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  revision_dttm DATETIME COMMENT '{"description": "Timestamp of this specific revision. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  service_date DATE COMMENT '{"description": "Date of service associated with this note. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
);

-- -----------------------------------------------------
-- Table: clinical_notes_text
-- -----------------------------------------------------
CREATE TABLE clinical_notes_text (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  note_id VARCHAR COMMENT '{"description": "Source note identifier. Foreign key to clinical_notes_facts.", "permissible": "No restriction"}',
  revision_id VARCHAR COMMENT '{"description": "Matches clinical_notes_facts.revision_id for revision-level join.", "permissible": "No restriction"}',
  note_text VARCHAR COMMENT '{"description": "Full concatenated note text for this revision.", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: validated_diagnosis
-- -----------------------------------------------------
CREATE TABLE validated_diagnosis (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  diagnosis_name VARCHAR COMMENT '{"description": "Free-text name of the diagnosis (clinician-entered or source name).", "permissible": "No restriction"}',
  diagnosis_category VARCHAR COMMENT '{"description": "Maps diagnosis_name to a standardized list of diagnosis categories.", "permissible": "e.g., sepsis, arf, aki, stroke, etc."}',
  diagnosis_start_dttm DATETIME COMMENT '{"description": "Date and time when the diagnosis is deemed clinically active.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  diagnosis_end_dttm DATETIME COMMENT '{"description": "Date and time when the diagnosis was resolved or deemed no longer active (optional).", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  validation_method VARCHAR COMMENT '{"description": "Method of clinician validation used for this label.", "permissible": "manual_chart_review, consensus_panel, automated_with_review"}',
  diagnosis_status VARCHAR COMMENT '{"description": "Final reviewer determination.", "permissible": "confirmed, ruled_out, uncertain"}',
  reviewer_id VARCHAR COMMENT '{"description": "Anonymized ID of the clinician or reviewer responsible for this label.", "permissible": "No restriction"}',
  review_timestamp DATETIME COMMENT '{"description": "Time when the label was finalized or adjudicated.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}'
);

-- -----------------------------------------------------
-- Table: model_registry
-- -----------------------------------------------------
CREATE TABLE model_registry (
  model_id VARCHAR COMMENT '{"description": "Unique identifier for a scoring model. Site-assigned. Primary key referenced by scores.model_id.", "permissible": "No restriction"}',
  model_name VARCHAR COMMENT '{"description": "Raw model name as it appears in the source EHR system, e.g. \"IP Deterioration Index\".", "permissible": "No restriction"}',
  model_category VARCHAR COMMENT '{"description": "Maps model_name to a standardized CLIF controlled vocabulary entry in vendor_modelname snake_case form (e.g., epic_deterioration_index, epic_mortality, rush_palliative_care). Official threshold tiers (where applicable) are documented as remarks in this mCIDE list rather than as columns.", "permissible": "WIP"}',
  model_version VARCHAR COMMENT '{"description": "Vendor- or site-assigned version string for the model deployment, e.g. \"0.0.2\".", "permissible": "No restriction"}',
  release_date DATE COMMENT '{"description": "Date the model version was first deployed at the site (optional / nullable).", "permissible": "Date format YYYY-MM-DD"}',
  is_live BOOLEAN COMMENT '{"description": "Whether this model version is currently firing live alerts to clinicians at the site (TRUE) or running silently / shadow-mode (FALSE). Sites should retain historical rows for retired versions and flag the active deployment.", "permissible": "TRUE or FALSE"}'
);

-- -----------------------------------------------------
-- Table: scores
-- -----------------------------------------------------
CREATE TABLE scores (
  model_id VARCHAR COMMENT '{"description": "Foreign key to model_registry.model_id identifying which scoring model produced this row.", "permissible": "No restriction"}',
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time the score was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  score_value DOUBLE COMMENT '{"description": "Numeric score value emitted by the model at recorded_dttm. Threshold-based alert categories (e.g., yellow/red) are not stored on this row -- consumers derive them per project from configuration or from mCIDE remarks on the model_category.", "permissible": "Numeric"}',
  FOREIGN KEY (model_id) REFERENCES model_registry(model_id),
  FOREIGN KEY (hospitalization_id) REFERENCES hospitalization(hospitalization_id)
);

-- -----------------------------------------------------
-- Table: radiology
-- -----------------------------------------------------
CREATE TABLE radiology (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient. Foreign key to patient.patient_id.", "permissible": "No restriction"}',
  radiology_accession VARCHAR COMMENT '{"description": "Accession number for the radiology study. Unique per study within a site.", "permissible": "No restriction"}',
  radiology_order_dttm DATETIME COMMENT '{"description": "Date and time the radiology study was ordered. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  radiology_capture_dttm DATETIME COMMENT '{"description": "Date and time the images were acquired. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  radiology_report_dttm DATETIME COMMENT '{"description": "Date and time the final radiology report was signed. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  radiology_order_name VARCHAR COMMENT '{"description": "Source-system exam name as ordered (e.g., CT CHEST W CONTRAST).", "permissible": "No restriction"}',
  radiology_modality_category VARCHAR COMMENT '{"description": "Imaging modality. Maps source-system modality codes to a standardized list.", "permissible": "[List of radiology modality categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/radiology/clif_radiology_modality_categories.csv)"}',
  radiology_region_category VARCHAR COMMENT '{"description": "Anatomic region imaged. Maps order-name fragments to a standardized list.", "permissible": "[List of radiology region categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/radiology/clif_radiology_region_categories.csv)"}',
  iv_contrast_category VARCHAR COMMENT '{"description": "IV contrast administration status for the study.", "permissible": "[List of IV contrast categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/radiology/clif_radiology_iv_contrast_categories.csv)"}',
  radiology_location_category VARCHAR COMMENT '{"description": "Where the study was performed (department vs portable/bedside).", "permissible": "[List of radiology location categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/radiology/clif_radiology_location_categories.csv)"}',
  radiology_report_text VARCHAR COMMENT '{"description": "Final radiology report narrative text.", "permissible": "No restriction"}',
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- -----------------------------------------------------
-- Table: line
-- -----------------------------------------------------
CREATE TABLE line (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  line_id VARCHAR COMMENT '{"description": "Per-event identifier for the line placement. Together with hospitalization_id, forms the composite key. Maps to the Epic LDA ID where applicable.", "permissible": "No restriction"}',
  placed_dttm DATETIME COMMENT '{"description": "Date and time the line was placed. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  removed_dttm DATETIME COMMENT '{"description": "Date and time the line was removed, NULL if still in place. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  line_category VARCHAR COMMENT '{"description": "Standardized line type.", "permissible": "[cvc, art_line, picc, midline, dialysis_catheter, swan_ganz, cordis, piv](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/line/clif_line_categories.csv)"}',
  line_site VARCHAR COMMENT '{"description": "Standardized anatomic site where the line was placed.", "permissible": "[right_ij, left_ij, right_subclavian, left_subclavian, right_femoral, left_femoral, right_radial, left_radial, right_brachial, left_brachial, other](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/line/clif_line_sites.csv)"}',
  lumen_count INT COMMENT '{"description": "Number of lumens on the line.", "permissible": "Numeric"}'
);

-- -----------------------------------------------------
-- Table: drain
-- -----------------------------------------------------
CREATE TABLE drain (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  drain_id VARCHAR COMMENT '{"description": "Per-event identifier for the drain placement. Together with hospitalization_id, forms the composite key. Maps to the Epic LDA ID where applicable.", "permissible": "No restriction"}',
  placed_dttm DATETIME COMMENT '{"description": "Date and time the drain was placed. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  removed_dttm DATETIME COMMENT '{"description": "Date and time the drain was removed, NULL if still in place. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  drain_category VARCHAR COMMENT '{"description": "Standardized drain type.", "permissible": "[chest_tube, foley, jp_drain, eud, evd, pigtail, ng_tube, og_tube, peg_tube, dobhoff](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/drain/clif_drain_categories.csv)"}',
  anatomical_location VARCHAR COMMENT '{"description": "Anatomic location where the drain was placed.", "permissible": "No restriction"}'
);

-- -----------------------------------------------------
-- Table: airway
-- -----------------------------------------------------
CREATE TABLE airway (
  hospitalization_id VARCHAR COMMENT '{"description": "ID variable for each patient encounter.", "permissible": "No restriction"}',
  airway_id VARCHAR COMMENT '{"description": "Per-event identifier for the airway placement. Together with hospitalization_id, forms the composite key. Maps to the Epic LDA ID where applicable.", "permissible": "No restriction"}',
  placed_dttm DATETIME COMMENT '{"description": "Date and time the airway was placed. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  removed_dttm DATETIME COMMENT '{"description": "Date and time the airway was removed, NULL if still in place. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  airway_category VARCHAR COMMENT '{"description": "Standardized airway type.", "permissible": "[ett, trach, npa, opa](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/airway/clif_airway_categories.csv)"}',
  airway_size FLOAT COMMENT '{"description": "Size of the airway device (e.g., 6.0, 7.5).", "permissible": "Numeric"}',
  is_cuffed INT COMMENT '{"description": "Whether the airway is cuffed.", "permissible": "0, 1"}'
);

-- -----------------------------------------------------
-- Table: patient_attributes
-- -----------------------------------------------------
CREATE TABLE patient_attributes (
  patient_id VARCHAR COMMENT '{"description": "Unique identifier for each patient. Foreign key to patient.patient_id.", "permissible": "No restriction"}',
  recorded_dttm DATETIME COMMENT '{"description": "Date and time the attribute value was recorded. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  attribute_name VARCHAR COMMENT '{"description": "Unstandardized attribute name as recorded in the source EHR, e.g., the flowsheet item name.", "permissible": "No restriction"}',
  attribute_category VARCHAR COMMENT '{"description": "Standardized attribute category. Identifies which patient attribute this row describes, e.g., smoking_status, housing_status, marital_status.", "permissible": "[List of attribute categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient_attributes/clif_patient_attributes_attribute_categories.csv)"}',
  attribute_group VARCHAR COMMENT '{"description": "Rollup family for attribute_category. One group per category, e.g., housing_status maps to health_related_social_needs.", "permissible": "[List of attribute groups in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient_attributes/clif_patient_attributes_attribute_groups.csv)"}',
  attribute_value_name VARCHAR COMMENT '{"description": "Unstandardized attribute value as recorded in the source EHR.", "permissible": "No restriction"}',
  attribute_value_category VARCHAR COMMENT '{"description": "Standardized attribute value. Permissible values are CONDITIONAL on attribute_category — for example, smoking_status accepts current/former/never/unknown while housing_status accepts housed/unstable/undomiciled/unknown. See the patient_attributes markdown section for the full conditional mapping.", "permissible": "[List of attribute value categories in CLIF (union across all attribute_categories)](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/patient_attributes/clif_patient_attributes_attribute_value_categories.csv)"}',
  FOREIGN KEY (patient_id) REFERENCES patient(patient_id)
);

-- -----------------------------------------------------
-- Table: ed_encounter
-- -----------------------------------------------------
CREATE TABLE ed_encounter (
  hospitalization_id VARCHAR COMMENT '{"description": "Foreign key to hospitalization. Links the ED encounter to its parent hospitalization.", "permissible": "No restriction"}',
  ed_encounter_id VARCHAR COMMENT '{"description": "Site-generated unique identifier for the ED encounter. Together with hospitalization_id, identifies the row.", "permissible": "No restriction"}',
  ed_arrival_dttm DATETIME COMMENT '{"description": "Date and time the patient arrived in the ED. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  ed_departure_dttm DATETIME COMMENT '{"description": "Date and time the patient left the ED. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  arrival_mode_name VARCHAR COMMENT '{"description": "Unstandardized arrival mode string as recorded in the source EHR.", "permissible": "No restriction"}',
  arrival_mode_category VARCHAR COMMENT '{"description": "Standardized arrival mode at ED presentation.", "permissible": "[List of arrival mode categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/ed_encounter/clif_ed_encounter_arrival_mode_categories.csv)"}',
  triage_system_name VARCHAR COMMENT '{"description": "Unstandardized name or version of the triage system used at this site, as recorded in the source EHR.", "permissible": "No restriction"}',
  triage_system_category VARCHAR COMMENT '{"description": "Standardized triage system class. esi = Emergency Severity Index, ctas = Canadian Triage and Acuity Scale.", "permissible": "[List of triage system categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/ed_encounter/clif_ed_encounter_triage_system_categories.csv)"}',
  triage_acuity_name VARCHAR COMMENT '{"description": "Unstandardized triage score or level as recorded in the source EHR (e.g., \"2 - Emergent\").", "permissible": "No restriction"}',
  triage_acuity_category VARCHAR COMMENT '{"description": "Standardized 5-level acuity class derived from triage_acuity_name. level_1 is highest acuity, level_5 is lowest.", "permissible": "[List of triage acuity categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/ed_encounter/clif_ed_encounter_triage_acuity_categories.csv)"}',
  triage_dttm DATETIME COMMENT '{"description": "Date and time of initial ED triage assessment. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  chief_complaint_name VARCHAR COMMENT '{"description": "Unstandardized chief complaint text as recorded in the source EHR.", "permissible": "No restriction"}',
  ed_disposition_name VARCHAR COMMENT '{"description": "Unstandardized ED disposition string or code as recorded in the source EHR.", "permissible": "No restriction"}',
  ed_disposition_category VARCHAR COMMENT '{"description": "Standardized final ED disposition. lwbs = left without being seen, ama = against medical advice.", "permissible": "[List of ED disposition categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/ed_encounter/clif_ed_encounter_ed_disposition_categories.csv)"}',
  ed_disposition_dttm DATETIME COMMENT '{"description": "Date and time of the final ED disposition decision. All datetime variables must be timezone-aware and set to UTC.", "permissible": "Datetime format should be YYYY-MM-DD HH:MM:SS+00:00 (UTC)"}',
  ed_destination_name VARCHAR COMMENT '{"description": "Unstandardized destination text or code recording where the patient went after the ED.", "permissible": "No restriction"}',
  ed_destination_category VARCHAR COMMENT '{"description": "Standardized destination after the ED. Aligned with hospitalization.discharge_category permissibles so post-ED transitions and final hospital outcomes share a vocabulary.", "permissible": "[List of ED destination categories in CLIF](https://github.com/Common-Longitudinal-ICU-data-Format/CLIF/blob/3.0/mCIDE/ed_encounter/clif_ed_encounter_ed_destination_categories.csv)"}',
  ed_observation_status INT COMMENT '{"description": "Binary indicator for whether the encounter went through an ED observation pathway (1 = yes, 0 = no). Derived metrics such as observation duration should be computed downstream from timestamps rather than stored here.", "permissible": "0, 1"}',
  FOREIGN KEY (hospitalization_id) REFERENCES hospitalization(hospitalization_id)
);
