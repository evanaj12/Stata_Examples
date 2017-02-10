/*
imports zipcode list for Austin MSA

Evan Johnston
*/

* import list of Austin MSA Zip codes
*	see AustinZips folder for details on this selection of codes
import excel using AustinMSAZips, first clear

* rename the variable, force to string to match with other datasets, and save
rename AustinMSAZips entity_zip
tostring entity_zip, replace
save austin_zips.dta, replace
