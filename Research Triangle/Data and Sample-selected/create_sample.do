* EVAN JOHNSTON: runtime approx. 33.178 mins 

/*
Uses the initial IPUMS extract to create samples and variables for all analyses.
Extract samples include:
	1980 US Census (5%)
	1990 US Census (5%)
	2000 US Census (5%)
	2005 American Community Survey (1%)
	2013 American Community Survey (1%)
Relevant variables include:
	year		year of observation
	statefip	state code
	metarea/d	metropolitan area/detailed
	met2013		metropolitan area 2013 OMB definition
	gq			group quarters status
	perwt		person weight
	sex			gender
	age			age
	race/d		racial/ethnic group/detailed
	hispan/d	hispanic origin/detailed
	educ/d		education level/detailed
	occ			occupation group (year specific)
	ind			industry group (year specific)
	ind1990		industry group 1990 basis (constant for 1950-2013)
	indnaics	NAICS classification
	classwrk/d	class of worker/detailed
	wkswork1	weeks worked in the last year
	wkswork2	weeks worked in the last year (binned version)
	uhrswork	usual hours worked per week
	incwage		annual wage and salary income
	county		county of residence (used with statefip)
	puma		IPUMS geographical variable (1990-2013 based on most recent
		census' geographical delineations)
	conspuma	consistent puma variable (1980-2000)
	cpuma0010	consistent puma variable (2000-2014)
	cntygrp98	county group geographical variable (1980)
Created variables include:
	austin			Binary Austin MSA indicator
	svalley			Binary Silicon Valley indicator
	bay_area		Binary Bay Area indicator
	res_tri			Binary Research Triangle indicator
	selfemp			Binary indicator of self-employment (removed for wage calculations)
	selfemp_inc		Binary indicator of incorporated self-employment, used as entrepreneurial proxy
	high_tech		Binary indicator of high-tech industries, Hecker (2005)
	high_tech_CoC	High-tech industry groups, Austin Chamber of Commerce
	sector			Three working sectors: government, high tech, non-high tech
	race_group		Five racial/ethnic groups
	school			Four education levels
	college			Three levels describing level of college completion
	occ1990dd		Occupation categories created by Dorn (2013?)
	occ8cat			Eight occupation categories based from Dorn's work
	occ4cat			Four occupation categories aggregated from the above eight
	hrwagelimit		Hourly wage limit for each year based on top-coded incwage
						following Dorn's example
Files needed:
	original extract file	ipums_1980_90_00_05_13_5p5p5p1p1p_initial.dta
	Dorn's occ crosswalks	occ1980_occ1990dd.dta
							occ1990_occ1990dd.dta
							occ2000_occ1990dd.dta
							occ2005_occ1990dd.dta
	Do file to translate 2013 occ codes to 2005 occ codes
		occ2013_occ2005.do
	Do file to create the 8 occ1990 groups
		subfile_occ1990dd_occgroups_8cat.do

After this file has been run, any figure-producing .do files from:
	1) High-Tech Growth and Employment-Wage Polarization in Austin
		(Elsie Echeverri-Carroll, David Gibson, and Michael Oden)
	2) High-Tech Growth in Austin and Labor Market Polarization by Gender
		(Elsie Echeverri-Carroll, Michael Oden, and David Gibson)
	3) Elsie Echeverri-Carroll's sections of the entreprenurial paper.

	may be run thereafter.
*/
timer clear 1
timer on 1

use ipums_1980_90_00_05_13_5p5p5p1p1p_initial.dta, clear

*Uncapitalize variables
	rename IND1990 ind1990
	rename WKSWORK1 wkswork1
	rename WKSWORK2 wkswork2
	rename MET2013 met2013
	rename CNTYGP98 cntygp98
	rename CPUMA0010 cpuma0010

*Must be working in prior year.
	drop if wkswork2==0
*Age 18-64 only.  Variable coded from <1 year old to 90+ 
	drop if age<18 | age>64
*Drop institutionalized pop (mental institutions, military barracs, etc.)
	drop if gq==3
*drop unpaid family workers (includes self-EMP=13,14, wage=22, Gs=25,27,28 
* unpaid=29)
	drop if classwkrd==29
*self-employment (removed from wages calculation)
	gen selfemp = 0
	replace selfemp = 1 if inlist(classwkrd,13,14)
	*incorporated self-employment as potential entrepreneurial proxy
	gen selfemp_inc = 0
	replace selfemp_inc = 1 if classwkrd == 14
*Drop military (different #s depending on year)
	drop if inlist(occ,0,905) & year==1980
	drop if inlist(occ,0,903,904,905) & year==1990
	drop if inlist(occ,0,980,981,982,983) & year==2000
	drop if inlist(occ,0,980,981,982,983) & (year==2005 | year==2013)

*Create Austin 
	gen austin = 0
	replace austin = 1 if metaread==640
	replace austin = 1 if met2013==12420
	label variable austin "Austin MSA"

*Create Silicon Valley 
	gen svalley = 0
	replace svalley = 1 if ( (statefip==6) & (inlist(county, ///
		810, 850)) )
	/*
	These correspond to the following counties:
		(removed) 10	Alameda
		810	San Mateo
		850	Santa Clara
		(removed) 870	Santa Cruz
	These are the geographical definition of Silicon Valley
	according to the 2014 Silicon Valley Index
	*/
	label variable svalley "Silicon Valley"

*Create Bay Area 
	gen bay_area = 0
	replace bay_area = 1 if ( (statefip==6) & ( ///
								(inlist(metaread, ///
		7360, 7361, 7362, 7400, 7480, 7500, 8120)) ///
								| ///
								(inlist(met2013, ///
		41860, 34900, 41940, 42100, 42220, 44700)) ) )
	/*
	These correspond to the following regions comprising the 
	 San Jose - San Francisco - Oakland CSA in
	 
	 1980-2010:
		(MSA Code)	(MSA Name)
						(Included Counties)
		7360 	San Francisco
					Marin, San Francisco, San Mateo
		7361	Oakland
					Alameda, Contra Costa
		7362	Vallejo-Fairfield-Napa
					Napa, Solano
		7400	San Jose*
					Santa Clara
		7480	Santa Cruz
					Santa Cruz
		7500 	Santa Rosa-Petaluma
					Sonoma
		8120 	Stockton
					San Joaquin
	 2010-2013:
		(MSA Code)	(MSA Name)
						(Included Counties)
		41860	San Francisco-Oakland-Hayward
					Alameda, Conta Costa, San Francisco, San Mateo, Marin
		34900 	Napa
					Napa
		41940	San Jose-Sunnyvale-Santa Clara*
					Santa Clara, San Benito
		42100	Santa Cruz-Watsonville
					Santa Cruz
		42220	Santa Rosa
					Sonoma
		44700	Stockton-Lodi
					San Joaquin
		46700	Vallejo-Fairfield
					Solano
					
	*Note: The new MSA delineations include San Benito County
			but the older ones omit it. Population of San Benito
			County in 2013 is 57,600.
	*/
	label variable bay_area "Bay Area"

*Create Research Triangle 
	gen res_tri = 0

	replace res_tri = 1 if ( (year<2013 & statefip==37 & inlist(conspuma, 343, 344, 346)) ///
						| ///
						(year==2013 & statefip==37 & inlist(puma, ///
						01201,01202,01203,01204,01205,01206,01207, ///
						01208,01301,01302,01400,01500)) )
	/*
	These correspond to the following counties:
		1980 - 2005 (4): Orange, Durham, Chatham, Wake
		2013 (5): Orange, Durham, Chatham, Wake, Lee
	*/
	label variable res_tri "Research Triangle"	
	
*Create High-Technology industries (Hecker 2005)
	gen high_tech = 0

	replace high_tech = 1 if inlist(ind1990, ///
		732, 882, 891, 441, 322, 371, 352, 362)
	replace high_tech = 1 if inlist(ind1990, ///
		341, 342, 181)

	replace high_tech = 1 if inlist(ind1990, ///
		42, 31, 450, 332, 192, 510, 331, 892, 180)

	replace high_tech = 1 if inlist(ind1990, ///
		441, 710, 451, 700, 191, 192, 331, 310, 190)
	replace high_tech = 1 if inlist(ind1990, ///
		200, 201, 752, 370)
		
	/*	removed:440 (Radio and TV broadcasting and cable)
	 			741 (Business ervices, n.e.c.)
		as these absorbed too many non-HT industries in aggregation
		see crosswalks for details
	*/
	
*Create High-Technology groups (Austin Chamber of Commerce)
	gen high_tech_CoC = 0
	replace high_tech_CoC = 1 if inlist(ind1990, ///
		342)
	replace high_tech_CoC = 2 if inlist(ind1990, ///
		322, 341, 371)
	replace high_tech_CoC = 3 if inlist(ind1990, ///
		181, 352, 362, 200, 201, 192, 180, 191, 190)
		replace high_tech_CoC = 3 if inlist(ind1990, ///
		332, 331, 310, 370)
	replace high_tech_CoC = 4 if inlist(ind1990, ///
		510, 700, 710, 31, 42, 450, 451, 752)
	replace high_tech_CoC = 5 if inlist(ind1990, ///
		732, 440, 441, 741)
	replace high_tech_CoC = 6 if inlist(ind1990, ///
		882, 891, 892)
	*342 741 removed from categories 2 and 6, respectively,
	* as they include NAICS industries both included by
	* the CoC definitions and industries only included
	* in the Hecker 2005 definitions
		
	label define ht_CoC_label ///
		1 "HT-Mfg: Semiconductor & Electronic Component" ///
		2 "HT-Mfg: Computer & Other Electronic" ///
		3 "HT-Mfg: Other" ///
		4 "HT-Other Services" ///
		5 "HT-Information & Other IT" ///
		6 "HT-Engineering, R&D, Labs/Testing"
	label values high_tech_CoC ht_CoC_label
	
*Define three working sectors
	gen sector = 0

	*Identify government employees
	replace sector = 1 if inlist(classwkrd,25,27,28)
	
	*HT government employees will be considered HT only
	replace sector = 2 if high_tech != 0

	*Identify all other industries as a sector
	replace sector = 3 if (high_tech == 0) & (sector != 1)
	
	label define sector_label ///
	1 "Government" ///
	2 "High-Tech Industries" ///
	3 "Non-High-Tech Industries"
	label values sector sector_label

*Define 5 racial groups
	gen race_group = 0
	replace race_group = 1 if (race == 1) & (hispan == 0)
	replace race_group = 2 if (race == 2) & (hispan == 0)
	replace race_group = 3 if (race == 4 | race == 5 | race == 6) ///
		& (hispan == 0)
	replace race_group = 4 if (race == 3 | race == 7 | race == 8 ///
		| race == 9) & (hispan == 0)
	replace race_group = 5 if (hispan != 0)
	
	label define race_label ///
		1 "Anglo" ///
		2 "African American" ///
		3 "Asian American" ///
		4 "Other" ///
		5 "Hispanic"
	label values race_group race_label

*Define education levels
	gen school = 0
	replace school = 1 if educd > 1
	replace school = 2 if educd > 59
	replace school = 3 if educd > 64
	replace school = 4 if educd > 99
	
	label define school_label ///
		1 "Less than High School" ///
		2 "High School or GED" ///
		3 "Some College" ///
		4 "4 or More Years of College"
	label values school school_label
	
*Define education levels based on college level
	gen college = 0
	replace college = 1 if educd > 1
	replace college = 2 if educd > 99
	replace college = 3 if educd > 101
	
	label define college_label ///
		1 "Less than 4 Years of College" ///
		2 "4 Years of College (BA/BS)" ///
		3 "More than 4 Years of College"
	label values college college_label
	
	*Keep only relevant original variables and created variables
	* to speed up calculations
	keep ///
		year statefip metaread met2013 perwt sex age raced hispand ///
			educd ind1990 occ wkswork1 wkswork2 uhrswork incwage county /// 
		selfemp selfemp_inc austin svalley high_tech high_tech_CoC sector ///
			race_group school college ///
		puma conspuma cntygp98 cpuma0010 res_tri bay_area

save ipums_1980_90_00_05_13_5p5p5p1p1p.dta, replace
*Split dataset by year

*creates 1980 dataset
drop if year!=1980

	*Wages: top coded wage for 1980: $75,000
	*Limit on hourly wages to (LIMIT*1.5)/(50 weeks * 35 hours per week)
	replace incwage = incwage*1.5 if incwage==75000
	gen hrwagelimit = (75000*1.5)/(50*35)

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ1980_occ1990dd.dta

	*use Dorn definitions to define occupations
	do subfile_occ1990dd_occgroups_8cat, nostop

	*create own occupation variable based on Dorn definitions
	gen occ8cat = 1 if occ1_managproftech==1
	replace occ8cat = 2 if occ1_product==1
	replace occ8cat = 3 if occ1_transport==1
	replace occ8cat = 4 if occ1_construct==1
	replace occ8cat = 5 if occ1_mechminefarm==1
	replace occ8cat = 6 if occ1_operator==1
	replace occ8cat = 7 if occ1_clericretail==1
	replace occ8cat = 8 if occ1_service==1

	label define occlabel ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft" ///
		3 "Transportation" ///
		4 "Construction" ///
		5 "Mechanics/Mining/Agriculture" ///
		6 "Machine Operators/Assemblers" ///
		7 "Clerical/Retail Sales" ///
		8 "Low-Skill Services"
	label values occ8cat occlabel
	
	*Divide into 4 occupations groups
	gen occ4cat = 1 if occ1_managproftech==1
	replace occ4cat = 2 if (occ1_product==1 | occ1_transport==1 | ///
							occ1_construct==1 | occ1_mechminefarm==1 | ///
							occ1_operator==1)
	replace occ4cat = 3 if occ1_clericretail==1
	replace occ4cat = 4 if occ1_service==1

	label define occ4label ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft/Transportation/Construction/Mechanics/Mining/Agriculture/Machine Operators/Assemblers" ///
		3 "Clerical/Retail Sales" ///
		4 "Low-Skill Services"
	label values occ4cat occ4label

	*Keep only relevant original variables and created variables
	* to speed up calculations
	keep ///
		year statefip metaread met2013 perwt sex age raced hispand ///
			educd ind1990 wkswork1 uhrswork incwage county /// 
		selfemp selfemp_inc austin svalley high_tech high_tech_CoC sector ///
			race_group school college occ1990dd occ8cat occ4cat hrwagelimit ///
		puma conspuma cntygp98 cpuma0010 res_tri bay_area
	
save ipums_1980_5p.dta, replace

use ipums_1980_90_00_05_13_5p5p5p1p1p.dta, clear
*creates 1990 dataset
drop if year!=1990

	*Wages: top coded wage for 1990: $140,000
	*Limit on hourly wages to (LIMIT*1.5)/(50 weeks * 35 hours per week)
	replace incwage = incwage*1.5 if incwage==140000
	gen hrwagelimit = (140000*1.5)/(50*35)

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ1990_occ1990dd.dta

	*use Dorn definitions to define occupations
	do subfile_occ1990dd_occgroups_8cat, nostop

	*create own occupation variable based on Dorn definitions
	gen occ8cat = 1 if occ1_managproftech==1
	replace occ8cat = 2 if occ1_product==1
	replace occ8cat = 3 if occ1_transport==1
	replace occ8cat = 4 if occ1_construct==1
	replace occ8cat = 5 if occ1_mechminefarm==1
	replace occ8cat = 6 if occ1_operator==1
	replace occ8cat = 7 if occ1_clericretail==1
	replace occ8cat = 8 if occ1_service==1

	label define occlabel ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft" ///
		3 "Transportation" ///
		4 "Construction" ///
		5 "Mechanics/Mining/Agriculture" ///
		6 "Machine Operators/Assemblers" ///
		7 "Clerical/Retail Sales" ///
		8 "Low-Skill Services"
	label values occ8cat occlabel

	*Divide into 4 occupations groups
	gen occ4cat = 1 if occ1_managproftech==1
	replace occ4cat = 2 if (occ1_product==1 | occ1_transport==1 | ///
							occ1_construct==1 | occ1_mechminefarm==1 | ///
							occ1_operator==1)
	replace occ4cat = 3 if occ1_clericretail==1
	replace occ4cat = 4 if occ1_service==1

	label define occ4label ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft/Transportation/Construction/Mechanics/Mining/Agriculture/Machine Operators/Assemblers" ///
		3 "Clerical/Retail Sales" ///
		4 "Low-Skill Services"
	label values occ4cat occ4label

	*Keep only relevant original variables and created variables
	* to speed up calculations
	keep ///
		year statefip metaread met2013 perwt sex age raced hispand ///
			educd ind1990 wkswork1 uhrswork incwage county /// 
		selfemp selfemp_inc austin svalley high_tech high_tech_CoC sector ///
			race_group school college occ1990dd occ8cat occ4cat hrwagelimit ///
		puma conspuma cntygp98 cpuma0010 res_tri bay_area

	
save ipums_1990_5p.dta, replace

use ipums_1980_90_00_05_13_5p5p5p1p1p.dta, clear
*creates 2000 dataset
drop if year!=2000

	*Wages: top coded wage for 2000: $175,000
	*Limit on hourly wages to (LIMIT*1.5)/(50 weeks * 35 hours per week)
	replace incwage = incwage*1.5 if incwage==175000
	gen hrwagelimit = (175000*1.5)/(50*35)

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ2000_occ1990dd.dta

	*use Dorn definitions to define occupations
	do subfile_occ1990dd_occgroups_8cat, nostop

	*create own occupation variable based on Dorn definitions
	gen occ8cat = 1 if occ1_managproftech==1
	replace occ8cat = 2 if occ1_product==1
	replace occ8cat = 3 if occ1_transport==1
	replace occ8cat = 4 if occ1_construct==1
	replace occ8cat = 5 if occ1_mechminefarm==1
	replace occ8cat = 6 if occ1_operator==1
	replace occ8cat = 7 if occ1_clericretail==1
	replace occ8cat = 8 if occ1_service==1

	label define occlabel ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft" ///
		3 "Transportation" ///
		4 "Construction" ///
		5 "Mechanics/Mining/Agriculture" ///
		6 "Machine Operators/Assemblers" ///
		7 "Clerical/Retail Sales" ///
		8 "Low-Skill Services"
	label values occ8cat occlabel
	
	*Divide into 4 occupations groups
	gen occ4cat = 1 if occ1_managproftech==1
	replace occ4cat = 2 if (occ1_product==1 | occ1_transport==1 | ///
							occ1_construct==1 | occ1_mechminefarm==1 | ///
							occ1_operator==1)
	replace occ4cat = 3 if occ1_clericretail==1
	replace occ4cat = 4 if occ1_service==1

	label define occ4label ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft/Transportation/Construction/Mechanics/Mining/Agriculture/Machine Operators/Assemblers" ///
		3 "Clerical/Retail Sales" ///
		4 "Low-Skill Services"
	label values occ4cat occ4label

	*Keep only relevant original variables and created variables
	* to speed up calculations
	keep ///
		year statefip metaread met2013 perwt sex age raced hispand ///
			educd ind1990 wkswork1 uhrswork incwage county /// 
		selfemp selfemp_inc austin svalley high_tech high_tech_CoC sector ///
			race_group school college occ1990dd occ8cat occ4cat hrwagelimit	///
		puma conspuma cntygp98 cpuma0010 res_tri bay_area
	
save ipums_2000_5p.dta, replace

use ipums_1980_90_00_05_13_5p5p5p1p1p.dta, clear
*creates 2005 dataset
drop if year!=2005

	*fix ACS2005 occ codes
	gen occ_new = occ / 10 
	rename occ occ_old  
	rename occ_new occ
	
	*Wages: top coded wage for 2005: $325,576.92
		*note: for ACS samples we use the national average of the
		* 99.5th percentile per state as the upper limit.
	*Limit on hourly wages to (LIMIT*1.5)/(50 weeks * 35 hours per week)
	replace incwage = incwage*1.5 if incwage==325576.92
	gen hrwagelimit = (325576.92*1.5)/(50*35)

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ2005_occ1990dd.dta

	*use Dorn definitions to define occupations
	do subfile_occ1990dd_occgroups_8cat, nostop

	*create own occupation variable based on Dorn definitions
	gen occ8cat = 1 if occ1_managproftech==1
	replace occ8cat = 2 if occ1_product==1
	replace occ8cat = 3 if occ1_transport==1
	replace occ8cat = 4 if occ1_construct==1
	replace occ8cat = 5 if occ1_mechminefarm==1
	replace occ8cat = 6 if occ1_operator==1
	replace occ8cat = 7 if occ1_clericretail==1
	replace occ8cat = 8 if occ1_service==1

	label define occlabel ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft" ///
		3 "Transportation" ///
		4 "Construction" ///
		5 "Mechanics/Mining/Agriculture" ///
		6 "Machine Operators/Assemblers" ///
		7 "Clerical/Retail Sales" ///
		8 "Low-Skill Services"
	label values occ8cat occlabel
	
	*Divide into 4 occupations groups
	gen occ4cat = 1 if occ1_managproftech==1
	replace occ4cat = 2 if (occ1_product==1 | occ1_transport==1 | ///
							occ1_construct==1 | occ1_mechminefarm==1 | ///
							occ1_operator==1)
	replace occ4cat = 3 if occ1_clericretail==1
	replace occ4cat = 4 if occ1_service==1

	label define occ4label ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft/Transportation/Construction/Mechanics/Mining/Agriculture/Machine Operators/Assemblers" ///
		3 "Clerical/Retail Sales" ///
		4 "Low-Skill Services"
	label values occ4cat occ4label

	*Keep only relevant original variables and created variables
	* to speed up calculations
	keep ///
		year statefip metaread met2013 perwt sex age raced hispand ///
			educd ind1990 wkswork1 uhrswork incwage county /// 
		selfemp selfemp_inc austin svalley high_tech high_tech_CoC sector ///
			race_group school college occ1990dd occ8cat occ4cat hrwagelimit ///
		puma conspuma cntygp98 cpuma0010 res_tri bay_area

save ipums_2005_1p.dta, replace

use ipums_1980_90_00_05_13_5p5p5p1p1p.dta, clear
*creates 2013 dataset
drop if year!=2013

	*Wages: top coded wage for 2013: $371,461.5
		*note: for ACS samples we use the national average of the
		* 99.5th percentile per state as the upper limit.
	*Limit on hourly wages to (LIMIT*1.5)/(50 weeks * 35 hours per week)
	replace incwage = incwage*1.5 if incwage==371461.5
	gen hrwagelimit = (371461.5*1.5)/(50*35)

	*2013 uses WKSWORK2 which bins the WKSWORK1 values
	replace wkswork1 = 7 if wkswork2==1
	replace wkswork1 = 20 if wkswork2==2
	replace wkswork1 = 33 if wkswork2==3
	replace wkswork1 = 43.5 if wkswork2==4
	replace wkswork1 = 48.5 if wkswork2==5
	replace wkswork1 = 51 if wkswork2==6

	*fix ACS2013 occ codes
	do occ2013_occ2005.do
		/*
		there is no Dorn crosswalk for 2013 so I crosswalked occ 2013 codes to
		occ 2005 codes so this crosswalk can be used
		*/
	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ2005_occ1990dd.dta

	*use Dorn definitions to define occupations
	do subfile_occ1990dd_occgroups_8cat, nostop

	*create own occupation variable based on Dorn definitions
	gen occ8cat = 1 if occ1_managproftech==1
	replace occ8cat = 2 if occ1_product==1
	replace occ8cat = 3 if occ1_transport==1
	replace occ8cat = 4 if occ1_construct==1
	replace occ8cat = 5 if occ1_mechminefarm==1
	replace occ8cat = 6 if occ1_operator==1
	replace occ8cat = 7 if occ1_clericretail==1
	replace occ8cat = 8 if occ1_service==1

	label define occlabel ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Production/Craft" ///
		3 "Transportation" ///
		4 "Construction" ///
		5 "Mechanics/Mining/Agriculture" ///
		6 "Machine Operators/Assemblers" ///
		7 "Clerical/Retail Sales" ///
		8 "Low-Skill Services"
	label values occ8cat occlabel
	
	*Divide into 4 occupations groups
	gen occ4cat = 1 if occ1_managproftech==1
	replace occ4cat = 2 if (occ1_product==1 | occ1_transport==1 | ///
							occ1_construct==1 | occ1_mechminefarm==1 | ///
							occ1_operator==1)
	replace occ4cat = 3 if occ1_clericretail==1
	replace occ4cat = 4 if occ1_service==1

	label define occ4label ///
		1 "Managers/Professionals/Technicians/Finance/Public Safety" ///
		2 "Other Middle-Skill" ///
		3 "Clerical/Retail Sales" ///
		4 "Low-Skill Services"
	label values occ4cat occ4label

	*Keep only relevant original variables and created variables
	* to speed up calculations
	keep ///
		year statefip metaread met2013 perwt sex age raced hispand ///
			educd ind1990 wkswork1 uhrswork incwage county /// 
		selfemp selfemp_inc austin svalley high_tech high_tech_CoC sector ///
			race_group school college occ1990dd occ8cat occ4cat hrwagelimit ///
		puma conspuma cntygp98 cpuma0010 res_tri bay_area
		
save ipums_2013_1p.dta, replace

timer off 1
timer list 1
