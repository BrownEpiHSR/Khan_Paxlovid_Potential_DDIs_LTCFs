# Khan_Paxlovid_Potential_DDIs_LTCFs
Khan et al. - Drug-drug interactions with nirmatrelvir/ritonavir among long-term care facility residents.

# Description
This repository contains data documentation and code for the analysis in the manuscript titled "Drug-drug interactions with nirmatrelvir/ritonavir among long-term care facility residents."

## Repository Contents
- `data_documentation/` - Contains files describing the data sources, key variables, and project information
- `code/` - The programs used for data management and analysis.
- `LICENSE` - The license under which this repository is shared.
- `README.md` - This file, providing an overview of the repository.
  
## Data Documentation
The `data_documentation/` directory contains the following file:
- Data_documentation.xlsx` - contains information about key variables, data sources and other project related information

## Code
The `code/` directory contains the following programs:

A. Subset to Paxlovid administrations.sas <Subsets eMAR file to Paxlovid administrations>

B. Apply eligibility criteria.sas <Applies eligibility criteria to derive study population>

C. Group concomitant drugs.sas <Groups concomitant drugs that exist as combinations or generic and brand names together>

D. Calculate prevalence and confidence limits.sas <Calculates the prevalence of drug-drug interaction (DDI) and confidence limits>

E. Calculate median and quartiles.sas <Calculates median and quartiles>

F. Classify Paxlovid dose.sas <Classifies dose of Paxlovid>

Programs were run in sequence to produce the study findings.
