*Calculates Location Quotient for 3 regions for main HT-sectors
*Evan Johnston

* LQ=(ei/e)/(Ei/E)
* ei = employment in ht-sector i in region
* e  = total ht-employment in region
* Ei = employment in ht-sector i in nation
* E  = total ht-employment in nation

timer clear 1
timer on 1

foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	
	use ipums_`year'.dta, clear
	keep year fulltime fullyear selfemp perwt ind1990 high_tech austin res_tri svalley
	drop if fulltime!=1
	drop if fullyear!=1
	drop if high_tech!=1
		
	*Create people	
	gen person_`year'= perwt
	
	*save data before collapse (national)
	save precollapse.dta, replace
		
	*collapse to get sum of fullemp persons in US
	capture collapse (sum) person_`year', by (year)
	drop if (year==.)
	
	*create local variable of total employment	
	local US_HT_`year' = person_`year'[1]
	
	* for each region austin, research triangle, silicon valley
	foreach region in austin res_tri svalley{
		
		*use precollapse data
		use precollapse.dta, clear

		* keep only the region
		drop if `region'!=1
		
		* save this regional dataset
		save `region'_`year'.dta, replace
		
		* collapse to get sum of fullemp persons in region
		capture collapse (sum) person_`year', by (year)
		drop if (year==.)
		
		* create locale variable of regional employment
		local `region'_HT_`year' = person_`year'[1]
	}
	
	* for each selected HT sector:
	foreach sector in 181 322 341 342 441 510 732 882 891 892 {
		
		*use precollapse data
		use precollapse.dta, clear
		
		*keep only sector workers
		drop if (ind1990!=`sector')

		*collapse to get sum of sectorial workers	
		capture collapse (sum) person_`year', by (year)
		drop if (year==.)

		*create local variable of sectorial employment
		local US_`sector'_`year' = person_`year'[1]
	
		* for each region austin, research triangle, silicon valley
		foreach region in austin res_tri svalley{
		
			*use regional data
			use `region'_`year'.dta, clear

			*keep only sector workers
			drop if (ind1990!=`sector')
				
			* collapse to get sum of fullemp persons in region
			capture collapse (sum) person_`year', by (year)
			drop if (year==.)
			
			*create local variable of sectorial employment
			local `region'_`sector'_`year' = person_`year'[1]
		
		}
	}
}

clear
set obs 1

*create national sector ratios
local LQ_US_181_1980_5p = (`US_181_1980_5p'/`US_HT_1980_5p')
local LQ_US_322_1980_5p = (`US_322_1980_5p'/`US_HT_1980_5p')
local LQ_US_341_1980_5p = (`US_341_1980_5p'/`US_HT_1980_5p')
local LQ_US_342_1980_5p = (`US_342_1980_5p'/`US_HT_1980_5p')
local LQ_US_441_1980_5p = (`US_441_1980_5p'/`US_HT_1980_5p')
local LQ_US_732_1980_5p = (`US_732_1980_5p'/`US_HT_1980_5p')
local LQ_US_510_1980_5p = (`US_510_1980_5p'/`US_HT_1980_5p')
local LQ_US_882_1980_5p = (`US_882_1980_5p'/`US_HT_1980_5p')
local LQ_US_891_1980_5p = (`US_891_1980_5p'/`US_HT_1980_5p')
local LQ_US_892_1980_5p = (`US_892_1980_5p'/`US_HT_1980_5p')

local LQ_US_181_1990_5p = (`US_181_1990_5p'/`US_HT_1990_5p')
local LQ_US_322_1990_5p = (`US_322_1990_5p'/`US_HT_1990_5p')
local LQ_US_341_1990_5p = (`US_341_1990_5p'/`US_HT_1990_5p')
local LQ_US_342_1990_5p = (`US_342_1990_5p'/`US_HT_1990_5p')
local LQ_US_441_1990_5p = (`US_441_1990_5p'/`US_HT_1990_5p')
local LQ_US_732_1990_5p = (`US_732_1990_5p'/`US_HT_1990_5p')
local LQ_US_510_1990_5p = (`US_510_1990_5p'/`US_HT_1990_5p')
local LQ_US_882_1990_5p = (`US_882_1990_5p'/`US_HT_1990_5p')
local LQ_US_891_1990_5p = (`US_891_1990_5p'/`US_HT_1990_5p')
local LQ_US_892_1990_5p = (`US_892_1990_5p'/`US_HT_1990_5p')

local LQ_US_181_2000_5p = (`US_181_2000_5p'/`US_HT_2000_5p')
local LQ_US_322_2000_5p = (`US_322_2000_5p'/`US_HT_2000_5p')
local LQ_US_341_2000_5p = (`US_341_2000_5p'/`US_HT_2000_5p')
local LQ_US_342_2000_5p = (`US_342_2000_5p'/`US_HT_2000_5p')
local LQ_US_441_2000_5p = (`US_441_2000_5p'/`US_HT_2000_5p')
local LQ_US_732_2000_5p = (`US_732_2000_5p'/`US_HT_2000_5p')
local LQ_US_510_2000_5p = (`US_510_2000_5p'/`US_HT_2000_5p')
local LQ_US_882_2000_5p = (`US_882_2000_5p'/`US_HT_2000_5p')
local LQ_US_891_2000_5p = (`US_891_2000_5p'/`US_HT_2000_5p')
local LQ_US_892_2000_5p = (`US_892_2000_5p'/`US_HT_2000_5p')

local LQ_US_181_2009_5y = (`US_181_2009_5y'/`US_HT_2009_5y')
local LQ_US_322_2009_5y = (`US_322_2009_5y'/`US_HT_2009_5y')
local LQ_US_341_2009_5y = (`US_341_2009_5y'/`US_HT_2009_5y')
local LQ_US_342_2009_5y = (`US_342_2009_5y'/`US_HT_2009_5y')
local LQ_US_441_2009_5y = (`US_441_2009_5y'/`US_HT_2009_5y')
local LQ_US_732_2009_5y = (`US_732_2009_5y'/`US_HT_2009_5y')
local LQ_US_510_2009_5y = (`US_510_2009_5y'/`US_HT_2009_5y')
local LQ_US_882_2009_5y = (`US_882_2009_5y'/`US_HT_2009_5y')
local LQ_US_891_2009_5y = (`US_891_2009_5y'/`US_HT_2009_5y')
local LQ_US_892_2009_5y = (`US_892_2009_5y'/`US_HT_2009_5y')

local LQ_US_181_2014_5y = (`US_181_2014_5y'/`US_HT_2014_5y')
local LQ_US_322_2014_5y = (`US_322_2014_5y'/`US_HT_2014_5y')
local LQ_US_341_2014_5y = (`US_341_2014_5y'/`US_HT_2014_5y')
local LQ_US_342_2014_5y = (`US_342_2014_5y'/`US_HT_2014_5y')
local LQ_US_441_2014_5y = (`US_441_2014_5y'/`US_HT_2014_5y')
local LQ_US_732_2014_5y = (`US_732_2014_5y'/`US_HT_2014_5y')
local LQ_US_510_2014_5y = (`US_510_2014_5y'/`US_HT_2014_5y')
local LQ_US_882_2014_5y = (`US_882_2014_5y'/`US_HT_2014_5y')
local LQ_US_891_2014_5y = (`US_891_2014_5y'/`US_HT_2014_5y')
local LQ_US_892_2014_5y = (`US_892_2014_5y'/`US_HT_2014_5y')

*LQs for austin
gen LQ_austin_181_1980_5p = (`austin_181_1980_5p'/`austin_HT_1980_5p')/`LQ_US_181_1980_5p'
gen LQ_austin_322_1980_5p = (`austin_322_1980_5p'/`austin_HT_1980_5p')/`LQ_US_322_1980_5p'
gen LQ_austin_341_1980_5p = (`austin_341_1980_5p'/`austin_HT_1980_5p')/`LQ_US_341_1980_5p'
gen LQ_austin_342_1980_5p = (`austin_342_1980_5p'/`austin_HT_1980_5p')/`LQ_US_342_1980_5p'
gen LQ_austin_441_1980_5p = (`austin_441_1980_5p'/`austin_HT_1980_5p')/`LQ_US_441_1980_5p'
gen LQ_austin_732_1980_5p = (`austin_732_1980_5p'/`austin_HT_1980_5p')/`LQ_US_732_1980_5p'
gen LQ_austin_510_1980_5p = (`austin_510_1980_5p'/`austin_HT_1980_5p')/`LQ_US_510_1980_5p'
gen LQ_austin_882_1980_5p = (`austin_882_1980_5p'/`austin_HT_1980_5p')/`LQ_US_882_1980_5p'
gen LQ_austin_891_1980_5p = (`austin_891_1980_5p'/`austin_HT_1980_5p')/`LQ_US_891_1980_5p'
gen LQ_austin_892_1980_5p = (`austin_892_1980_5p'/`austin_HT_1980_5p')/`LQ_US_892_1980_5p'

gen LQ_austin_181_1990_5p = (`austin_181_1990_5p'/`austin_HT_1990_5p')/`LQ_US_181_1990_5p'
gen LQ_austin_322_1990_5p = (`austin_322_1990_5p'/`austin_HT_1990_5p')/`LQ_US_322_1990_5p'
gen LQ_austin_341_1990_5p = (`austin_341_1990_5p'/`austin_HT_1990_5p')/`LQ_US_341_1990_5p'
gen LQ_austin_342_1990_5p = (`austin_342_1990_5p'/`austin_HT_1990_5p')/`LQ_US_342_1990_5p'
gen LQ_austin_441_1990_5p = (`austin_441_1990_5p'/`austin_HT_1990_5p')/`LQ_US_441_1990_5p'
gen LQ_austin_732_1990_5p = (`austin_732_1990_5p'/`austin_HT_1990_5p')/`LQ_US_732_1990_5p'
gen LQ_austin_510_1990_5p = (`austin_510_1990_5p'/`austin_HT_1990_5p')/`LQ_US_510_1990_5p'
gen LQ_austin_882_1990_5p = (`austin_882_1990_5p'/`austin_HT_1990_5p')/`LQ_US_882_1990_5p'
gen LQ_austin_891_1990_5p = (`austin_891_1990_5p'/`austin_HT_1990_5p')/`LQ_US_891_1990_5p'
gen LQ_austin_892_1990_5p = (`austin_892_1990_5p'/`austin_HT_1990_5p')/`LQ_US_892_1990_5p'

gen LQ_austin_181_2000_5p = (`austin_181_2000_5p'/`austin_HT_2000_5p')/`LQ_US_181_2000_5p'
gen LQ_austin_322_2000_5p = (`austin_322_2000_5p'/`austin_HT_2000_5p')/`LQ_US_322_2000_5p'
gen LQ_austin_341_2000_5p = (`austin_341_2000_5p'/`austin_HT_2000_5p')/`LQ_US_341_2000_5p'
gen LQ_austin_342_2000_5p = (`austin_342_2000_5p'/`austin_HT_2000_5p')/`LQ_US_342_2000_5p'
gen LQ_austin_441_2000_5p = (`austin_441_2000_5p'/`austin_HT_2000_5p')/`LQ_US_441_2000_5p'
gen LQ_austin_732_2000_5p = (`austin_732_2000_5p'/`austin_HT_2000_5p')/`LQ_US_732_2000_5p'
gen LQ_austin_510_2000_5p = (`austin_510_2000_5p'/`austin_HT_2000_5p')/`LQ_US_510_2000_5p'
gen LQ_austin_882_2000_5p = (`austin_882_2000_5p'/`austin_HT_2000_5p')/`LQ_US_882_2000_5p'
gen LQ_austin_891_2000_5p = (`austin_891_2000_5p'/`austin_HT_2000_5p')/`LQ_US_891_2000_5p'
gen LQ_austin_892_2000_5p = (`austin_892_2000_5p'/`austin_HT_2000_5p')/`LQ_US_892_2000_5p'

gen LQ_austin_181_2009_5y = (`austin_181_2009_5y'/`austin_HT_2009_5y')/`LQ_US_181_2009_5y'
gen LQ_austin_322_2009_5y = (`austin_322_2009_5y'/`austin_HT_2009_5y')/`LQ_US_322_2009_5y'
gen LQ_austin_341_2009_5y = (`austin_341_2009_5y'/`austin_HT_2009_5y')/`LQ_US_341_2009_5y'
gen LQ_austin_342_2009_5y = (`austin_342_2009_5y'/`austin_HT_2009_5y')/`LQ_US_342_2009_5y'
gen LQ_austin_441_2009_5y = (`austin_441_2009_5y'/`austin_HT_2009_5y')/`LQ_US_441_2009_5y'
gen LQ_austin_732_2009_5y = (`austin_732_2009_5y'/`austin_HT_2009_5y')/`LQ_US_732_2009_5y'
gen LQ_austin_510_2009_5y = (`austin_510_2009_5y'/`austin_HT_2009_5y')/`LQ_US_510_2009_5y'
gen LQ_austin_882_2009_5y = (`austin_882_2009_5y'/`austin_HT_2009_5y')/`LQ_US_882_2009_5y'
gen LQ_austin_891_2009_5y = (`austin_891_2009_5y'/`austin_HT_2009_5y')/`LQ_US_891_2009_5y'
gen LQ_austin_892_2009_5y = (`austin_892_2009_5y'/`austin_HT_2009_5y')/`LQ_US_892_2009_5y'

gen LQ_austin_181_2014_5y = (`austin_181_2014_5y'/`austin_HT_2014_5y')/`LQ_US_181_2014_5y'
gen LQ_austin_322_2014_5y = (`austin_322_2014_5y'/`austin_HT_2014_5y')/`LQ_US_322_2014_5y'
gen LQ_austin_341_2014_5y = (`austin_341_2014_5y'/`austin_HT_2014_5y')/`LQ_US_341_2014_5y'
gen LQ_austin_342_2014_5y = (`austin_342_2014_5y'/`austin_HT_2014_5y')/`LQ_US_342_2014_5y'
gen LQ_austin_441_2014_5y = (`austin_441_2014_5y'/`austin_HT_2014_5y')/`LQ_US_441_2014_5y'
gen LQ_austin_732_2014_5y = (`austin_732_2014_5y'/`austin_HT_2014_5y')/`LQ_US_732_2014_5y'
gen LQ_austin_510_2014_5y = (`austin_510_2014_5y'/`austin_HT_2014_5y')/`LQ_US_510_2014_5y'
gen LQ_austin_882_2014_5y = (`austin_882_2014_5y'/`austin_HT_2014_5y')/`LQ_US_882_2014_5y'
gen LQ_austin_891_2014_5y = (`austin_891_2014_5y'/`austin_HT_2014_5y')/`LQ_US_891_2014_5y'
gen LQ_austin_892_2014_5y = (`austin_892_2014_5y'/`austin_HT_2014_5y')/`LQ_US_892_2014_5y'

*LQs for res_tri
gen LQ_res_tri_181_1980_5p = (`res_tri_181_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_181_1980_5p'
gen LQ_res_tri_322_1980_5p = (`res_tri_322_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_322_1980_5p'
gen LQ_res_tri_341_1980_5p = (`res_tri_341_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_341_1980_5p'
gen LQ_res_tri_342_1980_5p = (`res_tri_342_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_342_1980_5p'
gen LQ_res_tri_441_1980_5p = (`res_tri_441_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_441_1980_5p'
gen LQ_res_tri_732_1980_5p = (`res_tri_732_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_732_1980_5p'
gen LQ_res_tri_510_1980_5p = (`res_tri_510_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_510_1980_5p'
gen LQ_res_tri_882_1980_5p = (`res_tri_882_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_882_1980_5p'
gen LQ_res_tri_891_1980_5p = (`res_tri_891_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_891_1980_5p'
gen LQ_res_tri_892_1980_5p = (`res_tri_892_1980_5p'/`res_tri_HT_1980_5p')/`LQ_US_892_1980_5p'

gen LQ_res_tri_181_1990_5p = (`res_tri_181_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_181_1990_5p'
gen LQ_res_tri_322_1990_5p = (`res_tri_322_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_322_1990_5p'
gen LQ_res_tri_341_1990_5p = (`res_tri_341_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_341_1990_5p'
gen LQ_res_tri_342_1990_5p = (`res_tri_342_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_342_1990_5p'
gen LQ_res_tri_441_1990_5p = (`res_tri_441_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_441_1990_5p'
gen LQ_res_tri_732_1990_5p = (`res_tri_732_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_732_1990_5p'
gen LQ_res_tri_510_1990_5p = (`res_tri_510_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_510_1990_5p'
gen LQ_res_tri_882_1990_5p = (`res_tri_882_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_882_1990_5p'
gen LQ_res_tri_891_1990_5p = (`res_tri_891_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_891_1990_5p'
gen LQ_res_tri_892_1990_5p = (`res_tri_892_1990_5p'/`res_tri_HT_1990_5p')/`LQ_US_892_1990_5p'

gen LQ_res_tri_181_2000_5p = (`res_tri_181_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_181_2000_5p'
gen LQ_res_tri_322_2000_5p = (`res_tri_322_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_322_2000_5p'
gen LQ_res_tri_341_2000_5p = (`res_tri_341_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_341_2000_5p'
gen LQ_res_tri_342_2000_5p = (`res_tri_342_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_342_2000_5p'
gen LQ_res_tri_441_2000_5p = (`res_tri_441_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_441_2000_5p'
gen LQ_res_tri_732_2000_5p = (`res_tri_732_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_732_2000_5p'
gen LQ_res_tri_510_2000_5p = (`res_tri_510_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_510_2000_5p'
gen LQ_res_tri_882_2000_5p = (`res_tri_882_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_882_2000_5p'
gen LQ_res_tri_891_2000_5p = (`res_tri_891_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_891_2000_5p'
gen LQ_res_tri_892_2000_5p = (`res_tri_892_2000_5p'/`res_tri_HT_2000_5p')/`LQ_US_892_2000_5p'

gen LQ_res_tri_181_2009_5y = (`res_tri_181_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_181_2009_5y'
gen LQ_res_tri_322_2009_5y = (`res_tri_322_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_322_2009_5y'
gen LQ_res_tri_341_2009_5y = (`res_tri_341_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_341_2009_5y'
gen LQ_res_tri_342_2009_5y = (`res_tri_342_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_342_2009_5y'
gen LQ_res_tri_441_2009_5y = (`res_tri_441_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_441_2009_5y'
gen LQ_res_tri_732_2009_5y = (`res_tri_732_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_732_2009_5y'
gen LQ_res_tri_510_2009_5y = (`res_tri_510_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_510_2009_5y'
gen LQ_res_tri_882_2009_5y = (`res_tri_882_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_882_2009_5y'
gen LQ_res_tri_891_2009_5y = (`res_tri_891_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_891_2009_5y'
gen LQ_res_tri_892_2009_5y = (`res_tri_892_2009_5y'/`res_tri_HT_2009_5y')/`LQ_US_892_2009_5y'

gen LQ_res_tri_181_2014_5y = (`res_tri_181_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_181_2014_5y'
gen LQ_res_tri_322_2014_5y = (`res_tri_322_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_322_2014_5y'
gen LQ_res_tri_341_2014_5y = (`res_tri_341_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_341_2014_5y'
gen LQ_res_tri_342_2014_5y = (`res_tri_342_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_342_2014_5y'
gen LQ_res_tri_441_2014_5y = (`res_tri_441_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_441_2014_5y'
gen LQ_res_tri_732_2014_5y = (`res_tri_732_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_732_2014_5y'
gen LQ_res_tri_510_2014_5y = (`res_tri_510_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_510_2014_5y'
gen LQ_res_tri_882_2014_5y = (`res_tri_882_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_882_2014_5y'
gen LQ_res_tri_891_2014_5y = (`res_tri_891_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_891_2014_5y'
gen LQ_res_tri_892_2014_5y = (`res_tri_892_2014_5y'/`res_tri_HT_2014_5y')/`LQ_US_892_2014_5y'

*LQs for svalley
gen LQ_svalley_181_1980_5p = (`svalley_181_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_181_1980_5p'
gen LQ_svalley_322_1980_5p = (`svalley_322_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_322_1980_5p'
gen LQ_svalley_341_1980_5p = (`svalley_341_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_341_1980_5p'
gen LQ_svalley_342_1980_5p = (`svalley_342_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_342_1980_5p'
gen LQ_svalley_441_1980_5p = (`svalley_441_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_441_1980_5p'
gen LQ_svalley_732_1980_5p = (`svalley_732_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_732_1980_5p'
gen LQ_svalley_510_1980_5p = (`svalley_510_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_510_1980_5p'
gen LQ_svalley_882_1980_5p = (`svalley_882_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_882_1980_5p'
gen LQ_svalley_891_1980_5p = (`svalley_891_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_891_1980_5p'
gen LQ_svalley_892_1980_5p = (`svalley_892_1980_5p'/`svalley_HT_1980_5p')/`LQ_US_892_1980_5p'

gen LQ_svalley_181_1990_5p = (`svalley_181_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_181_1990_5p'
gen LQ_svalley_322_1990_5p = (`svalley_322_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_322_1990_5p'
gen LQ_svalley_341_1990_5p = (`svalley_341_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_341_1990_5p'
gen LQ_svalley_342_1990_5p = (`svalley_342_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_342_1990_5p'
gen LQ_svalley_441_1990_5p = (`svalley_441_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_441_1990_5p'
gen LQ_svalley_732_1990_5p = (`svalley_732_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_732_1990_5p'
gen LQ_svalley_510_1990_5p = (`svalley_510_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_510_1990_5p'
gen LQ_svalley_882_1990_5p = (`svalley_882_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_882_1990_5p'
gen LQ_svalley_891_1990_5p = (`svalley_891_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_891_1990_5p'
gen LQ_svalley_892_1990_5p = (`svalley_892_1990_5p'/`svalley_HT_1990_5p')/`LQ_US_892_1990_5p'

gen LQ_svalley_181_2000_5p = (`svalley_181_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_181_2000_5p'
gen LQ_svalley_322_2000_5p = (`svalley_322_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_322_2000_5p'
gen LQ_svalley_341_2000_5p = (`svalley_341_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_341_2000_5p'
gen LQ_svalley_342_2000_5p = (`svalley_342_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_342_2000_5p'
gen LQ_svalley_441_2000_5p = (`svalley_441_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_441_2000_5p'
gen LQ_svalley_732_2000_5p = (`svalley_732_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_732_2000_5p'
gen LQ_svalley_510_2000_5p = (`svalley_510_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_510_2000_5p'
gen LQ_svalley_882_2000_5p = (`svalley_882_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_882_2000_5p'
gen LQ_svalley_891_2000_5p = (`svalley_891_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_891_2000_5p'
gen LQ_svalley_892_2000_5p = (`svalley_892_2000_5p'/`svalley_HT_2000_5p')/`LQ_US_892_2000_5p'

gen LQ_svalley_181_2009_5y = (`svalley_181_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_181_2009_5y'
gen LQ_svalley_322_2009_5y = (`svalley_322_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_322_2009_5y'
gen LQ_svalley_341_2009_5y = (`svalley_341_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_341_2009_5y'
gen LQ_svalley_342_2009_5y = (`svalley_342_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_342_2009_5y'
gen LQ_svalley_441_2009_5y = (`svalley_441_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_441_2009_5y'
gen LQ_svalley_732_2009_5y = (`svalley_732_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_732_2009_5y'
gen LQ_svalley_510_2009_5y = (`svalley_510_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_510_2009_5y'
gen LQ_svalley_882_2009_5y = (`svalley_882_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_882_2009_5y'
gen LQ_svalley_891_2009_5y = (`svalley_891_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_891_2009_5y'
gen LQ_svalley_892_2009_5y = (`svalley_892_2009_5y'/`svalley_HT_2009_5y')/`LQ_US_892_2009_5y'

gen LQ_svalley_181_2014_5y = (`svalley_181_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_181_2014_5y'
gen LQ_svalley_322_2014_5y = (`svalley_322_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_322_2014_5y'
gen LQ_svalley_341_2014_5y = (`svalley_341_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_341_2014_5y'
gen LQ_svalley_342_2014_5y = (`svalley_342_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_342_2014_5y'
gen LQ_svalley_441_2014_5y = (`svalley_441_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_441_2014_5y'
gen LQ_svalley_732_2014_5y = (`svalley_732_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_732_2014_5y'
gen LQ_svalley_510_2014_5y = (`svalley_510_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_510_2014_5y'
gen LQ_svalley_882_2014_5y = (`svalley_882_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_882_2014_5y'
gen LQ_svalley_891_2014_5y = (`svalley_891_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_891_2014_5y'
gen LQ_svalley_892_2014_5y = (`svalley_892_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_892_2014_5y'

export excel LQHTsectors.xlsx, first (var) replace

timer off 1
timer list 1


