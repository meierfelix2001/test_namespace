@AbapCatalog.sqlViewName: '/FISXEE/V_NG_185'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emittlung der min Status-Pos der Üb'
define view /FISXEE/SQLNG1_TRANS_MIN_STAT 
    as select from /FISXEE/SQL_NG_TRANS_STATUS
{
  subnum,
  transnum,
  min( status_pos ) as MinStatusPos
}
group by 
  subnum,
  transnum
