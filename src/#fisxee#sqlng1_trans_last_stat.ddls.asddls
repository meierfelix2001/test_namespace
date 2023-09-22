@AbapCatalog.sqlViewName: '/FISXEE/V_NG_147'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verknüpfung Übertragung zu letztem Übertragungsstatus'
define view /FISXEE/SQLNG1_TRANS_LAST_STAT
  as select from /FISXEE/SQLNG1_TRANS_MAX_STAT
{
  subnum,
  transnum,
  MaxStatusPos as LastStatusPos
} 
 