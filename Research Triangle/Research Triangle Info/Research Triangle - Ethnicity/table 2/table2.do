*table 2
*EVAN JOHNSTON

*creates table 2 showing employment share, wage, and education levels
* for 8 major occupation groups for workers in res_tri, 1980 and 2013.

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt wkswork1 uhrswork incwage hrwagelimit selfemp school occ8cat res_tri
	
*Only keep workers in res_tri
	drop if res_tri!= 1
	
* Define labor supply = weeks worked * usual number of hours per week
	gen laborsupply = wkswork1*uhrswork

*Multiply by Census sampling weight
	gen laborwgt = laborsupply*perwt

*Create person-workhours
*set it = 1 for everyone for now; used for 'collapse'
	gen pwrkhrs_80 = 1
	
* Save for future calculations
	save pre_collapse.dta, replace

******************** Employment Share ********************
*COLLAPSE: to calculate total work hours for each occupation
	collapse (sum) pwrkhrs_80 [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.

*Save and export collapsed data
	save tab2_empshare_80.dta, replace

******************** Wages ********************
use pre_collapse.dta, clear

* Remove self-employed or workers with missing wages
	drop if selfemp == 1
	drop if incwage == .
	
*Creat hourly wages
	gen hrwages = incwage/laborsupply
	
*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit

*Low Earnings Outliers
/*
	For each year, we find the average hourly wage of the first percentile 
	and set all hourly wages in that percentile = to this mean
*/

	*finds the 1st percentile of hourly wage
		sum hrwages, detail
		gen lowwagelimit = r(p1)

	*replaces hrwages with mean of hour wages <= the 1st percentile hourly wage
	* if wage is in that percentile
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
	
	*Use CPI deflator to convert to 2004 dollars
		gen hrwages2004 = hrwages * (188.9/82.4)

	*Take the natural log of the real wages
		gen logwages80 = log(hrwages2004)
		
*Collpase wages, logwages by 8 occupations
	collapse (mean) logwages80 [pw=laborwgt], by (occ8cat)
	drop if (occ8cat==.)
	
*Save data	
	save tab2_wage_80.dta, replace

******************** Education ********************
use pre_collapse.dta, clear

*Create persons
	gen persons_80 = perwt
	
*COLLAPSE by 8 occupation groups
	collapse (sum) persons_80, by(occ8cat school)
	drop if (occ8cat==.)

*Save data
	save tab2_educ_80.dta, replace
	
************************************************************
*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt wkswork1 uhrswork incwage hrwagelimit selfemp school occ8cat res_tri
	drop if res_tri!= 1
	gen laborsupply = wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen pwrkhrs_13 = 1
save pre_collapse.dta, replace
	collapse (sum) pwrkhrs_13 [pw=laborwgt], by(occ8cat)
	drop if occ8cat==.
	save tab2_empshare_13.dta, replace
use pre_collapse.dta, clear
	drop if selfemp == 1
	drop if incwage == .
	gen hrwages = incwage/laborsupply
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
		sum hrwages, detail
		gen lowwagelimit = r(p1)
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
		gen hrwages2004 = hrwages * (188.9/232.96)
		gen logwages13 = log(hrwages2004)
	collapse (mean) logwages13 [pw=laborwgt], by (occ8cat)
	drop if (occ8cat==.)
	save tab2_wage_13.dta, replace
use pre_collapse.dta, clear
	gen persons_13 = perwt
	collapse (sum) persons_13, by(occ8cat school)
	drop if (occ8cat==.)
	save tab2_educ_13.dta, replace
	
************************************************************
*Combine data sets
use tab2_educ_80.dta, clear
merge 1:1 occ8cat school using tab2_educ_13.dta
drop _merge

export excel table2_educ.xlsx, first(var) replace

use tab2_empshare_80.dta, clear
merge 1:1 occ8cat using tab2_empshare_13.dta
drop _merge
merge 1:1 occ8cat using tab2_wage_80.dta
drop _merge
merge 1:1 occ8cat using tab2_wage_13.dta
drop _merge

*Export results to excel file
export excel table2_emp_wage.xlsx, first(var) replace
