*Entrepreneurship 1
*EVAN JOHNSTON

*Computes number of self-employed workers in res_tri by HT and NHT sector
* for 1980-2013 inclusive.

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt res_tri high_tech selfemp_inc
	
*Only keep self-employed workers in res_tri
	drop if res_tri!=1
	drop if selfemp_inc!=1

*Number of self-employed
	gen self_emp_80 = perwt
	
*COLLAPSE : to calculate total number of self-employed by sector
	collapse (sum) self_emp_80, by(high_tech)

*Save data	
	save selfemp1_80.dta, replace

*Repeat for 1990
use ipums_1990_5p.dta, clear
	keep perwt res_tri high_tech selfemp_inc
	drop if res_tri!=1
	drop if selfemp_inc!=1
	gen self_emp_90 = perwt
	collapse (sum) self_emp_90, by(high_tech)
	save selfemp1_90.dta, replace

*Repeat for 2000
use ipums_2000_5p.dta, clear
	keep perwt res_tri high_tech selfemp_inc
	drop if res_tri!=1
	drop if selfemp_inc!=1
	gen self_emp_00 = perwt
	collapse (sum) self_emp_00, by(high_tech)
	save selfemp1_00.dta, replace

*Repeat for 2005
use ipums_2005_1p.dta, clear
	keep perwt res_tri high_tech selfemp_inc
	drop if res_tri!=1
	drop if selfemp_inc!=1
	gen self_emp_05 = perwt
	collapse (sum) self_emp_05, by(high_tech)
	save selfemp1_05.dta, replace

*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt res_tri high_tech selfemp_inc
	drop if res_tri!=1
	drop if selfemp_inc!=1
	gen self_emp_13 = perwt
	collapse (sum) self_emp_13, by(high_tech)
	save selfemp1_13.dta, replace

*Combine into one table
use selfemp1_80.dta, clear
merge 1:1 high_tech using selfemp1_90.dta
drop _merge
merge 1:1 high_tech using selfemp1_00.dta
drop _merge
merge 1:1 high_tech using selfemp1_05.dta
drop _merge
merge 1:1 high_tech using selfemp1_13.dta
drop _merge

sort high_tech

*Export results to excel file
export excel selfemp1.xlsx, first(var) replace
