/*
Firm births for:
	Texas registrations (SOS)
	Delaware registrations (SOS)
	Firm births (NETS)

Evan Johnston
*/

set more off

use SoSdata.dta, clear
			
* Only keep for-profit firms in AustinMSA zips
keep if target_SoS==1

* keep only unique filing numbers		
sort entity_name
duplicates drop filing_number, force
drop if entity_name==""

* collapse by year
gen year = year(creation_date)

* drop 2016 registrations
drop if year==2016

save precollapse.dta, replace

* keep only delaware-incorporated firms
keep if de_incorp==1
gen files_DE = 1
collapse (sum) files_DE, by(year)
save de_temp.dta, replace

use precollapse.dta, clear
* keep only texas-incorporated firms
keep if de_incorp==0
gen files_TX = 1
collapse (sum) files_TX, by(year)
save tx_temp.dta, replace

* Startups in NETS
use NETSData.dta, clear

* startup criteria (created in exclusions_and_startup_candidates.do file called in the NETS_format.do file)
/* 	1) started between 1990 and 2012 in the Austin MSA
	2) is not a Branch establishment category
	3) is not a non-profit legal status
	4) does not have an excluded NAICS code status
	5) is not a sole proprietorship by legalstatus or employment (had 1 employee in first year)
*/

* the startup variable satisfies criteria 1-4
notes startup
keep if startup == 1
gen NETS_startups = 1
collapse (sum) NETS_startups, by(firstyear)
gen year=firstyear
drop firstyear
sort year
save nets_temp_s.dta, replace

use NETSData.dta, clear

* the quality startup variable satisfies criteria 1-5 (removes sole-proprietors)
notes quality_startup
keep if quality_startup == 1
gen NETS_quality_startups = 1
collapse (sum) NETS_quality_startups, by(firstyear)
gen year=firstyear
drop firstyear
sort year
save nets_temp_qs.dta, replace

* startup_candidate_i are sequential startup candidate defs building to all 5
* e.g. startup_2_crit satisfies criteria 1 and 2 only
foreach i in 1 2 3 {
	use NETSData.dta, clear
	keep if startup_`i'_crit == 1
	gen NETS_startcrit_`i' = 1
	collapse (sum) NETS_startcrit_`i', by(firstyear)
	gen year=firstyear
	drop firstyear
	sort year
	save nets_temp_sc`i'.dta, replace
}

use de_temp.dta, clear
merge 1:1 year using tx_temp.dta
drop _merge
merge 1:1 year using nets_temp_sc1.dta
drop _merge
merge 1:1 year using nets_temp_sc2.dta
drop _merge
merge 1:1 year using nets_temp_sc3.dta
drop _merge
merge 1:1 year using nets_temp_s.dta
drop _merge
merge 1:1 year using nets_temp_qs.dta
drop _merge

sort year

erase de_temp.dta
erase tx_temp.dta
erase nets_temp_sc1.dta
erase nets_temp_sc2.dta
erase nets_temp_sc3.dta
erase nets_temp_s.dta
erase nets_temp_qs.dta
erase precollapse.dta

* export
export excel using "AnnualFilings_DE_TX_NETSbirths", firstrow(variables) replace

