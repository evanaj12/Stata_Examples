*FIGURE 6
*EVAN JOHNSTON

*1980
	use ipums_1980_5p.dta, clear

*Change sample to be only in res_tri
	drop if res_tri!=1

*Remove irrelevant variables for this calculation
	keep race_group occ8cat perwt
	
*Create # of jobs
	gen jobs_80 = perwt

*Collpase jobs by CoC HT categories
	collapse (sum) jobs_80, by (occ8cat race_group)
	drop if occ8cat==.
	
*Save and export collapsed data
	save fig6_80.dta, replace
	export excel fig6_80.xlsx, first(var) replace

*2013
*repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if res_tri!=1
	keep race_group occ8cat perwt
	gen jobs_13 = perwt
	collapse (sum) jobs_13, by (occ8cat race_group)
	drop if occ8cat==.
	save fig6_13.dta, replace
	export excel fig6_13.xlsx, first(var) replace
