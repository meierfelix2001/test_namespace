@AbapCatalog.sqlViewName: '/FISXEE/V_NG_129'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für für Proxy-Konfiguration'
@Search.searchable: true
define view /FISXEE/SQL_NG_PROXY_CONF_VH
  as select from /fisxee/dc_ng_pv
  association [0..1] to /FISXEE/SQL_NG_PROXY_CONF_TEXT as _ProxyConfText on  $projection.id       = _ProxyConfText.id
                                                                         and _ProxyConfText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _ProxyConfText.name as name,

      _ProxyConfText
}
