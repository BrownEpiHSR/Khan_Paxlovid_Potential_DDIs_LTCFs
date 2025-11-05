*Program name: E. Calculate median and quartiles
*Programmer: Marzan Khan
*Last Updated: 6 August 2025;

*remove duplicate medications on the same day per resident;
proc sort data=data.stacked_meds_flagged_nomiss  out=nodup_date nodupkey;
	by master_patient_id date matched_generic;
run;

*Calculate the total days of administration of each drug within person;
proc sql;
	create table days_sum as
	select distinct master_patient_id, matched_generic, count(matched_generic) as days_exp
	from nodup_date
	group by master_patient_id, matched_generic;
quit;

*Transpose the dataset so that each resident has the concomitant drugs in columns populated with total days of exposure;
proc transpose data=days_sum prefix=drug_ out=days_sum2 ;
	by master_patient_id ;
	var days_exp;
	id matched_generic;
	idlabel matched_generic;
run;

*change missing to 0 days of exposure;
data days_sum3;
	set days_sum2;
	array meds {*} drug_:;
	do i=1 to dim(meds);
	if meds[i] =. then meds[i]=0;
	end;
run;

proc freq data=days_sum3;
	tables drug_Aliskiren;
run;

*Put all the drug variable names into macro drug_vars;
proc sql noprint;
	select name into: drug_vars separated by ' '
	from dictionary.columns
	where libname="WORK"
	and memname="DAYS_SUM3"
	and upcase(name) like 'DRUG_%';
quit;


%put &drug_vars;

%macro summarize;
	%let i=1;
	%do  %while (%scan(&drug_vars, &i) ne);
	%let drug=%scan(&drug_vars, &i);

	proc summary data=days_sum3;
	var &drug;
	output out=median_&drug
	median= q1= q3=  /autoname;
	where &drug>0;
	run;

	data median_&drug;
		set median_&drug;
		drug_name="%scan(&drug,2,_)";
	rename _FREQ_=Number_residents
			&drug._median=median
			&drug._q1=q1
			&drug._q3=q3;

	run;

%let i=%eval(&i+1);
%end;
%mend;
%summarize;

*Find median and quartile manually for Glecaprevir;
proc summary data=days_sum3;
	var drug_Glecaprevir_pibrentasvir;
	output out=median_Glecaprevir_pibrentasvir
	median= q1= q3=  /autoname;
	where drug_Glecaprevir_pibrentasvir>0;
run;

data median_Glecaprevir_pibrentasvir;
	set median_Glecaprevir_pibrentasvir;
		
	rename _FREQ_=Number_residents
			drug_Glecaprevir_pibren_Median=median
			drug_Glecaprevir_pibrentasv_Q1=q1
			drug_Glecaprevir_pibrentasv_Q3=q3;
			drug_name="Glecaprevir_pibrentasvir";

run;

proc sql noprint;
	select cats("work.", memname)
	into :mediansets
	separated by ' '
	from dictionary.tables

	where libname="WORK" and memname contains "MEDIAN_"
	;
quit;

%put &mediansets;

%macro meanci (mean=&estimate,
lcl=&num1,
ucl=&num2,
decimals=1);
cat(strip(put(&mean., 8.&decimals.)), " (", strip(put(&lcl.,8.&decimals.)),", ", strip(put(&ucl.,8.&decimals.)), ")");
%mend meanci;

data data.ddi_median;
length drug_name $30 median_q13 $30;
	set  &mediansets;
	
	drop _TYPE_;
	median_q13=%meanci(mean=median, lcl=q1, ucl=q3);
run;

