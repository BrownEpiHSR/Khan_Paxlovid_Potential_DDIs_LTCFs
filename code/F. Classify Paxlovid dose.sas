*Program name: F. Classify Paxlovid dose
*Programmer: Marzan Khan
*Last Updated: April 4, 2025;
*Purpose: Classify Paxlovid administrations into appropriate dosages;

*Create missing format for numeric variables;
proc format ;
	value null_num .="Missing"
		 other="Not missing";
run;

*Create missing format for character variables;
proc format ;
	value $ null_char 
			" "="Missing"
		 other="Not missing";
run;

*Dataset is at the administration level;
data paxlovid_flagged;
    set output.paxlovid_perperson_admin;;

    length FLAGGED_DOSE $12;

    /* Combine all fields into a single string for pattern matching */
    all_text = catx(' ',
        upcase(MEDICATION_NAME),
        upcase(MEDICATION_GENERIC_NAME),
        upcase(MEDICATION_DOSE),
        upcase(MEDICATION_STRENGTH)
    );

    FLAGGED_DOSE = "UNDETERMINED";

    /* Indicators for 300 MG */
    if index(all_text, "3") > 0 or
	index(all_text, "THREE") > 0 or
		index(all_text, "300") > 0 or
		index(all_text, "300 MG") > 0 or
       index(all_text, "300MG") > 0 or
       index(all_text, "150 MG X 2") > 0 or
       index(all_text, "150MG X 2") > 0 or
       index(all_text, "150MGX2") > 0 or
       index(all_text, "150X2") > 0 or
	   index(all_text, "150(X2)-100 MG")>0 or
       index(all_text, "2-150MG") > 0 or
       index(all_text, "2X150MG") > 0 or
       index(all_text, "3 TABS") > 0 or
       index(all_text, "3 TABLETS") > 0 or
       index(all_text, "3 TAB") > 0 or
       index(all_text, "3 PILLS") > 0 or
       index(all_text, "150MG + 150MG") > 0 or
       index(all_text, "150MG AND 150MG") > 0 or
       index(all_text, "300-100 MG") > 0 or
       index(all_text, "300-100MG") > 0 or
       index(all_text, "300/100 MG") > 0 or
       index(all_text, "300/100MG") > 0 or
       index(all_text, "300/100 MG.") > 0 OR 
	    index(all_text, "2X150") > 0 
			then do;
        FLAGGED_DOSE = "300 MG";
    end;

    /* Indicators for 150 MG */
    else if 
			index(all_text, "150 MG X 1") > 0 or
            index(all_text, "150MG X 1") > 0 or
            index(all_text, "1 X 150MG") > 0 or
            index(all_text, "150*1") > 0 or
            index(all_text, "1 TAB") > 0 or
            index(all_text, "1 TABLET") > 0 or
            index(all_text, "1 CAPSULE") > 0 or
            index(all_text, "1 DOSE (2 TABS)") > 0 or
            index(all_text, "1 DOSE (150 MG)") > 0 or
			index(all_text, "2 TABS") > 0 or
      		index(all_text, "2 TABLETS") > 0 or
            index(all_text, "150-100 MG") > 0 or
            index(all_text, "150/100 MG") > 0 or
            index(all_text, "150MG/100MG") > 0 or
            (index(all_text, "150 MG") > 0 and index(all_text, "300") = 0) then do;
        FLAGGED_DOSE = "150 MG";
    end;
run;


