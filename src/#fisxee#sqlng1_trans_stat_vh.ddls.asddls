@AbapCatalog.sqlViewName: '/FISXEE/V_NG_144'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe zum Gesamtstatus der Übertragung'
define view /FISXEE/SQLNG1_TRANS_STAT_VH
  as select from /fisxee/dc_ng_sv
  association [0..1] to /FISXEE/SQLNG1_TRANS_STAT_TEXT as _StatusText on  $projection.status = _StatusText.status
                                                                      and _StatusText.spras  = $session.system_language
{
      @ObjectModel.text.element:  [ 'status_text' ]
  key status,
      criticality,
      icon_name,
      @Semantics.text: true
      _StatusText.status_text
      
}
