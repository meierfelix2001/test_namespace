@AbapCatalog.sqlViewName: '/FISXEE/VT_NG_SC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für Kommunikationsdatenart'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/SQL_NG_MSG_COM_TYP_TXT
  as select from /fisxee/dt_ng_sc
{
      @ObjectModel.text.element:  [ 'comm_meta_type_text' ]
  key comm_meta_type,
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      comm_meta_type_text
} 
 