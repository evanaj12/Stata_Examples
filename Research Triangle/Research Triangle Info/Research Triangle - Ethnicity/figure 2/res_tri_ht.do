*tests to see which of Hecker's HT-Industries are in R.T.
*Evan Johnston

*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
*Change sample to be only in res_tri for those in HT-industry
	drop if res_tri!=1
	drop if high_tech!=1
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

	gen pwrkhrs_80 = 1
	collapse (sum) pwrkhrs_80 [pw=laborwgt], by (ind1990 ind1990_code)
	save rt_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_90 = 1
	collapse (sum) pwrkhrs_90 [pw=laborwgt], by (ind1990 ind1990_code)
	save rt_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_00 = 1
	collapse (sum) pwrkhrs_00 [pw=laborwgt], by (ind1990 ind1990_code)
	save rt_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_05 = 1
	collapse (sum) pwrkhrs_05 [pw=laborwgt], by (ind1990 ind1990_code)
	save rt_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13 = 1
	collapse (sum) pwrkhrs_13 [pw=laborwgt], by (ind1990 ind1990_code)
	save rt_13.dta, replace

use rt_80.dta, clear
merge 1:1 ind1990 using rt_90.dta
drop _merge
merge 1:1 ind1990 using rt_00.dta
drop _merge
merge 1:1 ind1990 using rt_05.dta
drop _merge
merge 1:1 ind1990 using rt_13.dta
drop _merge

save rt.dta, replace
export excel rt.xlsx, first (var) replace
