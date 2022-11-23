*&---------------------------------------------------------------------*
*& Report ZCONTROLL_FOR_BOLCK
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZCONTROLL_SCREEN_BLOCK.

DATA: test TYPE char15.

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME TITLE text-001.
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN POSITION 1.
  SELECTION-SCREEN COMMENT 20(10) text-002.
  PARAMETERS: r1 RADIOBUTTON GROUP rad1 DEFAULT 'X' USER-COMMAND ex. " user-command its important to toggle sceen directly without use F8
  SELECTION-SCREEN COMMENT 40(10) text-003.
  PARAMETERS: r2 RADIOBUTTON GROUP rad1 .
  SELECTION-SCREEN COMMENT 60(10) text-004.
  PARAMETERS: r3 RADIOBUTTON GROUP rad1 .
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK block1.




*************************************************************************
*  Second blcok
*  **********************************************************************
  SELECTION-SCREEN BEGIN OF BLOCK block2 WITH FRAME TITLE text-005.

    SELECT-OPTIONS: T1 FOR test MODIF ID g1,
                    T2 FOR test MODIF ID g1.
    SELECTION-SCREEN END OF BLOCK block2.

***********************************************************************
*  Third block
*  **********************************************************************
  SELECTION-SCREEN BEGIN OF BLOCK block3 WITH FRAME TITLE text-006.
    SELECTION-SCREEN COMMENT /1(50) label2.
    SELECTION-SCREEN END OF BLOCK block3.


***********************************************************************
*  Fourth blcok
*  **********************************************************************
  SELECTION-SCREEN BEGIN OF BLOCK block4 WITH FRAME TITLE text-007.
    SELECTION-SCREEN COMMENT 1(50) text-004 FOR FIELD fpar.
     PARAMETERS: fpar TYPE char50 MODIF ID sc3.
    SELECTION-SCREEN END OF BLOCK block4.
SELECTION-SCREEN SKIP 5.
**********************************************************************
** Initialization ****
**********************************************************************

INITIALIZATION.
label2 = 'This is second block displaying'.
**label3 = 'This is fourth blcok displaying'.


**********************************************************************
***** AT SELECTION SCREEN *********
**********************************************************************

AT SELECTION-SCREEN OUTPUT.
  PERFORM contorl_bolck.

*&---------------------------------------------------------------------*
*& Form CONTORL_BOLCK
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM CONTORL_BOLCK .
    IF  r1 EQ abap_true.
    LOOP AT SCREEN.
      IF screen-group1 = 'G1'.
       screen-active = 0.
       screen-INVISIBLE = 1.
      ENDIF.
      IF screen-name = '%B002005_BLOCK_1000'.
        screen-INVISIBLE = 1.
      ENDIF.
       MODIFY SCREEN.
        ENDLOOP.
        ENDIF.

        IF r2 EQ abap_true.
          LOOP AT SCREEN.
       IF screen-name = '%B002009_BLOCK_1000' OR screen-name = 'LABEL2'.
        screen-invisible = 1.
      ENDIF.
      MODIFY SCREEN.
       ENDLOOP.
      ENDIF.

      IF r3 EQ abap_true.
        LOOP AT SCREEN.
          IF screen-name = '%B002012_BLOCK_1000' OR screen-name = 'LABEL3' OR screen-name = 'FPAR' OR screen-group1 = 'SC3' OR screen-name = '%F004019_1000'.
             screen-active = 0.
            screen-invisible = 1.
            ENDIF.
            MODIFY SCREEN.
          ENDLOOP.
        ENDIF.
ENDFORM.
