@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_OV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für OFTP-Dateiverschüsselung'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG2_OFTP_FE_TEXT
  as select from /fisxee/dt_ng_ov
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      description as name
} 
 