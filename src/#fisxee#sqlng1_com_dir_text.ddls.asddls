@AbapCatalog.sqlViewName: '/FISXEE/V_NG_149'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle Richtung der Kommunikation'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_COM_DIR_TEXT
  as select from /fisxee/dt_ng_di
{
  key direction,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      direction_text
} 
 