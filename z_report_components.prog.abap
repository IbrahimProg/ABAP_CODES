*&---------------------------------------------------------------------*
*& Report Z_REPORT_COMPONENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_REPORT_COMPONENTS.
TABLES: kna1, sflight,sscrfields.
SELECTION-SCREEN BEGIN OF SCREEN 100.

SELECTION-SCREEN BEGIN OF BLOCK part1 WITH FRAME TITLE text-001.
PARAMETERS field(10) TYPE c OBLIGATORY.
SELECTION-SCREEN END OF BLOCK part1.

SELECTION-SCREEN BEGIN OF BLOCK part2 WITH FRAME TITLE text-002.
PARAMETERS: p1(10) TYPE c VISIBLE LENGTH 1,
            p2(10) TYPE c VISIBLE LENGTH 5,
            p3(10) TYPE c VISIBLE LENGTH 10.
SELECTION-SCREEN END OF BLOCK part2.

SELECTION-SCREEN BEGIN OF BLOCK part3 WITH FRAME TITLE text-003.
PARAMETERS: a AS CHECKBOX USER-COMMAND flag,
            b AS CHECKBOX DEFAULT 'X' USER-COMMAND flag.

SELECTION-SCREEN END OF BLOCK part3.

SELECTION-SCREEN BEGIN OF BLOCK part4 WITH FRAME TITLE text-004.
PARAMETERS: r1 RADIOBUTTON GROUP rad1,
            r2 RADIOBUTTON GROUP rad1 DEFAULT 'X',
            r3 RADIOBUTTON GROUP rad1,

            s1 RADIOBUTTON GROUP rad2 DEFAULT 'X',
            s2 RADIOBUTTON GROUP rad2,
            s3 RADIOBUTTON GROUP rad2 .
SELECTION-SCREEN END OF BLOCK part4.

SELECTION-SCREEN BEGIN OF BLOCK part5 WITH FRAME TITLE text-005.
PARAMETERS p_carrid TYPE spfli-carrid
                    AS LISTBOX VISIBLE LENGTH 20
                    DEFAULT 'LH'.
SELECTION-SCREEN END OF BLOCK part5.

SELECTION-SCREEN BEGIN OF LINE.
  PARAMETERS: c AS CHECKBOX USER-COMMAND flag.
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN BEGIN OF BLOCK part6 WITH FRAME TITLE text-006.
PARAMETERS: test1(10) TYPE c MODIF ID sc1,
            test2(10) TYPE c MODIF ID sc2,
            test3(10) TYPE c MODIF ID sc1,
            test4(10) TYPE c MODIF ID sc2.
SELECTION-SCREEN END OF BLOCK part6.
SELECT-OPTIONS: s_air   FOR sflight-carrid ,
                s_aicon FOR sflight-connid NO INTERVALS .
SELECTION-SCREEN END OF SCREEN 100.

AT SELECTION-SCREEN OUTPUT.
PERFORM set_output.


" Help search using standard function module
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_air-low.
  PERFORM get_aircode_help.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_air-high.
*  PERFORM get_aircon_help.
  PERFORM get_aircode_help.
CLASS start DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

CLASS start IMPLEMENTATION.
  METHOD main.
    CALL SELECTION-SCREEN 100 STARTING AT 10 10.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    WRITE: / 'P1:', p1,
           / 'P2:', p2,
           / 'P3:', p3.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  start=>main( ).
*&---------------------------------------------------------------------*
*& Form SET_OUTPUT
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM SET_OUTPUT .

    LOOP AT screen INTO DATA(screen_wa).
    IF c <> 'X' AND
       screen_wa-group1 = 'SC1'.
      screen_wa-active = '0'.
    ENDIF.

    IF screen_wa-group1 = 'SC1'.
      screen_wa-intensified = '1'.
      MODIFY screen FROM screen_wa.
      CONTINUE.
    ENDIF.
    IF screen_wa-group1 = 'SC2'.
      screen_wa-intensified = '0'.
      MODIFY screen FROM screen_wa.
    ENDIF.
    ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_AIRCODE_HELP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_AIRCODE_HELP  .
  DATA : lt_ret TYPE TABLE OF ddshretval,
         lv_retfield TYPE dfies-fieldname,
         lv_dynpro   TYPE help_info-dynprofld.
  SELECT carrid,connid FROM SFLIGHT CLIENT SPECIFIED
                       INTO TABLE @DATA(lv_val)
                      WHERE mandt =  @sy-mandt.


    " Assign value to field
    lv_retfield = 'carrid'.
    lv_dynpro = 's_air'.


    CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
      EXPORTING
*       DDIC_STRUCTURE         = ' '
        RETFIELD               = lv_retfield
*       PVALKEY                = ' '
       DYNPPROG               = sy-CPROG
       DYNPNR                 = sy-DYNNR
       DYNPROFIELD             = lv_dynpro
*       STEPL                  = 0
*       WINDOW_TITLE           =
*       VALUE                  = ' '
       VALUE_ORG              = 'S'
*       MULTIPLE_CHOICE        = ' '
*       DISPLAY                = ' '
*       CALLBACK_PROGRAM       = ' '
*       CALLBACK_FORM          = ' '
*       CALLBACK_METHOD        =
*       MARK_TAB               =
*     IMPORTING
*       USER_RESET             =
      TABLES
        VALUE_TAB              = lv_val
*       FIELD_TAB              =
       RETURN_TAB             = lt_ret
*       DYNPFLD_MAPPING        =
*     EXCEPTIONS
*       PARAMETER_ERROR        = 1
*       NO_VALUES_FOUND        = 2
*       OTHERS                 = 3
              .
*    IF SY-SUBRC <> 0.
** Implement suitable error handling here
*    ENDIF.







ENDFORM.
*&---------------------------------------------------------------------*
*& Form GET_AIRCON_HELP
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM GET_AIRCON_HELP .

ENDFORM.
