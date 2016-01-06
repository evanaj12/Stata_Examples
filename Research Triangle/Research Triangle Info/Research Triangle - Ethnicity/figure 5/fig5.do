*FIGURE 5
*EVAN JOHNSTON

*Find employment share for 8 occ groups in HT-industries
*1980
	use ipums_1980_5p.dta, clear

*Only keep R.T.
	drop if res_tri != 1

*Remove irrelevant variables for this calculation
	keep occ8cat high_tech perwt wkswork1 uhrswork
	
save pre_collapse.dta, replace
*Only keep HT workers
	drop if high_tech != 1
	
*Create # of jobs
	gen jobs_80_ht = perwt

*Collpase jobs 8 occupations
	collapse (sum) jobs_80_ht, by (occ8cat)
	drop if occ8cat==.
	
*Save collapsed data
	save fig5_80_ht.dta, replace

*Repeat for Non-HT-industries
use pre_collapse.dta, replace

*Only keep Non-HT workers
	drop if high_tech != 0
	
	gen jobs_80_nht = perwt
	collapse (sum) jobs_80_nht, by (occ8cat)
	drop if occ8cat==.
	save fig5_80_nht.dta, replace
	
*Repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if res_tri != 1
	keep occ8cat high_tech perwt wkswork1 uhrswork
save pre_collapse.dta, replace
	drop if high_tech != 1
	gen jobs_13_ht = perwt
	collapse (sum) jobs_13_ht, by (occ8cat)
	drop if occ8cat==.
	save fig5_13_ht.dta, replace
use pre_collapse.dta, replace
	drop if high_tech != 0
	gen jobs_13_nht = perwt
	collapse (sum) jobs_13_nht, by (occ8cat)
	drop if occ8cat==.
	save fig5_13_nht.dta, replace
	
*Merge data for figure 5
use fig5_80_ht.dta, clear
merge 1:1 occ8cat using fig5_80_nht.dta
drop _merge
merge 1:1 occ8cat using fig5_13_ht.dta
drop _merge
merge 1:1 occ8cat using fig5_13_nht.dta
drop _merge

export excel fig5.xlsx, first(var) replace
