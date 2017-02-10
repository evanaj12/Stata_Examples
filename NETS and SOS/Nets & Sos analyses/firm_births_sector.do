/*
Using startup-firm-birth definitions established in
		year_comparison_full.do
and		exclusions_and_startup_candidates.do

This program determines startup firm birth in NETS data for the 
	established HT-IT sectors.

Evan Johnston 7-11-16
*/

set more off
timer clear 1
timer on 1

* import NETS
use NETSData.dta, clear

* keep HT startups only
keep if (startup == 1 & ht_ind>0)
save precollapse.dta, replace

* using the precollapse data,
*	iterate over firstyear and collapse dummy estabs_year over it_sector_first
forvalues i = 90(1) 99{
	use precollapse.dta, clear
	keep if firstyear==1900+`i'
	gen startups_`i' = 1
	collapse (sum) startups_`i', by(it_sector_first)
	save it_sector_startups_`i'.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
	use precollapse.dta, clear
	keep if firstyear==2000+`i'
	gen startups_`i' = 1
	collapse (sum) startups_`i', by(it_sector_first)
	save it_sector_startups_`i'.dta, replace
}

* merge the collapsed yearly it_sector_first files on it_sector_first
use it_sector_startups_90.dta, clear
save loop.dta, replace
forvalues i = 91(1) 99{
	use loop.dta, clear
	merge 1:1 it_sector_first using it_sector_startups_`i'.dta
	drop _merge
	save loop.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
	use loop.dta, clear
	merge 1:1 it_sector_first using it_sector_startups_`i'.dta
	drop _merge
	save loop.dta, replace
}
save it_startups.dta, replace

* import NETS
use NETSData.dta, clear

* keep HT non-sole prop startups only
keep if (quality_startup == 1 & ht_ind>0)
save precollapse.dta, replace

* using the precollapse data,
*	iterate over firstyear and collapse dummy estabs_year over it_sector_first
forvalues i = 90(1) 99{
	use precollapse.dta, clear
	keep if firstyear==1900+`i'
	gen qstartups_`i' = 1
	collapse (sum) qstartups_`i', by(it_sector_first)
	save it_sector_startups_`i'.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
	use precollapse.dta, clear
	keep if firstyear==2000+`i'
	gen qstartups_`i' = 1
	collapse (sum) qstartups_`i', by(it_sector_first)
	save it_sector_startups_`i'.dta, replace
}

* merge the collapsed yearly it_sector_first files on it_sector_first
use it_sector_startups_90.dta, clear
save loop.dta, replace
forvalues i = 91(1) 99{
	use loop.dta, clear
	merge 1:1 it_sector_first using it_sector_startups_`i'.dta
	drop _merge
	save loop.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
	use loop.dta, clear
	merge 1:1 it_sector_first using it_sector_startups_`i'.dta
	drop _merge
	save loop.dta, replace
}
save it_qstartups.dta, replace

use it_startups.dta, clear
merge 1:1 it_sector_first using it_qstartups.dta
drop _merge

* export merged set
export excel using "it_sector_startups", firstrow(variables) replace

use NETSData.dta, clear
keep if (startup == 1 & ht_ind>0)
tab ht_naics_first if it_sector_first==6
tab ht_title_first if it_sector_first==6
use NETSData.dta, clear
keep if (quality_startup == 1 & ht_ind>0)
tab ht_naics_first if it_sector_first==6
tab ht_title_first if it_sector_first==6

* erase the temporary datasets
forvalues i = 90(1) 99{
	erase it_sector_startups_`i'.dta
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13{
	erase it_sector_startups_`i'.dta
}
erase precollapse.dta
erase loop.dta
erase it_startups.dta
erase it_qstartups.dta
timer off 1
timer list 1
