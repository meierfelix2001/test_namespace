@AbapCatalog.sqlViewName: '/FISXEE/V_NG_095'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für OFTP-Stationen'
@Search.searchable: true
define view /FISXEE/SQL_NG_OFD_VH
  as select from /fisxee/d_ng_ofd
  association [1..1] to /fisxee/d_ng_ofb as _basis on $projection.station_id = _basis.id
{
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Semantics.text: true      
      _basis.station_name as name,
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      _basis.odette_id as description,
      
      station_id,
      _basis.subnum
}
