*table 4
*EVAN JOHNSTON

*creates table 4 showing the education levels of ethnic groups in res_tri, 1980, 2013

*1980
	use ipums_1980_5p.dta, clear
	
*Remove unused variables
	keep perwt school race_group res_tri

*Keep only workers in res_tri
	drop if res_tri!=1
	
*Create persons
	gen persons_80 = perwt

*COLLAPSE by race group to
	collapse (sum) persons_80, by(race_group school)

*Save and export collapsed data
	save table4_80.dta, replace
	
*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt school race_group res_tri
	drop if res_tri!=1
	gen persons_13 = perwt
	collapse (sum) persons_13, by(race_group school)
	save table4_13.dta, replace
	
*Combine into one table
use table4_80.dta, clear
merge 1:1 race_group school using table4_13.dta
drop _merge

sort school race_group

*Export results to excel file
export excel table4.xlsx, first(var) replace
