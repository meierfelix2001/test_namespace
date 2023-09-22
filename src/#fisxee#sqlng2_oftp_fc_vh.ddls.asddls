@AbapCatalog.sqlViewName: '/FISXEE/V_NG_202'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für OFTP-Dateikomprimierung'
@Search.searchable: true
define view /FISXEE/SQLNG2_OFTP_FC_VH
  as select from /fisxee/dc_ng_oc
  association [0..1] to /FISXEE/SQLNG2_OFTP_FC_TEXT as _CompressionText on  $projection.id       = _CompressionText.id
                                                                         and _CompressionText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _CompressionText.name as name,

      _CompressionText
}
