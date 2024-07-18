; #####################################
; # Programm: Write-Serial-Port2.asm  #
; # Autor:    Christian Gerbig        #
; # Datum:    02.11.2018              #
; # Version:  1.0                     #
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

  INCLUDE "hardware/custom.i"

  INCDIR "Daten:Asm-Sources.AGA/normsource-includes/"


  INCLUDE "equals.i"



  RSRESET

  RSRESET

RDArgs_structure    RS.L 1

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
  bsr.s   check_cmd_line
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   end1               ;Ja -> verzweige
  bsr     write_string
end1
  bsr     free_RDArgs_structure
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
  cmp.l   #59,d0             ;> 59 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
no_argument_SECS
  move.l  (a2),a0            ;Zeiger auf Langwort-Dezimalwert Minuten
  move.l  a0,d1              ;Zeiger = NULL ?
  beq.s   no_argument_MINS   ;Ja -> verzweige
  move.l  (a0),d1            ;Minutenwert
  cmp.l   #99,d1             ;> 99 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
  MULUF.W 60,d1,d2           ;*60 = Sekundenwert
no_argument_MINS
  add.l   d0,d1              ;+ Sekundenwert = Gesamtwert Sekunden
  MULUF.L 10,d1,d0           ;*10 = Zählerwert (in 100 ms)

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

; ** String auf seriellem Port ausgeben **
  CNOP 0,4
write_string
  CALLEXEC Disable
  move.l  #_CUSTOM,a5
  lea     serial_output_string(pc),a0 ;Zeiger auf Ausgabe-String
  move.w  ADKCONR(a5),d3     ;Alten Inhalt von ADKCON retten
  move.w  #$0100,d1          ;8 Bits pro Zeichen beim Schreiben, 1 Stoppbit
  move.w  #ADKCONF_UARTBRK,ADKCON(a5) ;Neuer Inhalt für ADKCON
  move.w  #SERDATRF_TBE,d2
  move.w  #(3546895/2400)-1,SERPER(a5) ;Baudrate 2400 bps
  moveq   #(serial_output_string_end-serial_output_string)-1,d7 ;Anzahl der Bytes zum Schreiben
write_string_loop
  move.w  SERDATR(a5),d0     ;SERDAT lesen
  and.w   d2,d0              ;TBE-Bit gesetzt ?
  beq.s   write_string_loop  ;Nein -> verzweige
  move.b  (a0)+,d1           ;Datenbyte D0-D7 kopieren
  move.w  d1,SERDAT(a5)      ;und Datenwort übertragen
  dbf     d7,write_string_loop
  or.w    #ADKCONF_SETCLR,d3 ;Bits setzen
  move.w  d3,ADKCON(a5)      ;Alter Inhalt von ADKCON
  CALLLIBQ Enable

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


  CNOP 0,4
_SysBase DC.L 0
_DOSBase  DC.L 0
variables DS.B variables_size


dos_name           DC.B "dos.library",0



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
  DC.B "MINS 99 SECS 59 "
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


program_version DC.B "$VER: WriteSerialPort2 beta 1.0 (2.11.18)",0
  EVEN

  END
