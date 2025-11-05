*Program name: D. Calculate prevalance and confidence limits
*Programmer: Marzan Khan
*Last Updated: 6 August 2025;

*Since we want to check if a resident ever had one of the potential drugs along with paxlovid during the study period,
we can remove duplicates by resident and same drug;
proc sort data=data.stacked_meds_flagged_nomiss out=nodup_drugs nodupkey;
	by master_patient_id matched_generic;
/*	where drug_group~=" ";*/
run;

*Create flag variable that will help when the data is transposed next;
data nodup_drugs1;
	set nodup_drugs;
	flag=1;
run;

proc transpose data=nodup_drugs1 prefix=drug_ out=prevalence ;
	by master_patient_id ;
	var flag;
	id matched_generic;
	idlabel matched_generic;
run;


*Change missing to 0 across all the drugs;
data data.drug_indicators;
	set prevalence;
	
	array meds {*} drug_: ;
	do i=1 to dim(meds);
	if meds[i] =. then meds[i]=0;
	end;
	drop i;
run;

*Put all the drug variable names into macro drug_vars;
proc sql noprint;
	select name into: drug_vars separated by ' '
	from dictionary.columns
	where libname="DATA"
	and memname="DRUG_INDICATORS"
	and upcase(name) like 'DRUG_%';
quit;

*Read and copy the names from the log to paste on tables statement;
%put &drug_vars;

ods excel file="pathname.xlsx" options( embedded_titles='yes') ;

ods output BinomialCLs=ci_limits_output;
proc freq data=data.drug_indicators;
	tables 
	drug_Atorvastatin drug_Clonazepam drug_Paxlovid drug_Apixaban drug_Mirtazapine drug_Rosuvastatin
drug_Hydrocodone drug_Hydromorphone drug_Hydroxyzine drug_Oxycodone drug_Clopidogrel
drug_Dexamethasone drug_Amlodipine drug_Risperidone drug_Sacubitril drug_Solifenacin drug_Alprazolam
drug_Buspirone drug_Quetiapine drug_Aripiprazole drug_Diazepam drug_Fentanyl drug_Oxybutynin
drug_Trazodone drug_Tamsulosin drug_Warfarin drug_Primidone drug_Quinidine drug_Simvastatin
drug_Tramadol drug_Morphine drug_Haloperidol drug_Methadone drug_Phenytoin drug_Rivaroxaban
drug_Verapamil drug_Ketoconazole drug_Pimavanserin drug_Diltiazem drug_Erythromycin drug_Cyclosporine
drug_Salmeterol drug_Dabigatran drug_Nifedipine drug_Amiodarone drug_Carbamazepine drug_Ranolazine
drug_Ziprasidone drug_Cariprazine drug_Digoxin drug_Tacrolimus drug_Bromocriptin drug_Cilostazol
drug_Felodipine drug_Valsartan drug_Flecainide drug_Tolvaptan drug_Clarithromycin drug_Ubrogepant
drug_Doxazosin drug_Zolpidem drug_Brexpiprazole drug_Colchicine drug_Relugolix drug_Tadalafil
drug_Ticagrelor drug_Riociguat drug_Mexiletine drug_Phenobarbital drug_Suvorexant drug_Terazosin
drug_Lovastatin drug_Clozapine drug_Sildenafil drug_Lurasidone drug_Eplerenone drug_Naloxegol
drug_Tofacitinib drug_Buprenorphine drug_Glyburide drug_Dronedarone drug_Darifenacin drug_Dofetilide
drug_Propafenone drug_Clobazam drug_Rimegepant drug_Clorazepate drug_Alfuzosin drug_Olaparib
drug_Silodosin drug_Pimozide drug_Pemigatinib drug_Palbociclib drug_Ivabradine drug_Darolutamide
drug_Ibrutinib drug_Zanubrutinib drug_Venetoclax drug_Triazolam drug_Nilotinib drug_Eluxadoline
drug_Upadacitinib drug_Daridorexant drug_Finerenone drug_Saxagliptin drug_Voriconazole drug_Midazolam
drug_Rifampin drug_Disopyramide drug_Sotorasib drug_Apalutamide drug_Ruxolitinib drug_Enzalutamide
drug_Imatinib drug_Bosutinib drug_Chlordiazepoxide drug_Edoxaban drug_Cobicistat drug_Lumateperone
drug_Everolimus drug_Itraconazole drug_Iloperidone drug_Acalabrutinib drug_Isavuconazole
drug_Posaconazole drug_Dasatinib drug_Bosentan drug_Dabrafenib drug_Lorlatinib
drug_Glecaprevir_pibrentasvir drug_Selinexor drug_Rifabutin drug_Abemaciclib drug_Maraviroc
drug_Erdafitinib drug_Zolmitriptan drug_Sonidegib drug_Aliskiren drug_Fostamatinib drug_Sirolimus
drug_Cabozantinib drug_Eletriptan drug_Axitinib

	/binomial(level="1" exact)alpha=0.05 ;
run;
ods output close;


%macro meanci (mean=&estimate,
lcl=&num1,
ucl=&num2,
decimals=2);
cat(strip(put(&mean., 8.&decimals.)), " (", strip(put(&lcl.,8.&decimals.)),", ", strip(put(&ucl.,8.&decimals.)), ")");
%mend meanci;

*Concatenate prevalance and confidence limits;
data ci_limits_output2;
	set ci_limits_output;
	length drug_name prev_ci $30 ;
	prop_100=proportion*100;
	lcl_100=lowercl*100;
	ucl_100=uppercl*100;
	drug_name=substr(table, 12);
	prev_ci=%meanci(mean=prop_100, lcl=lcl_100, ucl=ucl_100);
run;

*output the N for all drugs;
proc tabulate data=data.drug_indicators format=8.0 out=prev;
	class drug_:;
	table (drug_:), all=" "*(n colpctn="Percent");
run;


*Keep rows where the drug_=1;
data prev2;
	set prev;
	array meds {*} drug_:;
	do i=1 to dim(meds);
	if meds{i}=1 then do;
	drug_name=vlabel(meds[i]);
	output;
	end;
	end;
run;

*Combine datasets to have the prevalence and number of residents in one table;
proc sql;
	create table data.prev_number as
	select a.*, b.N
	from ci_limits_output2 as a
	left join prev2 as b
	on compress(a.drug_name)=compress(b.drug_name)
	order by proportion desc;
quit;

















