*Entrepreneurship 2
*EVAN JOHNSTON

*Computes number of self-employed workers in Austin/SV/RT/US by HT and NHT sector
* for 1980-2013 inclusive.

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt svalley res_tri austin high_tech selfemp
	
*Only keep workers in Austin/SV/RT/US
	*drop if austin!=1
	*drop if svalley!=1
	drop if res_tri!=1

*Number of self-employed
	gen persons_80 = perwt
	
*COLLAPSE : to calculate total number of self-employed by sector
	collapse (sum) persons_80, by(selfemp high_tech)

*Save data	
	save selfemp2_80.dta, replace

*Repeat for 1990
use ipums_1990_5p.dta, clear
	keep perwt svalley res_tri austin high_tech selfemp
	*drop if austin!=1
	*drop if svalley!=1
	drop if res_tri!=1
	gen persons_90 = perwt
	collapse (sum) persons_90, by(selfemp high_tech)
	save selfemp2_90.dta, replace

*Repeat for 2000
use ipums_2000_5p.dta, clear
	keep perwt svalley res_tri austin high_tech selfemp
	*drop if austin!=1
	*drop if svalley!=1
	drop if res_tri!=1
	gen persons_00 = perwt
	collapse (sum) persons_00, by(selfemp high_tech)
	save selfemp2_00.dta, replace

*Repeat for 2005
use ipums_2005_1p.dta, clear
	keep perwt svalley res_tri austin high_tech selfemp
	*drop if austin!=1
	*drop if svalley!=1
	drop if res_tri!=1
	gen persons_05 = perwt
	collapse (sum) persons_05, by(selfemp high_tech)
	save selfemp2_05.dta, replace

*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt svalley res_tri austin high_tech selfemp
	*drop if austin!=1
	*drop if svalley!=1
	drop if res_tri!=1
	gen persons_13 = perwt
	collapse (sum) persons_13, by(selfemp high_tech)
	save selfemp2_13.dta, replace
	
*Combine into one table
use selfemp2_80.dta, clear
merge 1:1 selfemp high_tech using selfemp2_90.dta
drop _merge
merge 1:1 selfemp high_tech using selfemp2_00.dta
drop _merge
merge 1:1 selfemp high_tech using selfemp2_05.dta
drop _merge
merge 1:1 selfemp high_tech using selfemp2_13.dta
drop _merge

sort high_tech selfemp

*Export results to excel file
export excel selfemp2.xlsx, first(var) replace
