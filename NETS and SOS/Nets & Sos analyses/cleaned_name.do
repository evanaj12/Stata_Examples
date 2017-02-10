/*
Creates cleaned versions of:
	company, address_first, officer in NETSData
	and
	entity_name, entity_address1, entity_address2, 
		officer_first_name, officer_last_name in SOSData
		
	Currently saves these as "Data"Y.dta until further notice

Evan Johnston
*/

set more off
timer clear 1
timer clear 2
timer on 2
timer on 1

foreach i in NETSData SoSData {

	* use data "i"
	use `i'.dta, clear
		
	if "`i'"=="SoSData"{
		sort creation_date entity_name
		duplicates drop filing_number, force
		gen year=year(creation_date)
		keep if (1990<=year & year<=2012)
		keep if target_SoS==1
		drop year
		gen address_first=entity_address1+" "+entity_address2
		gen officer = officer_first_name+" "+officer_last_name
		gen company=entity_name
		gen data=1
	}
	else {
		gen data=2
		drop if startup_candidate==0
		*drop if ht_ind<1
		drop if it_sector_first!=3
	}
	
	foreach j in company address_first officer {
			replace `j'=lower(`j')
			gen cleaned_`j'=trim(itrim(subinstr(`j', ".", "",.)))
	}

	foreach j in company address_first officer {
		foreach k in , ? : ; ! @ # - "(" ")" "/" ///
			incorporated corporation "limited liability company" ///
			partnership "limited partnership" "l l c" "l l p" "l t d" ///
			" inc" " ltd" " llc" " llp" " lp" " corp" " pllc" {
			
				replace cleaned_`j' = subinstr(cleaned_`j', "`k'", "",.)
				replace cleaned_`j' = subinstr(cleaned_`j', " and ", " & ",.)
				replace cleaned_`j' = subinstr(cleaned_`j', `"""', "",.)
		}
		replace cleaned_`j' = trim(itrim(cleaned_`j'))
		recast str60 cleaned_`j', force

	}

	* remove unnamed
	drop if inlist(cleaned_company, "")
	
	replace data = 2 if ("`i'"=="SoSData" & data==.)
	replace data = 1 if ("`i'"=="NETSData" & data==.)
	
	label define data_label ///
		1 "SOS" ///
		2 "NETS"
	label values data data_label
	
	if "`i'"=="NETSData" {
		keep cleaned_company cleaned_address_first cleaned_officer zipcode_first data dunsnumber
	}
	if "`i'"=="SoSData" {
		keep cleaned_company cleaned_address_first cleaned_officer entity_zip data de_incorp filing_number
	}

	sort cleaned_company
	
	* save each dataY
	save `i'Y.dta, replace
}

foreach i in NETSDataY SoSDataY {
	use `i'.dta, clear
	foreach j in cleaned_company cleaned_address_first cleaned_officer {
		if "`i'"=="NETSDataY" {
			rename `j' `j'1 
		}
		if "`i'"=="SoSDataY" {
			rename `j' `j'2
		}
	}
	if "`i'"=="NETSDataY" {
		gen cleaned_company = cleaned_company1
	}
	if "`i'"=="SoSDataY" {
		gen cleaned_company = cleaned_company2
	}
	save `i'.dta, replace
}

/*
local i NETSDataY
local j things
local k substr("`i'",1,3)

display "`i'"
display "`j'"
display `k'
*/

timer off 1
timer list 1

*25 seconds

timer clear 1
timer on 1

/* Joining procedures (now using SAS instead)

use NETSDataY, clear
joinby cleaned_company using SoSDataY, unmatched(both)
tab _merge
save join1.dta, replace
use NETSDataY, clear
joinby cleaned_address_first using SoSDataY, unmatched(both)
tab _merge
save join2.dta, replace

use NETSDataY, clear
joinby cleaned_company cleaned_address_first using SoSDataY, unmatched(both)
tab _merge
save join3.dta, replace

use NETSDataY, clear
joinby cleaned_company cleaned_address_first cleaned_officer using SoSDataY, unmatched(both)
tab _merge
save join4.dta, replace

timer off 1
timer off 2

*70 seconds

timer list 1
timer list 2

*117 seconds
