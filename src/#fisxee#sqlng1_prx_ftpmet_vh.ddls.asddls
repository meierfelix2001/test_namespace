@AbapCatalog.sqlViewName: '/FISXEE/V_NG_160'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für für Ftp-Proxy-Methode'
@Search.searchable: true
define view /FISXEE/SQLNG1_PRX_FTPMET_VH
  as select from /fisxee/dc_ng_pm
  association [0..1] to /FISXEE/SQLNG1_PRX_FTPMET_TEXT as _ProxyFtpMethText on  $projection.id          = _ProxyFtpMethText.id
                                                                            and _ProxyFtpMethText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _ProxyFtpMethText.name as name,

      _ProxyFtpMethText
}
