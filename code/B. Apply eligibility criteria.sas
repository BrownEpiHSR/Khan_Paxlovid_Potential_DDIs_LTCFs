*Program name: B. Apply eligibility criteria
*Programmer: Marzan Khan
*Last Updated: 14 April 2025;
*Purpose: Apply eligibility criteria to 

*Restrict to paxlvoid only, minus ritonavir records only (i.e., those that do not exist as combination with
nirmatrelvir;
data output.paxlovid_restrict;
	set output.paxlovid_03182025;
	*Find administrations of paxlovid;
	foundin_generic_f=0;
	foundin_name_f=0;
	if find(medication_generic_name, "nirmatrelvir", "i")>0 or find(medication_generic_name, "paxlovid", "i")>0   then foundin_generic_f=1;
	if find(medication_name, "nirmatrelvir", "i")>0 or find(medication_name, "paxlovid", "i")>0   then foundin_name_f=1;

	if foundin_name_f=1 or foundin_generic_f=1;
run;

*create date time variables for medication administrations as well as variables for data cleaning and sample restriction;
data output.paxlovid_datetime;
	set output.paxlovid_restrict;

	if medication_event_date=. then date_missing=1; else date_missing=0;

	if medication_route="Oral" then route_oral=1; else route_oral=0;

	date=datepart(medication_event_date);
	time=timepart(medication_event_date);

	day=day(date);
	month=month(date);
	year=year(date);

	if date>="01jan2022"d then time_period=1; else time_period=0;
	hour=hour(time);
	minute=minute(time);

	format date date9. time time11.2;

run;

*Fill in flow chart boxes for data cleaning;
proc freq data=output.paxlovid_datetime;
	tables time_period;
	where date_missing=0;
run;

proc freq data=output.paxlovid_datetime;
	tables route_oral;
	where date_missing=0;
	where also time_period=1;
run;

*Restrict the data;
data output.paxlovid_final;
	set output.paxlovid_datetime;
	where date_missing=0;
	where also time_period=1 ;
	where also route_oral=1;
run;

*Check the number of administrations of paxlovid by month-year;
proc freq data=output.paxlovid_final ;
	tables date/out=freqout ;
	format date monyy7.;
run;

ods graphics/ width=10in height=7in imagename="plot";
ods listing gpath="your pathname" ;
proc sgplot data=freqout;
vbar date/response=count datalabel=percent  DATALABELFITPOLICY=NONe fillattrs=(color=pink) datalabelattrs=(family="Arial" size=10) ;
/*text  x=location y=pos text=percent;*/
format percent 3.1;
xaxis fitpolicy=rotate valuesrotate=vertical label="Month-year of administration" labelattrs=(family="Arial" size=10) valueattrs=(family="Arial" size=10) ;
yaxis label="Frequency of administration" labelattrs=(family="Arial" size=10) valueattrs=(family="Arial" size=10);
run;
ods listing close;
