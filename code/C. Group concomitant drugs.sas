*Program name: C. Group concomitant drugs
*Programmer: Marzan Khan
*Last Updated: 9 April 2025;
*Purpose: Identify and group (those existing as combination) drugs of interest administered concomitantly with Paxlovid.;

*Import list of comcomitant drugs;
proc import datafile="pathname.xlsx"
	out=drug_groups
	dbms=xlsx
	replace;
run;

*Sort by generic name;
proc sort data=drug_groups nodupkey dupout=dupcheck;
	by generic_name;
run;

*Transpose that each bran name is in different columns;
proc transpose data=drug_groups out=transposed;
	by generic_name;
	var brand1-brand9;
run;

*Drop unnecessary rows and columns;
data flag;
	set transposed;
	where col1~=" " ;
	generic_name_strip=strip(generic_name);
	brand_name_strip=strip(col1);

	drop _NAME_ _LABEL_ ;
run;


data output.flagged_meds_other;
	set output.nonmissing_meds;

	length matched_generic $100;
	
	call missing (matched_generic);
	do i=1 to 306;
		set flag point=i;

		pattern_brand="/\b" || lowcase(strip(brand_name_strip)) || "\w*/i";
		pattern_generic="/\b" || lowcase(strip(generic_name_strip)) || "\w*/i";

		med1=lowcase(strip(medication_generic_name));
		med2=lowcase(strip(medication_name));

		if prxmatch(pattern_brand, med1) or 
		   prxmatch(pattern_brand, med2) or
		   prxmatch(pattern_generic, med1) or
		   prxmatch(pattern_generic, med2) then do;
		   matched_generic=generic_name_strip;
		leave;
		end ;
		end;
run;






















