/* MIGRATION From Cali: USA 1980 to 2014
Evan Johnston

files needed to run this do file:
	migration_data.dta		dataset of migration variables and information
*/

set more off
timer clear 1
timer on 1

use migration_data.dta, clear

* only keep full-time tech-oriented workers (not self-employed) who moved:
*	the previous year (ACS samples)
*	five years ago (Census samples)
keep if fulltime==1
drop if selfemp==1
keep if tech_oriented==1
drop if (migrate1<2 | migrate5<2)

* puts migplac1 and migplac5 into single variable
gen migplac=0
replace migplac=migplac1 if year>2000
replace migplac=migplac5 if year<2001
label values migplac MIGPLAC1

* keep California migrants only
keep if migplac==6

* weight the observations
gen person=perwt

save precollapse.dta, replace

* collapse 1: full-time tech-oriented cali migrants by state (domestic)
collapse (sum) person, by(year statefip)
reshape wide person, j(year) i(statefip)
*save migrant_tech_wrks_cali_state.dta, replace
export excel using "migrant_tech_wrks_cali_state", firstrow(variables) replace

use precollapse.dta, clear
gen msa=0
replace msa=1 if ( (year<2014 & metarea!=0) | (year>1999 & met2013!=0) )
replace msa=2 if austin==1
replace msa=3 if res_tri==1

* collapse 2: full-time tech-oriented cali migrants by MSA (domestic)
collapse (sum) person, by(year msa)
reshape wide person, j(year) i(msa)
*save migrant_tech_wrks_cali_msa.dta, replace
export excel using "migrant_tech_wrks_cali_msa", firstrow(variables) replace

use precollapse.dta, clear
* collapse 3: full-time tech-oriented cali migrants by (non-CA) MSA (domestic)
drop if statefip==6
collapse (sum) person, by(year met2013)
reshape wide person, j(year) i(met2013)
*save migrant_tech_wrks_cali_meta.dta, replace
export excel using "migrant_tech_wrks_cali_meta", firstrow(variables) replace
