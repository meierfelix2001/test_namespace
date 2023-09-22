@AbapCatalog.sqlViewName: '/FISXEE/V_NG_186'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verknüpfung Übertragung zum ersten Übertragungsstatus'
define view /FISXEE/SQLNG1_TRAN_FIRST_STAT
  as select from /FISXEE/SQLNG1_TRANS_MIN_STAT
{
  subnum,
  transnum,
  MinStatusPos as FirstStatusPos
} 
 