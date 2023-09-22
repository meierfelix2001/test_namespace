@AbapCatalog.sqlViewName: '/FISXEE/V_NG_031'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe zum Gesamtstatus des Prozesses'
@Search.searchable: true
define view /FISXEE/SQL_NG_PRO_STATUS_VH
  as select from /fisxee/dc_ng_ps
  association [0..1] to /FISXEE/SQL_NG_PRO_STATUS_TEXT as _StatusText on  $projection.status = _StatusText.status
                                                                      and _StatusText.spras  = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'status_text' ]
  key status,
      criticality,
      @Semantics.text: true
      _StatusText.status_text,

      _StatusText
}
