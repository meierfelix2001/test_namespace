@AbapCatalog.sqlViewName: '/FISXEE/V_NG_151'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: 'Wertehilfe für Richtung der Kommunikation'
@Search.searchable: true

define view /FISXEE/SQLNG1_COM_DIR_VH
  as select from /fisxee/dc_ng_di
  association [0..1] to /FISXEE/SQLNG1_COM_DIR_TEXT as _ComDirText on $projection.direction = _ComDirText.direction
                                                                   and _ComDirText.spras = $session.system_language
{
      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      //@ObjectModel.text.association: '_ComDirText'
      @ObjectModel.text.element:  [ 'name' ]
  key direction,
      @Semantics.text: true
      _ComDirText.direction_text as name,

      _ComDirText
} 
 