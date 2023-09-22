@AbapCatalog.sqlViewName: '/FISXEE/V_NG_189'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emittlung des letzten Status-Pos der Übertragungen'
define view /FISXEE/SQLNG1_TRANS_end_STAT 
    as select from /FISXEE/SQLNG1_TRANS_W_rep
{
  subnum,
  transnum,
  max( status_pos ) as MaxStatusPosWR
}
group by 
  subnum,
  transnum
 