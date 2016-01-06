*table 1
*EVAN JOHNSTON

*creates table 1 showing the employment share of the 9 occupation groups
* replicating Autor & Dorn (2013) "Growth of Low-Skill Jobs" Table 1 Panel A
* with 2013 added. Disaggregates construction occupation.

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt wkswork1 uhrswork occ8cat res_tri
	
*Save before collapse to repeat with res_tri
	save pre_collapse.dta, replace

* Define labor supply = weeks worked * usual number of hours per week
	gen laborsupply = wkswork1*uhrswork

*Multiply by Census sampling weight
	gen laborwgt = laborsupply*perwt

*Create person-workhours
*set it = 1 for everyone for now; used for 'collapse'
	gen pwrkhrs_80_us = 1

*COLLAPSE USA: to calculate total work hours for each occupation
	collapse (sum) pwrkhrs_80_us [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.

*Save and export collapsed data
	save table1_80_us.dta, replace

*Repeat for res_tri
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_80_rt = 1
	collapse (sum) pwrkhrs_80_rt [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_80_rt.dta, replace

*Repeat for 1990
use ipums_1990_5p.dta, clear
	keep perwt wkswork1 uhrswork occ8cat res_tri
	save pre_collapse.dta, replace
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_90_us = 1
	collapse (sum) pwrkhrs_90_us [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_90_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_90_rt = 1
	collapse (sum) pwrkhrs_90_rt [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_90_rt.dta, replace
	
*Repeat for 2000
use ipums_2000_5p.dta, clear
	keep perwt wkswork1 uhrswork occ8cat res_tri
	save pre_collapse.dta, replace
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_00_us = 1
	collapse (sum) pwrkhrs_00_us [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_00_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_00_rt = 1
	collapse (sum) pwrkhrs_00_rt [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_00_rt.dta, replace

*Repeat for 2005
use ipums_2005_1p.dta, clear
	keep perwt wkswork1 uhrswork occ8cat res_tri
	save pre_collapse.dta, replace
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_05_us = 1
	collapse (sum) pwrkhrs_05_us [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_05_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_05_rt = 1
	collapse (sum) pwrkhrs_05_rt [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_05_rt.dta, replace
	
*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt wkswork1 uhrswork occ8cat res_tri
	save pre_collapse.dta, replace
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13_us = 1
	collapse (sum) pwrkhrs_13_us [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_13_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri!=1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13_rt = 1
	collapse (sum) pwrkhrs_13_rt [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save table1_13_rt.dta, replace
	
	*****************************
*Combine into one table

use table1_80_us.dta, clear
merge 1:1 occ8cat using table1_90_us.dta
drop _merge
merge 1:1 occ8cat using table1_00_us.dta
drop _merge
merge 1:1 occ8cat using table1_05_us.dta
drop _merge
merge 1:1 occ8cat using table1_13_us.dta
drop _merge

merge 1:1 occ8cat using table1_80_rt.dta
drop _merge
merge 1:1 occ8cat using table1_90_rt.dta
drop _merge
merge 1:1 occ8cat using table1_00_rt.dta
drop _merge
merge 1:1 occ8cat using table1_05_rt.dta
drop _merge
merge 1:1 occ8cat using table1_13_rt.dta
drop _merge

*Export results to excel file
export excel table1.xlsx, first(var) replace
