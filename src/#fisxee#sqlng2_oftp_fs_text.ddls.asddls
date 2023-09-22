@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_OI'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für OFTP-Dateisignierung'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG2_OFTP_FS_TEXT
  as select from /fisxee/dt_ng_oi
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      description as name
} 
 