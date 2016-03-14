*Tabulates the number of SE jobs per HT sector for US, ATX, RT, SV full-employed
* in 1980, 1990, 2000, 2009-5y, 2014-5y.
*Evan Johnston

timer clear 1
timer on 1

foreach region in us atx rt sv{

	foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
		
		use ipums_`year'.dta, clear
		gen ind1990_code = ind1990
		keep fulltime fullyear selfemp perwt ind1990 ind1990_code high_tech austin res_tri svalley
		drop if high_tech!=1
		drop if selfemp!=1
		drop if fulltime!=1
		drop if fullyear!=1
		
		if ("`region'"=="atx") {
			drop if austin!=1
		}
		else if ("`region'"=="rt") {
			drop if res_tri!=1
		}
		else if ("`region'"=="sv") {
			drop if svalley!=1
		}
		
		gen jobsSE_`region'_`year' = perwt
		collapse (sum) jobsSE_`region'_`year', by (ind1990 ind1990_code)
		save `region'_`year'_HTSEjobs.dta, replace

	}
	
	use `region'_1980_5p_HTSEjobs.dta, clear
	merge 1:1 ind1990 using `region'_1990_5p_HTSEjobs.dta
	drop _merge
	erase `region'_1990_5p_HTSEjobs.dta
	merge 1:1 ind1990 using `region'_2000_5p_HTSEjobs.dta
	drop _merge
	erase `region'_2000_5p_HTSEjobs.dta
	merge 1:1 ind1990 using `region'_2009_5y_HTSEjobs.dta
	drop _merge
	erase `region'_2009_5y_HTSEjobs.dta
	merge 1:1 ind1990 using `region'_2014_5y_HTSEjobs.dta
	drop _merge
	erase `region'_2014_5y_HTSEjobs.dta

	save `region'_HTSEjobs.dta, replace
	erase `region'_1980_5p_HTSEjobs.dta
	export excel `region'_HTSEjobs.xlsx, first (var) replace

}

timer off 1
timer list 1
