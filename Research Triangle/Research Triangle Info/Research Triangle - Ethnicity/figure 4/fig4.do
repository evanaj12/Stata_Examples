*FIGURE 4
*EVAN JOHNSTON

*Find employment share for 8 occ groups in HT-industries
*1980
	use ipums_1980_5p.dta, clear

*Only keep res_triites
	drop if res_tri != 1

*Remove irrelevant variables for this calculation
	keep occ8cat high_tech perwt wkswork1 uhrswork
	
save pre_collapse.dta, replace
*Only keep HT workers
	drop if high_tech != 1
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

*Create person work hours for figure 4
	gen pwrkhrs_80_ht = 1
	collapse (sum) pwrkhrs_80_ht [pw=laborwgt], by (occ8cat)
	*Drop missing from occ6cat
	drop if occ8cat==.
	
*Save collapsed data
	save fig4_80_ht.dta, replace

*Repeat for Non-HT-industries
use pre_collapse.dta, replace

*Only keep Non-HT workers
	drop if high_tech != 0
	
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_80_nht = 1
	collapse (sum) pwrkhrs_80_nht [pw=laborwgt], by (occ8cat)
	drop if occ8cat==.
	save fig4_80_nht.dta, replace
	
*Repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if res_tri != 1
	keep occ8cat high_tech perwt wkswork1 uhrswork
	
save pre_collapse.dta, replace
	drop if high_tech != 1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13_ht = 1
	collapse (sum) pwrkhrs_13_ht [pw=laborwgt], by (occ8cat)
	drop if occ8cat==.
	save fig4_13_ht.dta, replace
use pre_collapse.dta, replace
	drop if high_tech != 0
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13_nht = 1
	collapse (sum) pwrkhrs_13_nht [pw=laborwgt], by (occ8cat)
	drop if occ8cat==.
	save fig4_13_nht.dta, replace
	
*Merge data for figure 4
use fig4_80_ht.dta, clear
merge 1:1 occ8cat using fig4_80_nht.dta
drop _merge
merge 1:1 occ8cat using fig4_13_ht.dta
drop _merge
merge 1:1 occ8cat using fig4_13_nht.dta
drop _merge

export excel fig4.xlsx, first(var) replace
