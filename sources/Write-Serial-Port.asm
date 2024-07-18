; #####################################
; # Programm: Write-Serial-Port.asm   #
; # Autor:    Christian Gerbig        #
; # Datum:    26.09.2018              #
; # Version:  1.2                     #
; # CPU:      68020+                  #
; # FASTMEM:  -                       #
; # Chipset:  AGA                     #
; # OS:       3.0+                    #
; #####################################

; Einfaches Beispiel über das serial.device einen Textstring auszugeben
; Jetzt mit ausgeschaltetem XON/XOFF Protokoll

  SECTION code_and_variables,CODE

  MC68020

  ;INCDIR  "OMA:include/"
  INCDIR "Daten:include3.5/"

  INCLUDE "libraries/dos_lib.i"
  INCLUDE "dos/dos.i"
  INCLUDE "dos/dosextens.i"

  INCLUDE "exec/exec_lib.i"
  INCLUDE "exec/exec.i"

  INCLUDE "devices/serial.i"

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

RDArgs_structure    RS.L 1

serial_msg_port RS.L 1

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
  bne.s   end4               ;Ja -> verzweige
  bsr.s   check_cmd_line
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end2               ;Ja -> verzweige
  bsr     create_serial_msg_port
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end2               ;Ja -> verzweige
  bsr     init_serial_request_structure
  bsr     open_serial_device
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end1               ;Ja -> verzweige
  bsr     write_string
  bsr     close_serial_device
end1
  bsr     delete_serial_msg_port
end2
  bsr     free_RDArgs_structure
end3
  bsr     close_dos_lib
end4
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
  lea     results_array(pc),a0
  move.l  d0,(a0)+
  move.l  d0,(a0)
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

; ** Befehlszeile überprüfen **
  CNOP 0,4
check_cmd_line
  lea     cmd_template(pc),a0
  move.l  a0,d1              ;Zeiger auf Befelsschablone
  lea     results_array(pc),a2
  move.l  a2,d2              ;Zeiger auf Ergebnis-Felder
  moveq   #TRUE,d3           ;Keine eigene RDArgs-Struktur
  CALLDOS ReadArgs
  move.l  d0,RDArgs_structure(a3) ;Zeiger auf RDArgs-Struktur retten
  beq     check_cmd_line_error ;Wenn NULL -> verzweige
  move.l  4(a2),a0           ;Zeiger auf Langwort-Dezimalwert Sekunden
  move.l  a0,d0              ;Zeiger = NULL ?
  beq.s   no_argument_SECS   ;Ja -> verzweige
  move.l  (a0),d0            ;Sekundenwert
  cmp.l   #6553,d0           ;> 6553 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
no_argument_SECS
  move.l  (a2),a0            ;Zeiger auf Langwort-Dezimalwert Minuten
  move.l  a0,d1              ;Zeiger = NULL ?
  beq.s   no_argument_MINS   ;Ja -> verzweige
  move.l  (a0),d1            ;Minutenwert
  beq.s   skip_secs_check    ;Wenn NULL -> verzweige
  cmp.l   #60,d0             ;Bei angegebenem Minutenwert Sekundenwert > 60 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
skip_secs_check
  MULUF.W 60,d1,d2           ;*60 = Sekundenwert
no_argument_MINS
  add.l   d0,d1              ;+ Sekundenwert = Gesamtwert Sekunden
  MULUF.L 10,d1,d0           ;*10 = Zählerwert (in 100 ms)
  beq     check_cmd_line_error ;Wenn = NULL -> verzweige
  cmp.l   #65535,d1          ;Zählert > 65535 ?
  bgt     check_cmd_line_error ;Ja -> verzweige

; ** Dezimalzahl in ASCII-Zeichen umwandeln **
dec_to_ascii
  lea     number_string(pc),a0 ;Stringadresse
  moveq   #5,d7              ;Stringlänge = Anzahl der Stellen
  ;ext.l   d1                 ;Auf 32 Bit erweitern (Wichtig!)
  move.l  a0,a1              ;Stringadresse kopieren
  add.l   d7,a1              ;Stringende ermitteln
  subq.b  #1,d7              ;Länge = Länge - 1
  lea     dec_tab(pc),a2     ;Stellentabelle
  move.l  d7,d2              ;Länge -> d2
  addq.b  #1,d2              ;Länge + 1
  add.w   d2,d2              ;*4
  add.w   d2,d2
  add.l   d2,a2              ;Erste Zehnerpotenz ermitteln
ds_dec_to_ascii_loop
  moveq   #FALSE,d3          ;Ziffer = -1
  move.l  -(a2),d2           ;Zehnerpotenz nach d2
ds_dec_sub_loop
  addq.b  #1,d3              ;Ziffer erhöhen
  sub.l   d2,d1              ;Zehnerpotenz abziehen
  bcc.s   ds_dec_sub_loop    ;Wenn kein Übertrag, dann verzweige
  add.b   #"0",d3            ;Ziffer -> ASCII-Zeichen
  add.l   d2,d1              ;Rest berichtigen
  move.b  d3,(a0)+           ;Zeichen in String schreiben
  dbf     d7,ds_dec_to_ascii_loop

; ** Checksumme aus den ersten 7 ASCII-Zeichen bilden **
get_ascii_checksum
  lea     serial_output_string(pc),a0 ;Zeiger auf String
  moveq   #0,d0           ;Summenzähler
  moveq   #7-1,d7            ;Anzahl der ASCII-Zeichen zum Addieren
get_ascii_checksum_loop
  move.b  (a0)+,d1           ;ASCII-Wert
  add.w   d1,d0              ;ASCII-Wert dazuaddieren
  dbf     d7,get_ascii_checksum_loop

; ** Dezimalzahl in Hexadezimalzahl umwandeln **
dec_to_hex
  moveq   #TRUE,d1           ;Ergebnis = Hexadezialzahl
  moveq   #16,d3             ;Hexadezimalzahl-Basis
  moveq   #TRUE,d4           ;1. Nibble-Shiftwert
dec_to_hex_loop
  divu.w  d3,d0              ;/16
  move.l  d0,d2              ;Ergebnis retten
  swap    d2                 ;Rest 
  lsl.w   d4,d2              ;Nibble in richtige Position bringen
  addq.b  #4,d4              ;nächstes Nibble
  add.w   d2,d1              ;Nibble eintragen
  ext.l   d0                 ;Quotient auf 32 Bit erweitern
  bne.s   dec_to_hex_loop    ;Wenn Quotient <> NULL -> verzweige
  and.w   #$00ff,d1          ;Nur Bits 0-7

; ** Hexadezimalzahl in ASCII-Zeichen umwandeln **
hex_2_ascii
  lea     checksum_string_end(pc),a0 ;Zeiger auf Ende des Strings
  moveq   #2-1,d7            ;Anzahl der Stellen zum Umwandeln
hex_2_ascii_loop
  moveq   #$f,d0             ;Nibble-Maske
  and.w   d1,d0              ;Nur Low-Nibble
  add.b   #"0",d0            ;Ziffer -> ASCII-Zeichen
  cmp.b   #"9",d0            ;Zeichen <= "9" ?
  ble.s   hex_2_ascii_ok     ;Ja -< verzweige
  add.b   #39,d0             ;10="a",11="b",...
hex_2_ascii_ok
  lsr.l   #4,d1              ;nächstes Nibble
  move.b  d0,-(a0)           ;Zeichen in String schreiben
  dbf     d7,hex_2_ascii_loop

  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
check_cmd_line_error
  lea     cmd_usage_text(pc),a0 ;Zeiger auf Text
  move.l  #cmd_usage_text_end-cmd_usage_text,d0 ;Textlänge
  bsr     print_msg          ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Serial-Message-Port initialisieren **
  CNOP 0,4
create_serial_msg_port
  CALLEXEC CreateMsgPort     ;Message-Port für serial.device initialisieren
  move.l  d0,serial_msg_port(a3) ;Zeiger auf MsgPort-Struktur retten
  beq.s   create_message_port_error ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
create_message_port_error
  lea     error_text1(pc),a0 ;Zeiger auf Text
  moveq   #error_text1_end-error_text1,d0 ;Textlänge
  bsr     print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Serial-Request-Struktur initialisieren **
  CNOP 0,4
init_serial_request_structure
  lea     serial_request_structure(pc),a0 ;Zeiger auf Serial-Request-Struktur
  move.l  serial_msg_port(a3),MN_ReplyPort(a0) ;Reply-Port eintragen
  moveq   #0,d0
  move.b  d0,LN_Type(a0)     ;Eintragstyp = Null
  move.b  d0,LN_Pri(a0)      ;Priorität der Struktur = Null
  move.l  d0,LN_Name(a0)     ;Keine Name der Struktur
  rts

; ** Serial-Device öffnen **
  CNOP 0,4
open_serial_device
  lea     serial_device_name(pc),a0 ;Zeiger auf Name des Serial-Device
  lea     serial_request_structure(pc),a1 ;Zeiger auf Serial-Request-Struktur
  moveq   #0,d0           ;Unit 0
  moveq   #TRUE,d1           ;Keine Flags
  CALLLIBS OpenDevice        ;Serial-Device öffnen
  tst.l   d0
  bne.s   open_serial_device_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
open_serial_device_error
  lea     error_text2(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text2_end-error_text2,d0 ;Textlänge
  bsr     print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** String auf seriellem Port ausgeben **
  CNOP 0,4
write_string
  lea     serial_request_structure(pc),a1 ;Zeiger auf Serial-Request-Struktur
  move.w  #SDCMD_SETPARAMS,IO_COMMAND(a1) ;Parameter für Serial-Device setzen
  move.l  a1,a2              ;Zeiger auf Serial-Request-Struktur retten
  move.l  #2400,IO_BAUD(a1)  ;Baudrate 2400 bps
  move.b  #8,IO_WRITELEN(a1) ;8 Bits pro Zeichen beim Schreiben
  move.b  #1,IO_STOPBITS(a1) ;1 Stopbit
  move.b  #SERF_XDISABLED,IO_SERFLAGS(a1) ;Parität aus, kein XON/XOFF Protokoll
  CALLLIBS DoIO
  move.b  IO_ERROR(a2),d0    ;Fehler ?
  beq.s   set_params_ok      ;Nein -> verzweige
  cmp.b   #SerErr_DevBusy,d0 ;Device bereits in Benutzung ?
  beq.s   set_params_device_error1 ;Ja -> verzweige
  cmp.b   #SerErr_BaudMismatch,d0 ;Baudrate nicht von der Hardware unterstützt ?
  beq.s   set_params_device_error2 ;Ja -> verzweige
  cmp.b   #SerErr_InvParam,d0 ;Falsche Parameter ?
  beq.s   set_params_device_error3 ;Ja -> verzweige
  cmp.b   #SerErr_LineErr,d0 ;Überlauf der Daten ?
  beq.s   set_params_device_error4 ;Ja -> verzweige
  cmp.b   #SerErr_NoDSR,d0   ;Data-Set nicht bereit ?
  beq.s   set_params_device_error5 ;Ja -> verzweige
set_params_ok
  move.l  a2,a1              ;Zeiger auf Serial-Request-Struktur 
  move.w  #CMD_WRITE,IO_COMMAND(a1) ;Schreibbefehl für Serial-Device
;  moveq   #FALSE,d0          ;-1 da String mit NULL-Endung
  moveq   #serial_output_string_end-serial_output_string,d0 ;Anzahl der Bytes zum Schreiben
  move.l  d0,IO_LENGTH(a1)   ;Länge für Lesen eintragen
  lea     serial_output_string(pc),a0
  move.l  a0,IO_DATA(a1)     ;Zeiger auf String zum Schreiben
  CALLLIBS DoIO
  tst.l   d0                 ;Fehler ?
  bne.s   write_string_error ;Ja -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
set_params_device_error1
  lea     error_text3(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text3_end-error_text3,d0 ;Textlänge
  bsr     print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts
  CNOP 0,4
set_params_device_error2
  lea     error_text4(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text4_end-error_text4,d0 ;Textlänge
  bsr     print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
set_params_device_error3
  lea     error_text5(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text5_end-error_text5,d0 ;Textlänge
  bsr.s   print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
set_params_device_error4
  lea     error_text6(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text6_end-error_text6,d0 ;Textlänge
  bsr.s   print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
set_params_device_error5
  lea     error_text7(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text7_end-error_text7,d0 ;Textlänge
  bsr.s   print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
write_string_error
  lea     error_text8(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text8_end-error_text8,d0 ;Textlänge
  bsr.s   print_msg          ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts            

; ** Serial-Device schließen **
  CNOP 0,4
close_serial_device
  lea     serial_request_structure(pc),a1 ;Zeiger auf Serial-Request-Struktur
  CALLEXECQ CloseDevice

; ** Serial-Message-Port löschen **
  CNOP 0,4
delete_serial_msg_port
  move.l  serial_msg_port(a3),a0
  CALLEXECQ DeleteMsgPort

; ** Speicher für RDArgs-Struktur wieder freigeben **
  CNOP 0,4
free_RDArgs_structure
  move.l  RDArgs_structure(a3),d1 ;Zeiger auf RDArgs-Struktur
  beq.s   no_free_RDArgs_structure ;Wenn NULL -> verzweige
  CALLDOSQ FreeArgs          ;Speicher freigeben
  CNOP 0,4
no_free_RDArgs_structure
  rts

; ** DOS-Libary schließen **
  CNOP 0,4
close_dos_lib
  move.l  _DOSBase(pc),a1    ;Zeiger auf DOS-Base -> a1
  CALLEXECQ CloseLibrary

; ** Text ausgeben **
; a0 ... Zeiger auf Fehlertext
; d0 ... Länge des Textes
  CNOP 0,4
print_msg
  movem.l d0/a0,-(a7)        ;Zeiger auf Text und Länge retten
  CALLDOS Output             ;Ausgabemedium ermitteln
  tst.l   d0
  beq.s   output_open_error  ;Wenn NULL -> verzweige
  move.l  (a7)+,d3           ;Anzahl der Zeichen zum Schreiben
  move.l  d0,d1              ;Zeiger auf Datei-Handle
  move.l  (a7)+,d2           ;Zeiger auf Fehlertext
  CALLLIBQ Write             ;Text schreiben
  CNOP 0,4
output_open_error
  CALLLIBS IoErr
  move.l  d0,DOS_return_code(a3) ;Fehlercode retten
  addq.w  #8,a7              ;Stack korrigieren
  rts


;
; ** Ergebniswerte von ReadArgs() **
  CNOP 0,4
results_array
  DC.L 0                     ;Ergebniswert Argument Minuten
  DC.L 0                     ;Ergebniswert Argument Sekunden

; ** Stellentabelle für Dezimalzahlumwandlung **
dec_tab
  DC.L 1,10,100,1000,10000

; ** IO-Request-Struktur für Serial-Device **
serial_request_structure
  DS.B IOEXTSER_size


  CNOP 0,4
_SysBase DC.L 0
_DOSBase  DC.L 0
variables DS.B variables_size


dos_name           DC.B "dos.library",0
serial_device_name DC.B "serial.device",0



; ** Befehlsschablone für ReadArgs() **
cmd_template
  DC.B "MIN=MINS/K/N,SEC=SECS/K/N",0
  EVEN

; ** Ausgabe Befehlsbenutzung **
cmd_usage_text
  DC.B 7                     ;Beep ohne Ton
  DC.B 10                    ;Line-Feed
  DC.B 155,"33",109          ;Farbe = Orange
  DC.B "USAGE: "
  DC.B 155,"31",109          ;Farbe = Weiß
  DC.B "WriteSerialPort "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "[min(s) n] [sec(s) n]"
  DC.B 155,"0",109           ;Stil = Normal
  DC.B 10,10                 ;2x Line-Feed
  DC.B "Minimum playtime is "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "MIN 1 SECS 0 "
  DC.B 155,"0",109           ;Stil = Normal
  DC.B "or "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "MIN 1 "
  DC.B 155,"0",109           ;Stil = Normal
  DC.B "or "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "MINS 0 SEC 1 "
  DC.B 155,"0",109           ;Stil = Normal
  DC.B "or "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "SEC 1"
  DC.B 155,"0",109           ;Stil = Normal
  DC.B 10
  DC.B "Maximum playtime is "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "MINS 109 SECS 13 "
  DC.B 155,"0",109           ;Stil = Normal
  DC.B "or "
  DC.B 155,"3",109           ;Stil = Kursiv
  DC.B "SECS 6553"
  DC.B 155,"0",109           ;Stil = Normal
  DC.B 10,10                 ;2x Line-Feed
cmd_usage_text_end
  EVEN

; ** String für serielle Übertragung **
serial_output_string
  DC.B "#"                   ;Start-Kennung
number_string
  DS.B 5                     ;Dezimal-ASCII-Zahl mit fünf Stellen
number_string_end
  DC.B ","                   ;Komma-ASCII-Zeichen
checksum_string
  DS.B 2                     ;Checksumme Hex-ASCII-Zahl mit zwei Stellen
checksum_string_end
  DC.B 10                    ;Line-Feed
serial_output_string_end
;  DC.B TRUE                  ;Nullbyte
  EVEN

; ** Fehlermeldungen **
error_text1
  DC.B "Couldn't create message port",10,0
error_text1_end
  EVEN
error_text2
  DC.B "Couldn't open serial.device",10,0
error_text2_end
  EVEN
error_text3
  DC.B "Serial device in use",10,0
error_text3_end
  EVEN
error_text4
  DC.B "Baud rate not supported by hardware",10,0
error_text4_end
  EVEN
error_text5
  DC.B "Bad parameter",10,0
error_text5_end
  EVEN
error_text6
  DC.B "Hardware data overrun",10,0
error_text6_end
  EVEN
error_text7
  DC.B "No data set ready",10,0
error_text7_end
  EVEN
error_text8
  DC.B "Write to serial port failed",10,0
error_text8_end
  EVEN

program_version DC.B "$VER: WriteSerialPort beta 1.2 (26.9.18)",0
  EVEN

  END


  lea     number_string(pc),a0 ;Stringadresse
  move.l  (a2),a0            ;Zeiger auf String
  moveq   #TRUE,d7           ;Schleifenzähler zurücksetzen
search_sting_end_loop
  addq.w  #1,d7              ;Zähler erhöhen
  tst.b   (a0)+              ;Nullbyte ?
  bne.s   search_sting_end_loop ;Nein -> verzweige
  subq.w  #1,d7              ;Wegen dbf
  lea     number_string_end(pc),a1 ;Ziel
copy_ascii_number_loop
  move.b  -(a0),-(a1)        ;Rückwärts kopieren
  dbf     d7,copy_ascii_number_loop

  move.l  #512,IO_RBUFLEN(a1)  ;Eingangspuffergröße 512 (Standart)
