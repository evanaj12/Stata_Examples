/*
Data cleaning and preliminary manipulation of Texas SOS dataset

Files needed:
	Initial TSoS files:
		rg_ERO_domestic_AustinZIPs_1960_2015.xlsx
		rg_ERO_foreignDE_AustinZIPs_1960_2015.xlsx

	Other:
		AustinMSAZips.xlsx
		AustinMSAZips.do
		
Files output:
	rg_ERO_domestic...	->	SoSData1.dta
	rg_ERO_foreignDE...	->	SoSData2.dta
	AustinMSAZips.dta (.dta version of AustinMSAZips.xlsx)
	SoSData.dta (complete TSoS data)
	
Evan Johnston
*/

set more off
* approx 2 min 45 sec
timer clear 1
timer on 1

************************ SoSData1 (registered in Austin) **********************
* import the excel file
* note: if a "file too large" error occurs, 
*	use "set excelxlsxlargefile on" before importing
set excelxlsxlargefile on
import excel using rg_ERO_domestic_AustinZIPs_1960_2015, first clear

* adjust variables to match second dataset
rename *, lower
tostring entity_zip, replace force

* add variable of DE incorporation
gen de_incorp = 0

save SoSData1.dta, replace

************************ SoSData2 (registered in DE) **********************
* import the second excel file
import excel using rg_ERO_foreignDE_AustinZIPs_1960_2015, first clear

* adjust variables to match first dataset
rename *, lower

* add variable of DE incorporation
gen de_incorp = 1

save SoSData2.dta, replace

************************ Combine SoSData1 and SoSData2 **********************
* combine datasets
use SoSData1.dta, clear
append using SoSData2.dta, force

* save
save SoSData.dta, replace

************************ General Data Cleaning ******************************
* Initial general cleaning

* trim string variables
ds, has(type string)
foreach var of varlist `r(varlist)' {
	replace `var' = trim(itrim(lower(`var')))
}
	
* replaces string variable of status with numerical one
	gen status = 0
	replace status = 1 if status_description=="in existence"
	replace status = 2 if status_description=="cancelled"
	replace status = 3 if status_description=="consolidated"
	replace status = 4 if status_description=="conversion"
	replace status = 5 if status_description=="deleted"
	replace status = 6 if status_description=="delinquent"
	replace status = 7 if status_description=="expired"
	replace status = 8 if status_description=="forfeited existence"
	replace status = 9 if status_description=="forfeited rights"
	replace status = 10 if status_description=="involuntarily dissolved"
	replace status = 11 if status_description=="judicially dissolved"
	replace status = 12 if status_description=="merged"
	replace status = 13 if status_description=="ra notice sent"
	replace status = 14 if status_description=="revoked"
	replace status = 15 if status_description=="terminated"
	replace status = 16 if status_description=="voluntarily dissolved"
	replace status = 17 if status_description=="withdrawn"
	replace status = 18 if status_description=="withdrawn on conversion"

	label define status_label ///
	 0 "other" ///
	 1 "in Existence" ///
	 2 "cancelled" ///
	 3 "consolidated" ///
	 4 "conversion" ///
	 5 "deleted" ///
	 6 "delinquent" ///
	 7 "expired" ///
	 8 "forfeited existence" ///
	 9 "forfeited rights" ///
	 10 "involuntarily dissolved" ///
	 11 "judicially dissolved" ///
	 12 "merged" ///
	 13 "ra notice sent" ///
	 14 "revoked" ///
	 15 "terminated" ///
	 16 "voluntarily dissolved" ///
	 17 "withdrawn" ///
	 18 "withdrawn on conversion"
	
	label values status status_label
	drop status_description
	
* replaces string variable of corporation type with numerical one
	gen corp_type_id = 0
	replace corp_type_id = 1 if corp_type=="domestic for-profit corporation"
	replace corp_type_id = 2 if corp_type=="domestic limited liability company (llc)"
	replace corp_type_id = 3 if corp_type=="domestic limited liability partnership (llp)"
	replace corp_type_id = 4 if corp_type=="domestic limited partnership (lp)"
	replace corp_type_id = 5 if corp_type=="domestic professional corporation"
	replace corp_type_id = 6 if corp_type=="domestic nonprofit corporation"
	replace corp_type_id = 7 if corp_type=="foreign for-profit corporation"
	replace corp_type_id = 8 if corp_type=="foreign limited liability company (llc)"
	replace corp_type_id = 9 if corp_type=="foreign limited partnership"
	replace corp_type_id = 10 if corp_type=="foreign professional association"
	replace corp_type_id = 11 if corp_type=="foreign professional corporation"
	replace corp_type_id = 12 if corp_type=="foreign nonprofit corporation"
	replace corp_type_id = 13 if corp_type=="foreign business trust"
	replace corp_type_id = 14 if corp_type=="other foreign entity"
	replace corp_type_id = 15 if corp_type=="professional association"
	replace corp_type_id = 16 if corp_type=="railroad company"
	replace corp_type_id = 17 if corp_type=="application for name reservation"

	label define corp_type_id_label ///
	0 "other" ///
	1 "domestic for-profit corporation" ///
	2 "domestic limited liability company (llc)" ///
	3 "domestic limited liability partnership (llp)" ///
	4 "domestic limited partnership (lp)" ///
	5 "domestic professional corporation" ///
	6 "domestic nonprofit corporation" ///
	7 "foreign for-profit corporation" ///
	8 "foreign limited liability company (llc)" ///
	9 "foreign limited partnership (lp)" ///
	10 "foreign professional association" ///
	11 "foreign professional corporation" ///
	12 "foreign nonprofit corporation" ///
	13 "foreign business trust" ///
	14 "other foreign entity" ///
	15 "professional association" ///
	16 "railroad company" ///
	17 "application for name reservation"

	label values corp_type_id corp_type_id_label
	drop corp_type
* creates aggregated officer title groups
gen officer_title_id = 0
replace officer_title_id = 15 if officer_title!=""

replace officer_title_id = 1 if ///
	(	regexm(officer_title, "chief") & ///
		regexm(officer_title, "officer")	) | ///
	regexm(officer_title, "ceo") | regexm(officer_title, "cfo") | regexm(officer_title, "cio")
replace officer_title_id = 2 if regexm(officer_title, "director")
replace officer_title_id = 3 if regexm(officer_title, "partner")
replace officer_title_id = 4 if regexm(officer_title, "govern")
replace officer_title_id = 5 if regexm(officer_title, "manager")
replace officer_title_id = 6 if regexm(officer_title, "member")
replace officer_title_id = 7 if regexm(officer_title, "owner")
replace officer_title_id = 8 if regexm(officer_title, "president")
replace officer_title_id = 9 if regexm(officer_title, "secretary")
replace officer_title_id = 10 if regexm(officer_title, "treasur")
replace officer_title_id = 11 if ///
	regexm(officer_title, "vice president") | ///
	regexm(officer_title, "vp") | regexm(officer_title, "vice")
replace officer_title_id =12 if regexm(officer_title, "found")
replace officer_title_id =13 if regexm(officer_title, "chair")
replace officer_title_id =14 if regexm(officer_title, "principal")

	label define officer_title_id_label ///
	 0 "none reported" ///
	 1 "C*O" ///
	 2 "Director" ///
	 3 "Partner" ///
	 4 "Governing Person" ///
	 5 "Manager" ///
	 6 "Member" ///
	 7 "Owner" ///
	 8 "President" ///
	 9 "Secretary" ///
	 10 "Treasurer" ///
	 11 "VP" ///
	 12 "Founder" ///
	 13 "Chairperson" ///
	 14 "Principal" ///
	 15 "Other"
	label values officer_title_id officer_title_id_label
		
save SoSData.dta, replace

timer off 1
timer list 1

************************* Error Checking: Austin MSA ***************************
* if not already done, create zipcode list
do AustinMSAZips.do

* merge the data on the zipcodes
use SoSData.dta, clear
merge m:1 entity_zip using austin_zips.dta
/*
   Result                           # of obs.
    -----------------------------------------
    not matched                           121
        from master                       109  (_merge==1)
        from using                         12  (_merge==2)

    matched                           555,991  (_merge==3)
    -----------------------------------------

Thus 555,991 records have zipcodes within the Austin MSA
*/
gen austin = 0
replace austin = 1 if _merge==3
drop _merge
			
* find number of unique filing numbers and entities
codebook filing_number entity_name
/*
------------------------------------------------------------------------------
filing_number                                                                 
------------------------------------------------------------------------------
         unique values:  234834                   missing .:  12/556112

------------------------------------------------------------------------------
entity_name
------------------------------------------------------------------------------
         unique values:  234370                   missing "":  16/556112
*/

* Indicate target(SoS) entities (Austin-MSA zipcodes that and for-profit)
*	used for matching later.
gen target_SoS = 0
replace target_SoS = 1 if (austin==1 & inlist(corp_type_id, 1,2,3,4,7,8,9,14))
gen interval = 0
replace interval = 1 if (1990<=year(creation_date) & year(creation_date)<=2013)

* add notes on variables
note filing_number: number assigned by the SoS when an entity is organized or registered with the SoS
note entity_name: name of the entity on file for the SoS
note creation_date: date of first registration with the SoS
note entity_address1: For a Texas corporation, this is the address on the ///
	public information report. For a foreign entity, this is the address ///
	listed in its application of certificate of authority or other similar ///
	document as its principle office. for a professional association, this ///
	is the address of its principal office. For a limited partnership, this ///
	is the address listed as the principal office in the US where records are kept.
note entity_address2: see entity_address1
note entity_city: see entity_address1
note entity_state: see entity_address1
note entity_zip: see entity_address1
note agent_business_name: name of registered agent firm
note agent_last_name: registered agent name
note agent_first_name: registered agent name
note agent_middle_name: registered agent name
note agent_address1: registered agent address
note agent_address2: registered agent address
note agent_city: registered agent address
note agent_state: registered agent address
note agent_zip: registered agent address
note officer_id: classifies officers by their title
note officer_title: officer's role
note officer_last_name: officer name
note officer_first_name: officer name
rename officee_address1 officer_address1
rename office_address2 officer_address2
note officer_address1: officer address
note officer_address2: officer address
note officer_city: officer address
note officer_state: officer address
note officer_zip: officer address
note de_incorp: binary indicator of foreign registration. The 'domestic' data ///
	has '0' and the 'foreign' data has '1'
note status: numerical variable of status type (see labels)
note corp_type_id: numerical variable of corporation type (see labels)
note austin: binary indicator of an AustinMSA zip code for the entity address
note target_SoS: binary indicator that the record is for a firm of interest. ///
	That is, the entity is in the AustinMSA (austin==1) and is a for-profit firm. ///
	For-Profit entities are: domestic and foreign corporations, LLCs, LLPs, LPs, and ///
	other foreign entities.
note interval: binary indicator that the creation_date of the record is in the ///
	same time interval as NETS (1990-2013).
note officer_title_id: grouped officer titles by similar keywords

save SoSData.dta, replace

timer off 1
timer list 1
