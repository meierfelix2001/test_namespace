@AbapCatalog.sqlViewName: '/FISXEE/V_NG_028'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe zum Scanregeltyp'
define view /FISXEE/SQL_NG_SCAN_TYPE_VH
  as select from /fisxee/dc_ng_st
  association [0..*] to /FISXEE/sql_ng_scan_type_text as _ScanruleTypeText on $projection.scanrule_type = _ScanruleTypeText.scanrule_type
{
  key scanrule_type,

      _ScanruleTypeText

} 
 