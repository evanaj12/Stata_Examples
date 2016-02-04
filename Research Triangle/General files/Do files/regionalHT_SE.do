*Tabulates the number of self-employed workers in the HT industries for the 3 regions
*Evan Johnston

timer clear 1
timer on 1

*Austin
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech selfemp perwt ind1990 ind1990_code

*Change sample to be only self-employed, HT-industry workers in austin
	drop if austin!=1
	drop if high_tech!=1
	drop if selfemp!=1
	
*Create selfE	
	gen selfE_atx__80= perwt

	collapse (sum) selfE_atx__80, by (ind1990 ind1990_code)
	save atxHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech selfemp perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_atx__90= perwt
	collapse (sum) selfE_atx__90, by (ind1990 ind1990_code)
	save atxHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech selfemp perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_atx__00= perwt
	collapse (sum) selfE_atx__00, by (ind1990 ind1990_code)
	save atxHT_00.dta, replace

*2009-5y
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech selfemp perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_atx__09= perwt
	collapse (sum) selfE_atx__09, by (ind1990 ind1990_code)
	save atxHT_09.dta, replace

/* DATA NOT YET AVAILABLE
*2014-5y
	use ipums_2014_5y.dta, clear
	gen ind1990_code = ind1990
	keep austin high_tech selfemp perwt ind1990 ind1990_code
	drop if austin!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_atx__14= perwt
	collapse (sum) selfE_atx__14, by (ind1990 ind1990_code)
	save atxHT_14.dta, replace
*/
use atxHT_80.dta, clear
merge 1:1 ind1990 using atxHT_90.dta
drop _merge
merge 1:1 ind1990 using atxHT_00.dta
drop _merge
merge 1:1 ind1990 using atxHT_09.dta
drop _merge
*merge 1:1 ind1990 using atxHT_14.dta
*drop _merge

save atxHTselfE.dta, replace
export excel atxHTselfE.xlsx, first (var) replace

*Research Triangle
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech selfemp perwt ind1990 ind1990_code

*Change sample to be only self-employed, HT-industry workers in res_tri
	drop if res_tri!=1
	drop if high_tech!=1
	drop if selfemp!=1
	
*Create selfE	
	gen selfE_rt__80= perwt

	collapse (sum) selfE_rt__80, by (ind1990 ind1990_code)
	save rtHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech selfemp perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_rt__90= perwt
	collapse (sum) selfE_rt__90, by (ind1990 ind1990_code)
	save rtHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech selfemp perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_rt__00= perwt
	collapse (sum) selfE_rt__00, by (ind1990 ind1990_code)
	save rtHT_00.dta, replace

*2009-5y
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech selfemp perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_rt__09= perwt
	collapse (sum) selfE_rt__09, by (ind1990 ind1990_code)
	save rtHT_09.dta, replace
/* DATA NOT YET AVALIABLE	
*2014-5y
	use ipums_2014_5y.dta, clear
	gen ind1990_code = ind1990
	keep res_tri high_tech selfemp perwt ind1990 ind1990_code
	drop if res_tri!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_rt__14= perwt
	collapse (sum) selfE_rt__14, by (ind1990 ind1990_code)
	save rtHT_14.dta, replace
*/
use rtHT_80.dta, clear
merge 1:1 ind1990 using rtHT_90.dta
drop _merge
merge 1:1 ind1990 using rtHT_00.dta
drop _merge
merge 1:1 ind1990 using rtHT_09.dta
drop _merge
*merge 1:1 ind1990 using rtHT_14.dta
*drop _merge

save rtHTselfE.dta, replace
export excel rtHTselfE.xlsx, first (var) replace

*Silicon Valley
*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech selfemp perwt ind1990 ind1990_code

*Change sample to be only self-employed, HT-industry workers in svalley
	drop if svalley!=1
	drop if high_tech!=1
	drop if selfemp!=1
	
*Create selfE	
	gen selfE_sv__80= perwt

	collapse (sum) selfE_sv__80, by (ind1990 ind1990_code)
	save svHT_80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech selfemp perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_sv__90= perwt
	collapse (sum) selfE_sv__90, by (ind1990 ind1990_code)
	save svHT_90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech selfemp perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_sv__00= perwt
	collapse (sum) selfE_sv__00, by (ind1990 ind1990_code)
	save svHT_00.dta, replace

*2009-5y
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech selfemp perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_sv__09= perwt
	collapse (sum) selfE_sv__09, by (ind1990 ind1990_code)
	save svHT_09.dta, replace
/* DATA NOT YET AVAILABLE	
*2014-5y
	use ipums_2014_5y.dta, clear
	gen ind1990_code = ind1990
	keep svalley high_tech selfemp perwt ind1990 ind1990_code
	drop if svalley!=1
	drop if high_tech!=1
	drop if selfemp!=1
	gen selfE_sv__14= perwt
	collapse (sum) selfE_sv__14, by (ind1990 ind1990_code)
	save svHT_14.dta, replace
*/
use svHT_80.dta, clear
merge 1:1 ind1990 using svHT_90.dta
drop _merge
merge 1:1 ind1990 using svHT_00.dta
drop _merge
merge 1:1 ind1990 using svHT_09.dta
drop _merge
*merge 1:1 ind1990 using svHT_14.dta
*drop _merge

save svHTselfE.dta, replace
export excel svHTselfE.xlsx, first (var) replace

timer off 1
timer list 1
