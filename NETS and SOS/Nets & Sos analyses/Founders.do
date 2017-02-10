* using TSoS to identify founders
use SoSData, clear
tab officer_title if regexm(officer_title,"found")

/*
                   OFFICER_TITLE |      Freq.     Percent        Cum.
---------------------------------+-----------------------------------
                     ceo founder |          2        0.31        0.31
     ceo of provident foundation |          1        0.16        0.47
                     ceo-founder |          1        0.16        0.62
        cfo-provident foundation |          1        0.16        0.78
    cfo-provident foundation inc |          1        0.16        0.93
      ch of provident foundation |          1        0.16        1.09
    ch of provident foundation i |          1        0.16        1.24
    chairman of provident founda |          2        0.31        1.55
                      co founder |         13        2.02        3.57
                      co-founder |        166       25.78       29.35
                       cofounder |         20        3.11       32.45
        director of edfoundation |          1        0.16       32.61
                director/founder |          1        0.16       32.76
                          founde |          1        0.16       32.92
                   founden phers |          1        0.16       33.07
                         founder |        393       61.02       94.10
                   founder & ceo |          1        0.16       94.25
                 founder and ceo |          2        0.31       94.57
            founder and director |          1        0.16       94.72
               founder and owner |          1        0.16       94.88
           founder and president |          1        0.16       95.03
                      founder ce |          1        0.16       95.19
                  founder member |          2        0.31       95.50
                       founder p |          1        0.16       95.65
                     founder-ceo |          1        0.16       95.81
               founder-principal |          1        0.16       95.96
               founding director |          1        0.16       96.12
               founding excc dir |          1        0.16       96.27
              founding executive |          1        0.16       96.43
                      founding m |          1        0.16       96.58
                     founding mb |          1        0.16       96.74
                    founding mem |          3        0.47       97.20
                 founding member |          8        1.24       98.45
                founding partner |          1        0.16       98.60
              founding president |          1        0.16       98.76
              founding principal |          1        0.16       98.91
               founding sr. past |          1        0.16       99.07
               president/founder |          1        0.16       99.22
        provident foundation inc |          4        0.62       99.84
          senior advisor founder |          1        0.16      100.00
---------------------------------+-----------------------------------
                           Total |        644      100.00
*/

gen founder=0
replace founder=1 if regexm(officer_title,"found")
keep if founder==1
save SoS_founders, replace
