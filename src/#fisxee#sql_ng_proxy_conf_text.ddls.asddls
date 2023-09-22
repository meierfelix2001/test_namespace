@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_PV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für Proxy-Konfiguration'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_PROXY_CONF_TEXT
  as select from /fisxee/dt_ng_pv
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 