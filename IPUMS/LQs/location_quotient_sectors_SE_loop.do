*Calculates Location Quotient for 3 regions for main HT-sectors
*Evan Johnston

* LQ=(ei/e)/(Ei/E)
* ei = employment in ht-sector i in region
* e  = total ht-employment in region
* Ei = employment in ht-sector i in nation
* E  = total ht-employment in nation
set more off
timer clear 1
timer on 1

foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	
	use ipums_`year'.dta, clear
	keep year fulltime fullyear uhrswork selfemp perwt ind1990 high_tech it_sector austin res_tri svalley
	drop if selfemp!=1
	drop if high_tech!=1
	
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
	capture collapse (sum) person_`year', by (year)
	drop if (year==.)
	
	*create local variable of total employment	
	local US_HT_`year' = person_`year'[1]
	
	* for each region austin, research triangle, silicon valley
	*res_tri svalley
	foreach region in austin {
		
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
	foreach sector in 1 2 3 4 5 6 {
		
		*use precollapse data
		use precollapse.dta, clear
		
		*keep only sector workers
		drop if (it_sector!=`sector')

		*collapse to get sum of sectorial workers	
		capture collapse (sum) person_`year', by (year)
		drop if (year==.)

		*create local variable of sectorial employment
		local US_`sector'_`year' = person_`year'[1]
	
		* for each region austin, research triangle, silicon valley
		*res_tri svalley
		foreach region in austin {
		
			*use regional data
			use `region'_`year'.dta, clear

			*keep only sector workers
			drop if (it_sector!=`sector')
				
			* collapse to get sum of fullemp persons in region
			capture collapse (sum) person_`year', by (year)
			drop if (year==.)
			
			*create local variable of sectorial employment
			local `region'_`sector'_`year' = person_`year'[1]
		
		}
	}
}
foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	*res_tri svalley
	foreach region in austin {
		erase `region'_`year'.dta
	}
}
clear
set obs 1

*create national sector ratios
local LQ_US_1_1960_5p = (`US_1_1960_5p'/`US_HT_1960_5p')
local LQ_US_2_1960_5p = (`US_2_1960_5p'/`US_HT_1960_5p')
local LQ_US_3_1960_5p = (`US_3_1960_5p'/`US_HT_1960_5p')
local LQ_US_4_1960_5p = (`US_4_1960_5p'/`US_HT_1960_5p')
local LQ_US_5_1960_5p = (`US_5_1960_5p'/`US_HT_1960_5p')
local LQ_US_6_1960_5p = (`US_6_1960_5p'/`US_HT_1960_5p')

local LQ_US_1_1970_1pf2 = (`US_1_1970_1pf2'/`US_HT_1970_1pf2')
local LQ_US_2_1970_1pf2 = (`US_2_1970_1pf2'/`US_HT_1970_1pf2')
local LQ_US_3_1970_1pf2 = (`US_3_1970_1pf2'/`US_HT_1970_1pf2')
local LQ_US_4_1970_1pf2 = (`US_4_1970_1pf2'/`US_HT_1970_1pf2')
local LQ_US_5_1970_1pf2 = (`US_5_1970_1pf2'/`US_HT_1970_1pf2')
local LQ_US_6_1970_1pf2 = (`US_6_1970_1pf2'/`US_HT_1970_1pf2')

local LQ_US_1_1980_5p = (`US_1_1980_5p'/`US_HT_1980_5p')
local LQ_US_2_1980_5p = (`US_2_1980_5p'/`US_HT_1980_5p')
local LQ_US_3_1980_5p = (`US_3_1980_5p'/`US_HT_1980_5p')
local LQ_US_4_1980_5p = (`US_4_1980_5p'/`US_HT_1980_5p')
local LQ_US_5_1980_5p = (`US_5_1980_5p'/`US_HT_1980_5p')
local LQ_US_6_1980_5p = (`US_6_1980_5p'/`US_HT_1980_5p')

local LQ_US_1_1990_5p = (`US_1_1990_5p'/`US_HT_1990_5p')
local LQ_US_2_1990_5p = (`US_2_1990_5p'/`US_HT_1990_5p')
local LQ_US_3_1990_5p = (`US_3_1990_5p'/`US_HT_1990_5p')
local LQ_US_4_1990_5p = (`US_4_1990_5p'/`US_HT_1990_5p')
local LQ_US_5_1990_5p = (`US_5_1990_5p'/`US_HT_1990_5p')
local LQ_US_6_1990_5p = (`US_6_1990_5p'/`US_HT_1990_5p')

local LQ_US_1_2000_5p = (`US_1_2000_5p'/`US_HT_2000_5p')
local LQ_US_2_2000_5p = (`US_2_2000_5p'/`US_HT_2000_5p')
local LQ_US_3_2000_5p = (`US_3_2000_5p'/`US_HT_2000_5p')
local LQ_US_4_2000_5p = (`US_4_2000_5p'/`US_HT_2000_5p')
local LQ_US_5_2000_5p = (`US_5_2000_5p'/`US_HT_2000_5p')
local LQ_US_6_2000_5p = (`US_6_2000_5p'/`US_HT_2000_5p')

local LQ_US_1_2009_5y = (`US_1_2009_5y'/`US_HT_2009_5y')
local LQ_US_2_2009_5y = (`US_2_2009_5y'/`US_HT_2009_5y')
local LQ_US_3_2009_5y = (`US_3_2009_5y'/`US_HT_2009_5y')
local LQ_US_4_2009_5y = (`US_4_2009_5y'/`US_HT_2009_5y')
local LQ_US_5_2009_5y = (`US_5_2009_5y'/`US_HT_2009_5y')
local LQ_US_6_2009_5y = (`US_6_2009_5y'/`US_HT_2009_5y')

local LQ_US_1_2014_5y = (`US_1_2014_5y'/`US_HT_2014_5y')
local LQ_US_2_2014_5y = (`US_2_2014_5y'/`US_HT_2014_5y')
local LQ_US_3_2014_5y = (`US_3_2014_5y'/`US_HT_2014_5y')
local LQ_US_4_2014_5y = (`US_4_2014_5y'/`US_HT_2014_5y')
local LQ_US_5_2014_5y = (`US_5_2014_5y'/`US_HT_2014_5y')
local LQ_US_6_2014_5y = (`US_6_2014_5y'/`US_HT_2014_5y')

*LQs for austin
gen LQ_austin_1_1960_5p = (`austin_1_1960_5p'/`austin_HT_1960_5p')/`LQ_US_1_1960_5p'
gen LQ_austin_2_1960_5p = (`austin_2_1960_5p'/`austin_HT_1960_5p')/`LQ_US_2_1960_5p'
gen LQ_austin_3_1960_5p = (`austin_3_1960_5p'/`austin_HT_1960_5p')/`LQ_US_3_1960_5p'
gen LQ_austin_4_1960_5p = (`austin_4_1960_5p'/`austin_HT_1960_5p')/`LQ_US_4_1960_5p'
gen LQ_austin_5_1960_5p = (`austin_5_1960_5p'/`austin_HT_1960_5p')/`LQ_US_5_1960_5p'
gen LQ_austin_6_1960_5p = (`austin_6_1960_5p'/`austin_HT_1960_5p')/`LQ_US_6_1960_5p'

gen LQ_austin_1_1970_1pf2 = (`austin_1_1970_1pf2'/`austin_HT_1970_1pf2')/`LQ_US_1_1970_1pf2'
gen LQ_austin_2_1970_1pf2 = (`austin_2_1970_1pf2'/`austin_HT_1970_1pf2')/`LQ_US_2_1970_1pf2'
gen LQ_austin_3_1970_1pf2 = (`austin_3_1970_1pf2'/`austin_HT_1970_1pf2')/`LQ_US_3_1970_1pf2'
gen LQ_austin_4_1970_1pf2 = (`austin_4_1970_1pf2'/`austin_HT_1970_1pf2')/`LQ_US_4_1970_1pf2'
gen LQ_austin_5_1970_1pf2 = (`austin_5_1970_1pf2'/`austin_HT_1970_1pf2')/`LQ_US_5_1970_1pf2'
gen LQ_austin_6_1970_1pf2 = (`austin_6_1970_1pf2'/`austin_HT_1970_1pf2')/`LQ_US_6_1970_1pf2'

gen LQ_austin_1_1980_5p = (`austin_1_1980_5p'/`austin_HT_1980_5p')/`LQ_US_1_1980_5p'
gen LQ_austin_2_1980_5p = (`austin_2_1980_5p'/`austin_HT_1980_5p')/`LQ_US_2_1980_5p'
gen LQ_austin_3_1980_5p = (`austin_3_1980_5p'/`austin_HT_1980_5p')/`LQ_US_3_1980_5p'
gen LQ_austin_4_1980_5p = (`austin_4_1980_5p'/`austin_HT_1980_5p')/`LQ_US_4_1980_5p'
gen LQ_austin_5_1980_5p = (`austin_5_1980_5p'/`austin_HT_1980_5p')/`LQ_US_5_1980_5p'
gen LQ_austin_6_1980_5p = (`austin_6_1980_5p'/`austin_HT_1980_5p')/`LQ_US_6_1980_5p'

gen LQ_austin_1_1990_5p = (`austin_1_1990_5p'/`austin_HT_1990_5p')/`LQ_US_1_1990_5p'
gen LQ_austin_2_1990_5p = (`austin_2_1990_5p'/`austin_HT_1990_5p')/`LQ_US_2_1990_5p'
gen LQ_austin_3_1990_5p = (`austin_3_1990_5p'/`austin_HT_1990_5p')/`LQ_US_3_1990_5p'
gen LQ_austin_4_1990_5p = (`austin_4_1990_5p'/`austin_HT_1990_5p')/`LQ_US_4_1990_5p'
gen LQ_austin_5_1990_5p = (`austin_5_1990_5p'/`austin_HT_1990_5p')/`LQ_US_5_1990_5p'
gen LQ_austin_6_1990_5p = (`austin_6_1990_5p'/`austin_HT_1990_5p')/`LQ_US_6_1990_5p'

gen LQ_austin_1_2000_5p = (`austin_1_2000_5p'/`austin_HT_2000_5p')/`LQ_US_1_2000_5p'
gen LQ_austin_2_2000_5p = (`austin_2_2000_5p'/`austin_HT_2000_5p')/`LQ_US_2_2000_5p'
gen LQ_austin_3_2000_5p = (`austin_3_2000_5p'/`austin_HT_2000_5p')/`LQ_US_3_2000_5p'
gen LQ_austin_4_2000_5p = (`austin_4_2000_5p'/`austin_HT_2000_5p')/`LQ_US_4_2000_5p'
gen LQ_austin_5_2000_5p = (`austin_5_2000_5p'/`austin_HT_2000_5p')/`LQ_US_5_2000_5p'
gen LQ_austin_6_2000_5p = (`austin_6_2000_5p'/`austin_HT_2000_5p')/`LQ_US_6_2000_5p'

gen LQ_austin_1_2009_5y = (`austin_1_2009_5y'/`austin_HT_2009_5y')/`LQ_US_1_2009_5y'
gen LQ_austin_2_2009_5y = (`austin_2_2009_5y'/`austin_HT_2009_5y')/`LQ_US_2_2009_5y'
gen LQ_austin_3_2009_5y = (`austin_3_2009_5y'/`austin_HT_2009_5y')/`LQ_US_3_2009_5y'
gen LQ_austin_4_2009_5y = (`austin_4_2009_5y'/`austin_HT_2009_5y')/`LQ_US_4_2009_5y'
gen LQ_austin_5_2009_5y = (`austin_5_2009_5y'/`austin_HT_2009_5y')/`LQ_US_5_2009_5y'
gen LQ_austin_6_2009_5y = (`austin_6_2009_5y'/`austin_HT_2009_5y')/`LQ_US_6_2009_5y'

gen LQ_austin_1_2014_5y = (`austin_1_2014_5y'/`austin_HT_2014_5y')/`LQ_US_1_2014_5y'
gen LQ_austin_2_2014_5y = (`austin_2_2014_5y'/`austin_HT_2014_5y')/`LQ_US_2_2014_5y'
gen LQ_austin_3_2014_5y = (`austin_3_2014_5y'/`austin_HT_2014_5y')/`LQ_US_3_2014_5y'
gen LQ_austin_4_2014_5y = (`austin_4_2014_5y'/`austin_HT_2014_5y')/`LQ_US_4_2014_5y'
gen LQ_austin_5_2014_5y = (`austin_5_2014_5y'/`austin_HT_2014_5y')/`LQ_US_5_2014_5y'
gen LQ_austin_6_2014_5y = (`austin_6_2014_5y'/`austin_HT_2014_5y')/`LQ_US_6_2014_5y'

*LQs for res_tri
/*
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
gen LQ_svalley_882_2014_5y = (`svalley_882_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_882d_2014_5y'
gen LQ_svalley_891_2014_5y = (`svalley_891_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_891_2014_5y'
gen LQ_svalley_892_2014_5y = (`svalley_892_2014_5y'/`svalley_HT_2014_5y')/`LQ_US_892_2014_5y'
*/

export excel LQHTSEsectors.xlsx, first (var) replace

timer off 1
timer list 1


