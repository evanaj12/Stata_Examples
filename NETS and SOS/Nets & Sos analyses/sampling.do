/*
Sampling the merged data to test matching success

Evan Johnston
*/

************************* Sampling1: All Match Levels **************************

* use startups data and remove duplicates
use startups.dta, clear
duplicates drop entity_name filing_number company dunsnumber, force
keep dunsnumber company city state zipcode hqduns hqcompany hqcity hqstate ///
	hqzipcode subsidiary related kids estcat sicchange hqdunschange yearstart ///
	pubpriv firstyear lastyear city_first state_first zipcode_first ht_ind ///
	software ht_title cleaned_name16 cleaned_name32 match_level filing_number ///
	entity_name creation_date corp_type entity_city entity_zip entity_address1 ///
	entity_address2 status ///
	emp90 emp91 emp92 emp93 emp94 emp95 emp96 emp97 emp98 emp99 emp00 emp01 ///
	emp02 emp03 emp04 emp04 emp05 emp06 emp07 emp08 emp09 emp10 emp11 emp12 ///
	emp13 emphere ///
	empc90 empc91 empc92 empc93 empc94 empc95 empc96 empc97 empc98 empc99 empc00 empc01 ///
	empc02 empc03 empc04 empc04 empc05 empc06 empc07 empc08 empc09 empc10 empc11 empc12 ///
	empc13 empherec
save startups_uniq.dta, replace

* create uniform random variable on [0,1)
gen random = runiform()

* sort by this random var.
sort random

* take the first 100 observations as the random sample
*	keep relevant vars and save
gen sample1_1 = _n <= 100
keep if sample1_1==1

save sample1_1.dta, replace

* repeat
use startups_uniq.dta, clear

gen random = runiform()
sort random
gen sample1_2 = _n <= 100
keep if sample1_2==1

save sample1_2.dta, replace

* repeat
use startups_uniq.dta, clear

gen random = runiform()
sort random
gen sample1_3 = _n <= 100
keep if sample1_3==1

save sample1_3.dta, replace

*********************** Sampling2: Sample by Match Level ***********************

use startups_uniq.dta, clear

* create samples for each merge level
foreach i in 32 28 24 20 16 {
	use startups_uniq.dta, clear
	keep if match_level==`i'
	gen random = runiform()
	sort random
	gen sample2_`i' = _n <= 50
	keep if sample2_`i'==1
	save sample2_`i'.dta, replace
}
