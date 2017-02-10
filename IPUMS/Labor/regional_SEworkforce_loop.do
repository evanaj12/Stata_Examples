*Tabulates civilian SElabor force (people) for each region in each year
* US, ATX, RT, SV
* in 1980, 1990, 2000, 2009-5y, 2014-5y.
*Evan Johnston

timer clear 1
timer on 1
set more off

foreach region in national regional{

	foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		
		use ipums_`year'.dta, clear
		keep selfemp uhrswork perwt high_tech it_sector austin res_tri svalley
		
		keep if selfemp==1
		gen selfemp_fulltime=0
		replace selfemp_fulltime=1 if uhrswork>=15
	
		* must have worked "enough" at the self-employment position
		*	follows the KF restriction (see KF Index of StartupActivity Metro Area p.59)
		drop if selfemp_fulltime!=1
	
		if ("`region'"=="national") {
			gen SElabor_`region'_`year' = perwt
			collapse (sum) SElabor_`region'_`year', by (high_tech it_sector)
			save `region'_`year'_SElabor.dta, replace
		}
		else{
			drop if (austin!=1 & res_tri!=1 & svalley!=1)
			gen SElabor_`region'_`year' = perwt
			collapse (sum) SElabor_`region'_`year', by (high_tech it_sector austin res_tri svalley)
			save `region'_`year'_SElabor.dta, replace
		}
	}
	
	if ("`region'"=="national") {

	use `region'_1960_5p_SElabor.dta, clear
	merge 1:1  high_tech it_sector using `region'_1970_1pf2_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector using `region'_1980_5p_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector using `region'_1990_5p_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector using `region'_2000_5p_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector using `region'_2009_5y_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector using `region'_2014_5y_SElabor.dta
	drop _merge

	sort  high_tech it_sector
	save `region'_SElabor.dta, replace
	export excel `region'_SElabor.xlsx, first (var) replace
	}
	else {

	use `region'_1960_5p_SElabor.dta, clear
	merge 1:1  high_tech it_sector austin res_tri svalley using `region'_1970_1pf2_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector austin res_tri svalley using `region'_1980_5p_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector austin res_tri svalley using `region'_1990_5p_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector austin res_tri svalley using `region'_2000_5p_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector austin res_tri svalley using `region'_2009_5y_SElabor.dta
	drop _merge
	merge 1:1  high_tech it_sector austin res_tri svalley using `region'_2014_5y_SElabor.dta
	drop _merge
	
	sort  high_tech it_sector austin res_tri svalley
	save `region'_SElabor.dta, replace
	export excel `region'_SElabor.xlsx, first (var) replace
	}

}
foreach region in national regional{
	foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		erase `region'_`year'_SElabor.dta
	}
}

timer off 1
timer list 1
