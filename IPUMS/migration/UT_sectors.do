/* Shows placement of UT workers in the three sectors by year

Evan Johnston
*/
set more off

foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	use ipums_`year'.dta, clear
	keep if austin & fulltime
	display "Year: " "`year'"
	display "Full-time Austin workers in ind1990 850: Colleges and Universities by sector"
	tab sector if ind1990==850 [fw=perwt]
}
