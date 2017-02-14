log using "C:\Users\eaj628\Documents\hwk5.smcl"
/*
	Assignment 5
	
	Evan Johnston
*/

set more off
cd "\\tsclient\Stat Apps Server\hwk5"

* problem 1
use "\\tsclient\Stat Apps Server\Data Sets- STATA\kielmc.dta", clear

* part 1.b
regress lprice ldist y81 y81ldist, robust

* part 1.c
regress lprice ldist y81 y81ldist age agesq rooms baths lintst lland larea, robust

* problem 2
use "\\tsclient\Stat Apps Server\Data Sets- STATA\children_sample.dta", clear
keep if white & male

* part 2.a
tabstat bmi, statistics(mean p10 p25 p50 p75 p90)

* part 2.b
histogram bmi, title("Prob 2.b Histogram of BMI") xtitle("BMI")
graph export bmi_hist.png, replace

* part 2.c
regress bmi educ age mombmi dadbmi, robust

* part 2.d
sqreg bmi educ age mombmi dadbmi, reps(500)
display _b[mombmi]+_b[dadbmi]
display _b[mombmi]+_b[dadbmi] - 1.645*(_se[mombmi]^2+_se[dadbmi]^2)^(1/2)
display _b[mombmi]+_b[dadbmi] + 1.645*(_se[mombmi]^2+_se[dadbmi]^2)^(1/2)

test [q50]_b[mombmi]+[q50]_b[dadbmi]=0
sqreg bmi educ age mombmi dadbmi, reps(500)

* part 2.e
sqreg bmi educ age mombmi dadbmi, q(0.1 0.25 0.5 0.75 0.9) reps(500)

test [q10]_b[age]=[q25]_b[age]=[q50]_b[age]=[q75]_b[age]=[q90]_b[age]

test [q50=q90]:mombmi dadbmi

predict q10_hat, eq(#1)
predict q90_hat, eq(#5)
sum q10_hat q90_hat

* problem 4
use "\\tsclient\Stat Apps Server\Data Sets- STATA\loanapp.dta", clear

* part 4.a
regress approve white, robust
predict phat_lpm
probit approve white
predictnl phat_prob=normal(xb(#1))
sum phat_lpm phat_prob if white
sum phat_lpm phat_prob if !white

* part 4.b
regress approve white hrat obrat loanprc unem male married dep sch cosign ///
	chist pubrec mortlat1 mortlat2 vr, robust
probit approve white hrat obrat loanprc unem male married dep sch cosign ///
	chist pubrec mortlat1 mortlat2 vr
dprobit approve white hrat obrat loanprc unem male married dep sch cosign ///
	chist pubrec mortlat1 mortlat2 vr
margins, dydx(white obrat)
margins, at(obrat=(10 20 30 40 50))
marginsplot
graph export obrat_margins.png, replace

margins, dydx(obrat) at(obrat=(10 20 30 40 50))
marginsplot
graph export obrat_APEs.png, replace

* part 4.c
probit approve white hrat obrat loanprc unem male married dep sch cosign ///
	chist pubrec mortlat1 mortlat2 vr
estimates store A
test _b[hrat]=_b[male]=_b[dep]=_b[sch]=_b[cosign]=_b[mortlat1]=_b[mortlat2]=0

* make sample sizes equal
keep if hrat!=. & male!=. & dep!=. & sch!=. & cosign!=. & mortlat1!=. & mortlat2!=.
probit approve white obrat loanprc unem married chist pubrec vr
estimates store B
lrtest A
	
log close
copy "C:\Users\eaj628\Documents\hwk5.smcl" "\\tsclient\Stat Apps Server\hwk5\hwk5.smcl"
translate hwk5.smcl hwk5.pdf
erase "C:\Users\eaj628\Documents\hwk5.smcl"
erase "\\tsclient\Stat Apps Server\hwk5\hwk5.smcl"
