*FIGURE 7
*EVAN JOHNSTON

*1980
	use ipums_1980_5p.dta, clear

*Change sample to be only in res_tri
	drop if res_tri!=1

*Remove irrelevant variables for this calculation
	keep race_group occ8cat high_tech perwt
	
save pre_collapse.dta, replace

*Keep only Anglo workers
	drop if race_group != 1
	
*Create # of jobs
	gen jobs_80_a = perwt

*Collpase jobs by CoC HT categories
	collapse (sum) jobs_80_a, by (occ8cat high_tech)
	drop if occ8cat==.
	
*Save and export collapsed data
	save fig7_80_a.dta, replace

*Repeat for Hispanic workers
use pre_collapse.dta, clear
	drop if race_group != 5
	gen jobs_80_h = perwt
	collapse (sum) jobs_80_h, by (occ8cat high_tech)
	drop if occ8cat==.
	save fig7_80_h.dta, replace	
	
*2013
*repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if res_tri!=1
	keep race_group occ8cat high_tech perwt
save pre_collapse.dta, replace
	drop if race_group != 1
	gen jobs_13_a = perwt
	collapse (sum) jobs_13_a, by (occ8cat high_tech)
	drop if occ8cat==.
	save fig7_13_a.dta, replace
use pre_collapse.dta, clear
	drop if race_group != 5
	gen jobs_13_h = perwt
	collapse (sum) jobs_13_h, by (occ8cat high_tech)
	drop if occ8cat==.
	save fig7_13_h.dta, replace	
	
*Merge all datasets for figure 7
use fig7_80_a.dta, replace
merge 1:1 occ8cat high_tech using fig7_80_h.dta
drop _merge
merge 1:1 occ8cat high_tech using fig7_13_a.dta
drop _merge
merge 1:1 occ8cat high_tech using fig7_13_h.dta
drop _merge

export excel fig7.xlsx, first(var) replace
