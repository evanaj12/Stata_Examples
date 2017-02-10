/*
Tabulates civilian labor force (people) for each region in each year
 by high-tech industry, ITC sector, and IND1990 code
 in US, ATX, RT, SV (RT and SV not defined in 1960 or 1970)
 in 1960, 1970, 1980, 1990, 2000, 2009-5y, 2014-5y.
 
Evan Johnston
*/

set more off
timer clear 1
timer on 1

*us atx rt sv
foreach region in rt atx{

	* 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y
	foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		
		use ipums_`year'.dta, clear
		gen ind1990_code = ind1990
		keep fulltime selfemp perwt ind1990 ind1990_code high_tech it_sector it_sector_mod austin res_tri res_tri_mod
		drop if high_tech!=1
		drop if selfemp==1
		drop if fulltime!=1
		
		if ("`region'"=="atx") {
			drop if austin!=1
		}
		else if ("`region'"=="rt") {
			drop if res_tri_mod!=1
		}
		else if ("`region'"=="sv") {
			drop if svalley!=1
		}
		
		gen jobs_`region'_`year' = perwt
		collapse (sum) jobs_`region'_`year', by (it_sector_mod ind1990 ind1990_code)
		save `region'_`year'_HTjobs.dta, replace

	}
	/*
	use `region'_1960_5p_HTjobs.dta, clear
	merge 1:1 it_sector_mod ind1990 ind1990 using `region'_1970_1pf2_HTjobs.dta
	drop _merge
	erase `region'_1970_1pf2_HTjobs.dta
	merge 1:1 it_sector_mod ind1990 ind1990 using `region'_1980_5p_HTjobs.dta
	drop _merge
	erase `region'_1980_5p_HTjobs.dta
	*/
	use `region'_1980_5p_HTjobs.dta, clear
	merge 1:1 it_sector_mod ind1990 ind1990 using `region'_1990_5p_HTjobs.dta
	drop _merge
	erase `region'_1990_5p_HTjobs.dta
	merge 1:1 it_sector_mod ind1990 ind1990 using `region'_2000_5p_HTjobs.dta
	drop _merge
	erase `region'_2000_5p_HTjobs.dta
	merge 1:1 it_sector_mod ind1990 ind1990 using `region'_2009_5y_HTjobs.dta
	drop _merge
	erase `region'_2009_5y_HTjobs.dta
	merge 1:1 it_sector_mod ind1990 ind1990 using `region'_2014_5y_HTjobs.dta
	drop _merge
	erase `region'_2014_5y_HTjobs.dta

	save `region'_HTjobs.dta, replace
	*erase `region'_1960_5p_HTjobs.dta
	erase `region'_1980_5p_HTjobs.dta
	export excel `region'_HTjobs.xlsx, first (var) replace

}

timer off 1
timer list 1
