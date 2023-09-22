@AbapCatalog.sqlViewName: '/FISXEE/V_NG_161'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Text zum globalen Kommunikationsparameter'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_GCP_TEXT
  as select from /fisxee/dt_ng_gc
{
  key qualifier,
  key com_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 