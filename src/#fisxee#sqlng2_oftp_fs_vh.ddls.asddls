@AbapCatalog.sqlViewName: '/FISXEE/V_NG_201'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für OFTP-Dateisignierung'
@Search.searchable: true
define view /FISXEE/SQLNG2_OFTP_FS_VH
  as select from /fisxee/dc_ng_oi
  association [0..1] to /FISXEE/SQLNG2_OFTP_FS_TEXT as _SignationText on  $projection.id       = _SignationText.id
                                                                         and _SignationText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _SignationText.name as name,

      _SignationText
}
