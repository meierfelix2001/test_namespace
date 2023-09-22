@AbapCatalog.sqlViewName: '/FISXEE/V_NG_164'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für globale Kommunikationsparameter'
@Search.searchable: true
define view /FISXEE/SQLNG1_GCP_VH
  as select from /fisxee/dc_ng_gc
  association [0..*] to /FISXEE/SQLNG1_GCP_TEXT as _GlobalCommText on  $projection.qualifier = _GlobalCommText.qualifier
                                                                   and $projection.com_type  = _GlobalCommText.com_type
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_GlobalCommText'
  key qualifier,
  key com_type,
      _GlobalCommText
} 
 