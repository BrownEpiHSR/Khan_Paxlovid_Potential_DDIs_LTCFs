*Programmer: Marzan Khan
*Last Updated: April, 2026;
*Purpose: Find the proportion of residents who received the normal dose of nirmatrelvir/ritonavir and still had chronic kidney disease

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

proc sort data=paxlovid_flagged;
	by master_patient_id;
run;

*Create course id;
data paxlovid_course;
	set paxlovid_flagged;
	
	retain new_admin;
	by master_patient_id;
	lag_date=lag(date);
	if first.master_patient_id then lag_date=date;

	*if there was a difference of at least 14 days between administrations per resident, then flag it as a new administration;
	if first.master_patient_id then new_admin=1;
	else if date-lag_date>15 then  new_admin+1;

	course_id=cats(put(master_patient_id, 8.), "_", put(new_admin, 8.));
	format lag_date date9.;
run;

proc sort data=paxlovid_course;
	by course_id date;
run;

*Keep the first record per course to get the first day of the course;
proc sort data=paxlovid_course out=firstday_course nodupkey;
	by course_id ;
run;

data lookback_dates;
	set firstday_course;
	lookback_end=date-1;
	lookback_start=intnx('year', lookback_end, -2, 'same');
	
	format lookback_start lookback_end date9.;
run;

data conditions;
	set output.icd_codes_flagged2;
	condition_date_new=datepart(condition_date);
	if condition_date_new=. then master_condition_date=onset_date;
	else master_condition_date=condition_date_new;
	format condition_date_new master_condition_date date9.;
run;

*keep records of individuals who are in my cohort;
proc sql;
	create table subset as
	select *
	from conditions
	where master_patient_id in (select master_patient_id from lookback_dates);
quit;

*Subset to people who had diagnosis of CKD;
data subset2;
	set subset;
	if ckd=1;
run;

*join to each row by master_patient_id, which is each course_id;
proc sql;
	create table ckd1 as
	select *
	from lookback_dates as a
	left join subset2 as b
	on a.master_patient_id=b.master_patient_id;
quit;

*Flag ckd codes that occurred during lookback as 2;
*Flag ckd codes that occurred outside lookback period as 1;
*Flag records whithout any codes at all as 0;
data ckd2;
	set ckd1;
	if master_condition_date=. then overlap_ckd=0;
	else if lookback_start<=master_condition_date<=lookback_end then overlap_ckd=2;
	else overlap_ckd=1;
run;

proc sort data=ckd2 ;
	by course_id descending ckd;
run;

*Keep the first record per course;
proc sort data=ckd2 out=ckd3 nodupkey;
	by course_id ;
run;

proc freq data=ckd3;
	tables flagged_dose*overlap_ckd;
run;
