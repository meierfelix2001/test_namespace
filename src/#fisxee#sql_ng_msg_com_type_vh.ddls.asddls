@AbapCatalog.sqlViewName: '/FISXEE/V_NG_093'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Kommunikationsdatentyp'
@Search.searchable: true

define view /FISXEE/SQL_NG_MSG_COM_TYPE_VH
  as select from /fisxee/dc_ng_sc
  association [0..*] to /FISXEE/SQL_NG_MSG_COM_TYP_TXT as _ComTypeText on $projection.comm_meta_type = _ComTypeText.comm_meta_type

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_ComTypeText'
  key comm_meta_type,

      _ComTypeText
} 
 