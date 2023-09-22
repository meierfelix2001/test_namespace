CLASS /fisxee/mpa_import_export DEFINITION PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF ts_import,
             mpa TYPE /fisxee/t_ng_mpa,
             is  TYPE /fisxee/t_ng_is,
             mdf TYPE  /fisxee/t_ng_mdf,
             msc TYPE /fisxee/t_ng_msc,
             mse TYPE /fisxee/t_ng_mse,
             msr TYPE /fisxee/t_ng_msr,
             mst TYPE /fisxee/t_ng_mst,
             msx TYPE /fisxee/t_ng_msx,
             mvc TYPE /fisxee/t_ng_mvc,
             bp  TYPE /fisxee/t_ng_bp,
             msv TYPE /fisxee/t_ng_msv,
             mpp TYPE /fisxee/t_ng_mpp,
             mpv TYPE /fisxee/t_ng_mpv,
           END OF ts_import.

    TYPES: BEGIN OF ts_export,
             mpa TYPE /fisxee/d_ng_mpa,
             is  TYPE /fisxee/d_ng_is,
             mdf TYPE  /fisxee/t_ng_mdf,
             msc TYPE /fisxee/t_ng_msc,
             mse TYPE /fisxee/t_ng_mse,
             msr TYPE /fisxee/t_ng_msr,
             mst TYPE /fisxee/t_ng_mst,
             msx TYPE /fisxee/t_ng_msx,
             mvc TYPE /fisxee/t_ng_mvc,
             bp  TYPE /fisxee/t_ng_bp,
             cha TYPE /fisxee/t_ng_cha,
             tc  TYPE /fisxee/t_ng_tc,
             tcc TYPE /fisxee/t_ng_tcc,
             tci TYPE /fisxee/t_ng_tci,
             tcp TYPE /fisxee/t_ng_tcp,
             mpv TYPE /fisxee/t_ng_mpv,
             msv TYPE /fisxee/t_ng_msv,
             mpp TYPE /fisxee/t_ng_mpp,
             pa  TYPE /fisxee/t_ng_pa,
             fil TYPE /fisxee/t_ng_fil,
             fc  TYPE /fisxee/t_ng_fc,
           END OF ts_export.
    TYPES : BEGIN OF ts_str,
              name TYPE string,
            END OF ts_str.
    TYPES:

      BEGIN OF ts_tab,
        tabname TYPE ddobjname,
        dbcnt   TYPE sy-dbcnt,
        daten   TYPE REF TO data.
    TYPES: END OF ts_tab .
    TYPES:
      tt_tabs TYPE TABLE OF ts_tab .
    TYPES:
      BEGIN OF ts_xml_line,
        data(1024) TYPE x,
      END OF ts_xml_line .
    TYPES:
      tt_xml_tab TYPE TABLE OF ts_xml_line .



    CLASS-METHODS get_data_for_export
      IMPORTING
        iv_mpa_id   TYPE /fisxee/ng_message_party_id
        iv_subnum   TYPE /fisxee/ng_subsystem_num
      EXPORTING
        ev_xml_data TYPE xstring.

    CLASS-METHODS search_duplicates_for_import2
      IMPORTING
        iv_mpa_xml     TYPE string
        iv_subnum      TYPE /fisxee/ng_subsystem_num
      EXPORTING
        ev_json_green  TYPE string
        ev_json_grey   TYPE string
        ev_json_yellow TYPE string
        ev_json_red    TYPE string
        ev_mpa_new     TYPE boolean
        ev_bp_id       TYPE /fisxee/ng_bp_id
        ev_bp_new      TYPE boolean
        ev_bp_id2      TYPE /fisxee/ng_bp_id
        ev_bp_new2     TYPE boolean.

    CLASS-METHODS import_mpa
      IMPORTING
        iv_subnum      TYPE /fisxee/ng_subsystem_num
        iv_json_green  TYPE string
        iv_json_grey   TYPE string
        iv_json_yellow TYPE string
        iv_json_red    TYPE string
      .
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      ty_it_table_names TYPE STANDARD TABLE OF ts_str WITH DEFAULT KEY.

    CLASS-METHODS import_to_database
      IMPORTING
        ls_new    TYPE ts_import
        ls_update TYPE ts_import.
ENDCLASS.



CLASS /FISXEE/MPA_IMPORT_EXPORT IMPLEMENTATION.


  METHOD get_data_for_export.

*  MPA HEAD
    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpa
    INTO @DATA(ls_mpa)
    WHERE subnum EQ @iv_subnum
    AND id EQ @iv_mpa_id.


* Nachrichtendefinition

    SELECT *                                  "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mdf
    INTO TABLE @DATA(lt_mdf)
    WHERE id EQ @ls_mpa-message_definition_id.

    IF lt_mdf IS NOT INITIAL.
      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_msc
      FOR ALL ENTRIES IN @lt_mdf                   "#EC CI_NO_TRANSFORM
      WHERE scanrule_id EQ @lt_mdf-scan_id
      INTO TABLE @DATA(lt_msc).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_mse
      FOR ALL ENTRIES IN @lt_mdf                   "#EC CI_NO_TRANSFORM
      WHERE scanrule_id EQ @lt_mdf-scan_id
      INTO TABLE @DATA(lt_mse).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_msr
      FOR ALL ENTRIES IN @lt_mdf                   "#EC CI_NO_TRANSFORM
      WHERE id EQ @lt_mdf-scan_id
      INTO TABLE @DATA(lt_msr).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_mst
      FOR ALL ENTRIES IN @lt_mdf                   "#EC CI_NO_TRANSFORM
      WHERE scanrule_id EQ @lt_mdf-scan_id
      INTO TABLE @DATA(lt_mst).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_msx
      FOR ALL ENTRIES IN @lt_mdf                   "#EC CI_NO_TRANSFORM
      WHERE scanrule_id EQ @lt_mdf-scan_id
      INTO TABLE @DATA(lt_msx).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_mvc ##SELECT_FAE_WITH_LOB[CONFIG_VALUE]
      FOR ALL ENTRIES IN @lt_mdf                   "#EC CI_NO_TRANSFORM
      WHERE message_value_scan_rule_id EQ @lt_mdf-scan_id
      INTO TABLE @DATA(lt_mvc).
    ENDIF.

* Business Partner
    SELECT *                                  "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_bp
    INTO TABLE @DATA(lt_bp)
    WHERE subnum EQ @iv_subnum
    AND ( id EQ @ls_mpa-bp_id_sender OR id EQ @ls_mpa-bp_id_receiver ).


    IF lt_bp IS NOT INITIAL.
* Kommunikationskanäle
      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_cha
      FOR ALL ENTRIES IN @lt_bp                    "#EC CI_NO_TRANSFORM
      WHERE subnum EQ @iv_subnum
      AND ( id EQ @lt_bp-default_receive_channel_id OR id EQ @lt_bp-default_send_channel_id OR id EQ @ls_mpa-send_channel_id OR id EQ @ls_mpa-receive_channel_id )
      INTO TABLE @DATA(lt_cha).

    ENDIF.
*  Zeitsteuerung der Kommunikationskanäle
    IF lt_cha IS NOT INITIAL.
      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_tc
      FOR ALL ENTRIES IN @lt_cha                   "#EC CI_NO_TRANSFORM
      WHERE id EQ @lt_cha-time_control
      INTO TABLE @DATA(lt_tc).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_tcc
      FOR ALL ENTRIES IN @lt_cha                   "#EC CI_NO_TRANSFORM
      WHERE time_control_id EQ @lt_cha-time_control
      INTO TABLE @DATA(lt_tcc).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_tci
      FOR ALL ENTRIES IN @lt_cha                   "#EC CI_NO_TRANSFORM
      WHERE time_control_id EQ @lt_cha-time_control
      INTO TABLE @DATA(lt_tci).

      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_tcp
      FOR ALL ENTRIES IN @lt_cha                   "#EC CI_NO_TRANSFORM
      WHERE time_control_id EQ @lt_cha-time_control
      INTO TABLE @DATA(lt_tcp).
    ENDIF.
* Scanwerte

    SELECT *                                  "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpv
    INTO TABLE @DATA(lt_mpv)
    WHERE message_party_id EQ @ls_mpa-id.

    IF lt_mpv IS NOT INITIAL.
      SELECT *                                "#EC CI_ALL_FIELDS_NEEDED
      FROM /fisxee/d_ng_msv
      FOR ALL ENTRIES IN @lt_mpv                   "#EC CI_NO_TRANSFORM
      WHERE id EQ @lt_mpv-message_scan_id
      INTO TABLE @DATA(lt_msv).
    ENDIF.

* Parameter

    SELECT *                                  "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpp
    INTO TABLE @DATA(lt_mpp)
    WHERE message_party_id EQ @ls_mpa-id.

* Integrationsszenario

    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_is
    INTO @DATA(ls_is)
    WHERE id EQ @ls_mpa-integration_scenario_id.


    SELECT *                                  "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_pa
    INTO TABLE @DATA(lt_pa)
    WHERE integration_scenario_id EQ @ls_is-id.
*    Prozessdefinition

    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_fil
    INTO @DATA(ls_fil)
    WHERE id EQ @ls_is-processdef_file_id
    AND subnum EQ @ls_mpa-subnum.



    DATA: lt_fil TYPE TABLE OF /fisxee/d_ng_fil.

* Mapping
    SELECT fil~id, fil~subnum, fil~file_name, fil~file_category, fil~last_changed, fil~chgusr, fil~mime_type
    FROM /fisxee/d_ng_fil AS fil
    INNER JOIN /fisxee/d_ng_pa AS pa
    ON pa~integration_scenario_id = @ls_is-id
    AND pa~argument_type = 'Mapping' ##NO_TEXT
    AND pa~argument_value = fil~id
    INTO CORRESPONDING FIELDS OF TABLE @lt_fil.


    APPEND ls_fil TO lt_fil.

    SELECT  *                                 "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_fc ##SELECT_FAE_WITH_LOB[CONTENT]
    FOR ALL ENTRIES IN @lt_fil                     "#EC CI_NO_TRANSFORM
    WHERE  file_id EQ @lt_fil-id
    AND is_active EQ @abap_true
    INTO TABLE @DATA(lt_fc).

    TYPES: BEGIN OF ts_export,
             mpa LIKE ls_mpa,
             mdf LIKE lt_mdf,
             msc LIKE lt_msc,
             mse LIKE lt_mse,
             msr LIKE lt_msr,
             mst LIKE lt_mst,
             msx LIKE lt_msx,
             mvc LIKE lt_mvc,
             bp  LIKE lt_bp,
             cha LIKE lt_cha,
             tc  LIKE lt_tc,
             tcc LIKE lt_tcc,
             tci LIKE lt_tci,
             tcp LIKE lt_tcp,
             mpv LIKE lt_mpv,
             msv LIKE lt_msv,
             mpp LIKE lt_mpp,
             is  LIKE ls_is,
             pa  LIKE lt_pa,
             fil LIKE lt_fil,
             fc  LIKE lt_fc,
           END OF ts_export.

    DATA ls_export TYPE ts_export.

    ls_export-mpa = ls_mpa.
    ls_export-mdf = lt_mdf.
    ls_export-msc = lt_msc.
    ls_export-mse = lt_mse.
    ls_export-msr = lt_msr.
    ls_export-mst = lt_mst.
    ls_export-msx = lt_msx.
    ls_export-mvc = lt_mvc.
    ls_export-bp = lt_bp.
    ls_export-cha = lt_cha.
    ls_export-tc = lt_tc.
    ls_export-tcc = lt_tcc.
    ls_export-tci = lt_tci.
    ls_export-tcp = lt_tcp.
    ls_export-mpv = lt_mpv.
    ls_export-msv = lt_msv.
    ls_export-mpp = lt_mpp.
    ls_export-is = ls_is.
    ls_export-pa = lt_pa.
    ls_export-fil = lt_fil.
    ls_export-fc = lt_fc.

    TRY.
        CALL TRANSFORMATION ('ID')
        SOURCE tab = ls_export
        RESULT XML ev_xml_data.
      CATCH cx_transformation_error.
*      write:/ 'Fehler beim Erstellen des XML-Streams'.
        RETURN.
    ENDTRY.
  ENDMETHOD.


  METHOD import_mpa.

    DATA lt_import_ready_new TYPE ts_import.
    DATA lt_import_ready_update TYPE ts_import.


    DATA mo_sys_info TYPE REF TO /fisxee/if_ng_system_info .
    mo_sys_info = /fisxee/cl_ng_factory=>get_system_info( ).


    DATA lt_importdata_green TYPE ts_import.
    DATA lt_importdata_red TYPE ts_import.
    DATA lt_importdata_yellow TYPE ts_import.
    DATA lt_importdata_grey TYPE ts_import.


    " deserialize JSON string json into internal table lt_flight doing camelCase to ABAP like field name mapping
    /ui2/cl_json=>deserialize( EXPORTING json = iv_json_green pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_importdata_green ).

    " deserialize JSON string json into internal table lt_flight doing camelCase to ABAP like field name mapping
    /ui2/cl_json=>deserialize( EXPORTING json = iv_json_red pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_importdata_red ).

    " deserialize JSON string json into internal table lt_flight doing camelCase to ABAP like field name mapping
    /ui2/cl_json=>deserialize( EXPORTING json = iv_json_yellow pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_importdata_yellow ).

    " deserialize JSON string json into internal table lt_flight doing camelCase to ABAP like field name mapping
    /ui2/cl_json=>deserialize( EXPORTING json = iv_json_grey pretty_name = /ui2/cl_json=>pretty_mode-camel_case CHANGING data = lt_importdata_grey ).


    LOOP AT lt_importdata_red-mpa   ASSIGNING FIELD-SYMBOL(<fs_mpa_red>).
*wenn was drinnen ist, den rest abbrechen.
      IF <fs_mpa_red>-id NE ''.
        RETURN.
      ENDIF.
    ENDLOOP.
    LOOP AT lt_importdata_grey-mpa   ASSIGNING FIELD-SYMBOL(<fs_mpa_grey>).
      IF <fs_mpa_grey>-id NE ''.
        RETURN.
      ENDIF.
    ENDLOOP.
    LOOP AT  lt_importdata_green-mpa ASSIGNING FIELD-SYMBOL(<fs_mpa>).

*Businesspartner
      LOOP AT lt_importdata_green-bp ASSIGNING FIELD-SYMBOL(<fs_bp>).
        <fs_bp>-subnum = iv_subnum.
        <fs_bp>-chgusr = sy-uname.
        <fs_bp>-last_changed = mo_sys_info->get_current_timestamp( ).
        <fs_bp>-mandt = sy-mandt.

        SELECT SINGLE *                       "#EC CI_ALL_FIELDS_NEEDED
               FROM /fisxee/d_ng_bp
               INTO  @DATA(ls_bp)
               WHERE subnum EQ @iv_subnum
               AND id EQ @<fs_bp>-id.

        SELECT SINGLE *                       "#EC CI_ALL_FIELDS_NEEDED
               FROM /fisxee/d_ng_bp
               INTO  @DATA(ls_bp2)
               WHERE id EQ @<fs_bp>-id
               AND subnum NE @iv_subnum.

        IF ls_bp-id IS NOT INITIAL.
          APPEND <fs_bp> TO   lt_import_ready_update-bp.
        ELSEIF ls_bp2-id IS NOT INITIAL. "id ist schon auf einem anderem Subsystem vorhanden
          TRY.
              <fs_bp>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
            CATCH /fisxee/cx_ng_uuid.
              "handle exception
          ENDTRY.

          IF <fs_mpa>-bp_id_receiver EQ ls_bp2-id.
            <fs_mpa>-bp_id_receiver = <fs_bp>-id.
          ELSEIF <fs_mpa>-bp_id_sender EQ ls_bp2-id.
            <fs_mpa>-bp_id_sender = <fs_bp>-id.
          ENDIF.

          APPEND <fs_bp> TO lt_import_ready_new-bp.
        ELSE.
          APPEND <fs_bp> TO lt_import_ready_new-bp.
        ENDIF.
      ENDLOOP.

      LOOP AT lt_importdata_yellow-bp ASSIGNING FIELD-SYMBOL(<fs_bp_yellow>).
        SELECT SINGLE *          "#EC CI_ALL_FIELDS_NEEDED
        FROM /fisxee/d_ng_bp     "#EC WARNOK
        INTO  @DATA(ls_bp3)
        WHERE subnum EQ @iv_subnum
        AND name EQ @<fs_bp_yellow>-name.

        IF <fs_bp_yellow>-id EQ <fs_mpa>-bp_id_receiver.
          <fs_mpa>-bp_id_receiver = ls_bp3-id.
        ELSEIF <fs_bp_yellow>-id EQ <fs_mpa>-bp_id_sender.
          <fs_mpa>-bp_id_sender = ls_bp3-id.
        ENDIF.
      ENDLOOP.

*Integrationsszenario
      LOOP AT lt_importdata_green-is ASSIGNING FIELD-SYMBOL(<fs_is_green>).

        SELECT SINGLE *                       "#EC CI_ALL_FIELDS_NEEDED
        FROM /fisxee/d_ng_is
        INTO @DATA(ls_is3)
        WHERE subnum NE @iv_subnum
        AND id EQ @<fs_is_green>-id.

        IF ls_is3-id IS NOT INITIAL.
          TRY.
              <fs_is_green>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
            CATCH /fisxee/cx_ng_uuid.
              "handle exception
          ENDTRY.
          <fs_mpa>-integration_scenario_id = <fs_is_green>-id.
        ENDIF.

        <fs_is_green>-processdef_file_id = ''.
        <fs_is_green>-subnum = iv_subnum.
        <fs_is_green>-last_changed = mo_sys_info->get_current_timestamp( ).
        <fs_is_green>-chgusr = sy-uname.
        <fs_is_green>-mandt = sy-mandt.
        APPEND <fs_is_green> TO lt_import_ready_new-is.
      ENDLOOP.

      LOOP AT lt_importdata_yellow-is ASSIGNING FIELD-SYMBOL(<fs_is_yellow>).
        SELECT SINGLE id                                "#EC CI_NOORDER
        FROM /fisxee/d_ng_is
        INTO @DATA(ls_is)
        WHERE name EQ @<fs_is_yellow>-name
        AND subnum EQ @iv_subnum.

        <fs_mpa>-integration_scenario_id = ls_is.
      ENDLOOP.

*MDF
      DATA ls_mdf TYPE /fisxee/d_ng_mdf.
      DATA ls_msv TYPE /fisxee/d_ng_msv.
      LOOP AT lt_importdata_green-mdf ASSIGNING FIELD-SYMBOL(<fs_mdf_green>).
        ls_mdf-scan_id = <fs_mdf_green>-scan_id.
        ls_mdf-id = <fs_mdf_green>-id.

        TRY.
            <fs_mdf_green>-scan_id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
          CATCH /fisxee/cx_ng_uuid.
            "handle exception
        ENDTRY.

*        SELECT SINGLE id                      "#EC CI_ALL_FIELDS_NEEDED
*        FROM /fisxee/d_ng_mdf
*        INTO  @DATA(ls_mdf2)
*        WHERE name EQ @<fs_mdf_green>-name
*        AND subnum EQ @iv_subnum.
*
*        IF ls_mdf2 EQ ''.

        <fs_mdf_green>-subnum = iv_subnum.
        <fs_mdf_green>-last_changed = mo_sys_info->get_current_timestamp( ).
        <fs_mdf_green>-chgusr = sy-uname.
        <fs_mdf_green>-mandt = sy-mandt.



***********************************************************
*Nachrichtendefinition bekommt immer eine neue id. (/FISXEE/D_NG_MDF)
        TRY.
            <fs_mdf_green>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
          CATCH /fisxee/cx_ng_uuid.
            "handle exception
        ENDTRY.

        <fs_mpa>-message_definition_id = <fs_mdf_green>-id.
        APPEND <fs_mdf_green> TO lt_import_ready_new-mdf.

        LOOP AT lt_importdata_green-msr ASSIGNING FIELD-SYMBOL(<fs_msr_green>).
          IF <fs_msr_green>-id EQ ls_mdf-scan_id.
            <fs_msr_green>-id = <fs_mdf_green>-scan_id.
            APPEND <fs_msr_green> TO lt_import_ready_new-msr.
          ENDIF.
        ENDLOOP.

        LOOP AT lt_importdata_green-msc ASSIGNING FIELD-SYMBOL(<fs_msc_green>).
          IF <fs_msc_green>-scanrule_id EQ ls_mdf-scan_id.
            <fs_msc_green>-scanrule_id = <fs_mdf_green>-scan_id.
            APPEND <fs_msc_green> TO lt_import_ready_new-msc.
          ENDIF.
        ENDLOOP.

        LOOP AT lt_importdata_green-mse ASSIGNING FIELD-SYMBOL(<fs_mse_green>).
          IF <fs_mse_green>-scanrule_id EQ ls_mdf-scan_id.
            <fs_mse_green>-scanrule_id = <fs_mdf_green>-scan_id.
            APPEND <fs_mse_green> TO lt_import_ready_new-mse.
          ENDIF.
        ENDLOOP.

        LOOP AT lt_importdata_green-mst ASSIGNING FIELD-SYMBOL(<fs_mst_green>).
          IF <fs_mst_green>-scanrule_id EQ ls_mdf-scan_id.
            <fs_mst_green>-scanrule_id = <fs_mdf_green>-scan_id.
            APPEND <fs_mst_green> TO lt_import_ready_new-mst.
          ENDIF.
        ENDLOOP.

        LOOP AT lt_importdata_green-msx ASSIGNING FIELD-SYMBOL(<fs_msx_green>).
          IF <fs_msx_green>-scanrule_id EQ ls_mdf-scan_id.
            <fs_msx_green>-scanrule_id = <fs_mdf_green>-scan_id.
            APPEND <fs_msx_green> TO lt_import_ready_new-msx.
          ENDIF.
        ENDLOOP.

        LOOP AT lt_importdata_green-msv ASSIGNING FIELD-SYMBOL(<fs_msv_green>).
          ls_msv-id = <fs_msv_green>-id.
          ls_msv-message_definition_id = <fs_msv_green>-message_definition_id.

          IF <fs_msv_green>-message_definition_id EQ ls_mdf-id.
            <fs_msv_green>-message_definition_id = <fs_mdf_green>-id.
            TRY.
                <fs_msv_green>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
              CATCH /fisxee/cx_ng_uuid.
                "handle exception
            ENDTRY.


            LOOP AT lt_importdata_green-mvc ASSIGNING FIELD-SYMBOL(<fs_mvc_green>).
              IF <fs_mvc_green>-message_value_scan_rule_id EQ ls_msv-id.
                <fs_mvc_green>-message_value_scan_rule_id = <fs_msv_green>-id.
                APPEND <fs_mvc_green> TO lt_import_ready_new-mvc.
              ENDIF.
            ENDLOOP.
            APPEND <fs_msv_green> TO lt_import_ready_new-msv.
          ENDIF.
        ENDLOOP.
      ENDLOOP.

*
      LOOP AT lt_importdata_yellow-mdf ASSIGNING FIELD-SYMBOL(<fs_mdf_yellow>).

        SELECT SINGLE id                                "#EC CI_NOORDER
        FROM /fisxee/d_ng_mdf
        INTO @DATA(lv_id)
        WHERE name EQ @<fs_mdf_yellow>-name
        AND subnum EQ @iv_subnum.

        <fs_mpa>-message_definition_id = lv_id.
      ENDLOOP.
    ENDLOOP.

***************************************
*MPA noch in die Import tabelle schreiben!


    SELECT SINGLE id                          "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpa
    INTO @DATA(lv_mpa)
    WHERE subnum EQ @iv_subnum
    AND id EQ @<fs_mpa>-id.

    SELECT SINGLE id             "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpa        "#EC WARNOK
    INTO @DATA(lv_mpa2)
    WHERE subnum EQ @iv_subnum
    AND name EQ @<fs_mpa>-name.

    SELECT SINGLE id             "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpa        "#EC WARNOK
    INTO @DATA(lv_mpa3)
    WHERE subnum NE @iv_subnum
    AND name EQ @<fs_mpa>-name.

    <fs_mpa>-subnum = iv_subnum.
    <fs_mpa>-last_changed = mo_sys_info->get_current_timestamp( ).
    <fs_mpa>-chgusr = sy-uname.
    <fs_mpa>-mandt = sy-mandt.

    IF lv_mpa EQ '' AND lv_mpa2 EQ '' AND lv_mpa3 EQ ''.
      APPEND <fs_mpa> TO lt_import_ready_new-mpa.
    ELSEIF lv_mpa NE ''.
      APPEND <fs_mpa> TO lt_import_ready_update-mpa.
    ELSEIF lv_mpa2 NE '' .
      <fs_mpa>-id = lv_mpa2.
      APPEND <fs_mpa> TO lt_import_ready_update-mpa.
    ELSE.
      TRY.
          <fs_mpa>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
        CATCH /fisxee/cx_ng_uuid.
          "handle exception
      ENDTRY.
      APPEND <fs_mpa> TO lt_import_ready_new-mpa.
    ENDIF.

    import_to_database(
      EXPORTING
        ls_new    = lt_import_ready_new
        ls_update = lt_import_ready_update
    ).


  ENDMETHOD.


  METHOD import_to_database.
*ls_new -> einfach rein
*ls_update -> id nehmen und felder aktualisieren

    INSERT /fisxee/d_ng_bp FROM TABLE ls_new-bp.
    MODIFY /fisxee/d_ng_bp FROM TABLE ls_update-bp.

    INSERT /fisxee/d_ng_is FROM TABLE ls_new-is.


    INSERT /fisxee/d_ng_mdf FROM TABLE ls_new-mdf.
    INSERT /fisxee/d_ng_msr FROM TABLE ls_new-msr.
    INSERT /fisxee/d_ng_msc FROM TABLE ls_new-msc.
    INSERT /fisxee/d_ng_mse FROM TABLE ls_new-mse.
    INSERT /fisxee/d_ng_mst FROM TABLE ls_new-mst.
    INSERT /fisxee/d_ng_msx FROM TABLE ls_new-msx.
    INSERT /fisxee/d_ng_msv FROM TABLE ls_new-msv.
    INSERT /fisxee/d_ng_mvc FROM TABLE ls_new-mvc.



    INSERT /fisxee/d_ng_mpa FROM TABLE ls_new-mpa.
    MODIFY /fisxee/d_ng_mpa FROM TABLE ls_update-mpa.

  ENDMETHOD.


  METHOD search_duplicates_for_import2.



    DATA it_table_names TYPE TABLE OF ts_str.


    APPEND VALUE #( name = 'FISXEE_D_NG_MPA' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_IS' )  TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MDF' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MSC' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MSE' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MSR' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MST' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MSX' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MVC' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_BP' )  TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MSV' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MPP' ) TO it_table_names.
    APPEND VALUE #( name = 'FISXEE_D_NG_MPV' ) TO it_table_names.


*XML Struktur zu Itabs wandeln
    DATA lt_importdata TYPE ts_export.
    CALL TRANSFORMATION id SOURCE XML iv_mpa_xml RESULT tab = lt_importdata.

    DATA ls_existing TYPE ts_export.
    DATA ls_notexisting TYPE ts_export.


    DATA ls_red TYPE ts_import.
    DATA ls_green TYPE ts_import.
    DATA ls_yellow TYPE ts_import.
    DATA ls_grey TYPE ts_import.


*Kopftabelle PNB

    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpa
    INTO @DATA(ls_mpa)
    WHERE subnum EQ @iv_subnum
    AND id EQ @lt_importdata-mpa-id.

    SELECT SINGLE *              "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_mpa        "#EC WARNOK
    INTO @DATA(ls_mpa2)
    WHERE subnum EQ @iv_subnum
    AND name EQ @lt_importdata-mpa-name.

    ev_mpa_new = abap_false.
    IF ls_mpa-id EQ ''. "id nicht vohanden
      IF ls_mpa2-id NE ''. "name vorhanden
        APPEND lt_importdata-mpa TO ls_grey-mpa. "id nicht + name vorhanden
      ELSE.
        APPEND lt_importdata-mpa TO ls_green-mpa."id nicht + name nicht
        ev_mpa_new = abap_true.
      ENDIF.
    ELSE. " id vorhanden
      IF ls_mpa-activate_process_trace EQ lt_importdata-mpa-activate_process_trace AND ls_mpa-bp_id_receiver EQ lt_importdata-mpa-bp_id_receiver AND ls_mpa-bp_id_sender EQ lt_importdata-mpa-bp_id_sender
      AND ls_mpa-encoding EQ lt_importdata-mpa-encoding AND ls_mpa-icn_key EQ lt_importdata-mpa-icn_key AND ls_mpa-id EQ lt_importdata-mpa-id AND ls_mpa-message_definition_id EQ lt_importdata-mpa-message_definition_id
      AND ls_mpa-name EQ lt_importdata-mpa-name AND ls_mpa-process_parallel EQ lt_importdata-mpa-process_parallel AND ls_mpa-subnum EQ iv_subnum. " alle felder gleich
        APPEND lt_importdata-mpa TO ls_grey-mpa."id da + alle felder gleich
      ELSEIF ls_mpa-name EQ lt_importdata-mpa-name. " id + name gleich
        APPEND lt_importdata-mpa TO ls_green-mpa.
      ELSE.
        APPEND lt_importdata-mpa TO ls_red-mpa.
      ENDIF.
    ENDIF.


*BusinessPartner
    IF lt_importdata-bp IS NOT INITIAL.

      LOOP AT lt_importdata-bp ASSIGNING FIELD-SYMBOL(<fs_bp>).

        SELECT SINGLE *                       "#EC CI_ALL_FIELDS_NEEDED
        FROM /fisxee/d_ng_bp
        INTO  @DATA(ls_bp)
        WHERE subnum EQ @iv_subnum
        AND id EQ @<fs_bp>-id.

        SELECT SINGLE *                       "#EC CI_ALL_FIELDS_NEEDED
        FROM /fisxee/d_ng_bp                                "#EC WARNOK
        INTO  @DATA(ls_bp2)
        WHERE subnum EQ @iv_subnum
        AND name EQ @<fs_bp>-name.

        <fs_bp>-default_send_channel_id = ''.
        <fs_bp>-default_receive_channel_id = ''.

        IF ev_bp_id IS INITIAL.
          ev_bp_id = <fs_bp>-id.
          ev_bp_new = abap_true.
        ELSE.
          ev_bp_id2 = <fs_bp>-id.
          ev_bp_new2 = abap_true.
        ENDIF.

        IF ls_bp-id EQ ''. " id nicht vorhanden
          IF ls_bp2-id NE ''. "name vorhanden
            APPEND <fs_bp> TO ls_yellow-bp. "id nicht, name schon
          ELSE.
            APPEND <fs_bp> TO ls_green-bp. " id nicht, name nicht
          ENDIF.
        ELSE. "id da
          IF ls_bp-business_partner EQ <fs_bp>-business_partner AND ls_bp-id EQ <fs_bp>-id AND ls_bp-location EQ <fs_bp>-location AND ls_bp-name EQ <fs_bp>-name AND ls_bp-state EQ <fs_bp>-state AND ls_bp-subnum EQ iv_subnum. "alles da
            APPEND <fs_bp> TO ls_grey-bp.

          ELSEIF ls_bp-name EQ <fs_bp>-name. "id + name
            APPEND <fs_bp> TO ls_green-bp.

            IF ev_bp_new2 IS INITIAL.
              ev_bp_new = abap_false.
            ELSE.
              ev_bp_new2 = abap_false.
            ENDIF.
          ELSE.
            APPEND <fs_bp> TO ls_red-bp.
          ENDIF.
        ENDIF.
        CLEAR ls_bp.
        CLEAR ls_bp2.
      ENDLOOP.
    ENDIF.


* Nachrichtendefinition ----> geht nur eine
    IF lt_importdata-mdf IS NOT INITIAL.
      LOOP AT lt_importdata-mdf ASSIGNING FIELD-SYMBOL(<fs_mdf>).
        SELECT SINGLE *                       "#EC CI_ALL_FIELDS_NEEDED
        FROM /fisxee/d_ng_mdf
        INTO  @DATA(ls_mdf)
        WHERE id EQ @<fs_mdf>-id
        AND subnum EQ @iv_subnum.

        SELECT SINGLE *          "#EC CI_ALL_FIELDS_NEEDED
        FROM /fisxee/d_ng_mdf    "#EC WARNOK
        INTO  @DATA(ls_mdf2)
        WHERE name EQ @<fs_mdf>-name
        AND subnum EQ @iv_subnum.


        IF ls_mdf-id EQ ''. "id nicht vorhanden
          IF ls_mdf2-id NE ''. "name da
            APPEND <fs_mdf> TO ls_yellow-mdf. "id ne, name ja
          ELSE.
            APPEND <fs_mdf> TO ls_green-mdf. "id ne, name ne
          ENDIF.
        ELSE. "id da
          IF ls_mdf-name EQ <fs_mdf>-name AND ls_mdf-id EQ <fs_mdf>-id AND ls_mdf-bp_split_file_id EQ <fs_mdf>-bp_split_file_id AND ls_mdf-cat_id EQ <fs_mdf>-cat_id AND ls_mdf-scan_id EQ <fs_mdf>-scan_id AND ls_mdf-subnum EQ iv_subnum. "alles da
            APPEND <fs_mdf> TO ls_grey-mdf.

          ELSEIF ls_mdf-name EQ <fs_mdf>-name. "id ja, name ja
            APPEND <fs_mdf> TO ls_red-mdf.
          ELSE.
            APPEND <fs_mdf> TO ls_red-mdf.
          ENDIF.
        ENDIF.

        DESCRIBE TABLE ls_green-mdf LINES DATA(lv_count2).
        IF lv_count2 NE 0.

          LOOP AT lt_importdata-msc ASSIGNING FIELD-SYMBOL(<fs_msc>).
            TRY.
                <fs_msc>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
              CATCH /fisxee/cx_ng_uuid.
                "handle exception
            ENDTRY.
          ENDLOOP.
          APPEND LINES OF lt_importdata-msc TO ls_green-msc.


          LOOP AT lt_importdata-mse ASSIGNING FIELD-SYMBOL(<fs_mse>).
            TRY.
                <fs_mse>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
              CATCH /fisxee/cx_ng_uuid.
                "handle exception
            ENDTRY.
          ENDLOOP.
          APPEND LINES OF lt_importdata-mse TO ls_green-mse.

          LOOP AT lt_importdata-mst ASSIGNING FIELD-SYMBOL(<fs_mst>).
            TRY.
                <fs_mst>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
              CATCH /fisxee/cx_ng_uuid.
                "handle exception
            ENDTRY.
          ENDLOOP.
          APPEND LINES OF lt_importdata-mst TO ls_green-mst.

          LOOP AT lt_importdata-msx ASSIGNING FIELD-SYMBOL(<fs_msx>).
            TRY.
                <fs_msx>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
              CATCH /fisxee/cx_ng_uuid.
                "handle exception
            ENDTRY.
          ENDLOOP.
          APPEND LINES OF lt_importdata-msx TO ls_green-msx.

          LOOP AT lt_importdata-mvc ASSIGNING FIELD-SYMBOL(<fs_mvc>).
            TRY.
                <fs_mvc>-id = /fisxee/cl_ng_factory=>get_uuid( )->create_uuid_c36( ).
              CATCH /fisxee/cx_ng_uuid.
                "handle exception
            ENDTRY.
          ENDLOOP.
          APPEND LINES OF lt_importdata-mvc TO ls_green-mvc.

          APPEND LINES OF lt_importdata-msr TO ls_green-msr.
          APPEND LINES OF lt_importdata-msv TO ls_green-msv.
        ENDIF.
      ENDLOOP.
    ENDIF.

* Integrationsszenario
    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_is
    INTO @DATA(ls_is)
    WHERE id EQ @lt_importdata-is-id
    AND subnum EQ @iv_subnum.

    SELECT SINGLE *                           "#EC CI_ALL_FIELDS_NEEDED
    FROM /fisxee/d_ng_is                                    "#EC WARNOK
    INTO @DATA(ls_is2)
    WHERE name EQ @lt_importdata-is-name
    AND subnum EQ @iv_subnum.

    lt_importdata-is-processdef_file_id = ''.

    IF ls_is-id EQ ''. "id nicht vorhanden
      IF ls_is2-id NE ''. "name da
        APPEND lt_importdata-is TO ls_yellow-is. "id ne, name ja
      ELSE.
        APPEND lt_importdata-is TO ls_green-is. "id ne, name ne
      ENDIF.
    ELSE. "id da
      IF ls_is EQ lt_importdata-is. "alles da
        APPEND lt_importdata-is TO ls_grey-is.

      ELSEIF ls_is-name EQ lt_importdata-is-name. "id ja, name ja
        APPEND lt_importdata-is TO ls_grey-is.
      ELSE.
        APPEND lt_importdata-is TO ls_red-is.
      ENDIF.
    ENDIF.




*MPA-Scanwerte
    LOOP AT lt_importdata-mpv ASSIGNING FIELD-SYMBOL(<fs_mpv>).
      APPEND <fs_mpv> TO ls_green-mpv.
    ENDLOOP.

    LOOP AT lt_importdata-mpp ASSIGNING FIELD-SYMBOL(<fs_mpp>).
* MPA-Parameter
      APPEND <fs_mpp> TO ls_green-mpp.
    ENDLOOP.


    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    ev_json_green = /ui2/cl_json=>serialize( data          = ls_green
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       compress      = abap_true
                                      ).

    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    ev_json_red = /ui2/cl_json=>serialize( data          = ls_red
                                        pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                        compress      = abap_true
                                       ).

    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    ev_json_yellow = /ui2/cl_json=>serialize( data          = ls_yellow
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       compress      = abap_true
                                      ).

    " serialize table lt_flight into JSON, skipping initial fields and converting ABAP field names into camelCase
    ev_json_grey = /ui2/cl_json=>serialize( data          = ls_grey
                                       pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                       compress      = abap_true
                                      ).

  ENDMETHOD.
ENDCLASS.
