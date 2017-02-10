/* Format migration dataset 

Evan Johnston

Replication of the SDA migration tables in Stata.
*/
* IPUMS download of all migration variables
set more off

* ~10 min
timer clear 1
timer on 1

*use migration_data_initial.dta, clear
use migration_data_initial.dta, clear

* add MIGCOGRP data
merge 1:1 serial pernum year using migration_MIGCOGRP_only.dta
drop _merge

* add SEX COUNTY COUNTYGP98 data
merge 1:1 serial pernum year using migration_SEX_COUNTY_GP98_only.dta
drop _merge

* define civilian noninstitutional population
	* ages 18-65 only
	keep if (18<=age & age<=65)
	* must not be instiutionalized (prison, mental facility, homes for the aged, etc.)
	drop if gq==3
	* non-military
	drop if occ1990==905

	if (year==2009 | year==2014) {
	
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


* define full-year persons
	gen fullyear = 0
	replace fullyear = 1 if wkswork1>=40
	
* define self-employment (removed from wages calculation)
	gen selfemp = 0
	replace selfemp = 1 if inlist(classwkrd,13,14)
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
	
	* 1980 IS EARLIEST SAMPLE FOR MIGRATION:
	*replace selfemp_fulltime=1 if (uhrswork>=7.5 & year<1980)
	* must have worked "enough" at the self-employment position
	*	follows the KF restriction (see KF Index of StartupActivity Metro Area p.59)

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
	
*Define three working sectors
	gen sector = 0

	*Identify government employees
	replace sector = 1 if inlist(classwkrd,25,27,28)
	
	*HT government employees will be considered HT only
	replace sector = 2 if high_tech != 0

	*Identify all other industries as a sector
	replace sector = 3 if (high_tech != 1) & (sector != 1)
	
	label define sector_label ///
	1 "Government" ///
	2 "HT Sector" ///
	3 "Non-HT Sector"
	label values sector sector_label

* Define technology-oriented workers
	gen tech_oriented = 0
	
	replace tech_oriented = 1 if inlist(occ1990, ///
		44, 45, 47, 48, 53, 55, 56, 57, 59, 64, 65)
	replace tech_oriented = 1 if inlist(occ1990, ///
		66, 68, 69, 73, 75, 76, 77, 78, 79, 83)
	replace tech_oriented = 1 if inlist(occ1990, ///
		214, 217, 218, 223, 224, 225, 229)

* rename migpuma for convenience
rename migpuma migpuma5

* puts migrate1 and migrate5 into single variable
gen migrate=0
replace migrate=migrate1 if year>2000
replace migrate=migrate5 if year<2001
label values migrate MIGRATE1

* puts migplac1 and migplac5 into single variable
gen migplac=0
replace migplac=migplac1 if year>2000
replace migplac=migplac5 if year<2001
label values migplac MIGPLAC1

* puts migpuma1 and migpuma5 into single variable
gen migpuma=0
replace migpuma=migpuma1 if year>2000
replace migpuma=migpuma5 if year<2001
label values migpuma MIGPUMA1

* puts migmet1 and migmet5 into single variable
gen migmet=0
replace migmet=migmet1 if year>2000
replace migmet=migmet5 if year<2001
label values migmet MIGMET1

* notes comments
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
note sector: Three working sectors: 1(government) 2(high tech) 3(non-high tech)
note tech_oriented: Binary indicator of a technology-oriented occupation (Hecker, 2005)
note _dta: sample includes non-institutionalized civilians age 18-65
note _dta: migration variables are: 1-migrate1/5(indicator of if migration occurred and what type (detail) ///
	2-migplac1/5(state or country of migration) 3-migmeta/5(MSA of migration if applicable) ///
	4-migpuma1/.(puma of migration) 5-migcogrp(county group of migration, 1980 only) ///
	migpuma1/5, migmet1/5, migplac1/5 also are combined in their corresponding vars sans #
		
save migration_data.dta, replace

timer off 1
timer list 1
