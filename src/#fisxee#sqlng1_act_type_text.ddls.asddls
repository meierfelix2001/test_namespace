@AbapCatalog.sqlViewName: '/FISXEE/V_NG_168'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für ApiDesigner-Actions'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_ACT_TYPE_TEXT
  as select from /fisxee/dt_ng_ac
{
//      @ObjectModel.text.element:  [ 'action_type_text' ]
  key action_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      @EndUserText.label: 'Action Type'
      action_type_text
} 
 