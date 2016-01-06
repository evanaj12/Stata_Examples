*FIGURE 3
*EVAN JOHNSTON

*Find employment share for 8 occ groups for US
*1980
	use ipums_1980_5p.dta, clear

*Remove irrelevant variables for this calculation
	keep occ8cat res_tri perwt wkswork1 uhrswork
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

	save pre_collapse.dta, replace
*Create person work hours for figure 3
	gen pwrkhrs_80_us = 1
	collapse (sum) pwrkhrs_80_us [pw=laborwgt], by (occ8cat)
	*Drop missing from occ6cat
	drop if occ8cat==.
	
*Save collapsed data
	save fig3_80_us.dta, replace

*Repeat for res_tri
	use pre_collapse.dta, clear
	drop if res_tri!=1
	gen pwrkhrs_80_rt = 1
	collapse (sum) pwrkhrs_80_rt [pw=laborwgt], by (occ8cat)
	*Drop missing from occ6cat
	drop if occ8cat==.

	save fig3_80_rt.dta, replace

*2013
	use ipums_2013_1p.dta, clear

	keep occ8cat res_tri perwt wkswork1 uhrswork
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_13_us = 1
	collapse (sum) pwrkhrs_13_us [pw=laborwgt], by (occ8cat)
	*Drop missing from occ6cat
	drop if occ8cat==.

	save fig3_13_us.dta, replace

*Repeat for res_tri
	use pre_collapse.dta, clear
	drop if res_tri!=1
	gen pwrkhrs_13_rt = 1
	collapse (sum) pwrkhrs_13_rt [pw=laborwgt], by (occ8cat)
	*Drop missing from occ6cat
	drop if occ8cat==.

	save fig3_13_rt.dta, replace
	
*Merge data for figure 3
use fig3_80_us.dta, clear
merge 1:1 occ8cat using fig3_13_us.dta
drop _merge
merge 1:1 occ8cat using fig3_80_rt.dta
drop _merge
merge 1:1 occ8cat using fig3_13_rt.dta
drop _merge

export excel fig3.xlsx, first(var) replace
