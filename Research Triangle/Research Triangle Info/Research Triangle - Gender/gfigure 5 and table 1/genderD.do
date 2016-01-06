*Employment (jobs) by 4 occupation groups in res_tri for males/females by
*	HT and NHT
*EVAN JOHNSTON

*Shows the number of jobs for males and females in HT vs NHT industry
*	in res_tri, 1980 and 2013.

*1980
	use ipums_1980_5p.dta, clear
	
*Change sample to be only in res_tri
	drop if res_tri!=1
	
*Remove irrelevant variables for this calculation
	keep perwt occ4cat res_tri sex high_tech
	
*Create # of jobs
	gen jobs_80 = perwt
	
*Collpase jobs by gender and HT status
	collapse (sum) jobs_80, by(occ4cat sex high_tech)
	drop if (occ4cat==. | sex==. | sex==0)
	save genderD_80.dta, replace

*Repeat for 2013
use ipums_2013_1p.dta, clear
	drop if res_tri!=1
	keep perwt occ4cat res_tri sex high_tech
	gen jobs_13 = perwt
	collapse (sum) jobs_13, by(occ4cat sex high_tech)
	drop if (occ4cat==. | sex==. | sex==0)
	save genderD_13.dta, replace
	
*Combine into one table
use genderD_80.dta, clear
merge 1:1 occ4cat sex high_tech using genderD_13.dta
drop _merge

sort sex high_tech occ4cat

*Export results to excel file
export excel genderD.xlsx, first(var) replace
