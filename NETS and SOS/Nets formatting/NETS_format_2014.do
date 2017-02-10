/* Evan Johnston
read in and format NETS data (2014)

*/

********************************* Read in Each ASCII file **********************
***************************** import variables in correct type *****************
* imports data from NETS Austin CBSA sample datasets
*	string and numeric columns based on the inital ASCII txt files
*	note that numeric codes (e.g. DunsNumber, Zipcode, SIC/NAICS codes)
*	are stored as strings to maintain leading zeros.
*	See varTypes.xlsx or column types.xlsx for breakdown
set more off

timer clear 2
timer on 2
* approx 6 min 11 seconds

* NETS 2014 main file
import delimited using NETS2014_AustinCBSA_with_Address.txt, ///
	stringcols(1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24  ///
		25 26 29 30 31 34 35 88 89 90 91 92 93 94 95 96 97 98 99 100 101 102 103 ///
		104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 ///
		122 123 124 125 126 127 128 129 130 131 132 133 134 135 136 137 138 139 ///
		140 141 142 143 144 145 146 147 148 149 150 151 152 153 154 155 156 157 ///
		158 159 160 161 162 163 164 165 166 167 168 169 170 171 172 173 174 175 ///
		176 177 178 179 231 232 233 234 235 236 237 238 239 240 241 242 243 244 ///
		245 246 247 248 249 250 251 252 253 254 255 312 323 314 316 317 318 323 ///
		324 325 326 327 328 329 330 331 332 333 336 337 338 339 340 341 342) ///
	numericcols(27 28 32 33 36 37 38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 ///
		53 54 55 56 57 58 59 60 61 62 63 64 65 67 68 69 70 71 72 736 74 75 76 ///
		77 78 79 80 81 82 83 84 85 86 87 180 181 182 183 184 185 186 187 188 189 ///
		190 191 192 193 194 195 196 197 198 199 200 201 202 203 204 205 206 207 ///
		208 209 210 211 212 213 214 215 216 217 218 219 220 221 222 223 224 225 ///
		226 227 228 229 230 256 257 258 259 260 261 262 263 264 265 266 267 268 ///
		269 270 271 272 273 274 275 276 277 278 279 280 281 282 283 284 285 286 ///
		287 288 289 290 291 292 293 294 295 296 297 298 299 300 301 302 303 304 ///
		305 306 307 308 309 310 311 319 320 321 322 334 335) ///
	clear
	save NETSData1.dta, replace

* NETS 2014 move file
import delimited Moves2014_AustinCBSA_with_Address.txt, ///
	stringcols(1 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 22 23 24 25 26 29 32) ///
	numericcols(18 19 20 21 27 28 30 31 33) ///
	clear
save NETSData2.dta, replace

* NETS 2014 NAICS file
* all strings (NAICS are numeric codes)
import delimited NAICS2014_AustinCBSA.txt, stringcols(_all) clear
save NETSData3.dta, replace

* do file for HT and IT-Sector NAICS codes (see do file for info)
do HT_IT_Sectors_NAICS_create.do
* HT runtime: 84 sec
********************************* Combine (Merge) the Data *********************
use NETSData1.dta, clear

merge 1:1 dunsnumber using NETSData3.dta
/*
    Result                           # of obs.
    -----------------------------------------
    not matched                             0
    matched                           396,271   (_merge==3)
    -----------------------------------------
*/
drop _merge

save NETSData.dta, replace

* fix error in legalstat variable (single case) and create labels
replace legalstat="" if legalstat=="AUSTIN"
replace legalstat="K" if legalstat==""
gen legalstat_n=0
replace legalstat_n=1 if legalstat=="G"
replace legalstat_n=2 if legalstat=="H"
replace legalstat_n=3 if legalstat=="I"
replace legalstat_n=4 if legalstat=="J"
replace legalstat_n=5 if legalstat=="K"
	label define legalstat_n_label ///
	 1 "proprietorship" ///
	 2 "partnership" ///
	 3 "corporation" ///
	 4 "non-profit" ///
	 5 "blank"
	label values legalstat_n legalstat_n_label
drop legalstat

* do file for exclusions and startups (see do file for info)
do exclusions_and_startup_candidates.do
* startups runtime: 23 sec

* variables indicating if zipcode (and zipcode_first) are in the Austin MSA zip list used for SoS
gen austin_zip = 0
gen austin_zipfirst = 0

rename zipcode entity_zip
merge m:1 entity_zip using austin_zips.dta
replace austin_zip = 1 if _merge==3
drop _merge
rename entity_zip zipcode

rename zipcode_first entity_zip
merge m:1 entity_zip using austin_zips.dta
replace austin_zipfirst = 1 if _merge==3
drop _merge
rename entity_zip zipcode_first

********************************* General Cleaning *****************************
set more off

* Trim string variables
ds, has(type string)
foreach var of varlist `r(varlist)' {
	replace `var' = trim(itrim(lower(`var')))
}

******************************* Other Modifications ****************************

* insert descriptive notes
note dunsnumber: d-u-n-s establishment number
note company: business name
note tradename: trade name
note address: street address
note city: city name
note state: state postal abbreviation
note zipcode: 5-digit postal zip code
note zip4: 4-digit zip code extension
note officer: officer
note title: officer title
note area: telephone area code
note phone: telephone number
note region: metropolitan area description
note hqduns: ultimate/parent/hq d-u-n-s number (highest reported)
note hqcompany: headquarters business name
note hqtradename: headquarters trade name
note hqaddress: headquarters street address
note hqcity: headquarters city name
note hqstate: headquarters 2-digit postal state abbreviation
note hqzipcode: headquarters 5-digit postal zip code
note hqzip4: headquarters 4-digit zip code extension
note hqofficer: headquarters officer
note hqtitle: headquarters officer title
note hqarea: headquarters telephone area code
note hqphone: headquarters telephone number
note subsidiary: "yes” indicates corporation that is more than 50 percent owned by another corporation; may also have branches/subsidiaries of own.
note related: number of establishments with same hqduns in 2013 or its lastyear
note kids: number of establishments with this establishment as hqduns in 2013 or its lastyear
note cbsa: establishment cbsa/metro division code
note fipscounty: establishment fips county code
note citycode: dun & bradstreet city code
note latitude: establishment latitude
note longitude: establishment longitude
note levelcode: level at which latitude/longitude provided (d = block face, b = block group, t = census tract centroid, z = zip code centroid, n = not coded, s = street level)
note estcat: last type of location (single location, headquarters, branch)
note emp90: establishment employment at location in 1990
note empc90: employees here code 1990 (0 = actual figure, 1 = bottom of range, 2= d&b estimate, 3 = walls estimate)
note emp91: establishment employment at location in 1991
note empc91: employees here code 1991 (see empc90 for definitions)
note emp92: establishment employment at location in 1992
note empc92: employees here code 1992 (see empc90 for definitions)
note emp93: establishment employment at location in 1993
note empc93: employees here code 1993 (see empc90 for definitions)
note emp94: establishment employment at location in 1994
note empc94: employees here code 1994 (see empc90 for definitions)
note emp95: establishment employment at location in 1995
note empc95: employees here code 1995 (see empc90 for definitions)
note emp96: establishment employment at location in 1996
note empc96: employees here code 1996 (see empc90 for definitions)
note emp97: establishment employment at location in 1997
note empc97: employees here code 1997 (see empc90 for definitions)
note emp98: establishment employment at location in 1998
note empc98: employees here code 1998 (see empc90 for definitions)
note emp99: establishment employment at location in 1999
note empc99: employees here code 1999 (see empc90 for definitions)
note emp00: establishment employment at location in 2000
note empc00: employees here code 2000 (see empc90 for definitions)
note emp01: establishment employment at location in 2001
note empc01: employees here code 2001 (see empc90 for definitions)
note emp02: establishment employment at location in 2002
note empc02: employees here code 2002 (see empc90 for definitions)
note emp03: establishment employment at location in 2003
note empc03: employees here code 2003 (see empc90 for definitions)
note emp04: establishment employment at location in 2004
note empc04: employees here code 2004 (see empc90 for definitions)
note emp05: establishment employment at location in 2005
note empc05: employees here code 2005 (see empc90 for definitions)
note emp06: establishment employment at location in 2006
note empc06: employees here code 2006 (see empc90 for definitions)
note emp07: establishment employment at location in 2007
note empc07: employees here code 2007 (see empc90 for definitions)
note emp08: establishment employment at location in 2008
note empc08: employees here code 2008 (see empc90 for definitions)
note emp09: establishment employment at location in 2009
note empc09: employees here code 2009 (see empc90 for definitions)
note emp10: establishment employment at location in 2010
note empc10: employees here code 2010 (see empc90 for definitions)
note emp11: establishment employment at location in 2011
note empc11: employees here code 2011 (see empc90 for definitions)
note emp12: establishment employment at location in 2012
note empc12: employees here code 2012 (see empc90 for definitions)
note emp13: establishment employment at location in 2013
note empc13: employees here code 2013 (see empc90 for definitions)
note emp14: establishment employment at location in 2014
note empc14: employees here code 2014 (see empc90 for definitions)
note emphere: establishment employment at location (last year)
note empherec: employees here (last year) code (see empc90 for definitions)
note sizecat: employment size category (last year)
note sic2: last primary standard industrial classification (sic) code – 2-digits
note sic3: last primary standard industrial classification (sic) code – 3-digits
note sic4: last primary standard industrial classification (sic) code – 4-digits
note sic6: last primary standard industrial classification (sic) code – 6-digits
note sic8: last primary standard industrial classification (sic) code – 8-digits
note sic8_2: last secondary standard industrial classification (sic) code – 8-digits
note sic8_3: last tertiary standard industrial classification (sic) code – 8-digits
note sic8_4: last fourth standard industrial classification (sic) code – 8-digits
note sic8_5: last fifth standard industrial classification (sic) code – 8-digits
note sic8_6: last sixth standard industrial classification (sic) code – 8-digits
note sicchange: change in 3-digit sic between 1990-2013 (“yes” or “no”)
note sic90: primary standard industrial classification (sic) code – 8-digits (1990)
note sic91: primary standard industrial classification (sic) code – 8-digits (1991)
note sic92: primary standard industrial classification (sic) code – 8-digits (1992)
note sic93: primary standard industrial classification (sic) code – 8-digits (1993)
note sic94: primary standard industrial classification (sic) code – 8-digits (1994)
note sic95: primary standard industrial classification (sic) code – 8-digits (1995)
note sic96: primary standard industrial classification (sic) code – 8-digits (1996)
note sic97: primary standard industrial classification (sic) code – 8-digits (1997)
note sic98: primary standard industrial classification (sic) code – 8-digits (1998)
note sic99: primary standard industrial classification (sic) code – 8-digits (1999)
note sic00: primary standard industrial classification (sic) code – 8-digits (2000)
note sic01: primary standard industrial classification (sic) code – 8-digits (2001)
note sic02: primary standard industrial classification (sic) code -- 8-digits (2002)
note sic03: primary standard industrial classification (sic) code -- 8-digits (2003)
note sic04: primary standard industrial classification (sic) code -- 8-digits (2004)
note sic05: primary standard industrial classification (sic) code -- 8-digits (2005)
note sic06: primary standard industrial classification (sic) code -- 8-digits (2006)
note sic07: primary standard industrial classification (sic) code -- 8-digits (2007)
note sic08: primary standard industrial classification (sic) code -- 8-digits (2008)
note sic09: primary standard industrial classification (sic) code -- 8-digits (2009)
note sic10: primary standard industrial classification (sic) code -- 8-digits (2010)
note sic11: primary standard industrial classification (sic) code -- 8-digits (2011)
note sic12: primary standard industrial classification (sic) code -- 8-digits (2012)
note sic13: primary standard industrial classification (sic) code -- 8-digits (2013)
note sic14: primary standard industrial classification (sic) code -- 8-digits (2014)
note industry: primary sic industry name in last year
note industrygroup: primary 3-digit sic industry name in last year
note hqduns90: ultimate/parent/hq d-u-n-s? number (highest reported) in 1990
note hqduns91: ultimate/parent/hq d-u-n-s? number (highest reported) in 1991
note hqduns92: ultimate/parent/hq d-u-n-s? number (highest reported) in 1992
note hqduns93: ultimate/parent/hq d-u-n-s? number (highest reported) in 1993
note hqduns94: ultimate/parent/hq d-u-n-s? number (highest reported) in 1994
note hqduns95: ultimate/parent/hq d-u-n-s? number (highest reported) in 1995
note hqduns96: ultimate/parent/hq d-u-n-s? number (highest reported) in 1996
note hqduns97: ultimate/parent/hq d-u-n-s? number (highest reported) in 1997
note hqduns98: ultimate/parent/hq d-u-n-s? number (highest reported) in 1998
note hqduns99: ultimate/parent/hq d-u-n-s? number (highest reported) in 1999
note hqduns00: ultimate/parent/hq d-u-n-s? number (highest reported) in 2000
note hqduns01: ultimate/parent/hq d-u-n-s? number (highest reported) in 2001
note hqduns02: ultimate/parent/hq d-u-n-s? number (highest reported) in 2002
note hqduns03: ultimate/parent/hq d-u-n-s? number (highest reported) in 2003
note hqduns04: ultimate/parent/hq d-u-n-s? number (highest reported) in 2004
note hqduns05: ultimate/parent/hq d-u-n-s? number (highest reported) in 2005
note hqduns06: ultimate/parent/hq d-u-n-s? number (highest reported) in 2006
note hqduns07: ultimate/parent/hq d-u-n-s? number (highest reported) in 2007
note hqduns08: ultimate/parent/hq d-u-n-s? number (highest reported) in 2008
note hqduns09: ultimate/parent/hq d-u-n-s? number (highest reported) in 2009
note hqduns10: ultimate/parent/hq d-u-n-s? number (highest reported) in 2010
note hqduns11: ultimate/parent/hq d-u-n-s? number (highest reported) in 2011
note hqduns12: ultimate/parent/hq d-u-n-s? number (highest reported) in 2012
note hqduns13: ultimate/parent/hq d-u-n-s? number (highest reported) in 2013
note hqduns14: ultimate/parent/hq d-u-n-s? number (highest reported) in 2014
note hqdunschange: hq change indicator (yes = headquarters changed 1990-2014, no = no change in headquarters)
note fips90: fips county code in january 1990
note fips91: fips county code in january 1991
note fips92: fips county code in january 1992
note fips93: fips county code in january 1993
note fips94: fips county code in january 1994
note fips95: fips county code in january 1995
note fips96: fips county code in january 1996
note fips97: fips county code in january 1997
note fips98: fips county code in january 1998
note fips99: fips county code in january 1999
note fips00: fips county code in january 2000
note fips01: fips county code in january 2001
note fips02: fips county code in january 2002
note fips03: fips county code in january 2003
note fips04: fips county code in january 2004
note fips05: fips county code in january 2005
note fips06: fips county code in january 2006
note fips07: fips county code in january 2007
note fips08: fips county code in january 2008
note fips09: fips county code in january 2009
note fips10: fips county code in january 2010
note fips11: fips county code in january 2011
note fips12: fips county code in january 2012
note fips13: fips county code in january 2013
note fips14: fips county code in january 2014
note fipschange: yes = county changed 1990-2014, no = no change in county
note outofbis: year of out-of-business/bankruptcy filing indicator (may still be active)
note yearstart: year start reported by establishment
note paydexmin90: minimum dun & bradstreet paydex score for jan '89 - jan '90 12
note paydexmax90: maximum dun & bradstreet paydex score for jan '89 - jan '90
note paydexmin91: minimum dun & bradstreet paydex score for jan '90 - jan '91
note paydexmax91: maximum dun & bradstreet paydex score for jan '90 - jan '91
note paydexmin92: minimum dun & bradstreet paydex score for jan '91 - jan '92
note paydexmax92: maximum dun & bradstreet paydex score for jan '91 - jan '92
note paydexmin93: minimum dun & bradstreet paydex score for jan '92 - jan '93
note paydexmax93: maximum dun & bradstreet paydex score for jan '92 - jan '93
note paydexmin94: minimum dun & bradstreet paydex score for jan '93 - jan '94
note paydexmax94: maximum dun & bradstreet paydex score for jan '93 - jan '94
note paydexmin95: minimum dun & bradstreet paydex score for jan '94 - jan '95
note paydexmax95: maximum dun & bradstreet paydex score for jan '94 - jan '95
note paydexmin96: minimum dun & bradstreet paydex score for jan '95 - jan '96
note paydexmax96: maximum dun & bradstreet paydex score for jan '95 - jan '96
note paydexmin97: minimum dun & bradstreet paydex score for jan '96 - jan '97
note paydexmax97: maximum dun & bradstreet paydex score for jan '96 - jan '97
note paydexmin98: minimum dun & bradstreet paydex score for jan '97 - jan '98
note paydexmax98: maximum dun & bradstreet paydex score for jan '97 - jan '98
note paydexmin99: minimum dun & bradstreet paydex score for jan '98 - jan '99
note paydexmax99: maximum dun & bradstreet paydex score for jan '98 - jan '99
note paydexmin00: minimum dun & bradstreet paydex score for jan '99 - jan '00
note paydexmax00: maximum dun & bradstreet paydex score for jan '99 - jan '00
note paydexmin01: minimum dun & bradstreet paydex score for jan '00 - jan '01
note paydexmax01: maximum dun & bradstreet paydex score for jan '00 - jan '01
note paydexmin02: minimum dun & bradstreet paydex score for jan '01 - jan '02
note paydexmax02: maximum dun & bradstreet paydex score for jan '01 - jan '02
note paydexmin03: minimum dun & bradstreet paydex score for jan '02 - jan '03
note paydexmax03: maximum dun & bradstreet paydex score for jan '02 - jan '03
note paydexmin04: minimum dun & bradstreet paydex score for jan '03 - jan '04
note paydexmax04: maximum dun & bradstreet paydex score for jan '03 - jan '04
note paydexmin05: minimum dun & bradstreet paydex score for jan '04 - jan '05
note paydexmax05: maximum dun & bradstreet paydex score for jan '04 - jan '05
note paydexmin06: minimum dun & bradstreet paydex score for jan '05 - jan '06
note paydexmax06: maximum dun & bradstreet paydex score for jan '05 - jan '06
note paydexmin07: minimum dun & bradstreet paydex score for jan '06 - jan '07
note paydexmax07: maximum dun & bradstreet paydex score for jan '06 - jan '07
note paydexmin08: minimum dun & bradstreet paydex score for jan '07 - jan '08
note paydexmax08: maximum dun & bradstreet paydex score for jan '07 - jan '08
note paydexmin09: minimum dun & bradstreet paydex score for jan '08 - jan '09
note paydexmax09: maximum dun & bradstreet paydex score for jan '08 - jan '09
note paydexmin10: minimum dun & bradstreet paydex score for jan '09 - jan '10
note paydexmax10: maximum dun & bradstreet paydex score for jan '09 - jan '10
note paydexmin11: minimum dun & bradstreet paydex score for jan '10 - jan '11
note paydexmax11: maximum dun & bradstreet paydex score for jan '10 - jan '11
note paydexmin12: minimum dun & bradstreet paydex score for jan '11 - jan '12
note paydexmax12: maximum dun & bradstreet paydex score for jan '11 - jan '12
note paydexmin13: minimum dun & bradstreet paydex score for jan '12 - jan '13
note paydexmax13: maximum dun & bradstreet paydex score for jan '12 - jan '13
note paydexmax14: maximum dun & bradstreet paydex score for jan '12 - jan '14
note dnbrating90: dun & bradstreet rating in 1990
note dnbrating91: dun & bradstreet rating in 1991
note dnbrating92: dun & bradstreet rating in 1992
note dnbrating93: dun & bradstreet rating in 1993
note dnbrating94: dun & bradstreet rating in 1994
note dnbrating95: dun & bradstreet rating in 1995
note dnbrating96: dun & bradstreet rating in 1996
note dnbrating97: dun & bradstreet rating in 1997
note dnbrating98: dun & bradstreet rating in 1998
note dnbrating99: dun & bradstreet rating in 1999
note dnbrating00: dun & bradstreet rating in 2000
note dnbrating01: dun & bradstreet rating in 2001
note dnbrating02: dun & bradstreet rating in 2002
note dnbrating03: dun & bradstreet rating in 2003
note dnbrating04: dun & bradstreet rating in 2004
note dnbrating05: dun & bradstreet rating in 2005
note dnbrating06: dun & bradstreet rating in 2006
note dnbrating07: dun & bradstreet rating in 2007
note dnbrating08: dun & bradstreet rating in 2008
note dnbrating09: dun & bradstreet rating in 2009
note dnbrating10: dun & bradstreet rating in 2010
note dnbrating11: dun & bradstreet rating in 2011
note dnbrating12: dun & bradstreet rating in 2012
note dnbrating13: dun & bradstreet rating in 2013
note dnbrating14: dun & bradstreet rating in 2014
note sales90: establishment sales 1990 ($)
note salesc90: establishment sales code 1990 (0 = actual, 1 = bottom of range, 2 =d&b estimate, 3 = walls estimate)
note sales91: establishment sales 1991 ($)
note salesc91: establishment sales code 1991 (see salesc90 for definitions)
note sales92: establishment sales 1992 ($)
note salesc92: establishment sales code 1992 (see salesc90 for definitions)
note sales93: establishment sales 1993 ($)
note salesc94: establishment sales code 1993 (see salesc90 for definitions)
note sales94: establishment sales 1994 ($)
note salesc94: establishment sales code 1994 (see salesc90 for definitions)
note sales95: establishment sales 1995 ($)
note salesc95: establishment sales code 1995 (see salesc90 for definitions)
note sales96: establishment sales 1996 ($)
note salesc96: establishment sales code 1996 (see salesc90 for definitions)
note sales97: establishment sales 1997 ($)
note salesc97: establishment sales code 1997 (see salesc90 for definitions)
note sales98: establishment sales 1998 ($)
note salesc98: establishment sales code 1998 (see salesc90 for definitions)
note sales99: establishment sales 1999 ($)
note salesc99: establishment sales code 1999 (see salesc90 for definitions)
note sales00: establishment sales 2000 ($)
note salesc00: establishment sales code 2000 (see salesc90 for definitions)
note sales01: establishment sales 2001 ($)
note salesc01: establishment sales code 2001 (see salesc90 for definitions)
note sales02: establishment sales 2002 ($)
note salesc02: establishment sales code 2002 (see salesc90 for definitions)
note sales03: establishment sales 2003 ($)
note salesc03: establishment sales code 2003 (see salesc90 for definitions)
note sales04: establishment sales 2004 ($)
note salesc04: establishment sales code 2004 (see salesc90 for definitions)
note sales05: establishment sales 2005 ($)
note salesc05: establishment sales code 2005 (see salesc90 for definitions)
note sales06: establishment sales 2006 ($)
note salesc06: establishment sales code 2006 (see salesc90 for definitions)
note sales07: establishment sales 2007 ($)
note salesc07: establishment sales code 2007 (see salesc90 for definitions)
note sales08: establishment sales 2008 ($)
note salesc08: establishment sales code 2008 (see salesc90 for definitions)
note sales09: establishment sales 2009 ($)
note salesc09: establishment sales code 2009 (see salesc90 for definitions)
note sales10: establishment sales 2010 ($)
note salesc10: establishment sales code 2010 (see salesc90 for definitions)
note sales11: establishment sales 2011 ($)
note salesc11: establishment sales code 2011 (see salesc90 for definitions)
note sales12: establishment sales 2012 ($)
note salesc12: establishment sales code 2012 (see salesc90 for definitions)
note sales13: establishment sales 2013 ($)
note salesc13: establishment sales code 2013 (see salesc90 for definitions)
note sales14: establishment sales 2014 ($)
note salesc14: establishment sales code 2014 (see salesc90 for definitions)
note saleshere: establishment sales (last year, $)
note salesherec: establishment sales (last year) code (see salesc90 for definitions)
note salesgrowth: quartile of last 3-yr sales growth (1=fastest growth, 4=slowest, 2=middle 50%)
note salesgrowthpeer: quartile of last 3-yr sales growth relative to 3-digit sic peers (1=fastest growth, 4=slowest, 2=middle 50%)
note moveyears: year(s) of establishment move(s)
note lastmove: year of last move
note movesic4: primary standard industrial classification (sic) code -- 4-digits (in move year)
note origincity: origin city name
note originstate: origin state abbreviation
note originzip: origin 5-digit postal zip code
note destcity: destination city name
note deststate: destination state abbreviation
note destzip: destination 5-digit postal zip code
note moveemp: establishment employment (here) in move year
note empc: employees here code in move year (0 = actual figure, 1 = bottom of range, 2 = d&b estimate, 3 = walls estimate)
note movesales: establishment sales estimate in move year ($)
note movesalesc: establishment sales code in move year (see empc for definitions)
note pubpriv: public/private indicator-last (y = public, n = private or government)
note legalstat: legal status-last (g = proprietorship, h = partnership, i = corporation, j = non-profit, blank = na)
note foreignown: foreign owned-last (1991 & after: y = yes, space = no)
note impexpind: import/export indicator-last (b = both, e = export, i = import, space = neither)
note govtcontra: government contracts/grants indicator-last (1998 & after: y=yes, n= no)
note minority: minority owned indicator-last (1991 & after: y = minority owned, n = not minority owned)
note genderceo: gender of executive in record-last (2000 & after: m = male, f = female, b = either, blank = unknown)
note womenowned: controlling interest in firm held by woman-last (1998 & after: y = yes, n = no)
note relocate: move indicator (0=never, 1=at least once 1990-2007, 2=at least once 2008-10, or 3=moved in 2011-12?)
note moveoften: moved more than once 1990-2013 (y=yes, n= no)
note cottage: indicator-last (2001 & after: c = yes) indicates private business in residence with less than 3 employees and not in sics 40,43-46, 60, 84, 86 or 91-97.
note firstyear: first year establishment was active (1989=existed before 1990)
note lastyear: last year establishment was active (2014 = active)
note address_first: street address in first year
note city_first: city name in first year (upper & lower case)
note state_first: state postal abbreviation in first year
note zipcode_first: 5-digit postal zip code in first year
note cbsa_first: establishment fips msa(cbsa) code in first year
note fipscounty_first: establishment fips county code in first year
note citycode_first: dun & bradstreet city code in first year
note naics90: primary industrial classification (naics 2012) code – 6-digits (1990)
note naics91: primary industrial classification (naics 2012) code – 6-digits (1991)
note naics92: primary industrial classification (naics 2012) code – 6-digits (1992)
note naics93: primary industrial classification (naics 2012) code – 6-digits (1993)
note naics94: primary industrial classification (naics 2012) code – 6-digits (1994)
note naics95: primary industrial classification (naics 2012) code – 6-digits (1995)
note naics96: primary industrial classification (naics 2012) code – 6-digits (1996)
note naics97: primary industrial classification (naics 2012) code – 6-digits (1997)
note naics98: primary industrial classification (naics 2012) code – 6-digits (1998)
note naics99: primary industrial classification (naics 2012) code – 6-digits (1999)
note naics00: primary industrial classification (naics 2012) code – 6-digits (2000)
note naics01: primary industrial classification (naics 2012) code – 6-digits (2001)
note naics02: primary industrial classification (naics 2012) code – 6-digits (2002)
note naics03: primary industrial classification (naics 2012) code – 6-digits (2003)
note naics04: primary industrial classification (naics 2012) code – 6-digits (2004)
note naics05: primary industrial classification (naics 2012) code – 6-digits (2005)
note naics06: primary industrial classification (naics 2012) code – 6-digits (2006)
note naics07: primary industrial classification (naics 2012) code – 6-digits (2007)
note naics08: primary industrial classification (naics 2012) code – 6-digits (2008)
note naics09: primary industrial classification (naics 2012) code – 6-digits (2009)
note naics10: primary industrial classification (naics 2012) code – 6-digits (2010)
note naics11: primary industrial classification (naics 2012) code – 6-digits (2011)
note naics12: primary industrial classification (naics 2012) code – 6-digits (2012)
note naics13: primary industrial classification (naics 2012) code – 6-digits (2013)
note naics14: primary industrial classification (naics 2012) code – 6-digits (2014)
note moveyear: year of move
note movesic: primary standard industrial classification (sic) code -- 8-digits (in move year)
note origincity: origin city name
note originstate: origin state 2-digit postal abbreviation
note originzip: origin 5-digit postal zip code
note destcity: destination city name
note deststate: destination state 2-digit postal abbreviation
note destzip: destination 5-digit postal zip code
note moveemp: establishment employment (here) in move year
note empc: employees here code in move year (0 = actual figure, 1 = bottom of range, 2 = d&b estimate, 3 = walls estimate)
note movesales: establishment sales estimate in move year
note movesalesc: establishment sales code in move year (0 = actual, 1 = bottom of range, 2 = d&b estimate, 3 = walls estimate)
note moveoften: moved more than once 1990-2012 ("yes" or "no")
note sizecat: employment size category in move year
note estcat: last type of location (single location, headquarters, branch, division)
note austin_zip: binary indicator if zipcode is in the list of Austin MSA zipcodes used for SoS
note austin_zipfirst: binary indicator if first zipcode is in the list of Austin MSA zipcodes used for SoS

save NETSData.dta, replace

timer off 2
timer list 2

