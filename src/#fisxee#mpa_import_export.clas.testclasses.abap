
CLASS ltcl_import DEFINITION FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    CLASS-DATA:
      go_db_stub TYPE REF TO if_osql_test_environment.
    CLASS-METHODS:
      class_setup,
      class_teardown.
    METHODS:
      setup,
      teardown,
      inject_all,
      test_search_for_duplicates FOR TESTING RAISING cx_static_check,
      test_import FOR TESTING RAISING cx_static_check.

ENDCLASS.


CLASS ltcl_import IMPLEMENTATION.

  METHOD class_setup.
    go_db_stub = cl_osql_test_environment=>create( i_dependency_list = VALUE #( ( '/FISXEE/D_NG_MPA' ) ( '/FISXEE/D_NG_MDF' ) ( '/FISXEE/D_NG_MSC' ) ( '/FISXEE/D_NG_MSE' )  ( '/FISXEE/D_NG_MSR' )  ( '/FISXEE/D_NG_MST' )  ( '/FISXEE/D_NG_BP' )  (
'/FISXEE/D_NG_CHA' )  ( '/FISXEE/D_NG_TC' )  ( '/FISXEE/D_NG_TCC' )  ( '/FISXEE/D_NG_TCI' )  ( '/FISXEE/D_NG_TCP' )  ( '/FISXEE/D_NG_MPV' )  ( '/FISXEE/D_NG_MSV' )  ( '/FISXEE/D_NG_MPP' )  ( '/FISXEE/D_NG_IS' )  ( '/FISXEE/D_NG_PA' )  (
'/FISXEE/D_NG_FIL' )  ( '/FISXEE/D_NG_FC' ) ) ).
  ENDMETHOD.

  METHOD class_teardown.
    go_db_stub->destroy( ).
  ENDMETHOD.

  METHOD setup.
    go_db_stub->clear_doubles( ).

    go_db_stub->insert_test_data( VALUE /fisxee/t_ng_bp( ( mandt = sy-mandt id = '005056B6-3BD9-1ED9-ADEB-CB31B51C688D' location = 'I'  name = 'WHD1' subnum = 'XXX' default_send_channel_id = '005056B6-3BD9-1ED9-ADEB-9AE45792682D'
                                                          default_receive_channel_id = '' chgusr = 'FIS-MEIERF' last_changed = 20191010132443 delkz = 'N' ) ) ).
*    go_db_stub->insert_test_data( VALUE /fisxee/t_ng_apr( ( mandt = sy-mandt id = '1' id_api = '1' action = 'STRING' route = 'testRouteOLD'  http_methode = 'GET' chgusr = 'FIS-TEST_OLD' last_changed = 2  ) ) ).
*
*    go_db_stub->insert_test_data( VALUE /fisxee/d_ng_arp_t( ( mandt = sy-mandt id = '1'   act_key = 'TestOld' id_route = '1' value = ' '
*                                              chgusr = 'FIS-TEST' last_changed = 1 ) ) ).

    inject_all( ).


  ENDMETHOD.

  METHOD teardown.
    /fisxee/th_ng_injector=>reset( ).
  ENDMETHOD.

  METHOD inject_all.
    /fisxee/th_ng_injector=>inject_system_info( NEW /fisxee/th_ng_sys_info_stub( ) ).
  ENDMETHOD.

  METHOD test_search_for_duplicates.
    TRY.

        DATA lv_string TYPE string.

        lv_string = |<?xml version="1.0" encoding="utf-8"?><asx:abap version="1.0" xmlns:asx="http://www.sap.com/abapxml"><asx:values><TAB><MPA><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-FBBFCD3528DB</| &&
    |ID><BP_ID_SENDER>005056B6-3BD9-1ED9-ADEB-CB31B51C688D</BP_ID_SENDER><| && |BP_ID_RECEIVER>005056B6-3BD9-1ED9-ADEB-CCB2A7D8688F</BP_ID_RECEIVER><MESSAGE_DEFINITION_ID>005056B6-3BD9-1E| &&
    |D9-ADEB-C618BEB62887</MESSAGE_DEFINITION_ID><SUBNUM>XXX</SUBNUM><INTEGRATION_SCENARIO_ID>005056B6-3BD9-1ED9-ADEB-E18FE1E| && |1E8B5</INTEGRATION_SCENARIO_ID><ICN_KEY/><LAST_CHANGED>20200120115353</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHG| &&
    |USR><DELKZ>N</DELKZ><SNDPRN/><RCVPRN/><SEND_CHANNEL_ID>005056B6-3BD9-1ED9-ADEB-B2EAEB290860</SEND_CHANNEL_ID><RECEIVE_CHANNEL_ID>005056B6-3BD9-1ED9-ADEC-2C895A34692D</RECEIVE_CHANNEL_ID><STATE/><NAME>Wetterabfrage</NAME><P| &&
    |ROCESS_PARALLEL>X</PROCESS_PARALLEL><ACTIVATE_PROCESS_TRACE/><ENCODING/></MPA><MDF><_-FISXEE_-D_NG_MDF><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-C618BEB62887</ID><SUBNUM>XXX</SUBNUM><NAME>wetterabfrage</NAME><SCA| &&
    |N_ID>005056B6-3BD9-1ED9-ADEB-C618BEB60887</SCAN_ID><LAST_CHANGED>20190830072609</LAST_CHANGED><CHGUSR>MEIERFE</CHGUSR><ACTIVE/><DELKZ>N</DELKZ><BP_SPLIT_FILE_ID/><CAT_ID/></_-FISXEE_-D_NG_MDF></MDF><MSC/><MSE/><MSR/><MST/><MSX/><MVC| &&
    |/><BP><_-FISXEE_-D_NG_BP><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-CB31B51C688D</ID><LOCATION>I</LOCATION><NAME>WHD1</NAME><SUBNUM>XXX</SUBNUM><BUSINESS_PARTNER/>| &&
    |<DEFAULT_SEND_CHANNEL_ID>005056B6-3BD9-1ED9-ADEB-9AE45792682D</| &&
    |DEFAULT_SEND_CHANNEL_ID><LAST_CHANGED>20191010132443</LAST_CHANGED><DEFAULT_RECEIVE_CHANNEL_ID/><CHGUSR>FIS-MEIERF</CHGUSR><DELK| &&
    |Z>N</DELKZ><STATE/></_-FISXEE_-D_NG_BP><_-FISXEE_-D_NG_BP><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-CCB2A7D8688F</ID><LOCATION>I</LOCATION><NAME>WHD2</NAME| &&
    |><SUBNUM>XXX</SUBNUM><BUSINESS_PARTNER/><DEFAULT_SEND_CHANNEL_ID>005056B6-3BD9-1ED9-ADEB-9AE45792682D</DEFAULT_SEND_CHANNEL_ID><LAST_CHANGED>20190805085247</LAST_CHANGED><DEFAULT_RECEIVE_CHANNEL_ID>005056B6-3BD9-1ED9-ADEB-B2EAEB290860</DE| &&
    |FAULT_RECEIVE_CHANNEL_ID><CHGUSR>FIS-MEIERF</CHGUSR><DELKZ>N</DELKZ><STATE/></_-FISXEE_-D_NG_BP></BP><CHA><_-FISXEE_-D_NG_CHA><MANDT>400</MANDT><ID>005056| &&
    |B6-3BD9-1ED9-ADEB-B2EAEB290860</ID><SUBNUM>XXX</SUBNUM><NAME>WetterSenden</NAME><COMMUNICATION_TYPE>FileT</COMMUNICATION_TYPE><LAST_CHANGED>20200305105649</LAST_CHANGED><T| &&
    |IME_CONTROL>005056B6-3BD9-1EEA-97D9-FED0980FA6DA</TIME_CONTROL><DIRECTION>2</DIRECTION><CHGUSR>FIS-MEIERF</CHGUSR><DELKZ>N</DELKZ><CHANNEL_ROUTING>X</CHANNEL_ROUTING><MAP| &&
    |PING_ID/><ACTIVE>X</ACTIVE><INFILE_SAVE/></_-FISXEE_-D_NG_CHA><_-FISXEE_-D_NG_CHA><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEC-2C895A34692D</ID><SUBNUM>XXX</SUBNUM>| &&
    |<NAME>WetterEmpfangEMAIL</NAME><COMMUNICATION_TYPE>Email</COMMUNICATION_TYPE>| &&
    |<LAST_CHANGED>20200305125455</LAST_CHANGED><TIME_CONTROL>005056B6-3BD9-1EEA-97DC-0E8387070AB6</TIME_CONTROL><DIRECTION>1</DIRECTION><CHGUSR>FIS-MEIERF</CHGUSR><DELKZ>N</DELKZ><CHANN| &&
    |EL_ROUTING/><MAPPING_ID/><ACTIVE>X</ACTIVE><INFILE_SAVE/></_-FISXEE_-D_NG_CHA><_-FISXEE_-D_NG_CHA><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-9AE45792682D</ID><SUBNUM>XXX| &&
    |</SUBNUM><NAME>WetterEmpang</NAME><COMMUNICATION_TYPE>FileT</COMMUNICATION_TYPE><LAST_CHANGED>20200305125529</LAST_CHANG| && |ED><TIME_CONTROL>005056B6-3BD9-1EEA-97DC-11BDFDA7CAB8</TIME_CONTROL><DIRECTION>1</DIRECTION><CHGUSR>FIS-MEIERF</CHGUSR| &&
    |><DELKZ>N</DELKZ><CHANNEL_ROUTING/><MAPPING_ID/><ACTIVE>X</ACTIVE><INFILE_SAVE/></_-FISXEE_-D_NG_CHA></CHA><TC><_| &&
    |-FISXEE_-D_NG_TC><MANDT>400</MANDT><ID>005056B6-3BD9-1EEA-97DC-0E8387070AB6</ID><NAME>test2</NAME><ACTIVE_FLAG/><SUBNUM>XXX</SUBNUM><LAST_CHANGED>20220124073351</LAST_CHANGED| &&
    |><CHGUSR>FIS-MEIERF</CHGUSR></_-FISXEE_-D_NG_TC><_-FISXEE_-D_NG_TC><MANDT>400</MANDT><ID>005056B6-3BD9-1EEA-97D9-FED0980FA6DA</ID><NAME>test| &&
    |</NAME><ACTIVE_FLAG>X</ACTIVE_FLAG><SUBNUM>XXX</SUBNUM><LAST_CHANGED>20200305105627</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR></_-FISXEE_-D_NG_TC><_-FISXEE_-D_NG_TC><MANDT>400</MANDT><ID>005056B6-3BD9-| &&
    |1EEA-97DC-11BDFDA7CAB8</ID><NAME>lbjhbhl</NAME><ACTIVE_FLAG/><SUBNUM>XXX</SUBNUM><LAST_CHANGED>20200305125513</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR| &&
    |></_-FISXEE_-D_NG_TC></TC><TCC/><TCI/><TCP/><MPV><_-FISXEE_-D_NG_MPV><MANDT>400</MANDT><ID>005056B6-3BD9-1EDB-ABE2-5E5B4A8BD804</ID><MESSAGE_PARTY| &&
    |_ID>005056B6-3BD9-1ED9-ADEB-FBBFCD3528DB</MESSAGE_PARTY_ID><MESSAGE_SCAN_ID>005056B6-3BD9-1ED9-ADEB-C618BEB70887</MESSAGE_SCAN_ID><VALUE>huhu</VALUE><LAST_CHANGED>202105070| &&
    |90229</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR></_-FISXEE_-D_NG_MPV></MPV><MSV><_-FISXEE_-D_NG_MSV><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-C618BEB70887</ID><ME| &&
    |SSAGE_DEFINITION_ID>005056B6-3BD9-1ED9-ADEB-C618BEB62887</MESSAGE_DEFINITION_ID><NAME>Empfänger</NAME><LAST_CHANGED>20190805085119</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR></_-FISXEE_-D_NG_MSV></M| &&
    |SV><MPP/><IS><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEB-E18FE1E1E8B5</ID><NAME>Abfrage Wetter an einem Standort</NAME><SUBNUM>XXX</SUBNUM><LAST_CHANGED>20190805095117</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR><DELKZ>N</| &&
    |DELKZ><PROCESSDEF_FILE_ID>005056B6-3BD9-1ED9-ADEC-CE406384EA5C</PROCESSDEF_FILE_ID></IS><PA><_-FISXEE_-D_NG_PA><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEC-D2418EEFAA5F</ID><INTEGRATION_SCENARIO_ID>005056B6-| &&
    |3BD9-1ED9-ADEB-E18FE1E1E8B5</INTEGRATION_SCENARIO_ID><ARGUMENT_KEY>resultmapping</ARGUMENT_KEY><ARGUMENT_VALUE>005| &&
    |056B6-3BD9-1ED9-ADEC-D033C528EA5E</ARGUMENT_VALUE><LAST_CHANGED>20190805095124</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR><ARGUMENT_TYPE>Mapping</A| &&
    |RGUMENT_TYPE></_-FISXEE_-D_NG_PA></PA><FIL><_-FISXEE_-D_NG_FIL><MANDT/><ID>005056B6-3BD9-1ED9-ADEC-D033C528EA5E</ID><SUBNUM>XXX</SUBNUM><FILE_NAME>wetter.max</FILE_NAME><FIL| &&
    |E_CATEGORY>MAPPING</FILE_CATEGORY><LAST_CHANGED>20190807080745</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR><MIME_TYPE>application/max</MIME_TYPE></_-FISXEE_-| &&
    |D_NG_FIL><_-FISXEE_-D_NG_FIL><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEC-CE406384EA5C</ID><SUBNUM>XXX</SUBNUM><FILE_NAME>G| &&
    |etWeatherFromCities mt mapping.bpmn</FILE_NAME><FILE_CATEGORY>PROCESSDEF</FILE_CATEGORY><LAST_CHANGED>20190805095352</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR><MIME_TYPE/></_-FISXEE_-D_NG_FIL></FIL><FC><_-FI| &&
    |SXEE_-D_NG_FC><MANDT>400</MANDT><ID>005056B6-3BD9-1ED9-ADEC-DDCB34546A7E</ID><CONTENT></CONTENT><CONTENT_LENGTH>16665</CONTENT_LENGTH>| &&
    |<HASH>HDBCSqdFKhpZxx5dDPX7Yg81uvo=</HASH><VERSIONNUMBER>2</VERSIONNUMBER><LAST_CHANGED>20190805095352</LAST_CHANGED><CHGUSR>FIS-MEIERF</CHGUSR><FILE_ID>005056B6-3BD9-1ED9-ADEC-CE406384EA5C</FILE_ID><IS_ACTIVE>X</IS_ACTIVE></_-FISXEE_-D_NG_FC><_-| &&
    |FISXEE_-D_NG_FC><MANDT>400</MANDT><ID>005056B6-3BD9-1EE9-AE9D-4DFB2344A3E7</ID><CONTENT></CONTENT><CONTENT_LENGTH>28399</CONTENT_L| &&
    |ENGTH><HASH>M2Fw/IRY3+jE8SkxCXUQO8FY72A=</HASH><VERSIONNUMBER>7</VERSIONNUMBER><LAST_CHANGED>20190807080745</LAST_CHANGED><CHGUSR>FIS-| &&
    |MEIERF</CHGUSR><FILE_ID>005056B6-3BD9-1ED9-ADEC-D033C528EA5E</FILE_ID><IS_ACTIVE>X</IS_ACTIVE></_-FISXEE_-D_NG_FC></FC></TAB></asx:values></asx:abap>|.


        DATA ls_iem TYPE /fisxee/d_ng_iem.

        /fisxee/mpa_import_export=>search_duplicates_for_import2(
  EXPORTING
           iv_mpa_xml          = lv_string
            iv_subnum           = 'XXX'
  IMPORTING
    ev_json_green  = ls_iem-green
    ev_json_grey   = ls_iem-grey
    ev_json_yellow = ls_iem-yellow
    ev_json_red    = ls_iem-red
    ev_mpa_new     = ls_iem-is_new
    ev_bp_id       = ls_iem-bp_id
    ev_bp_id2      = ls_iem-bp_id2
    ev_bp_new      = ls_iem-bp_new
    ev_bp_new2     = ls_iem-bp_new2
).


        cl_abap_unit_assert=>assert_equals( exp = '{}'
                                            act = ls_iem-yellow ).

        cl_abap_unit_assert=>assert_equals( exp = '{}'
                                            act = ls_iem-red ).

        cl_abap_unit_assert=>assert_equals( exp = '{"bp":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-CB31B51C688D","location":"I","name":"WHD1","subnum":"XXX","lastChanged":20191010132443,"chgusr":"FIS-MEIERF","delkz":"N"}]}'
                                            act = ls_iem-grey ).

        DATA lv_text TYPE string.
        lv_text = '{"mpa":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-FBBFCD3528DB","bpIdSender":"005056B6-3BD9-1ED9-ADEB-CB31B51C688D","bpIdReceiver":"005056B6-3BD9-1ED9-ADEB-CCB2A7D8688F","messageDefinitionId":"005056B6-3B' &&
        'D9-1ED9-ADEB-C618BEB62887","subnum":"XXX","integrationScenarioId":"005056B6-3BD9-1ED9-ADEB-E18FE1E1E8B5","lastChanged":20200120115353,"chgusr":"FIS-MEIERF","delkz":"N","sendChannelId":"005056B6-3BD9-1ED9-ADEB-B2EAEB290860"' &&
        ',"receiveChannelId":"005056B6-3BD9-1ED9-ADEC-2C895A34692D","name":"Wetterabfrage","processParallel":"X"}],"is":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-E18FE1E1E8B5","name":"Abfrage Wetter an einem Standort","subnum":' &&
        '"XXX","lastChanged":20190805095117,"chgusr":"FIS-MEIERF","delkz":"N"}],"mdf":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-C618BEB62887","subnum":"XXX","name":"wetterabfrage","scanId":"005056B6-3BD9-1ED9-ADEB-C618BEB60887"' &&
        ',"lastChanged":20190830072609,"chgusr":"MEIERFE","delkz":"N"}],' &&
        '"bp":[{"mandt":"400","id":"005056B6-3BD9-' &&
        '1ED9-ADEB-CCB2A7D8688F","location":"I","name":"WHD2","subnum":"XXX","lastChanged":20190805085247,"chgusr":"FIS-MEIERF","delkz":"N"}],"msv":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-C618BEB70887","messageDefinitionId":"' &&
        '005056B6-3BD9-1ED9-ADEB-C618BEB62887","name":"Empfänger","lastChanged":20190805085119,"chgusr":"FIS-MEIERF"}],"mpv":[{"mandt":"400","id":"005056B6-3BD9-1EDB-ABE2-5E5B4A8BD804","messagePartyId":"005056B6-3BD9-1ED9-ADEB-FBBF' &&
        'CD3528DB","messageScanId":"005056B6-3BD9-1ED9-ADEB-C618BEB70887","value":"huhu","lastChanged":20210507090229,"chgusr":"FIS-MEIERF"}]}'.

        cl_abap_unit_assert=>assert_equals( exp = lv_text
                                            act = ls_iem-green ).

      CATCH /fisxee/cx_ng_model INTO DATA(lx_model).
        /fisxee/th_ng_unit_assert=>assert_empty_input( lx_model ).
    ENDTRY.
  ENDMETHOD.

  METHOD test_import.
    TRY.
        DATA lv_text_green TYPE string.
        lv_text_green = '{"mpa":[{"mandt":"400","id":"2","bpIdSender":"005056B6-3BD9-1ED9-ADEB-CB31B51C688D","bpIdReceiver":"005056B6-3BD9-1ED9-ADEB-CCB2A7D8688F","messageDefinitionId":"005056B6-3B' &&
        'D9-1ED9-ADEB-C618BEB62887","subnum":"XXX","integrationScenarioId":"005056B6-3BD9-1ED9-ADEB-E18FE1E1E8B5","lastChanged":20200120115353,"chgusr":"FIS-MEIERF","delkz":"N","sendChannelId":"005056B6-3BD9-1ED9-ADEB-B2EAEB290860"' &&
        ',"receiveChannelId":"005056B6-3BD9-1ED9-ADEC-2C895A34692D","name":"TEST Import","processParallel":"X"}],"is":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-E18FE1E1E8B5","name":"Abfrage Wetter an einem Standort","subnum":' &&
        '"XXX","lastChanged":20190805095117,"chgusr":"FIS-MEIERF","delkz":"N"}],"mdf":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-C618BEB62887","subnum":"XXX","name":"wetterabfrage","scanId":"005056B6-3BD9-1ED9-ADEB-C618BEB60887"' &&
        ',"lastChanged":20190830072609,"chgusr":"MEIERFE","delkz":"N"}],' &&
        '"bp":[{"mandt":"400","id":"005056B6-3BD9-' &&
        '1ED9-ADEB-CCB2A7D8688F","location":"I","name":"WHD2","subnum":"XXX","lastChanged":20190805085247,"chgusr":"FIS-MEIERF","delkz":"N"}],"msv":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-C618BEB70887","messageDefinitionId":"' &&
        '005056B6-3BD9-1ED9-ADEB-C618BEB62887","name":"Empfänger","lastChanged":20190805085119,"chgusr":"FIS-MEIERF"}],"mpv":[{"mandt":"400","id":"005056B6-3BD9-1EDB-ABE2-5E5B4A8BD804","messagePartyId":"005056B6-3BD9-1ED9-ADEB-FBBF' &&
        'CD3528DB","messageScanId":"005056B6-3BD9-1ED9-ADEB-C618BEB70887","value":"huhu","lastChanged":20210507090229,"chgusr":"FIS-MEIERF"}]}'.

        DATA lv_text_grey TYPE string.
        lv_text_grey = '{"bp":[{"mandt":"400","id":"005056B6-3BD9-1ED9-ADEB-CB31B51C688D","location":"I","name":"WHD1","subnum":"XXX","lastChanged":20191010132443,"chgusr":"FIS-MEIERF","delkz":"N"}]}'.


        /fisxee/mpa_import_export=>import_mpa(
  EXPORTING
    iv_subnum      = 'XXX'
    iv_json_green  = lv_text_green
    iv_json_grey   = lv_text_grey
    iv_json_yellow =  '{}'
    iv_json_red    = '{}'
).

      CATCH /fisxee/cx_ng_model INTO DATA(lx_model).
        /fisxee/th_ng_unit_assert=>assert_id_not_found_in_db( ix_model  = lx_model
                                                       iv_tabnam = '/FISXEE/D_NG_MPA'
                                                       iv_id     = '2' ).
    ENDTRY.
  ENDMETHOD.



ENDCLASS.
