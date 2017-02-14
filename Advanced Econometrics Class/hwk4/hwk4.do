log using "C:\Users\eaj628\Documents\hwk4.smcl"
/*
	Assignment 4
	
	Evan Johnston
*/

set more off
cd "\\tsclient\Stat Apps Server\hwk4"

use "\\tsclient\Stat Apps Server\Data Sets- STATA\lee-moretti-butler.dta", clear

* prob 1
graph twoway scatter demvoteshare lagdemvoteshare, title("Prob 1")
graph export scatter1.png, replace

* prob 2 and 3
matrix DiffDemVoteShares = I(5)
matrix rownames DiffDemVoteShares = E_DemVS_Lag1 N_Lag1_h E_DemVS_Lag0 N_Lag0_h Difference
matrix colnames DiffDemVoteShares = All h=0.2 h=0.1 h=0.05 h=0.01
gen h = 1
foreach i in 1 2 3 4 5 {
	replace h = 0.2 if `i'==2
	replace h = 0.1 if `i'==3
	replace h = 0.05 if `i'==4
	replace h = 0.01 if `i'==5
	
	sum demvoteshare if (lagdemocrat==1 & abs(lagdemvoteshare-0.5)<h)
	matrix DiffDemVoteShares[1,`i'] = r(mean)
	matrix DiffDemVoteShares[2,`i'] = r(N)
	sum demvoteshare if (lagdemocrat==0 & abs(lagdemvoteshare-0.5)<h)
	matrix DiffDemVoteShares[3,`i'] = r(mean)
	matrix DiffDemVoteShares[4,`i'] = r(N)
	matrix DiffDemVoteShares[5,`i'] = DiffDemVoteShares[1,`i'] - DiffDemVoteShares[3,`i'] 
}
matrix list DiffDemVoteShares

* prob 4
foreach i in 4 5 {
	replace h = 0.05 if `i'==4
	replace h = 0.01 if `i'==5
	
	regress demvoteshare lagdemocrat if abs(lagdemvoteshare-0.5)<h, robust
	display "Naive estimate from 3: " DiffDemVoteShares[5,`i']
}

* prob 5 and 6
gen lagdemVS_diff = lagdemvoteshare-0.5
gen interact1 = lagdemocrat*lagdemVS_diff
gen lagdemVS_diff_sqr = lagdemVS_diff^2
gen interact2 = lagdemocrat*lagdemVS_diff^2

* part a
regress demvoteshare lagdemocrat lagdemVS_diff, robust
predict demVS_a
graph twoway scatter demVS_a lagdemvoteshare, title("Prob 5.a") ytitle("Fitted Values demVS_a")
graph export fitted_a.png, replace

*part b
regress demvoteshare lagdemocrat lagdemVS_diff interact1, robust
predict demVS_b
graph twoway scatter demVS_b lagdemvoteshare, title("Prob 5.b") ytitle("Fitted Values demVS_b")
graph export fitted_b.png, replace

* part c
regress demvoteshare lagdemocrat lagdemVS_diff lagdemVS_diff_sqr, robust
predict demVS_c
graph twoway scatter demVS_c lagdemvoteshare, title("Prob 5.c") ytitle("Fitted Values demVS_c")
graph export fitted_c.png, replace

* part d
regress demvoteshare lagdemocrat lagdemVS_diff lagdemVS_diff_sqr ///
	interact1 interact2, robust
predict demVS_d
graph twoway scatter demVS_d lagdemvoteshare, title("Prob 5.d = 6") ytitle("Fitted Values demVS_d")
graph export fitted_d.png, replace

* part e
regress demvoteshare lagdemocrat lagdemVS_diff lagdemVS_diff_sqr ///
	interact1 interact2 year pcturban pctblack pcthighschl, robust
predict demVS_e
graph twoway scatter demVS_e lagdemvoteshare, title("Prob 5.e") ytitle("Fitted Values demVS_e")
graph export fitted_e.png, replace

* prob 7
regress democrat lagdemocrat lagdemVS_diff lagdemVS_diff_sqr ///
	interact1 interact2, robust
predict demVS_7
graph twoway scatter demVS_7 lagdemvoteshare, title("Prob 7") ytitle("Fitted Values demVS_7")
graph export fitted_7.png, replace
summarize demVS_7

* prob 8 
foreach i in 1 2 3 4 5 {
	local rstar = 0.41+`i'*0.03
	replace lagdemVS_diff = lagdemvoteshare - `rstar'
	display "Rstar = " `rstar'
	regress demvoteshare lagdemocrat lagdemVS_diff, robust
	predict demVS_Rstar_`i'
}

log close
copy "C:\Users\eaj628\Documents\hwk4.smcl" "\\tsclient\Stat Apps Server\hwk4\hwk4.smcl"
translate hwk4.smcl hwk4.pdf
erase "C:\Users\eaj628\Documents\hwk4.smcl"
erase "\\tsclient\Stat Apps Server\hwk4\hwk4.smcl"
