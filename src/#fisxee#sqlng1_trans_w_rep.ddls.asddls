@AbapCatalog.sqlViewName: '/FISXEE/V_NG_188'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emittlung des letzten Status-Pos der Übertragungen'
define view /FISXEE/SQLNG1_TRANS_W_rep 
    as select from /FISXEE/SQL_NG_TRANS_STATUS
{
  subnum,
  transnum,
  status,
  status_pos
}
where status != '0007'
and status != '0006'
