*Gender B_0

*EVAN JOHNSTON
/*
Examination of wages, 1980-2013, in 4 occupation groups
for males and females in res_tri.
*/

*1980
use ipums_1980_5p.dta, clear

*Remove irrelevant variables for this calculation
	keep  selfemp incwage hrwagelimit wkswork1 uhrswork occ4cat perwt res_tri sex
	
*Drop if not in res_tri, self-employed, or missing wages
	drop if res_tri != 1
	drop if selfemp == 1
	drop if incwage == .
		
*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork
	
*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt
	
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
		gen hrwages2004_80 = hrwages * (188.9/82.4)

	*Take the natural log of the real wages
		gen logwages80 = log(hrwages2004)
		
*Collpase wages, logwages by 8 occupations and gender
	collapse (mean) logwages80 [pw=laborwgt], by (occ4cat sex)
	drop if (occ4cat==.)
	
*Save and export collapsed data
	save genderB0_80.dta, replace

*repeat for 1990
use ipums_1990_5p.dta, clear

	keep  selfemp incwage hrwagelimit wkswork1 uhrswork occ4cat perwt res_tri sex
	drop if res_tri != 1
	drop if selfemp == 1
	drop if incwage == .
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen hrwages = incwage/laborsupply
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
		sum hrwages, detail
		gen lowwagelimit = r(p1)
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
		gen hrwages2004 = hrwages * (188.9/130.7)
		gen logwages90 = log(hrwages2004)
	collapse (mean) logwages90 [pw=laborwgt], by (occ4cat sex)
	drop if (occ4cat==.)
	save genderB0_90.dta, replace	

*repeat for 2000
use ipums_2000_5p.dta, clear

	keep  selfemp incwage hrwagelimit wkswork1 uhrswork occ4cat perwt res_tri sex
	drop if res_tri != 1
	drop if selfemp == 1
	drop if incwage == .
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen hrwages = incwage/laborsupply
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
		sum hrwages, detail
		gen lowwagelimit = r(p1)
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
		gen hrwages2004 = hrwages * (188.9/172.2)
		gen logwages00 = log(hrwages2004)
	collapse (mean) logwages00 [pw=laborwgt], by (occ4cat sex)
	drop if (occ4cat==.)
	save genderB0_00.dta, replace	

*repeat for 2005
use ipums_2005_1p.dta, clear

	keep  selfemp incwage hrwagelimit wkswork1 uhrswork occ4cat perwt res_tri sex
	drop if res_tri != 1
	drop if selfemp == 1
	drop if incwage == .
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen hrwages = incwage/laborsupply
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
		sum hrwages, detail
		gen lowwagelimit = r(p1)
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
		gen hrwages2004 = hrwages * (188.9/195.3)
		gen logwages05 = log(hrwages2004)
	collapse (mean) logwages05 [pw=laborwgt], by (occ4cat sex)
	drop if (occ4cat==.)
	save genderB0_05.dta, replace
	
*repeat for 2013
use ipums_2013_1p.dta, clear

	keep  selfemp incwage hrwagelimit wkswork1 uhrswork occ4cat perwt res_tri sex
	drop if res_tri != 1
	drop if selfemp == 1
	drop if incwage == .
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen hrwages = incwage/laborsupply
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
		sum hrwages, detail
		gen lowwagelimit = r(p1)
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
		gen hrwages2004 = hrwages * (188.9/232.96)
		gen logwages13 = log(hrwages2004)
	collapse (mean) logwages13 [pw=laborwgt], by (occ4cat sex)
	drop if (occ4cat==.)
	save genderB0_13.dta, replace	

	*Merge data (B1) for collapse on occ8 and gender only
use genderB0_80.dta, replace
merge 1:1 occ4cat sex using genderB0_90.dta
drop _merge
merge 1:1 occ4cat sex using genderB0_00.dta
drop _merge
merge 1:1 occ4cat sex using genderB0_05.dta
drop _merge
merge 1:1 occ4cat sex using genderB0_13.dta
drop _merge

sort sex occ4cat

export excel genderB_0.xlsx, first(var) replace

