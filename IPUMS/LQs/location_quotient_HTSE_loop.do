*Tabulates the LQ for the total HT industry for:
* number of self-employed jobs in US, ATX, RT, SV
* in 1980, 1990, 2000, 2009-5y, 2014-5y.

* LQ=(ei/e)/(Ei/E)
* ei = employment in sector i in region
* e  = total employment in region
* Ei = employment in sector i in nation
* E  = total employment in nation

*Evan Johnston
set more off
timer clear 1
timer on 1

* 1960_5p 1970_1pf2
foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	
	use ipums_`year'.dta, clear
	keep year fulltime fullyear selfemp uhrswork perwt ind1990 high_tech austin res_tri svalley
	drop if selfemp!=1
	
	gen selfemp_fulltime=0
	replace selfemp_fulltime=1 if uhrswork>=15
	
	* must have worked "enough" at the self-employment position
	*	follows the KF restriction (see KF Index of StartupActivity Metro Area p.59)
	drop if selfemp_fulltime!=1
		
	*Create people	
	gen person_`year'= perwt
	
	*save data before collapse (national)
	save precollapse.dta, replace
		
	*collapse to get sum of fullemp persons in US
	collapse (sum) person_`year', by (year)
	drop if (year==.)
	
	*create local variable of total employment	
	local US_`year' = person_`year'[1]

	*use precollapse data
	use precollapse.dta, clear
	
	*keep only high-tech workers
	drop if (high_tech!=1)

	*collapse to get sum of high-tech se persons in US	
	collapse (sum) person_`year', by (year)
	drop if (year==.)

	*create local variable of high-tech employment
	local US_`year'_HT = person_`year'[1]
	
	* for each region austin, research triangle, silicon valley
	* svalley
	foreach region in austin res_tri {
		
		*use precollapse data
		use precollapse.dta, clear

		* keep only the region
		drop if `region'!=1
		
		* save this regional dataset
		save `region'_`year'.dta, replace
		
		* collapse to get sum of fullemp persons in region
		collapse (sum) person_`year', by (year)
		drop if (year==.)
		
		* create locale variable of regional employment
		local `region'_`year' = person_`year'[1]
		
		* use regional data
		use `region'_`year'.dta, clear
		
		* keep only HT workers
		drop if (high_tech!=1)
		
		* collapse to get total se HT regional workers
		collapse (sum) person_`year', by (year)
		drop if (year==.)
		
		* create local variable of regional HT employment
		local `region'_`year'_HT = person_`year'[1]
		
		erase `region'_`year'.dta
	}	
	
}
clear

set obs 1

*local LQ_US_1960 = (`US_1960_5p_HT'/`US_1960_5p')
*local LQ_US_1970 = (`US_1970_1pf2_HT'/`US_1970_1pf2')
local LQ_US_1980 = (`US_1980_5p_HT'/`US_1980_5p')
local LQ_US_1990 = (`US_1990_5p_HT'/`US_1990_5p')
local LQ_US_2000 = (`US_2000_5p_HT'/`US_2000_5p')
local LQ_US_2009 = (`US_2009_5y_HT'/`US_2009_5y')
local LQ_US_2014 = (`US_2014_5y_HT'/`US_2014_5y')

*gen LQ_austin_1960= (`austin_1960_5p_HT'/`austin_1960_5p')/`LQ_US_1960'
*gen LQ_austin_1970= (`austin_1970_1pf2_HT'/`austin_1970_1pf2')/`LQ_US_1970'
gen LQ_austin_1980= (`austin_1980_5p_HT'/`austin_1980_5p')/`LQ_US_1980'
gen LQ_austin_1990= (`austin_1990_5p_HT'/`austin_1990_5p')/`LQ_US_1990'
gen LQ_austin_2000= (`austin_2000_5p_HT'/`austin_2000_5p')/`LQ_US_2000'
gen LQ_austin_2009= (`austin_2009_5y_HT'/`austin_2009_5y')/`LQ_US_2009'
gen LQ_austin_2014= (`austin_2014_5y_HT'/`austin_2014_5y')/`LQ_US_2014'


gen LQ_res_tri_1980= (`res_tri_1980_5p_HT'/`res_tri_1980_5p')/`LQ_US_1980'
gen LQ_res_tri_1990= (`res_tri_1990_5p_HT'/`res_tri_1990_5p')/`LQ_US_1990'
gen LQ_res_tri_2000= (`res_tri_2000_5p_HT'/`res_tri_2000_5p')/`LQ_US_2000'
gen LQ_res_tri_2009= (`res_tri_2009_5y_HT'/`res_tri_2009_5y')/`LQ_US_2009'
gen LQ_res_tri_2014= (`res_tri_2014_5y_HT'/`res_tri_2014_5y')/`LQ_US_2014'
/*
gen LQ_svalley_1980= (`svalley_1980_5p_HT'/`svalley_1980_5p')/`LQ_US_1980'
gen LQ_svalley_1990= (`svalley_1990_5p_HT'/`svalley_1990_5p')/`LQ_US_1990'
gen LQ_svalley_2000= (`svalley_2000_5p_HT'/`svalley_2000_5p')/`LQ_US_2000'
gen LQ_svalley_2009= (`svalley_2009_5y_HT'/`svalley_2009_5y')/`LQ_US_2009'
gen LQ_svalley_2014= (`svalley_2014_5y_HT'/`svalley_2014_5y')/`LQ_US_2014'
*/
export excel LQHTSE.xlsx, first (var) replace

timer off 1
timer list 1
