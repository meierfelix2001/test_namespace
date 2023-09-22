@AbapCatalog.sqlViewName: '/FISXEE/V_NG_155'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle zum Scanregelparameter'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_CONFIG_KEY_TEXT
  as select from /fisxee/dt_ng_cs
{
  key config_key,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      config_key_text
} 
 