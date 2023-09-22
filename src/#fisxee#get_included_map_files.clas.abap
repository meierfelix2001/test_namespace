CLASS /fisxee/get_included_map_files DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS get_included_files
      IMPORTING
        iv_subnum    TYPE /fisxee/ng_subsystem_num
        iv_id        TYPE /fisxee/d_ng_fil-id OPTIONAL
        iv_recursive TYPE xfeld OPTIONAL
      CHANGING
        et_files     TYPE /fisxee/d_ng_fil_tt.

    METHODS get_import_nodes
      IMPORTING
        ir_node     TYPE REF TO if_ixml_node
      EXPORTING
        ev_children TYPE abap_bool
      CHANGING
        cs_data     TYPE any
        ct_data     TYPE STANDARD TABLE OPTIONAL.

    METHODS get_metadata_nodes
      IMPORTING
        ir_node     TYPE REF TO if_ixml_node
      EXPORTING
        ev_children TYPE abap_bool
      CHANGING
        cs_data     TYPE any
        ct_data     TYPE STANDARD TABLE OPTIONAL.

    METHODS add_file_to_table
      IMPORTING
        iv_subnum   TYPE /fisxee/ng_subsystem_num
        iv_filename TYPE string
      EXPORTING
        es_files    TYPE /fisxee/d_ng_fil
      CHANGING
        ct_files    TYPE /fisxee/d_ng_fil_tt.


    METHODS create_xml_document
      IMPORTING
        iv_data            TYPE xstring
        iv_filename        TYPE /fisxee/d_ng_fil-file_name
      RETURNING
        VALUE(rr_document) TYPE REF TO if_ixml_document.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS /FISXEE/GET_INCLUDED_MAP_FILES IMPLEMENTATION.


  METHOD get_included_files.
    TYPES:
      ts_dateiname TYPE string,
      tt_dateiname TYPE STANDARD TABLE OF ts_dateiname.
    FIELD-SYMBOLS:
      <ls_dateiname> TYPE ts_dateiname,
      <ls_imports>   TYPE /fisxee/ng_mapping_imports,
      <ls_import>    TYPE LINE OF /fisxee/ng_mapping_imports-imports,
      <ls_file>      TYPE /fisxee/d_ng_fil.
    FIELD-SYMBOLS:
          <ls_metadata_files> TYPE LINE OF /fisxee/ng_mapping_metadata-files.
    DATA: lt_dateiname TYPE tt_dateiname,
          ls_imports   TYPE /fisxee/ng_mapping_imports,
          ls_metadata  TYPE /fisxee/ng_mapping_metadata,
          lv_index     TYPE sy-tabix,
          lt_file      TYPE TABLE OF /fisxee/d_ng_fil,
          ls_file      TYPE /fisxee/d_ng_fil.
    DATA: lr_document      TYPE REF TO if_ixml_document,
          lv_xfile_content TYPE xstring,
          lr_node          TYPE REF TO if_ixml_node.
    DATA: lt_file_check TYPE TABLE OF /fisxee/d_ng_fil.

    CLEAR lv_xfile_content.

    SELECT SINGLE fc~content, file~file_name , file~id
    FROM /fisxee/d_ng_fc AS fc
    INNER JOIN /fisxee/d_ng_fil AS file
    ON fc~file_id = file~id
    INTO @DATA(ls_file_pos)
    WHERE file~subnum = @iv_subnum
    AND fc~file_id = @iv_id
    AND fc~is_active = @abap_true.

    lr_document = create_xml_document( iv_data     = ls_file_pos-content
                                       iv_filename = ls_file_pos-file_name ).

    IF lr_document IS INITIAL.
      RETURN.
    ENDIF.

    lr_node = lr_document->find_from_name( name = 'Imports' ). "#EC NOTEXT
    IF NOT lr_node IS INITIAL.

      get_import_nodes( EXPORTING ir_node = lr_node
                        CHANGING  cs_data = ls_imports ).
    ENDIF.

    lr_node = lr_document->find_from_path( path = 'SerializeableMappingData/Metadata' ).
    IF NOT lr_node IS INITIAL.

      get_metadata_nodes( EXPORTING ir_node = lr_node
                          CHANGING  cs_data = ls_metadata ).
    ENDIF.

    IF ls_imports-imports IS INITIAL
    AND ls_metadata-files[] IS INITIAL.
      RETURN.
    ENDIF.

    SELECT id subnum file_name file_category last_changed chgusr mime_type
      FROM /fisxee/d_ng_fil
      INTO CORRESPONDING FIELDS OF TABLE lt_file
      WHERE subnum = iv_subnum.

    LOOP AT ls_imports-imports ASSIGNING <ls_import>.
      CLEAR: lt_dateiname,
             lv_index.

      SPLIT <ls_import>-serializeablemappingimport-filename AT '\' INTO TABLE lt_dateiname.
      DESCRIBE TABLE lt_dateiname LINES lv_index.
      IF lv_index > 0.
        READ TABLE lt_dateiname ASSIGNING <ls_dateiname> INDEX lv_index.
        IF sy-subrc = 0.
          lt_file_check = et_files.
          add_file_to_table( EXPORTING iv_subnum   = iv_subnum
                                       iv_filename = <ls_dateiname>
                             IMPORTING es_files    = ls_file
                             CHANGING  ct_files    = et_files ).

        ENDIF.
      ENDIF.
      IF ls_file IS NOT INITIAL AND NOT iv_recursive IS INITIAL.
        get_included_files(
          EXPORTING
            iv_subnum = ls_file-subnum
            iv_id     = ls_file-id
          CHANGING
            et_files = et_files
        ).
      ENDIF.
    ENDLOOP.

    LOOP AT ls_metadata-files ASSIGNING <ls_metadata_files>.
      IF NOT <ls_metadata_files>-filemetadataserializeable-filename IS INITIAL.
        lt_file_check = et_files.
        add_file_to_table( EXPORTING iv_subnum   = iv_subnum
                                     iv_filename = <ls_metadata_files>-filemetadataserializeable-filename
                           CHANGING  ct_files    = et_files ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.                                             "#EC CI_VALPAR


  METHOD get_import_nodes.

    FIELD-SYMBOLS:
      <lv_data> TYPE any,
      <lt_itab> TYPE STANDARD TABLE,
      <lv_typ>  TYPE any,
      <ls_data> TYPE any.

    DATA: lr_node  TYPE REF TO if_ixml_node.
    DATA: lv_name  TYPE string,
          lv_value TYPE string.

    DATA: lv_tabname TYPE string,
          lr_descr   TYPE REF TO cl_abap_typedescr.

    DATA: lv_depth   TYPE i.

    CLEAR: ev_children.

    lr_node = ir_node->get_first_child( ).
    IF lr_node IS INITIAL.
      RETURN.
    ENDIF.

    IF lr_node->get_type( ) <> if_ixml_node=>co_node_element.
      RETURN.
    ENDIF.

    DO.
      CLEAR ev_children.
      lv_name = lr_node->get_name( ).
      lv_value = lr_node->get_value( ).

      TRANSLATE lv_name TO UPPER CASE.

      CONCATENATE 'CS_DATA-' lv_name INTO lv_tabname.
      ASSIGN (lv_tabname) TO <lv_typ>.
      IF sy-subrc > 0.
        ev_children = abap_true.
        lr_node = lr_node->get_next( ).
        IF lr_node IS INITIAL.
          EXIT.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.

      lr_descr = cl_abap_typedescr=>describe_by_data( <lv_typ> ).
      IF lr_descr->type_kind = lr_descr->typekind_table.
        ASSIGN (lv_tabname) TO <lt_itab>.
        IF sy-subrc = 0.
          CLEAR lv_depth.
          lv_depth = lr_node->get_depth( ).
          IF lv_depth > 0.
            APPEND INITIAL LINE TO <lt_itab> ASSIGNING <lv_data>.

            get_import_nodes( EXPORTING ir_node = lr_node
                              IMPORTING ev_children = ev_children
                              CHANGING  cs_data = <lv_data>
                                        ct_data = <lt_itab> ).
          ENDIF.
        ENDIF.
      ELSE.
        ASSIGN COMPONENT lv_name OF STRUCTURE cs_data TO <lv_data>.
        IF sy-subrc > 0.
          lr_node = lr_node->get_next( ).
          IF lr_node IS INITIAL.
            EXIT.
          ELSE.
            CONTINUE.
          ENDIF.

        ELSE.

          IF NOT <lv_data> IS INITIAL.
            APPEND INITIAL LINE TO ct_data ASSIGNING <ls_data>.
            ASSIGN COMPONENT lv_name OF STRUCTURE <ls_data> TO <lv_data>.
          ENDIF.

          get_import_nodes( EXPORTING ir_node = lr_node
                            IMPORTING ev_children = ev_children
                            CHANGING  cs_data = <lv_data> ).

        ENDIF.

      ENDIF.

      IF ev_children <> abap_true
      AND NOT lv_value IS INITIAL.
        <lv_data> = lv_value.
        ev_children = abap_true.
      ENDIF.

      lr_node = lr_node->get_next( ).
      IF lr_node IS INITIAL.
        EXIT.
      ENDIF.

    ENDDO.

  ENDMETHOD.


  METHOD get_metadata_nodes.
    FIELD-SYMBOLS:
      <lv_data>       TYPE any,
      <lt_itab>       TYPE STANDARD TABLE,
      <lv_typ>        TYPE any,
      <lv_typ_deeper> TYPE any,
      <ls_data>       TYPE any.

    DATA: lr_node  TYPE REF TO if_ixml_node.
    DATA: lv_name  TYPE string,
          lv_value TYPE string.

    DATA: lv_tabname TYPE string,
          lr_descr   TYPE REF TO cl_abap_typedescr.
    DATA: lv_depth   TYPE i.

    CLEAR: ev_children.

    lr_node = ir_node->get_first_child( ).
    IF lr_node IS INITIAL.
      RETURN.
    ENDIF.
    IF lr_node->get_type( ) <> if_ixml_node=>co_node_element.
      RETURN.
    ENDIF.

    DO.
      CLEAR ev_children.
      lv_name = lr_node->get_name( ).
      lv_value = lr_node->get_value( ).

      TRANSLATE lv_name TO UPPER CASE.

      CONCATENATE 'CS_DATA-' lv_name INTO lv_tabname.
      ASSIGN (lv_tabname) TO <lv_typ>.
      IF sy-subrc > 0.
*       there's no destination for this field
        ev_children = abap_true.
        lr_node = lr_node->get_next( ).
        IF lr_node IS INITIAL.
          EXIT.
        ELSE.
          CONTINUE.
        ENDIF.
      ENDIF.

      lr_descr = cl_abap_typedescr=>describe_by_data( <lv_typ> ).
      IF lr_descr->type_kind = lr_descr->typekind_table.
        ASSIGN (lv_tabname) TO <lt_itab>.
        IF sy-subrc = 0.
          CLEAR lv_depth.
          lv_depth = lr_node->get_depth( ).
          IF lv_depth > 0.
            APPEND INITIAL LINE TO <lt_itab> ASSIGNING <lv_data>.

            get_metadata_nodes( EXPORTING ir_node     = lr_node
                                IMPORTING ev_children = ev_children
                                CHANGING  cs_data     = <lv_data>
                                          ct_data     = <lt_itab> ).
          ENDIF.
        ENDIF.
      ELSE.
        IF strlen( lv_name ) > 30.
          ASSIGN COMPONENT lv_name(30) OF STRUCTURE cs_data TO <lv_data>.
        ELSE.
          ASSIGN COMPONENT lv_name OF STRUCTURE cs_data TO <lv_data>.
        ENDIF.
        IF sy-subrc > 0.
          lr_node = lr_node->get_next( ).
          IF lr_node IS INITIAL.
            EXIT.
          ELSE.
            CONTINUE.
          ENDIF.

        ELSE.

          IF NOT <lv_data> IS INITIAL.
            APPEND INITIAL LINE TO ct_data ASSIGNING <ls_data>.
            ASSIGN COMPONENT lv_name OF STRUCTURE <ls_data> TO <lv_data>.
          ENDIF.

          get_metadata_nodes( EXPORTING ir_node = lr_node
                             IMPORTING ev_children = ev_children
                             CHANGING  cs_data = <lv_data> ).
        ENDIF.

      ENDIF.

      IF ev_children <> abap_true
      AND NOT lv_value IS INITIAL.
        ASSIGN COMPONENT 'NAME' OF STRUCTURE <lv_typ> TO <lv_typ_deeper>.
        IF sy-subrc = 0.
          <lv_typ_deeper> = lv_value.
        ELSE.
          <lv_data> = lv_value.
        ENDIF.
        ev_children = abap_true.
      ENDIF.

      lr_node = lr_node->get_next( ).
      IF lr_node IS INITIAL.
        EXIT.
      ENDIF.

    ENDDO.
  ENDMETHOD.


  METHOD create_xml_document.
    DATA: lr_ixml          TYPE REF TO if_ixml.
    DATA: lr_streamfactory TYPE REF TO if_ixml_stream_factory,
          lr_istream       TYPE REF TO if_ixml_istream.
    DATA: lr_parser        TYPE REF TO if_ixml_parser.
    DATA: lr_parseerror TYPE REF TO if_ixml_parse_error,
          lv_str        TYPE string,
          lv_i          TYPE i,
          lv_count      TYPE i,
          lv_count_c(6) TYPE c,
          lv_i_c(10)    TYPE c,
          lv_index      TYPE i.
    DATA: lv_errormsg TYPE string,
          lv_title    TYPE string.

    TYPES:
      ts_filename_part TYPE /fisxee/d_ng_fil-file_name,
      tt_filename_part TYPE STANDARD TABLE OF ts_filename_part.

    FIELD-SYMBOLS:
          <ls_filename_part> TYPE ts_filename_part.
    DATA: lt_filename_part TYPE tt_filename_part.

    "Check data, if no XML file exit
    IF iv_filename IS INITIAL.
      RETURN.
    ELSE.
      SPLIT iv_filename AT '.' INTO TABLE lt_filename_part IN CHARACTER MODE.
      IF lt_filename_part IS INITIAL.
        RETURN.
      ELSE.
        DESCRIBE TABLE lt_filename_part LINES lv_index.
        READ TABLE lt_filename_part ASSIGNING <ls_filename_part> INDEX lv_index.
        IF sy-subrc = 0.
          TRANSLATE <ls_filename_part> TO UPPER CASE.
          IF <ls_filename_part> NE 'MAX'.
            RETURN.
          ENDIF.
        ENDIF.
        CLEAR lv_index.
      ENDIF.
    ENDIF.

    lr_ixml = cl_ixml=>create( ).
    lr_streamfactory = lr_ixml->create_stream_factory( ).
    lr_istream = lr_streamfactory->create_istream_xstring( string = iv_data ).
    rr_document = lr_ixml->create_document( ).
    lr_parser = lr_ixml->create_parser( stream_factory = lr_streamfactory
                                        istream        = lr_istream
                                        document       = rr_document ).

    IF lr_parser->parse( ) NE 0.
      IF lr_parser->num_errors( ) NE 0.
        lv_count = lr_parser->num_errors( ).

        lv_index = 0.

        lv_count_c = lv_count.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
          EXPORTING
            input  = lv_count_c
          IMPORTING
            output = lv_count_c.

        CONCATENATE lv_count_c 'Fehler in der Mappingdatei (XML)'(001) INTO lv_errormsg SEPARATED BY space.

        WHILE lv_index < lv_count.
          CONCATENATE lv_errormsg cl_abap_char_utilities=>cr_lf INTO lv_errormsg.

          lr_parseerror = lr_parser->get_error( index = lv_index ).

          lv_i = lr_parseerror->get_line( ).
          lv_i_c = lv_i.
          CONCATENATE lv_errormsg 'Zeile:'(002) lv_i_c cl_abap_char_utilities=>cr_lf INTO lv_errormsg SEPARATED BY space.

          lv_i = lr_parseerror->get_column( ).
          lv_i_c = lv_i.
          CONCATENATE lv_errormsg 'Spalte:'(003) lv_i_c cl_abap_char_utilities=>cr_lf INTO lv_errormsg SEPARATED BY space.

          lv_str = lr_parseerror->get_reason( ).
          CONCATENATE lv_errormsg lv_str cl_abap_char_utilities=>cr_lf INTO lv_errormsg SEPARATED BY space.

          CONCATENATE lv_errormsg cl_abap_char_utilities=>cr_lf INTO lv_errormsg.

          lv_index = lv_index + 1.
        ENDWHILE.

      ENDIF.
    ENDIF.

    lr_istream->close( ).
    CLEAR lr_istream.
  ENDMETHOD.


  METHOD add_file_to_table.

    FIELD-SYMBOLS:
      <ls_file_db> TYPE /fisxee/d_ng_fil,
      <ls_file>    TYPE /fisxee/d_ng_fil.

    CLEAR: es_files.

    SELECT SINGLE *
    FROM /fisxee/d_ng_fil
    INTO @DATA(ls_file)
    WHERE file_name = @iv_filename
    AND subnum = @iv_subnum.

    ASSIGN ls_file TO <ls_file_db>.


    READ TABLE ct_files
      WITH KEY file_name = iv_filename
      TRANSPORTING NO FIELDS.
    IF sy-subrc = 0.
      RETURN.
    ENDIF.

    APPEND INITIAL LINE TO ct_files ASSIGNING <ls_file>.

    IF <ls_file_db> IS ASSIGNED.
      MOVE-CORRESPONDING <ls_file_db> TO <ls_file>.
    ENDIF.
    <ls_file>-file_name = iv_filename.

    es_files = <ls_file>.

  ENDMETHOD.                                             "#EC CI_VALPAR
ENDCLASS.
