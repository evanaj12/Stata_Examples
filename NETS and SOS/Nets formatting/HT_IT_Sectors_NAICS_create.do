/*
Creates HT, IT, and Software indicators for NETS

Evan Johnston
*/
set more off
timer clear 1
timer on 1

* create HT NAICS dataset is not already in the working directory
*do ImportHT_IT_NAICS.do

* use the NAICS NETS data
use NETSData3.dta, clear
*drop ht_ind software ht_title

* initialize variables:
*	ht_ind_i: binary indicator of HT-industry status in year i
*	ht_title_i: NAICS (2012) title of HT-industry in year i
*	it_sector_i: indicates the IT-sector classification in year i

forvalues i = 90(1) 99{
	gen ht_ind_`i' = 0
	gen ht_title_`i' = "."
	gen it_sector_`i' = 0
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14{
	gen ht_ind_`i' = 0
	gen ht_title_`i' = "."
	gen it_sector_`i' = 0
}

forvalues i = 90(1) 99{
	rename naics`i' HTNAICS
	merge m:1 HTNAICS using HTNAICS.dta
	
	replace ht_ind_`i' = 1 if _merge==3
	replace ht_title_`i' = HTNAICS_Title if _merge==3
	
	replace it_sector_`i' = 6 if ht_ind_`i' == 1

	replace it_sector_`i' = 1 if inlist(HTNAICS, "333242", "334412", "334413", ///
		"334416", "334417", "334418")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "334419", "334613", "334614", ///
		"335311", "335312", "335313")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "335314", "335911", "335912", ///
		"335921", "335929", "335931")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "335932", "335991", "335999")

	replace it_sector_`i' = 2 if inlist(HTNAICS, "334111", "334112", "334118", ///
		"333314", "334210", "334220")
	replace it_sector_`i' = 2 if inlist(HTNAICS, "334290", "334310", "334513", ///
		"334515", "334519")
		
	replace it_sector_`i' = 3 if inlist(HTNAICS, "511210", "518210", "541511", ///
		"541512", "541513", "541519")
	
	replace it_sector_`i' = 4 if inlist(HTNAICS, "423410", "423420", "423430", ///
		"423440", "423450", "423460")
	replace it_sector_`i' = 4 if inlist(HTNAICS, "423490", "517110", "517210", ///
		"517410", "517911", "517919")
	replace it_sector_`i' = 4 if HTNAICS=="519130"
		
	replace it_sector_`i' = 5 if inlist(HTNAICS, "541310", "541320", "541330", ///
		"541340", "541350", "541360")
	replace it_sector_`i' = 5 if inlist(HTNAICS, "541370", "541380", "541611", ///
		"541612", "541613", "541614")
	replace it_sector_`i' = 5 if inlist(HTNAICS, "541618", "541620", "541690", ///
		"541711", "541712", "541720")
		
	rename HTNAICS naics`i'
	drop _merge HTNAICS_Title
	drop if dunsnumber==""
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14{
	rename naics`i' HTNAICS
	merge m:1 HTNAICS using HTNAICS.dta
	
	replace ht_ind_`i' = 1 if _merge==3
	replace ht_title_`i' = HTNAICS_Title if _merge==3
	
	replace it_sector_`i' = 6 if ht_ind_`i' == 1

	replace it_sector_`i' = 1 if inlist(HTNAICS, "333242", "334412", "334413", ///
		"334416", "334417", "334418")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "334419", "334613", "334614", ///
		"335311", "335312", "335313")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "335314", "335911", "335912", ///
		"335921", "335929", "334418")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "335314", "335911", "335912", ///
		"335921", "335929", "335931")
	replace it_sector_`i' = 1 if inlist(HTNAICS, "335932", "335991", "335999")

	replace it_sector_`i' = 2 if inlist(HTNAICS, "334111", "334112", "334118", ///
		"333314", "334210", "334220")
	replace it_sector_`i' = 2 if inlist(HTNAICS, "334290", "334310", "334513", ///
		"334515", "334519")
		
	replace it_sector_`i' = 3 if inlist(HTNAICS, "511210", "518210", "541511", ///
		"541512", "541513", "541519")
	
	replace it_sector_`i' = 4 if inlist(HTNAICS, "423410", "423420", "423430", ///
		"423440", "423450", "423460")
	replace it_sector_`i' = 4 if inlist(HTNAICS, "423490", "517110", "517210", ///
		"517410", "517911", "517919")
	replace it_sector_`i' = 4 if HTNAICS=="519130"
		
	replace it_sector_`i' = 5 if inlist(HTNAICS, "541310", "541320", "541330", ///
		"541340", "541350", "541360")
	replace it_sector_`i' = 5 if inlist(HTNAICS, "541370", "541380", "541611", ///
		"541612", "541613", "541614")
	replace it_sector_`i' = 5 if inlist(HTNAICS, "541618", "541620", "541690", ///
		"541711", "541712", "541720")
	
	rename HTNAICS naics`i'
	drop _merge HTNAICS_Title
	drop if dunsnumber==""
}

label define it_sector_label ///
	1 "Semiconductor & Electrical Equipment Mfg." ///
	2 "Computer & Related Equipment Mfg." ///
	3 "Software Services" ///
	4 "Commercial Equipment Wholesalers (Dell) & Telecommunications" ///
	5 "Other High-Tech Business Services" ///
	6 "Other High-Tech"

forvalues i = 90(1) 99{
	label values it_sector_`i' it_sector_label
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14{
	label values it_sector_`i' it_sector_label
}

gen ht_ind = 0
gen ht_title_last = "."
gen ht_naics_last = "."
gen it_sector_last = 0

forvalues i = 90(1) 99{
	replace ht_ind = ht_ind + ht_ind_`i'
	replace ht_title_last = ht_title_`i' if ht_title_`i'!="."
	replace ht_naics_last = naics`i' if ht_title_`i'!="."
	replace it_sector_last = it_sector_`i' if it_sector_`i'>0
	notes ht_ind_`i': see ht_ind_90
	notes ht_title_`i': see ht_title_90
	notes it_sector_`i': see it_sector_90
}
foreach i in 00 01 02 03 04 05 06 07 08 09 10 11 12 13 14{
	replace ht_ind = ht_ind + ht_ind_`i'
	replace ht_title_last = ht_title_`i' if ht_title_`i'!="."
	replace ht_naics_last = naics`i' if ht_title_`i'!="."
	replace it_sector_last = it_sector_`i' if it_sector_`i'>0
	notes ht_ind_`i': see ht_ind_90
	notes ht_title_`i': see ht_title_90
	notes it_sector_`i': see it_sector_90
}

gen ht_title_first = "."
gen ht_naics_first = "."
gen it_sector_first = 0
gen naics_first = "."
foreach i in 14 13 12 11 10 09 08 07 06 05 04 03 02 01 00{
	replace ht_title_first = ht_title_`i' if ht_title_`i'!="."
	replace ht_naics_first = naics`i' if ht_title_`i'!="."
	replace it_sector_first = it_sector_`i' if it_sector_`i'>0
	replace naics_first = naics`i' if naics`i' != ""
}
forvalues i = 99(-1) 90{
	replace ht_title_first = ht_title_`i' if ht_title_`i'!="."
	replace ht_naics_first = naics`i' if ht_title_`i'!="."
	replace it_sector_first = it_sector_`i' if it_sector_`i'>0
	replace naics_first = naics`i' if naics`i' != ""
}
replace naics_first= naics_first+"0" if length(naics_first)==5
replace naics_first= naics_first+"00" if length(naics_first)==4
replace naics_first= naics_first+"000" if length(naics_first)==3

label values it_sector_first it_sector_label
label values it_sector_last it_sector_label

* notes information
notes replace ht_ind_90 in 1: binary indicator of HT-industry status in year i (90)
notes replace ht_title_90 in 1: NAICS (2012) title of HT-industry in year i (90)
notes replace it_sector_90 in 1: indicates the IT-sector classification in year i (90)
notes ht_ind: total number of years a firm reported a HT-industry
notes ht_naics_first: first NAICS of HT-industry classification
notes ht_title_first: first title of HT-industry classification
notes it_sector_first: first HT-IT sector
notes ht_title_last: most recent title of HT-industry classification
notes ht_naics_last: most recent NAICS of HT-industry classification
notes it_sector_last: most recent HT-IT sector
notes naics_first: first NAICS of industry classification

save NETSData3.dta, replace

timer off 1
timer list 1
