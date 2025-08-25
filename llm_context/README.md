# CLIF Data Dictionary for LLM Context

This directory contains YAML data dictionaries for CLIF (Common Longitudinal ICU data Format) that can be used as context for Large Language Models (LLMs) and custom GPTs.

## Files

- `clif_2_0_data_dict.yaml` - Data dictionary for CLIF version 2.0
- `clif_2_1_data_dict.yaml` - Data dictionary for CLIF version 2.1
- `generate_data_dictionary.py` - Script to generate data dictionaries from DDL and mCIDE files
- `generate_changelog.py` - Script to compare two data dictionaries and generate changelog
- `changelog_2_0_to_2_1.yaml` - Example changelog comparing CLIF 2.0 to 2.1

## Structure

Each YAML file contains a structured representation of all CLIF tables and their variables, including:

- **Variable names** - Column names in each table
- **Data types** - String, numeric, datetime, categorical, etc.
- **Descriptions** - Detailed descriptions of each variable
- **Categorical values** - Permissible values for categorical variables sourced from mCIDE (mapping Common Data Elements)

## Example Structure

```yaml
tables:
  patient:
    variables:
      - name: patient_id
        type: string
        description: Unique identifier for each patient
      - name: race_category
        type: categorical
        description: A standardized CDE description of patient's race per the US Census
        values:
          - Black or African American
          - White
          - American Indian or Alaska Native
          - Asian
          - Native Hawaiian or Other Pacific Islander
          - Unknown
          - Other
  vitals:
    variables:
      - name: hospitalization_id
        type: string
        description: ID variable for each patient encounter
      - name: vital_category
        type: categorical
        description: Maps vital_name to a list of standard vital sign categories
        values:
          - temp_c
          - heart_rate
          - sbp
          - dbp
          - spo2
          - respiratory_rate
          - map
          - height_cm
          - weight_kg
```

## Generation

These files are automatically generated using the `generate_data_dictionary.py` script located in this directory, which:

1. Parses the CLIF DDL SQL files from the `../ddl/` directory
2. Extracts table and column information with descriptions
3. Maps categorical values from the `../mCIDE` directory
4. Outputs structured YAML for LLM consumption

To regenerate (run from the `llm_context` directory):

```bash
cd llm_context

# For CLIF 2.0
python generate_data_dictionary.py --sql ../ddl/2.0/CLIF2.0_MYSQL_ddl.sql --mcide-dir ../mCIDE --output clif_2_0_data_dict.yaml

# For CLIF 2.1  
python generate_data_dictionary.py --sql ../ddl/2.1/CLIF2.1_MYSQL_ddl.sql --mcide-dir ../mCIDE --output clif_2_1_data_dict.yaml
```

### Changelog Generation

To generate a changelog comparing two data dictionary versions:

```bash
python generate_changelog.py --old clif_2_0_data_dict.yaml --new clif_2_1_data_dict.yaml --output changelog_2_0_to_2_1.yaml
```

## Changelog Structure

The generated changelog YAML contains:

- **Metadata**: Generation timestamp, file comparison info, versions, and status change details
- **Summary**: High-level counts of tables added, removed, modified, and status changes:
  - `concept_to_beta`: Tables that moved from concept to beta status
  - `beta_to_concept`: Tables that moved from beta to concept status
- **Changes**: Detailed breakdown for each table including:
  - `variables_added`: New variables in the table
  - `variables_removed`: Variables removed from the table  
  - `variables_modified`: Variables with changed types, descriptions, or categorical values
  - `old_status`/`new_status`: Table classification changes (concept/beta)

Example changelog structure:
```yaml
metadata:
  generated_at: '2025-08-25T14:33:45.366569'
  comparison:
    old_version: '2.0'
    new_version: '2.1'
  status_changes:
    concept_to_beta_count: 5
    concept_to_beta_details:
    - table: ecmo_mcs
      old_status: concept
      new_status: beta
summary:
  tables_modified: ['adt', 'respiratory_support']
  concept_to_beta: ['ecmo_mcs', 'crrt_therapy', ...]
  total_changes: 8
changes:
  adt:
    change_type: table_modified
    description: 'Table "adt" modified: 1 variables added'
    variables_added:
    - name: location_type
      type: categorical
      values: ['general_icu', 'cardiac_icu', ...]
  ecmo_mcs:
    change_type: table_status_changed
    old_status: concept
    new_status: beta
```

### Table Status Classifications

The changelog generator automatically detects table status changes by parsing comments in the YAML files:
- `table_name: #concept` - Indicates a concept-level table
- `table_name: #beta` - Indicates a beta-level table

Status transitions tracked:
- 📈 **Concept → Beta**: Tables promoted from concept to beta status
- 📉 **Beta → Concept**: Tables moved back from beta to concept status

## Usage

These YAML files can be used to provide LLMs with comprehensive context about the CLIF data format, enabling them to:

- Answer questions about available data fields
- Suggest appropriate analyses based on available variables
- Help with data mapping and ETL processes
- Validate data quality and categorical values
- Generate code for working with CLIF data

