#!/usr/bin/env python3
"""
CLIF Data Dictionary Changelog Generator

This script compares two CLIF data dictionary YAML files and generates
a changelog documenting the differences between versions.

Usage:
    python generate_changelog.py --old <old_file> --new <new_file> --output <output_file>

Example:
    python generate_changelog.py --old clif_2_0_data_dict.yaml --new clif_2_1_data_dict.yaml --output changelog_2_0_to_2_1.yaml
"""

import argparse
import yaml
import os
import re
from typing import Dict, List, Any, Set
from datetime import datetime


class CLIFChangelogGenerator:
    def __init__(self, old_file: str, new_file: str):
        self.old_file = old_file
        self.new_file = new_file
        self.old_data = {}
        self.new_data = {}
        self.old_table_classifications = {}
        self.new_table_classifications = {}
        self.changelog = {
            'metadata': {},
            'summary': {
                'tables_added': [],
                'tables_removed': [],
                'tables_modified': [],
                'tables_status_changed': [],
                'concept_to_beta': [],
                'beta_to_concept': [],
                'total_changes': 0
            },
            'changes': {}
        }
        
    def parse_table_classifications(self, file_path: str) -> Dict[str, str]:
        """Parse table classifications from YAML comments."""
        classifications = {}
        
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
            
        # Look for patterns like "  table_name: #beta" or "  table_name: #concept"
        pattern = r'^\s+(\w+):\s*#(beta|concept)'
        
        for line in content.split('\n'):
            match = re.match(pattern, line)
            if match:
                table_name = match.group(1)
                classification = match.group(2)
                classifications[table_name] = classification
                
        return classifications

    def load_data_dictionaries(self):
        """Load both YAML data dictionaries and parse table classifications."""
        print(f"Loading old file: {self.old_file}")
        with open(self.old_file, 'r', encoding='utf-8') as f:
            self.old_data = yaml.safe_load(f)
        self.old_table_classifications = self.parse_table_classifications(self.old_file)
            
        print(f"Loading new file: {self.new_file}")
        with open(self.new_file, 'r', encoding='utf-8') as f:
            self.new_data = yaml.safe_load(f)
        self.new_table_classifications = self.parse_table_classifications(self.new_file)
        
        print(f"Old file classifications: {len(self.old_table_classifications)} tables")
        print(f"New file classifications: {len(self.new_table_classifications)} tables")
            
    def extract_version_from_filename(self, filename: str) -> str:
        """Extract version from filename."""
        basename = os.path.basename(filename)
        if '2_0' in basename:
            return '2.0'
        elif '2_1' in basename:
            return '2.1'
        else:
            return 'unknown'
            
    def compare_variables(self, old_vars: List[Dict], new_vars: List[Dict]) -> Dict[str, Any]:
        """Compare variables between old and new table versions."""
        changes = {
            'variables_added': [],
            'variables_removed': [],
            'variables_modified': []
        }
        
        # Create lookup dictionaries
        old_vars_dict = {var['name']: var for var in old_vars}
        new_vars_dict = {var['name']: var for var in new_vars}
        
        old_var_names = set(old_vars_dict.keys())
        new_var_names = set(new_vars_dict.keys())
        
        # Find added variables
        added_vars = new_var_names - old_var_names
        for var_name in added_vars:
            var_info = new_vars_dict[var_name].copy()
            changes['variables_added'].append(var_info)
            
        # Find removed variables
        removed_vars = old_var_names - new_var_names
        for var_name in removed_vars:
            var_info = old_vars_dict[var_name].copy()
            changes['variables_removed'].append(var_info)
            
        # Find modified variables
        common_vars = old_var_names & new_var_names
        for var_name in common_vars:
            old_var = old_vars_dict[var_name]
            new_var = new_vars_dict[var_name]
            
            var_changes = {}
            
            # Compare each field
            for field in ['type', 'description', 'values']:
                old_value = old_var.get(field)
                new_value = new_var.get(field)
                
                if old_value != new_value:
                    var_changes[field] = {
                        'old': old_value,
                        'new': new_value
                    }
                    
            if var_changes:
                changes['variables_modified'].append({
                    'name': var_name,
                    'changes': var_changes
                })
                
        return changes
        
    def analyze_table_status_changes(self) -> None:
        """Analyze changes in table classifications (concept/beta)."""
        concept_to_beta = []
        beta_to_concept = []
        status_changed = []
        
        # Find tables that exist in both versions
        old_tables = set(self.old_table_classifications.keys())
        new_tables = set(self.new_table_classifications.keys())
        common_tables = old_tables & new_tables
        
        for table_name in common_tables:
            old_status = self.old_table_classifications.get(table_name)
            new_status = self.new_table_classifications.get(table_name)
            
            if old_status and new_status and old_status != new_status:
                status_changed.append(table_name)
                
                change_info = {
                    'table': table_name,
                    'old_status': old_status,
                    'new_status': new_status,
                    'description': f'Table "{table_name}" status changed from {old_status} to {new_status}'
                }
                
                if old_status == 'concept' and new_status == 'beta':
                    concept_to_beta.append(change_info)
                elif old_status == 'beta' and new_status == 'concept':
                    beta_to_concept.append(change_info)
                    
                # Add to changes if not already there
                if table_name not in self.changelog['changes']:
                    self.changelog['changes'][table_name] = {
                        'change_type': 'table_status_changed',
                        'description': change_info['description'],
                        'old_status': old_status,
                        'new_status': new_status,
                        'variables_added': [],
                        'variables_removed': [],
                        'variables_modified': []
                    }
                else:
                    # Update existing change record
                    self.changelog['changes'][table_name]['old_status'] = old_status
                    self.changelog['changes'][table_name]['new_status'] = new_status
                    original_desc = self.changelog['changes'][table_name]['description']
                    self.changelog['changes'][table_name]['description'] = f"{original_desc}; Status changed from {old_status} to {new_status}"
        
        self.changelog['summary']['tables_status_changed'] = status_changed
        self.changelog['summary']['concept_to_beta'] = [c['table'] for c in concept_to_beta]
        self.changelog['summary']['beta_to_concept'] = [c['table'] for c in beta_to_concept]
        
        # Add detailed status change info to metadata
        if concept_to_beta or beta_to_concept:
            self.changelog['metadata']['status_changes'] = {
                'concept_to_beta_count': len(concept_to_beta),
                'beta_to_concept_count': len(beta_to_concept),
                'concept_to_beta_details': concept_to_beta,
                'beta_to_concept_details': beta_to_concept
            }
        
    def compare_tables(self) -> None:
        """Compare tables between old and new data dictionaries."""
        old_tables = set(self.old_data.get('tables', {}).keys())
        new_tables = set(self.new_data.get('tables', {}).keys())
        
        # Find added tables
        added_tables = new_tables - old_tables
        self.changelog['summary']['tables_added'] = list(added_tables)
        
        for table_name in added_tables:
            table_data = self.new_data['tables'][table_name]
            self.changelog['changes'][table_name] = {
                'change_type': 'table_added',
                'description': f'New table "{table_name}" added',
                'variables_count': len(table_data.get('variables', [])),
                'variables': table_data.get('variables', [])
            }
            
        # Find removed tables
        removed_tables = old_tables - new_tables
        self.changelog['summary']['tables_removed'] = list(removed_tables)
        
        for table_name in removed_tables:
            table_data = self.old_data['tables'][table_name]
            self.changelog['changes'][table_name] = {
                'change_type': 'table_removed',
                'description': f'Table "{table_name}" removed',
                'variables_count': len(table_data.get('variables', [])),
                'variables': table_data.get('variables', [])
            }
            
        # Find modified tables
        common_tables = old_tables & new_tables
        modified_tables = []
        
        for table_name in common_tables:
            old_table = self.old_data['tables'][table_name]
            new_table = self.new_data['tables'][table_name]
            
            old_vars = old_table.get('variables', [])
            new_vars = new_table.get('variables', [])
            
            var_changes = self.compare_variables(old_vars, new_vars)
            
            # Check if there are any changes
            has_changes = (
                var_changes['variables_added'] or 
                var_changes['variables_removed'] or 
                var_changes['variables_modified']
            )
            
            if has_changes:
                modified_tables.append(table_name)
                
                change_summary = []
                if var_changes['variables_added']:
                    change_summary.append(f"{len(var_changes['variables_added'])} variables added")
                if var_changes['variables_removed']:
                    change_summary.append(f"{len(var_changes['variables_removed'])} variables removed")
                if var_changes['variables_modified']:
                    change_summary.append(f"{len(var_changes['variables_modified'])} variables modified")
                    
                self.changelog['changes'][table_name] = {
                    'change_type': 'table_modified',
                    'description': f'Table "{table_name}" modified: {", ".join(change_summary)}',
                    **var_changes
                }
                
        self.changelog['summary']['tables_modified'] = modified_tables
        
        # Analyze status changes
        self.analyze_table_status_changes()
        
        # Calculate total changes (including status changes)
        status_changed_tables = set(self.changelog['summary']['tables_status_changed'])
        all_changed_tables = set(added_tables) | set(removed_tables) | set(modified_tables) | status_changed_tables
        total_changes = len(all_changed_tables)
        self.changelog['summary']['total_changes'] = total_changes
        
    def generate_metadata(self) -> None:
        """Generate metadata for the changelog."""
        old_version = self.extract_version_from_filename(self.old_file)
        new_version = self.extract_version_from_filename(self.new_file)
        
        self.changelog['metadata'] = {
            'generated_at': datetime.now().isoformat(),
            'comparison': {
                'old_file': os.path.basename(self.old_file),
                'new_file': os.path.basename(self.new_file),
                'old_version': old_version,
                'new_version': new_version
            },
            'description': f'Changelog comparing CLIF data dictionary from version {old_version} to {new_version}'
        }
        
    def save_changelog(self, output_file: str) -> None:
        """Save the changelog as YAML."""
        with open(output_file, 'w', encoding='utf-8') as f:
            yaml.dump(self.changelog, f, default_flow_style=False, sort_keys=False, allow_unicode=True)
            
        print(f"Changelog saved to: {output_file}")
        
    def print_summary(self) -> None:
        """Print a summary of changes to console."""
        print("\n" + "="*50)
        print("CHANGELOG SUMMARY")
        print("="*50)
        
        summary = self.changelog['summary']
        metadata = self.changelog['metadata']
        
        print(f"Comparison: {metadata['comparison']['old_version']} → {metadata['comparison']['new_version']}")
        print(f"Total changes: {summary['total_changes']}")
        print()
        
        if summary['tables_added']:
            print(f"Tables added ({len(summary['tables_added'])}):")
            for table in summary['tables_added']:
                print(f"  + {table}")
            print()
            
        if summary['tables_removed']:
            print(f"Tables removed ({len(summary['tables_removed'])}):")
            for table in summary['tables_removed']:
                print(f"  - {table}")
            print()
            
        if summary['tables_modified']:
            print(f"Tables modified ({len(summary['tables_modified'])}):")
            for table in summary['tables_modified']:
                change_info = self.changelog['changes'][table]
                print(f"  ~ {table}: {change_info['description'].split(': ', 1)[1]}")
            print()
            
        if summary['concept_to_beta']:
            print(f"Tables moved from concept to beta ({len(summary['concept_to_beta'])}):")
            for table in summary['concept_to_beta']:
                print(f"  📈 {table}")
            print()
            
        if summary['beta_to_concept']:
            print(f"Tables moved from beta to concept ({len(summary['beta_to_concept'])}):")
            for table in summary['beta_to_concept']:
                print(f"  📉 {table}")
            print()
            
        # Show status change summary
        if 'status_changes' in self.changelog['metadata']:
            status_info = self.changelog['metadata']['status_changes']
            print(f"Status Changes Summary:")
            print(f"  • Concept → Beta: {status_info['concept_to_beta_count']} tables")
            print(f"  • Beta → Concept: {status_info['beta_to_concept_count']} tables")
            print()
            
        if summary['total_changes'] == 0:
            print("No differences found between the data dictionaries.")
            
    def generate(self, output_file: str) -> None:
        """Main generation process."""
        print("Starting changelog generation...")
        self.load_data_dictionaries()
        self.generate_metadata()
        self.compare_tables()
        self.save_changelog(output_file)
        self.print_summary()
        print("Changelog generation complete!")


def main():
    parser = argparse.ArgumentParser(description='Generate changelog between CLIF data dictionary versions')
    parser.add_argument('--old', required=True, help='Path to old data dictionary YAML file')
    parser.add_argument('--new', required=True, help='Path to new data dictionary YAML file')
    parser.add_argument('--output', required=True, help='Output changelog YAML file path')
    
    args = parser.parse_args()
    
    if not os.path.exists(args.old):
        print(f"Error: Old file not found: {args.old}")
        return 1
        
    if not os.path.exists(args.new):
        print(f"Error: New file not found: {args.new}")
        return 1
        
    # Ensure output directory exists
    output_dir = os.path.dirname(args.output)
    if output_dir:
        os.makedirs(output_dir, exist_ok=True)
    
    generator = CLIFChangelogGenerator(args.old, args.new)
    generator.generate(args.output)
    
    return 0


if __name__ == '__main__':
    exit(main())
