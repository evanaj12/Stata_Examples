/*
Tabulates civilian labor force (people) for each region in each year
 by high-tech industry and ITC sector
 in US, ATX, RT, SV (RT and SV not defined in 1960 or 1970)
 in 1960, 1970, 1980, 1990, 2000, 2009-5y, 2014-5y.
 
runtime: 1.5 min

Evan Johnston
*/

timer clear 1
timer on 1
set more off

foreach region in national regional{

	foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		
		use ipums_`year'.dta, clear
		keep fulltime selfemp selfemp_fulltime perwt high_tech it_sector_mod austin res_tri_mod svalley
		
		if ("`region'"=="national") {
			gen labor_`region'_`year' = perwt
			collapse (sum) labor_`region'_`year', by (fulltime selfemp selfemp_fulltime high_tech it_sector_mod)
			save `region'_`year'_labor.dta, replace
		}
		else{
			drop if (austin!=1 & res_tri_mod!=1 & svalley!=1)
			gen labor_`region'_`year' = perwt
			collapse (sum) labor_`region'_`year', by (fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley)
			save `region'_`year'_labor.dta, replace
		}
	}
	
	if ("`region'"=="national") {

	use `region'_1960_5p_labor.dta, clear
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod using `region'_1970_1pf2_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod using `region'_1980_5p_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod using `region'_1990_5p_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod using `region'_2000_5p_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod using `region'_2009_5y_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod using `region'_2014_5y_labor.dta
	drop _merge

	sort  fulltime selfemp selfemp_fulltime high_tech it_sector_mod
	save `region'_labor.dta, replace
	export excel `region'_labor.xlsx, first (var) replace
	}
	else {

	use `region'_1960_5p_labor.dta, clear
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley using `region'_1970_1pf2_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley using `region'_1980_5p_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley using `region'_1990_5p_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley using `region'_2000_5p_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley using `region'_2009_5y_labor.dta
	drop _merge
	merge 1:1 fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley using `region'_2014_5y_labor.dta
	drop _merge
	
	sort  fulltime selfemp selfemp_fulltime high_tech it_sector_mod austin res_tri_mod svalley
	save `region'_labor.dta, replace
	export excel `region'_labor.xlsx, first (var) replace
	}

}
foreach region in national regional{
	foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		erase `region'_`year'_labor.dta
	}
}

timer off 1
timer list 1
