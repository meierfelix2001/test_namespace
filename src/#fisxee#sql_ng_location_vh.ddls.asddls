@AbapCatalog.sqlViewName: '/FISXEE/V_NG_030'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe zur Lage'
@Search.searchable: true
define view /FISXEE/SQL_NG_LOCATION_VH
  as select from /fisxee/dc_ng_bp
  association [0..*] to /FISXEE/SQL_NG_LOCATION_TEXT as _LocationText on $projection.location = _LocationText.location

{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @ObjectModel.text.association: '_LocationText'
      //@ObjectModel.foreignKey.association: '_Location'
  key location,

      _LocationText
} 
 