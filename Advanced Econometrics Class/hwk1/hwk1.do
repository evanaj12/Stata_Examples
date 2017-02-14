log using "C:\Users\eaj628\Documents\hwk1.smcl"
/*
	Assignment 1
	
	Evan Johnston
*/

set more off
cd "\\tsclient\Stat Apps Server\hwk1"

* prob 3
use "\\tsclient\Stat Apps Server\Data Sets- STATA\fertil2.dta", clear

gen heducmissing = heduc==.
replace heduc=0 if heducmissing

* part 3.a
regress children age agesq educ evermarr heduc heducmissing

* part 3.b
regress children age agesq educ heduc heducmissing if evermarr==1
regress children age agesq educ heduc heducmissing if evermarr==0

* part 3.c
regress children age agesq educ electric

* part 3.d
gen interact1 = electric*age*educ
regress children age agesq educ electric interact1

gen elec_partial = _b[electric]+_b[interact1]*age*educ
histogram elec_partial
graph export elec_partial_hist.png, replace
sum elec_partial

* prob 4
use "\\tsclient\Stat Apps Server\Data Sets- STATA\card.dta", clear
drop if _n>3000

* part 4.b
regress lwage educ exper expersq, robust

lincom 0.0897303+2*(-0.0024818)*exper
display 0.0897303+2*(-0.0024818)*10-1.645*0.0000352
display 0.0897303+2*(-0.0024818)*10+1.645*0.0000352

* part 4.c
regress lwage educ exper expersq if (_n<1001), robust 
regress lwage educ exper expersq if (1000<_n & _n<2001), robust 
regress lwage educ exper expersq if (_n>2000), robust 

* part 4.c.iii
display 1/3*(0.0062012+0.0065912+0.0063513)
display ( (0.0062012-.00638123)^2+(0.0065912-.00638123)^2+(0.0063513-.00638123)^2 )^(1/2)

* part 4.d.ii
bootstrap sig=e(rmse) rsq=e(r2) _b, reps(1000): regress lwage educ exper expersq
matrix list e(ci_normal)
matrix list e(ci_percentile)

log close
copy "C:\Users\eaj628\Documents\hwk1.smcl" "\\tsclient\Stat Apps Server\hwk1\hwk1.smcl"
translate hwk1.smcl hwk1.pdf
erase "C:\Users\eaj628\Documents\hwk1.smcl"
erase "\\tsclient\Stat Apps Server\hwk1\hwk1.smcl"
