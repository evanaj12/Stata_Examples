*Employment share change by gender and education level, manager/professionals
* in res_tri

*EVAN JOHNSTON
/*
Shows the change in employment share (hours)  with 1980 as the base year for 
managerial/professional males and females in res_tri by education level
Note: new education levels are as follows (variable college):
	less than 4 years of college
	4 years of college
	more than 4 years of college
*/

*1980
	use ipums_1980_5p.dta, clear

*Remove irrelevant variables for this calculation
	keep sex college occ4cat perwt wkswork1 uhrswork res_tri
		
*Only keep managers/professionals in res_tri
	drop if res_tri != 1
	drop if occ4cat != 1
	
*Define labor supply = weeks worked * usual number of hours per week
	gen laborsupply = wkswork1*uhrswork

*Multiply by Census sampling weight
	gen laborwgt = laborsupply*perwt
	
*Create person-workhours
*set it = 1 for everyone for now; used for 'collapse'
	gen pwrkhrs_80 = 1

*COLLAPSE: to calculate total work hours for each occupation
	collapse (sum) pwrkhrs_80 [pw=laborwgt], by(occ4cat sex college)
	drop if (occ4cat==. | sex==0 | sex==.)
	
*Save and export collapsed data
	save gender5_1_2_80.dta, replace

*Repeat for 1990
	use ipums_1990_5p.dta, clear

	keep sex college occ4cat perwt wkswork1 uhrswork res_tri
	drop if res_tri != 1
	drop if occ4cat != 1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_90 = 1
	collapse (sum) pwrkhrs_90 [pw=laborwgt], by(occ4cat sex college)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender5_1_2_90.dta, replace

*Repeat for 2000
	use ipums_2000_5p.dta, clear

	keep sex college occ4cat perwt wkswork1 uhrswork res_tri
	drop if res_tri != 1
	drop if occ4cat != 1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_00 = 1
	collapse (sum) pwrkhrs_00 [pw=laborwgt], by(occ4cat sex college)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender5_1_2_00.dta, replace
	
*Repeat for 2005
	use ipums_2005_1p.dta, clear

	keep sex college occ4cat perwt wkswork1 uhrswork res_tri
	drop if res_tri != 1
	drop if occ4cat != 1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_05 = 1
	collapse (sum) pwrkhrs_05 [pw=laborwgt], by(occ4cat sex college)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender5_1_2_05.dta, replace
	
*Repeat for 2013
	use ipums_2013_1p.dta, clear

	keep sex college occ4cat perwt wkswork1 uhrswork res_tri
	drop if res_tri != 1
	drop if occ4cat != 1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13 = 1
	collapse (sum) pwrkhrs_13 [pw=laborwgt], by(occ4cat sex college)
	drop if (occ4cat==. | sex==0 | sex==.)
	save gender5_1_2_13.dta, replace
	
*Merge all datasets for complete table
use gender5_1_2_80.dta, replace
merge 1:1 occ4cat sex college using gender5_1_2_90.dta
drop _merge
merge 1:1 occ4cat sex college using gender5_1_2_00.dta
drop _merge
merge 1:1 occ4cat sex college using gender5_1_2_05.dta
drop _merge
merge 1:1 occ4cat sex college using gender5_1_2_13.dta
drop _merge

sort sex occ4cat college

export excel gender5_1_2.xlsx, first(var) replace


