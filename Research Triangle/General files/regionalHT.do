*Tabulates the employment share of Hecker's (2005) HT industries for the 3 regions
*Evan Johnston

*Austin
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
*Change sample to be only in austin for those in HT-industry
	drop if austin!=1
	drop if high_tech!=1
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

	gen pwrkhrs_atx__80 = 1
	collapse (sum) pwrkhrs_atx__80 [pw=laborwgt], by (ind1990 ind1990_code)
	save atxHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_atx__90 = 1
	collapse (sum) pwrkhrs_atx__90 [pw=laborwgt], by (ind1990 ind1990_code)
	save atxHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_atx__00 = 1
	collapse (sum) pwrkhrs_atx__00 [pw=laborwgt], by (ind1990 ind1990_code)
	save atxHT_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_atx__05 = 1
	collapse (sum) pwrkhrs_atx__05 [pw=laborwgt], by (ind1990 ind1990_code)
	save atxHT_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_atx__13 = 1
	collapse (sum) pwrkhrs_atx__13 [pw=laborwgt], by (ind1990 ind1990_code)
	save atxHT_13.dta, replace

use atxHT_80.dta, clear
merge 1:1 ind1990 using atxHT_90.dta
drop _merge
merge 1:1 ind1990 using atxHT_00.dta
drop _merge
merge 1:1 ind1990 using atxHT_05.dta
drop _merge
merge 1:1 ind1990 using atxHT_13.dta
drop _merge

save atxHT.dta, replace
export excel atxHT.xlsx, first (var) replace

*Research Triangle
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

	gen pwrkhrs_rt__80 = 1
	collapse (sum) pwrkhrs_rt__80 [pw=laborwgt], by (ind1990 ind1990_code)
	save rtHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_rt__90 = 1
	collapse (sum) pwrkhrs_rt__90 [pw=laborwgt], by (ind1990 ind1990_code)
	save rtHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_rt__00 = 1
	collapse (sum) pwrkhrs_rt__00 [pw=laborwgt], by (ind1990 ind1990_code)
	save rtHT_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_rt__05 = 1
	collapse (sum) pwrkhrs_rt__05 [pw=laborwgt], by (ind1990 ind1990_code)
	save rtHT_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_rt__13 = 1
	collapse (sum) pwrkhrs_rt__13 [pw=laborwgt], by (ind1990 ind1990_code)
	save rtHT_13.dta, replace

use rtHT_80.dta, clear
merge 1:1 ind1990 using rtHT_90.dta
drop _merge
merge 1:1 ind1990 using rtHT_00.dta
drop _merge
merge 1:1 ind1990 using rtHT_05.dta
drop _merge
merge 1:1 ind1990 using rtHT_13.dta
drop _merge

save rtHT.dta, replace
export excel rtHT.xlsx, first (var) replace

*Silicon Valley
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
*Change sample to be only in svalley for those in HT-industry
	drop if svalley!=1
	drop if high_tech!=1
	
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt

	gen pwrkhrs_sv__80 = 1
	collapse (sum) pwrkhrs_sv__80 [pw=laborwgt], by (ind1990 ind1990_code)
	save svHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_sv__90 = 1
	collapse (sum) pwrkhrs_sv__90 [pw=laborwgt], by (ind1990 ind1990_code)
	save svHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_sv__00 = 1
	collapse (sum) pwrkhrs_sv__00 [pw=laborwgt], by (ind1990 ind1990_code)
	save svHT_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_sv__05 = 1
	collapse (sum) pwrkhrs_sv__05 [pw=laborwgt], by (ind1990 ind1990_code)
	save svHT_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_sv__13 = 1
	collapse (sum) pwrkhrs_sv__13 [pw=laborwgt], by (ind1990 ind1990_code)
	save svHT_13.dta, replace

use svHT_80.dta, clear
merge 1:1 ind1990 using svHT_90.dta
drop _merge
merge 1:1 ind1990 using svHT_00.dta
drop _merge
merge 1:1 ind1990 using svHT_05.dta
drop _merge
merge 1:1 ind1990 using svHT_13.dta
drop _merge

save svHT.dta, replace
export excel svHT.xlsx, first (var) replace
