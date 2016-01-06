*Modified Gender 2.1: Gender Employement Share (hours) by 4 categories
*EVAN JOHNSTON

*Examines the employment share of the 4 occupation groups by gender 
* for 1980, 1990, 2000, 2005, 2013 in the US and res_tri.

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt wkswork1 uhrswork occ4cat res_tri sex

* Define labor supply = weeks worked * usual number of hours per week
	gen laborsupply = wkswork1*uhrswork

*Multiply by Census sampling weight
	gen laborwgt = laborsupply*perwt

*Save before collapse to repeat for res_tri
	save pre_collapse.dta, replace
	
*Create person-workhours
*set it = 1 for everyone for now; used for 'collapse'
	gen pwrkhrs_80_us = 1

*COLLAPSE: to calculate total work hours for each occupation
	collapse (sum) pwrkhrs_80_us [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)

*Save and export collapsed data
	save gender2_2_80_us.dta, replace

* Repeat for res_tri
use pre_collapse.dta, clear
	drop if res_tri != 1
	gen pwrkhrs_80_rt = 1
	collapse (sum) pwrkhrs_80_rt [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_80_rt.dta, replace

*Repeat for 1990
	use ipums_1990_5p.dta, clear

	keep perwt wkswork1 uhrswork occ4cat res_tri sex
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_90_us = 1
	collapse (sum) pwrkhrs_90_us [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_90_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri != 1
	gen pwrkhrs_90_rt = 1
	collapse (sum) pwrkhrs_90_rt [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_90_rt.dta, replace

*Repeat for 2000
	use ipums_2000_5p.dta, clear

	keep perwt wkswork1 uhrswork occ4cat res_tri sex
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_00_us = 1
	collapse (sum) pwrkhrs_00_us [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_00_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri != 1
	gen pwrkhrs_00_rt = 1
	collapse (sum) pwrkhrs_00_rt [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_00_rt.dta, replace
	
*Repeat for 2005
	use ipums_2005_1p.dta, clear

	keep perwt wkswork1 uhrswork occ4cat res_tri sex
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_05_us = 1
	collapse (sum) pwrkhrs_05_us [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_05_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri != 1
	gen pwrkhrs_05_rt = 1
	collapse (sum) pwrkhrs_05_rt [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_05_rt.dta, replace
	
*Repeat for 2013
	use ipums_2013_1p.dta, clear

	keep perwt wkswork1 uhrswork occ4cat res_tri sex
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	save pre_collapse.dta, replace
	gen pwrkhrs_13_us = 1
	collapse (sum) pwrkhrs_13_us [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_13_us.dta, replace
use pre_collapse.dta, clear
	drop if res_tri != 1
	gen pwrkhrs_13_rt = 1
	collapse (sum) pwrkhrs_13_rt [pw=laborwgt], by(occ4cat sex)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender2_2_13_rt.dta, replace
	
*Combine US results into one table
use gender2_2_80_us.dta, clear
merge 1:1 occ4cat sex using gender2_2_90_us.dta
drop _merge
merge 1:1 occ4cat sex using gender2_2_00_us.dta
drop _merge
merge 1:1 occ4cat sex using gender2_2_05_us.dta
drop _merge
merge 1:1 occ4cat sex using gender2_2_13_us.dta
drop _merge

*Export US results to excel file
export excel gender2_2_us.xlsx, first(var) replace

*Combine res_tri results into one table
use gender2_2_80_rt.dta, clear
merge 1:1 occ4cat sex using gender2_2_90_rt.dta
drop _merge
merge 1:1 occ4cat sex using gender2_2_00_rt.dta
drop _merge
merge 1:1 occ4cat sex using gender2_2_05_rt.dta
drop _merge
merge 1:1 occ4cat sex using gender2_2_13_rt.dta
drop _merge

*Export res_tri results to excel file
export excel gender2_2_rt.xlsx, first(var) replace
