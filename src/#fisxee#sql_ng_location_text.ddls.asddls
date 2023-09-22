@AbapCatalog.sqlViewName: '/FISXEE/V_NG_032'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle zur Lage'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_LOCATION_TEXT
  as select from /fisxee/dt_ng_bp
{

  key location,
      @Semantics.language: true
  key spras,
      @Search.defaultSearchElement: true
      @Search.ranking: #MEDIUM
      @Semantics.text: true
      location_text
} 
 