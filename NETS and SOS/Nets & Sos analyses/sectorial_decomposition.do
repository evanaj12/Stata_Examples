/*
Shows distribution of NAICS codes in the IT sectors

Evan Johnston
*/
set more off
timer clear 1
timer on 1

use NETSData.dta, clear
keep naics90 naics91 naics92 naics93 naics94 naics95 naics96 naics97 naics98 ///
	 naics99 naics00 naics01 naics02 naics03 naics04 naics05 naics06 naics07 ///
	 naics08 naics09 naics10 naics11 naics12 ///
	 ht_ind it_sector_first it_sector_90 ht_title_first ht_naics_first startup_candidate
	 
decode it_sector_first, gen(it_sector_first_title)
gen description = "First IT sector = "+it_sector_first_title if it_sector_first_title!="."
gen estabs = 1
keep if startup_candidate==1
save precollapse.dta, replace

forvalues i = 1(1) 6 {
	use precollapse.dta, clear
	keep if it_sector_first==`i'
	notes it_sector_first
	display description
	*tab ht_title_first
	collapse (count) estabs, by(it_sector_first ht_naics_first ht_title_first)
	save it_sector_first_`i'.dta, replace
}
use it_sector_first_1.dta, clear
save loop.dta, replace
forvalues i = 2(1) 6 {
	use loop.dta, clear
	merge 1:1 it_sector_first ht_naics_first ht_title_first using it_sector_first_`i'.dta
	drop _merge
	save loop.dta, replace
}
sort it_sector_first estabs
export excel using "sector_decomposion", firstrow(variables) replace

forvalues i = 1(1) 6 {
	erase it_sector_first_`i'.dta
}
erase loop.dta
erase precollapse.dta

timer off 1
timer list 1
