log using "C:\Users\eaj628\Documents\hwk6.smcl"
/*
	Assignment 6
	
	Evan Johnston
*/

set more off
cd "\\tsclient\Stat Apps Server\hwk6"

* problem 1
use "\\tsclient\Stat Apps Server\Data Sets- STATA\fringe.dta", clear
**************************************************

* part 1.a
gen pen_bin=(pension==0)
tab pen_bin
sum pension if pen_bin==0

* part 1.b
tobit pension exper age tenure educ depends married white male, ll(0)

* part 1.c
display _b[white]+_b[male]

* part 1.d
tobit pension exper age tenure educ depends married white male union, ll(0)

* part 1.e
tobit peratio exper age tenure educ depends married white male union, ll(0)
	
* problem 4
use "\\tsclient\Stat Apps Server\Data Sets- STATA\vote2.dta", clear
**************************************************

* part 4.a
regress cvote clinexp clchexp cincshr, robust

* part 4.b
test clinexp=clchexp=0

* part 4.c
regress cvote cincshr, robust

* part 4.d
regress cvote cincshr, cluster(state) robust

* part 4.e
regress cvote cincshr if rptchall, robust


* problem 5
use "\\tsclient\Stat Apps Server\Data Sets- STATA\married_bmi_sample.dta", clear
xtset hhid male
**************************************************

* part 5.a
regress bmi male educ age agesq smoke logfaminc withkid, robust

* part 5.b
predict uhat, resid
gen uhat_sps = uhat[_n-1] if hhid==hhid[_n-1]
pwcorr uhat uhat_sps, sig star(0.01)

* part 5.c
regress bmi male educ age agesq smoke logfaminc withkid, cluster (hhid) robust

* part 5.d

***** FD estimation: *****
*regress D.(bmi male educ age agesq smoke logfaminc withkid), cluster (hhid) robust

***** FE estimation: *****
xtreg bmi male educ age agesq smoke logfaminc withkid, fe robust

* part 5.e
xtreg obese male educ age agesq smoke logfaminc withkid, fe robust

log close
copy "C:\Users\eaj628\Documents\hwk6.smcl" "\\tsclient\Stat Apps Server\hwk6\hwk6.smcl"
translate hwk6.smcl hwk6.pdf
erase "C:\Users\eaj628\Documents\hwk6.smcl"
erase "\\tsclient\Stat Apps Server\hwk6\hwk6.smcl"
