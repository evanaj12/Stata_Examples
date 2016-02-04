*FIGURE A - employment share (no. jobs) for SV/BA, RT, ATX
*EVAN JOHNSTON

*1990
	use ipums_1990_5p.dta, clear

*Remove irrelevant variables for this calculation
	keep occ8cat bay_area svalley austin res_tri perwt

save pre_collapse.dta, replace
*Silicon Valley
	drop if svalley!=1
	gen jobs_90_sv = perwt
	collapse (sum) jobs_90_sv, by (occ8cat)
	drop if occ8cat==.

	save figA_90_sv.dta, replace
	
use pre_collapse.dta, clear
*Research Triangle
	drop if res_tri!=1
	gen jobs_90_rt = perwt
	collapse (sum) jobs_90_rt, by (occ8cat)
	drop if occ8cat==.

	save figA_90_rt.dta, replace

use pre_collapse.dta, clear
*Austin
	drop if austin!=1
	gen jobs_90_atx = perwt
	collapse (sum) jobs_90_atx, by (occ8cat)
	drop if occ8cat==.

	save figA_90_atx.dta, replace
	
use pre_collapse.dta, clear
*Bay Area
	drop if bay_area!=1
	gen jobs_90_ba = perwt
	collapse (sum) jobs_90_ba, by (occ8cat)
	drop if occ8cat==.

	save figA_90_ba.dta, replace

*2000
	use ipums_2000_5p.dta, clear

	keep occ8cat bay_area svalley austin res_tri perwt
save pre_collapse.dta, replace
	drop if svalley!=1
	gen jobs_00_sv = perwt
	collapse (sum) jobs_00_sv, by (occ8cat)
	drop if occ8cat==.
	save figA_00_sv.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen jobs_00_rt = perwt
	collapse (sum) jobs_00_rt, by (occ8cat)
	drop if occ8cat==.
	save figA_00_rt.dta, replace
use pre_collapse.dta, clear
	drop if austin!=1
	gen jobs_00_atx = perwt
	collapse (sum) jobs_00_atx, by (occ8cat)
	drop if occ8cat==.
	save figA_00_atx.dta, replace
use pre_collapse.dta, clear
	drop if bay_area!=1
	gen jobs_00_ba = perwt
	collapse (sum) jobs_00_ba, by (occ8cat)
	drop if occ8cat==.
	save figA_00_ba.dta, replace

*2013
	use ipums_2013_1p.dta, clear

	keep occ8cat bay_area svalley austin res_tri perwt
save pre_collapse.dta, replace
	drop if svalley!=1
	gen jobs_13_sv = perwt
	collapse (sum) jobs_13_sv, by (occ8cat)
	drop if occ8cat==.
	save figA_13_sv.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen jobs_13_rt = perwt
	collapse (sum) jobs_13_rt, by (occ8cat)
	drop if occ8cat==.
	save figA_13_rt.dta, replace
use pre_collapse.dta, clear
	drop if austin!=1
	gen jobs_13_atx = perwt
	collapse (sum) jobs_13_atx, by (occ8cat)
	drop if occ8cat==.
	save figA_13_atx.dta, replace
use pre_collapse.dta, clear
	drop if bay_area!=1
	gen jobs_13_ba = perwt
	collapse (sum) jobs_13_ba, by (occ8cat)
	drop if occ8cat==.
	save figA_13_ba.dta, replace

*Merge data for figure
use figA_90_sv.dta, clear
merge 1:1 occ8cat using figA_00_sv.dta
drop _merge
merge 1:1 occ8cat using figA_13_sv.dta
drop _merge

merge 1:1 occ8cat using figA_90_ba.dta
drop _merge
merge 1:1 occ8cat using figA_00_ba.dta
drop _merge
merge 1:1 occ8cat using figA_13_ba.dta
drop _merge

merge 1:1 occ8cat using figA_90_rt.dta
drop _merge
merge 1:1 occ8cat using figA_00_rt.dta
drop _merge
merge 1:1 occ8cat using figA_13_rt.dta
drop _merge

merge 1:1 occ8cat using figA_90_atx.dta
drop _merge
merge 1:1 occ8cat using figA_00_atx.dta
drop _merge
merge 1:1 occ8cat using figA_13_atx.dta
drop _merge

export excel figA.xlsx, first(var) replace
