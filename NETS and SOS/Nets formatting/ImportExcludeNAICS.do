/*
imports list of excluded NAICS codes

Evan Johnston
*/

import excel using "ExcludeNAICS.xlsx", firstrow clear
tostring ExcludeNAICS, replace force
sort ExcludeNAICS
duplicates drop ExcludeNAICS, force
drop if ExcludeNAICS=="."

save ExcludeNAICS.dta, replace
