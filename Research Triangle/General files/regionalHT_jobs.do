*Tabulates the employment share of Hecker's (2005) HT industries for the 3 regions
*Evan Johnston

*Austin
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
*Change sample to be only in austin for those in HT-industry
	drop if austin!=1
	drop if high_tech!=1
	
*Create jobs	
	gen jobs_atx__80= perwt

	collapse (sum) jobs_atx__80, by (ind1990 ind1990_code)
	save atxHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen jobs_atx__90= perwt
	collapse (sum) jobs_atx__90, by (ind1990 ind1990_code)
	save atxHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen jobs_atx__00= perwt
	collapse (sum) jobs_atx__00, by (ind1990 ind1990_code)
	save atxHT_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen jobs_atx__05= perwt
	collapse (sum) jobs_atx__05, by (ind1990 ind1990_code)
	save atxHT_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if austin!=1
	drop if high_tech!=1
	gen jobs_atx__13= perwt
	collapse (sum) jobs_atx__13, by (ind1990 ind1990_code)
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

save atxHTjobs.dta, replace
export excel atxHTjobs.xlsx, first (var) replace

*Research Triangle
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
*Change sample to be only in res_tri for those in HT-industry
	drop if res_tri!=1
	drop if high_tech!=1
	
*Create jobs	
	gen jobs_rt__80= perwt

	collapse (sum) jobs_rt__80, by (ind1990 ind1990_code)
	save rtHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen jobs_rt__90= perwt
	collapse (sum) jobs_rt__90, by (ind1990 ind1990_code)
	save rtHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen jobs_rt__00= perwt
	collapse (sum) jobs_rt__00, by (ind1990 ind1990_code)
	save rtHT_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen jobs_rt__05= perwt
	collapse (sum) jobs_rt__05, by (ind1990 ind1990_code)
	save rtHT_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if res_tri!=1
	drop if high_tech!=1
	gen jobs_rt__13= perwt
	collapse (sum) jobs_rt__13, by (ind1990 ind1990_code)
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

save rtHTjobs.dta, replace
export excel rtHTjobs.xlsx, first (var) replace

*Silicon Valley
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
*Change sample to be only in svalley for those in HT-industry
	drop if svalley!=1
	drop if high_tech!=1
	
*Create jobs	
	gen jobs_sv__80= perwt

	collapse (sum) jobs_sv__80, by (ind1990 ind1990_code)
	save svHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen jobs_sv__90= perwt
	collapse (sum) jobs_sv__90, by (ind1990 ind1990_code)
	save svHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen jobs_sv__00= perwt
	collapse (sum) jobs_sv__00, by (ind1990 ind1990_code)
	save svHT_00.dta, replace

*2005
	use ipums_2005_1p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen jobs_sv__05= perwt
	collapse (sum) jobs_sv__05, by (ind1990 ind1990_code)
	save svHT_05.dta, replace

*2013
	use ipums_2013_1p.dta, clear
	gen ind1990_code = ind1990
	drop if svalley!=1
	drop if high_tech!=1
	gen jobs_sv__13= perwt
	collapse (sum) jobs_sv__13, by (ind1990 ind1990_code)
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

save svHTjobs.dta, replace
export excel svHTjobs.xlsx, first (var) replace
