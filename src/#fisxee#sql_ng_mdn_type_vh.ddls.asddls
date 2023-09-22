@AbapCatalog.sqlViewName: '/FISXEE/V_NG_109'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für für AS2-MDN-Typen'
@Search.searchable: true
define view /FISXEE/SQL_NG_MDN_TYPE_VH
  as select from /fisxee/dc_ng_at
  association [0..1] to /FISXEE/SQL_NG_MDN_TYPE_TEXT as _MdnTypeText on $projection.mdn_type = _MdnTypeText.mdn_type
                                                                   and _MdnTypeText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key mdn_type,
      @Semantics.text: true
      _MdnTypeText.mdn_type_text as name,

      _MdnTypeText
} 
 