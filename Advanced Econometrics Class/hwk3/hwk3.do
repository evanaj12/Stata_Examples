log using "C:\Users\eaj628\Documents\hwk3.smcl"
/*
	Assignment 3
	
	Evan Johnston
*/

set more off
cd "\\tsclient\Stat Apps Server\hwk3"

* prob 4
use "\\tsclient\Stat Apps Server\Data Sets- STATA\401ksubs.dta", clear
 
* part 4.a
regress pira p401k inc incsq age agesq, robust
****************************************
* part 4.d
* first stage
regress p401k e401k, robust
predict p401k_hat
****************************************
* part 4.e
* second stage
regress pira p401k_hat inc incsq age agesq, robust
* iv command version
ivregress 2sls pira (p401k=e401k) inc incsq age agesq, robust

********************************************************************************
* prob 5
use "\\tsclient\Stat Apps Server\Data Sets- STATA\voucher.dta", clear

* part a
tab choiceyrs selectyrs
****************************************
* part b
regress choiceyrs selectyrs, robust
****************************************
* part c
regress mnce choiceyrs, robust
regress mnce choiceyrs black hispanic female, robust
****************************************
* part e
ivregress 2sls mnce (choiceyrs=selectyrs) black hispanic female, robust
****************************************
* part f
regress mnce choiceyrs black hispanic female mnce90, robust
ivregress 2sls mnce (choiceyrs=selectyrs) black hispanic female mnce90, robust
****************************************
* part h
ivregress 2sls mnce (choiceyrs1 choiceyrs2 choiceyrs3 choiceyrs4 = ///
	selectyrs1 selectyrs2 selectyrs3 selectyrs4) black hispanic female, robust
****************************************
* part i
ivregress 2sls mnce (choiceyrs = selectyrs1 selectyrs2 selectyrs3 selectyrs4) ///
	black hispanic female, robust
	
* regression from d/e
ivregress 2sls mnce (choiceyrs=selectyrs) black hispanic female, robust
****************************************
ivregress gmm mnce (choiceyrs = selectyrs1 selectyrs2 selectyrs3 selectyrs4) ///
	black hispanic female, robust
estat overid
****************************************
* part j
regress mnce selectyrs black hispanic female, robust
* regression from c
regress mnce choiceyrs black hispanic female, robust

log close
copy "C:\Users\eaj628\Documents\hwk3.smcl" "\\tsclient\Stat Apps Server\hwk3\hwk3.smcl"
translate hwk3.smcl hwk3.pdf
erase "C:\Users\eaj628\Documents\hwk3.smcl"
erase "\\tsclient\Stat Apps Server\hwk3\hwk3.smcl"
