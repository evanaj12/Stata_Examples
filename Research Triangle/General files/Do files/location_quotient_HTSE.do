*Calculates Location Quotient of self-employed HT industry for 3 regions
*Evan Johnston

* LQ=(ei/e)/(Ei/E)
* ei = self-employment in sector i in region
* e  = total self-employment in region
* Ei = self-employment in sector i in nation
* E  = total self-employment in nation

timer clear 1
timer on 1

*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt high_tech employed selfemp
	*drop if (employed!=1)
	drop if (selfemp!=1)
	
*Create people	
	gen person_80= perwt
	
*save data before collapse (national)
	save precollapse.dta, replace

*collapse to get sum of employed persons in US, 1980
	collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of total employment	
	local E = person_80[1]

*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech workers
	drop if (high_tech!=1)

*collapse to get sum of high-tech employed persons in US, 1980	
	collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local Ei = person_80[1]
	
*use precollapse data
	use precollapse.dta, clear
	
*only keep data on relevant regions
	drop if (austin!=1 & res_tri!=1 & svalley!=1)

*save data before collapse (regional)	
	save precollapse.dta, replace

*collapse to get sum of employed persons by region, 1980
	collapse (sum) person_80, by (austin res_tri svalley)
	
*create local variables of total employment for each region
	gsort -austin
	local eATX = person_80[1]
	gsort -res_tri
	local eRT = person_80[1]
	gsort -svalley
	local eSV = person_80[1]
	
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech workers
	drop if (high_tech!=1)
	
*collapse to get sum of high-tech workers by region, 1980
	collapse (sum) person_80, by (austin res_tri svalley)
	
*create local variables of high-tech employment for each region
	gsort -austin
	local eiATX = person_80[1]
	gsort -res_tri
	local eiRT = person_80[1]
	gsort -svalley
	local eiSV = person_80[1]

*create location quotient variable and calculate for each region
	gen LQ80 = 0
	replace LQ80 = (`eiATX' / `eATX') / (`Ei' / `E') if austin==1
	replace LQ80 = (`eiRT'/`eRT')/(`Ei'/`E') if res_tri==1
	replace LQ80 = (`eiSV'/`eSV')/(`Ei'/`E') if svalley==1
	
	keep LQ80 austin res_tri svalley
	save LQ80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt high_tech employed selfemp
	*drop if (employed!=1)
	drop if (selfemp!=1)
	gen person_90= perwt
save precollapse.dta, replace
	collapse (sum) person_90, by (year)
	drop if (year==.)
	local E = person_90[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_90, by (year)
	drop if (year==.)
	local Ei = person_90[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	collapse (sum) person_90, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_90[1]
	gsort -res_tri
	local eRT = person_90[1]
	gsort -svalley
	local eSV = person_90[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_90, by (austin res_tri svalley)
	gsort -austin
	local eiATX = person_90[1]
	gsort -res_tri
	local eiRT = person_90[1]
	gsort -svalley
	local eiSV = person_90[1]
	gen LQ90 = 0
	replace LQ90 = (`eiATX' / `eATX') / (`Ei' / `E') if austin==1
	replace LQ90 = (`eiRT'/`eRT')/(`Ei'/`E') if res_tri==1
	replace LQ90 = (`eiSV'/`eSV')/(`Ei'/`E') if svalley==1	
	keep LQ90 austin res_tri svalley
save LQ90.dta, replace

*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt high_tech employed selfemp
	*drop if (employed!=1)
	drop if (selfemp!=1)
	gen person_00= perwt
save precollapse.dta, replace
	collapse (sum) person_00, by (year)
	drop if (year==.)
	local E = person_00[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_00, by (year)
	drop if (year==.)
	local Ei = person_00[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	collapse (sum) person_00, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_00[1]
	gsort -res_tri
	local eRT = person_00[1]
	gsort -svalley
	local eSV = person_00[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_00, by (austin res_tri svalley)
	gsort -austin
	local eiATX = person_00[1]
	gsort -res_tri
	local eiRT = person_00[1]
	gsort -svalley
	local eiSV = person_00[1]
	gen LQ00 = 0
	replace LQ00 = (`eiATX' / `eATX') / (`Ei' / `E') if austin==1
	replace LQ00 = (`eiRT'/`eRT')/(`Ei'/`E') if res_tri==1
	replace LQ00 = (`eiSV'/`eSV')/(`Ei'/`E') if svalley==1	
	keep LQ00 austin res_tri svalley
save LQ00.dta, replace

*2009-5y
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt high_tech employed selfemp
	*drop if (employed!=1)
	drop if (selfemp!=1)
	gen person_09= perwt
save precollapse.dta, replace
	collapse (sum) person_09, by (year)
	drop if (year==.)
	local E = person_09[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_09, by (year)
	drop if (year==.)
	local Ei = person_09[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	collapse (sum) person_09, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_09[1]
	gsort -res_tri
	local eRT = person_09[1]
	gsort -svalley
	local eSV = person_09[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_09, by (austin res_tri svalley)
	gsort -austin
	local eiATX = person_09[1]
	gsort -res_tri
	local eiRT = person_09[1]
	gsort -svalley
	local eiSV = person_09[1]
	gen LQ09 = 0
	replace LQ09 = (`eiATX' / `eATX') / (`Ei' / `E') if austin==1
	replace LQ09 = (`eiRT'/`eRT')/(`Ei'/`E') if res_tri==1
	replace LQ09 = (`eiSV'/`eSV')/(`Ei'/`E') if svalley==1	
	keep LQ09 austin res_tri svalley
save LQ09.dta, replace
/*NOT YET AVAILABLE
*2014-5y
	use ipums_2014_1p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt high_tech employed selfemp
	*drop if (employed!=1)
	gen person_14= perwt
save precollapse.dta, replace
	collapse (sum) person_14, by (year)
	drop if (year==.)
	local E = person_14[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_14, by (year)
	drop if (year==.)
	local Ei = person_14[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	collapse (sum) person_14, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_14[1]
	gsort -res_tri
	local eRT = person_14[1]
	gsort -svalley
	local eSV = person_14[1]
use precollapse.dta, clear
	drop if (high_tech!=1)
	collapse (sum) person_14, by (austin res_tri svalley)
	gsort -austin
	local eiATX = person_14[1]
	gsort -res_tri
	local eiRT = person_14[1]
	gsort -svalley
	local eiSV = person_14[1]
	gen LQ14 = 0
	replace LQ14 = (`eiATX' / `eATX') / (`Ei' / `E') if austin==1
	replace LQ14 = (`eiRT'/`eRT')/(`Ei'/`E') if res_tri==1
	replace LQ14 = (`eiSV'/`eSV')/(`Ei'/`E') if svalley==1	
	keep LQ14 austin res_tri svalley
save LQ14.dta, replace
*/
use LQ80.dta, clear
merge 1:1 austin res_tri svalley using LQ90.dta
drop _merge
merge 1:1 austin res_tri svalley using LQ00.dta
drop _merge
merge 1:1 austin res_tri svalley using LQ09.dta
drop _merge
*merge 1:1 austin res_tri svalley using LQ14.dta
*drop _merge

save LQHTSE.dta, replace
export excel LQHTSE.xlsx, first (var) replace

timer off 1
timer list 1
