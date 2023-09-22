@AbapCatalog.sqlViewName: '/FISXEE/V_NG_165'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für HTTP-Verhalten'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_H_BEHAVIOR_TEXT
  as select from /fisxee/dt_ng_hb
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 