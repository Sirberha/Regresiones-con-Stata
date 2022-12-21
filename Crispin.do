***************************************************************************
*  Autor: SirBerHA
*  Tema: Indicadores socieocnomicos  y ingrso laboral Departamento de Ayacucho
******************************************************************************
	use 	"$data/Ayacucho.dta", clear
	
* Tablas de analisis de regresion 
** en logaritmo
*--------------------
** si usa factor07, ya que busca analizar ingresos laboralres a nivel hogar
*-------------------------------------------------------------------------
****Variable
/*   ingreso,
	 nivel de educacion,
	 experiencia, 
	 sexo, 
	 area, 
	 horas laborales 
	 infromalidad,
	 estado civil y
	 ef de provincias
*/

	reg lning i.neduc c.expp##c.expp i.sexo [pw=factor07], r  cformat(%9.2fc)
		outreg2 using "$outputs\tabla_ols_1.xls", label  bdec(3) sdec(3) ctitle(modelo 1)  ///
		addtext(FE provincia, No, Controls, No, Robust SE, Si) /// 
		addnote("Nota. Especificaciones de la ecuancion de Mincer") replace
	reg lning i.neduc c.expp##c.expp i.sexo horast [pw=factor07], r  cformat(%9.2fc)
		outreg2 using "$outputs\tabla_ols_1.xls", label  bdec(3) sdec(3) ctitle(modelo 2) ///
		addtext(FE provincia, No, Controls, Si, Robust SE, Si) append  
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad [pw=factor07], r  cformat(%9.2fc)
		outreg2 using "$outputs\tabla_ols_1.xls", label  bdec(3) sdec(3) ctitle(modelo 3) ///
		addtext(FE provincia, No, Controls, Si, Robust SE, Si) append  
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area i.estado [pw=factor07], r  cformat(%9.2fc)
		outreg2 using "$outputs\tabla_ols_1.xls", label  bdec(3) sdec(3) ctitle(modelo 4) ///
		addtext(FE provincia, No, Controls, Si, Robust SE, Si) append  
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area i.estado i.provincia  [pw=factor07],  r cformat(%9.2fc)
		outreg2 using "$outputs\tabla_ols_1.xls", label  bdec(3) sdec(3) ctitle(modelo 4) ///
		addtext(FE provincia, Si, Controls, Si, Robust SE, Si) append  
		
* Efectos marginales
*-------------------------	
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area i.estado i.provincia  [pw=factor07], r  cformat(%9.2fc)
	margins, at(neduc = (1 (1) 5)) 
	marginsplot,  scheme(white_ptol)
	
	graph save "${graphs}/fig_11.gph", replace
	
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area i.estado i.provincia  [pw=facpob], r  cformat(%9.2fc)
	margins, at(horast = (1 (10) 112)) 
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_12.gph", replace
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area i.estado i.provincia  [pw=facpob], r  cformat(%9.2fc)
	margins, at(sexo = (0 1)) 
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_13.gph", replace
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area i.estado i.provincia  [pw=facpob], r  cformat(%9.2fc)
	margins, at(expp = (1 (5) 80)) 
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_14.gph", replace
	
	graph combine "${graphs}/fig_11.gph" "${graphs}/fig_12.gph" "${graphs}/fig_13.gph" "${graphs}/fig_14.gph"
	
	reg lning i.neduc c.expp##c.expp i.sexo c.horast i.informalidad i.area i.estado i.provincia  [pw=facpob] if p203==1, r  cformat(%9.2fc)
	margins neduc#sexo
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_15.gph", replace
	reg lning i.neduc c.expp##c.expp i.sexo c.horast i.informalidad i.area i.estado i.provincia  [pw=facpob] if p203==1, r  cformat(%9.2fc)
	margins neduc#informalidad 
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_16.gph", replace
	reg lning i.neduc c.expp##c.expp i.sexo c.horast i.informalidad i.area i.estado i.provincia  [pw=facpob] , r  cformat(%9.2fc)
	margins, at(horast=(1 (10) 112) sexo=(0 1)) 
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_17.gph", replace
	reg lning i.neduc c.expp##c.expp i.sexo c.horast i.informalidad i.area i.estado i.provincia  [pw=facpob] if p203==1, r  cformat(%9.2fc)
	margins, at(expp = (1 (5) 80) sexo=(0 1)) 
	marginsplot, scheme(white_ptol)
	graph save "${graphs}/fig_18.gph", replace
	graph combine "${graphs}/fig_15.gph" "${graphs}/fig_16.gph" "${graphs}/fig_17.gph" "${graphs}/fig_18.gph"
	graph save "${graphs}/fig_19.gph", replace

* Regresiones finales para el asño 2019
*---------------------------------------
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado [pw=factor07],  r b cformat(%9.2fc)
		outreg2 using "$outputs\ols.xls", label  bdec(3) sdec(3) ctitle(modelo 1) ///
		addstat(F test, e(p)) addtext(FE provincia, Si, Robust SE, Si) 
  
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado c.horast i.informalidad  ///
		i.provincia  [pw=factor07],  r b cformat(%9.2fc)
		outreg2 using "$outputs\ols.xls", label  bdec(3) sdec(3) ctitle(modelo 1) ///
		addstat(F test, e(p)) addtext(FE provincia, Si, Robust SE, Si) append 
		
	reg lning i.neduc c.expp##c.expp i.sexo horast i.informalidad i.area ///
		i.estado i.provincia  [pw=factor07],  beta r cformat(%9.2fc)
		margins, dydx(neduc)
	
* Efectos margianles
*-------------------
	****educacion 
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado c.horast i.informalidad  ///
		i.provincia  [pw=factor07],  r b cformat(%9.2fc)
		
		margins, dydx(neduc)
		marginsplot,  scheme(white_ptol) name(fig_1, replace)  recastci(rarea)
		"${graphs}/fig_educ.gph", replace
		margins, dydx(neduc) atmeans
	****Experiencia	
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado c.horast i.informalidad  ///
		i.provincia  [pw=factor07],  r b cformat(%9.2fc)
		margins, at(expp==(0(1)50))
		marginsplot, noci scheme(white_ptol) name(fig_2, replace)  recastci(rarea)
	*   otra oppción 
		marginsplot,  scheme(white_ptol) name(fig_1, replace)  recastci(rarea)

	****Sexo	
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado c.horast i.informalidad  ///
		i.provincia  [pw=factor07],  r b cformat(%9.5fc)
		margins, at(sexo==(0 1))
		marginsplot,  scheme(white_ptol) name(fig_3, replace)  recastci(rarea)
			
		graph combine  fig_2 fig_3

	****Area	
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado c.horast i.informalidad  ///
		i.provincia  [pw=factor07],  r b cformat(%9.5fc)
		margins, at(area==(0 1))
		marginsplot,  scheme(white_ptol) name(fig_4, replace)  recastci(rarea)

	****Estado Civil	
	reg lning i.neduc c.expp##c.expp i.sexo i.area i.estado c.horast i.informalidad  ///
		i.provincia  [pw=factor07],  r b cformat(%9.5fc)
		margins, at(estado==(0 1))
		marginsplot,  scheme(white_ptol) name(fig_5, replace)  recastci(rarea)
				
		graph combine  fig_4 fig_5
		