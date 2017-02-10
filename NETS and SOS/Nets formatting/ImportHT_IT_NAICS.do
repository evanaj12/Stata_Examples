/*
imports HT NAICS list from xlsx file

Evan Johnston
*/

import excel using "HTNAICS.xlsx", firstrow clear
tostring HTNAICS, replace force
sort HTNAICS
duplicates drop HTNAICS, force

save HTNAICS.dta, replace
