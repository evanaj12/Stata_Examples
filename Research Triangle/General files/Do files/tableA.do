*table A
*EVAN JOHNSTON

*Ethno-demographic breakdown of SV/BA, RT, ATX

*1980
	use ipums_1980_5p.dta, clear
	
*Remove unused variables
	keep perwt race_group austin svalley bay_area res_tri

save pre_collapse.dta, replace
*Austin
	drop if austin!=1
	gen persons_80_atx = perwt
	collapse (sum) persons_80_atx, by(race_group)

	save tableA_80_atx.dta, replace
	
use pre_collapse.dta, clear
*Silicon Valley
	drop if svalley!=1
	gen persons_80_sv = perwt
	collapse (sum) persons_80_sv, by (race_group)

	save tableA_80_sv.dta, replace

use pre_collapse.dta, clear
*Bay Area
	drop if bay_area!=1
	gen persons_80_ba = perwt
	collapse (sum) persons_80_ba, by (race_group)

	save tableA_80_ba.dta, replace
	
use pre_collapse.dta, clear
*Research Triangle
	drop if res_tri!=1
	gen persons_80_rt = perwt
	collapse (sum) persons_80_rt, by (race_group)

	save tableA_80_rt.dta, replace
	
*1990
	use ipums_1990_5p.dta, clear
	keep perwt race_group austin svalley bay_area res_tri
save pre_collapse.dta, replace
	drop if austin!=1
	gen persons_90_atx = perwt
	collapse (sum) persons_90_atx, by(race_group)
	save tableA_90_atx.dta, replace
use pre_collapse.dta, clear
	drop if svalley!=1
	gen persons_90_sv = perwt
	collapse (sum) persons_90_sv, by (race_group)
	save tableA_90_sv.dta, replace
use pre_collapse.dta, clear
	drop if bay_area!=1
	gen persons_90_ba = perwt
	collapse (sum) persons_90_ba, by (race_group)
	save tableA_90_ba.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen persons_90_rt = perwt
	collapse (sum) persons_90_rt, by (race_group)
	save tableA_90_rt.dta, replace	
	
*2000
	use ipums_2000_5p.dta, clear
	keep perwt race_group austin svalley bay_area res_tri
save pre_collapse.dta, replace
	drop if austin!=1
	gen persons_00_atx = perwt
	collapse (sum) persons_00_atx, by(race_group)
	save tableA_00_atx.dta, replace
use pre_collapse.dta, clear
	drop if svalley!=1
	gen persons_00_sv = perwt
	collapse (sum) persons_00_sv, by (race_group)
	save tableA_00_sv.dta, replace
use pre_collapse.dta, clear
	drop if bay_area!=1
	gen persons_00_ba = perwt
	collapse (sum) persons_00_ba, by (race_group)
	save tableA_00_ba.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen persons_00_rt = perwt
	collapse (sum) persons_00_rt, by (race_group)
	save tableA_00_rt.dta, replace	

*2005
	use ipums_2005_1p.dta, clear
	keep perwt race_group austin svalley bay_area res_tri
save pre_collapse.dta, replace
	drop if austin!=1
	gen persons_05_atx = perwt
	collapse (sum) persons_05_atx, by(race_group)
	save tableA_05_atx.dta, replace
use pre_collapse.dta, clear
	drop if svalley!=1
	gen persons_05_sv = perwt
	collapse (sum) persons_05_sv, by (race_group)
	save tableA_05_sv.dta, replace
use pre_collapse.dta, clear
	drop if bay_area!=1
	gen persons_05_ba = perwt
	collapse (sum) persons_05_ba, by (race_group)
	save tableA_05_ba.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen persons_05_rt = perwt
	collapse (sum) persons_05_rt, by (race_group)
	save tableA_05_rt.dta, replace	

*2013
	use ipums_2013_1p.dta, clear
	keep perwt race_group austin svalley bay_area res_tri
save pre_collapse.dta, replace
	drop if austin!=1
	gen persons_13_atx = perwt
	collapse (sum) persons_13_atx, by(race_group)
	save tableA_13_atx.dta, replace
use pre_collapse.dta, clear
	drop if svalley!=1
	gen persons_13_sv = perwt
	collapse (sum) persons_13_sv, by (race_group)
	save tableA_13_sv.dta, replace
use pre_collapse.dta, clear
	drop if bay_area!=1
	gen persons_13_ba = perwt
	collapse (sum) persons_13_ba, by (race_group)
	save tableA_13_ba.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen persons_13_rt = perwt
	collapse (sum) persons_13_rt, by (race_group)
	save tableA_13_rt.dta, replace	

use tableA_80_atx.dta, clear
merge 1:1 race_group using tableA_90_atx.dta
drop _merge
merge 1:1 race_group using tableA_00_atx.dta
drop _merge
merge 1:1 race_group using tableA_05_atx.dta
drop _merge
merge 1:1 race_group using tableA_13_atx.dta
drop _merge

merge 1:1 race_group using tableA_80_sv.dta
drop _merge
merge 1:1 race_group using tableA_90_sv.dta
drop _merge
merge 1:1 race_group using tableA_00_sv.dta
drop _merge
merge 1:1 race_group using tableA_05_sv.dta
drop _merge
merge 1:1 race_group using tableA_13_sv.dta
drop _merge

merge 1:1 race_group using tableA_80_ba.dta
drop _merge
merge 1:1 race_group using tableA_90_ba.dta
drop _merge
merge 1:1 race_group using tableA_00_ba.dta
drop _merge
merge 1:1 race_group using tableA_05_ba.dta
drop _merge
merge 1:1 race_group using tableA_13_ba.dta
drop _merge

merge 1:1 race_group using tableA_80_rt.dta
drop _merge
merge 1:1 race_group using tableA_90_rt.dta
drop _merge
merge 1:1 race_group using tableA_00_rt.dta
drop _merge
merge 1:1 race_group using tableA_05_rt.dta
drop _merge
merge 1:1 race_group using tableA_13_rt.dta
drop _merge

*Export results to excel file
export excel tableA.xlsx, first(var) replace
