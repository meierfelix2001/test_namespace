CLASS /fisxee/file_functions DEFINITION PUBLIC.

public section.
CLASS-METHODS split_filename
  IMPORTING
    i_filepath TYPE rsfilenm
  EXPORTING
    e_pathname TYPE rstxtlg
    e_filename TYPE rsawbnobjnm.
ENDCLASS.



CLASS /FISXEE/FILE_FUNCTIONS IMPLEMENTATION.


  METHOD split_filename.
  DATA: delimiter TYPE c,
        extension(3) TYPE c.

  IF contains( val = i_filepath sub = '\' ).
    delimiter = '\'.
  ELSE.
    IF contains( val = i_filepath sub = '/' ).
      delimiter = '/'.
    ELSE.
      CLEAR delimiter.
    ENDIF.
  ENDIF.

  IF delimiter IS INITIAL.
    CLEAR e_pathname.
*  FILENAME
    e_filename = i_filepath.
  ELSE.
*  PATH
    e_pathname = substring_before( val = i_filepath sub = delimiter occ = -1 ) && delimiter.

*  FILENAME
    e_filename = substring_after( val = i_filepath sub = delimiter occ = -1 ).
  ENDIF.

  ENDMETHOD.
ENDCLASS.
