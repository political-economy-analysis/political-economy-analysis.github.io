* Data: https://github.com/political-economy-analysis/aca-dd-code-sample/blob/main/lab3.dta.zip
* (unzip to lab3.dta and set the cd path below to the folder containing it)

clear all

cd"/Users/alexander/Documents/phd/stata/"

log using lab3.log, replace

use lab3.dta, clear

display "Table 1. Demographic, Socioeconomic and Insurance Characteristics"

* all observations
sum anyhi emphi_dep emphi indiv govhi employed unemployed age white black hispanic mar ft_student hsdo hsg somcol colgrd bad_hlth [weight=p_weight]

* by age group
forvalues k = 1 / 3 {
    sum anyhi emphi_dep emphi indiv govhi employed unemployed age white black hispanic mar ft_student hsdo hsg somcol colgrd bad_hlth [weight=p_weight] if age_group==`k'
}

local effects mar_sep10 after_oct10 fedelig elig_mar10 elig_oct10
local exp_vars age17-age18  age20-age25 age27-age29 trend female ue hispanic white asian other student mar fpl_ratio fpl_ratio_2 ue_treat y2009 y2010 month2-month12 st_trend_1-st_trend_55
display "Table 2: Effect of ACA on Coverage of Young Adults 19-25 years: Main DD Results (regression)"
foreach instype in anyhi emphi_dep indiv emphi govhi{
    areg `instype' `effects' `exp_vars' [weight=p_weight], absorb(fipstate) cluster(fipstate)
}

display "Table 2: Effect of ACA on Coverage of Young Adults 19-25 years: Main DD Results (unconditional DD)"
sum anyhi emphi_dep indiv emphi govhi [weight=p_weight] if after_oct10==0 & mar_sep10 ==0 & fedelig==1
sum anyhi emphi_dep indiv emphi govhi [weight=p_weight] if after_oct10==0 & mar_sep10 ==0 & fedelig==0
sum anyhi emphi_dep indiv emphi govhi [weight=p_weight] if after_oct10==1 & fedelig==1
sum anyhi emphi_dep indiv emphi govhi [weight=p_weight] if after_oct10==1 & fedelig==0

* CLOSE LOG FILE
log close
