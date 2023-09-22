@AbapCatalog.sqlViewName: '/FISXEE/V_NG_159'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Texttabelle für Dateikategorie'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_FILE_CATEG_TEXT
  as select from /fisxee/dt_ng_ft
{
      ///fisxee/dt_ng_ft
  key file_category,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      file_category_name
} 
 