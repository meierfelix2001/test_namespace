@AbapCatalog.sqlViewName: '/FISXEE/V_NG_200'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für OFTP-Dateiverschlüsselung'
@Search.searchable: true
define view /FISXEE/SQLNG2_OFTP_FE_VH
  as select from /fisxee/dc_ng_ov
  association [0..1] to /FISXEE/SQLNG2_OFTP_FE_TEXT as _EncryptionText on  $projection.id       = _EncryptionText.id
                                                                         and _EncryptionText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _EncryptionText.name as name,

      _EncryptionText
}
