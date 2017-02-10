/*
Uses the matching procedure used in matching2_0.do with the full NETS and
	TSoS data. subsets of NETS and TSoS data to match on names. Matching procedure 
	using joinby rather than merge.
	
Files needed:
	NETSData.dta
	NETSDataNAMES.dta
	SoSData.dta
	(Outputs of the NETS_format.do and SoSData_format.do files)
	
Files output:
	join.dta
	startups.dta
	
NOTES:
	NETS contains 360,000 unique establishments. TSoS contains 240,000 unique
	filing#s and 240,000 unique entities, but these are not 1:1.
	
Evan Johnston
*******************************************************************************
Matching excercise 2: joinby (D. McClendon)

"Overall, I think your mataching strategy and code looks sound. But there was
	one thing that I thought might be givien you problems, and that's using the
	m:m or many-to-many merge. I understand the impulse to use this type of
	merge, rather than 1:1 or 1:m, but it has the potential to scre things up.
	This is especially true when yo have two datasets that may have different
	numbers of identical matches. It might be helpful to read this for more:
	(dmerge.pdf)
	
It looks like you were following Mary and Alyse's strategy with the m:m merge.
	I would think about trying a different merging technique - have you ever
	seen "joinby"? It might be what youre looking for because it will create 
	all possible matches. You will end up with a much bigger dataset but it might
	help you be able to better identify entrepreneurial companies, or at least 
	which ones might be those type. (djoinby.pdf)"
	
***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** ***** 
Following his suggestion, I will first clean the entity_names of both datasets
	as in matching1_1. Then I will use joinby to connect the two datasets.
	Hopefully this procedure will cause less issues with duplication problems, 
	or at least create duplicates in a more meaningful way. Recall that the TSoS
	data does not have uniqueness (240,000 filing numbers and 240,000 entites
	that are not 1:1) thus joining in this way will show us all possible matches.
	
Commented outputs are shown below the code (mostly _merge tabs and information 
	on duplicates).
*/

/********************************* Cleaning ************************************
clean NETS and TSoS by removing abbreviations (inc, co, corp, etc.)
note that the formatting of the company/entity names in two datasets has already
	been completed identically at this point */

timer clear 1
timer on 1

foreach i in NETSDataNAMES SoSDataNAMES {
	* use data "i"
	use `i'.dta, clear
	
	* set entity_name to lowercase
	replace entity_name=lower(entity_name)
	
	/* for the TSoS data, only keep records:
			in the same interval as NETS
			unique filing_number-entity_name pairings
		(see annualfilings .do file in SoS data folder for details)
	*/
	if "`i'"=="SoSDataNAMES"{
		keep if interval==1
		duplicates drop filing_number entity_name, force
		drop if entity_name==""
		duplicates tag entity_name, gen(multi_regs)
		note multi_regs: numerical variable showing the number of ///
			times an entity re-registered with the TSoS ///
			(0->registered once; 1->registered twice; 2->registered thrice)
	}
	
	* create a cleaned named variable
	*	remove all special characters and abbreviations from cleaned name
	gen cleaned_name = trim(itrim(subinstr(entity_name, ".", "",.)))
	foreach j in , ? : ; ! @ # - ///
		incorporated corporation "limited liability company" ///
		partnership "limited partnership" "l l c" "l l p" "l t d" ///
		" inc" " ltd" " llc" " llp" " lp" " corp" " pllc"{
		replace cleaned_name = subinstr(cleaned_name, "`j'", "",.)
		replace cleaned_name = subinstr(cleaned_name, " and ", " & ",.)
	}
	replace cleaned_name = trim(itrim(cleaned_name))
	recast str60 cleaned_name, force
	
	* create recast cleaned named variables with 16, ..., 32 characters
	foreach k in 16 20 24 28 32{
		gen cleaned_name`k'=cleaned_name
		recast str`k' cleaned_name`k', force
	}
	
	* initialize match level (used later)
	gen match_level = 0
	
	* remove unnamed
	drop if inlist(cleaned_name, "")
	
	* save each dataX
	save `i'X.dta, replace
}
********************************** MATCHIT(1) **********************************
* uses -matchit- command to "fuzzy" match the entities in TSoS with establishments in NETS
use NETSDataNAMESX, clear
destring(dunsnumber), gen(dunID)
matchit dunID cleaned_name using SoSDataNAMESX.dta, ///
	idusing(filing_number) txtusing(cleaned_name) time override


********************************** JOIN(1) *************************************
* First join NETSDataNAMES (the subset of NETS) with the cleaned_name SoSData (full)

use NETSDataNAMESX, clear
drop entity_name

joinby cleaned_name using SoSDataNAMESX, unmatched(both)
tab _merge
/*
                       _merge |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
          only in master data |    300,772       62.32       62.32
           only in using data |    122,503       25.38       87.70
both in master and using data |     59,339       12.30      100.00
------------------------------+-----------------------------------
                        Total |    482,614      100.00

*/
keep if _merge==3
drop _merge
count
* 59,339
codebook dunsnumber company cleaned_name filing_number entity_name
/*
dunsnumber:
	unique values:  58246                    missing "":  0/146333
company:
	unique values:  52703                    missing "":  0/146333
cleaned_name:
	unique values:  50528                    missing "":  0/146333
filing_number:
	unique values:  51296                    missing .:  0/146333
entity_name:
	unique values:  51136                    missing "":  0/146333
*/

* because the joinby command creates duplicates, we only keep a single observation
*	for each dunsnumber-cleaned_name-filing_number combination
* NOTE: because I changed the process so that duplicates are removed before the
*	joining, this duplicate removal deletes zero observations now. It is left
*	as an illustration.
duplicates drop dunsnumber cleaned_name filing_number, force

count
* 59339

codebook dunsnumber
/*
-----------------------------------------------------------------------------------------------------------------------------------------------------------
dunsnumber                                                                                                                                       DunsNumber
-----------------------------------------------------------------------------------------------------------------------------------------------------------
unique values:  58246                    missing "":  0/59339
*/
save joinX.dta, replace

********************************** JOIN(2) *************************************
* Then join the joined set with the NETData (full)

joinby dunsnumber using NETSData.dta, unmatched(both)
tab _merge
/*
                       _merge |      Freq.     Percent        Cum.
------------------------------+-----------------------------------
           only in using data |    300,772       83.52       83.52
both in master and using data |     59,339       16.48      100.00
------------------------------+-----------------------------------
                        Total |    360,111      100.00
						
The results are 59,339 matches between unique entity_name-filing_number 
	pairings and companies in NETS. There are 58246 unique Duns#s with 
	1093 duplicates. These duplicated Duns#s mean the company has filed
	multiple times with the TSoS, which is in line with G&S (2016)'s idea of
	re-registration of entrepreneurial firms.
*/
keep if _merge==3
drop _merge

* create new target variable (HT, not a Branch establishment, and for-profit)
gen target = 0
replace target = 1 if(target_NETS==1 & target_SoS==1)
notes target: binary indicator where a 1 means the establishment has been ///
	high-tech at least once, is not a branch, and is a for-profit entity.
erase NETSDataNAMESX.dta
erase SoSDataNAMESX.dta
save startupsX.dta, replace

timer off 1
timer list 1
