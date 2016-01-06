/*
Converts OCC 2013 codes to OCC 2005 so they can be ran with
Dorn's subfile

Evan Johnston
*/

*pre truncation 2013 OCC fixes

/*
	replace occ = [2005 occ equivalent] if occ == [2013 occ code(s)]
	2013 code(s) and title(s)
		-> 2005 code and title
*/

	replace occ = 181 if occ == 730
		*730 (Market Research Analysts and Marketing Specialists)
			*-> 181 (Market and Survey Researchers)
	replace occ = 320 if occ == 4465
		*4465 (Morticians, Undertakers, and Funeral directors)
			*-> 320 (Funeral Directors)
	replace occ = 620 if inlist(occ, 630, 640, 650)
		*630 (HR Workers)
		*640 (Compensation, Benefits, and Job Analysis Specialists
		*650 (Training and Development Specialists)
			*-> 620 (HR, Training, and Labor Relations Specialists)
	replace occ = 730 if occ == 740
		*740 (Business Operations Specialsts, All Other)
			*-> 730 (Other Business Operations Specialists)
	replace occ = 1000 if inlist(occ,1106,1107)
		*1107 (Computer Occupations, All Other)
		*1106 (Computer Network Architects) }
			*-> 1000 (Computer Scientists and Systems Analysts)
	replace occ = 1110 if inlist(occ,1007,1030)
		*1007 (Information Security Analysts)
		*1030 (Web Developers)
			*-> 1110 (Network Systems and Data Communications Analysts)
	replace occ = 1040 if occ == 1050
		*1050 (Computer Support Specialists)
			*-> 1040 (Computer Support Specialists)
	replace occ = 1960 if occ == 1950
		*1950 (Social Science Research Assistants)
			*->1960 (Other Life, Physical, and Social Science Technicians)
	replace occ = 2020 if inlist(occ, 2015, 2016)
		*2015 (Probation Officers nad Correctional Treatment Specialists
		*2016 (Social and Human Service Assistants
			*->2020 (Miscellaneous Community and Social Service Specialists
	replace occ = 2140 if occ == 2105
		*2105 (Judicial Law Clerks)
			*-> 2140 (Paralegals and Legal Assistants)
	replace occ = 2150 if occ == 2160
		*2160 (Miscellaneous Legal Support Workers)
			*->2150 (Miscellaneous Legal Support Workers)
	replace occ = 3130 if inlist(occ, 3255,3256,3258)
		*3255 (Registered Nurses)
		*3256 (Nurse Anesthetists)
		*3258 (Nurse Practitioners and Nurse Midwives)
			*-> 3130 (Registered Nurses)
	replace occ = 3410 if occ == 3420
		*3420 (Health Practitioner Support Technologists and Technicians)
			*-> 3410 (Health Diagnosing and Treating Practitioner Support Technicians)
	replace occ = 3650 if inlist(occ,3645,3646,3647,3648,3649,3655)
		*3645 (Medical Assistants)
		*3646 (Medical Transcriptionists)
		*3647 (Pharmacy Aides)
		*3648 (Veterinary Assistants and Laboratory Animal Caretakers)
		*3649 (Phlebotmists)
			*-> 3650 (Medical Assistants and Other Healthcare Support 
				*Occupations, except dental assistants)
	replace occ = 3920 if occ == 3930
		*3930 (Security Guards and Gaming Surveillance Officers)
			*-> 3920 (Security Guards and Gaming Surveillance Officers)
	replace occ = 4550 if inlist(occ,9050,9415)
		*9050 (Flight Attendants)
		*9415 (Transportation Attendants, Except Flight Attendants)
			*->4550 (Transportation Attendants)
	replace occ = 5930 if inlist(occ,5940,5165)
		*5940 (Miscellaneous office and administrative support workers including 
			*desktop publishers)
		*5165 (Financial Clerks, All Other)
			*->5930 (Miscellaneous office and administrative support workers 
				*including desktop publishers)
	replace occ = 7620 if occ == 7630
		*7620 (Other Installation, Maintenance, and Repair Workers Including 
				*Commercial Divers, and Signal and Track Switch Repairers)
			*->7630	(Other Installation, Maintenance, and Repair Workers 
				*Including Wind Turbine Service Technicians, and Commercial 
				*Divers, and Signal and Track Switch Repairers)
	replace occ = 8960	if occ == 7855
		*7855 (Production Workers, All Other)
			*->8960	(Production Workers, All Other)
	replace occ = 8230 if occ == 8256
		*8256 (Print Binding and Finishing Workers)
			*-> 8230 (Bookbinders and Bindery Workers)
	replace occ = 8260 if occ == 8255
		*8255 (Print Machine Operators)
			*-> 8260 (Print Machine Operators)
/*
2013 occ codes include details at the 4th digit
example: 3655 -> 365.5 -> 365
The above fixes are for codes that would have not matched after truncation.
All other 2013 occ codes will match their 2005 counter parts after truncation.	
*/

gen occ_new13 = trunc(occ / 10)
	rename occ occ_old13  
	rename occ_new13 occ
	
