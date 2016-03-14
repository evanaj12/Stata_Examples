*Tabulates civilian labor force (people) for each region in each year
* US, ATX, RT, SV
* in 1980, 1990, 2000, 2009-5y, 2014-5y.
*Evan Johnston

timer clear 1
timer on 1

foreach region in national regional{

	foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		
		use ipums_`year'.dta, clear
		keep fulltime fullyear perwt high_tech austin res_tri svalley
		
		if ("`region'"=="national") {
			gen labor_`region'_`year' = perwt
			collapse (sum) labor_`region'_`year', by (fulltime fullyear high_tech)
			save `region'_`year'_labor.dta, replace
		}
		else{
			drop if (austin!=1 & res_tri!=1 & svalley!=1)
			gen labor_`region'_`year' = perwt
			collapse (sum) labor_`region'_`year', by (fulltime fullyear high_tech austin res_tri svalley)
			save `region'_`year'_labor.dta, replace
		}
	}
	
	if ("`region'"=="national") {

	use `region'_1980_5p_labor.dta, clear
	merge 1:1 fulltime fullyear high_tech using `region'_1990_5p_labor.dta
	drop _merge
	merge 1:1 fulltime fullyear high_tech using `region'_2000_5p_labor.dta
	drop _merge
	merge 1:1 fulltime fullyear high_tech using `region'_2009_5y_labor.dta
	drop _merge
	merge 1:1 fulltime fullyear high_tech using `region'_2014_5y_labor.dta
	drop _merge

	sort fullyear fulltime high_tech
	save `region'_labor.dta, replace
	export excel `region'_labor.xlsx, first (var) replace
	}
	else {

	use `region'_1980_5p_labor.dta, clear
	merge 1:1 fulltime fullyear high_tech austin res_tri svalley using `region'_1990_5p_labor.dta
	drop _merge
	merge 1:1 fulltime fullyear high_tech austin res_tri svalley using `region'_2000_5p_labor.dta
	drop _merge
	merge 1:1 fulltime fullyear high_tech austin res_tri svalley using `region'_2009_5y_labor.dta
	drop _merge
	merge 1:1 fulltime fullyear high_tech austin res_tri svalley using `region'_2014_5y_labor.dta
	drop _merge
	
	sort fullyear fulltime high_tech austin res_tri svalley
	save `region'_labor.dta, replace
	export excel `region'_labor.xlsx, first (var) replace
	}

}

timer off 1
timer list 1
