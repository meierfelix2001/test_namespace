@AbapCatalog.sqlViewName: '/FISXEE/V_NG_150'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für Subsystemparameter'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_SUB_KEY_TEXT
  as select from /fisxee/dt_ng_sk
{
  key sub_key,
      @Semantics.language: true
  key spras,

      @Semantics.text: true
      sub_key_text
} 
 