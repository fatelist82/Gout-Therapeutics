// change the working directory if needed
cd "E:\Eugene\PDFs\Lubuntu_pdf\temp\gout_therpeutics\Final_YJ\sUALowering_Final\RawData"

log using "UricLowering", text replace

//################### Hyperuricemic Population ########################################//
// This file includes the codes for the uric lowering ///////////////////////////////////
// We conducted analyses for the Febuxostat, Allopurinol, and Topiroxostat //////////////
// Each drug has three types of the models: all, no-ckd, and with-ckd patients /////
// Each type of models inciude 1. crude model and 2. covariate model ////////////////////


********************** Febuxostat Percent Urate Lowering  *************

** All patients in the crude model **
import delimited Febuxostat_updated.csv, clear 
keep if filter == "High"
drop if filter==""
keep if dose_frequency=="Daily"
drop if no_data ==1
drop if per==0
gen ln_dose = ln(dose)

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 

summarize
hist dose


metareg per dose, wsse(perse) reml
margins, at(dose = (20(20)240))
margins, at(dose = (50(20)150))

// Drawing a forest plot using admetan
drop if per == .
replace group =1 if dose == 20
replace group =2 if dose == 40
replace group =3 if dose == 60
replace group =4 if dose == 80
replace group =5 if dose == 90
replace group =6 if dose == 120
replace group =7 if dose == 240
label define group_name 1 "Daily: 20mg" 2  "Daily: 40mg" 3  "Daily: 60mg" 4  "Daily: 80mg" 5  "Daily: 90mg" 6  "Daily: 120mg" 7  "Daily: 240mg"
label value group group_name
admetan per perse, lcols(article_authors dose number_arm days) by(group) sortby(dose) forest(hetstat(p) leftj) saving(ekwon, replace) nograph model(dl)
use ekwon, clear
label var _LABELS `"`"{bf:Febuxostat}"' `"{bf:Study ID}"'"'
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0  //subheadings: _USE==3; overall: _USE==5
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==3  //subheadings: _USE==3; overall: _USE==5
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==5  //subheadings: _USE==3; overall: _USE==5
label var dose `"`"{bf:Dose}"' `"{bf:(mg)}"'"'
label var number_arm `"`"{bf:Sample}"' `"{bf:Size}"'"'
label var days `"`"{bf:Treatment}"' `"{bf:Days}"'"'
label var _EFFECT `"`"{bf:% Urate Change}"' `"{bf:(95% CI)}"'"'
label var _WT `"`"{bf:% Study}"' `"{bf:Weight}"'"'
forestplot, useopts nostats nowt rcols(_EFFECT _WT) range(0 80) astext(65)

// Export the graph to a file
graph export "UricLowering_Febuxostat_Forest_Plot.pdf", replace


** All patients in the covariate model **
import delimited Febuxostat_updated.csv, clear 
keep if filter == "High"
drop if filter==""
keep if dose_frequency=="Daily"
drop if no_data ==1
drop if per==0
gen ln_dose = ln(dose)

// Generate the variable, male_dominant
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .9459459
replace male_c = 0 if male < .9459459
replace male_c = . if male == .
encode region, gen (region_rc)
summarize
sktest male
drop if male_c ==.
drop if per ==.


label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
label list region_rc

xi: metareg per dose i.ckd number_arm days i.region_rc i.male_c, wsse(perse) reml // China as a comparator
margins, at(dose = (20(20)240))

** Covariate model with a different collection site as a reference **

table region_rc // China; europe; Japan; N America

recode region_rc (1=2) (2=1) (3=3) (4=4), gen (region_rc1)
xi: metareg per dose i.ckd number_arm days i.region_rc1 i.male_c, wsse(perse) reml  // Europe as a comparator

recode region_rc (1=2) (2=3) (3=1) (4=4), gen (region_rc2)
xi: metareg per dose i.ckd number_arm days i.region_rc2 i.male_c, wsse(perse) reml // Japan as a comparator

recode region_rc (1=2) (2=3) (3=4) (4=1), gen (region_rc3)
xi: metareg per dose i.ckd number_arm days i.region_rc3 i.male_c, wsse(perse) reml // North America as a comparator




********************** Allopurinol Percent Urate Lowering  *************


** All patients in the crude model **
import delimited Allopurinol_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1

summarize

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
metareg per dose,wsse(perse) reml
margins, at(dose = (50(35)461))
margins, at(dose = (50(20)150))


// Drawing a forest plot using admetan
drop if per == .
replace group =1 if dose == 50
replace group =2 if dose == 100
replace group =3 if dose == 150
replace group =4 if dose == 200
replace group =5 if dose == 300
replace group =6 if dose == 461
label define group_name 1 "Daily: 50mg" 2  "Daily: 100mg" 3  "Daily: 150mg" 4  "Daily: 200mg" 5  "Daily: 300mg" 6  "Daily: 461mg"
label value group group_name
admetan per perse, lcols(article_authors dose number_arm days) by(group) sortby(dose) forest(hetstat(p) leftj) saving(ekwon, replace) nograph model(dl)
use ekwon, clear
label var _LABELS `"`"{bf:Allopurinol}"' `"{bf:Study ID}"'"'
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0  //subheadings: _USE==3; overall: _USE==5
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==3  //subheadings: _USE==3; overall: _USE==5
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==5  //subheadings: _USE==3; overall: _USE==5
label var dose `"`"{bf:Dose}"' `"{bf:(mg)}"'"'
label var number_arm `"`"{bf:Sample}"' `"{bf:Size}"'"'
label var days `"`"{bf:Treatment}"' `"{bf:Days}"'"'
label var _EFFECT `"`"{bf:% Urate Change}"' `"{bf:(95% CI)}"'"'
label var _WT `"`"{bf:% Study}"' `"{bf:Weight}"'"'
forestplot, useopts nostats nowt rcols(_EFFECT _WT) range(0 50) astext(65)

// Export the graph to a file
graph export "UricLowering_Allopurinol_Forest_Plot.pdf", replace

** All patients in the covariate model **
import delimited Allopurinol_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1
replace region = "MiddleEastern" if region == "Iran" | region == "Turkey"  // Merge two regions with a few sample
encode region, gen (region_rc)
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .8154762 
replace male_c = 0 if male < .8154762 
replace male_c = . if male == .
drop if per == .
drop if number_arm == .
drop if male_c == .
drop if days == .
summarize
sktest male
drop if male_c ==.
drop if per ==.

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 

xi: metareg per dose i.ckd number_arm days i.region_rc i.male_c, wsse(perse) reml // China as a comparator
margins, at(dose = (50(35)461))


table region_rc // china; europe; japan; middle Eastern; Multi national ;N.America
label list region_rc

** Covariate model with a different collection site as a reference **

recode region_rc (1=2) (2=1) (3=3) (4=4) (5=5) (6=6), gen (region_rc1) 
xi: metareg per dose i.ckd number_arm days i.region_rc1 i.male_c, wsse(perse) reml  // Europe as a comparator

recode region_rc (1=2) (2=3) (3=1) (4=4) (5=5) (6=6), gen (region_rc2)
xi: metareg per dose i.ckd number_arm days i.region_rc2 i.male_c, wsse(perse) reml // Japan as a comparator


recode region_rc (1=2) (2=3) (3=4) (4=1) (5=5) (6=6), gen (region_rc3)
xi: metareg per dose i.ckd number_arm days i.region_rc3 i.male_c, wsse(perse) reml // Middle East. as a comparator

recode region_rc (1=2) (2=3) (3=4) (4=5) (5=1) (6=6), gen (region_rc4)
xi: metareg per dose i.ckd number_arm days i.region_rc4 i.male_c, wsse(perse) reml // MultiNational. as a comparator

recode region_rc (1=2) (2=3) (3=4) (4=5) (5=6) (6=1), gen (region_rc5)
xi: metareg per dose i.ckd number_arm days i.region_rc5 i.male_c, wsse(perse) reml // N.America as a comparator


** Patients without CKD in the crude model **
import delimited Allopurinol_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1
keep if ckd==0

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
metareg per dose,wsse(perse) reml

** Patients without CKD in the covariate model **
import delimited Allopurinol_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1
keep if ckd==0

encode region, gen (region_rc)
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .9836102
replace male_c = 0 if male < .9836102
replace male_c = . if male == .

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
//xi: metareg per dose i.ckd number_arm days i.region_rc i.male_c, wsse(perse)
//insufficient obs. (n=4)

** Patients with CKD in the crude model **
import delimited Allopurinol_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1
keep if ckd==1

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
metareg per dose,wsse(perse) reml


** Patients with CKD in the covariate model **
import delimited Allopurinol_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1
keep if ckd==1

replace region = "MiddleEastern" if region == "Iran" | region == "Turkey"

encode region, gen (region_rc)
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .7142857
replace male_c = 0 if male < .7142857
replace male_c = . if male == .

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
xi: metareg per dose i.ckd number_arm days i.region_rc i.male_c, wsse(perse) reml

********************** Topiroxostat Percent Urate Lowering  *************

** All patients in the crude model **
import delimited Topiroxostat_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1

summarize
label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
metareg per dose,wsse(perse) reml
margins, at(dose = (20(12)160))
margins, at(dose = (50(20)150))

// Drawing a forest plot using admetan
drop if per == .
replace group =1 if dose == 20
replace group =2 if dose == 40
replace group =3 if dose == 60
replace group =4 if dose == 80
replace group =5 if dose == 120
replace group =6 if dose == 160
label define group_name 1 "Daily: 20mg" 2  "Daily: 40mg" 3  "Daily: 60mg" 4  "Daily: 80mg" 5  "Daily: 120mg" 6  "Daily: 160mg"
label value group group_name
admetan per perse, lcols(article_authors dose number_arm days) by(group) sortby(dose) forest(hetstat(p) leftj) saving(ekwon, replace) nograph model(dl)
use ekwon, clear
label var _LABELS `"`"{bf:Topiroxostat}"' `"{bf:Study ID}"'"'
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==0  //subheadings: _USE==3; overall: _USE==5
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==3  //subheadings: _USE==3; overall: _USE==5
replace _LABELS = `"{bf:"' + _LABELS + `"}"' if _USE==5  //subheadings: _USE==3; overall: _USE==5
label var dose `"`"{bf:Dose}"' `"{bf:(mg)}"'"'
label var number_arm `"`"{bf:Sample}"' `"{bf:Size}"'"'
label var days `"`"{bf:Treatment}"' `"{bf:Days}"'"'
label var _EFFECT `"`"{bf:% Urate Change}"' `"{bf:(95% CI)}"'"'
label var _WT `"`"{bf:% Study}"' `"{bf:Weight}"'"'
forestplot, useopts nostats nowt rcols(_EFFECT _WT) range(0 55) astext(65)

// Export the graph to a file
graph export "UricLowering_Topiroxostat_Forest_Plot.pdf", replace

** All patients in the covariate model **
import delimited Topiroxostat_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1

// Generate the variable, male_dominant
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .9052325 
replace male_c = 0 if male < .9052325 
replace male_c = . if male == .
encode region, gen (region_rc)
drop if per ==.
drop if male_c ==.

summarize

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
xi: metareg per dose i.ckd number_arm days i.male_c, wsse(perse) reml
margins, at(dose = (20(12)160))


** Patients with a male dominant group in the covariance model **
import delimited Topiroxostat_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1

// Generate the variable, male_dominant
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .9052325 
replace male_c = 0 if male < .9052325 
replace male_c = . if male == .
encode region, gen (region_rc)
summarize

keep if male_c==1

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
xi: metareg per dose i.ckd number_arm days, wsse(perse) reml


** Patients with a male non-dominant group in the covariance model **
import delimited Topiroxostat_updated.csv, clear 
keep if filter=="High"
drop if filter==""
keep if dose_frequency == "Daily"
drop if no_data ==1

// Generate the variable, male_dominant
generate float male = number_male / (number_male + number_female) 
tabstat male, stats(median) save
gen male_c = 1 if male > .9052325 
replace male_c = 0 if male < .9052325 
replace male_c = . if male == .
encode region, gen (region_rc)
summarize

keep if male_c==0

label variable per  "Uric Acid Lowering (%)" 
label variable dose  "Daily Dose (mg/dL)" 
xi: metareg per dose i.ckd number_arm days, wsse(perse) reml


log close
