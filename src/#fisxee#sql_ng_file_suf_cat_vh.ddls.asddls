@AbapCatalog.sqlViewName: '/FISXEE/V_NG_091'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK   
@EndUserText.label: 'Wertehilfe für Dateiendung zu Kategorie'
define view /FISXEE/SQL_NG_FILE_SUF_CAT_VH
  as select from /fisxee/dc_ng_fc {
  
    key file_suffix, 
    
        file_category
} 
 