/* Evan Johnston

Crosstab for INDNAICS and IND1990 IPUMS variables:
2000 INDNAICS only (old INDNAICS)

Uses dataset from 2000 (5%) to create a crosswalk between
the indnaics and ind1990 variables from IPUMS.
The indnaics variable was created from 1997 NAICS codes in 2000.

The High Tech definitions are taken from Hecker (2005) definition of HT industry.

Variables:
	ind1990: IPUMS industrial classification
	indnaics: IPUMS NAICS variable

Files that need to be in this directory:
	ind1990_indnaics_00_5p.dta	2000 (5%) dataset
	HT_crosswalk_csv			dataset for final HT crosswalk
*/

*changes directory to where Stata extract file is
*cd "C:\Users\eaj628\Documents\StataData\Migration Stata replication\NAICS to IND1990 crosswalk"

*select dataset. 00_5p meaning 2000 5% sample
use ind1990_indnaics_00_5p.dta, clear

*rename ind1990 for convenience
rename IND1990 ind1990

*forces the dropping of all duplicates of INDNAICS
*this creates only unique observations of INDNAICS
duplicates drop indnaics, force

*saves the dataset
save ind1990_indnaics_crosswalk_00_5p, replace

*creates high tech variable
gen high_tech = 0

* list of HT industries from Hecker 2005 table 4

replace high_tech = 1 if inlist(indnaics, ///
	"3254", "3341", "334M1", "334M2", "3345", "33641M1", "33641M2", "5112")
replace high_tech = 1 if inlist(indnaics, ///
	"5161", "5133Z", "5181", "5142", "5413", "5415", "5417")

replace high_tech = 1 if inlist(indnaics, ///
	"113M", "211", "2211P", "325M", "3252", "333M")
replace high_tech = 1 if inlist(indnaics, ///
	"3333", "4214", "5416")
	
replace high_tech = 1 if inlist(indnaics, ///
	"3241M", "32411", "3253", "3255", "325M", "3336", "333M", "335M")
replace high_tech = 1 if inlist(indnaics, ///
	"3369", "486", "51331", "5133Z", "52M1", "52M2")
replace high_tech = 1 if inlist(indnaics, ///
	"55", "561M", "8112")
/*
	2002 NAICS	|	1997 NAICS	|	2000 INDNAICS	|	
	
	3254			3254			3254				
	3341			3341			3341				
	3342			3342			334M1				
	3343			3343			334M1				
	3344			3344			334M2				
	3345			3345			3345				
	3346			3346			334M2				
	3364			336411-13		33641M1, 33641M2	
	5112			5112			5112				
	5161			-				5161				
	5179			5133			5133Z				
	5181			-				5181				
	5182			5142			5142		
	5413			5413			5413				
	5415			5415			5415				
	5417			5417			5417				
	
	1131			1131			113M				
	1132			1132			113M				
	2111			211				211					
	2211			2211			2211P				
	3251			3251			325M				
	3252			3252			3252				
	3332			3332			333M				
	3333			3333			3333				
	4234			4214			4214				
	5416			5416			5416				

	3341			3241			3241M, 32411				
	3253			3253			3253				
	3255			3255			3255				
	3259			3259			325M				
	3336			3336			3336				
	3339			3339			333M				
	3353			3353			335M				
	3369			3369			3369				
	4861			486				486						
	4862			486				486							
	4869			486				486						
	5171			51331			51331				
	5172			5133			5133Z				
	5173			5133			5133Z				
	5174			5133			5133Z				
	5211			52111			52M1				
	5232			523				52M2				
	5511			551				55					
	5612			5612			561M				
	8112			8112			8112				
*/

* creates a column of the ind1990 codes
gen ind1990_code = ind1990

* removes irrelevant variables and saves dataset
keep ind1990 ind1990_code indnaics high_tech

* sorts by ind1990 and saves dataset
sort ind1990
save ind1990_indnaics_crosswalk_ht_2000, replace
export excel ind1990_indnaics_crosswalk_ht_2000.xlsx, first(var) replace
