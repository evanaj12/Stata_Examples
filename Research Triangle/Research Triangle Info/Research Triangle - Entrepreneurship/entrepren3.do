 *Entrepreneurship 3
*EVAN JOHNSTON

*Computes number of self-employed workers in res_tri by CoC categories
/*
NOTE TO SELF: CoC_high_tech or whatever gives only the high tech
broader categories. To get the NON HT ones we need to look at the 
old SV_A migration pies to see the main IND1990 categories.
*/

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt res_tri selfemp high_tech_CoC
	
*Only keep workers in res_tri
	drop if res_tri!=1

*Number of self-employed
	gen persons_80 = perwt
	
*COLLAPSE : to calculate total number of self-employed by sector
	collapse (sum) persons_80, by(selfemp high_tech_CoC)

*Save data	
	save selfemp3_80.dta, replace

*Repeat for 1990
use ipums_1990_5p.dta, clear
	keep perwt res_tri high_tech_CoC selfemp
	drop if res_tri!=1
	gen persons_90 = perwt
	collapse (sum) persons_90, by(selfemp high_tech_CoC)
	save selfemp3_90.dta, replace

*Repeat for 2000
use ipums_2000_5p.dta, clear
	keep perwt res_tri high_tech_CoC selfemp
	drop if res_tri!=1
	gen persons_00 = perwt
	collapse (sum) persons_00, by(selfemp high_tech_CoC)
	save selfemp3_00.dta, replace

*Repeat for 2005
use ipums_2005_1p.dta, clear
	keep perwt res_tri high_tech_CoC selfemp
	drop if res_tri!=1
	gen persons_05 = perwt
	collapse (sum) persons_05, by(selfemp high_tech_CoC)
	save selfemp3_05.dta, replace

*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt res_tri high_tech_CoC selfemp
	drop if res_tri!=1
	gen persons_13 = perwt
	collapse (sum) persons_13, by(selfemp high_tech_CoC)
	save selfemp3_13.dta, replace
	
*Combine into one table
use selfemp3_80.dta, clear
merge 1:1 selfemp high_tech using selfemp3_90.dta
drop _merge
merge 1:1 selfemp high_tech using selfemp3_00.dta
drop _merge
merge 1:1 selfemp high_tech using selfemp3_05.dta
drop _merge
merge 1:1 selfemp high_tech using selfemp3_13.dta
drop _merge

sort high_tech selfemp

*Export results to excel file
export excel selfemp3.xlsx, first(var) replace
