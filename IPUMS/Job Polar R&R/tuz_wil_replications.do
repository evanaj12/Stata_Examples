/* Replication of Tuzeman & Willis (2013) table 1
	
	a(i,s)= b(i,s)+w(i,s); where e(i,s,t,g,r) is employment (full time jobs) of
		sector i (high-tech and non-high-tech)
		skill level s (low, production-middle, clerical-middle, high)
		time period t (1980, 1990, 2000, 2009-5y, 2014-5y)
		group g (male, female, male and female)
		region r (US, Austin MSA)
		
	b(i,s)= e(i,s,t0)/e(i,t0)*(e(i,t1)/e(t1) - e(i,t0)/e(t0))
	w(i,s)= e(i,t1)/e(t1)*(e(i,s,t1)/e(i,t1) - e(i,s,t0)/e(i,t0))
	
	b(i,s) is the change of employment share in sector i, skill group s from
		t0 and t1 due to shifts BETWEEN sectors
	w(i,s) is the change of employment share in sector i, skill group s from
		t0 to t1 due to shifts WITHIN sectors
	a(i,s) is the total change of employment share in sector i, skill group s
		from t0 to t1
		
	Calculations are separated by group g, region r

	Evan Johnston 2/9/17
*/

set more off
timer clear 1
timer on 1

* 1990_5p  2009_5y
foreach year in 1980_5p 2000_5p 2014_5y {
	use ipums_`year'.dta, clear
	
	keep if fulltime==1 & selfemp==0
	keep perwt sex austin high_tech it_sector occ4cat
	
	*Divide into 3 occupations groups
	gen occ3cat = 1 if occ4cat==1
	replace occ3cat = 2 if inlist(occ4cat, 2, 3)
	replace occ3cat = 3 if occ4cat==4

	label define occ3label ///
		1 "High-Skill Occupations" ///
		2 "Middle-Skill Occupations" ///
		3 "Low-Skill Occupations"
	label values occ3cat occ3label
	note occ3cat: Aggregated occupation categories into 3 broad skill groups

	gen worker_`year'=perwt
	
	save temp1.dta, replace	
	foreach region in atx us {
		use temp1.dta, clear
		
		drop if "`region'"=="atx" & austin==0

		save temp2.dta, replace		
		foreach group in male female all {
			use temp2.dta, clear
			
			drop if "`group'"=="male" & sex==2
			drop if "`group'"=="female" & sex==1
			
			* number of male/female/all workers in region-year
			egen emp_`year'_`region'_`group'=sum(worker_`year')
			local emp_`year'_`region'_`group'=emp_`year'_`region'_`group'
			drop emp_`year'_`region'_`group'
			
			save temp3.dta, replace
			foreach sector in ht nht {
				use temp3.dta, clear
				
				drop if "`sector'"=="ht" & high_tech==0
				drop if "`sector'"=="nht" & high_tech==1
				
				* number of male/female/all workers in high-tech/non-high-tech sectors in region-year
				egen `sector'_emp_`year'_`region'_`group'=sum(worker_`year')
				local `sector'_emp_`year'_`region'_`group'=`sector'_emp_`year'_`region'_`group'
				drop `sector'_emp_`year'_`region'_`group'
				
				save temp4.dta, replace
				*foreach skill in low cler prod high {
				foreach skill in low mid high {
					use temp4.dta, clear
					/*
					drop if "`skill'"=="low" & occ4cat!=4
					drop if "`skill'"=="cler" & occ4cat!=3
					drop if "`skill'"=="prod" & occ4cat!=2
					drop if "`skill'"=="high" & occ4cat!=1
					*/
					drop if "`skill'"=="low" & occ3cat!=3
					drop if "`skill'"=="mid" & occ3cat!=2
					drop if "`skill'"=="high" & occ3cat!=1
					
					* number of male/female/all workers in high-tech/non-high-tech sectors in low/(clerical/production)/high skilled jobs in region-year
					egen `skill'_`sector'_emp_`year'_`region'_`group'=sum(worker_`year')
					local `skill'_`sector'_emp_`year'_`region'_`group'=`skill'_`sector'_emp_`year'_`region'_`group'
					drop `skill'_`sector'_emp_`year'_`region'_`group'
				}
			}
		}
	}
}
macro list

timer off 1
timer list 1
timer on 1
* 4 min (all years)
* 1 min 20 sec (1980 and 2014)

clear
set obs 1
foreach region in atx us {
	foreach group in male female all {
		*foreach skill in low cler prod high {
		foreach skill in low mid high {
			foreach sector in ht nht {
			*b(i, s)
				gen `sector'_`skill'_between_`region'_`group' = ///
				(``skill'_`sector'_emp_1980_5p_`region'_`group''/``sector'_emp_1980_5p_`region'_`group'')* ///
				(``sector'_emp_2014_5y_`region'_`group''/`emp_2014_5y_`region'_`group'' - ///
				``sector'_emp_1980_5p_`region'_`group''/`emp_1980_5p_`region'_`group'')*100
			*w(i, s)
				gen `sector'_`skill'_within_`region'_`group' = ///
				(``sector'_emp_2014_5y_`region'_`group''/`emp_2014_5y_`region'_`group'')* ///
				(``skill'_`sector'_emp_2014_5y_`region'_`group''/``sector'_emp_2014_5y_`region'_`group'' - ///
				``skill'_`sector'_emp_1980_5p_`region'_`group''/``sector'_emp_1980_5p_`region'_`group'')*100
			}
		}
	}
}
				
xpose, clear varname

timer off 1
timer list 1
* 45 sec (1980 and 2014)

*export excel tuz_wil_tbl_1_80_14.xlsx, first (var) replace
export excel tuz_wil_tbl_1_80_14_3skill.xlsx, first (var) replace

* repeat for 1980 and 2000
clear
set obs 1
foreach region in atx us {
	foreach group in male female all {
		*foreach skill in low cler prod high {
		foreach skill in low mid high {
			foreach sector in ht nht {
				gen `sector'_`skill'_between_`region'_`group' = ///
				(``skill'_`sector'_emp_1980_5p_`region'_`group''/``sector'_emp_1980_5p_`region'_`group'')* ///
				(``sector'_emp_2000_5p_`region'_`group''/`emp_2000_5p_`region'_`group'' - ///
				``sector'_emp_1980_5p_`region'_`group''/`emp_1980_5p_`region'_`group'')*100
				
				gen `sector'_`skill'_within_`region'_`group' = ///
				(``sector'_emp_2000_5p_`region'_`group''/`emp_2000_5p_`region'_`group'')* ///
				(``skill'_`sector'_emp_2000_5p_`region'_`group''/``sector'_emp_2000_5p_`region'_`group'' - ///
				``skill'_`sector'_emp_1980_5p_`region'_`group''/``sector'_emp_1980_5p_`region'_`group'')*100
			}
		}
	}
}
				
xpose, clear varname

*export excel tuz_wil_tbl_1_80_00_3skill.xlsx, first (var) replace
export excel tuz_wil_tbl_1_80_00_3skill.xlsx, first (var) replace

*repeat for 2000 and 2014-5y
clear
set obs 1
foreach region in atx us {
	foreach group in male female all {
		*foreach skill in low cler prod high {
		foreach skill in low mid high {
			foreach sector in ht nht {
				gen `sector'_`skill'_between_`region'_`group' = ///
				(``skill'_`sector'_emp_2000_5p_`region'_`group''/``sector'_emp_2000_5p_`region'_`group'')* ///
				(``sector'_emp_2014_5y_`region'_`group''/`emp_2014_5y_`region'_`group'' - ///
				``sector'_emp_2000_5p_`region'_`group''/`emp_2000_5p_`region'_`group'')*100
				
				gen `sector'_`skill'_within_`region'_`group' = ///
				(``sector'_emp_2014_5y_`region'_`group''/`emp_2014_5y_`region'_`group'')* ///
				(``skill'_`sector'_emp_2014_5y_`region'_`group''/``sector'_emp_2014_5y_`region'_`group'' - ///
				``skill'_`sector'_emp_2000_5p_`region'_`group''/``sector'_emp_2000_5p_`region'_`group'')*100
			}
		}
	}
}
				
xpose, clear varname

*export excel tuz_wil_tbl_1_00_14.xlsx, first (var) replace
export excel tuz_wil_tbl_1_00_14_3skill.xlsx, first (var) replace

erase temp1.dta
erase temp2.dta
erase temp3.dta
erase temp4.dta

/* Data used in Replication of Tuzeman & Willis (2013) chart 4
	Evan Johnston 2/7/17
*/

foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	use ipums_`year'.dta, clear
	
	keep if fulltime==1 & selfemp==0
	keep perwt sex austin high_tech occ4cat
	gen worker_`year'=perwt	
	collapse (sum) worker_`year', by(sex austin high_tech occ4cat)
	save emp_`year'.dta, replace
}

use emp_1980_5p.dta, clear
merge 1:1 sex austin high_tech occ4cat using emp_1990_5p.dta
drop _merge
merge 1:1 sex austin high_tech occ4cat using emp_2000_5p.dta
drop _merge
merge 1:1 sex austin high_tech occ4cat using emp_2009_5y.dta
drop _merge
merge 1:1 sex austin high_tech occ4cat using emp_2014_5y.dta
drop _merge

sort occ4cat high_tech sex austin

export excel emp_table.xlsx, first (var) replace

foreach year in 1980_5p 1990_5p 2000_5p 2009_5y 2014_5y {
	erase emp_`year'.dta
}
