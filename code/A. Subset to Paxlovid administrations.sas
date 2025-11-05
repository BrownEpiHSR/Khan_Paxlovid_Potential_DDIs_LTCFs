*Program name: A. Subset to Paxlovid administrations
*Programmer: Marzan Khan
*Last Updated: 14 April 2025;
*Purpose: Subset eMAR file to administrations of Paxlovid;


*Dataset is at the administration level;
data output.paxlovid_03182025;
	set ltcdc.medication_admin (drop= created_date updated_date medication_id_hashed episode_id medication_event_provider_id episode_id)  ;
	where medication_generic_name^=" " or medication_name^=" ";

	*Flag administrations of paxlovid;
	foundin_generic=0;
	foundin_name=0;
	if find(medication_generic_name, "nirmatrelvir", "i")>0 or find(medication_generic_name, "paxlovid", "i")>0  or find(medication_generic_name, "ritonavir", "i")>0  then foundin_generic=1;
	if find(medication_name, "nirmatrelvir", "i")>0 or find(medication_name, "paxlovid", "i")>0 or find(medication_name, "ritonavir", "i")>0  then foundin_name=1;

	if foundin_name=1 or foundin_generic=1;
run;

