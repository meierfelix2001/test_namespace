@AbapCatalog.sqlViewName: '/FISXEE/V_NG_029'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Text zum Gesamtstatus des Prozesses'
@ObjectModel.dataCategory: #TEXT
@Search.searchable: true
define view /FISXEE/SQL_NG_PRO_STATUS_TEXT
  as select from /fisxee/dt_ng_ps
{
  key status,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      status_text
} 
 