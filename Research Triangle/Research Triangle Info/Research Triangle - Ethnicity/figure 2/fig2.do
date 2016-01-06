*FIGURE 2
*EVAN JOHNSTON

*1980
	use ipums_1980_5p.dta, clear

*Change sample to be only in res_tri for those in HT-industry
	drop if res_tri!=1
	drop if high_tech!=1

*Remove irrelevant variables for this calculation
	keep high_tech_CoC perwt wkswork1 uhrswork
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

	save pre_collapse.dta, replace
*A] Create # of jobs to compare to CoC data for validation
	gen jobs_80 = perwt

*Collpase jobs by CoC HT categories
	collapse (sum) jobs_80, by (high_tech_CoC)
	
*Save collapsed data
	save fig2_80_a.dta, replace

	use pre_collapse.dta, clear
*B] Create person work hours for figure 2
	gen pwrkhrs_80 = 1
	collapse (sum) pwrkhrs_80 [pw=laborwgt], by (high_tech_CoC)
	
*Save collapsed data
	save fig2_80_b.dta, replace

*2000
*repeat for 2000
	use ipums_2000_5p.dta, clear

	drop if res_tri!=1
	drop if high_tech!=1
	keep high_tech_CoC perwt wkswork1 uhrswork
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen jobs_00 = perwt
	collapse (sum) jobs_00, by (high_tech_CoC)
	save fig2_00_a.dta, replace
	use pre_collapse.dta, clear
	gen pwrkhrs_00 = 1
	collapse (sum) pwrkhrs_00 [pw=laborwgt], by (high_tech_CoC)
	save fig2_00_b.dta, replace

*2013
*repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if res_tri!=1
	drop if high_tech!=1
	keep high_tech_CoC perwt wkswork1 uhrswork
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen jobs_13 = perwt
	collapse (sum) jobs_13, by (high_tech_CoC)
	save fig2_13_a.dta, replace
	use pre_collapse.dta, clear
	gen pwrkhrs_13 = 1
	collapse (sum) pwrkhrs_13 [pw=laborwgt], by (high_tech_CoC)
	save fig2_13_b.dta, replace

*Merge data for validation (a)
use fig2_80_a.dta, clear
merge 1:1 high_tech_CoC using fig2_00_a.dta
drop _merge
merge 1:1 high_tech_CoC using fig2_13_a.dta
drop _merge

export excel fig2_a.xlsx, first(var) replace

*Merge data for figure 2 (b)
use fig2_80_b.dta, clear
merge 1:1 high_tech_CoC using fig2_00_b.dta
drop _merge
merge 1:1 high_tech_CoC using fig2_13_b.dta
drop _merge

export excel fig2_b.xlsx, first(var) replace
