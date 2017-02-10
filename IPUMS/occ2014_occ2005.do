/*
Converts ACS OCC codes from 2010-11 and 2012-14 and converts
	to ACS OCC codes from 2005 so they can be used with Dorn's subfile

	see https://usa.ipums.org/usa/volii/occ_acs.shtml

Evan Johnston
*/

/*
	replace occ = [2005 occ equivalent] if occ == [20** occ code(s)]
*/

	replace occ = 130 if inlist(occ, 135, 136, 137)
	replace occ = 210 if occ==205
	replace occ = 320 if occ==4465
	replace occ = 560 if occ==565
	replace occ = 620 if inlist(occ, 630, 640, 650)
	replace occ = 4960 if occ==726
	replace occ = 720 if occ==725
	replace occ = 730 if inlist(occ, 735, 740, 425)
	replace occ = 1000 if inlist(occ, 1005, 1006, 1107)
	replace occ = 1110 if inlist(occ, 1106, 1107, 1030)
	replace occ = 1040 if occ==1050
	replace occ = 1100 if occ==1105
	replace occ = 1810 if occ==1815
	replace occ = 1960 if inlist(occ, 1950, 1965)
	replace occ = 2020 if inlist(occ, 2015, 2016, 2025)
	replace occ = 2100 if occ==2105
	replace occ = 2150 if occ==2160
	replace occ = 2140 if occ==2145
	replace occ = 2820 if occ==2825
	replace occ = 3130 if inlist(occ, 3255, 3256, 3258)
	replace occ = 3240 if occ==3245
	replace occ = 3410 if occ==3420
	replace occ = 3530 if occ==3535
	replace occ = 3650 if inlist(occ, 3645, 3646, 3647, 3648, 3649, 3655)
	replace occ = 3920 if inlist(occ, 3930, 3945)
	replace occ = 3950 if occ==3955
	replace occ = 4550 if inlist(occ, 9050, 9415)
	replace occ = 4960 if inlist(occ, 726, 4965)
	replace occ = 5930 if inlist(occ, 5165, 5940)
	replace occ = 6000 if occ==6005
	replace occ = 6350 if occ==6355
	replace occ = 6510 if occ==6515
	replace occ = 6760 if inlist(occ, 6765, 6540)
	replace occ = 7310 if occ==7315
	replace occ = 7620 if occ==7630
	replace occ = 8230 if occ==8256
	replace occ = 8260 if occ==8255
	replace occ = 8960 if occ==8965
	
* remove trailing zero
replace occ = trunc(occ / 10)
