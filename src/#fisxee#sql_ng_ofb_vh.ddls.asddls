@AbapCatalog.sqlViewName: '/FISXEE/V_NG_094'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für OFTP-Stationen'
@Search.searchable: true
define view /FISXEE/SQL_NG_OFB_VH
  as select from /fisxee/d_ng_ofb
{
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true
      station_name as name,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      odette_id as description,
      subnum
}
