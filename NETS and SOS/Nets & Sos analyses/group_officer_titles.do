/*
group officer titles

Evan Johnston
*/

use SOSData, clear

duplicates drop filing_number, force

gen officer_title_id = 0
replace officer_title_id = 15 if officer_title!=""

replace officer_title_id = 1 if ///
	(	regexm(officer_title, "chief") & ///
		regexm(officer_title, "officer")	) | ///
	regexm(officer_title, "ceo") | regexm(officer_title, "cfo") | regexm(officer_title, "cio")
replace officer_title_id = 2 if regexm(officer_title, "director")
replace officer_title_id = 3 if regexm(officer_title, "partner")
replace officer_title_id = 4 if regexm(officer_title, "govern")
replace officer_title_id = 5 if regexm(officer_title, "manager")
replace officer_title_id = 6 if regexm(officer_title, "member")
replace officer_title_id = 7 if regexm(officer_title, "owner")
replace officer_title_id = 8 if regexm(officer_title, "president")
replace officer_title_id = 9 if regexm(officer_title, "secretary")
replace officer_title_id = 10 if regexm(officer_title, "treasur")
replace officer_title_id = 11 if ///
	regexm(officer_title, "vice president") | ///
	regexm(officer_title, "vp") | regexm(officer_title, "vice")
replace officer_title_id =12 if regexm(officer_title, "found")
replace officer_title_id =13 if regexm(officer_title, "chair")
replace officer_title_id =14 if regexm(officer_title, "principal")

	label define officer_title_id_label ///
	 0 "none reported" ///
	 1 "C*O" ///
	 2 "Director" ///
	 3 "Partner" ///
	 4 "Governing Person" ///
	 5 "Manager" ///
	 6 "Member" ///
	 7 "Owner" ///
	 8 "President" ///
	 9 "Secretary" ///
	 10 "Treasurer" ///
	 11 "VP" ///
	 12 "Founder" ///
	 13 "Chairperson" ///
	 14 "Principal" ///
	 15 "Other"
	label values officer_title_id officer_title_id_label
	
tab officer_title_id
