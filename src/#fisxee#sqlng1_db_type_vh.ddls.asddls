@AbapCatalog.sqlViewName: '/FISXEE/V_NG_158'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Datenbank-Verbindungstypen'
@Search.searchable: true
define view /FISXEE/SQLNG1_DB_TYPE_VH
  as select from /fisxee/dc_ng_dt
  association [0..1] to /FISXEE/SQLNG1_DB_TYPE_TEXT as _DbTypeText on $projection.db_type = _DbTypeText.db_type
                                                                   and _DbTypeText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.element:  [ 'name' ]
  key db_type,
      @Semantics.text: true
      _DbTypeText.db_type_text as name,

      _DbTypeText
} 
 