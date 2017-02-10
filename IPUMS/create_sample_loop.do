* EVAN JOHNSTON: runtime approx. 26.25 mins 

/*
Uses the initial IPUMS extract to create samples and variables for all analyses.
Extract samples include:
	1960 US Census (5%)
	1970 US Census (1%, form2, MET)
	1980 US Census (5%)
	1990 US Census (5%)
	2000 US Census (5%)
	2009 American Community Survey (5year)
	2014 American Community Survey (5year)
Relevant variables include:
	year		year of survey	(all)
	gq			group quarters status (all)
	perwt		person weight (all)
	multyear	Actual year of survey, multi-year ACS/PRCS (2009-5y, 2014-5y)
	statefip	state code (all)
	county		county of residence (used with statefip) (NOT 1970)
	countyfips	county fips code (NOT 1970)
	metarea		metropolitan area/detailed (NOT 2014-5y, 1970)
	met2013		metropolitan area 2013 OMB definition (2014-5y, 2009-5y, 2000)
	met2013err	Coverage error in MET2013 variable (2014-5y, 2009-5y, 2000)
	cntygrp98	county group geographical variable (1980)
	puma		IPUMS geographical variable (NOT 1980, 1970)
	conspuma	consistent puma variable (1980, 1990, 2000, 2009-5y)
	cpuma0010	consistent puma variable (2000, 2009-5y, 2014-5y)
	sex			gender (all)
	age			age (all)
	race		racial/ethnic group/detailed (all)
	hispan		hispanic origin/detailed (all)
	educ		education level/detailed (all)
	occ1990		occupation 1990 basis (constant for 1950-*) (all)
	occ2010		occupation 2010 basis (constant for 1950-*) (all)
	ind1990		industry group 1990 basis (constant for 1950-*) (all)
	classwrk/d	class of worker/detailed (all)
	occsoc		occupation, SOC classification (2000 2009-5y 2014-5y)
	indnaics	industry, NAICS classification (2000 2009-5y 2014-5y)
	wkswork1	weeks worked in the last year (1980, 1990, 2000)
	wkswork2	weeks worked in the last year, intervalled (all)
	hrswork2	hours worked last week, intervalled (1960, 1970, 1980, 1990)
	uhrswork	usual hours worked per week (1980, 1990, 2000, 2009-5y, 2014-5y)
	incwage		annual wage and salary income (all)
Created variables include:
	fulltime		Binary indicator of full-time employment (work more than 35 hours per week, 14 weeks per year)
	fullyear		Binary indicator of full-year employment (work more than 40 weeks per year)
	selfemp			Binary indicator of self-employment
	selfemp_inc		Binary indicator of incorporated self-employment, used as entrepreneurial proxy
	selfemp_fulltime	Binary indicator of full-time self-employment following KF restriction
	austin			Binary Austin MSA indicator
	svalley			Binary Silicon Valley indicator
	bay_area		Binary Bay Area indicator (NOT USED)
	res_tri			Binary Research Triangle indicator for 4* main counties
	res_tri_mod		Binary Research Triangle indicator for 14* counties
	high_tech		Binary indicator of high-tech industries
	it_sector		Categorical variable of five high-tech, ITC sectors
	it_sector_mod	Categorical variable of six high-tech, ITC sectors ("biotech")
	high_tech_CoC	High-tech industry groups, Austin Chamber of Commerce
	sector			Three working sectors: government, high tech, non-high tech
	race_group		Five racial/ethnic groups
	school			Four education levels
	college			Three levels describing level of college completion
	occ1990dd		Occupation categories created by Dorn
	occ8cat			Eight occupation categories based from Dorn's work
	occ4cat			Four occupation categories aggregated from the above eight
	hrwagelimit		Hourly wage limit for each year based on top-coded incwage
						following Dorn's example
Files needed:
	original extract files	ipums_1960_5p_initial.dta
							ipums_1970_1pf2_initial.dta
							ipums_1980_5p_initial.dta
							ipums_1990_5p_initial.dta
							ipums_2000_5p_initial.dta
							ipums_2009_5y_initial.dta
							ipums_2014_5y_initial.dta
	Dorn's occ crosswalks	occ1960_occ1990dd.dta
							occ1970_occ1990dd.dta
							occ1980_occ1990dd.dta
							occ1990_occ1990dd.dta
							occ2000_occ1990dd.dta
							occ2005_occ1990dd.dta
	Do file to translate ACS>2009 occ codes to ACS 2005-09 occ codes
	Do file to create the 8 occ1990 groups
		subfile_occ1990dd_occgroups_8cat.do
*/

set more off

timer clear 1
timer on 1

* 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y
foreach year in 1960_5p 1970_1pf2 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
use ipums_`year'_initial.dta, clear

* add OCC data
merge 1:1 serial pernum year using ipums_occ_all_yrs.dta
drop _merge

* define civilian noninstitutional population
	* ages 18-65 only
	keep if (18<=age & age<=65)
	* must not be instiutionalized (prison, mental facility, homes for the aged, etc.)
	drop if gq==3
	* non-military
	drop if occ1990==905

	if (inlist(year, 1960, 1970, 2009, 2014)) {
	
		*add WKSWORK1 variable
		gen wkswork1 = 0

		*WKSWORK2 which bins the WKSWORK1 values
		replace wkswork1 = 7 if wkswork2==1
		replace wkswork1 = 20 if wkswork2==2
		replace wkswork1 = 33 if wkswork2==3
		replace wkswork1 = 43.5 if wkswork2==4
		replace wkswork1 = 48.5 if wkswork2==5
		replace wkswork1 = 51 if wkswork2==6
	}
	
	if (year==1960 | year==1970) {
	
		*add uhrswork variable
		gen uhrswork = 0

		*hrswork2 which bins the uhrswork values
		replace uhrswork = 7.5 if hrswork2==1
		replace uhrswork = 22 if hrswork2==2
		replace uhrswork = 32 if hrswork2==3
		replace uhrswork = 37 if hrswork2==4
		replace uhrswork = 40 if hrswork2==5
		replace uhrswork = 44.5 if hrswork2==6
		replace uhrswork = 54 if hrswork2==7
		replace uhrswork = 60 if hrswork2==8
	}

* define full-year persons
	gen fullyear = 0
	replace fullyear = 1 if wkswork1>=40
	
* define self-employment (removed from wages calculation)
	gen selfemp = 0
	replace selfemp = 1 if inlist(classwkrd,13,14) & year!=1960
	replace selfemp = 1 if classwkrd==10 & year==1960
	*incorporated self-employment as potential entrepreneurial proxy
	gen selfemp_inc = 0
	replace selfemp_inc = 1 if classwkrd == 14
	
* define full-time persons
	gen fulltime = 0
	replace fulltime = 1 if ( (year<2009) & (uhrswork>=35) & (wkswork1>=14) )
	replace fulltime = 1 if ( (year>=2009) & (uhrswork>=35) & (wkswork1>=7) )
	* note: we separate into before and after '09 because
	* '09 and '14 samples use WKSWORKS2	bins (see above)

* define full-time Self-employed persons
	gen selfemp_fulltime=0
	replace selfemp_fulltime=1 if (uhrswork>=15 & year>=1980)
	replace selfemp_fulltime=1 if (uhrswork>=7.5 & year<1980)
	* must have worked "enough" at the self-employment position
	*	follows the KF restriction (see KF Index of StartupActivity Metro Area p.59)
	* note: we separate into before and after '80 because
	* '60 and '70 samples use hrswork2	bins (see above)
	
*Create Austin 
	gen austin = 0
	capture replace austin = 1 if (year<2014 & metaread==640)
	capture replace austin = 1 if (year==2014 & met2013==12420)
		
	label variable austin "Austin MSA"

*Create Research Triangle (1960, 1970 not defined)
	gen res_tri = 0

	capture replace res_tri = 1 if ( (statefip==37) & (year<2014) & ///
		(inlist(conspuma, 343, 355, 346)) )
	capture replace res_tri = 1 if ( (statefip==37) & (year==2014) & (multyear<2012) ///
		& (inlist(puma, 02601, 02602, 02701, 02702, 02703, 02801, 02802, 02900)) )
	capture replace res_tri = 1 if ( (statefip==37) & (year==2014) & (multyear>=2012) ///
		& (inlist(puma, 01201, 01202, 01203, 01204, 01205, 01206, 01207, ///
			01208, 01301, 01302, 01400, 01500)) )
	/*
	These correspond to the following counties:
		1980 - 2011 (4): Orange, Durham, Chatham, Wake
		2012 - 2014 (5): Orange, Durham, Chatham, Wake, Lee
	*/

	gen res_tri_mod = 0
	capture replace res_tri_mod = 1 if ( (statefip==37) & (year==1980) & ///
		inlist(cntygp98, 14, 15, 16, 17, 18, 19, 20, 34) )
	capture replace res_tri_mod = 1 if ( (statefip==37) & (year==1990) & ///
		(inlist(puma, 01800, 02700, 02500, 02400, 02301, 02302) | ///
			inlist(puma, 02303, 02600, 03200) ) )
	capture replace res_tri_mod = 1 if ( (statefip==37) & inlist(year, 1960, 2000, 2009) & ///
		(inlist(puma, 02400, 02801, 02802, 02900, 03000, 03100) | ///
			inlist(puma, 03300, 02701, 02702, 02703, 02601, 02602) ) )
	capture replace res_tri_mod = 1 if ( (statefip==37) & (year==2014) & (multyear<2012) & ///
		(inlist(puma, 02400, 02801, 02802, 02900, 03000, 03100) | ///
			inlist(puma, 03300, 02701, 02702, 02703, 02601, 02602) ) )
	capture replace res_tri_mod = 1 if ( (statefip==37) & (year==2014) & (multyear>=2012) & ///
		(inlist(puma, 00400, 00500, 01400, 01301, 01302, 01201) | ///
			inlist(puma, 01202, 01203, 01204, 01205, 01206, 01207) | ///
			inlist(puma, 01208, 01500, 03800, 01100) ) )

	/*
	These correspond to the following counties:
		1980 (15): Rockingham, Caswell, Person, Granville, Vance, Warren, Franklin, 
			Orange, Durham, Chatham, Wake, Lee, Johnston, Harnett, and Sampson  
		1990 (15): Rockingham, Caswell, Person, Granville, Vance, Warren, Franklin, 
			Orange, Durham, Chatham, Wake, Lee, Johnston, Harnett, and Sampson  
		2000-2011 (14): Rockingham, Caswell, Person, Granville, Vance, Warren, Franklin, 
			Orange, Durham, Chatham, Wake, Lee, Johnston, and Harnett
		2012-* (13): Caswell, Person, Granville, Vance, Warren (WEST PART ONLY), Franklin, 
			Orange, Durham, Chatham, Wake, Lee, Johnston, and Harnett
	*/
	label variable res_tri_mod "Research Triangle Mod"	

*Create Silicon Valley (1960, 1970 not defined)
	gen svalley = 0
	
	capture replace svalley = 1 if ( (year<2014) & (statefip==6) & (inlist(county, ///
		810, 850)) )
	capture replace svalley = 1 if ( (year==2014) & (statefip==6) & (inlist(puma, ///
		08101, 08102, 08103, 08104, 08105, 08106, 08501, 08502, ///
		08503, 08504, 08505, 08506, 08507, 08508, 08509, 08510, ///
		08511, 08512, 08513, 08513)) )
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

/*Create Bay Area

NOTE: this variable is not currently used for any calculations and is commented out

	gen bay_area = 0
	if year<2014 {
		replace bay_area = 1 if (inlist(metaread, ///
		7360, 7361, 7362, 7400, 7480, 7500, 8120))
		} 
		else {
		*replace bay_area = 1 if (inlist(met2013, ///
		*41860, 34900, 41940, 42100, 42220, 44700))
		}
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
			but the older ones omit it. ulation of San Benito
			County in 2013 is 57,600.
	*/
	label variable bay_area "Bay Area"
*/
	
*Create High-Technology industries (Hecker 2005)
	gen high_tech= 0

	replace high_tech = 1 if inlist(ind1990, ///
		31, 42, 180, 181, 190, 191, 192, 200, 201)
	replace high_tech = 1 if inlist(ind1990, ///
		310, 322, 331, 332, 341, 342, 352, 352, 362)
	replace high_tech = 1 if inlist(ind1990, ///
		370, 371, 440, 441, 732, 450, 451, 510, 700)
	replace high_tech = 1 if inlist(ind1990, ///
		710, 741, 752, 882, 891, 892)
		
*Create High-Technology sector see IT Tables.xlsx for details
	gen it_sector = 0
	replace it_sector = 6 if high_tech == 1
	replace it_sector = 1 if inlist(ind1990, 331, 342)
	replace it_sector = 2 if inlist(ind1990, 322, 332, 371, 341)
	replace it_sector = 3 if inlist(ind1990, 732)
	replace it_sector = 4 if inlist(ind1990, 510, 441, 440)
	replace it_sector = 5 if inlist(ind1990, 882, 892, 891)
	
	label define it_sector_label ///
		1 "Semiconductor & Electrical Equipment Mfg." ///
		2 "Computer & Related Equipment Mfg." ///
		3 "Software Publishers, Computer Systems Design, and Related Services" ///
		4 "Commercial Equipment Wholesalers (Dell) & Telecommunication Provider Services" ///
		5 "High-Tech Business Services (Architectural, Engineering, Management Consulting, and other Scientific and Technical Consulting Services)" ///
		6 "Other High-Tech"
	label values it_sector it_sector_label

* Create modified ITC sectors: add sector of Pharm & R&D 
	gen it_sector_mod = 0
	replace it_sector_mod = 7 if high_tech == 1
	replace it_sector_mod = 1 if inlist(ind1990, 331, 342)
	replace it_sector_mod = 2 if inlist(ind1990, 322, 332, 341)
	replace it_sector_mod = 3 if inlist(ind1990, 732)
	replace it_sector_mod = 4 if inlist(ind1990, 510, 441, 440)
	replace it_sector_mod = 5 if inlist(ind1990, 882, 892)
	replace it_sector_mod = 6 if inlist(ind1990, 181, 371, 891)
	
	label define it_sector_label_mod ///
		1 "Semiconductor & Electrical Equipment Mfg." ///
		2 "Computer & Related Equipment Mfg." ///
		3 "Software Publishers, Computer Systems Design, and Related Services" ///
		4 "Commercial Equipment Wholesalers (Dell) & Telecommunication Provider Services" ///
		5 "High-Tech Business Services (Architectural, Engineering, Management Consulting, and other Scientific and Technical Consulting Services)" ///
		6 "Biotechnology (Pharmaceutical & Medicine Mfg., Scientific & Controlling Instrument Mfg., & R&D Testing Services)" ///
		7 "Other High-Tech"
	label values it_sector_mod it_sector_label_mod
	
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
	replace sector = 2 if high_tech == 1

	*Identify all other industries as a sector
	replace sector = 3 if (high_tech != 1) & (sector != 1)
	
	label define sector_label ///
	1 "Government" ///
	2 "HT Sector" ///
	3 "Non-HT Sector"
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

* Wage and Income-related variables ********

* dummy for us-50 states
gen us_50 = 0
replace us_50 = 1 if statefip<=56

* Tag top-coded incomes
gen top_code = 0
* state-year string variable: 1990 and on use state-specific top-codes and
* 	year-specific for the multi-year samples
gen state_yr = string(statefip)+"0"+string(year)
	if (year>=2009) {
		replace state_yr = string(statefip)+"0"+string(multyear)
	}
replace state_yr="0"+state_yr if length(state_yr)==6

* finds the maximum income (except the N/A and missing codes) by state-year
egen top_code_state_yr = max(incwage) if incwage<999998 & us_50==1, by(state_yr)

* top code dummy if state, year, and state-year topcode all match
replace top_code = 1 if (statefip==real(substr(state_yr,1,2)) & ///
						 year==real(substr(state_yr,4,4)) & ///
						 incwage==top_code_state_yr)
	if (year>=2009) {
		replace top_code = 1 if (statefip==real(substr(state_yr,1,2)) & ///
						 multyear==real(substr(state_yr,4,4)) & ///
						 incwage==top_code_state_yr)
	}
	
*Create labor supply based on person-work hours	
gen laborsupply= wkswork1*uhrswork

*Multiply by Census sampling weight
gen laborwgt = laborsupply*perwt
	
* notes comments
note fulltime: Binary indicator of full-time employment (work more than 35 hours per week, 14 weeks per year)
note fullyear: Binary indicator of full-year employment (work more than 40 weeks per year)
note selfemp: Binary indicator of self-employment (removed for wage calculations)
note selfemp_inc: Binary indicator of incorporated self-employment, used as entrepreneurial proxy
note austin: Binary Austin MSA indicator (Bastrop, Caldwell, Hays, Travis, and Williamson Counties)
note svalley: Binary Silicon Valley indicator (San Mateo and Santa Clara counties)
*note bay_area: Binary Bay Area indicator (NOT USED)
note res_tri: Binary Research Triangle indicator (Orange, Wake, Durham, and Chatham counties*) ///
	Lee county included in 2014 year
note res_tri_mod: Binary Research Triangle indicator ///
	These correspond to the following counties:	///
		1980 (15): Rockingham, Caswell, Person, Granville, Vance, Warren, Franklin, ///
			Orange, Durham, Chatham, Wake, Lee, Johnston, Harnett, and Sampson 	///
		1990 (15): Rockingham, Caswell, Person, Granville, Vance, Warren, Franklin, 	///
			Orange, Durham, Chatham, Wake, Lee, Johnston, Harnett, and Sampson  	///
		2000-2011 (14): Rockingham, Caswell, Person, Granville, Vance, Warren, Franklin, 	///
			Orange, Durham, Chatham, Wake, Lee, Johnston, and Harnett	///
		2012-* (13): Caswell, Person, Granville, Vance, Warren (WEST PART ONLY), Franklin, 	///
			Orange, Durham, Chatham, Wake, Lee, Johnston, and Harnett
note high_tech: Binary indicator of high-tech industries (Hecker, 2005)
note it_sector: Indicates high-tech it-sector of industry ///
		1(Semiconductor & Electrical Equipment Mfg.) ///
		2(Computer & Related Equipment Mfg.) 3(Software Services) ///
		4(Commercial Equipment Wholesalers (Dell) & Telecommunications) ///
		5(Other High-Tech Business Services)
note it_sector_mod: Indicates high-tech it-sector of industry ///
		1(Semiconductor & Electrical Equipment Mfg.) ///
		2(Computer & Related Equipment Mfg.) 3(Software Services) ///
		4(Commercial Equipment Wholesalers (Dell) & Telecommunications) ///
		5(Other High-Tech Business Services) ///
		6(Pharmaceutical & Medicine Mfg. & R&D Testing Services)
note high_tech_CoC: High-tech industry groups, Austin Chamber of Commerce
note sector: Three working sectors: 1(government) 2(high tech) 3(non-high tech)
note race_group: Five racial/ethnic groups ///
		1(Anglo) 2(African American) 3(Asian American) 4(Other) 5(Hispanic)
note school: Four education levels ///
		1(Less than High School) 2(High School or GED) 3(Some College) 4(4 or More Years of College)
note college: Three levels describing level of college completion ///
		1(Less than 4 Years of College)	2(4 Years of College (BA/BS)) 3(More than 4 Years of College)
note us_50: binary of individual living in 50-US states
note top_code: binary of if an individual has a top-coded wage
note state_yr: string of state FIPS code, 0, and year (or mult-year) used for identifying top-codes
note top_code_state_yr: top-coded income for each state-year (or mult-year)
note laborsupply: total hours a person worked in a week (wkswork1*uhrswork) used in hourly wage calculations
note laborwgt: total hours worked weighted (laborsupply*perwt) used in hourly wage calculations
note _dta: sample includes non-institutionalized civilians age 18-65

*1960 specific coding
if year==1960 {

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ1960_occ1990dd.dta
	drop _merge
	
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
	
	drop occ1_* occ2_* occ3_*
	
	* Inflate incwage to $2014: CPI=8
	replace incwage=incwage*8
	
	* Inflate top code for state-year to $2014
	gen top_code_state_yr_adj=top_code_state_yr*8
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
*Low Earnings Outliers
/*
	For each year, we find the average hourly wage of the first percentile 
	and set all hourly wages in that percentile = to this mean
	
	Because this depends on the distribution in question, we calculate these
	per analyes rather than for the entire sample

	*finds the 1st percentile of hourly wage
		sum hrwages, detail
		gen lowwagelimit = r(p1)

	*replaces hrwages with mean of hour wages <= the 1st percentile hourly wage
	* if wage is in that percentile
		sum hrwages if hrwages<=lowwagelimit
		replace hrwages=r(mean) if hrwages<=lowwagelimit
	
	*Use CPI deflator to convert to 2004 dollars
		gen hrwages2004 = hrwages * (188.9/82.4)

	*Take the natural log of the real wages
		gen logwages80 = log(hrwages2004)
*/		
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups

	save ipums_`year'.dta, replace
}
*1970 specific coding
if year==1970 {

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ1970_occ1990dd.dta
	drop _merge

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
	
	drop occ1_* occ2_* occ3_*
	
	* Inflate incwage to $2014: CPI=6.1
	replace incwage=incwage*6.1
	
	* Inflate top code for state-year to $2014
	gen top_code_state_yr_adj=top_code_state_yr*6.1
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups

	save ipums_`year'.dta, replace
}

*1980 specific coding
if year==1980 {

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ1980_occ1990dd.dta
	drop _merge
	
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
	
	drop occ1_* occ2_* occ3_*

	* Inflate incwage to $2014: CPI=2.87
	replace incwage=incwage*2.87
	
	* Inflate top code for state-year to $2014
	gen top_code_state_yr_adj=top_code_state_yr*2.87
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups

save ipums_`year'.dta, replace
}

*1990 specific coding
else if year==1990 {

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ1990_occ1990dd.dta
	drop _merge
	
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
	
	drop occ1_* occ2_* occ3_*

	* Inflate incwage to $2014: CPI=1.81
	replace incwage=incwage*1.81
	
	* Inflate top code for state-year to $2014
	gen top_code_state_yr_adj=top_code_state_yr*1.81
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups
		
save ipums_`year'.dta, replace
}
* 2000 specific coding
else if year==2000 {

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ2000_occ1990dd.dta
	drop _merge
	
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
	
	drop occ1_* occ2_* occ3_*

	* Inflate incwage to $2014: CPI=1.37
	replace incwage=incwage*1.37
	
	* Inflate top code for state-year to $2014
	gen top_code_state_yr_adj=top_code_state_yr*1.37
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups
		
save ipums_`year'.dta, replace
}

* 2009-5y specific coding
else if year==2009 {
	
	* adjust occs
	replace occ = trunc(occ / 10)
	
	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ2005_occ1990dd.dta
	drop _merge
	
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
	
	drop occ1_* occ2_* occ3_*

	* Inflate incwage to $2014: CPI= (1.21, 1.17, 1.14, 1.10, 1.10)
	replace incwage=incwage*1.21 if multyear==2005
	replace incwage=incwage*1.17 if multyear==2006
	replace incwage=incwage*1.14 if multyear==2007
	replace incwage=incwage*1.1 if multyear==2008
	replace incwage=incwage*1.1 if multyear==2009
	
	* Inflate top code for state-year to $2014	
	gen top_code_state_yr_adj=top_code_state_yr
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.21 if multyear==2005
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.17 if multyear==2006
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.14 if multyear==2007
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.1 if multyear==2008
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.1 if multyear==2009
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups

save ipums_`year'.dta, replace
}

* 2014-5y specific coding
else if year==2014 {

	* convert 2014 occs to 2005-9 occs
	do occ2014_occ2005.do

	*create occ1990dd variable from the Dorn crosswalks
	merge m:1 occ using occ2005_occ1990dd.dta
	drop _merge
	
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
	
	drop occ1_* occ2_* occ3_*

	* Inflate incwage to $2014: CPI= (1.09, 1.05, 1.03, 1.02)
	replace incwage=incwage*1.09 if multyear==2010
	replace incwage=incwage*1.05 if multyear==2011
	replace incwage=incwage*1.03 if multyear==2012
	replace incwage=incwage*1.02 if multyear==2013
		
	* Inflate top code for state-year to $2014
	gen top_code_state_yr_adj=top_code_state_yr
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.09 if multyear==2010
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.05 if multyear==2011
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.03 if multyear==2012
	replace top_code_state_yr_adj=top_code_state_yr_adj*1.02 if multyear==2013
	
	* Create hourly wage limit
	gen hrwagelimit=incwage*1.5/(50*35) if top_code==1
	
	*Create hourly wages
	gen hrwages = incwage/laborsupply

	*Cap hourly wages
	replace hrwages=hrwagelimit if hrwages>hrwagelimit
	
	note top_code_state_yr_adj: top-coded income for each state-year (or mult-year) adjusted to $ 2014	
	note hrwages: real hourly wage (already inflated) calculated as total wage income over total hours worked in a year (incwage/laborsupply)
	note hrwagelimit: the maximum real hourly wage (already inflated) for a given top_code (state-year) scaled by 1.5 and assuming 50 weeks worked at 35 hours per week ///
		(incwage*1.5/(50*35) if top_code==1) 
	note occ1990dd: Occupation categories created by Dorn (2013?)
	note occ8cat: Eight occupation categories based from Dorn's work
	note occ4cat: Four occupation categories aggregated from the eight groups
	
save ipums_`year'.dta, replace
}

}
timer off 1
timer list 1
