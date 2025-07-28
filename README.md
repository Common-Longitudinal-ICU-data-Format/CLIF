# Common Longitudinal ICU data Format (CLIF)

Official Website to the CLIF Consortium - [CLIF Consortium](https://clif-icu.com/)

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

[Updated ERD and data dictionary](https://clif-icu.com/data-dictionary/data-dictionary-2.0.0) 

## CLIF table POCs

Each CLIF table has an assigned clinician who serves as the primary point of contact for any inquiries related to the schema or common data elements specific to that table.

| Tables                       | Point of Contact                              | Email                                         | GitHub Username       |
|------------------------------|-----------------------------------------------|-----------------------------------------------|-----------------------|
| patient                      | Pat Lyons, MD                                 | lyonspa@ohsu.edu                              | plyons                |
| hospitalization              | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| admission_diagnosis          | J.C. Rojas, MD, MS                            | juan_rojas@rush.edu                           | sajor2000             |
| provider                     | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| adt                          | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| vitals                       | Catherine Gao, MD                             | catherine.gao@northwestern.edu                | cloverbunny           |
| dialysis                     | Jay Koyner, MD                                | jkoyner@uchicago.edu                          |                       |
| intake_output                |                                               |                                               |                       |
| procedures                   | J.C. Rojas, MD                                | juan_rojas@rush.edu                           | sajor2000             |
| therapy_details              | William Parker, MD, PhD & Bhakti Patel, MD    | wparker@uchicago.edu; bpatel@bsd.uchicago.edu | 08wparker             | 
| respiratory_support          | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| position                     | Chad Hochberg, MD                             | chochbe1@jh.edu                               | chochbe1              |
| patient_assessment           | Snigdha Jain, MD                              | snigdha.jain@yale.edu                         | snigdhajainyale       |
| ecmo_mcs                     | Nicholas Ingraham, MD                         | ingra107@umn.edu                              | ingra107              |
| labs                         | Catherine Gao, MD                             | catherine.gao@northwestern.edu                | cloverbunny           |
| microbiology_culture         | Kevin Buell, MBBS                             | kevin.buell@uchicagomedicine.org              | kevingbuell           |
| microbiology_nonculture      | Kevin Buell, MBBS                             | kevin.buell@uchicagomedicine.org              | kevingbuell           |
| sensitivity                  | Kevin Buell, MBBS                             | kevin.buell@uchicagomedicine.org              | kevingbuell           |
| medication_orders            | Anna Barker, MD, PhD                          | baanna@med.umich.edu                          | baanna23              |
| medication_admin_intermittent| Anna Barker, MD, PhD                          | baanna@med.umich.edu                          | baanna23              |
| medication_admin_continuous  | Chad Hochberg, MD                             | chochbe1@jh.edu                               | chochbe1              |
| code_status                  | Nathan Mesfin, MD                             |                                               |                       |


## Data Architecture 

One of CLIF's key contributions is an open-source web application for converting relational databases into longitudinal datasets, selecting study-specific variables, and generating code in multiple programming languages. This tool enables streamlined data processing and supports cross-center comparisons without requiring pooled patient-level data.  

For more information about our data architecture and tools, please visit our [website](https://clif-icu.com/about).


## Current team members 

Our team of clinicians, data scientists, and collaborators can be found on our [website](https://clif-icu.com/team).




