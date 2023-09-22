@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_PF'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle Ftp-Proxy-Methode'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_PRX_FTPMET_TEXT
  as select from /fisxee/dt_ng_pm
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 