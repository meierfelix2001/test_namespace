@AbapCatalog.sqlViewName: '/FISXEE/V_NG_146'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emittlung der größten Status-Pos der Übertragungen'
define view /FISXEE/SQLNG1_TRANS_MAX_STAT 
    as select from /FISXEE/SQL_NG_TRANS_STATUS
{
  subnum,
  transnum,
  max( status_pos ) as MaxStatusPos
}
group by 
  subnum,
  transnum
  
