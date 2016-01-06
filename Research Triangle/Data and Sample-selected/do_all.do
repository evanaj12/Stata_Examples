* Run all figure files for Research Triangle
* EVAN JOHNSTON

*Change location to folder with datasets
cd "C:\Users\eaj628\Documents\StataData\Data"

* Employment and Ethnicity files
*  Set filepath1 variable to figure .do files location
local filepath1 "C:\Users\eaj628\Documents\StataData\Employment and Ethnicity\Paper Files - Research Triangle\"
do "`filepath1'figure 1\fig1.do"
do "`filepath1'figure 2\fig2.do"
do "`filepath1'figure 3\fig3.do"
do "`filepath1'figure 4\fig4.do"
do "`filepath1'figure 5\fig5.do"
do "`filepath1'figure 6\fig6.do"
do "`filepath1'figure 7\fig7.do"

do "`filepath1'table 1\table1.do"
do "`filepath1'table 2\table2.do"
do "`filepath1'table 3\table3.do"
do "`filepath1'table 4\table4.do"

* Employment and Gender files
*  Set filepath2 variable to figure .do files location
local filepath2 "C:\Users\eaj628\Documents\StataData\Employment and Gender\Research Triangle\"
do "`filepath2'gfigure 1\fig1.do"
do "`filepath2'gfigure 2 and 3\gender2_2.do"
do "`filepath2'gfigure 4\genderB_0.do"
do "`filepath2'gfigure 5 and table 1\genderD.do"
do "`filepath2'gfigure x\gender5_1_2.do"
do "`filepath2'gtable 2\genderD_1.do"

* Entrepreneurship files
*  Set filepath3 variable to figure .do files location
local filepath3 "C:\Users\eaj628\Documents\StataData\Entrepreneurship\Research Triangle\"
do "`filepath3'entrepren1.do"
do "`filepath3'entrepren2.do"
do "`filepath3'entrepren3.do"
