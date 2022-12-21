'***************************************************************************************
'     Tesis: Sector industrial y el crecimiento económico en el Perú, 1980-2018
'							Autor: Sir Bernabé Huamanculí
'						     Fecha de Modificacion: 16/06/21
'***************************************************************************************
pageselect tesis
smpl 1980Q1 2018Q4 
'delete(noerr)  gru* fig* tab* tc_* ln_* ' activar si desea correr

'Analisis Descriptivo
group grupo_1.sheets cons m pbi
freeze(fig_01) grupo_1.line(m)

'Desestacionalizacion 
for %y cons m pbi
	 {%y}.x12   
next

group grupo_2 cons_sa m_sa pbi_sa
freeze(fig_02) grupo_2.line(m)

'trabajando en logaritmos
for %z cons_sa m_sa pbi_sa
	series ln_{%z}= log({%z})   
next
'creando tasas de crecimiento

for %t ln_cons_sa  ln_m_sa ln_pbi_sa
	series tc_{%t} = {%t}-{%t}(-4)  
next 

group grupo_3 tc_ln_cons_sa  tc_ln_m_sa tc_ln_pbi_sa
freeze(fig_03) grupo_3.line(m)

'dummies 
series dum1=@date>@dateval ("1990Q2")
' Test de raiz unitaria
'**************************************************************************************
'en niveles
freeze(tab_adf_cons_n) cons_sa.uroot
 freeze(tab_adf_man_n) m_sa.uroot
freeze(tab_adf_pbi_n) pbi_sa.uroot

freeze(tab_pp_cons_n) cons_sa.uroot(pp)
 freeze(tab_pp_man_n) m_sa.uroot(pp)
freeze(tab_pp_pbi_n) pbi_sa.uroot(pp)

'en tasas
freeze(tab_adf_cons) tc_ln_cons_sa.uroot
 freeze(tab_adf_man) tc_ln_m_sa.uroot
freeze(tab_adf_pbi) tc_ln_pbi_sa.uroot

 
'Relacion de Largo Plazo General
'***************************************************************************************
equation eq03_gene_largo.ardl(fixed, deplags=1, reglags=1, cov=hac) tc_ln_pbi_sa tc_ln_cons_sa tc_ln_m_sa @
'Autocorrelacion
freeze(tab_auto_gen_largo) eq03_gene_largo.auto
'Heterocedastecidad
freeze(tab_heter_gen_largo) eq03_gene_largo.hettest @regs


'conitegrafion y ECM
eq03_gene_largo.makecoint cointnondeg

freeze(tab_coint_gen) eq03_gene_largo.cointrep
freeze(tab_ECM_gen) eq03_gene_largo.ecreg

'consistencia
eq03_gene_largo.resids(g)
group grupo_4 tc_ln_pbi_sa (tc_ln_pbi_sa - cointnondeg)
freeze(mode=overwrite, fig_03_comparacion) grupo_4.line
 fig_03_comparacion.axis(l) format(suffix="%")
 fig_03_comparacion.setelem(1) legend(Tasa de Crecimiento de PBI)
 fig_03_comparacion.setelem(2) legend(Long run relationship (Tasa de Crecimiento de PBI - COINTNONDEG))
show fig_03_comparacion

'mejor modelo especifico 1
'***************************************************************************************
equation eq01_esp_largo.ardl(fixed, deplags=2, reglags=1, cov=hac)  tc_ln_pbi_sa   tc_ln_cons_sa @

'Autocorrelacion
freeze(tab_auto_esp_largo_1) eq01_esp_largo.auto

'Heterocedastecidad
freeze(tab_heter_esp_largo_1) eq01_esp_largo.hettest  @regs


'conitegrafion y ECM
eq01_esp_largo.makecoint coint_cons
freeze(tab_coint_esp_1) eq01_esp_largo.cointrep
freeze(tab_ECM_esp_1) eq01_esp_largo.ecreg

'consistencia
freeze(fig_esp_1) eq01_esp_largo.resids(g)

group grupo_5 tc_ln_pbi_sa (tc_ln_pbi_sa - coint_cons)
freeze(mode=overwrite, fig_esp_1_comparacion) grupo_5.line
 fig_esp_1_comparacion.axis(l) format(suffix="%")
 fig_esp_1_comparacion.setelem(1) legend(Tasa de Crecimiento de PBI)
 fig_esp_1_comparacion.setelem(2) legend(Long run relationship (Tasa de Crecimiento de PBI - COINT_CONS))
show fig_esp_1_comparacion

'mejor modelo especifico 2
'***************************************************************************************
equation eq02_esp_largo.ardl(fixed, deplags=1, reglags=4, cov=hac)  tc_ln_pbi_sa   tc_ln_m_sa @


'Autocorrelacion
freeze(tab_auto_esp_largo_2) eq02_esp_largo.auto

'Heterocedastecidad
freeze(tab_heter_esp_largo_2) eq02_esp_largo.hettest @regs


'conitegrafion y ECM
eq02_esp_largo.makecoint coint_manu
freeze(tab_coint_esp_2) eq02_esp_largo.cointrep
freeze(tab_ECM_esp_2) eq02_esp_largo.ecreg

'consistencia
freeze(fig_esp_2) eq02_esp_largo.resids(g)

group grupo_6 tc_ln_pbi_sa (tc_ln_pbi_sa -coint_manu)
freeze(mode=overwrite, fig_esp_2_comparacion) grupo_6.line
 fig_esp_2_comparacion.axis(l) format(suffix="%")
 fig_esp_2_comparacion.setelem(1) legend(Tasa de Crecimiento de PBI)
 fig_esp_2_comparacion.setelem(2) legend(Long run relationship (Tasa de Crecimiento de PBI - COINT_MANU))
show fig_esp_2_comparacion


