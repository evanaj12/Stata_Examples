/*
Finds the most frequent NAICS codes in all of NETS

Evan Johnston
*/
set more off
timer clear 1
timer on 1

use NETSData.dta, clear
keep naics90 naics91 naics92 naics93 naics94 naics95 naics96 naics97 naics98 ///
	 naics99 naics00 naics01 naics02 naics03 naics04 naics05 naics06 naics07 ///
	 naics08 naics09 naics10 naics11 naics12
save precollapse.dta

gen no_naics = 0
replace no_naics = 1 if ///
	(naics90=="" & naics91=="" & naics92=="" & naics93=="" & naics94=="" & ///
	naics95=="" & naics96=="" & naics97=="" & naics98=="" & naics99=="" & ///
	naics00=="" & naics01=="" & naics02=="" & naics03=="" & naics04=="" & ///
	naics05=="" & naics06=="" & naics07=="" & naics08=="" & naics09=="" & ///
	naics10=="" & naics11=="" & naics12=="")
	
foreach i in 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 {
	use precollapse.dta, clear
	gen estabs_`i'=1
	collapse (sum) estabs_`i', by(naics`i')
	rename naics`i' naics
	save naics`i'.dta, replace
}
use naics90.dta, clear
save loop.dta, replace
foreach i in 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 {
	use loop.dta, clear
	merge 1:1 naics using naics`i'.dta
	drop _merge
	save loop.dta, replace
}

export excel using "naics_tabulation", firstrow(variables) replace

use precollapse.dta, clear
foreach i in 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 {
	gen d4_naics`i' = substr(naics`i',1,4)
	drop naics`i'
}
save precollapse.dta, replace

foreach i in 90 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 {
	use precollapse.dta, clear
	gen estabs_`i'=1
	collapse (sum) estabs_`i', by(d4_naics`i')
	rename d4_naics`i' d4_naics
	save d4_naics`i'.dta, replace
}
use d4_naics90.dta, clear
save loop.dta, replace
foreach i in 91 92 93 94 95 96 97 98 99 00 01 02 03 04 05 06 07 08 09 10 11 12 {
	use loop.dta, clear
	merge 1:1 d4_naics using d4_naics`i'.dta
	drop _merge
	save loop.dta, replace
}

export excel using "d4_naics_tabulation", firstrow(variables) replace

* erase the temporary datasets
forvalues i = 90(1) 99{
	erase naics`i'.dta
	erase d4_naics`i'.dta
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12{
	erase naics`i'.dta
	erase d4_naics`i'.dta
}
erase precollapse.dta
erase loop.dta

timer off 1
timer list 1
