*FIGURE 8
*EVAN JOHNSTON

*1980
	use ipums_1980_5p.dta, clear

*Remove if not in res_tri, self-employed, or missing wages
	drop if selfemp == 1
	drop if incwage == .
	drop if res_tri != 1
	
*Remove irrelevant variables for this calculation
	keep race_group occ8cat wkswork1 uhrswork incwage hrwagelimit perwt
	
*Keep only Anglo and Hispanic workers
	keep if ( (race_group == 1) | (race_group == 5) )
	
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
	collapse (mean) logwages80 [pw=laborwgt], by(occ8cat race_group)
	drop if occ8cat == .
	save fig8_80.dta, replace
	
*2013
*repeat for 2013
	use ipums_2013_1p.dta, clear

	drop if selfemp == 1
	drop if incwage == .
	drop if res_tri != 1
	keep race_group occ8cat wkswork1 uhrswork incwage hrwagelimit perwt
	keep if ( (race_group == 1) | (race_group == 5) )
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
	collapse (mean) logwages13 [pw=laborwgt], by(occ8cat race_group)
	drop if occ8cat == .
	save fig8_13.dta, replace
	
*Merge data for figure 8
use fig8_80.dta, replace
merge 1:1 occ8cat race_group using fig8_13.dta
drop _merge

export excel fig8.xlsx, first(var) replace
