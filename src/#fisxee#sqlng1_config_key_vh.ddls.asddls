@AbapCatalog.sqlViewName: '/FISXEE/V_NG_156'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe zum Scanregelparameter'
@Search.searchable: true
define view /FISXEE/SQLNG1_CONFIG_KEY_VH
  as select from /fisxee/dc_ng_ck
  association [0..*] to /FISXEE/SQLNG1_CONFIG_KEY_TEXT as _ConfigKeyText on $projection.config_key = _ConfigKeyText.config_key

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_ConfigKeyText'
  key config_key,

      _ConfigKeyText
} 
 