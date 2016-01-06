/*
Code to combine 2000 and 2005 ind1990 to indnaics crosswalks
and keeps only the HT industries, labeling the indnaics codes

Evan Johnston

Uses datasets from 2000 (5%) and 2005 (1%) census, ACS respectively to
create a crosswalk between the indnaics and ind1990 variables from IPUMS.
The indnaics variable was created from 1997 NAICS codes in 2000 and from
2002 NAICS codes after 2003, so we use both of these to create the crosswalk.

The High Tech definitions are taken from Hecker (2005) definition of HT industry.

Variables:
	ind1990: IPUMS industrial classification
	indnaics: IPUMS NAICS variable

Files that need to be in this directory:
	ind1990_indnaics_00_5p.dta				2000 (5%) dataset
	ind1990_indnaics_05_1p.dta				2005 (1%) dataset
	ind1990_indnaics_crosswalk_ht_2000.do	Crosstab for INDNAICS and IND1990 
											for 2000 Census (5%)
	ind1990_indnaics_crosswalk_ht_2005.do	Crosstab for INDNAICS and IND1990
											for 2005 Census (1%)
	HT_crosswalk_csv.csv					dataset for final HT crosswalk
											from ipums INDNAICS (2003 on) to NAICS 2002 table
*/

*changes directory to where Stata extract file is
*cd "C:\Users\eaj628\Documents\StataData\Migration Stata replication\NAICS to IND1990 crosswalk"

*runs the 2 .do files for 2000 and 2005
do ind1990_indnaics_crosswalk_ht_2000.do
do ind1990_indnaics_crosswalk_ht_2005.do

*merges the 2000 and 2005 crosswalks
merge 1:1 indnaics using ind1990_indnaics_crosswalk_ht_2000.dta
drop _merge

*crosswalk1: shows path from NAICS to INDNAICS to IND1990 for all industries
save crosswalk1.dta, replace
export excel crosswalk1.xlsx, first(var) replace

*crosswalk_ht1: shows path from NAICS to INDNAICS to IND1990 for HT industries
drop if high_tech!=1
merge 1:m indnaics using HT_crosswalk_csv.dta
keep titles naics02 indnaics ind1990_code ind1990
save crosswalk_ht1.dta, replace
export excel crosswalk_ht1.xlsx, first(var) replace

*crosswalk_ht2: shows path from NAICS to IND1990 for HT industries
drop indnaics
sort titles naics02 ind1990_code ind1990
quietly by titles naics02 ind1990_code ind1990:  gen dup = cond(_N==1,0,_n)
drop if dup>1
drop dup
sort naics02
save crosswalk_ht2.dta, replace
export excel crosswalk_ht2.xlsx, first(var) replace
