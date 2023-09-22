@AbapCatalog.sqlViewName: '/FISXEE/V_NG_145'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Text zum Gesamtstatus der Übertragung'
@ObjectModel.dataCategory: #TEXT
@Search.searchable: true
define view /FISXEE/SQLNG1_TRANS_STAT_TEXT
  as select from /fisxee/dt_ng_sv
{
      @ObjectModel.text.element:  [ 'status_text' ]
  key status,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      status_text
} 
 