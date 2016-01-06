*FIGURE 1
*EVAN JOHNSTON

*1980
	use ipums_1980_5p.dta, clear

*Change sample to be only in res_tri
	drop if res_tri!=1

*Remove unused variables
	keep sector perwt wkswork1 uhrswork
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

	save pre_collapse.dta, replace
*Create person work hours for figure 1
	gen pwrkhrs_80 = 1
	collapse (sum) pwrkhrs_80 [pw=laborwgt], by (sector)
	
*Save collapsed data
	save fig1_80.dta, replace

*2000
*repeat for 2000
	use ipums_2000_5p.dta, clear

	drop if res_tri!=1
	keep sector perwt wkswork1 uhrswork
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_00 = 1
	collapse (sum) pwrkhrs_00 [pw=laborwgt], by (sector)
	save fig1_00.dta, replace

*2013
*repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if res_tri!=1
	keep sector perwt wkswork1 uhrswork
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_13 = 1
	collapse (sum) pwrkhrs_13 [pw=laborwgt], by (sector)
	save fig1_13.dta, replace

*Merge data for figure 1
use fig1_80.dta, clear
merge 1:1 sector using fig1_00.dta
drop _merge
merge 1:1 sector using fig1_13.dta
drop _merge

export excel fig1.xlsx, first(var) replace
