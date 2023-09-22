@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_PT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für Proxy-Typen'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_PROXY_TYPE_TEXT
  as select from /fisxee/dt_ng_pt
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 