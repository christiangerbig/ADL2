; ##############################
; # Programm: DetectADL.asm    #
; # Autor:    Christian Gerbig #
; # Datum:    28.06.2019       #
; # Version:  1.0              #
; # CPU:      68020+           #
; # FASTMEM:  -                #
; # Chipset:  AGA              #
; # OS:       3.0+             #
; ##############################

; Prüfen ober der ADL im Speicher aktiv ist

  SECTION code_and_variables,CODE

  MC68040

  ;INCDIR  "OMA:include/"
  INCDIR "Daten:include3.5/"

  INCLUDE "libraries/dos_lib.i"
  INCLUDE "dos/dos.i"
  INCLUDE "dos/dosextens.i"

  INCLUDE "exec/exec_lib.i"
  INCLUDE "exec/exec.i"

  INCLUDE "devices/serial.i"

  INCDIR "Daten:Asm-Sources.AGA/normsource-includes/"



TRUE        EQU 0
FALSE       EQU -1
FALSE_BYTE      EQU $ff
FALSE_WORD      EQU $ffff
FALSE_LONGWORD      EQU $ffffffff

BYTESHIFT   EQU 256
WORDSHIFT   EQU 65536

exec_base   EQU $0004

vectors_num EQU 3



  RSRESET

  RSRESET

DOS_return_code RS.L 1

variables_size  RS.B 0


; ## Makrobefehle ##
  INCLUDE "macros.i"


start
  movem.l d2-d7/a2-a6,-(a7)
  lea     variables(pc),a3   ;Basiszeiger auf alle Variablen
  bsr.s   init_variables
  bsr.s   open_dos_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end2               ;Ja -> verzweige
  bsr.s   get_capture_vectors
  tst.w   d0
  bne.s   end1
  bsr     print_vectors_overview
wait_rmb
  btst    #2,$dff016         ;Auf rechts Maustaste warten
  bne.s   wait_rmb
end1
  bsr     close_dos_lib
end2
  move.l  DOS_return_code(a3),d0 ;Fehlercode 
  movem.l (a7)+,d2-d7/a2-a6
  rts

; ** Variablen initialisieren **
  CNOP 0,4
init_variables
  moveq   #0,d0
  move.l  d0,DOS_return_code(a3)
  lea     _SysBase(pc),a0
  move.l  exec_base.w,(a0)
  rts

; ** DOS-Library öffnen **
  CNOP 0,4
open_dos_lib
  lea     dos_name(pc),a1    ;Name der DOS-Library
  moveq   #0,d0           ;Version egal
  CALLEXEC OpenLibrary       ;Graphics-Library öffnen
  lea     _DOSBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf DOS-Base retten
  beq.s   dos_lib_error      ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
dos_lib_error
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Capture-Vektoren auslesen **
  CNOP 0,4
get_capture_vectors
  lea     data_stream(pc),a0
  move.l  ColdCapture(a6),(a0)+
  move.l  CoolCapture(a6),a1
  cmp.w   #"DL",2(a1)
  beq.s   ADL_active
  lea     ADL_id(pc),a2
  move.l  #"    ",(a2)+      ;ADL-ID löschen
  move.w  #"  ",(a2)
ADL_active
  move.l  a1,(a0)+
  move.l  WarmCapture(a6),(a0)
  rts

; ** Übersicht in Shell-Fenster ausgeben **
  CNOP 0,4
print_vectors_overview
  lea     format_string(pc),a0 ;String mit Format-Zeichen
  lea     data_stream(pc),a1 ;Daten für den Format-String
  lea     put_ch_proc(pc),a2 ;Zeiger auf Kopierroutine
  move.l  a3,-(a7)
  lea     put_ch_data(pc),a3 ;Zeiger auf Ausgabestring
  CALLEXEC RawDoFmt          ;Text formatieren
  move.l  (a7)+,a3
  CALLDOS Output             ;Ausgabehandle 
  move.l  d0,d1              ;Handle -> d1
  beq.s   no_print_text      ;Wenn Fehler -> verzweige
  lea     put_ch_data(pc),a0 ;Zeiger auf Text
  move.l  a0,d2
  moveq   #TRUE,d3           ;Länge des Texts
search_nullbyte
  tst.b   (a0)+              ;Null byte gefunden ?
  beq.s   nullbyte_found     ;Ja- > verzweige
  addq.w  #1,d3              ;Zeichenzähler erhöhen
  bra.s   search_nullbyte    ;Schleife
nullbyte_found
  CALLLIBQ Write             ;Text ausgeben
  CNOP 0,4
no_print_text
  rts
  CNOP 0,4
put_ch_proc
  move.b  d0,(a3)+           ;Daten in den Ausgabestring schreiben
  rts

; ** DOS-Libary schließen **
  CNOP 0,4
close_dos_lib
  move.l  _DOSBase(pc),a1    ;Zeiger auf DOS-Base -> a1
  CALLEXECQ CloseLibrary


;

  CNOP 0,4
_SysBase DC.L 0
_DOSBase  DC.L 0
variables DS.B variables_size


dos_name           DC.B "dos.library",0



; ** Speicherstellen für die Routine RawDoFmt() **
format_string
  DC.B 10
  DC.B "ColdCapture...... %08lx",10
  DC.B "CoolCapture...... %08lx"
ADL_id
  DC.B " (ADL)",10
  DC.B "WarmCapture...... %08lx",10,10
  DC.B "Press right mousebutton to continue...",10,10
  DC.B TRUE
format_string_end
  EVEN

data_stream
  DS.L vectors_num
data_stream_end

put_ch_data
  DS.B (format_string_end-format_string-1)+((data_stream_end-data_stream)*2)


program_version DC.B "$VER: DumpRegs 1.0 (8.6.19)",0
  EVEN

  END
