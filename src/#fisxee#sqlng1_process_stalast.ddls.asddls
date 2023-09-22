@AbapCatalog.sqlViewName: '/FISXEE/V_NG_163'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Verknüpfung Prozess zu letztem Prozessstatus'
define view /FISXEE/SQLNG1_PROCESS_STALAST
  as select from /FISXEE/SQLNG1_PROCESS_STA_MAX
  //  association [1..1] to /FISXEE/sql_ng_process as _Process on $projection.id = _Process.id
  //  association [1..1] to /FISXEE/SQL_NG_PROCESS_STATUS as _LastProcessStatus      on $projection.id = _LastProcessStatus.id
  //                                                                                 and $projection.MaxStatusPos = _LastProcessStatus.status_pos
  association [1..1] to /FISXEE/SQL_NG_PROCESS_STATUS as _SUB_LastProcessStatus on  $projection.id           = _SUB_LastProcessStatus.id
                                                                                and $projection.MaxStatusPos = _SUB_LastProcessStatus.status_pos
{
      ///FISXEE/SQL_NG_PROCESS_STA_MAX
  key id,
      MaxStatusPos,
      //
      //      _Process,
      //      _LastProcessStatus
      _SUB_LastProcessStatus
}
