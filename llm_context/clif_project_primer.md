# CLIF Project Primer

## Recommendations for Code Workflow

### 1. Load Core Tables to Identify the Cohort
- Output: a list of cohort (hospitalization) IDs
1. If filtering the database by **age and dates**, load the **hospitalization** table to identify IDs.
2. Join with the **ADT** table to ensure all hospitalizations have location data (sanity check).
3. Join with the **patient** table to get demographics and other static patient info.
4. Extract the list of hospitalization IDs to use for filtering other tables.
5. Optionally, use the `stitching_encounters` logic to identify linked hospitalizations, or use the `hospitalization_joined_id` depending on project requirements.

### 2. Filter Other Tables Using the Cohort
- Output: a refined list of cohort IDs
1. Example 1: Identify patients with **ICU stay ≥ 24 hours**. Use the **ADT** table to calculate duration, filter down to qualifying hospitalizations.
2. Example 2: Identify patients on **IMV at least once**. Use the **respiratory_support** table for the cohort and filter on the `device_category` column.
3. Example 3: Exclude patients with tracheostomy. Use the `tracheostomy` column in the **respiratory_support** table to exclude IDs from step 1.

### 3. Finalize the Cohort
- Cohort = list of hospitalization IDs
- Load all other required CLIF tables using the finalized cohort.
- The `load_data()` function in **clifpy** filters tables to required fields and mCIDE before writing to a pandas DataFrame for memory efficiency.

### 4. Fill Time-Series Data
- Use `waterfall()` for **respiratory support** or **CRRT** tables.
- Apply other appropriate filling logic to create representative trajectories.

### 5. Optimization Tips
1. Prefer **vectorized operations** over loops.
2. Use **memory-efficient data types** (e.g., `Int8` instead of `Int64` for dummy variables).
3. Normalize all `_category` fields to **lowercase**.
4. Wrap code in `try/except` blocks to handle errors gracefully.

---

## Package Information
- The recommended Python interface for CLIF data is **clifpy**, available on PyPI: https://pypi.org/project/clifpy/
- Use clifpy functions for loading and processing CLIF data to ensure consistency and efficiency.
