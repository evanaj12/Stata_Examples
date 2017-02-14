log using "C:\Users\eaj628\Documents\hwk2.smcl"
/*
	Assignment 2
	
	Evan Johnston
*/

set more off
cd "\\tsclient\Stat Apps Server\hwk2"

* prob 4
use "\\tsclient\Stat Apps Server\Data Sets- STATA\bertrandmull.dta", clear
 
* part 4.a
foreach i in female computerskills ofjobs yearsexp {
	regress `i' black, robust
}

* part 4.b
tab education black

* part 4.c
mean call if black
local d1 = _b[call]
* Note that this [Avg(call | not black)] is the baseline to compare against
mean call if !black
local d0 = _b[call]
* The calculated ATE:
display `d1'-`d0'
regress call black, robust
* Note that [Avg(call | black) - Avg(call | not black)] =~ Coef. Black

* part 4.d & e
regress call education ofjobs yearsexp computerskills female black, robust

log close
copy "C:\Users\eaj628\Documents\hwk2.smcl" "\\tsclient\Stat Apps Server\hwk2\hwk2.smcl"
translate hwk2.smcl hwk2.pdf
erase "C:\Users\eaj628\Documents\hwk2.smcl"
erase "\\tsclient\Stat Apps Server\hwk2\hwk2.smcl"
