/*
Creation of exlusion criteria in NETSData

Evan Johnston
*/

set more off
timer clear 1
timer on 1

* create austin_zips datafile if not already created in the directory
*do AustinMSAZips.do

* create ExcludeNAICS datafile if not already created in the directory
*do ImportExcludeNAICS.do

* import NETSData
*use NETSData.dta, clear

/***** Exclusion 1 *****
First location of establishment is in Austin MSA
*/
gen exclude1 = 0
replace exclude1 = 1 if cbsa_first!="12420"

/***** Exclusion 2 *****
Remove establishments that reported an exluded NAICS code in any year
e.g. NAICS code family 92*- military and public service
*/
gen exclude2 = 0
forvalues i = 90(1) 99{
	rename naics`i' ExcludeNAICS
	merge m:1 ExcludeNAICS using ExcludeNAICS.dta
	replace exclude2 = 1 if _merge==3
	rename ExcludeNAICS naics`i'
	drop _merge ExcludeNAICS_Title
	drop if dunsnumber==""
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14{
	rename naics`i' ExcludeNAICS
	merge m:1 ExcludeNAICS using ExcludeNAICS.dta
	replace exclude2 = 1 if _merge==3
	rename ExcludeNAICS naics`i'
	drop _merge ExcludeNAICS_Title
	drop if dunsnumber==""
}

/***** Exclusion 3 *****
Remove sole proprietors and partnerships identified by having 1 employee
in the first year employment data is available.
*/

gen emp_first = 0
gen emp_yrfirst = 0
foreach i in 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00{
	replace emp_first = emp`i' if emp`i'!=.
	replace emp_yrfirst = `i' if emp`i'!=.
}
forvalues i = 99(-1) 90{
	replace emp_first = emp`i' if emp`i'!=.
	replace emp_yrfirst = `i' if emp`i'!=.
}
gen emp_last = 0
gen emp_yrlast = 0
forvalues i = 90(1) 99{
	replace emp_last = emp`i' if emp`i'!=.
	replace emp_yrlast = `i' if emp`i'!=.
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14{
	replace emp_last = emp`i' if emp`i'!=.
	replace emp_yrlast = `i' if emp`i'!=.
}
gen emp_first_cat = 0
	replace emp_first_cat = 1 if (0<emp_first & emp_first<3)
	replace emp_first_cat = 2 if (2<emp_first & emp_first<11)
	replace emp_first_cat = 3 if (10<emp_first & emp_first<51)
	replace emp_first_cat = 4 if (50<emp_first & emp_first<101)
	replace emp_first_cat = 5 if (100<emp_first & emp_first<501)
	replace emp_first_cat = 6 if (500<emp_first & emp_first<1001)
	replace emp_first_cat = 7 if (1000<emp_first)
	
label define emp_first_cat_label ///
	1 "1 - 2 employees" ///
	2 "3 - 10 employees" ///
	3 "11 - 50 employees" ///
	4 "51 - 100 employees" ///
	5 "101 - 500 employees" ///
	6 "501 - 1000 employees" ///
	7 ">1000 employees"
label values emp_first_cat emp_first_cat_label

/***** Startup candidacy *****
An establishment is a probable quality startup candidate if:
			1) it started in the appropriate time interval
				1990<=year & year<=2013
				AND first year was in Austin
				exclude1==0 ==> zipcode_first is in Austin MSA zip code list
					NOTE: year = firstyear | yearstart;
						yearstart gives annual startup establishment counts
							closer to the SoS, but has missing values for
							over 100,000 records
						firstyear has no missing values but is less indicative
							of firm birth, rather showing firm activity start
					UPDATE: firstyear = yearstart when firstyear>1989. thus firstyear is used.
					. correlate firstyear yearstart if yearstart>1989

									| firsty~r yearst~t
						-------------+------------------
						firstyear |   1.0000
						yearstart |   1.0000   1.0000
			2) it is not a branch establishment
				estcat!="branch"
			3) it is not a non-profit legal status
				legalstat_n!=4
				NOTE: there are  248,382 (69.18 %) missing values for the legalstat
				variable
			4) it is not an excluded NAICS code for any year
				exclude2==0
			5) it is not a sole proprietorship by employment proxy or legal status
				emp_first>1 & legalstat_n!=1
				
*/

* An establishment is a probable quality startup candidate if:
*	1), 2), 3), 4), 5) are met
gen quality_startup = 0
replace quality_startup = 1 if ( ///
	( (1990<=firstyear & firstyear<=2013) & (exclude1==0) ) & ///
	(estcat!="Branch") & ///
	(legalstat_n!=1 & legalstat_n!=4) & ///
	(exclude2 == 0) & ///
	(emp_first > 1) )
	
gen startup_1_crit = 0
replace startup_1_crit = 1 if ( ///
	( (1990<=firstyear & firstyear<=2013) & (exclude1==0) ) )
	
gen startup_2_crit = 0
replace startup_2_crit = 1 if ( ///
	( (1990<=firstyear & firstyear<=2013) & (exclude1==0) ) & ///
	(estcat!="Branch") )
	
gen startup_3_crit = 0
replace startup_3_crit = 1 if ( ///
	( (1990<=firstyear & firstyear<=2013) & (exclude1==0) ) & ///
	(estcat!="Branch") & ///
	(legalstat_n!=4) )

* An establishment is a probable startup candidate if:
*	1), 2), 3), 4) are met
gen startup = 0
replace startup = 1 if ( ///
	( (1990<=firstyear & firstyear<=2013) & (exclude1==0) ) & ///
	(estcat!="Branch") & ///
	(legalstat_n!=4) & ///
	(exclude2==0) )
		
* notes descriptions
notes exclude1: binary indicator of if an establishment's first zipcode was in the Austin-MSA
notes exclude2: binary indicator of if an establishment reported an excluded ///
	NAICS code at any point in time
notes startup: binary indicator of if an establishment meets the ///
	NETS data criterion of a startup, namley ///
	1) started between 1990 and 2013 in the Austin MSA, ///
	2) is not a Branch establishment category, ///
	3) is not a non-profit legal status, ///
	4) does not have an excluded NAICS code status
notes quality_startup: binary indicator of if an establishment meets the ///
	NETS data criterion of a startup, namley ///
	1) started between 1990 and 2013 in the Austin MSA, ///
	2) is not a Branch establishment category, ///
	3) is not a sole proprietorship nor a non-profit legal status, ///
	4) does not have an excluded NAICS code status, ///
	5) is not a sole proprietorship by employment (had 1 employee in first year)
notes emp_first: Number of employees reported in first year of employment
notes emp_yrfirst: Year of first reported employment (should be firstyear+1)
notes emp_last: Number of employees reported in last year of employment
notes emp_yrlast: Year of last reported employment
notes emp_first_cat: Categories of number of employees reported in first year of employment

timer off 1
timer list 1

/*
OLD EXLUSION 1 CRITERIA:

Only keep establishments that had their first zipcode in Austin MSA

gen exclude1 = 0
rename zipcode_first entity_zip
merge m:1 entity_zip using austin_zips.dta
replace exclude1 = 1 if _merge!=3
drop _merge
rename entity_zip zipcode_first

* zipcode list may be incomplete: use CBSA_First to establish birth location 11/4/16

gen austin_dest = 0
gen austin_orig = 0

rename destzip entity_zip
merge m:1 entity_zip using austin_zips.dta
replace austin_dest = 1 if _merge==3
drop _merge
rename entity_zip destzip

rename originzip entity_zip
merge m:1 entity_zip using austin_zips.dta
replace austin_orig = 1 if _merge==3
drop _merge
rename entity_zip originzip

replace exclude1 = 1 if (austin_dest==1 & austin_orig==0)
*/

