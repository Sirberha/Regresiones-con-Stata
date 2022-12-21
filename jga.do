/***************************************************************************
* PROYECTO		: Tesis Jhan
* AÑO			: 2021
* AUTOR			: SIR BERNABÉ HUAMANCULÍ 
****************************************************************************

*********************************************************************************
*** PART 0: Set initial configurations and globals
********************************************************************************/

*** 0.0 Install required packages:
    ssc install xtabond2, all replace
*** 0.1 Setting up users	

*** 0.2 Setting up folders
	
	global project 		"G:..\"
	global codes		"${project}/codes"
	global data			"${project}/data"
	global outputs 		"${project}/outputs"
	global graphs		"${project}/graphs"
	
*********************************************************************************
*** PART 1: Manipolación de datos
********************************************************************************/
*** 1.1 Cargar data
	use 				"${data}/data.dta", clear
		 
	 
***	Declarando fromato de data
	xtset id año
*** promedios
	summarize 		lg lgc lgk lpbi lem Educación
	
*** Estimagion general
{
*********************************************************************************
*** PART 2: Esticación económetrica LSDV Model 
********************************************************************************/
	reg 			lpbi lg, robust
	estimates		store Pool
	
*********************************************************************************
*** PART 3: Esticación económetrica 'within' Model 
********************************************************************************/
	xtreg 			lpbi lg , fe vce(robust)
	estimates 		store Efecto_fijo
	
*********************************************************************************
*** PART 4: Esticación económetrica 'ramdom' Model 
********************************************************************************/
	xtreg 			lpbi lg , re vce(robust)
	estimates 		store Efecto_aleatorio
	outreg2 		[Pool Efecto_fijo Efecto_aleatorio ] ///
					using "$outputs/Resultado_1.xls", replace
*********************************************************************************
*** Implement  the Hausman Test
*********************************************************************************
	xtreg			lpbi lg , fe 
	est 			store fe
	xtreg			lpbi lg , re 
	est 			store re
	hausman 		fe re 
*********************************************************************************
*** Analisis de Autocorrelación y heterocedastecidad 
*********************************************************************************
	xtserial		lpbi lg calidad, output /* existe autocorelacion*/
	xtreg 			lpbi lg calidad, fe		/* exite heterocedastecidad*/
	xttest3 

*********************************************************************************
*** PART 5: Mejor Model con problemas autocorelacion rubusto
********************************************************************************/
	xtreg 			lpbi lg lem, re vce(robust) 
	estimate 		store modfe1
	xtreg 			lpbi lg c.lem#c.Educación, re vce(robust)
	estimate 		store modfe2
	outreg2 		[modfe1 modfe2] using "$outputs/resultados_2.docx", replace


*********************************************************************************
*** Implement panel dinamico Arellano bond
********************************************************************************* 
	xtabond2 		lpbi L.lpbi lg, gmm(L.(lpbi),collapse) iv(lg yr3-yr13 ) ///
					nodiffsargan noleveleq twostep robust 
	estimates 		store Arellado_bond1
	xtabond2 		lpbi L.lpbi lg lem, gmm(L.(lpbi),collapse) iv(lg lem yr3-yr13 ) ///
					nodiffsargan noleveleq twostep robust 
	estimates 		store Arellado_bond2			
	xtabond2 		lpbi L.lpbi lg c.lem#c.Educación, gmm(L.(lpbi),collapse) iv(lg yr3-yr13 ) ///
					nodiffsargan noleveleq twostep robust 
	estimates 		store Arellado_bond3
	
	outreg2			[ Pool modfe1 modfe2 Arellado_bond1 Arellado_bond2 Arellado_bond3] ///
					using "$outputs/resultados_3.doc", replace
}

*** Obejtivos especificos
{
*********************************************************************************
*** PART 2: Esticación económetrica LSDV Model 
********************************************************************************/
	reg 			lpbi lgc, robust
	estimates		store Pool1
	
*********************************************************************************
*** PART 3: Esticación económetrica 'within' Model 
********************************************************************************/
	xtreg 			lpbi lgc lem, fe vce(robust)
	estimates 		store Efecto_fijo1
	
*********************************************************************************
*** PART 4: Esticación económetrica 'ramdom' Model 
********************************************************************************/
	xtreg 			lpbi lgc lem, re vce(robust)
	estimates 		store Efecto_aleatorio1
	outreg2 		[Pool Efecto_fijo1 Efecto_aleatorio1 ] ///
					using "$outputs/Resultado_11.xls", replace
*********************************************************************************
*** Implement  the Hausman Test
*********************************************************************************
	xtreg 			lpbi lgc calidad , fe 
	est 			store fe1
	xtreg 			lpbi lgc calidad , re 
	est 			store re1
	hausman 		fe1 re1 
*********************************************************************************
*** Analisis de Autocorrelación y heterocedastecidad 
*********************************************************************************
	xtserial		lpbi lgc lem, output /* existe autocorelacion*/
	xtreg 			lpbi lgc lem, fe		/* exite heterocedastecidad*/
	xttest3 

*********************************************************************************
*** PART 5: Mejor Model con problemas autocorelacion rubusto
********************************************************************************/
	xtreg 			lpbi lgc lem, fe vce(robust)
	estimate 		store modfe11
	xtreg 			lpbi lgc c.lem#c.Educación, fe vce(robust)
	estimate 		store modfe21
	outreg2 		[modfe11 modfe21] using "$outputs/resultados_22.doc", replace


*********************************************************************************
*** Implement panel dinamico Arellano bond
********************************************************************************* 
	xtabond2 		lpbi L.lpbi lgc, gmm(L.(lpbi),collapse) iv(lgc yr3-yr13 ) ///
					nodiffsargan noleveleq twostep robust 
	estimates 		store Arellado_bond11
	xtabond2 		lpbi L.lpbi lgc lem, gmm(L.(lpbi),collapse) iv(lgc yr3-yr13 ) ///
					nodiffsargan noleveleq twostep robust 
	estimates 		store Arellado_bond21			
	xtabond2 		lpbi L.lpbi lgc c.lem#c.Educación, gmm(L.(lpbi),collapse) iv(lgc  yr3-yr13 ) ///
					nodiffsargan noleveleq twostep robust 
	estimates 		store Arellado_bond31
	
	outreg2			[ Pool1 modfe11 modfe21 Arellado_bond11 Arellado_bond21 Arellado_bond31] ///
					using "$outputs/resultados_31.doc", replace
 }
*********************************************************************************
*** PART 3: Esticación económetrica LSDV Model 
********************************************************************************/
*** Implement  the Hausman Test
*********************************************************************************
	xtreg 			lpbi lgk cl , fe 
	est 			store fe2
	xtreg 			lpbi lgk cl , re 
	est 			store re2
	hausman 		fe2 re2 

*********************************************************************************
*** Implement panel dinamico con LSGF
********************************************************************************* 
	reg 			lpbi lgk , robust
	estimates		store Pool2
	xtreg 			lpbi lgk lem, re vce(robust)
	estimates 		store ea2
	xtreg 			lpbi lgk  lem c.lem#c.Educación, re vce(robust)
	estimate 		store moda22
	xi: xtgls lpbi L.lpbi lgk l.lgk  lem c.lem#c.Educación yr3-yr13, panels (heteroskedastic correlated) corr(ar1) 
	estimates 		store Efectohc
	
	outreg2			[Pool2 ea2 moda22 Efectohc] using "$outputs/resultados_h3.doc", replace
*********************************************************************
*PARTE 4 Estiamación para cda departamento
*********************************************************************
	forvalues x = 1/25{
	reg lpbi lg if Departamento==`x', r b
	estimates store reg_`x'
	}
	outreg2 [reg_1 reg_2 reg_3 reg_4 reg_5 reg_6 reg_7 reg_8 reg_9 reg_10 reg_11 reg_12 reg_13 reg_14 reg_15 reg_16 reg_17 reg_18 reg_19 reg_20 reg_21 reg_22 reg_23 reg_24 reg_25] using "$outputs/resultados_regiones.xls", addstat(F test, e(p)) replace
**************************************













