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

*1960_5p 1970_1pf2 
foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	
	use ipums_`year'.dta, clear
	keep year fulltime fullyear selfemp perwt ind1990 high_tech it_sector austin res_tri svalley
	drop if fulltime!=1
	drop if high_tech!=1
		
	*Create people	
	gen person_`year'= perwt
	
	* Create modified ITC sectors: add sector of Pharm & R&D (NAICS 3254, 5417)
	gen it_sector_mod = 0
	replace it_sector_mod = 7 if high_tech == 1
	replace it_sector_mod = 1 if inlist(ind1990, 331, 342)
	replace it_sector_mod = 2 if inlist(ind1990, 322, 332, 371, 341)
	replace it_sector_mod = 3 if inlist(ind1990, 732)
	replace it_sector_mod = 4 if inlist(ind1990, 510, 441, 440)
	replace it_sector_mod = 5 if inlist(ind1990, 882, 892)
	replace it_sector_mod = 6 if inlist(ind1990, 181, 891)
	
	label define it_sector_label_mod ///
		1 "Semiconductor & Electrical Equipment Mfg." ///
		2 "Computer & Related Equipment Mfg." ///
		3 "Software Publishers, Computer Systems Design, and Related Services" ///
		4 "Commercial Equipment Wholesalers (Dell) & Telecommunication Provider Services" ///
		5 "High-Tech Business Services (Architectural, Engineering, Management Consulting, and other Scientific and Technical Consulting Services)" ///
		6 "Pharmaceutical & Medicine Mfg. & R&D Testing Services" ///
		7 "Other High-Tech"
	label values it_sector_mod it_sector_label_mod

	*save data before collapse (national)
	save precollapse.dta, replace
		
	*collapse to get sum of fullemp persons in US
	capture noisily collapse (sum) person_`year', by (year)
	drop if (year==.)
	
	*create local variable of total employment	
	local US_HT_`year' = person_`year'[1]
	
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
		capture noisily collapse (sum) person_`year', by (year)
		drop if (year==.)
		
		* create locale variable of regional employment
		local `region'_HT_`year' = person_`year'[1]
	}
	
	* for each selected  HT sector:
	foreach sector in 1 2 3 4 5 6 7 {
		
		*use precollapse data
		use precollapse.dta, clear
		
		*keep only sector workers
		drop if (it_sector_mod!=`sector')

		*collapse to get sum of sectorial workers	
		capture noisily collapse (sum) person_`year', by (year)
		drop if (year==.)

		*create local variable of sectorial employment
		local US_`sector'_`year' = person_`year'[1]
	
		* for each region austin, research triangle, silicon valley
		* res_tri svalley
		foreach region in austin {
		
			*use regional data
			use `region'_`year'.dta, clear

			*keep only sector workers
			drop if (it_sector_mod!=`sector')
				
			* collapse to get sum of fullemp persons in region
			capture noisily collapse (sum) person_`year', by (year)
			drop if (year==.)
			
			*create local variable of sectorial employment
			local `region'_`sector'_`year' = person_`year'[1]
		
		}
	}
}

clear
set obs 1

* create the LQs
*1960_5p 1970_1pf2 
foreach year1 in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	display "here 1"
	foreach sector1 in 1 2 3 4 5 6 7 {
		local LQ_US_`sector1'_`year1'= `=`US_`sector1'_`year1''/`US_HT_`year1'''
		* creates local variable of US LQ for each sector and year
	display "here 2"
		* svalley 
		foreach region1 in austin res_tri {
			local LQ_`region1'_`sector1'_`year1'= `=``region1'_`sector1'_`year1''/``region1'_HT_`year1'''
			* creates local variable of regional LQ for each sector and year
	display "here 3"
	display "`region1'"
	display "`sector1'"
	display "`year1'"
	display `LQ_`region1'_`sector1'_`year1''
		}
		* svalley
		foreach region2 in austin  res_tri {
			gen LQ_`region2'_`sector1'_`year1'= `=`LQ_`region2'_`sector1'_`year1''/`LQ_US_`sector1'_`year1'''
			* uses the local variables to create real variable output
	display "here 4"
		}
	}
}

* lists all the above created local variables
macro list

* remove the temp data sets
*1960_5p 1970_1pf2
foreach year in  1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	* svalley
	foreach region in austin res_tri {
		erase `region'_`year'.dta
	}
}
erase precollapse.dta

export excel LQHTsectors.xlsx, first (var) replace

timer off 1
timer list 1


