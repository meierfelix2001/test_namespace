@AbapCatalog.sqlViewName: '/FISXEE/V_NG_167'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für ApiDesigner-Actions'
@Search.searchable: true

define view /FISXEE/SQLNG1_ACT_TYPE_VH
  as select from /fisxee/dc_ng_ac
  association [0..*] to /FISXEE/SQLNG1_ACT_TYPE_TEXT as _ActTypeText on $projection.action_type = _ActTypeText.action_type

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_ActTypeText'
  key action_type,

      _ActTypeText
} 
 