@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_EN'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle Encoding'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_ENCODING_TEXT
  as select from /fisxee/dt_ng_en
{
  key id,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      name
} 
 