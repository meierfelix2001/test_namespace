@AbapCatalog.sqlViewName: '/FISXEE/VT_RFC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'FIS Texttabelle für HTTP-Destination'
@ObjectModel.dataCategory: #TEXT
define view /FISXEE/sql_ng_rfcdes_text
  as select from rfcdoc
{
  key rfcdest,
      @Semantics.language: true
  key rfclang,
      @Semantics.text: true
      @EndUserText.label: 'Bescheibung der Destination'
      rfcdoc1
} 
 