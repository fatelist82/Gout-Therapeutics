

/// change working directory if needed
cd "E:\Eugene\PDFs\Lubuntu_pdf\temp\gout_therpeutics\Final_YJ\AchievementDiff_Final\RawData"

log using "AchievementDifference", text replace

********************** Achievement Difference Forest Plot (based on Allopurinol as a comparator) *************

//// all patients

import delimited "Allopurinol_AchievedOutcome_T3.csv", clear  

label define group_name 1 "Febuxostat" 2 "Lesinurad" 3 "Rasburicase"
label value group group_name
keep if dose_freq=="Daily"
drop if drg != "Febuxostat"

label variable dose "Dose(mg/dL)" 

sort group dose

gen group1 = 1 if group==1 & dose==40
replace group1 = 2 if group==1 & dose==80
replace group1 = 3 if group==1 & dose==120
replace group1 = 4 if group==2 & dose==400
replace group1 = 5 if group==2 & dose==600
replace group1 = 6 if group==3

keep if group==1

sort rd

meta esize drgac drgnac ctrlac ctrlnac, studylabel(article_authors) random(reml) esize(rdiff)
meta summarize, random subgroup(group1) sort(group dose)
meta forestplot _id _data _plot _esci dose, random subgroup(group) sort(dose) noohet noohom nogbhom
graph export AchievementDiff_Allopurinol6_ForestPlot.pdf, replace

meta bias, egger
meta funnel, random
graph export AchievementDiff_Allopurinol6_FunnelPlot.pdf, replace

meta trimfill, random
meta summarize, random subgroup(group1) sort(group dose)
meta forestplot, random cumulative(dose, by(group)) noohet noohom nogbhom
graph export AchievementDiff_Allopurinol6_Acc_ForestPlot.pdf, replace

log close

