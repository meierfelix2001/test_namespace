@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_AT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für AS2-MDN-Typen'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_MDN_TYPE_TEXT
  as select from /fisxee/dt_ng_at
{
  key mdn_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      mdn_type_text
} 
 