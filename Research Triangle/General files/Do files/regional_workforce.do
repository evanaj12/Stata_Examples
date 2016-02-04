*Tabulates civilian labor force (people) for each region in each year
*Evan Johnston

*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	
*Create people	
	gen person_80= perwt

	collapse (sum) person_80, by (austin res_tri svalley high_tech employed selfemp)
	save laborF80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_90= perwt
	collapse (sum) person_90, by (austin res_tri svalley high_tech employed selfemp)
	save laborF90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_00= perwt
	collapse (sum) person_00, by (austin res_tri svalley high_tech employed selfemp)
	save laborF00.dta, replace

*2009-5y
	use ipums_2009_5y.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_09= perwt
	collapse (sum) person_09, by (austin res_tri svalley high_tech employed selfemp)
	save laborF09-5y.dta, replace

*2010
	use ipums_2010_1p.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_10= perwt
	collapse (sum) person_10, by (austin res_tri svalley high_tech employed selfemp)
	save laborF10.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_13= perwt
	collapse (sum) person_13, by (austin res_tri svalley high_tech employed selfemp)
	save laborF13.dta, replace
	
*2014
	use ipums_2014_1p.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_14= perwt
	collapse (sum) person_14, by (austin res_tri svalley high_tech employed selfemp)
	save laborF14.dta, replace
/* DATA NOT YET AVAILABLE
*2014-5y
	use ipums_2014_5y.dta, clear
	keep austin res_tri svalley perwt high_tech employed selfemp
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
	gen person_145y= perwt
	collapse (sum) person_14, by (austin res_tri svalley high_tech employed selfemp)
	save laborF145y.dta, replace
*/
use laborF80.dta, clear
merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF90.dta
drop _merge
merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF00.dta
drop _merge
merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF09-5y.dta
drop _merge
merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF10.dta
drop _merge
merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF13.dta
drop _merge
merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF14.dta
drop _merge
*merge 1:1 austin res_tri svalley high_tech employed selfemp using laborF145y.dta
*drop _merge

sort selfemp employed high_tech svalley res_tri austin

save laborF.dta, replace
export excel laborF.xlsx, first (var) replace
