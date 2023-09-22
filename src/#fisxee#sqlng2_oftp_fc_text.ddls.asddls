@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_OC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für OFTP-Dateikomprimierung'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG2_OFTP_FC_TEXT
  as select from /fisxee/dt_ng_oc
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      description as name
} 
 