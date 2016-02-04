*Tabulates the employment share of Hecker's (2005) HT industries for the 3 regions
*Evan Johnston

timer clear 1
timer on 1

*U.S.
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep high_tech employed perwt ind1990 ind1990_code

*Change sample to be only HT-industry workers
	drop if high_tech!=1
	drop if employed!=1
	
*Create 	
	gen jobs_us_80= perwt

	collapse (sum) jobs_us_80, by (ind1990 ind1990_code)
	save usHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep high_tech employed perwt ind1990 ind1990_code
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_us_90= perwt
	collapse (sum) jobs_us_90, by (ind1990 ind1990_code)
	save usHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep high_tech employed perwt ind1990 ind1990_code
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_us_00= perwt
	collapse (sum) jobs_us_00, by (ind1990 ind1990_code)
	save usHT_00.dta, replace
	
*2009-5y
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep high_tech employed perwt ind1990 ind1990_code
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_us_09= perwt
	collapse (sum) jobs_us_09, by (ind1990 ind1990_code)
	save usHT_09.dta, replace
	
*2014
	use ipums_2014_1p.dta, clear
	gen ind1990_code = ind1990
	keep high_tech employed perwt ind1990 ind1990_code
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_us_14= perwt
	collapse (sum) jobs_us_14, by (ind1990 ind1990_code)
	save usHT_14.dta, replace

use usHT_80.dta, clear
merge 1:1 ind1990 using usHT_90.dta
drop _merge
merge 1:1 ind1990 using usHT_00.dta
drop _merge
merge 1:1 ind1990 using usHT_09.dta
drop _merge
merge 1:1 ind1990 using usHT_14.dta
drop _merge

save usHT.dta, replace
export excel usHTjobs.xlsx, first (var) replace

*Austin
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech employed perwt ind1990 ind1990_code
	
*Change sample to be only workers in austin for those in HT-industry
	drop if austin!=1
	drop if high_tech!=1
	drop if employed!=1
	
*Create jobs	
	gen jobs_atx__80= perwt

	collapse (sum) jobs_atx__80, by (ind1990 ind1990_code)
	save atxHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech employed perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_atx__90= perwt
	collapse (sum) jobs_atx__90, by (ind1990 ind1990_code)
	save atxHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech employed perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_atx__00= perwt
	collapse (sum) jobs_atx__00, by (ind1990 ind1990_code)
	save atxHT_00.dta, replace

*2009
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech employed perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_atx__09= perwt
	collapse (sum) jobs_atx__09, by (ind1990 ind1990_code)
	save atxHT_09.dta, replace
	
*2014
	use ipums_2014_1p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech employed perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_atx__14= perwt
	collapse (sum) jobs_atx__14, by (ind1990 ind1990_code)
	save atxHT_14.dta, replace
	
use atxHT_80.dta, clear
merge 1:1 ind1990 using atxHT_90.dta
drop _merge
merge 1:1 ind1990 using atxHT_00.dta
drop _merge
merge 1:1 ind1990 using atxHT_09.dta
drop _merge
merge 1:1 ind1990 using atxHT_14.dta
drop _merge

save atxHTjobs.dta, replace
export excel atxHTjobs.xlsx, first (var) replace

*Research Triangle
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech employed perwt ind1990 ind1990_code

*Change sample to be only workers in res_tri for those in HT-industry
	drop if res_tri!=1
	drop if high_tech!=1
	drop if employed!=1
	
*Create jobs	
	gen jobs_rt__80= perwt

	collapse (sum) jobs_rt__80, by (ind1990 ind1990_code)
	save rtHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech employed perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_rt__90= perwt
	collapse (sum) jobs_rt__90, by (ind1990 ind1990_code)
	save rtHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech employed perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_rt__00= perwt
	collapse (sum) jobs_rt__00, by (ind1990 ind1990_code)
	save rtHT_00.dta, replace

*2009
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech employed perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_rt__09= perwt
	collapse (sum) jobs_rt__09, by (ind1990 ind1990_code)
	save rtHT_09.dta, replace

*2014
	use ipums_2014_1p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech employed perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_rt__14= perwt
	collapse (sum) jobs_rt__14, by (ind1990 ind1990_code)
	save rtHT_14.dta, replace
	
use rtHT_80.dta, clear
merge 1:1 ind1990 using rtHT_90.dta
drop _merge
merge 1:1 ind1990 using rtHT_00.dta
drop _merge
merge 1:1 ind1990 using rtHT_09.dta
drop _merge
merge 1:1 ind1990 using rtHT_14.dta
drop _merge

save rtHTjobs.dta, replace
export excel rtHTjobs.xlsx, first (var) replace

*Silicon Valley
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech employed perwt ind1990 ind1990_code

*Change sample to be only workers in svalley for those in HT-industry
	drop if svalley!=1
	drop if high_tech!=1
	drop if employed!=1
	
*Create jobs	
	gen jobs_sv__80= perwt

	collapse (sum) jobs_sv__80, by (ind1990 ind1990_code)
	save svHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech employed perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_sv__90= perwt
	collapse (sum) jobs_sv__90, by (ind1990 ind1990_code)
	save svHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech employed perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_sv__00= perwt
	collapse (sum) jobs_sv__00, by (ind1990 ind1990_code)
	save svHT_00.dta, replace

*2009
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech employed perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_sv__09= perwt
	collapse (sum) jobs_sv__09, by (ind1990 ind1990_code)
	save svHT_09.dta, replace

*2014
	use ipums_2014_1p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech employed perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if employed!=1
	gen jobs_sv__14= perwt
	collapse (sum) jobs_sv__14, by (ind1990 ind1990_code)
	save svHT_14.dta, replace
	
use svHT_80.dta, clear
merge 1:1 ind1990 using svHT_90.dta
drop _merge
merge 1:1 ind1990 using svHT_00.dta
drop _merge
merge 1:1 ind1990 using svHT_09.dta
drop _merge
merge 1:1 ind1990 using svHT_14.dta
drop _merge

save svHTjobs.dta, replace
export excel svHTjobs.xlsx, first (var) replace

timer off 1
timer list 1
