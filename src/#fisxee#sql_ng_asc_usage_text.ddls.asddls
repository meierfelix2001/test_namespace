@AbapCatalog.sqlViewName: '/FISXEE/V_NG_110'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für AS2 Zertifikatsverwendun'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_ASC_USAGE_TEXT
  as select from /fisxee/dt_ng_au
{
  key asc_usage,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      text
} 
 