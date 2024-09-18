# Common Longitudinal ICU Format (CLIF)

Official Website to the CLIF Consortium - [CLIF Consortium](https://kaveric.github.io/clif-consortium/about.html)

[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

[![Maturity Level](https://img.shields.io/badge/maturity-Beta-yellow)](https://clif-consortium.github.io/website/data-dictionary.html#overall-maturity-level-for-clif)

[CLIF Project Workflow Documentation](https://github.com/clif-consortium/CLIF/blob/main/WORKFLOW.md)


## Introduction
Multicenter critical care research often relies on sharing sensitive patient data across sites, requiring complex data use agreements (DUAs) and yielding redundant work to account for diverse data infrastructures. Common data models (CDMs) like the Observational Medical Outcomes Partnership can allow for standardized analysis scripts, mitigating these challenges but requiring advanced data engineering skills and risking a loss of crucial granular clinical information. To overcome these barriers, we present the Common Longitudinal ICU Format (CLIF), designed specifically for observational studies of critically ill patients across multiple centres. Through CLIF, we aim to streamline data organization into a longitudinal format and establish standard vocabularies to facilitate standardized analysis scripts and improve data readability for researchers and clinicians.

The CLIF consortium, comprising critical care researchers from eight US academic health systems, collaboratively developed CLIF's schema, clinical vocabularies, and "proof of concept" datasets. CLIF’s tables emphasize care processes, clinical outcomes, and granular clinical physiology measures.

This README file contains detailed instructions on how to set up your heathcare system's EHR data into the Relational CLIF format. The repository also provides a detailed data dictionary for each table in the R-CLIF database, along with the required limited vocabulary defined by clinical experts in the consortium. 

## Relational CLIF

In an iterative and ongoing fashion, we developed CLIF's schema, contents, and limited clinical vocabularies through collective discussion to consensus. The consortium's broad use case of clinical research on critically ill patients focused the decision-making on care processes, outcomes, and granular measures of clinical physiology. The primary development outcomes were (1) an initial schema, (2) a limited vocabulary set for important clinical variables, and (3)"proof of concept" datasets to demonstrate usability and interoperability.

To develop a structured relational database, we initiated a comprehensive data collection and cleaning effort at the eight health systems. We designed CLIF as an encounter-centric relational database with a clinically determined limited vocabulary for vitals, laboratory names, medications, patient locations, and respiratory device names. By consensus, we determined that CLIF would prioritize (1) completeness of routine clinical data, (2) temporal granularity, and (3) consistently measured clinical outcomes. The entity-relationship diagram from relational CLIF is presented below as a human-readable and clinically meaningful flow of information. Tables are organized into clinically relevant column categories (demographics, objective measures, respiratory support, orders and inputs-outputs)

[Updated ERD and data dictionary](https://clif-consortium.github.io/website/data-dictionary.html) 

Each CLIF table has an assigned clinician who serves as the primary point of contact for any inquiries related to the schema or common data elements specific to that table.

| Tables                       | Point of Contact                              | Email                                         | GitHub Username       |
|------------------------------|-----------------------------------------------|-----------------------------------------------|-----------------------|
| patient                      | Pat Lyons, MD                                 | lyonspa@ohsu.edu                              | plyons                |
| hospitalization              | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| admission_diagnosis          | J.C. Rojas, MD, MS                            | juan_rojas@rush.edu                           | sajor2000             |
| provider                     | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| adt                          | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| vitals                       | Catherine Gao, MD                             | catherine.gao@northwestern.edu                | cloverbunny           |
| scores                       | Snigdha Jain, MD                              | snigdha.jain@yale.edu                         | snigdhajainyale       |
| dialysis                     | Jay Koyner, MD                                | jkoyner@uchicago.edu                          |                       |
| intake_output                |                                               |                                               |                       |
| procedures                   | J.C. Rojas, MD                                | juan_rojas@rush.edu                           | sajor2000             |
| therapy_session              | William Parker, MD, PhD & Bhakti Patel, MD    | wparker@uchicago.edu; bpatel@bsd.uchicago.edu | 08wparker             |
| therapy_details              | William Parker, MD, PhD & Bhakti Patel, MD    | wparker@uchicago.edu; bpatel@bsd.uchicago.edu | 08wparker             | 
| respiratory_support          | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| position                     | Chad Hochberg, MD                             | chochbe1@jh.edu                               | chochbe1              |
| ecmo_mcs                     | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| labs                         | Catherine Gao, MD                             | catherine.gao@northwestern.edu                | cloverbunny           |
| microbiology_culture         | Kevin Buell, MBBS                             | kevin.buell@uchicagomedicine.org              |                       |
| microbiology_nonculture      | Kevin Buell, MBBS                             | kevin.buell@uchicagomedicine.org              |                       |
| sensitivity                  | Kevin Buell, MBBS                             | kevin.buell@uchicagomedicine.org              |                       |
| medication_orders            | Anna Barker, MD, PhD                          | baanna@med.umich.edu                          | baanna23              |
| medication_admin_intermittent| Anna Barker, MD, PhD                          | baanna@med.umich.edu                          | baanna23              |
| medication_admin_continuous  | Chad Hochberg, MD                             | chochbe1@jh.edu                               | chochbe1              |


## Data Architecture 

One of CLIF's key contributions is an open-source web application that enables users to convert a relational database into a longitudinal dataset with custom time intervals, select study-specific variables, and choose a preferred programming language. This facilitates straightforward data processing and enables effortless cross-center comparisons and integrations, bypassing the need for DUAs when analytic queries do not need pooled patient-level data. CLIF's deployment across four of the planned eight health systems has successfully compiled a robust ICU encounter-centric relational database, documenting 87,120 ICU admissions and capturing data from 71,190 unique patients.

| ![Diagram_CLIF_ATS_v3.jpg](/images/Diagram_CLIF_ATS_v3.jpg) | 
|:--:| 
||


## Current team members 

### Clinicians 
 * William Parker, MD, PhD 
 * Kevin Buell, MBBS
 * J.C. Rojas, MD
 * Catherine Gao, MD
 * Pat Lyons, MD
 * Chad Hochberg, MD
 * Nicholas Ingraham, MD 
 * Siva Bhavani, MD
 * Anna Barker, MD, PhD
 * Snigdha Jain, MD

### Data Scientists 
 * Kaveri Chhikara, MS
 * Rachel Baccile, MPP
 * Kyle Carey, MS
 * Vaishvik C., MS
 * Saki Amagai, PhD
 * Brenna Park-Egan, MS
 * Muna Nour, MPH

### Collaborators 
 * Jay Koyner, MD
 * Bhakti Patel, MD 
 * Kevin Smith, MD
 * Haley Beck, MA
 * Yuan Luo, PhD
 * Chengsheng Mao, PhD
 * Susan Han, MD




