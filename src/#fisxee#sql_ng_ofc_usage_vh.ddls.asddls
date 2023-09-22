@AbapCatalog.sqlViewName: '/FISXEE/V_NG_080'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für OFTP-Zertifikatsverwendung'
@Search.searchable: true
define view /FISXEE/SQL_NG_OFC_USAGE_VH
  as select from /fisxee/dc_ng_ou
  association [0..1] to /FISXEE/SQL_NG_OFC_USAGE_TEXT as _OfcUsageText on $projection.ofc_usage = _OfcUsageText.ofc_usage
                                                                      and _OfcUsageText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      //@ObjectModel.text.association: '_ComDirText'
      @ObjectModel.text.element:  [ 'text' ]
  key ofc_usage,
      @Semantics.text: true
      _OfcUsageText.text as text,

      _OfcUsageText
} 
 