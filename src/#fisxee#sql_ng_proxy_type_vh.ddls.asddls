@AbapCatalog.sqlViewName: '/FISXEE/V_NG_123'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für für Proxy-Typen'
@Search.searchable: true
define view /FISXEE/SQL_NG_PROXY_TYPE_VH
  as select from /fisxee/dc_ng_pt
  association [0..1] to /FISXEE/SQL_NG_PROXY_TYPE_TEXT as _ProxyTypeText on  $projection.id       = _ProxyTypeText.id
                                                                         and _ProxyTypeText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _ProxyTypeText.name as name,

      _ProxyTypeText
}
