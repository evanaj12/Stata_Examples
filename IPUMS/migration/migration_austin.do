/* MIGRATION to Austin: USA 1980 to 2014
Evan Johnston

files needed to run this do file:
	migration_data.dta		dataset of migration variables and information
*/

set more off
timer clear 1
timer on 1

foreach region in austin res_tri {

* use migration data
use migration_data.dta, clear

* only keep full-time tech-oriented workers (not self-employed) living in Austin who moved to Austin in:
*	the previous year (ACS samples)
*	five years ago (Census samples)
keep if fulltime==1
drop if selfemp==1
keep if `region'==1
keep if tech_oriented==1
drop if (migrate1<2 | migrate5<2)

* puts migplac1 and migplac5 into single variable
gen migplac=0
replace migplac=migplac1 if year>2000
replace migplac=migplac5 if year<2001
label values migplac MIGPLAC1

* remove international migrants
drop if migplac>56

* puts migpuma1 and migpuma5 into single variable
gen migpuma=0
replace migpuma=migpuma1 if year>2000
replace migpuma=migpuma5 if year<2001
label values migpuma MIGPUMA1

*create silicon valley migrants
gen svalley_migrant = 0
replace svalley_migrant = 1 if migplac==6 & ///
	( (year==1980 & inlist(migcogrp, 15, 31) ) | ///
	  (year==1990 & inlist(migpuma, 22, 34) ) | ///
	  (year==2000 & inlist(migpuma, 23, 24, 27, 28) ) | ///
	(year>2000 & inlist(migpuma, 2300, 2400, 2700, 2800) ) )

* weight the observations
gen person_`region'=perwt

save precollapse.dta, replace

* collapse 1: full-time tech-oriented migrants by state (domestic)
collapse (sum) person_`region', by(year migplac)
reshape wide person_`region', j(year) i(migplac)
save migrant_tech_wrks_state_`region'.dta, replace

use precollapse.dta, clear
keep if svalley_migrant
* collapse 2: full-time tech-oriented migrants by SV
collapse (sum) person_`region', by(year)
save migrant_tech_wrks_SV_`region'.dta, replace

use precollapse.dta, clear
keep if year>2000
drop if migplac==48 & "`region'"=="austin"
drop if migplac==37 & "`region'"=="res_tri"
* collapse 3: full-time tech-oriented migrants by MSA (2009 and 2014 -5y only)
collapse (sum) person_`region', by(year migmet1)
reshape wide person_`region', j(year) i(migmet1)
save migrant_tech_wrks_met213_`region'.dta, replace

}
use migrant_tech_wrks_state_austin.dta, clear
merge 1:1 migplac using migrant_tech_wrks_state_res_tri.dta
drop _merge
export excel using "migrant_tech_workers_State", firstrow(variables) replace
erase migrant_tech_wrks_state_austin.dta
erase migrant_tech_wrks_state_res_tri.dta

use migrant_tech_wrks_SV_austin.dta, clear
merge 1:1 year using migrant_tech_wrks_SV_res_tri.dta
drop _merge
sort year
export excel using "migrant_tech_workers_SV", firstrow(variables) replace
erase migrant_tech_wrks_SV_austin.dta
erase migrant_tech_wrks_SV_res_tri.dta

use migrant_tech_wrks_met213_austin.dta, clear
merge 1:1 migmet1 using migrant_tech_wrks_met213_res_tri.dta
drop _merge
sort migmet1
export excel using "migrant_tech_wrks_met213", firstrow(variables) replace
erase migrant_tech_wrks_met213_austin.dta
erase migrant_tech_wrks_met213_res_tri.dta

/* collapse 2: same as collapse 1, restricted to TEXAS migrants, by PUMA
* NA: note: for 1980 we must use county group so two collapses are needed
use precollapse.dta, clear
keep if texas_migrant >0
collapse (sum) person, by(year texas_migrant)
reshape wide person, j(year) i(texas_migrant)
export excel using "texas_migrant_tech_workers", firstrow(variables) replace

/*
use precollapse.dta, clear
keep if migplac==48
collapse (sum) person, by(year migcogrp)
reshape wide person, j(year) i(migcogrp)


/*
*categorize texas migrants
gen texas_migrant = 0
replace texas_migrant = 1 if migplac==48

* College Station-Bryan MSA: Brazos, Burleson, Robertson
replace texas_migrant = 2 if ( (migplac==48) & ///
	(	(year==1980 & migcogrp==050) | ///
		(year==1990 & inlist(migpuma, 07100, 05500)) | ///
		(inlist(year, 2000, 2009) & inlist(migpuma, 04000, 03900)) | ///
		(year==2014 & multyear<2012 & inlist(migpuma, 04000, 03900)) | ///
		(year==2014 & multyear>2011 & inlist(migpuma, 03601, 03602, 03700, ///
			04900, 05000, 05100)) ) )

* DFW MSA: Dallas, Tarrant, Collin, Denton, Johnson, Ellis, Parker, Kaufman, Hunt, 
	* Rockwall, Wise, Delta, Grayson, Henderson, Hood, Somervell, Cooke, Fannin, Palo Pinto 
	* NOTES: Palo Pinto removed because of significant noise aggregation.
	*	MIGPUMA=/=PUMA. 
replace texas_migrant = 3 if ( (migplac==48) & ///
	(	(year==1980 & inlist(migcogrp, 018, 021, 022, 023, 024, 025, 007, 008, ///
			011, 049)) | ///
		(year==1990 & inlist(migpuma, 02903, 02904, 02102, 02103, 02104, ///
			02300, 02400, 02201, 02202, 01800, 01500, 00700, 00800, 01400, ///
			01600, 00600, )) | ///
		(inlist(year, 2000, 2009) & inlist(migpuma, 02100, 02200, 02300, 02400, ///
			02500, 02600, 02000, 02700, 00900, 00600, 01000, 00800, 01800)) | ///
		(year==2014 & multyear<2012 & inlist(migpuma, 02100, 02200, 02300, 02400, ///
			02500, 02600, 02000, 02700, 00900, 00600, 01000, 00800, 01800)) | ///
		(year==2014 & multyear>2011 & inlist(migpuma, 00600, 00800, 00900, ///
			01000, 01100, 01300, 01400, 01800, 01900, 02000, 02102, 02200, ///
			02300, 02400, 02500, 02600, 03700)) ) )
/*
	DALLAS MSA PUMAS: 02301, 02302, 02307, 02308, ///
			02305, 02306, 02309, 02310, 02314, 02303, 02304, 02312, 02311, ///
			02313, 02315, 02501, 02502, 02505, 02507, 02503, 02506, 02508, ///
			02504, 02509, 02510, 02511, 02101, 02102, 02103, 02104, 02201, ///
			02202, 02600, 02400, 02000, 00900, 00600, 01000, 00800, 01800, ///
			02700
*/
/*(migplac==48 & ///
  (	(year==1980 & inlist(migcogrp, 058, 059, 060, 061, 062, 063)) | ///
	(year==1990 & inlist(migpuma, 06601, 06602, 06603, 06604, 06605, ///
		06606, 06607, 06608, 06609, 06610, 06611, 06612, 06613, 06614, 06615)) | ///
	(year==1990 & inlist(migpuma, 06700, 06800, 06901, 06902, 06903, 06904, ///
		06905, 06906, 06907, 06908)) | ///
	(inlist(year, 2000, 2009) & (04500<migpuma & migpuma<04903)) | ///
	(multyear<2012 & (04500<migpuma & migpuma<04903)) | ///
	(multyear>2011 & (
HOUSTON-MSA
	inlist(migpuma, 04501, 04502, 04503, 04601, ///
		04602, 04603, 04604, 04605, 04606, 04607, 04608, 04609, 04610) | ///
	(inlist(year, 2000, 2009) & inlist(migpuma, 04611, 04612, 04613, 04614, ///
		04615, 04616, 04617, 04618, 04619, 04620, 04621, 04622, 04623, 04624, 04625, 04701, 04702, 
		04902, 04901, 04802, 04801

	label define texas_migrant_label ///
		1 "Houston MSA (3360)" ///
	label values texas_migrant texas_migrant_label
*/
	label define texas_migrant_label ///
		0 "Non-Texan Migrant" ///
		1 "Texan Migrant" ///
		2 "College Station-Bryan Migrant" ///
		3 "Dallas Fort-Worth Migrant" 
	label values texas_migrant texas_migrant_label
*/
