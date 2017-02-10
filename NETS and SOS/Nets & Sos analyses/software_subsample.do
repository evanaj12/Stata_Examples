* the software subsample
use NETSData.dta, clear

keep if it_sector_first==3

notes startup
tab startup

notes quality_startup
tab quality_startup

tab startup if (1990<=firstyear & firstyear<=2010)
tab quality_startup if (1990<=firstyear & firstyear<=2010)

keep if (quality_startup==1 & (1990<=firstyear & firstyear<=2010) )
save NETS_software_quality_startups.dta, replace
