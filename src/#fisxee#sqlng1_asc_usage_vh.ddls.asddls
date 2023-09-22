@AbapCatalog.sqlViewName: '/FISXEE/V_NG_148'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für AS2-Zertifikatsverwendung'
@Search.searchable: true
define view /FISXEE/SQLNG1_ASC_USAGE_VH
  as select from /fisxee/dc_ng_au
  association [0..1] to /FISXEE/SQL_NG_ASC_USAGE_TEXT as _AscUsageText on  $projection.asc_usage = _AscUsageText.asc_usage
                                                                       and _AscUsageText.spras   = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'text' ]
  key asc_usage,
      @Semantics.text: true
      _AscUsageText.text as text,

      _AscUsageText
}
