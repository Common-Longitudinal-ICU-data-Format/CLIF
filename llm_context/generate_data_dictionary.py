#!/usr/bin/env python3
"""
CLIF Data Dictionary Generator

This script parses CLIF DDL SQL files and mCIDE mapping files to generate
YAML data dictionaries for use with custom GPTs and other LLM applications.

Usage:
    python generate_data_dictionary.py --sql <sql_file> --mcide-dir <mcide_dir> --output <output_file>

Example:
    python generate_data_dictionary.py --sql ../ddl/2.0/CLIF2.0_MYSQL_ddl.sql --mcide-dir ../mCIDE --output clif_2_0_data_dict.yaml
"""

import argparse
import re
import json
import os
import csv
import yaml
from typing import Dict, List, Any, Optional, Set
from pathlib import Path


class CLIFDataDictionaryGenerator:
    def __init__(self, sql_file: str, mcide_dir: str):
        self.sql_file = sql_file
        self.mcide_dir = Path(mcide_dir)
        self.tables = {}
        self.mcide_mappings = {}
        
    def load_mcide_mappings(self) -> None:
        """Load all mCIDE CSV files into memory for categorical value lookups."""
        print("Loading mCIDE mappings...")
        
        # Map common table/field names to their mCIDE file paths
        mcide_files = {
            'patient_race_categories': 'patient/clif_patient_race_categories.csv',
            'patient_ethnicity_categories': 'patient/clif_patient_ethinicity_categories.csv', 
            'patient_sex_categories': 'patient/clif_patient_sex_categories.csv',
            'patient_language_categories': 'patient/clif_patient_language_categories.csv',
            'vitals_categories': 'vitals/clif_vitals_categories.csv',
            'lab_categories': 'labs/clif_lab_categories.csv',
            'lab_order_categories': 'labs/clif_labs_order_categories.csv',
            'adt_location_categories': 'adt/clif_adt_location_categories.csv',
            'adt_location_type': 'adt/clif_adt_location_type.csv',
            'adt_hospital_type': 'adt/clif_adt_hospital_type.csv',
            'respiratory_device_categories': 'respiratory_support/clif_respiratory_support_device_categories.csv',
            'respiratory_mode_categories': 'respiratory_support/clif_respiratory_support_mode_categories.csv',
            'medication_continuous_categories': 'medication_admin_continuous/clif_medication_admin_continuous_med_categories.csv',
            'medication_intermittent_categories': 'medication_admin_intermittent/clif_medication_admin_intermittent_med_categories.csv',
            'microbiology_culture_fluid_categories': 'microbiology_culture/clif_microbiology_culture_fluid_categories.csv',
            'microbiology_culture_method_categories': 'microbiology_culture/clif_microbiology_culture_method_categories.csv',
            'microbiology_culture_organism_categories': 'microbiology_culture/clif_microbiology_culture_organism_categories.csv',
            'microbiology_culture_organism_groups': 'microbiology_culture/clif_microbiology_culture_organism_groups.csv',
            'hospitalization_admission_type_categories': 'hospitalization/clif_hospitalization_admission_type_categories.csv',
            'hospitalization_discharge_categories': 'hospitalization/clif_hospitalization_discharge_categories.csv',
            'code_status_categories': 'code_status/clif_code_status_categories.csv',
            'crrt_therapy_mode_categories': 'crrt_therapy/clif_crrt_therapy_mode_categories.csv',
            'ecmo_mcs_groups': 'ecmo/clif_ecmo_mcs_groups.csv',
            'invasive_hemodynamics_measure_categories': 'invasive_hemodynamics/clif_invasive_hemodynamics_measure_categories.csv',
            'key_icu_orders_categories': 'key_icu_orders/clif_key_icu_orders_categories.csv',
            'patient_assessment_categories': 'patient_assessments/clif_patient_assessment_categories.csv',
            'position_categories': 'postion/clif_position_categories.csv',  # Note: typo in original directory name
            'microbiology_nonculture_fluid_category': 'microbiology_nonculture/clif_microbiology_nonculture_fluid_category.csv',
            'microbiology_nonculture_method_category': 'microbiology_nonculture/clif_microbiology_nonculture_method_category.csv',
            'microbiology_nonculture_result_category': 'microbiology_nonculture/clif_microbiology_nonculture_result_category.csv',
            'microbiology_susceptibility_antibiotics_category': 'microbiology_susceptibility/clif_microbiology_susceptibility_antibiotics_category.csv',
            'microbiology_susceptibility_category': 'microbiology_susceptibility/clif_microbiology_susceptibility_category.csv'
        }
        
        for key, file_path in mcide_files.items():
            full_path = self.mcide_dir / file_path
            if full_path.exists():
                self.mcide_mappings[key] = self._load_csv_values(full_path)
            else:
                print(f"Warning: mCIDE file not found: {full_path}")
                
    def _load_csv_values(self, file_path: Path) -> List[str]:
        """Load values from a CSV file, handling different column structures."""
        values = []
        try:
            with open(file_path, 'r', encoding='utf-8') as f:
                reader = csv.DictReader(f)
                for row in reader:
                    # Get the first column value (usually the category column)
                    first_col = next(iter(row.values()))
                    if first_col and first_col.strip():
                        values.append(first_col.strip())
        except Exception as e:
            print(f"Error reading {file_path}: {e}")
        return values
        
    def parse_sql_comment(self, comment: str) -> Dict[str, Any]:
        """Parse JSON comment from SQL DDL."""
        try:
            # Remove COMMENT ' and trailing '
            comment = comment.replace("COMMENT '", "").rstrip("'")
            return json.loads(comment)
        except (json.JSONDecodeError, ValueError):
            return {"description": comment, "permissible": "No restriction"}
            
    def extract_permissible_values(self, permissible) -> Optional[List[str]]:
        """Extract categorical values from permissible field."""
        if not permissible or permissible == "No restriction":
            return None
            
        # Handle case where permissible is already a list
        if isinstance(permissible, list):
            return [str(v) for v in permissible if v]
            
        # Convert to string if needed
        permissible = str(permissible)
            
        # Handle array-style permissible values like ["Male", "Female", "Unknown"]
        if permissible.startswith('[') and permissible.endswith(']'):
            try:
                # Parse the array string
                values_str = permissible.strip('[]')
                values = [v.strip(' "') for v in values_str.split(',')]
                return [v for v in values if v]
            except:
                pass
                
        # Handle comma-separated values
        if ',' in permissible and not permissible.startswith('http'):
            values = [v.strip() for v in permissible.split(',')]
            return [v for v in values if v and not v.startswith('http')]
            
        return None
        
    def get_mcide_values(self, table_name: str, field_name: str) -> Optional[List[str]]:
        """Get categorical values from mCIDE mappings based on table and field name."""
        # Map field names to mCIDE keys
        field_mappings = {
            'race_category': 'patient_race_categories',
            'ethnicity_category': 'patient_ethnicity_categories', 
            'sex_category': 'patient_sex_categories',
            'language_category': 'patient_language_categories',
            'vital_category': 'vitals_categories',
            'lab_category': 'lab_categories',
            'lab_order_category': 'lab_order_categories',
            'location_category': 'adt_location_categories',
            'location_type': 'adt_location_type',
            'hospital_type': 'adt_hospital_type',
            'device_category': 'respiratory_device_categories',
            'mode_category': 'respiratory_mode_categories',
            'med_category': 'medication_continuous_categories',
            'fluid_category': 'microbiology_culture_fluid_categories',
            'method_category': 'microbiology_culture_method_categories',
            'organism_category': 'microbiology_culture_organism_categories',
            'organism_group': 'microbiology_culture_organism_groups',
            'admission_type_category': 'hospitalization_admission_type_categories',
            'discharge_category': 'hospitalization_discharge_categories',
            'code_status_category': 'code_status_categories',
            'crrt_mode_category': 'crrt_therapy_mode_categories',
            'mcs_group': 'ecmo_mcs_groups',
            'measure_category': 'invasive_hemodynamics_measure_categories',
            'order_category': 'key_icu_orders_categories',
            'assessment_category': 'patient_assessment_categories',
            'position_category': 'position_categories'
        }
        
        mcide_key = field_mappings.get(field_name)
        if mcide_key and mcide_key in self.mcide_mappings:
            return self.mcide_mappings[mcide_key]
            
        return None
        
    def determine_field_type(self, sql_type: str, field_name: str, comment_data: Dict) -> str:
        """Determine the YAML field type based on SQL type and context."""
        sql_type = sql_type.upper()
        
        if 'DATETIME' in sql_type or 'TIMESTAMP' in sql_type:
            return 'datetime'
        elif 'DATE' in sql_type:
            return 'date' if 'birth_date' in field_name else 'datetime'
        elif 'INT' in sql_type or 'FLOAT' in sql_type or 'DOUBLE' in sql_type or 'DECIMAL' in sql_type:
            return 'numeric'
        elif 'BOOL' in sql_type:
            return 'boolean'
        else:
            return 'string'
            
    def parse_sql_file(self) -> None:
        """Parse the SQL DDL file to extract table and column information."""
        print(f"Parsing SQL file: {self.sql_file}")
        
        with open(self.sql_file, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Split content by table creation statements
        table_patterns = re.findall(r'CREATE TABLE (\w+) \((.*?)\);', content, re.DOTALL | re.IGNORECASE)
        
        for table_name, table_content in table_patterns:
            if table_name == 'medication_admin_intermittent':
                # Skip placeholder table
                continue
                
            print(f"Processing table: {table_name}")
            self.tables[table_name] = {'variables': []}
            
            # Extract column definitions
            column_pattern = r"(\w+)\s+(\w+(?:\([^)]+\))?)\s+COMMENT\s+'([^']+)'"
            columns = re.findall(column_pattern, table_content, re.IGNORECASE)
            
            for col_name, col_type, comment in columns:
                comment_data = self.parse_sql_comment(comment)
                field_type = self.determine_field_type(col_type, col_name, comment_data)
                
                variable = {
                    'name': col_name,
                    'type': field_type,
                    'description': comment_data.get('description', '')
                }
                
                # Check for categorical values
                permissible = comment_data.get('permissible', '')
                categorical_values = self.extract_permissible_values(permissible)
                
                # If no values found in permissible, check mCIDE mappings
                if not categorical_values:
                    categorical_values = self.get_mcide_values(table_name, col_name)
                
                if categorical_values:
                    variable['type'] = 'categorical'
                    variable['values'] = categorical_values
                    
                self.tables[table_name]['variables'].append(variable)
                
    def generate_yaml(self) -> Dict[str, Any]:
        """Generate the YAML structure."""
        return {'tables': self.tables}
        
    def save_yaml(self, output_file: str) -> None:
        """Save the data dictionary as YAML."""
        yaml_data = self.generate_yaml()
        
        with open(output_file, 'w', encoding='utf-8') as f:
            yaml.dump(yaml_data, f, default_flow_style=False, sort_keys=False, allow_unicode=True)
            
        print(f"Data dictionary saved to: {output_file}")
        
    def generate(self, output_file: str) -> None:
        """Main generation process."""
        print("Starting CLIF data dictionary generation...")
        self.load_mcide_mappings()
        self.parse_sql_file()
        self.save_yaml(output_file)
        print("Generation complete!")


def main():
    parser = argparse.ArgumentParser(description='Generate CLIF data dictionary YAML files')
    parser.add_argument('--sql', required=True, help='Path to CLIF SQL DDL file')
    parser.add_argument('--mcide-dir', required=True, help='Path to mCIDE directory')
    parser.add_argument('--output', required=True, help='Output YAML file path')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.sql):
        print(f"Error: SQL file not found: {args.sql}")
        return 1
        
    if not os.path.exists(args.mcide_dir):
        print(f"Error: mCIDE directory not found: {args.mcide_dir}")
        return 1
        
    # Ensure output directory exists
    output_dir = os.path.dirname(args.output)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)
    
    generator = CLIFDataDictionaryGenerator(args.sql, args.mcide_dir)
    generator.generate(args.output)
    
    return 0


if __name__ == '__main__':
    exit(main())
