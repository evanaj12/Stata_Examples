/*
Using startup-firm-birth definitions established in
		year_comparison_full.do
and		exclusions_and_startup_candidates.do

This program determines startup firm birth in NETS data for the 
	HT and Non-HT industries.

Evan Johnston 10-21-16
*/

set more off
timer clear 1
timer on 1

* import NETS
use NETSData.dta, clear

* keep quality startups only
keep if (startup == 1)
gen ht_binary = (ht_ind>0)
save precollapse.dta, replace

* using the precollapse data,
*	iterate over firstyear and collapse dummy estabs_year over it_sector_first
forvalues i = 90(1) 99{
	use precollapse.dta, clear
	keep if firstyear==1900+`i'
	gen startups_`i' = 1
	collapse (sum) startups_`i', by(ht_binary)
	save startups_`i'.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12{
	use precollapse.dta, clear
	keep if firstyear==2000+`i'
	gen startups_`i' = 1
	collapse (sum) startups_`i', by(ht_binary)
	save startups_`i'.dta, replace
}

* merge the collapsed yearly it_sector_first files on it_sector_first
use startups_90.dta, clear
save loop.dta, replace
forvalues i = 91(1) 99{
	use loop.dta, clear
	merge 1:1 ht_binary using startups_`i'.dta
	drop _merge
	save loop.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12{
	use loop.dta, clear
	merge 1:1 ht_binary using startups_`i'.dta
	drop _merge
	save loop.dta, replace
}
save startups_ht_nht.dta, replace

* import NETS
use NETSData.dta, clear

* keep non-sole prop startups only
keep if (quality_startup == 1)
gen ht_binary = (ht_ind>0)
save precollapse.dta, replace

* using the precollapse data,
*	iterate over firstyear and collapse dummy estabs_year over it_sector_first
forvalues i = 90(1) 99{
	use precollapse.dta, clear
	keep if firstyear==1900+`i'
	gen qstartups_`i' = 1
	collapse (sum) qstartups_`i', by(ht_binary)
	save qstartups_`i'.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12{
	use precollapse.dta, clear
	keep if firstyear==2000+`i'
	gen qstartups_`i' = 1
	collapse (sum) qstartups_`i', by(ht_binary)
	save qstartups_`i'.dta, replace
}

* merge the collapsed yearly it_sector_first files on it_sector_first
use qstartups_90.dta, clear
save loop.dta, replace
forvalues i = 91(1) 99{
	use loop.dta, clear
	merge 1:1 ht_binary using qstartups_`i'.dta
	drop _merge
	save loop.dta, replace
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12{
	use loop.dta, clear
	merge 1:1 ht_binary using qstartups_`i'.dta
	drop _merge
	save loop.dta, replace
}
save qstartups_ht_nht.dta, replace

use startups_ht_nht.dta, clear
merge 1:1 ht_binary using qstartups_ht_nht.dta
drop _merge

* export merged set
export excel using "startups_ht_nht", firstrow(variables) replace

/*
use NETSData.dta, clear
keep if (startup == 1 & ht_ind>0)
tab ht_naics_first if it_sector_first==6
tab ht_title_first if it_sector_first==6
use NETSData.dta, clear
keep if (quality_startup == 1 & ht_ind>0)
tab ht_naics_first if it_sector_first==6
tab ht_title_first if it_sector_first==6
*/
* erase the temporary datasets
forvalues i = 90(1) 99{
	erase startups_`i'.dta
	erase qstartups_`i'.dta
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12{
	erase startups_`i'.dta
	erase qstartups_`i'.dta
}
erase precollapse.dta
erase loop.dta
erase startups_ht_nht.dta
erase qstartups_ht_nht.dta
timer off 1
timer list 1
