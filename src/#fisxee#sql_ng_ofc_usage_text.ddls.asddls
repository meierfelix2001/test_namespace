@AbapCatalog.sqlViewName: '/FISXEE/V_NG_081'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für OFTP Zertifikatsverwendung'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_OFC_USAGE_TEXT
  as select from /fisxee/dt_ng_ou
{
      ///FISXEE/dt_ng_ou
  key ofc_usage,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      text
} 
 