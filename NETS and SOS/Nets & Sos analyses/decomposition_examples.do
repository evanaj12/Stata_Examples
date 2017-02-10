/*
Finds examples of certain NAICS codes selected from the decomposition

Evan Johnston
*/
set more off
timer clear 1
timer on 1

use NETSData.dta, clear
keep if quality_startup==1 & it_sector_first>0
save precollapse.dta, replace

foreach i in 1 2 3 4 5 6 {
	use precollapse.dta, clear
	keep if it_sector_first==`i'
	
	gen random = runiform()
	sort random
	gen sample_`i' = _n <= 10
	keep if sample_`i' == 1
	
	keep company it_sector_first ht_naics_first ht_title_first firstyear lastyear emp_last
	gen id = _n
	
	save sample_`i'.dta, replace
}

use sample_1.dta, clear
save loop.dta, replace
foreach i in 2 3 4 5 6 {
	use loop.dta, clear
	append using sample_`i'.dta
	save loop.dta, replace
}
export excel using "decomposion_examples", firstrow(variables) replace

forvalues i = 1(1) 6 {
	erase sample_`i'.dta
}
erase loop.dta
erase precollapse.dta

timer off 1
timer list 1
