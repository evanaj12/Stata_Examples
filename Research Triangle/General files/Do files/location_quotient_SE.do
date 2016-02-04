*Calculates Location Quotient for 3 regions for SE in main HT sectors
* 1980 - 2009-57 (until 2014-5y relased)
*Evan Johnston

* LQ=(ei/e)/(Ei/E)
* ei = employment in sector i in region
* e  = total employment in region
* Ei = employment in sector i in nation
* E  = total employment in nation

timer clear 1
timer on 1

*1980
	use ipums_1980_5p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt employed selfemp high_tech ind1990
	*drop if (employed!=1)
	drop if (high_tech!=1)
	drop if (selfemp!=1)
	
*Create people	
	gen person_80= perwt
	
*save data before collapse (national)
	save precollapse.dta, replace

*collapse to get sum of HT self-employed persons in US, 1980
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of total employment	
	local E = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Electrical machinery, equipment, and supplies, n.e.c (Semiconductors)
	drop if (ind1990!=342)

*collapse to get sum of high-tech employed persons in US, 1980	
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local E_342 = person_80[1]

***********************************	
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Computers and related equipment manufacturing
	drop if (ind1990!=322)

*collapse to get sum of high-tech employed persons in US, 1980	
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local E_322 = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Drugs (Pharmaceutical and medicine maufacturing)
	drop if (ind1990!=181)

*collapse to get sum of high-tech employed persons in US, 1980	
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local E_181 = person_80[1]

***********************************	
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Radio, TV, and communication equipment manufacturing
	drop if (ind1990!=341)

*collapse to get sum of high-tech employed persons in US, 1980	
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local E_341 = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Computer and data processing services
	drop if (ind1990!=732)

*collapse to get sum of high-tech employed persons in US, 1980	
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local E_732 = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Research, development, and testing services
	drop if (ind1990!=891)

*collapse to get sum of high-tech employed persons in US, 1980	
	capture collapse (sum) person_80, by (year)
	drop if (year==.)
	
*create local variable of high-tech employment
	local E_891 = person_80[1]

********************************************************************************
*use precollapse data
	use precollapse.dta, clear

*only keep data on relevant regions
	drop if (austin!=1 & res_tri!=1 & svalley!=1)

*save data before collapse (regional)	
	save precollapse.dta, replace

*collapse to get sum of employed persons by region, 1980
	capture collapse (sum) person_80, by (austin res_tri svalley)
	
*create local variables of total employment for each region
	gsort -austin
	local eATX = person_80[1]
	gsort -res_tri
	local eRT = person_80[1]
	gsort -svalley
	local eSV = person_80[1]
	
***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Electrical machinery, equipment, and supplies, n.e.c (Semiconductors)
	drop if (ind1990!=342)
	
*save precollapse data for this sector
	save precollapse1.dta, replace

	*austin
		drop if austin!=1
	
		*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (austin)
	
		*create local variables of high-tech employment for each region
		local eATX_342 = person_80[1]
	
*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*research triangle
		drop if res_tri!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (res_tri)
	
	*create local variables of high-tech employment for each region
		local eRT_342 = person_80[1]

*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*silicon valley
		drop if svalley!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (svalley)
	
	*create local variables of high-tech employment for each region
	local eSV_342 = person_80[1]
	
***********************************	
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Computers and related equipment manufacturing
	drop if (ind1990!=322)

*save precollapse data for this sector
	save precollapse1.dta, replace

	*austin
		drop if austin!=1
	
		*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (austin)
	
		*create local variables of high-tech employment for each region
		local eATX_322 = person_80[1]
	
*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*research triangle
		drop if res_tri!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (res_tri)
	
	*create local variables of high-tech employment for each region
		local eRT_322 = person_80[1]

*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*silicon valley
		drop if svalley!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (svalley)
	
	*create local variables of high-tech employment for each region
	local eSV_322 = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Drugs (Pharmaceutical and medicine maufacturing)
	drop if (ind1990!=181)

*save precollapse data for this sector
	save precollapse1.dta, replace

	*austin
		drop if austin!=1
	
		*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (austin)
	
		*create local variables of high-tech employment for each region
		local eATX_181 = person_80[1]
	
*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*research triangle
		drop if res_tri!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (res_tri)
	
	*create local variables of high-tech employment for each region
		local eRT_181 = person_80[1]

*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*silicon valley
		drop if svalley!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (svalley)
	
	*create local variables of high-tech employment for each region
	local eSV_181 = person_80[1]

***********************************	
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Radio, TV, and communication equipment manufacturing
	drop if (ind1990!=341)

*save precollapse data for this sector
	save precollapse1.dta, replace

	*austin
		drop if austin!=1
	
		*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (austin)
	
		*create local variables of high-tech employment for each region
		local eATX_341 = person_80[1]
	
*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*research triangle
		drop if res_tri!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (res_tri)
	
	*create local variables of high-tech employment for each region
		local eRT_341 = person_80[1]

*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*silicon valley
		drop if svalley!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (svalley)
	
	*create local variables of high-tech employment for each region
	local eSV_341 = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Computer and data processing services
	drop if (ind1990!=732)

*save precollapse data for this sector
	save precollapse1.dta, replace

	*austin
		drop if austin!=1
	
		*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (austin)
	
		*create local variables of high-tech employment for each region
		local eATX_732 = person_80[1]
	
*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*research triangle
		drop if res_tri!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (res_tri)
	
	*create local variables of high-tech employment for each region
		local eRT_732 = person_80[1]

*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*silicon valley
		drop if svalley!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (svalley)
	
	*create local variables of high-tech employment for each region
	local eSV_732 = person_80[1]

***********************************
*use precollapse data
	use precollapse.dta, clear
	
*keep only high-tech self-employed workers in:
*	Research, development, and testing services
	drop if (ind1990!=891)

*save precollapse data for this sector
	save precollapse1.dta, replace

	*austin
		drop if austin!=1
	
		*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (austin)
	
		*create local variables of high-tech employment for each region
		local eATX_891 = person_80[1]
	
*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*research triangle
		drop if res_tri!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (res_tri)
	
	*create local variables of high-tech employment for each region
		local eRT_891 = person_80[1]

*use sectorial precollapse data
	use precollapse1.dta, clear
		
	*silicon valley
		drop if svalley!=1
	
	*collapse to get sum of high-tech employed persons in US, 1980	
		capture collapse (sum) person_80, by (svalley)
	
	*create local variables of high-tech employment for each region
	local eSV_891 = person_80[1]

use precollapse, clear
*create location quotient variable and calculate for each region and sector
	gen LQ342_80 = 0
	replace LQ342_80 = (`eATX_342' / `eATX') / (`E_342' / `E') if austin==1
	replace LQ342_80 = (`eRT_342'/`eRT')/(`E_342'/`E') if res_tri==1
	replace LQ342_80 = (`eSV_342'/`eSV')/(`E_342'/`E') if svalley==1

	gen LQ322_80 = 0
	replace LQ322_80 = (`eATX_322' / `eATX') / (`E_322' / `E') if austin==1
	replace LQ322_80 = (`eRT_322'/`eRT')/(`E_322'/`E') if res_tri==1
	replace LQ322_80 = (`eSV_322'/`eSV')/(`E_322'/`E') if svalley==1
	
	gen LQ181_80 = 0
	replace LQ181_80 = (`eATX_181' / `eATX') / (`E_181' / `E') if austin==1
	replace LQ181_80 = (`eRT_181'/`eRT')/(`E_181'/`E') if res_tri==1
	replace LQ181_80 = (`eSV_181'/`eSV')/(`E_181'/`E') if svalley==1
	
	gen LQ341_80 = 0
	replace LQ341_80 = (`eATX_341' / `eATX') / (`E_341' / `E') if austin==1
	replace LQ341_80 = (`eRT_341'/`eRT')/(`E_341'/`E') if res_tri==1
	replace LQ341_80 = (`eSV_341'/`eSV')/(`E_341'/`E') if svalley==1
	
	gen LQ732_80 = 0
	replace LQ732_80 = (`eATX_732' / `eATX') / (`E_732' / `E') if austin==1
	replace LQ732_80 = (`eRT_732'/`eRT')/(`E_732'/`E') if res_tri==1
	replace LQ732_80 = (`eSV_732'/`eSV')/(`E_732'/`E') if svalley==1
	
	gen LQ891_80 = 0
	replace LQ891_80 = (`eATX_891' / `eATX') / (`E_891' / `E') if austin==1
	replace LQ891_80 = (`eRT_891'/`eRT')/(`E_891'/`E') if res_tri==1
	replace LQ891_80 = (`eSV_891'/`eSV')/(`E_891'/`E') if svalley==1
	collapse (mean) LQ342_80 LQ322_80 LQ181_80 LQ341_80 LQ732_80 LQ891_80, by (austin res_tri svalley)
	save LQ80.dta, replace

*1990
	use ipums_1990_5p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt employed selfemp high_tech ind1990
	*drop if (employed!=1)
	drop if (high_tech!=1)
	drop if (selfemp!=1)
	gen person_90= perwt
	save precollapse.dta, replace
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=342)
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E_342 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E_322 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E_181 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E_341 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E_732 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	capture collapse (sum) person_90, by (year)
	drop if (year==.)
	local E_891 = person_90[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	capture collapse (sum) person_90, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_90[1]
	gsort -res_tri
	local eRT = person_90[1]
	gsort -svalley
	local eSV = person_90[1]
use precollapse.dta, clear	
	drop if (ind1990!=342)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_90, by (austin)
		local eATX_342 = person_90[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_90, by (res_tri)
		local eRT_342 = person_90[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_90, by (svalley)
		local eSV_342 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_90, by (austin)
		local eATX_322 = person_90[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_90, by (res_tri)
		local eRT_322 = person_90[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_90, by (svalley)
		local eSV_322 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_90, by (austin)
		local eATX_181 = person_90[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_90, by (res_tri)
		local eRT_181 = person_90[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_90, by (svalley)
		local eSV_181 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_90, by (austin)
		local eATX_341 = person_90[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_90, by (res_tri)
		local eRT_341 = person_90[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_90, by (svalley)
		local eSV_341 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_90, by (austin)
		local eATX_732 = person_90[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_90, by (res_tri)
		local eRT_732 = person_90[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_90, by (svalley)
		local eSV_732 = person_90[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_90, by (austin)
		local eATX_891 = person_90[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_90, by (res_tri)
		local eRT_891 = person_90[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_90, by (svalley)
		local eSV_891 = person_90[1]
use precollapse, clear
	gen LQ342_90 = 0
	replace LQ342_90 = (`eATX_342' / `eATX') / (`E_342' / `E') if austin==1
	replace LQ342_90 = (`eRT_342'/`eRT')/(`E_342'/`E') if res_tri==1
	replace LQ342_90 = (`eSV_342'/`eSV')/(`E_342'/`E') if svalley==1
	gen LQ322_90 = 0
	replace LQ322_90 = (`eATX_322' / `eATX') / (`E_322' / `E') if austin==1
	replace LQ322_90 = (`eRT_322'/`eRT')/(`E_322'/`E') if res_tri==1
	replace LQ322_90 = (`eSV_322'/`eSV')/(`E_322'/`E') if svalley==1
	gen LQ181_90 = 0
	replace LQ181_90 = (`eATX_181' / `eATX') / (`E_181' / `E') if austin==1
	replace LQ181_90 = (`eRT_181'/`eRT')/(`E_181'/`E') if res_tri==1
	replace LQ181_90 = (`eSV_181'/`eSV')/(`E_181'/`E') if svalley==1
	gen LQ341_90 = 0
	replace LQ341_90 = (`eATX_341' / `eATX') / (`E_341' / `E') if austin==1
	replace LQ341_90 = (`eRT_341'/`eRT')/(`E_341'/`E') if res_tri==1
	replace LQ341_90 = (`eSV_341'/`eSV')/(`E_341'/`E') if svalley==1
	gen LQ732_90 = 0
	replace LQ732_90 = (`eATX_732' / `eATX') / (`E_732' / `E') if austin==1
	replace LQ732_90 = (`eRT_732'/`eRT')/(`E_732'/`E') if res_tri==1
	replace LQ732_90 = (`eSV_732'/`eSV')/(`E_732'/`E') if svalley==1
	gen LQ891_90 = 0
	replace LQ891_90 = (`eATX_891' / `eATX') / (`E_891' / `E') if austin==1
	replace LQ891_90 = (`eRT_891'/`eRT')/(`E_891'/`E') if res_tri==1
	replace LQ891_90 = (`eSV_891'/`eSV')/(`E_891'/`E') if svalley==1
	collapse (mean) LQ342_90 LQ322_90 LQ181_90 LQ341_90 LQ732_90 LQ891_90, by (austin res_tri svalley)
	save LQ90.dta, replace
	
*2000
	use ipums_2000_5p.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt employed selfemp high_tech ind1990
	*drop if (employed!=1)
	drop if (high_tech!=1)
	drop if (selfemp!=1)
	gen person_00= perwt
	save precollapse.dta, replace
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=342)
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E_342 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E_322 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E_181 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E_341 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E_732 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	capture collapse (sum) person_00, by (year)
	drop if (year==.)
	local E_891 = person_00[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	capture collapse (sum) person_00, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_00[1]
	gsort -res_tri
	local eRT = person_00[1]
	gsort -svalley
	local eSV = person_00[1]
use precollapse.dta, clear	
	drop if (ind1990!=342)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_00, by (austin)
		local eATX_342 = person_00[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_00, by (res_tri)
		local eRT_342 = person_00[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_00, by (svalley)
		local eSV_342 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_00, by (austin)
		local eATX_322 = person_00[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_00, by (res_tri)
		local eRT_322 = person_00[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_00, by (svalley)
		local eSV_322 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_00, by (austin)
		local eATX_181 = person_00[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_00, by (res_tri)
		local eRT_181 = person_00[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_00, by (svalley)
		local eSV_181 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_00, by (austin)
		local eATX_341 = person_00[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_00, by (res_tri)
		local eRT_341 = person_00[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_00, by (svalley)
		local eSV_341 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_00, by (austin)
		local eATX_732 = person_00[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_00, by (res_tri)
		local eRT_732 = person_00[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_00, by (svalley)
		local eSV_732 = person_00[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_00, by (austin)
		local eATX_891 = person_00[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_00, by (res_tri)
		local eRT_891 = person_00[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_00, by (svalley)
		local eSV_891 = person_00[1]
use precollapse, clear
	gen LQ342_00 = 0
	replace LQ342_00 = (`eATX_342' / `eATX') / (`E_342' / `E') if austin==1
	replace LQ342_00 = (`eRT_342'/`eRT')/(`E_342'/`E') if res_tri==1
	replace LQ342_00 = (`eSV_342'/`eSV')/(`E_342'/`E') if svalley==1
	gen LQ322_00 = 0
	replace LQ322_00 = (`eATX_322' / `eATX') / (`E_322' / `E') if austin==1
	replace LQ322_00 = (`eRT_322'/`eRT')/(`E_322'/`E') if res_tri==1
	replace LQ322_00 = (`eSV_322'/`eSV')/(`E_322'/`E') if svalley==1
	gen LQ181_00 = 0
	replace LQ181_00 = (`eATX_181' / `eATX') / (`E_181' / `E') if austin==1
	replace LQ181_00 = (`eRT_181'/`eRT')/(`E_181'/`E') if res_tri==1
	replace LQ181_00 = (`eSV_181'/`eSV')/(`E_181'/`E') if svalley==1
	gen LQ341_00 = 0
	replace LQ341_00 = (`eATX_341' / `eATX') / (`E_341' / `E') if austin==1
	replace LQ341_00 = (`eRT_341'/`eRT')/(`E_341'/`E') if res_tri==1
	replace LQ341_00 = (`eSV_341'/`eSV')/(`E_341'/`E') if svalley==1
	gen LQ732_00 = 0
	replace LQ732_00 = (`eATX_732' / `eATX') / (`E_732' / `E') if austin==1
	replace LQ732_00 = (`eRT_732'/`eRT')/(`E_732'/`E') if res_tri==1
	replace LQ732_00 = (`eSV_732'/`eSV')/(`E_732'/`E') if svalley==1
	gen LQ891_00 = 0
	replace LQ891_00 = (`eATX_891' / `eATX') / (`E_891' / `E') if austin==1
	replace LQ891_00 = (`eRT_891'/`eRT')/(`E_891'/`E') if res_tri==1
	replace LQ891_00 = (`eSV_891'/`eSV')/(`E_891'/`E') if svalley==1
	collapse (mean) LQ342_00 LQ322_00 LQ181_00 LQ341_00 LQ732_00 LQ891_00, by (austin res_tri svalley)
	save LQ00.dta, replace
	
*2009-5y
	use ipums_2009_5y.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt employed selfemp high_tech ind1990
	*drop if (employed!=1)
	drop if (high_tech!=1)
	drop if (selfemp!=1)
	gen person_09= perwt
	save precollapse.dta, replace
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=342)
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E_342 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E_322 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E_181 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E_341 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E_732 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	capture collapse (sum) person_09, by (year)
	drop if (year==.)
	local E_891 = person_09[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	capture collapse (sum) person_09, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_09[1]
	gsort -res_tri
	local eRT = person_09[1]
	gsort -svalley
	local eSV = person_09[1]
use precollapse.dta, clear	
	drop if (ind1990!=342)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_09, by (austin)
		local eATX_342 = person_09[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_09, by (res_tri)
		local eRT_342 = person_09[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_09, by (svalley)
		local eSV_342 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_09, by (austin)
		local eATX_322 = person_09[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_09, by (res_tri)
		local eRT_322 = person_09[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_09, by (svalley)
		local eSV_322 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_09, by (austin)
		local eATX_181 = person_09[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_09, by (res_tri)
		local eRT_181 = person_09[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_09, by (svalley)
		local eSV_181 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_09, by (austin)
		local eATX_341 = person_09[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_09, by (res_tri)
		local eRT_341 = person_09[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_09, by (svalley)
		local eSV_341 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_09, by (austin)
		local eATX_732 = person_09[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_09, by (res_tri)
		local eRT_732 = person_09[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_09, by (svalley)
		local eSV_732 = person_09[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_09, by (austin)
		local eATX_891 = person_09[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_09, by (res_tri)
		local eRT_891 = person_09[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_09, by (svalley)
		local eSV_891 = person_09[1]
use precollapse, clear
	gen LQ342_09 = 0
	replace LQ342_09 = (`eATX_342' / `eATX') / (`E_342' / `E') if austin==1
	replace LQ342_09 = (`eRT_342'/`eRT')/(`E_342'/`E') if res_tri==1
	replace LQ342_09 = (`eSV_342'/`eSV')/(`E_342'/`E') if svalley==1
	gen LQ322_09 = 0
	replace LQ322_09 = (`eATX_322' / `eATX') / (`E_322' / `E') if austin==1
	replace LQ322_09 = (`eRT_322'/`eRT')/(`E_322'/`E') if res_tri==1
	replace LQ322_09 = (`eSV_322'/`eSV')/(`E_322'/`E') if svalley==1
	gen LQ181_09 = 0
	replace LQ181_09 = (`eATX_181' / `eATX') / (`E_181' / `E') if austin==1
	replace LQ181_09 = (`eRT_181'/`eRT')/(`E_181'/`E') if res_tri==1
	replace LQ181_09 = (`eSV_181'/`eSV')/(`E_181'/`E') if svalley==1
	gen LQ341_09 = 0
	replace LQ341_09 = (`eATX_341' / `eATX') / (`E_341' / `E') if austin==1
	replace LQ341_09 = (`eRT_341'/`eRT')/(`E_341'/`E') if res_tri==1
	replace LQ341_09 = (`eSV_341'/`eSV')/(`E_341'/`E') if svalley==1
	gen LQ732_09 = 0
	replace LQ732_09 = (`eATX_732' / `eATX') / (`E_732' / `E') if austin==1
	replace LQ732_09 = (`eRT_732'/`eRT')/(`E_732'/`E') if res_tri==1
	replace LQ732_09 = (`eSV_732'/`eSV')/(`E_732'/`E') if svalley==1
	gen LQ891_09 = 0
	replace LQ891_09 = (`eATX_891' / `eATX') / (`E_891' / `E') if austin==1
	replace LQ891_09 = (`eRT_891'/`eRT')/(`E_891'/`E') if res_tri==1
	replace LQ891_09 = (`eSV_891'/`eSV')/(`E_891'/`E') if svalley==1
	collapse (mean) LQ342_09 LQ322_09 LQ181_09 LQ341_09 LQ732_09 LQ891_09, by (austin res_tri svalley)
	save LQ09.dta, replace

/* DATA NOT YET AVAILABLE
*2014-5y
	use ipums_2014_5y.dta, clear
	gen ind1990_code = ind1990
	keep year austin res_tri svalley perwt employed selfemp high_tech ind1990
	*drop if (employed!=1)
	drop if (high_tech!=1)
	drop if (selfemp!=1)
	gen person_14= perwt
	save precollapse.dta, replace
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=342)
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E_342 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E_322 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E_181 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E_341 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E_732 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	capture collapse (sum) person_14, by (year)
	drop if (year==.)
	local E_891 = person_14[1]
use precollapse.dta, clear
	drop if (austin!=1 & res_tri!=1 & svalley!=1)
save precollapse.dta, replace
	capture collapse (sum) person_14, by (austin res_tri svalley)
	gsort -austin
	local eATX = person_14[1]
	gsort -res_tri
	local eRT = person_14[1]
	gsort -svalley
	local eSV = person_14[1]
use precollapse.dta, clear	
	drop if (ind1990!=342)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_14, by (austin)
		local eATX_342 = person_14[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_14, by (res_tri)
		local eRT_342 = person_14[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_14, by (svalley)
		local eSV_342 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=322)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_14, by (austin)
		local eATX_322 = person_14[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_14, by (res_tri)
		local eRT_322 = person_14[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_14, by (svalley)
		local eSV_322 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=181)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_14, by (austin)
		local eATX_181 = person_14[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_14, by (res_tri)
		local eRT_181 = person_14[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_14, by (svalley)
		local eSV_181 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=341)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_14, by (austin)
		local eATX_341 = person_14[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_14, by (res_tri)
		local eRT_341 = person_14[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_14, by (svalley)
		local eSV_341 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=732)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_14, by (austin)
		local eATX_732 = person_14[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_14, by (res_tri)
		local eRT_732 = person_14[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_14, by (svalley)
		local eSV_732 = person_14[1]
use precollapse.dta, clear
	drop if (ind1990!=891)
	save precollapse1.dta, replace
		drop if austin!=1
		capture collapse (sum) person_14, by (austin)
		local eATX_891 = person_14[1]
	use precollapse1.dta, clear
		drop if res_tri!=1
		capture collapse (sum) person_14, by (res_tri)
		local eRT_891 = person_14[1]
	use precollapse1.dta, clear
		drop if svalley!=1
		capture collapse (sum) person_14, by (svalley)
		local eSV_891 = person_14[1]
use precollapse, clear
	gen LQ342_14 = 0
	replace LQ342_14 = (`eATX_342' / `eATX') / (`E_342' / `E') if austin==1
	replace LQ342_14 = (`eRT_342'/`eRT')/(`E_342'/`E') if res_tri==1
	replace LQ342_14 = (`eSV_342'/`eSV')/(`E_342'/`E') if svalley==1
	gen LQ322_14 = 0
	replace LQ322_14 = (`eATX_322' / `eATX') / (`E_322' / `E') if austin==1
	replace LQ322_14 = (`eRT_322'/`eRT')/(`E_322'/`E') if res_tri==1
	replace LQ322_14 = (`eSV_322'/`eSV')/(`E_322'/`E') if svalley==1
	gen LQ181_14 = 0
	replace LQ181_14 = (`eATX_181' / `eATX') / (`E_181' / `E') if austin==1
	replace LQ181_14 = (`eRT_181'/`eRT')/(`E_181'/`E') if res_tri==1
	replace LQ181_14 = (`eSV_181'/`eSV')/(`E_181'/`E') if svalley==1
	gen LQ341_14 = 0
	replace LQ341_14 = (`eATX_341' / `eATX') / (`E_341' / `E') if austin==1
	replace LQ341_14 = (`eRT_341'/`eRT')/(`E_341'/`E') if res_tri==1
	replace LQ341_14 = (`eSV_341'/`eSV')/(`E_341'/`E') if svalley==1
	gen LQ732_14 = 0
	replace LQ732_14 = (`eATX_732' / `eATX') / (`E_732' / `E') if austin==1
	replace LQ732_14 = (`eRT_732'/`eRT')/(`E_732'/`E') if res_tri==1
	replace LQ732_14 = (`eSV_732'/`eSV')/(`E_732'/`E') if svalley==1
	gen LQ891_14 = 0
	replace LQ891_14 = (`eATX_891' / `eATX') / (`E_891' / `E') if austin==1
	replace LQ891_14 = (`eRT_891'/`eRT')/(`E_891'/`E') if res_tri==1
	replace LQ891_14 = (`eSV_891'/`eSV')/(`E_891'/`E') if svalley==1
	collapse (mean) LQ342_14 LQ322_14 LQ181_14 LQ341_14 LQ732_14 LQ891_14, by (austin res_tri svalley)
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

save LQSEsectors.dta, replace
export excel LQSEsectors.xlsx, first (var) replace

timer off 1
timer list 1
