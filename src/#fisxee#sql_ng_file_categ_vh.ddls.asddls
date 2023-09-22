@AbapCatalog.sqlViewName: '/FISXEE/V_NG_084'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Dateikategorie'
@Search.searchable: true
define view /FISXEE/SQL_NG_FILE_CATEG_VH
  as select from /fisxee/dc_ng_ft
  association [0..*] to /FISXEE/SQLNG1_FILE_CATEG_TEXT as _FileCategoryText on $projection.file_category = _FileCategoryText.file_category

{
      ///fisxee/dc_ng_ft
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_FileCategoryText'
  key file_category,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      file_path,

      /* Associations */
      _FileCategoryText

} 
 