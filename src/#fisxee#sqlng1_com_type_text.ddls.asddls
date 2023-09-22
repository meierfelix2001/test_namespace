@AbapCatalog.sqlViewName: '/FISXEE/V_NG_153'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für Kommunikationsart'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_COM_TYPE_TEXT
  as select from /fisxee/dt_ng_ct
{
      @ObjectModel.text.element:  [ 'communication_type_text' ]
  key communication_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      @Search.defaultSearchElement: true
      communication_type_text
} 
 