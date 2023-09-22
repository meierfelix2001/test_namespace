@AbapCatalog.sqlViewName: '/FISXEE/V_NG_162'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Emittlung der größten Status-Pos der Prozesse'
define view /FISXEE/SQLNG1_PROCESS_STA_MAX
  as select from /FISXEE/SQL_NG_PROCESS_STATUS
{
      ///FISXEE/SQL_NG_PROCESS_STATUS
  key id,
      max( status_pos ) as MaxStatusPos
//      ,
//
//      /* Associations */
//      /////FISXEE/SQL_NG_PROCESS_STATUS
//      _Process
}
group by
  id  
 