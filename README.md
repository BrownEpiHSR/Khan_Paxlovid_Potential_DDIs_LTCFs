# Khan_Paxlovid_Potential_DDIs_LTCFs
Khan et al. - Drug-drug interactions with nirmatrelvir/ritonavir among long-term care facility residents.

# Description
This repository contains data documentation and code for the analysis in the manuscript titled "Drug-drug interactions with nirmatrelvir/ritonavir among long-term care facility residents."

## Repository Contents
- `data_documentation` - Contains files describing the data sources, key variables, and project information
- `code` - The programs used for data management and analysis.
- `LICENSE` - The license under which this repository is shared.
- `README.md` - This file, providing an overview of the repository.
  
## Data Documentation
The `directory`contains the following files:
- ` Data_documentation.xlsx`- contains information about key variables, data sources and other project related information
- ` Program Codebook Developed in Response to Reviewer Comments.xlsx` - This codebook documents the SAS programs and derived variables developed to address additional analyses and clarifications requested during the journal peer-review process. 

## Code
The `code` directory contains the following programs:

A. Subset to Paxlovid administrations.sas — Subsets eMAR file to Paxlovid administrations

B. Apply eligibility criteria.sas Applies — eligibility criteria to derive study population

C. Group concomitant drugs.sas — Groups concomitant drugs that exist as combinations or generic and brand names together

D. Calculate prevalence and confidence limits.sas — Calculates the prevalence of drug-drug interaction (DDI) and confidence limits

E. Calculate median and quartiles.sas — Calculates median and quartiles

F. Classify Paxlovid dose.sas — Classifies dose of Paxlovid

Programs A-F were run in sequence to produce the study findings.

Programs 1–6 were developed to respond to journal reviewer comments. 

1- Create subsets of medication administration files_GH.sas — Creates yearly subsets of medication administration files restricted to residents in the final Paxlovid cohort.

2- Polypharmacy Statistics_GH.sas — Calculates polypharmacy statistics during the 180-day lookback period prior to Paxlovid initiation.

3- Proportion of residents with interacting medications_GH.sas — Calculates the proportion of residents with ≥1, ≥2, and ≥3 potentially interacting medications during Paxlovid treatment.

4- Nursing home time calculation_GH.sas — Calculates nursing home length of stay prior to Paxlovid initiation and stratifies results by DDI exposure.

5- Create comorbid conditions from conditions file_GH.sas — Creates comorbidity indicators (e.g., diabetes, CKD, dementia, CHF) using ICD-9 and ICD-10 diagnosis codes.

6- Residents receiving normal dose with CKD_GH.txt — Identifies residents with chronic kidney disease (CKD) who received the standard Paxlovid dose.

