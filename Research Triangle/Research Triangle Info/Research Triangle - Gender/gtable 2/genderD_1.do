*Gender: wage by HT/NHT for 1980, 2013 in res_tri
*EVAN JOHNSTON

*1980
	use ipums_1980_5p.dta, clear

*Remove unused variables
	keep perwt wkswork1 uhrswork selfemp incwage hrwagelimit occ4cat res_tri high_tech sex
	
*Remove if not in res_tri, self-employed, or missing wages
	drop if selfemp == 1
	drop if incwage == .
	drop if res_tri != 1

*Create labor supply based on person-work hours	
	gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight to get the total for the population
	gen laborwgt = laborsupply*perwt
	
*Creat hourly wages
	gen hrwages = incwage/(wkswork1*uhrswork)
	
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

	*Collapse logwages on eight occupation groups
	collapse (mean) logwages80 [pw=laborwgt], by(occ4cat high_tech sex)
	drop if (occ4cat==. | sex == . | sex == 0)

*Save and export collapsed data
	save genderD_1_80.dta, replace

*Repeat for 2013
use ipums_2013_1p.dta, clear
	keep perwt wkswork1 uhrswork selfemp incwage hrwagelimit occ4cat res_tri high_tech sex
	drop if selfemp == 1
	drop if incwage == .
	drop if res_tri != 1
	gen laborsupply= wkswork1*uhrswork
	gen laborwgt = laborsupply*perwt
	gen hrwages = incwage/(wkswork1*uhrswork)
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
		sum hrwages, detail
		gen lowwagelimit = r(p1)
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
		gen hrwages2004 = hrwages * (188.9/232.96)
		gen logwages13 = log(hrwages2004)
	collapse (mean) logwages13 [pw=laborwgt], by(occ4cat high_tech sex)
	drop if (occ4cat==. | sex == . | sex == 0)
	save genderD_1_13.dta, replace	

*Combine into one table
use genderD_1_80.dta, clear
merge 1:1 occ4cat high_tech sex using genderD_1_13.dta
drop _merge

sort sex high_tech occ4cat

*Export results to excel file
export excel genderD_1.xlsx, first(var) replace
