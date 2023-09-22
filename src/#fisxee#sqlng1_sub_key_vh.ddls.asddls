@AbapCatalog.sqlViewName: '/FISXEE/V_NG_152'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Subsystemparameter'
define view /FISXEE/SQLNG1_SUB_KEY_VH
  as select from /fisxee/dc_ng_sk
  association [0..*] to /FISXEE/SQLNG1_SUB_KEY_TEXT as _Text on $projection.sub_key = _Text.sub_key

{
      @ObjectModel.text.association: '_Text'
  key sub_key,
      sub_key_pos,
      sub_value_length,
      sub_value_tab,
      sub_value_type,
      sub_value_req,
      check_method,

      _Text
} 
 