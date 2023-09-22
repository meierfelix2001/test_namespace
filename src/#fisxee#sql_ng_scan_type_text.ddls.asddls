@AbapCatalog.sqlViewName: '/FISXEE/V_NG_008'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle zum Scanregeltyp'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/sql_ng_scan_type_text
  as select from /fisxee/dt_ng_st
{
  key scanrule_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      scanrule_type_text
} 
 