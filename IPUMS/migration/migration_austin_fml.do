/* MIGRATION to Austin: USA 1980 to 2014
Evan Johnston

updated 1-25-17 to incorporate migration by sex

files needed to run this do file:
	migration_data.dta		dataset of migration variables and information
*/

set more off
timer clear 1
timer on 1

* austin res_tri res_tri_mod
foreach region in austin {

* use migration data
use migration_data.dta, clear

* only keep full-time tech-oriented workers (not self-employed) living in Austin who moved to Austin
* from OUTSIDE of Austin in:
*	the previous year (ACS samples)
*	five years ago (Census samples)
keep if fulltime==1
drop if selfemp==1
keep if `region'==1
keep if tech_oriented==1
drop if (migrate<2)
* currently austin-specific MIGMET*
drop if (migmet==640)
* remove international migrants
drop if migplac>56

save precollapse.dta, replace

* collapse 1: full-time tech-oriented migrants by state (domestic)
gen person_`region'=perwt
collapse (sum) person_`region', by(year migplac)
reshape wide person_`region', j(year) i(migplac)
save migrant_tech_wrks_state_`region'.dta, replace

use precollapse.dta, clear
keep if sex==2
* collapse 2: female full-time tech-oriented migrants by state (domestic)
gen fml_person_`region'=perwt
collapse (sum) fml_person_`region', by(year migplac)
reshape wide fml_person_`region', j(year) i(migplac)
save migrant_fml_tech_wrks_state_`region'.dta, replace

use precollapse.dta, clear
* collapse 3: full-time tech-oriented migrants by MSA
gen person_`region'=perwt
collapse (sum) person_`region', by(year migmet)
reshape wide person_`region', j(year) i(migmet)
save migrant_tech_wrks_met_`region'.dta, replace

use precollapse.dta, clear
keep if sex==2
* collapse 4: female full-time tech-oriented migrants by MSA
gen fml_person_`region'=perwt
collapse (sum) fml_person_`region', by(year migmet)
reshape wide fml_person_`region', j(year) i(migmet)
save migrant_fml_tech_wrks_met_`region'.dta, replace

}

use migrant_tech_wrks_state_austin.dta, clear
merge 1:1 migplac using migrant_fml_tech_wrks_state_austin.dta
drop _merge
export excel using "migrant_tech_workers_State", firstrow(variables) replace
erase migrant_tech_wrks_state_austin.dta
erase migrant_fml_tech_wrks_state_austin.dta

use migrant_tech_wrks_met_austin.dta, clear
merge 1:1 migmet using migrant_fml_tech_wrks_met_austin.dta
drop _merge
export excel using "migrant_tech_workers_MSA", firstrow(variables) replace
erase migrant_tech_wrks_met_austin.dta
erase migrant_fml_tech_wrks_met_austin.dta

