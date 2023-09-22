@AbapCatalog.sqlViewName: '/FISXEE/V_NG_141'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für HTTP-Verhalten'
@Search.searchable: true
define view /FISXEE/SQLNG1_H_METHOD_VH
  as select from /fisxee/dc_ng_hm
  association [0..1] to /FISXEE/SQLNG1_H_METHOD_TEXT as _MethodText on  $projection.id      = _MethodText.id
                                                                        and _MethodText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _MethodText.name as name,

      _MethodText
}
