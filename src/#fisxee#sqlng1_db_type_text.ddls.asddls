@AbapCatalog.sqlViewName: '/FISXEE/V_NG_157'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für Datenbank-Verbindungstypen'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQLNG1_DB_TYPE_TEXT
  as select from /fisxee/dt_ng_dt
{
  key db_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      db_type_text
} 
 