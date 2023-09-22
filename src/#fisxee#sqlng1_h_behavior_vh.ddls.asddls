@AbapCatalog.sqlViewName: '/FISXEE/V_NG_166'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für HTTP-Verhalten'
@Search.searchable: true
define view /FISXEE/SQLNG1_H_BEHAVIOR_VH
  as select from /fisxee/dc_ng_hb
  association [0..1] to /FISXEE/SQLNG1_H_BEHAVIOR_TEXT as _BehaviorText on  $projection.id      = _BehaviorText.id
                                                                        and _BehaviorText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _BehaviorText.name as name,

      _BehaviorText
}
