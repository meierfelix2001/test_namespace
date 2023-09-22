@AbapCatalog.sqlViewName: '/FISXEE/V_NG_142'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für HTTP-Verhalten'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_H_METHOD_TEXT
  as select from /fisxee/dt_ng_hm
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 