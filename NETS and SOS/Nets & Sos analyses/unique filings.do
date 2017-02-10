/*
Determine number of unique filings in SoS data

Evan Johnston
*/

use SoSData, clear
sort creation_date entity_name
duplicates drop filing_number, force
*|234,835|
*NOTE: filing numbers uniquely identify a given entity
*		thus dropping duplicate filing numbers gives the same result
*		sorting before is still recommended

* keep only Austin MSA, for-profit firms (see notes)
keep if target_SoS == 1
*|214,876|

* keep if in "NETS interval"
gen year=year(creation_date)
keep if 1990<=year & year<=2012
*|142,203|
