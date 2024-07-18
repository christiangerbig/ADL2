  OPT L+

; ##############################
; # Programm: CLI-Header.asm   #
; # Autor:    Christian Gerbig #
; # Datum:    17.06.2018       #
; # Version:  1.0              #
; # CPU:      68020+           #
; # FASTMEM:  -                #
; # Chipset:  AGA              #
; # OS:       3.0+             #
; ##############################

; Header zum Laden von Tracker-Modulen f¸r die sp‰tere Weiterverwendung in
; einer Replay-Routine

  SECTION code_and_variables,CODE

  MC68020

  ;INCDIR  "OMA:include/"
  INCDIR "Daten:include3.5/"

  INCLUDE "libraries/dos_lib.i"
  INCLUDE "dos/dos.i"
  INCLUDE "dos/dosextens.i"

  INCLUDE "exec/exec_lib.i"
  INCLUDE "exec/exec.i"

  INCDIR "Daten:Asm-Sources.AGA/normsource-includes/"



TRUE           EQU 0
FALSE          EQU -1
FALSE_BYTE         EQU $ff
FALSE_WORD         EQU $ffff
FALSE_LONGWORD         EQU $ffffffff

BYTESHIFT      EQU 256
WORDSHIFT      EQU 65536

exec_base      EQU $0004

AFF_68060      EQU $80
AFB_68060      EQU 7



  RSRESET

  RSRESET

file_path_length RS.L 1
file_path        RS.L 1

file_lock        RS.L 1
fib_memory       RS.L 1

file_handle      RS.L 1
file_memory      RS.L 1
file_length      RS.L 1

DOS_return_code  RS.L 1

variables_size   RS.B 0


; ## Makrobefehle ##
  INCLUDE "macros.i"


start
  movem.l d2-d7/a2-a6,-(a7)
  lea     variables(pc),a3   ;Basiszeiger auf alle Variablen
  movem.l d0/a0,file_path_length(a3) ;Zeiger auf Dateiname und L‰nge retten
  bsr     init_variables
  bsr     open_dos_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end6               ;Ja -> verzweige
  bsr     check_cpu
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end5               ;Ja -> verzweige
  bsr     check_cmd_line
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end5               ;Ja -> verzweige
  bsr     lock_file
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end5               ;Ja -> verzweige
  bsr     alloc_fib_mem
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end4               ;Ja -> verzweige
  bsr     get_file_length
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end3               ;Ja -> verzweige
  bsr     alloc_file_mem
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end2               ;Ja -> verzweige
  bsr     open_file
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end2               ;Ja -> verzweige
  bsr     read_file
  move.l  file_memory(a3),a0 ;Zeiger auf Modul im Speicher
  bsr     replay_module
end1
  bsr     close_file
end2
  bsr     free_file_mem
end3
  bsr     free_fib_mem
end4
  bsr     unlock_file
end5
  bsr     close_dos_lib
end6
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

; ** DOS-Library ˆffnen **
  CNOP 0,4
open_dos_lib
  lea     dos_name(pc),a1    ;Name der DOS-Library
  moveq   #0,d0           ;Version egal
  CALLEXEC OpenLibrary       ;Graphics-Library ˆffnen
  lea     _DOSBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf DOS-Base retten
  beq.s   dos_lib_error      ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
dos_lib_error
  moveq   #FALSE,d0          ;Returncode = FALSE
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Testen, ob 68020+ vorhanden ist **
  CNOP 0,4
check_cpu
  move.l  _SysBase(pc),a0   ;Zeiger auf ExecBase 
  btst    #AFB_68020,ATTNFLAGS+1(a0) ;68020+ ?
  beq.s   no_cpu_020         ;Nein -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
no_cpu_020
  lea     error_text1(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text1_end-error_text1,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Befehlszeile ¸berpr¸fen **
  CNOP 0,4
check_cmd_line
  move.l  file_path_length(a3),d0 ;L‰nge des Pfades in Bytes
  cmp.w   #2,d0              ;Nur Return oder ein Zeichen + Return ?
  ble.s   usage              ;Ja -> verzweige
  move.l  file_path(a3),a0
check_file_path_loop
  cmp.b   #10,(a0)+          ;Line-Feed ?
  bne.s   check_file_path_loop ;Nein -> verzweige
  clr.b   -1(a0)             ;Nullbyte einf¸gen
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
usage
  lea     usage_text(pc),a0  ;Zeiger auf Text
  moveq   #usage_text_end-usage_text,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Datei-Lock ermitteln **
  CNOP 0,4
lock_file
  move.l  file_path(a3),d1   ;Zeiger auf Modulname
  moveq   #ACCESS_READ,d2    ;Lesen
  CALLDOS Lock               ;File-Lock 
  move.l  d0,file_lock(a3)   
  beq.s   file_lock_error    ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
file_lock_error
  lea     error_text2(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text2_end-error_text2,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Speicher f¸r File-Info-Block belegen **
  CNOP 0,4
alloc_fib_mem
  MOVEF.L fib_sizeOF,d0      ;Grˆﬂe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_PUBLIC,d1
  CALLEXEC AllocMem          ;Speicher reservieren
  move.l  d0,fib_memory(a3)  
  beq.s   fib_mem_error      ;wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
fib_mem_error
  lea     error_text3(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text3_end-error_text3,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Dateil‰nge ermitteln **
  CNOP 0,4
get_file_length
  movem.l file_lock(a3),d1-d2 ;File-Lock, Zeiger auf Info-Block
  CALLDOS Examine            ;Dateiinformation 
  tst.l   d0                 ;Wenn NULL -> verzweige
  beq.s   file_examine_error
  move.l  fib_memory(a3),a0  ;Zeiger auf Speicherbereich
  moveq   #TRUE,d0           ;Returncode = OK
  move.l  fib_size(a0),file_length(a3) ;L‰nge des Moduls in Bytes 
  rts
  CNOP 0,4
file_examine_error
  lea     error_text4(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text4_end-error_text4,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = False
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Speicher f¸r Datei belegen **
  CNOP 0,4
alloc_file_mem
  move.l  file_length(a3),d0 ;Grˆﬂe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_PUBLIC+MEMF_CHIP,d1
  CALLEXEC AllocMem          ;Speicher reservieren
  move.l  d0,file_memory(a3) 
  beq.s   file_mem_error     ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
file_mem_error
  lea     error_text5(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text5_end-error_text5,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = False
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Datei ˆffnen **
  CNOP 0,4
open_file
  move.l  file_path(a3),d1   ;Zeiger auf Modulname
  move.l  #MODE_OLDFILE,d2   ;Lesen
  CALLDOS Open               ;Datei ˆffnen
  move.l  d0,file_handle(a3) 
  beq.s   file_open_error    ;Wenn NULL -> Fehler
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
file_open_error
  lea     error_text6(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text6_end-error_text6,d0 ;Textl‰nge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = False
  moveq   #RETURN_ERROR,d1
  move.l  d1,DOS_return_code(a3)
  rts

; ** Datei auslesen **
  CNOP 0,4
read_file
  movem.l file_handle(a3),d1-d3 ;File-Handle, Speicherbereich, L‰nge des Moduls
  CALLLIBQ Read              ;Datei auslesen

; ** Datei wieder schlieﬂen **
  CNOP 0,4
close_file
  move.l  file_handle(a3),d1 ;File-Handle
  CALLDOSQ Close             ;Datei schlieﬂen

; ** File-Speicher freigeben **
  CNOP 0,4
free_file_mem
  move.l  file_memory(a3),a1 ;Zeiger auf Speicherbereich
  move.l  file_length(a3),d0 ;L‰nge
  CALLEXECQ FreeMem

; ** Datei wieder freigeben **
  CNOP 0,4
unlock_file
  movem.l file_lock(a3),d1/a0 ;File-Lock, Zeiger auf Info-File
  CALLDOSQ UnLock            ;File wieder freigeben

; ** FileInfoBlock-Speicher freigeben **
  CNOP 0,4
free_fib_mem
  move.l  fib_memory(a3),a1  ;Zeiger auf Speicherbereich
  move.l  #fib_sizeOF,d0     ;L‰nge
  CALLEXECQ FreeMem

; ** DOS-Libary schlieﬂen **
  CNOP 0,4
close_dos_lib
  move.l  _DOSBase(pc),a1    ;Zeiger auf DOS-Base -> a1
  CALLEXECQ CloseLibrary     ;DOS-Library schlieﬂen

; ** Text ausgeben **
; a0 ... Zeiger auf Fehlertext
; d0 ... L‰nge des Textes
  CNOP 0,4
print_msg
  movem.l d0/a0,-(a7)        ;Zeiger auf Text und L‰nge retten
  CALLDOS Output             ;Ausgabemedium ermitteln
  tst.l   d0
  beq.s   output_open_error  ;Wenn NULL -> verzweige
  move.l  (a7)+,d3           ;Anzahl der Zeichen zum Schreiben
  move.l  d0,d1              ;Zeiger auf Datei-Handle
  move.l  (a7)+,d2           ;Zeiger auf Fehlertext
  CALLLIBQ Write             ;Text schreiben
  CNOP 0,4
output_open_error
  addq.w  #8,a7              ;Stack korrigieren
  rts


;

  CNOP 0,4
_SysBase      DC.L 1
_DOSBase       DC.L 1
variables      DS.B variables_size


dos_name       DC.B "dos.library",0



; ** Fehlermeldungen **
error_text1
  DC.B "No 68020+ CPU !",10,10
error_text1_end
  EVEN
error_text2
  DC.B "Couldn't find file !",10,10
error_text2_end
  EVEN
error_text3
  DC.B "Couldn't allocate memory for FileInfoBlock !",10,10
error_text3_end
  EVEN
error_text4
  DC.B "Couldn't examine file !",10,10
error_text4_end
  EVEN
error_text5
  DC.B "Couldn't allocate memory for file !",10,10
error_text5_end
  EVEN
error_text6
  DC.B "Couldn't open file !",10,10
error_text6_end
  EVEN

; ** Befehlsschablone **
usage_text
  DC.B 7                     ;Beep ohne Ton
  DC.B 155,"33",109          ;Farbe = Orange
  DC.B "USAGE:"
  DC.B 155,"31",109          ;Farbe = Weiﬂ
  DC.B " ReplayMOD-NT1.0 "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "filename"
  DC.B 155,"0",109           ;Stil = Normal
  DC.B 10,10
usage_text_end
  EVEN

program_version DC.B "$VER: ReplayMOD-NT1.0 1.0 (17.6.18)",0
  EVEN

  CNOP 0,4
replay_module
  END
