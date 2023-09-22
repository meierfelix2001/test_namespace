@AbapCatalog.sqlViewName: '/FISXEE/V_NG_183'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Encoding'
@Search.searchable: true
define view /FISXEE/SQLNG1_ENCODING_VH
  as select from /fisxee/dc_ng_en
  association [0..1] to /FISXEE/SQLNG1_ENCODING_TEXT as _EncodingText on  $projection.id          = _EncodingText.id
                                                                            and _EncodingText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key id,
      @Semantics.text: true
      _EncodingText.name as name,

      _EncodingText
}
