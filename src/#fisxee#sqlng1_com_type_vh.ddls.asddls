@AbapCatalog.sqlViewName: '/FISXEE/V_NG_154'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Kommunikationstyp'
@Search.searchable: true

define view /FISXEE/SQLNG1_COM_TYPE_VH
  as select from /fisxee/dc_ng_ct
  association [0..*] to /FISXEE/SQLNG1_COM_TYPE_TEXT as _ComTypeText on $projection.communication_type = _ComTypeText.communication_type

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_ComTypeText'
  key communication_type,

      _ComTypeText
} 
 