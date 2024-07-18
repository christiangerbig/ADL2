; ###################################
; # Programm: AmigaDemoLauncher.asm #
; # Autor:    Christian Gerbig      #
; # Datum:    11.01.2020            #
; # Version:  1.9 beta              #
; # CPU:      68020+                #
; # FASTMEM:  -                     #
; # Chipset:  AGA                   #
; # OS:       3.0+                  #
; ###################################

; Lader für Intros und Demos "DemoSelector"
; Mit CoolCapture-Abfrage
; Mit Level-7-Interrupt (optional im Code)
; Mit erweiterter Fehlerausgabe über IOErr()
; Mit Abfrage der WB-Message als Option, jedoch bis jetzt nicht genutzt
; Mit 123-Zeichen Pfadlänge für Demo
; Mit 63-Zeichen Pfadlänge für Scriptfile
; Mit "AGA 020" - Modus
; Mit ID für Trap0-Routine
; Völlig überarbeiterter Prozessablauf, es kann jetzt der DemoSelector immer
; wieder aufgerufen werden und es können jederzeit weitere Demos hinzugefügt
; werden
; Mit ReadArgs()-Nutzung
; Mit überarbeiteter Timer-Value-Parsing-Routine
; Mit Berücksichtigung eines Pre-Script-Files bei der Playlist
; Prüfung des Dateinamen auf maximale Länge
; Stoppen des Timers nach vorzeitigem Verlassen des Demos durch ein Tastatur-
; Reset mit der Reset-Routine
; Entfernen des Reset-Programms nach einem Tastatur-Reset, wenn bereits alle
; Demos ausgeführt wurden. Jedoch nur, wenn vorher RunDemo ohne die Option
; ENDLESS aufgerufen wurde.
; Beim Reset wird durch einen gefärbten Playfieldschirm angezeigt, dass der Demo
; Launcher im Speicher noch aktiv ist
; Wird beim Reset die rechte Maustaste gedrückt, dann wird der Demo Launcher
; aus dem Speicher entfernt.
; Fehlerabfrage verfeinert
; Genauere Fehlermeldungen
; Es werden im Dateirequester mehr Endungen ausmaskiert
; Nach dem Parsen der Playliste wird ausgegeben, wie viele Einträge noch in
; die Wiedergabeliste transferiert werden können

; Demo-Abspieler "RunDemo"
; Dummy-Screen mit Dummy-Fenster wird in Schwarz umgeblendet
; Mit exe-file-Test
; Mit Aktivierung der Reset-Routine
; Mit erweiterter Fehlerausgabe IOError()
; Mit Abfrage der WB-Message als Option, jedoch bis jetzt nicht genutzt
; Mit 123-Zeichen Pfadlänge für Demo
; Mit 63-Zeichen Pfadlänge für Scriptfile
; Mit "AGA 020"-Startmodus
; Mit Abschalten der 68030/68040-MMU
; Mit geänderter NOFASTMEM-Routine
; Mit Rückkehr zur WB und wieder Einblenden des Screens
; Aktivieren des Zurücksetzens Level-7-interrupt-vektors (optional im Code)
; Mit ReadArgs()-Nutzung
; Mit Ausgabe des Strings über das serial.device
; Mit neuen Argumenten
; Mit geänderter 68040/60 MMU-Routine
; Ab- und Anschalten der 68030/40/60 MMU (optional im Code)
; Mit überarbeiteter Timer-Value-Parsing-Routine
; Mit dem Argument scriptfile
; Prüfung der Dateinamen auf maximale Länge
; Stoppen des Timers bei vorzeitigem Verlassen des Demos
; Entfernen des Demo Launchers aus dem Speicher nach dem Verlassen des
; letzten Demos, wenn nicht das Argument ENDLESS angegeben wurde
; Abschalten der 040/060-MMU erneut geändert. 030-MMU-Routine deaktiviert,
; kann aber optional angeschaltet werden
; Diese Version mit dem Abschalten der MMU funktioniert auf realem A1200/060
; beim Test mit Polka Brothers/FridayAtEight und Coccon/Catabasis. Die Demos
; werden nicht verlangsamt abgespielt !
; Neues Argument REMOVE: Demo Launcher wird vorzeitig aus dem Speicher ent-
; fernt
; Fehlerausgabe bei Nichtladen der Datei verfeinert und korrigiert
; Fehlerabfrage korrigiert
; Ausgabe des Namens des Demos das ausgeführt wird
; Änderung des Arguments in PRERUNSCRIPT

; Gesamtprogramm "AmigaDemoLauncher"
; Neues Argument NEWENTRY: Manuelles Erstellen eines Eintrags über den Amiga
; Demo Launcher ohne eine Playlist zu laden
; Neues Argument QUIET: Wenn keine interne Playlist vorhanden ist, dann wird
; der Dateirequester unterdrückt, der Amiga Demo Launcher vorzeitig beendet
; und der Returncode 5 für eine Batch-Verarbeitung zurückgegeben zurückgegeben
; Neues Argument SHOWQUEUE: Anzeigen des Inhalts der  Playback Queue mit
; laufender Nummer, Demoname und Tag-Status
; Neues Argument PLAYENTRY: Abspielen eines bestimmten Eintrags aus der
; Playback Queue
; Lokale Optimierungen
; Equals erweitert
; Texte geändert
; Beseitigung Fehlerausgabe bei Speicherplatzmangel
; File-Requester: Je nachdem, ob die Workbench geladen wurde oder nicht
; variert der Cancel-Text und die darauffolgende Aktion: "Quit" -> Rückkehr
; zur Shell, "Reboot" -> Software-Reset
; Kurzer Hinweis auf HELP argument nur bei Start von der WB aus.
; Weitere CacheClearU-Aufrufe eingefügt
; Falsche Ermittlung des Zeigers auf die ColorMap-Struktur korrigiert
; Pattern-String für File-Requester geändert
; Fehlerhafte Abfrage, ob ein Software-Reset bei nicht geladener WB ausge-
; führt wird oder nicht war an den Status der geladenen/nicht geladenen WB
; gebunden -> Reset nach Transferieren einer Playliste aus einem CLI heraus,
; ohne dass die WB geladen ist. Lösung: Eine neue Variable "ds_reset_active"
; wird nun abgefragt und nur auf TRUE gesetzt, wenn im File-Requester der
; Button "Reboot" existiert
; Longword-Alignment bei Variablen durch Dummies garantiert
; Reihenfolge der Aktivierung MMU/Caches bei "AGA 020"-Modus geändert: Erst
; werden die Caches aktiviert, dann die MMU
; "No AGA" startmode: Nun wird auch die MMU deaktiviert
; Abfrage der AGA-Chip-Version verbessert
; Argument SOFTRESET: Wird nur ausgeführt, wenn die Argumente LOOP und QUIET
; nicht angegeben wurden. Bei QUIET erfolgt nur eine Ausführung, wenn Demos
; in der Playback Queue sind.
; Reboot-File-Requester: Kein Reset, wenn keine Datei ausgewählt wurde, oder
; es einen Fehler > 5 gab. Es erfolgt die Fehlerausgabe. Wurde keine weitere
; Datei ausgewählt, dann erfolgt ein Reset.
; NoAGA Startmode: Es wird bei der MMU config für den Instruction Cache der
; Modus "cache inhibited, precise" anstatt "cachable, writethrough" verwendet
; Aufruf von PFLUSHA bevor die MMU deaktiviert wird
; Es werden jetzt alle wichtigen Hardware-Register wieder hergestellt oder
; zurück gesetzt
; Wiederherstellen des unteren 1MB CHIP-Memories im "OCS"-Startmode hat sich
; als nicht prakatikabel erwiesen
; Neue Startmodes: "Stock-OCS", "Stock-AGA" und "Fast-OCS/AGA" ersetzen und
; erweitern die alten.
; "Stock-OCS"     = 68000 downgrade/OCS downgrade/NOFASTMEM
; "Stock-AGA"     = 68020 downgrade/NOFASTMEM
; "Fast-OCS/AGA"  = keine Einschränkungen
; Geänderte MMU-030 off-Routine, die jetzt die Translation-Register bei der
; Konfiguration berücksichtigt
; Geänderte MMU-040/060-Routine, URP/SRP werden nicht mehr auf NULL gesetzt
; Überarbeitete Textausgabe des Arguments SHOWQUEUE
; Änderung Argument SOFTRESET: Wird es angegeben, dann wird der File-Requester
; mit dem "Reboot" Gadget dargestellt und nach dem Anklicken, wenn mindestens
; eine Datei gewählt wurde, ein Reset ausgeführt. Ansonsten wird das "Quit"
; Gadget dargestellt.
; File Requester: Zeiger auf negativen Standart-Text "Quit" in der Requester-
; Struktur wird jetzt früher initialisiert. Der Zeiger auf den Alterntiv-Text
; "Reboot" wird erst kurz vor dem Aufruf von AllocAslRequest() initialisiert
; File Requester: Es wird nun auch geprüft, ob ein Verzeichnisname angegeben
; wurde
; Änderung der Mindestconfig: OS 2.04, 68020, OCS anstatt OS 3.0, 68020, AGA
; => A500/A2000 mit OS2/OS3 + Turbokarte und A3000/030 werden ebenfalls
; unterstützt.
; Differenziertere Fehlerausgabe beim Fehlen einzelner Mindestkomponenten
; Kleinere Optimierungen
; Abfrage der rechten Maustaste in der Reset-Routine geändert. Das POTGO-
; Register wird vorher auf den Standartwert zurückgesetzt.
; Anzeigen, dass AllocAbs() der Reset-Routine nicht erfolgreich war
; Es wird jetzt trotzdem die Playback-Liste angelegt, wenn mindestens eine
; Datei ausgewählt wurde und die zweite Datei ein leerer String ist. Somit
; bleiben alle Einträge vor dem Leerstring erhalten, obwohl mit einer Fehler-
; meldung abgebrochen wird
; Unterstützung von WHDLoad Slave-Dateien: Das aus der Playback-Liste zu
; ladende Demo wird darauf untersucht, ob es sich um eine Slave-Datei handelt.
; Fällt der Test positiv aus, dann werden die ToolTypes der WHDLoad .info-
; Datei daraufhin überprüft, ob die Argumente PRELOAD, PRELOADSIZE oder
; QUITKEY angegeben wurden. Es wird dann ein Kommando-String erstellt, der
; über die Funktion Execute() ausgeführt wird und das Demo über WHDLoad
; startet
; Neues Argument LMBEXIT n: n=2...10 Bei einem Demo mit mehreren Teilen wird
; vom Reset Device automatisch das Drücken der linken Maustaste n-mal nach
; der vorgegebenen Spielzeit simuliert und somit zum nächsten Teil gesprungen.
; Die Spielzeit wird dabei wieder zurückgesetzt und von Neuem heruntergezählt.
; Intern wird mit n=1...9 gearbeitet und n zu der Spielzeit einfach dazu-
; addiert, bevor der Sekundenwert in Hex/ASCII umgewandelt wird. Wird keine
; Spielzeit angegeben, dann wird das Argument ignoriert und eine Fehlermeldung
; ausgegeben.
; Abbruch einer LOOP-Ausführung erst bei Fehlernummer = 20 (DOS-ERROR FAIL)
; oder > 121 (Datei ist nicht ausführbar)
; Routinen zur Umwandlung von Zahlen umgeschrieben und von Fehlern bereinigt                                                       <
; Fehler in Routine zum Warten auf eine Rasterzeile bereinigt
; Fehler bei der Berechnung der Länge des Demo-Dateinamens bereinigt
; Das Argument LOOP kann jetzt über CTRL-C abgebrochen werden. Bevor das Demo
; per Mausklick beendet wird, muss die Tastenkombination CTRL-C dauerhaft
; gedrückt werden, damit nach dem Einblenden die Abfrage der Tastenkmbination
; funktioniert
; ADKCON wird jetzt richtig zurückgesetzt, bevor der alte Inhalt hineinge-
; schrieben wird


  SECTION code_and_variables,CODE

  MC68040

; ** Library-Includes V.3.5 nachladen **
  INCDIR "Daten:include3.5/"

  INCLUDE "dos/dos.i"
  INCLUDE "dos/dosextens.i"
  INCLUDE "dos/rdargs.i"
  INCLUDE "dos/dos_lib.i"

  INCLUDE "exec/exec.i"
  INCLUDE "exec/exec_lib.i"

  INCLUDE "graphics/gfxbase.i"
  INCLUDE "graphics/videocontrol.i"
  INCLUDE "graphics/graphics_lib.i"

  INCLUDE "intuition/intuition.i"
  INCLUDE "intuition/intuition_lib.i"

  INCLUDE "libraries/asl_lib.i"
  INCLUDE "libraries/asl.i"
  INCLUDE "libraries/icon_lib.i"
  INCLUDE "libraries/any_lib.i"

  INCLUDE "workbench/startup.i"
  INCLUDE "workbench/workbench.i"

  INCLUDE "devices/serial.i"

  INCLUDE "resources/cia_lib.i"

  INCLUDE "hardware/adkbits.i"
  INCLUDE "hardware/cia.i"
  INCLUDE "hardware/custom.i"
  INCLUDE "hardware/dmabits.i"
  INCLUDE "hardware/intbits.i"

  INCDIR "Daten:Asm-Sources.AGA/normsource-includes/"


; ** allgemeine Konstanten **
  INCLUDE "equals.i"

workbench_start_enabled      EQU FALSE

OS_VERSION                   EQU 37

level_7_int_handler          EQU FALSE ;TRUE = Level7-Handler aktivieren

demofile_path_length         EQU 124
slavefile_path_length        EQU 124
prerunscript_path_length     EQU 64

FAST                         EQU $00
OCS                          EQU $01
AGA                          EQU $02

colourclock_PAL              EQU 3546895
baud                         EQU 2400


; ** DemoSelector-Konstanten **
ds_entries_num_default_max   EQU 10
ds_entries_num_max_value     EQU 99


; ** Reset-Programm-Konstanten **
rp_delay_value               EQU 50


; ** RunDemo-Konstanten **
rd_MAGIC_COOKIE_value        EQU $000003f3

rd_PRELOAD_arg_length        EQU 8
rd_PRELOADSIZE_arg_length    EQU 20
rd_QUITKEY_arg_length        EQU 11
rd_whdload_slave_path_length EQU 124
rd_whdload_icon_path_length  EQU 124

rd_sfo_fader_speed           EQU 6
rd_sfi_fader_speed           EQU 8


  INCLUDE "except-vectors-offsets.i"



  RSRESET

  RSRESET

; ** allgemeine Variablenoffets **
DOS_return_code               RS.L 1
  IFEQ workbench_start_enabled
WB_msg                        RS.L 1
  ENDC

RDArgs_structure                  RS.L 1

entries_buffer                RS.L 1
entries_num                   RS.W 1
entries_num_max               RS.W 1


; ** DemoSelector-Variablenoffsets **
ds_playlist_filename          RS.L 1
ds_playlist_file_lock         RS.L 1
ds_FileInfoBlock_structure        RS.L 1
ds_playlist_file_length       RS.L 1
ds_playlist_file_memory       RS.L 1
ds_playlist_file_handle       RS.L 1
ds_own_RDArgs_structure           RS.L 1

ds_file_requester             RS.L 1
ds_current_pathname           RS.L 1
ds_entries_multiselect_num    RS.W 1
ds_reset_active               RS.W 1

ds_load_active                RS.W 1

ds_playlist_active            RS.W 1 ;Argument playlist
ds_playlist_entries_num       RS.W 1
ds_playlist_succ_entries_num  RS.W 1

ds_reset_prg_active           RS.W 1
ds_longword_align_dummy       RS.W 1


; ** RunDemo-Variablenoffsets **
rd_reset_prg_mem              RS.L 1

rd_RDArgs_structure               RS.L 1

rd_ser_msg_port               RS.L 1

rd_largest_FASTmem_block_size RS.L 1
rd_largest_FASTmem_block_pointer  RS.L 1

rd_demo_filepath              RS.L 1
rd_demo_filename              RS.L 1
rd_demo_filename_length       RS.L 1
rd_MAGIC_COOKIE               RS.L 1
rd_demofile_seglist           RS.L 1
rd_disk_object                RS.L 1
rd_demo_dir_lock              RS.L 1
rd_old_current_dir_lock       RS.L 1
rd_prerunscript_path          RS.L 1

rd_old_view                   RS.L 1
rd_old_sprite_resolution      RS.L 1
rd_sprite_data_structure      RS.L 1
rd_dummy_window               RS.L 1

rd_old_VBR                    RS.L 1
rd_own_trap_vectors           RS.L 1
rd_old_CACR                   RS.L 1

rd_old_TC                     RS.L 1
rd_old_DTT0                   RS.L 1
rd_old_DTT1                   RS.L 1
rd_old_ITT0                   RS.L 1
rd_old_ITT1                   RS.L 1
rd_old_030_TC                 RS.L 1
rd_old_030_TT0                RS.L 1
rd_old_030_TT1                RS.L 1
rd_clr_030_MMU_reg            RS.L 1

rd_old_PCR                    RS.L 1

rd_old_COP1LC                 RS.L 1
rd_old_COP2LC                 RS.L 1

rd_old_DMACON                 RS.W 1
rd_old_INTENA                 RS.W 1
rd_old_ADKCON                 RS.W 1

rd_old_CIAAPRA                RS.B 1
rd_old_CIAATALO               RS.B 1
rd_old_CIAATAHI               RS.B 1
rd_old_CIAATBLO               RS.B 1
rd_old_CIAATBHI               RS.B 1
rd_old_CIAAICR                RS.B 1
rd_old_ciaa_cra_bits                RS.B 1
rd_old_ciaa_crb_bits                RS.B 1

rd_old_CIABPRB                RS.B 1
rd_old_CIABTALO               RS.B 1
rd_old_CIABTAHI               RS.B 1
rd_old_CIABTBLO               RS.B 1
rd_old_CIABTBHI               RS.B 1
rd_old_CIABICR                RS.B 1
rd_old_ciab_cra_bits                RS.B 1
rd_old_ciab_crb_bits                RS.B 1

rd_whdload_slave_active       RS.W 1

rd_sf_colors_number              RS.L 1
rd_sf_odd_sprite_color_base      RS.L 1
rd_sf_even_sprite_color_base     RS.L 1
rd_sf_color_values32          RS.L 1
rd_sf_color_cache32           RS.L 1
rd_sfo_active                 RS.W 1
rd_sfi_active                 RS.W 1

rd_play_duration              RS.W 1 ;Argument MIN[S]/SEC[S]
rd_play_duration_active       RS.W 1 ;Argument MIN[S]/SEC[S]
rd_prerunscript_active        RS.W 1 ;Argument PRERUNSCRIPT
rd_show_entries_active        RS.W 1 ;Argument SHOWENTRIES
rd_play_entry_offset          RS.W 1 ;Argument PLAYENTRY
rd_random_play_active         RS.W 1 ;Argument RANDOM
rd_endless_play_active        RS.W 1 ;Argument ENDLESS
rd_loop_play_active           RS.W 1 ;Argument LOOP
rd_nofader_active             RS.W 1 ;Argument NOFADER
rd_reset_active               RS.W 1 ;Argument SOFTRESET
rd_remove_reset_prg_active    RS.W 1 ;Argument REMOVE

variables_size                RS.B 0


  RSRESET

cmd_results_array      RS.B 0

; ** DemoSelector **
cra_HELP               RS.L 1
cra_MAXENTRIES         RS.L 1
cra_RESETLOADPOS       RS.L 1
cra_playlist           RS.L 1
cra_NEWENTRY           RS.L 1
cra_QUIET              RS.L 1
; ** RunDemo **
cra_MINS               RS.L 1
cra_SECS               RS.L 1
cra_LMBEXIT            RS.L 1
cra_PRERUNSCRIPT       RS.L 1
cra_SHOWENTRIES        RS.L 1
cra_PLAYENTRY          RS.L 1
cra_RANDOM             RS.L 1
cra_ENDLESS            RS.L 1
cra_LOOP               RS.L 1
cra_NOFADER            RS.L 1
cra_SOFTRESET          RS.L 1
cra_REMOVE             RS.L 1

cmd_results_array_size RS.B 0


  RSRESET

ds_playlist_results_array      RS.B 0

ds_pra_demofile                RS.L 1
ds_pra_OCS                     RS.L 1
ds_pra_AGA                     RS.L 1
ds_pra_FAST                    RS.L 1
ds_pra_MINS                    RS.L 1
ds_pra_SECS                    RS.L 1
ds_pra_LMBEXIT                 RS.L 1
ds_pra_prerunscript            RS.L 1

ds_playlist_results_array_size RS.B 1


  RSRESET

playback_queue_entry      RS.B 0

pqe_demofile_path         RS.B 124
pqe_playtime              RS.W 1
pqe_startmode             RS.B 1
pqe_tag_active            RS.B 1
pqe_prerunscript_path     RS.B 64

playback_queue_entry_size RS.B 0



; ## Makrobefehle ##

; ** Allgemeine Makrobefehle **
  INCLUDE "macros.i"


; ** Reset-Programm Makrobefehle **
RP_GET_ENTRIES_NUM MACRO
  trap    #0
  ENDM

RP_GET_ENTRIES_NUM_MAX MACRO
  trap    #1
  ENDM

RP_GET_ENTRIES_OFFSET MACRO
  trap    #2
  ENDM

RP_GET_ENTRIES_BUFFER MACRO
  trap    #3
  ENDM

RP_GET_ENDLESS_PLAY_STATE MACRO
  trap    #4
  ENDM

RP_GET_OWN_TRAP_0_VECTOR MACRO
  trap    #5
  ENDM

RP_GET_RESET_PRG_size MACRO
  trap    #6
  ENDM

  IFEQ level_7_int_handler
RP_SET_LEVEL_7_RESET_STATE MACRO
    trap    #7
    ENDM
  ENDC

; ** Programmbeginn AmigaDemoLauncher **
start
  movem.l d2-d7/a2-a6,-(a7)
  lea     variables(pc),a3   ;Basiszeiger auf alle Variablen
  bsr     init_variables
  bsr     init_structures
  IFEQ workbench_start_enabled
    bsr     test_start
    tst.w   d0               ;Fehler aufgetreten ?
    bne     end14            ;Ja -> verzweige
  ENDC
  bsr     open_dos_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end14              ;Ja -> verzweige
  bsr     open_gfx_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end13              ;Ja -> verzweige
  bsr     check_system
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end12              ;Ja -> verzweige
  bsr     open_intuition_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end12              ;Ja -> verzweige
  bsr     check_CoolCapture_vector
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end11              ;Ja -> verzweige
  bsr     check_cmd_line
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end10              ;Ja -> verzweige
  tst.w   ds_reset_prg_active(a3) ;Reset-Programm bereits installiert ?
  bne.s   ds_start           ;Nein -> verzweige
  tst.w   ds_load_active(a3) ;Lademodus aktiv ?
  bne     rd_start           ;Nein -> verzweige

; ** DemoSelector **
ds_start
  moveq   #RETURN_WARN,d0
  cmp.l   DOS_return_code(a3),d0 ;Wenn Fehler = 5
  beq     end10              ;dann verzweige
  bsr     ds_alloc_entries_buffer
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end10              ;Ja -> verzweige
  tst.w   ds_playlist_active(a3) ;Wurde eine Playlist-Datei angegeben ?
  bne.s   ds_open_file_requester ;FALSE -> verzweige

; ** Es wurde eine Playlist-Datei angegeben **
  bsr     ds_lock_playlist_file
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end10           ;Ja -> verzweige
  bsr     ds_alloc_FileInfoBlock_structure
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end9            ;Ja -> verzweige
  bsr     ds_get_playlist_file_length
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end8            ;Ja -> verzweige
  bsr     ds_alloc_playlist_file_mem
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end8            ;Ja -> verzweige
  bsr     ds_open_playlist_file
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end7            ;Ja -> verzweige
  bsr     ds_read_playlist_file
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end6            ;Ja -> verzweige
  bsr     ds_parse_playlist_file
  moveq   #RETURN_WARN,d1
  cmp.l   d1,d0              ;Fehler > 5 aufgetreten ?
  bgt     ds_end6            ;Ja -> verzweige
  bra.s   ds_end3

; ** Es wurte keine Playlist-Datei angegeben **
  CNOP 0,4
ds_open_file_requester
  bsr     ds_open_asl_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     ds_end10           ;Ja -> verzweige
  lea     ds_current_drawer_name(pc),a5 ;Zeiger auf Puffer für aktuellen Verzeichnisnamen
  bsr     ds_get_program_dir
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   ds_end2            ;Ja -> verzweige
ds_choose_files_loop
  bsr     ds_files_num_to_ascii
  bsr     ds_init_file_requester
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   ds_end2            ;Ja -> verzweige
  bsr     ds_display_file_requester
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   ds_end1            ;Ja -> verzweige
  bsr     ds_get_demo_filepath
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   ds_end1            ;Ja -> verzweige
  bsr     ds_free_file_requester_structure
  bsr     ds_display_startmode_requester
  move.w  entries_num_max(a3),d0 ;Maximale Anzahl der Dateien zum Auswählen
  cmp.w   entries_num(a3),d0 ;Wurde das Maximum an Dateien ausgewählt?
  bne.s   ds_choose_files_loop ;Nein -> Schleife
  bsr     ds_maximum_entries_reached
  bra.s   ds_end2
  CNOP 0,4
ds_end1
  bsr     ds_free_file_requester_structure
ds_end2
  bsr     ds_close_asl_lib
ds_end3
  tst.w   entries_num(a3)    ;Wurde mindestens eine Datei ausgewählt?
  beq.s   ds_end6            ;Nein -> verzweige
  cmp.l   #ERROR_OBJECT_NOT_FOUND,DOS_return_code(a3) ;Wurde keine zweite Datei ausgewählt?
  beq.s   ds_end4            ;Ja -> verzweige
  moveq   #RETURN_WARN,d0
  cmp.l   DOS_return_code(a3),d0 ;Ist ein Fehler > 5 aufgetreten?
  blt.s   ds_end6            ;Ja -> verzweige
ds_end4
  tst.w   ds_reset_prg_active(a3) ;Reset-Prg bereits installiert?
  beq.s   ds_end5            ;Ja -> verzweige
  bsr     ds_init_reset_prg
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   ds_end6            ;ja -> verzweige
ds_end5
  RP_GET_ENTRIES_NUM         ;Zeiger auf Variable rp_entries_num  -> a0
  move.w  entries_num(a3),(a0) ;Aktuelle Anzahl der Dateipfade an rp_entries_num übergeben
ds_end6
  tst.w   ds_playlist_active(a3) ;Wurde eine Playlist-Datei angegeben ?
  bne.s   ds_end10           ;FALSE -> verzweige
  bsr     ds_close_playlist_file
ds_end7
  bsr     ds_free_playlist_file_mem
ds_end8
  bsr     ds_free_FileInfoBlock_structure
ds_end9
  bsr     ds_unlock_playlist_file
ds_end10
  bsr     ds_free_entries_buffer
  moveq   #RETURN_WARN,d0
  cmp.l   DOS_return_code(a3),d0 ;Ist ein Fehler > 5 aufgetreten?
  blt.s   end10              ;Ja -> verzweige
  tst.w   entries_num(a3)    ;Wurde mindestens eine Datei ausgewählt?
  beq.s   end10              ;Nein -> verzweige
  tst.w   rd_reset_active(a3) ;Soll ein Reset ausgeführt werden ?
  beq     rd_reboot          ;TRUE -> verzweige

; ** AmigaDemoLauncher **
end10
  bsr     free_RDArgs_structure
  bsr     print_io_error
end11
  bsr     close_intuition_lib
end12
  bsr     close_gfx_lib
end13
  bsr     close_dos_lib
end14
  IFEQ workbench_start_enabled
    bsr     reply_WB_msg
end15
  ENDC
  move.l  DOS_return_code(a3),d0 ;Returncode = OK
  movem.l (a7)+,d2-d7/a2-a6
  rts

; ** Variablen initialisieren **
  CNOP 0,4
init_variables

; ** Allgemeine Variablen initialisieren **
  lea     _SysBase(pc),a0
  move.l  exec_base.w,(a0)

  moveq   #0,d0
  move.l  d0,DOS_return_code(a3)
  IFEQ workbench_start_enabled
    move.l  d0,WB_msg(a3)
  ENDC

; ** DemoSelector-Variablen initialisieren **
  move.w  d0,ds_entries_multiselect_num(a3)
  moveq   #FALSE,d1

  move.w  d1,ds_load_active(a3) ;TRUE = Lademodus

  move.w  d1,ds_playlist_active(a3) ;TRUE = Playlist wurde angegeben - Argument playlist
  move.w  d0,ds_playlist_entries_num(a3)
  move.w  d0,ds_playlist_succ_entries_num(a3)

  move.w  d1,ds_reset_prg_active(a3)


; ** RunDemo-Variablen initialisieren **
  move.l  d0,rd_clr_030_MMU_reg(a3)

  move.l  d0,rd_demofile_seglist(a3)
  move.l  d0,rd_prerunscript_path(a3)

  move.w  d1,rd_whdload_slave_active(a3) ;TRUE = Demo wird als WHDLOAD Slave-Datei ausgeführt

  move.w  d0,rd_sfo_active(a3)
  move.w  d0,rd_sfi_active(a3)

  move.w  d1,rd_play_duration_active(a3) ;TRUE = Sekundenwert vorhanden - Argument MIN[S]/SEC[S]
  move.w  d1,rd_prerunscript_active(a3) ;TRUE = Scriptfile vorhanden - Argument PRERUNSCRIPT
  move.w  d1,rd_show_entries_active(a3) ;TRUE = Inhalt der Playback queue anzeigen - Argument SHOWENTRIES
  move.w  d0,rd_play_entry_offset(a3) ;TRUE = Es wurde kein Offset angegeben - Argument PLAYENTRY
  move.w  d1,rd_random_play_active(a3) ;TRUE = Zufällige Offsets - Argument RANDOM
  move.w  d1,rd_endless_play_active(a3) ;TRUE = Endlosschleife - Argument ENDLESS
  move.w  d1,rd_loop_play_active(a3) ;TRUE = Keine Rückkehr zur Shell - Argument LOOP
  move.w  d1,rd_nofader_active(a3) ;TRUE = Kein Ein- und Ausfaden - Argument "NOFADER"
  move.w  d1,rd_reset_active(a3) ;TRUE = Reset nach Demoende - Argument SOFTRESET
  move.w  d1,rd_remove_reset_prg_active(a3) ;TRUE = Demo Launcher aus dem Speicher vorzeitig entfernen - Argument REMOVE
  rts

; ** Strukturen initialisieren **
  CNOP 0,4
init_structures
  bsr.s   ds_init_file_requester_taglist
  bsr     ds_init_file_requester_use_taglist
  bsr     init_easy_request_structures
  bsr     rd_init_color_table
  bsr     rd_init_ScreenTagList
  bsr     rd_init_WindowTagList
  bsr     rd_init_VideoControlTagList1
  bsr     rd_init_VideoControlTagList2
  bra     rd_init_VideoControlTagList3

; ** File-Requester-TagList initialisieren **
  CNOP 0,4
ds_init_file_requester_taglist
  lea     ds_file_requester_taglist(pc),a0
; ** Tags für Fensterbeeinflussung **
  move.l  #ASLFR_Window,(a0)+
  moveq   #0,d0
  move.l  d0,(a0)+
; ** Text für Textanzeige **
  move.l  #ASLFR_TitleText,(a0)+
  lea     ds_file_req_title(pc),a1
  move.l  a1,(a0)+
  move.l  #ASLFR_PositiveText,(a0)+
  lea     ds_file_req_ok_text(pc),a1
  move.l  a1,(a0)+
  move.l  #ASLFR_NegativeText,(a0)+
  lea     ds_file_req_cancel_text1(pc),a1 ;Zeiger auf Text "Quit"
  move.l  a1,(a0)+
; ** Grundparameter für FileRequester **
  move.l  #ASLFR_InitialLeftEdge,(a0)+
  move.l  d0,(a0)+
  move.l  #ASLFR_InitialTopEdge,(a0)+
  move.l  d0,(a0)+
  move.l  #ASLFR_InitialWidth,(a0)+
  move.l  #320,(a0)+
  move.l  #ASLFR_InitialHeight,(a0)+
  move.l  #200,(a0)+
  move.l  #ASLFR_InitialPattern,(a0)+
  lea     ds_file_req_pattern_text(pc),a1
  move.l  a1,(a0)+
; ** Optionen **
  move.l  #ASLFR_Flags1,(a0)+
  moveq   #FRF_DOPATTERNS+FRF_DOMULTISELECT,d1 ;Pattern-Gadget und Multiselect zulassen
  move.l  d1,(a0)+
  moveq   #TAG_DONE,d1
  move.l  d1,(a0)            ;Ende der Tag-Liste
  rts

; ** Zusätzliche File-Requester-Taglist initialisieren **
  CNOP 0,4
ds_init_File_Requester_use_taglist
  lea     ds_file_requester_use_taglist(pc),a0
  move.l  #ASLFR_InitialDrawer,(a0)+
  lea     ds_current_drawer_name(pc),a1
  move.l  a1,(a0)+
  moveq   #TAG_DONE,d1
  move.l  d1,(a0)            ;Ende der tag-Liste
  rts

; ** Easy-Request-Strukturen initialisieren **
  CNOP 0,4
init_easy_request_structures
 ; ** Requester für CoolCapture-Abfrage **
  lea     CoolCapture_req_structure(pc),a0 ;Zeiger auf Easy-Request-Struktur
  moveq   #EasyStruct_sizeOF,d2
  move.l  d2,(a0)+           ;Größe der Struktur
  moveq   #0,d0
  move.l  d0,(a0)+           ;Keine Flags
  lea     CoolCapture_req_title(pc),a1
  move.l  a1,(a0)+           ;Zeiger auf Titeltext
  lea     CoolCapture_req_text(pc),a1
  move.l  a1,(a0)+           ;Zeiger auf Text in Requester
  lea     CoolCapture_req_gadgets_text(pc),a1
  move.l  a1,(a0)            ;Zeiger auf Gadgettexte

; ** Requester für Startmode-Abfrage **
  lea     ds_startmode_req_structure(pc),a0 ;Zeiger auf Easy-Request-Struktur
  move.l  d2,(a0)+           ;Größe der Struktur
  move.l  d0,(a0)+           ;Keine Flags
  lea     ds_startmode_req_title(pc),a1
  move.l  a1,(a0)+           ;Zeiger auf Titeltext
  lea     ds_startmode_req_text(pc),a1
  move.l  a1,(a0)+           ;Zeiger auf Text in Requester
  lea     ds_startmode_req_gadgets_text(pc),a1
  move.l  a1,(a0)            ;Zeiger auf Gadgettexte
  rts

; ** Farbtabelle für Fader **
  CNOP 0,4
rd_init_color_table
  lea     rd_color_table32(pc),a0
  move.w  #1,(a0)+           ;Anzahl der Farben zum Laden
  moveq   #0,d0
  move.w  d0,(a0)+           ;Erste Farbe zum Laden
  move.l  d0,(a0)+           ;32-Bit Rotwert löschen
  move.l  d0,(a0)+           ;32-Bit Grünwert löschen
  move.l  d0,(a0)+           ;32-Bit Blauwert löschen
  move.l  d0,(a0)            ;Ende
  rts

; ** ScreenTagList-Struktur initialisieren **
  CNOP 0,4
rd_init_ScreenTagList
  lea     rd_ScreenTagList(pc),a0
  move.l  #SA_Top,(a0)+
  moveq   #0,d0
  move.l  d0,(a0)+
  move.l  #SA_Title,(a0)+
  lea     ScreenName(pc),a1
  move.l  a1,(a0)+
  move.l  #SA_DisplayID,(a0)+
  move.l  #PAL_MONITOR_ID|LORES_KEY,(a0)+
  move.l  #SA_Left,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Width,(a0)+
  moveq   #2,d2
  move.l  d2,(a0)+
  move.l  #SA_Height,(a0)+
  moveq   #2,d2
  move.l  d2,(a0)+
  move.l  #SA_Depth,(a0)+
  moveq   #1,d2
  move.l  d2,(a0)+
  move.l  #SA_DetailPen,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_BlockPen,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Font,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_ShowTitle,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Behind,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Quiet,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Type,(a0)+
  move.l  #CUSTOMSCREEN,(a0)+
  move.l  #SA_AutoScroll,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_SysFont,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Draggable,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Interleaved,(a0)+
  move.l  d0,(a0)+
  move.l  #SA_Colors32,(a0)+
  lea     rd_color_table32(pc),a1
  move.l  a1,(a0)+
  moveq   #TAG_DONE,d2
  move.l  d2,(a0)
  rts

; ** WindowTagList-Struktur initialisieren **
  CNOP 0,4
rd_init_WindowTagList
  lea     rd_WindowTagList(pc),a0
  move.l  #WA_CustomScreen,(a0)+
  moveq   #0,d0
  move.l  d0,(a0)+
  move.l  #WA_Left,(a0)+
  move.l  d0,(a0)+
  move.l  #WA_Top,(a0)+
  move.l  d0,(a0)+
  move.l  #WA_Width,(a0)+
  moveq   #2,d2
  move.l  d2,(a0)+
  move.l  #WA_MaxWidth,(a0)+
  move.l  d2,(a0)+
  move.l  #WA_MinWidth,(a0)+
  move.l  d2,(a0)+
  move.l  #WA_Height,(a0)+
  move.l  d2,(a0)+
  move.l  #WA_MaxHeight,(a0)+
  move.l  d2,(a0)+
  move.l  #WA_MinHeight,(a0)+
  move.l  d2,(a0)+
  move.l  #WA_DetailPen,(a0)+
  move.l  d0,(a0)+
  move.l  #WA_BlockPen,(a0)+
  move.l  d0,(a0)+
  move.l  #WA_IDCMP,(a0)+
  move.l  d0,(a0)+
  move.l  #WA_Flags,(a0)+
  move.l  #WFLG_BACKDROP|WFLG_BORDERLESS|WFLG_ACTIVATE,(a0)+
  move.l  #WA_AutoAdjust,(a0)+
  moveq   #1,d2
  move.l  d2,(a0)+
  move.l  #WA_Title,(a0)+
  lea     WindowName(pc),a1
  move.l  a1,(a0)+
  move.l  #WA_WindowName,(a0)+
  move.l  a1,(a0)+
  moveq   #TAG_DONE,d2
  move.l  d2,(a0)
  rts

; ** VideoControl-TagList initialisieren **
  CNOP 0,4
rd_init_VideoControlTagList1
  lea     rd_VideoControlTagList1(pc),a0
  move.l  #VTAG_SPRITERESN_GET,(a0)+
  moveq   #0,d0
  move.l  d0,(a0)+
  moveq   #TAG_DONE,d1
  move.l  d1,(a0)
  rts

; ** VideoControl-TagList initialisieren **
  CNOP 0,4
rd_init_VideoControlTagList2
  lea     rd_VideoControlTagList2(pc),a0
  move.l  #VTAG_SPRITERESN_SET,(a0)+
  move.l  #SPRITERESN_140NS,(a0)+
  moveq   #TAG_DONE,d1
  move.l  d1,(a0)
  rts

; ** VideoControl-TagList initialisieren **
  CNOP 0,4
rd_init_VideoControlTagList3
  lea     rd_VideoControlTagList3(pc),a0
  move.l  #VTAG_SPODD_BASE_GET,(a0)+
  moveq   #0,d0
  move.l  d0,(a0)+
  move.l  #VTAG_SPEVEN_BASE_GET,(a0)+
  move.l  d0,(a0)+
  moveq   #TAG_DONE,d1
  move.l  d1,(a0)
  rts

; ** Testen, ob von der Workbench ein Start erfolgte **
; -----------------------------------------------------
  IFEQ workbench_start_enabled
  CNOP 0,4
test_start
    sub.l   a1,a1              ;Nach dem eigenen Task suchen
    CALLEXEC FindTask
    tst.l   d0
    beq.s   task_error         ;Fehler -> verzweige
    move.l  d0,a2              ;aktuellen Task 
    tst.l   pr_CLI(a2)         ;Von WB gestartet ?
    beq.s   start_from_wb      ;Ja -> verzweige
start_from_CLI
    moveq   #TRUE,d0           ;Returncode = OK
    rts
    CNOP 0,4
start_from_WB
    lea     pr_MsgPort(a2),a0  ;Zeiger auf Message-Port
    CALLLIBS WaitPort          ;Auf Start-Message warten
    lea     pr_MsgPort(a2),a0  ;Zeiger auf Message
    CALLLIBS GetMsg            ;Message 
    move.l  d0,WB_msg(a3)      
    moveq   #TRUE,d0           ;Returncode = TRUE
    rts
    CNOP 0,4
task_error
    moveq   #RETURN_FAIL,d0
    move.l  d0,DOS_return_code(a3)
    moveq   #FALSE,d0          ;Returncode = FALSE
    rts
  ENDC

; ** DOS-Library öffnen **
  CNOP 0,4
open_dos_lib
  lea     dos_name(pc),a1    ;Name der DOS-Library
  moveq   #0,d0           ;Version egal
  CALLEXEC OpenLibrary       ;DOS-Library öffnen
  lea     _DOSBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf DOS-Base retten
  beq.s   dos_lib_error      ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
dos_lib_error
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Graphics-Library öffnen **
  CNOP 0,4
open_gfx_lib
  lea     gfx_name(pc),a1    ;Name der Graphics-Library
  moveq   #0,d0           ;Version egal
  CALLLIBS OpenLibrary       ;Graphics-Library öffnen
  lea     _GfxBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf Graphics-Base retten
  beq.s   gfx_lib_error      ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
gfx_lib_error
  lea     error_text1(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text1_end-error_text1,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Konfiguration checken **
  CNOP 0,4
check_system
  CALLLIBS Forbid            ;Multitasking aus
  cmp.w   #OS_Version,Lib_Version(a6) ;Kickstart 2.04+ ?
  blt.s   no_OS_min          ;Nein -> verzweige
  btst    #AFB_68020,AttnFlags+1(a6) ;68020+?
  beq.s   no_CPU_min         ;Nein -> verzweige
;  move.l  _GfxBase(pc),a0    ;GFX-Base 
;  moveq   #GFXF_HR_AGNUS+GFXF_HR_DENISE,d0 ;ECS-Chipset als Minimum
;  and.b   gb_ChipRevBits0(a0),d0 ;Bits ausmaskieren
;  subq.b  #GFXF_HR_AGNUS+GFXF_HR_DENISE,d0 ;ECS/AGA-Chipset vorhanden ?
;  bne.s   no_chipset_min     ;Nein -> verzweige
  CALLLIBS Permit            ;Multitasking an
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
no_OS_min
  lea     error_text2(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text2_end-error_text2,d0 ;Textlänge
  bra.s   print_check_system_error
  CNOP 0,4
no_CPU_min
  lea     error_text3(pc),a0 ;Zeiger auf Fehlertext
  move.l  #error_text3_end-error_text3,d0 ;Textlänge
;  bra.s   print_check_system_error
  CNOP 0,4
;no_chipset_min
;  lea     error_text4(pc),a0 ;Zeiger auf Fehlertext
;  move.l  #error_text4_end-error_text4,d0 ;Textlänge
print_check_system_error
  CALLLIBS Permit            ;Multitasking an
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Intuition-Library öffnen **
  CNOP 0,4
open_intuition_lib
  lea     intuition_name(pc),a1 ;Name der Intuition-Library
  moveq   #OS_Version,d0     ;Version 2.04+
  CALLLIBS OpenLibrary       ;Intuition-Library öffnen
  lea     _IntuitionBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf Intuition-Base retten
  beq.s   intuition_lib_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
intuition_lib_error
  lea     error_text5(pc),a0 ;Zeiger auf Fehlertext
  moveq   #error_text5_end-error_text5,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** CoolCapture-Vektor prüfen **
  CNOP 0,4
check_CoolCapture_vector
  move.l  CoolCapture(a6),d0 ;CoolCapture-Vektor <> NULL ?
  bne.s   CoolCapture_used   ;Ja -> verzweige
reset_prg_not_installed
  moveq   #ds_entries_num_default_max,d2
  move.w  d2,entries_num_max(a3) ;Defaultwert setzen
  lea     rp_entries_num_max(pc),a0
  move.w  d2,(a0)            ;Defaultwert setzen
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
CoolCapture_used
  move.l  d0,a0              ;CoolCapture-Vektor -> a0
  cmp.w   #"DL",2(a0)        ;Kennung "DL" vorhanden ?
  bne.s   CoolCapture_used_by_sys ;Nein -> verzweige
reset_prg_already_installed
  RP_GET_ENTRIES_NUM_MAX     ;Zeiger auf Variable rp_entries_num_max  -> a0
  move.w  (a0),entries_num_max(a3) ;Inhalt von rp_entries_num retten
  RP_GET_ENTRIES_NUM         ;Zeiger auf Variable rp_entries_num  -> a0
  move.w  (a0),entries_num(a3) ;Inhalt von rp_entries_num retten
  RP_GET_ENTRIES_BUFFER    ;Zeiger auf Variable rp_entries_buffer  -> a0
  move.l  a0,entries_buffer(a3) ;Inhalt von rp_entries_buffer retten
  moveq   #TRUE,d0           ;Returncode = TRUE
  move.w  d0,ds_reset_prg_active(a3) ;TRUE = Reset-Prg bereits installiert
  rts
  CNOP 0,4
CoolCapture_used_by_sys
  move.l  a3,a4              ;Inhalt von a3 retten
  sub.l   a0,a0              ;NULL = Requester erscheint auf Workbench
  lea     CoolCapture_req_structure(pc),a1 ;Zeiger auf Easy-Request-Struktur
  move.l  a0,a2              ;NULL = Keine IDCMP-Flags
  move.l  a0,a3              ;NULL = Keine Argumentenliste
  CALLINT EasyRequestArgs    ;Requester darstellen
  move.l  a4,a3              ;Alter Inhalt von a3
  tst.l   d0                 ;Wurde linkes Gadget "Proceed" (1) angeklickt?
  bne.s   reset_prg_not_installed ;Ja -> verzweige
quit_prg
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Befehlszeile überprüfen **
  CNOP 0,4
check_cmd_line
  lea     cmd_template(pc),a0
  move.l  a0,d1              ;Zeiger auf Befelsschablone
  lea     cmd_results_array_structure(pc),a2
  move.l  a2,d2              ;Zeiger auf Ergebnis-Felder
  moveq   #TRUE,d3           ;NULL = Keine eigene RDArgs-Struktur
  CALLDOS ReadArgs
  move.l  d0,RDArgs_structure(a3) ;Zeiger auf RDArgs-Struktur retten
  beq     check_cmd_line_error ;Wenn NULL -> verzweige

; ** DemoSelector-Argumente abfragen **
check_demoselector_arguments
; ** HELP-Argument abfragen **
  tst.l   cra_HELP(a2)       ;Boolean-Wert
  bne     check_cmd_line_error ;Wenn FALSE -> verzweige
; ** MAXENTRIES-Argument abfragen **
  moveq   #TRUE,d3           ;NULL
  tst.w   ds_reset_prg_active(a3) ;Reset-Programm installiert ?
  beq.s   no_argument_MAXENTRIES ;Ja -> verzweige
  move.l  cra_MAXENTRIES(a2),d0 ;Zeiger auf Zahlenwert von Argument "MAXENTRIES"
  beq.s   no_argument_MAXENTRIES ;Wenn NULL -> verzweige
  move.l  d0,a0              ;Zeiger 
  move.l  (a0),d0            ;Zahlenwert 
  beq     check_cmd_line_error ;Wenn NULL -> verzweige
  cmp.w   #ds_entries_num_max_value,d0
  bgt     check_cmd_line_error ;Wenn Zahl > 99 -> verzweige
  move.w  d0,entries_num_max(a3) ;Maximale Anzahl der Einträge übernehmen
  lea     rp_entries_num_max(pc),a0
  move.w  d0,(a0)            ;Maximale Anzahl der Einträge übernehmen
no_argument_MAXENTRIES
; ** RESETLOADPOS-Argument abfragen **
  tst.l   cra_RESETLOADPOS(a2) ;Boolean-Wert für Argument "RESETLOADPOS" gesetzt ?
  beq.s   no_argument_RESETLOADPOS ;Wenn NULL -> verzweige
  move.w  d3,entries_num(a3) ;TRUE = Offset in Einträge-Puffer zurücksetzen
no_argument_RESETLOADPOS
; ** playlist-Argument abfragen **
  move.l  cra_playlist(a2),ds_playlist_filename(a3) ;Zeiger auf Dateinamen der Playlist 
  beq.s   no_argument_playlist ;Wenn NULL verzweige
  move.w  d3,ds_playlist_active(a3) ;TRUE = Zeiger auf Dateinamen für Playlist vorhanden
  move.w  d3,ds_load_active(a3) ;TRUE = Ladevorgang
  bra.s   no_argument_NEWENTRY
  CNOP 0,4
no_argument_playlist
; ** NEWENTRY-Argument abfragen **
  tst.l   cra_NEWENTRY(a2)   ;Boolean-Wert für Argument "NEWENTRY" gesetzt ?
  beq.s   no_argument_NEWENTRY ;Wenn NULL -> verzweige
  move.w  d3,ds_load_active(a3) ;TRUE = Ladevorgang
no_argument_NEWENTRY
; ** QUIET-Argument abfragen **
  tst.l   cra_QUIET(a2)      ;Boolean-Wert für Argument "QUIET" gesetzt ?
  beq.s   no_argument_QUIET  ;Wenn NULL -> verzweige
  tst.w   ds_reset_prg_active(a3) ;Reset-Programm installiert ?
  beq.s   no_argument_QUIET  ;Ja -> verzweige
  moveq   #RETURN_WARN,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
no_argument_QUIET
  tst.w   ds_load_active(a3) ;Wenn kein Ladevorgang,
  bne.s   check_rundemo_arguments ;dann verzweige
  move.w  entries_num(a3),d0
  cmp.w   entries_num_max(a3),d0 ;Maximale Anzahl bereits erreicht ?
  beq.s   ds_maximum_entries_reached ;Ja -> verzweige
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
ds_maximum_entries_reached
  lea     ds_error_text1(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text1_end-ds_error_text1,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_WARN,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** RunDemo-Argumente abfragen **
  CNOP 0,4
check_rundemo_arguments
  tst.w   ds_reset_prg_active(a3) ;Reset-Programm installiert ?
  bne     no_argument_NOFADER ;Nein -> verzweige
; ** REMOVE-Argument abfragen **
ds_check_argument_REMOVE
  tst.l   cra_REMOVE(a2)     ;Boolean-Wert für Argument "REMOVE" gesetzt ?
  beq.s   no_argument_REMOVE ;Wenn NULL -> verzweige
  move.w  d3,rd_remove_reset_prg_active(a3) ;TRUE = Amiga Demo Launcher vorzeitig aus dem Speicher entfernen
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
no_argument_REMOVE
; ** MIN[S]/SEC[S]-Agrumente abfragen **
  move.l  cra_SECS(a2),d0    ;Zeiger auf Langwort-Dezimalwert Sekunden von Argument "SEC[S]"
  beq.s   no_argument_SECS   ;Wenn NULL -> verzweige
  move.l  d0,a0              ;Zeiger 
  move.l  (a0),d0            ;Sekundenwert 
  moveq   #59,d2
  cmp.l   d2,d0              ;> 59 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
no_argument_SECS
  move.l  cra_MINS(a2),d1    ;Zeiger auf Langwort-Dezimalwert Minuten von Argument "MIN[S]"
  beq.s   no_argument_MINS   ;Wenn NULL -> verzweige
  move.l  d1,a0              ;Zeiger 
  move.l  (a0),d1            ;Minutenwert 
  moveq   #99,d2
  cmp.l   d2,d1              ;Wert > 99 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
  MULUF.W 60,d1,d2           ;*60 = Sekundenwert
no_argument_MINS
  add.l   d0,d1              ;+ Sekundenwert = Gesamtwert Sekunden
  MULUF.L 10,d1,d0           ;*10 = Zählerwert (in 100 ms)
  beq.s   no_argument_MINS_SECS ;Wenn = NULL -> verzweige
  move.w  d1,rd_play_duration(a3) ;Sekundenwert retten
no_argument_MINS_SECS
; ** LMBEXIT-Argument abfragen **
  move.l  cra_LMBEXIT(a2),d0 ;Zeiger auf Langwort-Teilewert von Argument "LMBEXIT"
  beq.s   no_argument_LMBEXIT ;Wenn NULL -> verzweige
  tst.w   rd_play_duration(a3) ;Wurde eine Spieldauer angegeben ?
  beq     check_cmd_line_error ;Nein -> verzweige
  move.l  d0,a0              ;Zeiger 
  move.l  (a0),d0            ;Anzahl der Demoteile 
  beq     check_cmd_line_error ;Wenn NULL -> verzweige
  cmp.w   #2,d0              ;Anzahl < 2 ?
  blt     check_cmd_line_error ;Ja -> verzweige
  cmp.w   #10,d0             ;Anzahl > 10 ?
  bgt     check_cmd_line_error ;Ja -> verzweige
  subq.w  #1,d0              ;Wert anpassen, da intern 1...9 übergeben wird
  add.w   d0,rd_play_duration(a3) ;und zu Sekundenwert dazuaddieren
no_argument_LMBEXIT
; ** PRERUNSCRIPT-Argument abfragen **
  move.l  cra_PRERUNSCRIPT(a2),d0 ;Zeiger auf Dateiname des Prerunscript von Argument "PRERUNSCRIPT"
  beq.s   no_argument_PRERUNSCRIPT ;Wenn NULL -> verzweige
  move.l  d0,rd_prerunscript_path(a3) 
  move.l  d0,a0              ;Zeiger auf Dateiname
  moveq   #0,d0           ;Zähler für Anzahl Zeichen
check_prerunscript_name_length_loop
  addq.b  #1,d0              ;Zähler erhöhen
  cmp.b   #prerunscript_path_length-1,d0 ;Maximale Länge erreicht ?
  bge.s   rd_prerunscript_path_error ;Ja -> verzweige
  tst.b   (a0)+              ;Nullbyte ?
  bne.s   check_prerunscript_name_length_loop ;Nein -> verzweige
  move.w  d3,rd_prerunscript_active(a3) ;TRUE = Prerunscript vorhanden
no_argument_PRERUNSCRIPT
; ** SHOWENTRIES-Argument abfragen **
  tst.l   cra_SHOWENTRIES(a2) ;Boolean-Wert für Argument "SHOWENTRIES" gesetzt ?
  beq.s   no_argument_SHOWENTRIES ;Wenn NULL -> verzweige
  move.w  d3,rd_show_entries_active(a3) ;TRUE = Inhalt der Playback Queue anzeigen
no_argument_SHOWENTRIES
; ** PLAYENTRY-Argument abfragen **
  move.l  cra_PLAYENTRY(a2),d0 ;Zeiger auf Zahlenwert von Argument "PLAYENTRY"
  beq.s   no_argument_PLAYENTRY ;Wenn NULL -> verzweige
  move.l  d0,a0              ;Zeiger 
  move.l  (a0),d0            ;Zahlenwert 
  beq.s   check_cmd_line_error ;Wenn NULL -> verzweige
  cmp.w   entries_num(a3),d0 ;Wert > Maximum an Dateien ?
  bgt.s   check_cmd_line_error ;Ja -> verzweige
  move.w  d0,rd_play_entry_offset(a3) 
no_argument_PLAYENTRY
; ** RANDOM-Argument abfragen **
  tst.l   cra_RANDOM(a2)     ;Boolean-Wert für Argument "RANDOM" gesetzt ?
  beq.s   no_argument_RANDOM ;Wenn NULL -> verzweige
  move.w  d3,rd_random_play_active(a3) ;TRUE = Zufällige Offsets im Dateipfade-Puffer
no_argument_RANDOM
; ** ENDLESS-Argument abfragen **
  tst.l   cra_ENDLESS(a2)    ;Boolean-Wert für Argument "ENDLESS" gesetzt ?
  beq.s   no_argument_ENDLESS ;Wenn NULL -> verzweige
  move.w  d3,rd_endless_play_active(a3) ;TRUE = Endlosschleife im Dateipfade-Puffer
no_argument_ENDLESS
; ** LOOP-Argument abfragen **
  tst.l   cra_LOOP(a2)       ;Boolean-Wert für Argument "LOOP" gesetzt ?
  beq.s   no_argument_LOOP   ;Wenn NULL -> verzweige
  move.w  d3,rd_loop_play_active(a3) ;TRUE = Keine Rückkehr zur Shell
no_argument_LOOP
; ** NOFADER-Argument abfragen **
  tst.l   cra_NOFADER(a2)    ;Boolean-Wert für Argument "NOFADER" gesetzt ?
  beq.s   no_argument_NOFADER ;Wenn NULL -> verzweige
  move.w  d3,rd_nofader_active(a3) ;TRUE = Fader aus
no_argument_NOFADER
; ** SOFTRESET-Argument abfragen **
  tst.l   cra_SOFTRESET(a2)  ;Boolean-Wert für Argument "SOFTRESET" gesetzt ?
  beq.s   no_argument_SOFTRESET ;Wenn NULL -> verzweige
  tst.w   rd_loop_play_active(a3) ;Schleife an ?
  beq.s   no_argument_SOFTRESET ;Ja -> verzweige
  moveq   #RETURN_WARN,d0
  cmp.l   DOS_return_code(a3),d0 ;Returncode = 5 ?
  beq.s   no_argument_SOFTRESET ;Ja -> verzweige
  clr.w   rd_reset_active(a3) ;TRUE = Reset nach Demoende
no_argument_SOFTRESET
  tst.w   ds_reset_prg_active(a3) ;Reset-Prg bereits installiert?
  bne.s   print_help_message ;Nein -> verzweige
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
rd_prerunscript_path_error
  lea     rd_error_text1(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text1_end-rd_error_text1,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  #ERROR_INVALID_COMPONENT_NAME,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts
  CNOP 0,4
check_cmd_line_error
  lea     cmd_usage_text(pc),a0 ;Zeiger auf Text
  move.l  #cmd_usage_text_end-cmd_usage_text,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts
  CNOP 0,4
print_help_message
  tst.w   rd_reset_active(a3) ;Reset ausführen ?
  beq.s   no_print_help_message ;Ja -> verzweige
  lea     help_message(pc),a0 ;Zeiger auf Text
  moveq   #help_message_end-help_message,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
no_print_help_message
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts

; ** Genauere Fehlercodebschreibung ausgeben **
  CNOP 0,4
print_io_error
  move.l  DOS_return_code(a3),d1 ;Fehlercode
  moveq   #ERROR_NO_FREE_STORE,d0
  cmp.l   d0,d1              ;Fehlercode < 103 ?
  blt.s   no_print_io_error  ;Ja -> verzweige
  lea     error_header(pc),a0 ;Header für Fehlermeldung
  move.l  a0,d2
  CALLDOSQ PrintFault
  CNOP 0,4
no_print_io_error
  rts

; ** RDArgs-Struktur wieder freigeben **
  CNOP 0,4
free_RDArgs_structure
  move.l  RDArgs_structure(a3),d1 ;Zeiger auf RDArgs-Struktur
  beq.s   no_free_RDArgs_structure ;Wenn NULL -> verzweige
  CALLDOSQ FreeArgs          ;Speicher freigeben
  CNOP 0,4
no_free_RDArgs_structure
  rts

; ** Intuition-Libary schließen **
  CNOP 0,4
close_intuition_lib
  move.l  _IntuitionBase(pc),a1 ;Zeiger auf Intuition-Base -> a1
  CALLEXECQ CloseLibrary     ;Intuition-Library schließen

; ** Graphics-Library schließen **
  CNOP 0,4
close_gfx_lib
  move.l  _GfxBase(pc),a1    ;Zeiger auf GFX-Base -> a1
  CALLEXECQ CloseLibrary     ;Graphics-Library schließen

; ** DOS-Libary schließen **
  CNOP 0,4
close_dos_lib
  move.l  _DOSBase(pc),a1    ;Zeiger auf DOS-Base -> a1
  CALLEXECQ CloseLibrary     ;DOS-Library schließen

; ** WB-Message ggf. noch beantworten **
  IFEQ workbench_start_enabled
  CNOP 0,4
reply_WB_msg
    move.l  WB_msg(a3),d2      ;Message 
    bne.s   WB_msg_ok          ;Wenn WB-Message <> Null -> verzweige
    rts
    CNOP 0,4
WB_msg_ok
    CALLEXEC Forbid            ;Multitasking aus
    move.l  d2,a1
    CALLLIBS ReplyMsg          ;und zurückgeben
    CALLLIBQ Permit            ;Multitasking an
  ENDC

; ** Text ausgeben **
; a0 ... Zeiger auf Fehlertext
; d0 ... Länge des Textes
  CNOP 0,4
print_text
  movem.l d0/a0,-(a7)        ;Zeiger auf Text und Länge retten
  IFEQ workbench_start_enabled
    tst.l   WB_msg(a3)         ;Start von der Workbench ?
    beq.s   CLI_start          ;Nein -> verzweige
    lea     wb_output_window(pc),a0
    move.l  a0,d1              ;Passives CON: öffnen
    move.l  #MODE_OLDFILE,d2   ;Modus Lesen
    CALLDOS Open
    tst.l   d0
    beq.s   output_open_error  ;Wenn NULL -> verzweige
    bra.s   output_opened
    CNOP 0,4
CLI_start
  ENDC
  CALLDOS Output             ;Ausgabemedium ermitteln
  tst.l   d0
  beq.s   output_open_error  ;Wenn NULL -> verzweige
output_opened
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


; ** DemoSelector **

; ** Puffer für Dateipfade belegen **
  CNOP 0,4
ds_alloc_entries_buffer
  tst.w   ds_reset_prg_active(a3) ;Reset-Programm bereits installiert ?
  beq.s   ds_no_alloc_entries_buffer ;Ja -> verzweige
  moveq   #0,d0           ;Wichtig
  move.w  entries_num_max(a3),d0 ;Maximale Anzahl der Einträge in Liste mit Dateipfaden
  MULUF.W playback_queue_entry_size,d0,d1 ;*Größe des Eintrags = Größe des Puffers
  move.l  #MEMF_CLEAR+MEMF_PUBLIC+MEMF_ANY,d1 ;Memory-Request
  CALLEXEC AllocMem
  move.l  d0,entries_buffer(a3) ;Zeiger auf Speicherbereich retten
  beq.s   ds_alloc_entries_buffer_error ;Wenn NULL -> verzweige
ds_no_alloc_entries_buffer
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
ds_alloc_entries_buffer_error
  lea     ds_error_text2(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text2_end-ds_error_text2,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Datei-Lock der Playlist-Datei ermitteln **
  CNOP 0,4
ds_lock_playlist_file
  move.l  ds_playlist_filename(a3),d1 ;Zeiger auf Dateinamen der Playlist
  moveq   #ACCESS_READ,d2    ;Lesen
  CALLDOS Lock               
  move.l  d0,ds_playlist_file_lock(a3) ;Datei-Lock der Playlist retten
  beq.s   ds_lock_playlist_file_error ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_lock_playlist_file_error
  CALLLIBS IoErr
  move.l  d0,DOS_return_code(a3)
  lea     ds_error_text3(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text3_end-ds_error_text3,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Speicher für FileInfoBlock-Struktur belegen **
  CNOP 0,4
ds_alloc_FileInfoBlock_structure
  MOVEF.L fib_sizeOF,d0      ;Größe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_PUBLIC+MEMF_ANY,d1 ;Attribute
  CALLEXEC AllocMem
  move.l  d0,ds_FileInfoBlock_structure(a3) 
  beq.s   ds_alloc_FileInfoBlock_structure_error ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_alloc_FileInfoBlock_structure_error
  lea     ds_error_text4(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text4_end-ds_error_text4,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Länge der Playlist-Datei ermitteln **
  CNOP 0,4
ds_get_playlist_file_length
  move.l  ds_FileInfoBlock_structure(a3),d2 ;Zeiger auf FileInfBlock-Struktur
  move.l  d2,a2              
  move.l  ds_playlist_file_lock(a3),d1 ;Datei-Lock der Playlist
  CALLDOS Examine
  tst.l   d0                 
  beq.s   playlist_file_examine_error ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  move.l  fib_Size(a2),ds_playlist_file_length(a3) ;Länge der Playlist in Bytes 
  rts
  CNOP 0,4
playlist_file_examine_error
  lea     ds_error_text5(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text5_end-ds_error_text5,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Speicher für Playlist-Datei belegen **
  CNOP 0,4
ds_alloc_playlist_file_mem
  move.l  ds_playlist_file_length(a3),d0 ;Größe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_PUBLIC+MEMF_ANY,d1 ;Attribute
  CALLEXEC AllocMem
  move.l  d0,ds_playlist_file_memory(a3) 
  beq.s   ds_alloc_playlist_file_mem_error ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_alloc_playlist_file_mem_error
  lea     ds_error_text6(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text6_end-ds_error_text6,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Playlist-Datei öffnen **
  CNOP 0,4
ds_open_playlist_file
  move.l  ds_playlist_filename(a3),d1 ;Zeiger auf Dateiname
  move.l  #MODE_OLDFILE,d2   ;Modues: Lesen
  CALLDOS Open
  move.l  d0,ds_playlist_file_handle(a3) ;Datei-Handle retten
  beq.s   ds_open_playlist_file_error ;Wenn NULL -> Fehler
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_open_playlist_file_error
  CALLLIBS IoErr
  move.l  d0,DOS_return_code(a3) ;Fehlercode retten
  lea     ds_error_text7(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text7_end-ds_error_text7,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Playlist-Datei auslesen **
  CNOP 0,4
ds_read_playlist_file
  move.l  ds_playlist_file_handle(a3),d1 ;Datei-Handle der Playlist
  move.l  ds_playlist_file_length(a3),d3 ;Länge der Playlist-Datei
  move.l  ds_playlist_file_memory(a3),d2 ;Speicherbereich der Playlist-Datei
  CALLLIBS Read
  tst.l   d0                 ;Fehler ?
  bmi.s   ds_read_playlist_file_error ;Ja -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_read_playlist_file_error
  CALLLIBS IoErr
  move.l  d0,DOS_return_code(a3) ;Fehlercode retten
  lea     ds_error_text8(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text8_end-ds_error_text8,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Playlist-Einträge nach Argumenten durchsuchen **
  CNOP 0,4
ds_parse_playlist_file
  lea     ds_message_text(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_message_text_end-ds_message_text,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  entries_buffer(a3),a0 ;Zeiger auf Dateipfade-Puffer
  moveq   #10,d5             ;Line-Feed
  move.w  entries_num(a3),d0 ;Aktuelles Offset in Puffer ermitteln
  MULUF.W (playback_queue_entry_size)/8,d0,d1 ;*Größe des Eintrags
  move.l  ds_playlist_file_memory(a3),a2 ;Zeiger auf Daten aus der Playlist-Datei
  lea     (a0,d0.w*8),a0     ;Zeiger auf aktuellen kompletten Pfadnamen
  move.l  a0,d6              
  move.w  ds_playlist_file_length+2(a3),d7 ;Länge der Playlist-Datei in Bytes
ds_parse_playlist_file_return
  subq.w  #1,d7              ;-1 wegen dbf
  bmi.s   ds_print_playlist_end_message ;Wenn negativ -> verzweige
  addq.w  #1,ds_playlist_entries_num(a3) ;Anzahl der Einträge in Playlist zählen
  move.l  #DOS_RDARGS,d1     ;ReadArgs-Struktur erzeugen
  moveq   #TRUE,d2           ;Keine Tags
  CALLLIBS AllocDosObject
  move.l  d0,ds_own_RDArgs_structure(a3) ;Zeiger auf RDArgs-Struktur retten
  beq     ds_alloc_own_RDArgs_structure_error ;Wenn NULL -> verzweige
  move.l  d0,a4              ;Zeiger auf RDArgs-Struktur
  moveq   #TRUE,d4           ;Zähler für Länge einer Befehlszeile zurücksetzen
  move.l  a2,CS_Buffer(a4)   ;Zeiger auf Befehlszeile in RDArgs-Struktur eintragen
ds_parse_playlist_file_loop
  addq.w  #1,d4              ;Zähler für Länge einer Befehlszeile erhöhen
  cmp.b   (a2)+,d5           ;Line-Feed gefunden ?
  beq.s   ds_line_feed_found ;Ja -> verzweige
  dbf     d7,ds_parse_playlist_file_loop
ds_print_playlist_end_message
  lea     ds_playlist_succ_entries_num_value(pc),a0 ;Zeiger auf String
  move.w  ds_playlist_succ_entries_num(a3),d1 ;Dezimalzahl
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  lea     ds_playlist_entries_num_value(pc),a0 ;Zeiger auf String
  move.w  ds_playlist_entries_num(a3),d1 ;Dezimalzahl
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  move.w  entries_num_max(a3),d1 ;Maximale Anzahl der Einträge in Liste mit Dateipfaden
  lea     ds_not_used_entries_num_value(pc),a0 ;Stringadresse
  sub.w   entries_num(a3),d1 ;Verbleibende Anzahl der zu ladenden Dateien ermitteln
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  lea     ds_message_text2(pc),a0 ;Zeiger auf Fehlertext
  move.l  #ds_message_text2_end-ds_message_text2,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #TRUE,d0           ;Returncode = OK
  rts
; ** Befehlszeile in der Playlist-Datei untersuchen **
  CNOP 0,4
ds_line_feed_found
  move.l  d4,CS_Length(a4)   ;Länge der Befelszeile in ReadArgs-Struktur eintragen
  lea     ds_playlist_results_array_structure(pc),a5
  moveq   #0,d0
  move.l  d0,ds_pra_demofile(a5) ;Alle Arrays der Argumente löschen
  move.l  d0,ds_pra_OCS(a5)
  move.l  d0,ds_pra_AGA(a5)
  move.l  d0,ds_pra_FAST(a5)
  lea     ds_playlist_template(pc),a0
  move.l  d0,ds_pra_MINS(a5)
  move.l  a0,d1              ;Zeiger auf Befelsschablone für die Playlist-Argumente
  move.l  d0,ds_pra_SECS(a5)
  move.l  a5,d2              ;Zeiger auf Ergebnis-Felder für die Playlist-Argumente
  move.l  d0,ds_pra_LMBEXIT(a5)
  move.l  a4,d3              ;Eigene RDArgs-Struktur
  move.l  d0,ds_pra_prerunscript(a5)
  CALLLIBS ReadArgs
  tst.l   d0
  beq     ds_syntax_error    ;Wenn NULL -> verzweige
  move.l  d6,a0              ;Zeiger auf Eintrag
  bsr     ds_clear_entries_buffer_entry
; ** Startmode-Argument abfragen **
  move.l  d6,a1              ;Zeiger auf Dateipfade-Puffer
  moveq   #FALSE,d4          ;FALSE = Kein Startmodus wurde angegeben
; ** OCS-Argument abfragen **
  tst.l   ds_pra_OCS(a5)     ;Boolean für Argument "OCS" gesetzt ?
  beq.s   ds_no_argument_OCS ;Nein -> verzweige
  moveq   #OCS,d0
  move.b  d0,pqe_startmode(a1) ;Startmode $01 = "OCS" eintragen
  moveq   #TRUE,d4           ;TRUE = Startmodus wurde angegeben
  bra.s   ds_no_argument_FAST
  CNOP 0,4
ds_no_argument_OCS
; ** AGA-Argument abfragen **
  tst.l   ds_pra_AGA(a5)     ;Boolean für Argument "AGA" gesetzt ?
  beq.s   ds_no_argument_AGA ;Nein -> verzweige
  moveq   #AGA,d0
  move.b  d0,pqe_startmode(a1) ;Startmode $02 = "AGA" eintragen
  moveq   #TRUE,d4          ;TRUE = Startmodus wurde angegeben
  bra.s   ds_no_argument_FAST
  CNOP 0,4
ds_no_argument_AGA
; ** FAST-Argument abfragen **
  tst.l   ds_pra_FAST(a5)    ;Boolean für Argument "FAST" gesetzt ?
  beq.s   ds_no_argument_FAST ;Nein -> verzweige
  clr.b   pqe_startmode(a1)  ;Startmode $00 = "FAST" eintragen
  moveq   #TRUE,d4           ;TRUE = Startmodus wurde angegeben
ds_no_argument_FAST
  tst.w   d4                 ;Wurde Startmodus angegeben ?
  bne     ds_syntax_error2   ;FALSE -> verzweige
; ** MIN[S]/SEC[S]-Agrument abfragen **
  move.l  ds_pra_SECS(a5),d0 ;Zeiger auf Langwort-Dezimalwert Sekunden von Argument "SEC[S]"
  beq.s   ds_no_argument_SECS ;Wenn NULL -> verzweige
  move.l  d0,a0              ;Zeiger 
  move.l  (a0),d0            ;Sekundenwert 
  moveq   #59,d2
  cmp.l   d2,d0              ;Wert > 59 ?
  bgt     ds_syntax_error2   ;Ja -> verzweige
ds_no_argument_SECS
  move.l  ds_pra_MINS(a5),d1 ;Zeiger auf Langwort-Dezimalwert Minuten von Argument "MIN[S]"
  beq.s   ds_no_argument_MINS ;Wenn NULL -> verzweige
  move.l  d1,a0              ;Zeiger = NULL ?
  move.l  (a0),d1            ;Minutenwert 
  moveq   #99,d2
  cmp.l   d2,d1              ;Wert > 99 ?
  bgt     ds_syntax_error2   ;Ja -> verzweige
ds_skip_secs_check
  MULUF.W 60,d1,d2           ;*60 = Sekundenwert
ds_no_argument_MINS
  add.l   d0,d1              ;+ Sekundenwert = Gesamtwert Sekunden
  MULUF.L 10,d1,d0           ;*10 = Zählerwert (in 100 ms)
  beq.s   ds_no_argument_MINS_SECS ;Wenn = NULL -> verzweige
  move.w  d1,pqe_playtime(a1) ;Sekundenwert eintragen
ds_no_argument_MINS_SECS
; ** LMBEXIT-Argument abfragen **
  move.l  ds_pra_LMBEXIT(a5),d0 ;Zeiger auf Langwort-Teilewert von Argument "LMBEXIT"
  beq.s   ds_no_argument_LMBEXIT ;Wenn NULL -> verzweige
  tst.w   pqe_playtime(a1)   ;Wurde eine Spieldauer angegeben ?
  beq     ds_syntax_error2   ;Nein -> verzweige
  move.l  d0,a0              ;Zeiger 
  move.l  (a0),d0            ;Anzahl der Demoteile 
  beq     ds_syntax_error2   ;Wenn NULL -> verzweige
  cmp.w   #2,d0              ;Anzahl < 2 ?
  blt     ds_syntax_error2   ;Ja -> verzweige
  cmp.w   #10,d0             ;Anzahl > 10 ?
  bgt     ds_syntax_error2   ;Ja -> verzweige
  subq.w  #1,d0              ;Wert anpassen, da intern 1...9 übergeben wird
  add.w   d0,pqe_playtime(a1) ;und zu Sekundenwert dazuaddieren
ds_no_argument_LMBEXIT
; ** demofilename-Argument abfragen **
  move.l  ds_pra_demofile(a5),d0 ;Zeiger auf Dateiname des Demos von Argument "demofilename"
  beq.s   ds_syntax_error2   ;Wenn NULL -> verzweige
  move.l  d0,a0              ;Zeiger auf Dateiname des Demos
; ** Dateipfad in Dateipade-Puffer kopieren **
  moveq   #0,d0           ;Zähler zurücksetzen
ds_copy_demofile_pathloop
  addq.b  #1,d0              ;Zähler erhöhen
  cmp.b   #demofile_path_length-1,d0 ;Maximale Länge des Dateipfads erreicht ?
  bge.s   ds_syntax_error2   ;Ja -> verzweige
  move.b  (a0)+,(a1)+        ;1 Byte kopieren, bis NULL-Byte gefunden
  bne.s   ds_copy_demofile_pathloop ;Wenn <> NULL -> verzweige
; ** prerunscript-Argument abfragen **
  move.l  ds_pra_prerunscript(a5),d0 ;Zeiger auf Dateiname des Scriptfiles 
  beq.s   ds_no_argument_prerunscript ;Ja -> verzweige
  move.l  d0,a0              ;Zeiger auf Dateiname des Scriptfiles
; ** Prerunscriptpfad in Dateipade-Puffer kopieren **
  move.l  d6,a1
  moveq   #0,d0           ;Zähler zurücksetzen
  ADDF.W  pqe_prerunscript_path,a1 ;Zeiger auf Prerunscript-Pfad in Dateipfade-Puffer
ds_copy_prerunscript_pathloop
  addq.b  #1,d0              ;Zähler erhöhen
  cmp.b   #prerunscript_path_length-1,d0 ;Maximale Länge erreicht ?
  bge.s   ds_syntax_error2   ;Ja -> verzweige
  move.b  (a0)+,(a1)+        ;1 Byte kopieren, bis NULL-Byte gefunden
  bne.s   ds_copy_prerunscript_pathloop ;Wenn <> NULL -> verzweige
ds_no_argument_prerunscript
  addq.w  #1,ds_playlist_succ_entries_num(a3) ;Zähler für erfolgreich transferierte Einträge hochsetzen
  move.w  entries_num_max(a3),d0 ;Maximale Einträge in Dateipfade-Puffer 
  addq.w  #1,entries_num(a3) ;Anzahl der Einträge in Dateipfade-Puffer erhöhen
  cmp.w   entries_num(a3),d0 ;Maximale Anzahl an Einträgen bereits erreicht ?
  bne     ds_next_playlist_cmd_line ;Nein -> verzweige
  bsr     ds_print_playlist_end_message
  bra     ds_maximum_entries_reached
  CNOP 0,4
ds_next_playlist_cmd_line
  add.l   #playback_queue_entry_size,d6 ;Offset in Dateipfade-Puffer erhöhen = nächster Eintrag
ds_free_own_RDArgs_structure
  move.l  a4,d1              ;Zeiger auf RDArgs-Struktur
  CALLLIBS FreeArgs          ;Speicher freigeben
ds_free_DosObject_structure
  moveq   #DOS_RDARGS,d1     ;ReadArgs-Struktur freigeben
  move.l  a4,d2              ;Zeiger auf ReadArgs-Struktur
  CALLLIBS FreeDosObject
  bra     ds_parse_playlist_file_return
  CNOP 0,4
ds_alloc_own_RDArgs_structure_error
  lea     ds_error_text9(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text9_end-ds_error_text9,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts
  CNOP 0,4
ds_syntax_error
  bsr.s   ds_print_playlist_error_message
  bra.s   ds_free_DosObject_structure
  CNOP 0,4
ds_syntax_error2
  move.l  d6,a0              ;Zeiger auf Eintrag
  bsr.s   ds_clear_entries_buffer_entry
  bsr.s   ds_print_playlist_error_message
  bra.s   ds_free_own_RDArgs_structure
; a0 ... Zeiger auf den Eintrag zum Löschen
  CNOP 0,4
ds_clear_entries_buffer_entry
  moveq   #0,d0
  moveq   #((playback_queue_entry_size)/4)-1,d3 ;Länge des Eintrags in Langworten
ds_clear_entry_loop
  move.l  d0,(a0)+           ;1 Langwort löschen
  dbf     d3,ds_clear_entry_loop
  rts
  CNOP 0,4
ds_print_playlist_error_message
  move.w  d7,d4              
  lea     ds_entries_num_value(pc),a0 ;Zeiger auf String
  move.w  ds_playlist_entries_num(a3),d1 ;Dezimalzahl
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  move.w  d4,d7              ;Schleifenzähler wieder herstellen
  lea     ds_error_text10(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text10_end-ds_error_text10,d0 ;Textlänge
  bra     print_text         ;Text ausgeben

; ** ASL-Library öffnen **
  CNOP 0,4
ds_open_asl_lib
  lea     asl_name(pc),a1    ;Name der ASL-Library
  moveq   #OS_Version,d0     ;Version 2.04+
  CALLEXEC OpenLibrary       ;Graphics-Library öffnen
  lea     _ASLBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf ASL-Base retten
  beq.s   ds_asl_lib_error   ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_asl_lib_error
  lea     ds_error_text11(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text11_end-ds_error_text11,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Programmverzeichnis in Erfahrung bringen **
  CNOP 0,4
ds_get_program_dir
  CALLDOS GetProgramDir
  tst.l   d0
  beq.s   ds_get_program_dir_error ;Wenn Fehler -> verzweige
  move.l  d0,d1              ;Verzeichnis-Lock retten
  move.l  a5,d2              ;Zeiger auf Puffer für Verzeichnisname
  move.l  #ds_current_drawer_name_end-ds_current_drawer_name,d3 ;Länge
  CALLLIBS NameFromLock
  tst.l   d0
  beq.s   ds_get_program_dir_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_get_program_dir_error
  lea     ds_error_text12(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text12_end-ds_error_text12,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Rückgabewert = FALSE
  rts

; ** Zahlenwert in ASCII-Wert umwandeln **
  CNOP 0,4
ds_files_num_to_ascii
  move.w  entries_num_max(a3),d1 ;Maximale Anzahl der Einträge in Liste mit Dateipfaden
  lea     ds_files_num_value(pc),a0 ;Stringadresse
  sub.w   entries_num(a3),d1 ;Verbleibende Anzahl der zu ladenden Dateien ermitteln
  cmp.w   #1,d1              ;Nur noch ein File?
  bne.s   ds_no_change_req_title ;Nein -> verzweige
  clr.b   ds_character_s-ds_files_num_value(a0) ;"s" von Demos löschen
ds_no_change_req_title
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bra     rp_dec_to_ascii

; ** File-Requester anlegen **
  CNOP 0,4
ds_init_file_requester
  moveq   #ASL_FileRequest,d0 ;Type = FileRequester
  lea     ds_file_requester_taglist(pc),a0 ;Tag-Liste für Aufbau FileRequest
  tst.w   rd_reset_active(a3) ;Soll ein Reset ausgeführt werden ?
  bne.s   ds_no_reboot_text  ;Nein -> verzweige
  lea     ds_file_req_cancel_text2(pc),a1 ;Zeiger auf Text "Reboot"
  move.l  a1,(ti_sizeOF*3)+4(a0) ;Zeiger auf negativen Text eintragen
ds_no_reboot_text
  CALLASL AllocAslRequest    ;FileRequest-Struktur initialisieren
  move.l  d0,ds_file_requester(a3) ;Adresse retten
  beq.s   ds_file_requester_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
ds_file_requester_error
  lea     ds_error_text13(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text13_end-ds_error_text13,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** FileRequest darstellen **
  CNOP 0,4
ds_display_file_requester
  move.l  ds_file_requester(a3),a0 ;Zeiger auf FileRequester-Struktur
  lea     ds_file_requester_use_taglist(pc),a1 ;Tag-Liste für FileRequester
  CALLASL AslRequest
  tst.l   d0                 ;Rückgabewert = Null ?
  beq.s   ds_display_file_requester_error ;Ja -> verzweige
  moveq   #0,d0           ;Rückgabewert = OK
  rts
  CNOP 0,4
ds_display_file_requester_error
  moveq   #FALSE,d0          ;Rückgabewert = FALSE
  rts
    
; ** Dateipfad herausfinden **
  CNOP 0,4
ds_get_demo_filepath
  clr.w   ds_entries_multiselect_num(a3) ;Zurücksetzen
  move.l  ds_file_requester(a3),a2 ;Zeiger auf FileRequester-Struktur
  move.l  fr_NumArgs(a2),d6  ;Wurden mehrere Dateien auf einmal ausgewählt?
  beq.s   ds_no_multiselect  ;Nein -> verzweige
  move.w  d6,d0              ;Anzahl retten
  add.w   entries_num(a3),d0 ;+ ggf. bereits ausgewählte Dateien
  cmp.w   entries_num_max(a3),d0 ;Maximale Anzahl der Einträge erreicht?
  blt.s   ds_entries_num_okay ;Wenn kleiner, dann verzweige
  move.w  entries_num_max(a3),d6 ;Ansonsten maximalen Wert setzen
  sub.w   entries_num(a3),d6 ;und Anzahl der bereits ausgewählten abziehen
ds_entries_num_okay
  move.w  d6,ds_entries_multiselect_num(a3) 
  moveq   #TRUE,d5           ;Erster Eintrag in ArgLists
  move.l  fr_ArgList(a2),a6  ;Zeiger auf ArgLists
  subq.w  #1,d6              ;-1 wegen dbf
ds_multiselect_loop
  move.l  wa_Name(a6,d5.w*8),a0 ;Zeiger auf Dateiname 
  move.l  fr_Drawer(a2),a1   ;Zeiger auf Verzeichnisname 
  move.l  a2,-(a7)
  bsr.s   ds_check_demo_filepath
  move.l  (a7)+,a2
  tst.w   d0                 ;Ist ein Fehler aufgetreten ?
  bne.s   ds_multiselect_end ;Ja -> verzweige
  addq.w  #1,d5              ;nächster Eintrag in ArgLists
  dbf     d6,ds_multiselect_loop
ds_multiselect_end
  rts
  CNOP 0,4
ds_no_multiselect
  move.l  fr_File(a2),a0     ;Zeiger auf Dateiname 
  move.l  fr_Drawer(a2),a1   ;Zeiger auf Verzeichnisname 
ds_check_demo_filepath
  tst.b   (a1)               ;Dateipfad vorhanden?
  beq.s   ds_get_demo_filepath_error1 ;Wenn NULL -> verzweige
  tst.b   (a0)               ;Dateipfad vorhanden?
  beq     ds_get_demo_filepath_error2 ;Wenn NULL -> verzweige
  move.w  entries_num(a3),d0 ;Aktuelles Offset in Puffer ermitteln
  MULUF.W (playback_queue_entry_size)/8,d0,d1 ;*Größe des Eintrags
  move.l  entries_buffer(a3),a2 ;Zeiger auf Puffer für kompletten Pfadnamen
  lea     (a2,d0.w*8),a2     ;Zeiger auf aktuellen kompletten Pfadnamen
  move.l  a2,ds_current_pathname(a3) 
  move.l  a0,d1              ;Zeiger auf Dateiname retten
  move.l  a2,a0              ;Zeiger auf Eintrag
  bsr     ds_clear_entries_buffer_entry
  move.l  d1,a0              ;Zeiger auf Dateiname 
  moveq   #"/",d2
  moveq   #":",d3
ds_check_demo_drawername
  tst.b   (a1)               ;Ende von Verzeichnisname?
  beq.s   ds_copy_demo_filename ;Wenn ja -> Dateiname kopieren
  cmp.b   (a1),d2            ;Bei "/" auch Dateiname kopieren
  bne.s   ds_copy_demo_drawername ;Sonst Verzeichnisname kopieren
  addq.w  #1,a1              ;Nächstes Zeichen im Verzeichnisnamen
  bra.s   ds_check_demo_drawername
  CNOP 0,4
ds_copy_demo_drawername
  move.l  a5,a4              ;Zeiger auf Puffer für aktuellen Verzeichnisnamen
  moveq   #0,d0           ;Zähler zurücksetzen
ds_copy_demo_drawername_loop
  addq.b  #1,d0              ;Zähler erhöhen
  cmp.b   #demofile_path_length-1,d0 ;Maximale Länge des Dateipfads erreicht ?
  bge.s   ds_get_demo_filepath_error3 ;Ja -> verzweige
  move.b  (a1),(a2)+         ;Ein Zeichen kopieren
  move.b  (a1)+,(a4)+
  tst.b   (a1)               ;Ende von Verzeichnisname?
  bne.s   ds_copy_demo_drawername_loop ;Wenn nicht -> Schleife
  clr.b   (a4)               ;Ende des Verzeichnisnamens setzen
  cmp.b   -1(a1),d3          ;War letztes Zeichen ein ":" ?
  beq.s   ds_copy_demo_filename ;Ja -> Dateiname kopieren
  cmp.b   -1(a1),d2          ;War letztes Zeichen ein "/" ?
  beq.s   ds_copy_demo_filename ;Ja -> Dateiname kopieren
  move.b  d2,(a2)+           ;Sonst "/" einfügen
ds_copy_demo_filename
  addq.b  #1,d0              ;Zähler erhöhen
  cmp.b   #demofile_path_length-1,d0 ;Maximale Länge des Dateipfads erreicht ?
  bge.s   ds_get_demo_filepath_error3 ;Ja -> verzweige
  move.b  (a0)+,(a2)+        ;Ein Zeichen kopieren
  cmp.b   (a0),d2            ;Nächstes Zeiche ein "/" ?
  beq.s   ds_get_demo_filepath_error2 ;Ja -> verzweige
  tst.b   (a0)               ;Ende von Dateiname ?
  bne.s   ds_copy_demo_filename ;Wenn nicht -> Schleife
  clr.b   (a2)               ;Ende des kompletten Pfadnamens setzen
ds_demo_filepath_ok
  addq.w  #1,entries_num(a3) ;Anzahl der Dateipfade erhöhen
  moveq   #0,d0           ;Rückgabewert = OK
  rts
  CNOP 0,4
ds_get_demo_filepath_error1
  lea     ds_error_text14(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text14_end-ds_error_text14,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  #ERROR_DIR_NOT_FOUND,DOS_return_code(a3) ;Fehlercode setzen
  moveq   #FALSE,d0          ;Rückgabewert = FALSE
  rts
  CNOP 0,4
ds_get_demo_filepath_error2
  lea     ds_error_text15(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text15_end-ds_error_text15,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  #ERROR_OBJECT_NOT_FOUND,DOS_return_code(a3) ;Fehlercode setzen
  moveq   #FALSE,d0          ;Rückgabewert = FALSE
  rts
  CNOP 0,4
ds_get_demo_filepath_error3
  move.l  ds_current_pathname(a3),a0 ;Zeiger auf Eintrag
  bsr     ds_clear_entries_buffer_entry
  lea     ds_error_text16(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text16_end-ds_error_text16,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  #ERROR_INVALID_COMPONENT_NAME,DOS_return_code(a3) ;Fehlercode setzen
  moveq   #FALSE,d0          ;Rückgabewert = FALSE
  rts

; ** FileRequester-Struktur wieder freigeben **
  CNOP 0,4
ds_free_file_requester_structure
  move.l  ds_file_requester(a3),a0 ;Zeiger auf FileRequester-Struktur
  CALLASLQ FreeAslRequest

; ** Startmode-Requester darstellen **
  CNOP 0,4
ds_display_startmode_requester
  move.l  a3,a4              ;Inhalt von a3 retten
  sub.l   a0,a0              ;NULL = Requester erscheint auf Workbench
  lea     ds_startmode_req_structure(pc),a1 ;Zeiger auf Easy-Struktur
  move.l  a0,a2              ;NULL = Keine IDCMP-Flags
  move.l  a0,a3              ;NULL = Keine Argumentenliste
  CALLINT EasyRequestArgs    ;Requester darstellen
  move.l  a4,a3              ;Alter Inhalt von a3
  move.w  ds_entries_multiselect_num(a3),d7
  beq.s   ds_no_multiselect_files ;Wenn NULL verzweige
  subq.w  #1,d7              ;-1 wegen dbf
ds_no_multiselect_files
  move.l  ds_current_pathname(a3),a0 ;Zeiger auf aktuellen Pfadnamen
  MOVEF.W playback_queue_entry_size,d1 ;Größe des Eintrags
ds_start_loop
  move.b  d0,pqe_startmode(a0) ;Kennung "FAST"($00), "OCS"($01) oder "AGA"($02) eintragen
  sub.l   d1,a0              ;vorheriger Pfadname
  dbf     d7,ds_start_loop
  rts

; ** Resetfestes Programm installieren **
  CNOP 0,4
ds_init_reset_prg
; ** Speicher für resetfestes Programm reservieren **
  move.l  #rp_reset_prg_end-rp_reset_prg,d0 ;Programmlänge
  move.w  d0,d7              
  moveq   #TRUE,d1           ;Muss sein!
  move.w  entries_num_max(a3),d1 ;Maximale Anzahl der Einträge in Liste mit Pfadnamen
  MULUF.W playback_queue_entry_size,d1,d2 ;* Größe des Eintrags
  add.l   d1,d0              ;+ Länge des Puffers für die Dateipfade
  lea     rp_reset_prg_size(pc),a0
  move.l  d0,(a0)            ;Gesamtlänge des Reset-Programms retten
  move.l  #MEMF_PUBLIC+MEMF_CHIP+MEMF_CLEAR+MEMF_REVERSE,d1 ;Anforderungen
  CALLEXEC AllocMem          ;Speicher reservieren
  lea     rp_reset_prg_mem(pc),a0
  move.l  d0,(a0)            ;Zeiger auf Speicherbereich retten
  beq.s   ds_init_reset_prg_error ;Wenn Fehler -> verzweige
; ** Programmcode des Reset-Programms in Speicherbereich kopieren **
  lea     rp_reset_prg(pc),a0 ;Quelle
  move.l  d0,a1              ;Ziel
  move.l  d0,a2              
  move.l  d0,CoolCapture(a6) ;Zeiger auf CoolCapture-Programm eintragen
  subq.w  #1,d7              ;-1 wegen dbf = Anzahl der Bytes zum kopieren
ds_copy_reset_prg_loop
  move.b  (a0)+,(a1)+        ;1 Byte kopieren
  dbf     d7,ds_copy_reset_prg_loop
; ** Inhalt des Puffers für Dateipfade in Speicherbereich kopieren **
  move.w  entries_num_max(a3),d7 ;Maximale Anzahl der Einträge in Liste mit Pfadnamen
  MULUF.W playback_queue_entry_size,d7,d0 ;* Größe des Eintrags
  move.l  entries_buffer(a3),a0 ;Quelle
  subq.w  #1,d7              ;Anzahl der Bytes zum kopieren
ds_copy_entries_buffer_loop
  move.b  (a0)+,(a1)+        ;1 Byte kopieren
  dbf     d7,ds_copy_entries_buffer_loop
; ** LowMemChkSum in Execbase berechnen **
  moveq   #0,d0
  move.w  d0,LowMemChkSum(a6) ;Checksumme löschen
  lea     SoftVer(a6),a0     ;Start-Abschnitt in Execbase
  moveq   #24-1,d7           ;Anzahl Worte, über die Checksumme gebildet wird
ds_calculate_LowMemChkSum_loop
  add.w   (a0)+,d0
  dbf     d7,ds_calculate_LowMemChkSum_loop
  not.w   d0                 ;Negieren
  move.w  d0,(a0)            ;Neue Checksumme eintragen
ds_install_own_exception_vectors
  CALLLIBS CacheClearU       ;Caches flushen
  jsr     rp_install_own_exception_vectors-rp_reset_prg(a2) ;Zeiger auf eigene Exception/Trap-Routinen initialisieren
  lea     ds_read_VBR(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
  tst.l   d0                 ;VBR = $00000000 ?
  beq.s   ds_no_install_own_exception_vectors ;Ja -> verzweige
  RP_GET_OWN_TRAP_0_VECTOR   ;Zeiger auf Variable rp_own_trap0_vector  -> a0
  move.w  #TRAP_0_VECTOR,a1  ;Ab Trap0-Vektor im CHIP memory
  IFNE level_7_int_handler
    moveq   #7-1,d7            ;Anzahl der Trap-Vektoren
  ENDC
  IFEQ level_7_int_handler
    moveq   #8-1,d7            ;Anzahl der Trap-Vektoren
  ENDC
ds_copy_own_trap_vectors_loop
  move.l  (a0)+,(a1)+        ;Vektor kopieren
  dbf     d7,ds_copy_own_trap_vectors_loop
  CALLLIBS CacheClearU       ;Caches flushen
  moveq   #TRUE,d0           ;Returncode = OK
ds_no_install_own_exception_vectors
  rts
  CNOP 0,4
ds_init_reset_prg_error
  lea     ds_error_text17(pc),a0 ;Zeiger auf Fehlertext
  moveq   #ds_error_text17_end-ds_error_text17,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts
; d0 ... Rückgabewert Inhalt von VBR
  CNOP 0,4
ds_read_VBR
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  movec.l VBR,d0
  nop
  rte

; ** ASL-Libary schließen **
  CNOP 0,4
ds_close_asl_lib
  move.l  _ASLBase(pc),a1    ;Zeiger auf ASL-Base -> a1
  CALLEXECQ CloseLibrary     ;ASL-Library schließen

; ** Playlist-Datei wieder schließen **
  CNOP 0,4
ds_close_playlist_file
  move.l  ds_playlist_file_handle(a3),d1 ;Datei-Handle der Playlist
  CALLDOSQ Close             ;Datei schließen

; ** Speicher für Playlist-Datei wieder freigeben **
  CNOP 0,4
ds_free_playlist_file_mem
  move.l  ds_playlist_file_memory(a3),a1 ;Zeiger auf Speicherbereich
  move.l  ds_playlist_file_length(a3),d0 ;Länge
  CALLEXECQ FreeMem          ;Speicher freigeben

; ** Speicher für FileInfoBlock-Struktur wieder freigeben **

  CNOP 0,4
ds_free_FileInfoBlock_structure
  move.l  ds_FileInfoBlock_structure(a3),a1 ;Zeiger auf Speicherbereich
  move.l  #fib_sizeOF,d0     ;Länge
  CALLEXECQ FreeMem

; ** Playlist-Datei wieder freigeben **
  CNOP 0,4
ds_unlock_playlist_file
  move.l ds_playlist_file_lock(a3),d1 ;Datei-Lock der Playlist
  CALLDOSQ UnLock            ;Datei wieder freigeben

; ** Puffer für Dateipfade wieder freigeben **
  CNOP 0,4
ds_free_entries_buffer
  tst.w   ds_reset_prg_active(a3) ;Reset-Programm installiert ?
  bne.s   ds_free_entries_buffer_mem ;Nein -> verzweige
  rts
  CNOP 0,4
ds_free_entries_buffer_mem
  move.l  entries_buffer(a3),a1 ;Zeiger auf Speicherbeich
  moveq   #0,d0           ;Muss sein!
  move.w  entries_num_max(a3),d0 ;Maximale Anzahl der Einträge in Liste mit Dateipfaden
  MULUF.W playback_queue_entry_size,d0,d1 ;* Größe des Eintrags = Größe des Puffers
  CALLEXECQ FreeMem          ;Speicher freigeben


; ## Run-Demo ##
  CNOP 0,4
rd_start
  tst.w   rd_remove_reset_prg_active(a3) ;Reset-Programm entfernen ?
  beq     rd_end12           ;Ja -> verzweige
  tst.w   rd_show_entries_active(a3) ;Inhalt anzeigen ?
  beq     rd_show_entries    ;TRUE -> verzweige
  RP_GET_ENDLESS_PLAY_STATE  ;Zeiger auf Variable rp_endless_play_active -> a0
  move.w  rd_endless_play_active(a3),(a0) ;Variable rp_endless_play_active setzen
  bsr     rd_open_ciax_resources
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end12              ;Ja -> verzweige
  bsr     rd_open_icon_lib
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     end12              ;Ja -> verzweige
  bsr     rd_create_ser_msg_port
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     rd_end11           ;Ja -> verzweige
  bsr     rd_init_ser_request_structure
  bsr     rd_open_ser_device
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     rd_end10           ;Ja -> verzweige
  bsr     rd_alloc_sprite_data_structure
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     rd_end9            ;Ja -> verzweige
  bsr     rd_sf_alloc_color_values_mem
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     rd_end8            ;Ja -> verzweige
  bsr     rd_sf_alloc_color_cache_mem
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     rd_end7            ;Ja -> verzweige
rd_start_loop
  bsr     rd_get_demo_filename
  tst.w   d0                 ;Fehler aufgetreten ?
  bne     rd_end6            ;Ja -> verzweige
  bsr     rd_check_file_header
  tst.w   d0
  bne     rd_end6
  bsr     rd_init_ser_output_string
  bsr     rd_execute_prerunscript
  tst.w   d0
  bne     rd_end6
  bsr     rd_check_FAST_memory
  bsr     rd_load_demo
  tst.w   d0
  bne     rd_end5
  bsr     rd_check_demo_header
  tst.w   d0
  bne.s   rd_end4
  bsr     rd_set_new_current_dir
  tst.w   d0
  bne.s   rd_end4
  bsr     rd_open_PAL_screen
  tst.w   d0
  bne.s   rd_end3
  bsr     rd_downgrade_sprite_resolution
  bsr     rd_open_dummy_window
  tst.w   d0
  bne.s   rd_end2
  bsr     rd_clear_mousepointer
  bsr     rd_fade_out_screen
  bsr     rd_control_timer
  tst.w   d0                 ;Fehler aufgetreten ?
  bne.s   rd_end1            ;Ja -> verzweige
  bsr     rd_downgrade_display
  bsr     rd_get_own_trap_vectors
  bsr     rd_downgrade_CPU
  bsr     rd_save_hardware_regs
  bsr     rd_run_demo
  bsr     rd_clear_important_regs
  bsr     rd_restore_hardware_regs
  bsr     rd_upgrade_CPU
  bsr     rd_restore_own_trap_vectors
  bsr     rd_restore_display
  bsr     rd_init_ser_output_string2
  bsr     rd_control_timer2
rd_end1
  bsr     rd_fade_in_screen
  bsr     rd_close_dummy_window
rd_end2
  bsr     rd_restore_sprite_resolution
  bsr     rd_close_PAL_screen
rd_end3
  bsr     rd_set_old_current_dir
  bsr     rd_unlock_demo_directory
rd_end4
  bsr     rd_unload_demo
rd_end5
  bsr     rd_free_FAST_memory
rd_end6
  bsr     print_io_error
  bsr     rd_check_demofile_pathtags
  bsr     rd_check_loop_active
  tst.w   d0                 ;Rückgabewert = TRUE ?
  beq     rd_start_loop      ;Ja -> Schleife
  bsr     rd_sf_free_color_cache_mem
rd_end7
  bsr     rd_sf_free_color_values_mem
rd_end8
  bsr     rd_free_sprite_data_structure
rd_end9
  bsr     rd_close_ser_device
rd_end10
  bsr     rd_delete_ser_msg_port
rd_end11
  bsr     rd_close_icon_lib
rd_end12
  bsr     rd_remove_reset_prg
  bra     end11

; ** Inhalt der Playback Queue anzeigen **
  CNOP 0,4
rd_show_entries
  move.l  entries_buffer(a3),a2 
  move.w  #playback_queue_entry_size,a4
  move.w  entries_num(a3),d7 ;Anzahl der Einträge
  moveq   #1,d5              ;Zähler für Einträge
  subq.w  #1,d7              ;-1 wegen dbf
rd_show_entries_loop
  lea     rd_show_entry_header(pc),a0 ;Zeiger auf Text
  moveq   #rd_show_entry_value-rd_show_entry_header,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.w  d7,d4              
  lea     rd_show_entry_value(pc),a0 ;Zeiger auf ASCII-Wert
  move.w  d5,d1              ;Wert zum Umwandeln
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  move.w  d4,d7              ;Schleifenzähler wieder herstellen
  lea     rd_show_entry_value(pc),a0 ;Zeiger auf Text
  moveq   #rd_show_entry_value_end-rd_show_entry_value,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  a2,a0              ;Zeiger auf Eintrag in Playback-Queue
  moveq   #demofile_path_length-1,d6 ;Länge des Dateipfads
  moveq   #0,d0           ;Zähler für Demo-Dateinamen-Länge
  add.l   d6,a0              ;Zeiger auf letztes Zeichen (Nullbyte)
  moveq   #"/",d2
  moveq   #":",d3
rd_get_entry_filename_loop
  tst.b   (a0)               ;Nullbyte ?
  beq.s   rd_get_entry_filename_skip  ;Yes -> skip
  addq.w  #1,d0              ;Zähler für Demo-Dateinamen-Länge erhöhen
rd_get_entry_filename_skip
  cmp.b   (a0),d2            ;"/" gefunden ?
  beq.s   rd_entry_filename_ok ;Ja -> verzweige
  cmp.b   (a0),d3            ;":" gefunden ?
  beq.s   rd_entry_filename_ok ;Ja -> verzweige
  subq.w  #1,a0              ;vorgeriges Zeichen in Dateipfad
  dbf     d6,rd_get_entry_filename_loop
rd_entry_filename_ok
  subq.w  #1,d0              ;"/" oder ":" abziehen
  addq.w  #1,a0              ;"/" oder ":" überspringen
  cmp.w   #rd_show_entry_space_end-rd_show_entry_space-1,d0 ;Länge des Dateinamens <= Füllzeile ?
  ble.s   rd_filename_length_ok ;Ja -> verzweige
  moveq   #rd_show_entry_space_end-rd_show_entry_space-1,d0 ;Textlänge = Länge Füllzeile
rd_filename_length_ok
  move.w  d0,d4              ;Länge des Dateinamens retten
  bsr     print_text         ;Demo-Dateiname ausgeben
  lea     rd_show_entry_space(pc),a0 ;Zeiger auf "..."-String
  moveq   #rd_show_entry_space_end-rd_show_entry_space-1,d0 ;Textlänge der Füllzeile
  sub.w   d4,d0              ;Länge des Dateinamens abziehen
  bsr     print_text         ;Text ausgeben
  tst.b   pqe_tag_active(a2)  ;Tag-Status
  beq.s   rd_print_negative_tag_msg ;Wenn TRUE -> verzweige
rd_print_positive_tag_msg
  lea     rd_tag_active_text1(pc),a0 ;Zeiger auf Text
  moveq   #rd_tag_active_text1_end-rd_tag_active_text1,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  bra.s   rd_tag_msg_skip
  CNOP 0,4
rd_print_negative_tag_msg
  lea     rd_tag_active_text2(pc),a0 ;Zeiger auf Text
  moveq   #rd_tag_active_text2_end-rd_tag_active_text2,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
rd_tag_msg_skip
  add.l   a4,a2              ;nächster Eintrag in Playback Queue
  addq.w  #1,d5              ;Zähler erhöhen
  dbf     d7,rd_show_entries_loop
  move.w  entries_num_max(a3),d1 ;Maximale Anzahl der Einträge in Liste mit Dateipfaden
  lea     rd_not_used_entries_num_value(pc),a0 ;Stringadresse
  sub.w   entries_num(a3),d1 ;Verbleibende Anzahl der zu ladenden Dateien ermitteln
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  lea     rd_message_text(pc),a0 ;Zeiger auf Text
  moveq   #rd_message_text_end-rd_message_text,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  bra     rd_end11

; ** CIA-A und CIA-B Resources öffnen und ICR-Register retten **

  CNOP 0,4
rd_open_ciax_resources
  lea     CIAA_name(pc),a1   ;Name der CIA-A-Resource
  CALLEXEC OpenResource      ;Resource öffnen
  lea     _CIABase(pc),a0
  move.l  d0,(a0)
  beq.s   rd_ciax_resources_error ;Wenn Fehler -> verzweige
  moveq   #0,d0           ;Maske = NULL
  CALLCIA AbleICR            ;ICR-Maske 
  move.b  d0,rd_old_CIAAICR(a3) 

  lea     CIAB_name(pc),a1   ;Name der CIA-B-Resource
  CALLEXEC OpenResource      ;Resource öffnen
  lea     _CIABase(pc),a0
  move.l  d0,(a0)
  beq.s   rd_ciax_resources_error ;Wenn Fehler -> verzweige
  moveq   #0,d0           ;Maske = NULL
  CALLCIA AbleICR            ;ICR-Maske 
  move.b  d0,rd_old_CIABICR(a3) 
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_ciax_resources_error
  lea     rd_error_text2(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text2_end-rd_error_text2,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Icon-Library öffnen **
  CNOP 0,4
rd_open_icon_lib
  lea     icon_name(pc),a1   ;Name der Icon-Library
  moveq   #OS_Version,d0     ;Version 2.04+
  CALLEXEC OpenLibrary       ;Icon-Library öffnen
  lea     _IconBase(pc),a0
  move.l  d0,(a0)            ;Zeiger auf Icon-Base retten
  beq.s   rd_icon_lib_error  ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_icon_lib_error
  lea     rd_error_text3(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text3_end-rd_error_text3,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Serial-Message-Port initialisieren **
  CNOP 0,4
rd_create_ser_msg_port
  CALLLIBS CreateMsgPort     ;Message-Port für serial.device initialisieren
  move.l  d0,rd_ser_msg_port(a3) ;Zeiger auf MsgPort-Struktur retten
  beq.s   rd_create_message_port_error ;Wenn NULL -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_create_message_port_error
  lea     rd_error_text4(pc),a0 ;Zeiger auf Text
  moveq   #rd_error_text4_end-rd_error_text4,d0 ;Textlänge
  bsr     print_text          ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Serial-Request-Struktur initialisieren **
  CNOP 0,4
rd_init_ser_request_structure
  lea     rd_ser_request_structure(pc),a0 ;Zeiger auf Serial-Request-Struktur
  move.l  rd_ser_msg_port(a3),MN_ReplyPort(a0) ;Reply-Port eintragen
  moveq   #0,d0
  move.b  d0,LN_Type(a0)     ;Eintragstyp = Null
  move.b  d0,LN_Pri(a0)      ;Priorität der Struktur = Null
  move.l  d0,LN_Name(a0)     ;Keine Name der Struktur
  rts

; ** Serial-Device öffnen **
  CNOP 0,4
rd_open_ser_device
  lea     serial_device_name(pc),a0 ;Zeiger auf Name des Serial-Device
  lea     rd_ser_request_structure(pc),a1 ;Zeiger auf Serial-Request-Struktur
  moveq   #0,d0           ;Unit 0
  moveq   #TRUE,d1           ;Keine Flags
  CALLLIBS OpenDevice        ;Serial-Device öffnen
  tst.l   d0
  bne.s   rd_open_ser_device_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_open_ser_device_error
  lea     rd_error_text5(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text5_end-rd_error_text5,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Speicher für Sprite-Data-Struktur belegen **
  CNOP 0,4
rd_alloc_sprite_data_structure
  moveq   #6*2,d0            ;Größe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_CHIP+MEMF_PUBLIC+MEMF_REVERSE,d1
  CALLLIBS AllocMem          ;Speicher reservieren
  move.l  d0,rd_sprite_data_structure(a3)
  beq.s   rd_alloc_sprite_data_structure_error
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_alloc_sprite_data_structure_error
  lea     rd_error_text6(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text6_end-rd_error_text6,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Speicher für 32-Bit-RGB-Werte der Screenfarben belegen **

  CNOP 0,4
rd_sf_alloc_color_values_mem
  move.l  #256*3*4,d0        ;Größe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_ANY+MEMF_PUBLIC+MEMF_REVERSE,d1
  CALLLIBS AllocMem          ;Speicher reservieren
  move.l  d0,rd_sf_color_values32(a3)
  beq.s   rd_sf_alloc_color_values_mem_error
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_sf_alloc_color_values_mem_error
  lea     rd_error_text7(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text7_end-rd_error_text7,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Speicher für 32-Bit-RGB-Werte Colourcache belegen **
  CNOP 0,4
rd_sf_alloc_color_cache_mem
  move.l  #256*3*4,d0        ;Größe der Speicherbereiches
  move.l  #MEMF_CLEAR+MEMF_ANY+MEMF_PUBLIC+MEMF_REVERSE,d1
  CALLLIBS AllocMem          ;Speicher reservieren
  move.l  d0,rd_sf_color_cache32(a3)
  beq.s   rd_sf_alloc_color_cache_mem_error
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_sf_alloc_color_cache_mem_error
  lea     rd_error_text8(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text8_end-rd_error_text8,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Demo-Dateinamen ermitteln **
rd_get_demo_filename
  move.w  rd_play_entry_offset(a3),d0 ;Offset von Argument PLAYENTRY 
  subq.w  #1,d0              ;1 abziehen
  bpl.s   rd_calculate_entry_offset ;Wenn positiv -> verzweige
  tst.w   rd_random_play_active(a3) ;Zufallswert für Offset ?
  beq     rd_random_entries_offset ;Wenn TRUE -> verzweige
rd_sequential_entries_offset
  RP_GET_ENTRIES_OFFSET      ;Zeiger auf Variable rp_entries_offset  -> a0
  move.w  (a0),d0            ;Inhalt von rp_entries_offset retten
  addq.w  #1,(a0)            ;Inhalt von Variable rp_entries_offset erhöhen
rd_calculate_entry_offset
  MULUF.W (playback_queue_entry_size)/8,d0,d1 ;* Größe des Eintrags/8
  move.l  entries_buffer(a3),a0 ;Zeiger auf Puffer für Einträge
  lea     (a0,d0.w*8),a0     ;Offset in Dateipfade-Puffer berechnen
rd_check_demo_filepath
  move.l  a0,rd_demo_filepath(a3) ;Zeiger auf Eintrag in Playback-Queue 2x retten
  move.l  a0,a2
  moveq   #demofile_path_length-1,d7 ;Länge des Dateipfads
  moveq   #0,d0           ;Zähler für Dateinamen-Länge
  add.l   d7,a0              ;Zeiger auf letztes Zeichen (Nullbyte)
  moveq   #"/",d2
  moveq   #":",d3
rd_get_demo_filename_loop
  tst.b   (a0)               ;Nullbyte ?
  beq.s   rd_get_demo_filename_skip  ;Yes -> skip
  addq.w  #1,d0              ;Zähler für Demo-Dateinamen-Länge erhöhen
rd_get_demo_filename_skip
  cmp.b   (a0),d2            ;"/" gefunden ?
  beq.s   rd_demo_filename_ok ;Ja -> verzweige
  cmp.b   (a0),d3            ;":" gefunden ?
  beq.s   rd_demo_filename_ok ;Ja -> verzweige
  subq.w  #1,a0              ;vorgeriges Zeichen in Dateipfad
  dbf     d7,rd_get_demo_filename_loop
rd_demo_filename_ok
  addq.w  #1,a0              ;"/" oder ":" überspringen
  move.l  a0,rd_demo_filename(a3) ;Zeiger auf Dateinamen retten
  subq.w  #1,d0              ;"/" oder ":" abziehen
  move.l  d0,rd_demo_filename_length(a3) ;Länge des Dateinamens retten
  lea     rd_demo_filename_header(pc),a0 ;Zeiger auf Text
  moveq   #rd_demo_filename_header_end-rd_demo_filename_header,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  rd_demo_filename(a3),a0 ;Zeiger auf Text
  move.l  rd_demo_filename_length(a3),d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  lea     rd_demo_filename_tail(pc),a0 ;Zeiger auf Text
  moveq   #rd_demo_filename_tail_end-rd_demo_filename_tail,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  move.l  a2,a0              ;Zeiger auf Eintrag 
  tst.b   pqe_tag_active(a0)  ;Tag-Status gesetzt ?
  bne     rd_demo_already_executed ;Ja -> verzweige
rd_check_arguments
  tst.w   rd_prerunscript_active(a3) ;Wurde das Argument "PRERUNSCRIPT" angegeben ?
  beq.s   rd_no_prerunscript_path ;Ja -> verzweige
  lea     pqe_prerunscript_path(a0),a1 ;Zeiger auf Prerunscript-Pfad
  tst.b   (a1)               ;1. Byte Nullbyte ?
  beq.s   rd_no_prerunscript_path ;Ja -> verzweige
  move.l  a1,rd_prerunscript_path(a3) ;Zeiger auf Prerunscript-Pfad retten
rd_no_prerunscript_path
  moveq   #FALSE,d0
  move.b  d0,pqe_tag_active(a0) ;Tag-Status setzen = Demo wurde ausgeführt
  moveq   #0,d0           ;Rückgabewert = OK
  rts
  CNOP 0,4
rd_random_entries_offset
  move.l  #_CUSTOM+VHPOSR,a1
  move.w  entries_num(a3),d1 ;Anzahl der Einträge
  move.l  #_CIAA+CIATODLOW,a2
  move.w  (a1),d0            ;f(x)
  move.l  #_CIAB+CIATODLOW,a4
rd_get_random_offset_loop
  mulu.w  (a1),d0            ;f(x)*a
  move.w  (a1),d2
  swap    d2
  move.b  (a2),d2
  lsl.w   #8,d2
  move.b  (a4),d2            ;b
  add.l   d2,d0              ;(f(x)*a)+b
  and.l   #$0000ffff,d0      ;Nur Bits 0-15
  divu.w  d1,d0              ;f(x+1)=[(f(x)*a)+b]/mod rp_entries_num
  swap    d0                 ;Rest der Division = Zufallsoffset
  MULUF.W (playback_queue_entry_size)/8,d0,d2 ;* Größe des Eintrags/8
  move.l  entries_buffer(a3),a0 ;Zeiger auf Puffer für Einträge
  lea     (a0,d0.w*8),a0     ;Offset in Dateipfade-Puffer berechnen
  tst.b   pqe_tag_active(a0)  ;Tag-Status gesetzt ?
  bne.s   rd_get_random_offset_loop ;Ja -> verzweige
  bra     rd_check_demo_filepath
  CNOP 0,4
rd_demo_already_executed
  lea     rd_error_text9(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text9_end-rd_error_text9,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = False
  rts

; ** Prüfen, ob die Datei ausführbar ist **
  CNOP 0,4
rd_check_file_header
  move.l  rd_demo_filepath(a3),d1 ;Zeiger auf Eintrag in Playback-Queue
  move.l  #MODE_OLDFILE,d2   ;Nur lesen
  CALLDOS Open
  tst.l   d0
  beq.s   rd_open_file_error ;Wenn NULL -> verzweige
  move.l  d0,a2              ;Zeiger auf Datei-Handle retten
  move.l  d0,d1              ;Zeiger auf Datei-Handle 
  lea     rd_MAGIC_COOKIE(a3),a4
  move.l  a4,d2              ;Zeiger auf Puffer
  moveq   #4,d3              ;Anzahl der Zeichen zum Lesen
  CALLLIBS Read              ;4 Bytes lesen
  move.l  a2,d1              ;Zeiger auf Datei-Handle 
  CALLLIBS Close
  cmp.l   #rd_MAGIC_COOKIE_value,(a4) ;Ist die Datei ausführbar?
  bne.s   rd_check_file_header_error ;Nein -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_open_file_error
  CALLLIBS IoErr
  move.l  d0,DOS_return_code(a3) ;Fehlercode retten
  lea     rd_error_text10(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text10_end-rd_error_text10,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts
  CNOP 0,4
rd_check_file_header_error
  lea     rd_error_text11(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text11_end-rd_error_text11,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #ERROR_FILE_NOT_OBJECT,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** String für die serielle Ausgabe initialisieren **
; ----------------------------------------------------
  CNOP 0,4
rd_init_ser_output_string
  move.w  rd_play_duration(a3),d1 ;Sekundenwert über die Argumente MIN(S)/SEC(S)/LMBEXIT ?
  bne.s   rd_create_output_string ;Ja -> verzweige
rd_check_filepath_playtime
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  add.w   pqe_playtime(a0),d1 ;Sekundenwert aus Dateipfade-Puffer über Argumente MIN(S)/SEC(S)/LMBEXIT ?
  beq.s   rd_no_playtime_given ;Nein -> verzweige
rd_create_output_string
  clr.w   rd_play_duration_active(a3) ;TRUE = Es wurde eine Spielzeit angegeben
  lea     rd_ser_output_string_number(pc),a0 ;Stringadresse
  moveq   #5,d7              ;Stringlänge = Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  lea     rd_ser_output_string(pc),a0 ;Zeiger auf Ausgabe-String
  moveq   #rd_ser_output_string_checksum-rd_ser_output_string,d7 Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
  bsr     rp_get_ascii_checksum
  bsr     rp_dec_to_hex
  lea     rd_ser_output_string_checksum(pc),a0 ;Zeiger auf String
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bra     rp_hex_to_ascii
  CNOP 0,4
rd_no_playtime_given
  moveq   #FALSE,d0
  move.w  d0,rd_play_duration_active(a3) ;FALSE = Es wurde keine Spielzeit angegeben
  rts

; ** Prerunscript ausführen **
  CNOP 0,4
rd_execute_prerunscript
  move.l  rd_prerunscript_path(a3),d0 ;Gibt es ein Prerunscript ?
  beq.s   rd_no_execute_prerunscript ;Nein -> verzweige
  move.l  d0,a0              ;Quelle: Prerunscript-Name
  lea     rd_prerunscript_cmd_line_path(pc),a1 ;Ziel: Befehlszeile
  moveq   #prerunscript_path_length-1,d7
rd_copy_prerunscript_filename_loop
  move.b  (a0)+,(a1)+        ;1 Byte kopieren
  dbeq    d7,rd_copy_prerunscript_filename_loop ;Wenn <> NULL oder Schleifebzähler <> FALSE -> Scleife
  lea     rd_prerunscript_cmd_line(pc),a0
  move.l  a0,d1              ;Zeiger auf Kommandozeile
  moveq   #TRUE,d2           ;NULL = Kein Input
  moveq   #TRUE,d3           ;NULL = Kein Output
  CALLDOS Execute
  tst.l   d0                 ;Fehler aufgetreten ?
  beq.s   rd_execute_prerunscript_error ;Ja -> verzweige
  CALLLIBS IoErr             
  tst.l   d0                 ;Hat die Ausführung der Kommandozeile einen Fehler ergeben ?
  bne.s   rd_execute_prerunscript_error2 ;Ja -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
rd_no_execute_prerunscript
  rts
  CNOP 0,4
rd_execute_prerunscript_error
  lea     rd_error_text12(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text12_end-rd_error_text12,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_ERROR,d0
rd_execute_prerunscript_error2
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** FAST-memory ggf. ausschalten **
  CNOP 0,4
rd_check_FAST_memory
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Demo-Dateipad
  tst.b   pqe_startmode(a0)  ;Startmodus "FAST" ?
  beq.s   rd_no_turn_off_FAST_memory ;Ja -> verzweige
rd_turn_off_FAST_memory
  move.l  #MEMF_FAST+MEMF_LARGEST,d1 ;Größten FAST-memory Block prüfen
  move.l  d1,d2              ;Request retten
  CALLEXEC AvailMem
  move.l  d0,rd_largest_FASTmem_block_size(a3) ;Größe retten
  beq.s   rd_no_turn_off_FAST_memory ;Wenn NULL -> verzweige
  move.l  d2,d1              ;MEMF_FAST+MEMF_LARGEST
  CALLLIBS AllocMem          ;Größten FAST-memory Block belegen
  move.l  d0,rd_largest_FASTmem_block_pointer(a3) ;2x retten
  move.l  d0,a2
rd_turn_off_FAST_memory_loop
  move.l  d2,d1              ;MEMF_FAST+MEMF_LARGEST
  CALLLIBS AvailMem          ;Größten FAST-memory Block prüfen
  move.l  d0,(a2)+           ;Größe retten
  beq.s   rd_no_turn_off_FAST_memory ;Wemm NULL -> verzweige
  move.l  d2,d1              ;MEMF_FAST+MEMF_LARGEST
  CALLLIBS AllocMem          ;Größten FAST-memory Block belegen
  move.l  d0,(a2)+           ;Zeiger auf Speicher retten
  bra.s   rd_turn_off_FAST_memory_loop
  CNOP 0,4
rd_no_turn_off_FAST_memory
  rts

; ** Demo laden **
  CNOP 0,4
rd_load_demo
  move.l  rd_demo_filepath(a3),d1 ;Zeiger auf Demo-Dateipad
  CALLDOS LoadSeg            ;Demo laden
  move.l  d0,rd_demofile_seglist(a3)  ;Zeiger retten
  beq.s   rd_load_demo_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_load_demo_error
  CALLLIBS IoErr
  move.l  d0,DOS_return_code(a3)
  lea     rd_error_text13(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text13_end-rd_error_text13,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Prüfen, ob es sich um eine WHDLoad Slave-Datei handelt **

  CNOP 0,4
rd_check_demo_header
  move.l  rd_demofile_seglist(a3),a0 ;Zeiger auf SegList-Struktur
  add.l   a0,a0              ;Zeiger*4, da BCPL-Zeiger
  add.l   a0,a0
  cmp.l   #"WHDL",8(a0)      ;Kennung "WHDLOADS" vorhanden ?
  bne     rd_no_WHDLoad_slave ;Nein -> verzweige
  cmp.l   #"OADS",12(a0)
  bne     rd_no_WHDLoad_slave ;Nein -> verzweige
rd_create_whdload_command_string
  clr.w   rd_WHDLoad_slave_active(a3) ;TRUE = Datei ist eine WHDLoad Slave-Datei
  lea     rd_whdload_slave_cmd_line_path(pc),a1 ;Zeiger auf Dateinamen in Kommand-String
  move.l  rd_demo_filename(a3),a0 ;Zeiger auf Slave-Dateinamen
  move.l  rd_demo_filename_length(a3),d7 ;Länge des Slave-Dateinamens inklusive Nullbyte
rd_copy_slave_filename_loop
  move.b  (a0)+,(a1)+        ;Slave-Dateinamen kopieren
  dbf     d7,rd_copy_slave_filename_loop
  move.l  a1,a2              ;Zeiger auf Dateipfadende in Kommando-String retten
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Slave-Dateipfad
  lea     rd_whdload_icon_path(pc),a1 ;Zeiger auf Icon-Dateipfad
  moveq   #demofile_path_length-1,d7 ;Maximale Länge des Slave-Dateipfads
rd_copy_slave_filepath_loop
  move.b  (a0)+,(a1)+        ;ASCII-Zeichen kopieren
  dbeq    d7,rd_copy_slave_filepath_loop ;Wenn <> NULL oder Schleifenzähler <> FALSE -> Schleife
  subq.w  #7,a1              ;Endung ".slave",0 in Icon-Dateipfad überspringen
  clr.b   (a1)               ;Nullbyte einfügen
rd_check_icon_tooltypes
  lea     rd_whdload_icon_path(pc),a0 ;Zeiger auf Icon-Dateiname
  CALLICON GetDiskObject
  move.l  d0,rd_disk_object(a3) ;Zeiger auf Disk-Objekt-Struktur retten
  beq     rd_disk_object_error ;Wenn NULL -> verzweige
  move.l  d0,a0
  move.l  do_ToolTypes(a0),a0 ;Zeiger auf Tooltypes-Feld der Icon-Datei 
  move.l  a0,a4              
  lea     rd_whdload_tooltype_PRELOAD(pc),a1 ;Zeiger auf String "PRELOAD"
  CALLLIBS FindToolType
  tst.l   d0                 ;Tooltype "PRELOAD" gefunden ?
  beq.s   rd_no_tooltype_PRELOAD ;Nein -> verzweige
  subq.w  #1,a2              ;Zeiger auf Nullbyte
  move.b  #" ",(a2)+         ;und durch Space-Zeichen ersetzen
  move.b  #"P",(a2)+         ;Argument "Preload" in String einfügen
  move.b  #"r",(a2)+
  move.b  #"e",(a2)+
  move.b  #"l",(a2)+
  move.b  #"o",(a2)+
  move.b  #"a",(a2)+
  move.b  #"d",(a2)+
  clr.b   (a2)+              ;Nullbyte einfügen
rd_no_tooltype_PRELOAD
  move.l  a4,a0              ;Zeiger auf Tooltypes-Feld 
  lea     rd_whdload_tooltype_PRELOADSIZE(pc),a1 ;Zeiger auf String "PRELOADSIZE"
  CALLLIBS FindToolType
  tst.l   d0                 ;Tooltype "PRELOADSIZE" gefunden ?
  beq.s   rd_no_tooltype_PRELOADSIZE ;Nein -> verzweige
  subq.w  #1,a2              ;Zeiger auf Nullbyte
  move.b  #" ",(a2)+         ;und durch Space-Zeichen ersetzen
  move.b  #"P",(a2)+         ;Argument "Preloadsize" in String einfügen
  move.b  #"r",(a2)+
  move.b  #"e",(a2)+
  move.b  #"l",(a2)+
  move.b  #"o",(a2)+
  move.b  #"a",(a2)+
  move.b  #"d",(a2)+
  move.b  #"s",(a2)+
  move.b  #"i",(a2)+
  move.b  #"z",(a2)+
  move.b  #"e",(a2)+
  move.b  #" ",(a2)+         ;Space
  move.l  d0,a0              ;Zeiger auf Wert von Argument "PRELOADSIZE"
rd_copy_PRELOADSIZE_value
  move.b  (a0)+,(a2)+        ;Wert kopieren
  bne.s   rd_copy_PRELOADSIZE_value
rd_no_tooltype_PRELOADSIZE
  move.l  a4,a0              ;Zeiger auf Tooltypes-Feld 
  lea     rd_whdload_tooltype_QUITKEY(pc),a1 ;Zeiger auf String "QUITKEY"
  CALLLIBS FindToolType
  tst.l   d0                 ;Tooltype "QUITKEY" gefunden ?
  beq.s   rd_no_tooltype_QUITKEY ;Nein -> verzweige
  subq.w  #1,a2              ;Zeiger auf Nullbyte
  move.b  #" ",(a2)+         ;und durch Space-Zeichen ersetzen
  move.b  #"Q",(a2)+         ;Argument "Quitkey" in String einfügen
  move.b  #"u",(a2)+
  move.b  #"i",(a2)+
  move.b  #"t",(a2)+
  move.b  #"k",(a2)+
  move.b  #"e",(a2)+
  move.b  #"y",(a2)+
  move.b  #" ",(a2)+         ;Space
  move.l  d0,a0              ;Zeiger auf Wert von Argument "QUITKEY"
  cmp.b   #"$",(a0)          ;Hex-Zahl ?
  beq.s   rd_convert_QUITKEY_hexvalue ;Ja -> verzweige
rd_copy_QUITKEY_value
  move.b  (a0)+,(a2)+        ;QUITKEY-Wert nach Kommando-String kopieren
  bne.s   rd_copy_QUITKEY_value
rd_no_tooltype_QUITKEY
  move.l  rd_disk_object(a3),a0 ;Zeiger auf Disk-Objekt-Struktur
  CALLLIBS FreeDiskObject
rd_no_WHDLoad_slave
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_disk_object_error
  CALLDOS IoErr
  move.l  d0,DOS_return_code(a3)
  lea     rd_error_text14(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text14_end-rd_error_text14,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts
  CNOP 0,4
rd_convert_QUITKEY_hexvalue
  addq.w  #1,a0              ;"$"-Zeichen in String überspringen
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr.s   rd_ascii_to_hex
  move.l  a2,a0              ;Zeiger auf Kommando-String
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  clr.b   (a0)               ;Nullbyte in Kommando-String setzen
  bra.s   rd_no_tooltype_QUITKEY

; ** ASCII-Zeichen in Hexadezimalzahl umwandeln **
; a0 ... Zeiger auf String
; d1 ... Rückgabewert = Hexadezimalzahl
; d7 ... Anzahl der Stellen zum Umwandeln
  CNOP 0,4
rd_ascii_to_hex
  add.l   d7,a0              ;Zeiger auf Ende des Strings
  moveq   #TRUE,d1           ;Hexadezimalzahl
  moveq   #TRUE,d2           ;Erster Hex-Stellenwert 16^0 als Shiftwert 0
  subq.w  #1,d7              ;-1 wegen dbf
rd_ascii_to_hex_loop
  moveq   #0,d0           ;Für 32-Bit Zugriff
  move.b  -(a0),d0           ;ASCII-Wert lesen
  sub.b   #"0",d0            ;ASCII-Wert "0" abziehen = 0...9
  cmp.b   #9,d0              ;Hex-Ziffern 0...9 ?
  ble.s   rd_ascii_to_hex_ok ;Ja -> verzweige
  subq.b  #7,d0              ;ASCII-Wert "A" abziehen
  cmp.b   #15,d0             ;Hex-Ziffern A...F ?
  ble.s   rd_ascii_to_hex_ok ;Ja -> verzweige
  sub.b   #32,d0             ;Ansonsten ASCII-Wert "a" abziehen für Hex-Ziffern a...f
rd_ascii_to_hex_ok
  lsl.l   d2,d0              ;*Hex-Stellenwert (16^0,16^1,16^2,...)
  addq.w  #4,d2              ;Shiftwert um 16^n erhöhen
  add.l   d0,d1              ;Stelle zum Ergebnis addieren
  dbf     d7,rd_ascii_to_hex_loop
  rts

; ** Demo-Verzeichnisname ermitteln und zu aktuellem Verzeichnis erklären **

rd_set_new_current_dir
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  moveq   #demofile_path_length-1,d7 ;Länge des Pfadnamens
  lea     rd_demo_directory_path(pc),a1 ;Zeiger auf Puffer für Demo-Directory-Pfad
  add.l   d7,a0              ;Ende des Quellpuffers
  move.l  a1,d1              
  add.l   d7,a1              ;Ende des Zielpuffers
  moveq   #"/",d2
  moveq   #":",d3
rd_get_directory_loop
  move.b  -(a0),d0           ;Quell-Pfadename rückwärts byteweise auslesen
  subq.w  #1,d7              ;Zähler verringern
  clr.b   -(a1)              ;Quell-Pfadename rückwärts byteweise löschen
  cmp.b   d2,d0              ;Ende des Verzeichnisnamens gefunden ?
  beq.s   rd_directory_name_found2 ;Ja -> verzweige
  cmp.b   d3,d0              ;Ende des Gerätenamens gefunden ?
  beq.s   rd_directory_name_found1 ;Ja -> verzweige
  bra.s   rd_get_directory_loop
  CNOP 0,4
rd_directory_name_found1
  move.b  d0,(a1)            ;":" eintragen
rd_directory_name_found2
  subq.w  #1,d7              ;-1 wegen dbf
rd_copy_character_loop
  move.b  -(a0),-(a1)        ;1 Byte des Verzeichnisnamens kopieren
  dbf     d7,rd_copy_character_loop
  move.l  #ACCESS_READ,d2    ;Nur Lesen
  CALLDOS Lock               ;Lock von Demo-Directory 
  move.l  d0,rd_demo_dir_lock(a3) 
  beq.s   rd_directory_error ;Wenn NULL -> verzweige
  move.l  d0,d1              ;Lock für Programm-Directory
  move.l  d0,d3              ;Lock für Current-Directory
  CALLLIBS SetProgramDir     ;PRGDIR: = Demo-Directory
  move.l  d3,d1              ;Current-Directory-Lock
  CALLLIBS CurrentDir        ;Current Directory = Demo-Directory
  move.l  d0,rd_old_current_dir_lock(a3) ;Lock von altem Current Directory retten
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_directory_error
  lea     rd_error_text15(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text15_end-rd_error_text15,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_ERROR,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** PAL-Screen öffnen **
  CNOP 0,4
rd_open_PAL_screen
  CALLINT ViewAddress        ;Viewadresse des aktuellen Screens 
  move.l  d0,a0              ;Zeiger auf View 
  lea     rd_COLOR00_value32(pc),a1 ;32-Bit RGB-Wert COLOR00 in Erfahrung bringen
  move.l  v_Viewport(a0),a0  ;Zeiger auf Viewport 
  moveq   #0,d0           ;Erstes Register COLOR00
  move.l  vp_ColorMap(a0),a0 ;Zeiger auf Farbtabelle 
  moveq   #1,d1              ;Nur eine Farbe (Hintergrundfarbe)
  CALLGRAF GetRGB32
  sub.l   a0,a0              ;Keine NewScreen-Struktur
  lea     rd_ScreenTagList(pc),a1 ;Zeiger auf ScreenTagList-Struktur
  CALLINT OpenScreenTagList  ;Screen öffnen
  lea     rd_WindowTagList+4(pc),a0 
  move.l  d0,(a0)            ;Zeiger auf Screen in WindowTagList eintragen
  beq.s   rd_open_PAL_screen_error ;Wenn Fehler -> verzweige
  CALLLIBS ViewAddress       ;Viewadresse des PAL-Screens 
  move.l  d0,rd_old_view(a3) 
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_open_PAL_screen_error
  lea     rd_error_text16(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text16_end-rd_error_text16,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Sprite-Auflösung auf OCS-kompatible Werte zurücksetzen **

  CNOP 0,4
rd_downgrade_sprite_resolution
  move.l  rd_WindowTagList+4(pc),a2 ;Zeiger auf PAL-Screen
  lea     rd_VideoControlTagList1(pc),a1 ;Zeiger auf Tagliste
  move.l  sc_ViewPort+vp_ColorMap(a2),a0 ;Zeiger auf ColorMap-Struktur
  CALLGRAF VideoControl      ;Sprite-Auflösung ermitteln
  lea     rd_VideoControlTagList1(pc),a0 ;Zeiger auf Tagliste
  move.l  ti_data(a0),rd_old_sprite_resolution(a3) ;Sprite-Auflösung retten
  lea     rd_VideoControlTagList2(pc),a1 ;Zeiger auf Tagliste
  move.l  sc_ViewPort+vp_ColorMap(a2),a0 ;Zeiger auf ColorMap-Struktur
  CALLLIBS VideoControl      ;Sprite-Auflösung zurücksetzen
  move.l  a2,a0              ;Zeiger auf Screen
  CALLINT MakeScreen         ;Änderungen sichtbar machen
  CALLLIBQ RethinkDisplay

; ** Dummy-Fenster öffnen **
  CNOP 0,4
rd_open_dummy_window
  sub.l   a0,a0              ;Keine NewWindow-Struktur
  lea     rd_WindowTagList(pc),a1 ;Zeiger auf WindowTagList-Struktur
  CALLLIBS OpenWindowTagList  ;Window öffnen
  move.l  d0,rd_dummy_window(a3) ;Zeiger retten
  beq.s   rd_open_dummy_window_error ;Wenn Fehler -> verzweige
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_open_dummy_window_error
  lea     rd_error_text17(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text17_end-rd_error_text17,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Mousepointer löschen **
  CNOP 0,4
rd_clear_mousepointer
  move.l  rd_dummy_window(a3),a0 ;Zeiger auf Window
  moveq   #1,d0              ;Höhe
  move.l  rd_sprite_data_structure(a3),a1 ;Leersprite
  moveq   #16,d1             ;Breite
  moveq   #TRUE,d2           ;x-Offset
  moveq   #TRUE,d3           ;y-Offset
  CALLLIBQ SetPointer        ;Mousepointer löschen

; ** Screen ausblenden **
  CNOP 0,4
rd_fade_out_screen
  tst.w   rd_nofader_active(a3) ;Wurde Argument "NOFADER" angegeben ?
  beq     rd_no_fade_out_screen ;Ja -> verzweige
  move.l  rd_WindowTagList+4(pc),a2 ;Zeiger auf PAL-Screen

; ** Color-Base der Sprites in Erfahrung bringen **
  move.l  sc_ViewPort+vp_ColorMap(a2),a0 ;Zeiger auf Farbtabelle
  lea     rd_VideoControlTagList3(pc),a1 ;Zeiger auf Tagliste
  CALLGRAF VideoControl      ;Sprite Colourbanks ermitteln
  lea     rd_VideoControlTagList3(pc),a0 ;Zeiger auf Tagliste
  move.l  ti_data(a0),rd_sf_odd_sprite_color_base(a3) ;Color-Base der ungeraden Sprites
  addq.w  #ti_sizeOF,a0      ;nächster Tag-Eintrag
  move.l  ti_data(a0),rd_sf_even_sprite_color_base(a3) ;Color-Base der geraden Sprites

; ** Tiefe des Workbench-Screens und Anzahl der Farben ermitteln **
  move.l  a2,a0              ;Zeiger auf Screen
  CALLINT GetScreenDrawInfo
  move.l  d0,a0              ;Zeiger auf Draw-Info-Struktur
  moveq   #1,d0              ;Tiefe = 1 Bitplane
  move.w  dri_depth(a0),d7   ;Tiefe des Screens
  subq.w  #1,d7              ;-1 wegen dbf
rd_sf_scr_depth_loop
  add.w   d0,d0              ;2^n = Anzahl der Farben des Screen
  dbf     d7,rd_sf_scr_depth_loop
  move.l  d0,rd_sf_colors_number(a3) ;Anzahl der Farben retten
  move.l  d0,d7              

; ** Screenfarbwerte aus ColorMap-Struktur auslesen **
  move.l  sc_ViewPort+vp_ColorMap(a2),a4 ;Zeiger auf Farbtabelle
  move.l  a4,a0              ;Zeiger auf Farbtabelle
  moveq   #0,d0           ;Erstes Register
  move.l  rd_sf_color_values32(a3),a1 ;32-Bit RGB-Werte
  move.l  d7,d1              ;Anzahl der Screenfarben
  CALLGRAF GetRGB32

; ** Farbwerte der ungeraden Sprites aus ColorMap-Struktur auslesen **
  move.l  rd_sf_odd_sprite_color_base(a3),d0 ;Erstes Register
  move.l  d0,d1              
  MULUF.L 3,d1,d2            ;Farbnummer * 3
  move.l  rd_sf_color_values32(a3),a1 ;32-Bit RGB-Werte
  move.l  a4,a0              ;Zeiger auf Farbtabelle
  lea     (a1,d1.w*4),a1     ;Offset in Farbtabelle
  moveq   #16,d1             ;Anzahl der Spritefarben
  CALLLIBS GetRGB32

; ** Farbwerte der geraden Sprites aus ColorMap-Struktur auslesen **
  move.l  rd_sf_even_sprite_color_base(a3),d0 ;Erstes Register
  cmp.l   rd_sf_odd_sprite_color_base(a3),d0 ;Color-Base der ungeraden und gerade Sprites gleich ?
  beq.s   rd_sf_skip_get_even_sprite_colors ;Ja -> verzweige
  move.l  d0,d1              
  MULUF.L 3,d1,d2            ;Farbnummer * 3
  move.l  rd_sf_color_values32(a3),a1 ;32-Bit RGB-Werte
  move.l  a4,a0              ;Zeiger auf Farbtabelle
  lea     (a1,d1.w*4),a1     ;Offset in Farbtabelle
  moveq   #16,d1             ;Anzahl der Spritefarben
  CALLLIBS GetRGB32
rd_sf_skip_get_even_sprite_colors

; ** 32-Bit RGB-Werte kopieren **
  move.l  rd_sf_color_values32(a3),a0 ;Quelle 32-Bit RGB-Werte
  move.l  rd_sf_color_cache32(a3),a1 ;Ziel 32-Bit RGB-Werte
  MOVEF.W 256-1,d7           ;Anzahl der Farbwerte
rd_sf_copy_color_values_loop
  move.l  (a0)+,(a1)+        ;32-Bit-Rotwert
  move.l  (a0)+,(a1)+        ;32-Bit-Grünwert
  move.l  (a0)+,(a1)+        ;32-Bit-Blauwert
  dbf     d7,rd_sf_copy_color_values_loop

; ** Screen ausblenden **
rd_sfo_wait_fade_out
  CALLGRAF WaitTOF
  bsr.s   rd_sfo_screenfader_out
  bsr     rd_sf_set_new_scr_colors
  tst.w   rd_sfo_active(a3)
  beq.s   rd_sfo_wait_fade_out
rd_no_fade_out_screen
  rts

; ** Farben ausblenden **
  CNOP 0,4
rd_sfo_screenfader_out
  move.l  rd_sf_color_cache32(a3),a0 ;Istwerte
  move.w  #rd_sfo_fader_speed,a4 ;Additions-/Subtraktionswert RGB-Werte
  sub.l   a1,a1              ;RGB-Sollwert
  move.w  #256*3,d6          ;Anzahl der Farbwerte*3 = Zähler
  MOVEF.W 256-1,d7           ;Anzahl der Farbwerte
rd_sfo_fader_loop
  moveq   #0,d0
  move.b  (a0),d0            ;8-Bit Rot-Istwert
  move.l  a1,d3              ;8-Bit Rot-Sollwert
  moveq   #TRUE,d1
  swap    d3                 ;$00Rr
  move.b  4(a0),d1           ;8-Bit Grün-Istwert
  moveq   #TRUE,d2
  move.b  8(a0),d2           ;8-Bit Blau-Istwert
  move.w  a1,d4              ;8-Bit Grün-Sollwert
  moveq   #TRUE,d5
  move.b  d4,d5              ;8-Bit Blau-Sollwert
  lsr.w   #8,d4              ;$00Gg
    
; ** Ist-Rotwert mit Soll-Rotwert vergleichen **
  cmp.w   d0,d3              ;Ist-Rotwert mit Soll-Rotwert vergleichen
  blt.s   rd_sfo_decrease_red_value ;Wenn Ist-Rotwert < Soll-Rotwert -> verzweige
  bgt.s   rd_sfo_increase_red_value ;Wenn Ist-Rotwert > Soll-Rotwert -> verzweige
  subq.w  #1,d6              ;Zähler verringern
rd_sfo_rt_fader_loop1

; ** Ist-Grünwert mit Soll-Grünwert vergleichen **
  cmp.w   d1,d4              ;Ist-Grünwert mit Soll-Grünwert vergleichen
  blt.s   rd_sfo_decrease_green_value ;Wenn Ist-Grünwert < Soll-Grünwert -> verzweige
  bgt.s   rd_sfo_increase_green_value ;Wenn Ist-Grünwert > Soll-Grünwert -> verzweige
  subq.w  #1,d6              ;Zähler verringern
rd_sfo_rt_fader_loop2

; ** Ist-Blauwert mit Soll-Blauwert vergleichen **
  cmp.w   d2,d5              ;Ist-Blauwert mit Soll-Blauwert vergleichen
  blt.s   rd_sfo_decrease_blue_value ;Wenn Ist-Blauwert < Soll-Blauwert -> verzweige
  bgt.s   rd_sfo_increase_blue_value ;Wenn Ist-Blauwert > Soll-Blauwert -> verzweige
  subq.w  #1,d6              ;Zähler verringern
rd_sfo_rt_fader_loop3
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  dbf     d7,rd_sfo_fader_loop
  tst.w   d6                 ;Fertig mit ausblenden ?
  bne.s   rd_sfo_not_finished ;Nein -> verzweige
  moveq   #FALSE,d0
  move.w  d0,rd_sfo_active(a3) ;Fading-Out aus
rd_sfo_not_finished
  CALLEXEC CacheClearU       ;Caches flushen
rd_sfo_no_screenfader_out
  rts
  CNOP 0,4
rd_sfo_decrease_red_value
  sub.w   a4,d0              ;Rotanteil verringern
  cmp.w   d0,d3              ;Ist-Rotwert > Soll-Rotwert ?
  blt.s   rd_sfo_rt_fader_loop1 ;Ja -> verzweige
  move.w  d3,d0              ;Ist-Rotwert <= Soll-Rotwert
  bra.s   rd_sfo_rt_fader_loop1
  CNOP 0,4
rd_sfo_increase_red_value
  add.w   a4,d0              ;Rotanteil erhöhen
  cmp.w   d0,d3              ;Ist-Rotwert < Soll-Rotwert ?
  bgt.s   rd_sfo_rt_fader_loop1 ;Ja -> verzweige
  move.w  d3,d0              ;Ist-Rotwert >= Soll-Rotwert
  bra.s   rd_sfo_rt_fader_loop1
  CNOP 0,4
rd_sfo_decrease_green_value
  sub.w   a4,d1              ;Grünanteil verringern
  cmp.w   d1,d4              ;Ist-Grünwert > Soll-Grünwert ?
  blt.s   rd_sfo_rt_fader_loop2 ;Ja -> verzweige
  move.w  d4,d1              ;Ist-Grünwert <= Soll-Grünwert
  bra.s   rd_sfo_rt_fader_loop2
  CNOP 0,4
rd_sfo_increase_green_value
  add.w   a4,d1              ;Grünanteil erhöhen
  cmp.w   d1,d4              ;Ist-Grünwert < Soll-Grünwert ?
  bgt.s   rd_sfo_rt_fader_loop2 ;Ja -> verzweige
  move.w  d4,d1              ;Ist-Grünwert >= Soll-Grünwert
  bra.s   rd_sfo_rt_fader_loop2
  CNOP 0,4
rd_sfo_decrease_blue_value
  sub.w   a4,d2              ;Blauanteil verringern
  cmp.w   d2,d5              ;Ist-Blauwert > Soll-Blauwert ?
  blt.s   rd_sfo_rt_fader_loop3 ;Ja -> verzweige
  move.w  d5,d2              ;Ist-Blauwert <= Soll-Blauwert
  bra.s   rd_sfo_rt_fader_loop3
  CNOP 0,4
rd_sfo_increase_blue_value
  add.w   a4,d2              ;Blauanteil erhöhen
  cmp.w   d2,d5              ;Ist-Blauwert < Soll-Blauwert ?
  bgt.s   rd_sfo_rt_fader_loop3 ;Ja -> verzweige
  move.w  d5,d2              ;Ist-Blauwert >= Soll-Blauwert
  bra.s   rd_sfo_rt_fader_loop3

; ** Neue Farbwerte in Copperliste eintragen **
  CNOP 0,4
rd_sf_set_new_scr_colors
  move.l  rd_sf_color_cache32(a3),a4 ;Puffer für Farbwerte
  moveq   #TRUE,d6           ;Farbregisternummer
  move.l  rd_sf_colors_number(a3),d7 ;Anzahl der Screenfarbwerte
  subq.w  #1,d7              ;-1 wegen dbf
  bsr.s   rd_sf_set_colors_loop

  cmp.l   #256,rd_sf_colors_number(a3) ;Hat der Screen 256 Farben ?
  beq.s   rd_sf_no_even_sprite_colors_set ;Ja -> verzweige
  move.l  rd_sf_odd_sprite_color_base(a3),d6 ;Farbregisternummer
  move.l  d6,d0              
  move.l  rd_sf_color_cache32(a3),a4 ;Puffer für Farbwerte
  MULUF.L 3,d0,d1            ;Farbnummer * 3
  moveq   #16-1,d7           ;Anzahl der Farbwerte
  lea     (a4,d0.w*4),a4     ;Offset in Farbtabelle
  bsr.s   rd_sf_set_colors_loop

  move.l  rd_sf_even_sprite_color_base(a3),d6 ;Farbregisternummer
  cmp.l   rd_sf_odd_sprite_color_base(a3),d6 ;Farbregister-Base bei ungeraden und geraden Sprites gleich ?
  beq.s   rd_sf_no_even_sprite_colors_set ;Ja -> verzweige
  move.l  d6,d0              
  move.l  rd_sf_color_cache32(a3),a4 ;Puffer für Farbwerte
  MULUF.L 3,d0,d1            ;Farbnummer * 3
  moveq   #16-1,d7           ;Anzahl der Farbwerte
  lea     (a4,d0.w*4),a4     ;Offset in Farbtabelle
  bra.s   rd_sf_set_colors_loop
  CNOP 0,4
rd_sf_no_even_sprite_colors_set
  rts

  CNOP 0,4
rd_sf_set_colors_loop
  move.l  (a4)+,d1           ;32-Bit-Rotwert
  move.l  d6,d0              ;Farbnummer
  move.l  (a4)+,d2           ;32-Bit-Grünwert
  lea     sc_ViewPort(a2),a0 ;Zeiger auf Viewport
  move.l  (a4)+,d3           ;32-Bit-Blauwert
  CALLGRAF SetRGB32
  addq.w  #1,d6              ;Farbnummer erhöhen
  dbf     d7,rd_sf_set_colors_loop
  rts

; ** String auf seriellem Port ausgeben und Timer starten **

  CNOP 0,4
rd_control_timer
  tst.w   rd_play_duration_active(a3) ;Gibt es einen Sekundenwert ?
  bne   rd_no_write_ser_output_string ;FALSE -> verzweige
rd_control_timer2
  lea     rd_ser_request_structure(pc),a1 ;Zeiger auf Serial-Request-Struktur
  moveq   #SDCMD_SETPARAMS,d0
  move.w  d0,IO_COMMAND(a1)  ;Parameter für Serial-Device setzen
  move.l  a1,a2              ;Zeiger auf Serial-Request-Struktur retten
  move.l  #baud,IO_BAUD(a1)  ;Baudrate 2400 bps
  moveq   #8,d0
  move.b  d0,IO_WRITELEN(a1) ;8 Bits pro Zeichen beim Schreiben
  moveq   #1,d0
  move.b  d0,IO_STOPBITS(a1) ;1 Stopbit
  MOVEF.B SERF_XDISABLED,d0
  move.b  d0,IO_SERFLAGS(a1) ;Parität aus, kein XON/XOFF Protokoll
  CALLEXEC DoIO
  move.b  IO_ERROR(a2),d0    ;Fehler ?
  beq.s   rd_set_params_ok   ;Nein -> verzweige
  cmp.b   #SerErr_DevBusy,d0 ;Device bereits in Benutzung ?
  beq.s   rd_set_params_device_error1 ;Ja -> verzweige
  cmp.b   #SerErr_BaudMismatch,d0 ;Baudrate nicht von der Hardware unterstützt ?
  beq.s   rd_set_params_device_error2 ;Ja -> verzweige
  cmp.b   #SerErr_InvParam,d0 ;Falsche Parameter ?
  beq.s   rd_set_params_device_error3 ;Ja -> verzweige
  cmp.b   #SerErr_LineErr,d0 ;Überlauf der Daten ?
  beq.s   rd_set_params_device_error4 ;Ja -> verzweige
  cmp.b   #SerErr_NoDSR,d0   ;Data-Set nicht bereit ?
  beq   rd_set_params_device_error5 ;Ja -> verzweige
rd_set_params_ok
  move.l  a2,a1              ;Zeiger auf Serial-Request-Struktur 
  move.w  #CMD_WRITE,IO_COMMAND(a1) ;Schreibbefehl für Serial-Device
  moveq   #rd_ser_output_string_end-rd_ser_output_string,d0 ;Anzahl der Bytes zum Schreiben
  move.l  d0,IO_LENGTH(a1)   ;Länge für Lesen eintragen
  lea     rd_ser_output_string(pc),a0
  move.l  a0,IO_DATA(a1)     ;Zeiger auf String zum Schreiben
  CALLLIBS DoIO
  tst.l   d0                 ;Fehler ?
  bne     rd_write_ser_output_string_error ;Ja -> verzweige
rd_no_write_ser_output_string
  moveq   #TRUE,d0           ;Returncode = OK
  rts
  CNOP 0,4
rd_set_params_device_error1
  lea     rd_error_text18(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text18_end-rd_error_text18,d0 ;Textlänge
  bsr     print_text          ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts
  CNOP 0,4
rd_set_params_device_error2
  lea     rd_error_text19(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text19_end-rd_error_text19,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
rd_set_params_device_error3
  lea     rd_error_text20(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text20_end-rd_error_text20,d0 ;Textlänge
  bsr     print_text          ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
rd_set_params_device_error4
  lea     rd_error_text21(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text21_end-rd_error_text21,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
rd_set_params_device_error5
  lea     rd_error_text22(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text22_end-rd_error_text22,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts   
  CNOP 0,4
rd_write_ser_output_string_error
  lea     rd_error_text23(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text23_end-rd_error_text23,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_FAIL,d0
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = False
  rts          

; ** Display-Hardware auf OCS kompatible Werte zurücksetzen **

rd_downgrade_display
  sub.l   a1,a1              ;Hardware-Register auf PAL-Werte zurücksetzen
  CALLGRAF LoadView
  CALLLIBS WaitTOF           ;Warten bis Änderung sichtbar ist
  CALLLIBS WaitTOF           ;Warten bis Interlace-Screens mit 2 Copperlisten auch voll geändert sind
  tst.l   gb_ActiView(a6)    ;Erschien zwischenzeitlich ein anderer View?
  bne.s	  rd_downgrade_display ;Dann neuer Versuch
  move.l  gb_Copinit(a6),rd_old_COP1LC(a3) ;OS-COP1LC retten
  move.l  gb_LOFlist(a6),rd_old_COP2LC(a3) ;OS-COP2LC (LOFlist, da OS das LOF-Bit bei non-Interlaced immer setzt!) retten
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Demo-Dateipad
  cmp.b   #OCS,pqe_startmode(a0) ;Startmodus "OCS" ?
  bne.s   rd_no_BPLMOD_reset ;Nein -> verzweige
  moveq   #0,d0
  move.l  d0,_CUSTOM+BPL1MOD ;NULL = OCS-komptible Moduli BPL1MOD&BPL2MOD
rd_no_BPLMOD_reset
  rts

; ** Zeiger auf eigene Trap-Vektoren  **
  CNOP 0,4
rd_get_own_trap_vectors
  RP_GET_OWN_TRAP_0_VECTOR   ;Zeiger auf Variable rp_own_trap0_vector  -> a0
  move.l  a0,rd_own_trap_vectors(a3)
  lea     rd_read_VBR(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLEXEC Supervisor
  move.l  d0,rd_old_VBR(a3)  ;Alten Inhalt retten
  rts

; ** VBR auslesen **
; d0 ... Rückgabewert Inhalt von VBR
  CNOP 0,4
rd_read_VBR
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  movec.l VBR,d0             ;VBR-Register auslesen
  nop
  rte

; ** Ggf. VBR zurücksetzen, Caches und MMU deaktivieren **
  CNOP 0,4
rd_downgrade_CPU
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Demo-Dateipad
  tst.b   pqe_startmode(a0)  ;Startmodus "FAST" ?
  beq.s   rd_no_downgrade_CPU ;Ja -> verzweige
rd_check_VBR
  tst.l   rd_old_VBR(a3)     ;VBR-Adresse = NULL ?
  beq.s   rd_deactivate_caches_MMU ;Ja -> verzweige
  moveq   #0,d0           ;VBR = Adresse $00000000
  lea     rd_write_VBR(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
rd_deactivate_caches_MMU
  tst.b   AttnFlags+1(a6)    ;CPU 68060 ?
  bmi.s   rd_deactivate_060_caches_MMU_superscalar ;Ja -> verzweige
; ** 68020-68040 **
rd_deactivate_caches
  moveq   #0,d0           ;Alle Bits löschen
  move.l  #CACRF_EnableI|CACRF_IBE|CACRF_EnableD|CACRF_DBE|CACRF_WriteAllocate|CACRF_EnableE|CACRF_CopyBack,d1 ;Caches ausschalten
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Demo-Dateipad
  cmp.b   #AGA,pqe_startmode(a0) ;Startmodus "AGA"?
  bne.s   rd_disable_instr_cache ;Nein -> verzweige
  and.b   #~(CACRF_EnableI),d1 ;Instruction-Cache nicht ausschalten
rd_disable_instr_cache
  CALLLIBS CacheControl      ;CPU neu konfigurieren und Caches flushen
  move.l  d0,rd_old_CACR(a3) ;Alten Inhalt von CACR retten
; ** 68030-68040 **
rd_deactivate_MMU
  btst    #AFB_68040,AttnFlags+1(a6) ;CPU 68040 ?
  bne.s   rd_deactivate_040_MMU ;Ja -> verzweige
  btst    #AFB_68030,AttnFlags+1(a6) ;CPU 68030 ?
  bne.s   rd_deactivate_030_MMU ;Nein -> verzweige
  rts
  CNOP 0,4
rd_deactivate_030_MMU
  lea     rd_CPU030_MMU_off(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBQ Supervisor
  CNOP 0,4
rd_deactivate_040_MMU
  lea     rd_CPU040_060_MMU_off(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
  movem.l d0-d4,rd_old_TC(a3) ;Alten Inhalt von TC,DTT0,DTT1,ITT0 und ITT1-Registern retten
rd_no_downgrade_CPU
  rts

; ** 68060 **
  CNOP 0,4
rd_deactivate_060_caches_MMU_superscalar
  moveq   #TRUE,d1	     ;Alle Bits in CACR löschen
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Demo-Dateipad
  cmp.b   #AGA,pqe_startmode(a0) ;Startmodus "AGA"?
  bne.s   rd_disable_060_instr_cache ;Nein -> verzweige
  or.w    #CACR060F_FIC+CACR060F_EIC,d1 ;1/2 Instruction-Cache an
rd_disable_060_instr_cache
  lea     rd_CPU060_caches_off(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
  move.l  d0,rd_old_CACR(a3) ;Alten Inhalt von CACR retten
rd_deactivate_060_MMU
  lea     rd_CPU040_060_MMU_off(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
  movem.l d0-d4,rd_old_TC(a3) ;Alten Inhalt von TC,DTT0,DTT1,ITT0 und ITT1-Registern retten
rd_deactivate_060_superscalar
  moveq   #TRUE,d1           ;Alle Bits in PCR-Register löschen
  lea     rd_CPU060_superscalar_off(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
  move.l  d0,rd_old_PCR(a3)  ;Alten Inhalt von PCR-Register retten
  rts

; ** VBR beschreiben **
; d0 ... neuer Inhalt von VBR
  CNOP 0,4
rd_write_VBR
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  movec.l d0,VBR
  nop
  rte

; ** 68060-Caches aus **
; d0 ... alter Inhalt von CACR
; d1 ... neuer Inhalt von CACR
  CNOP 0,4
rd_CPU060_caches_off
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  movec.l CACR,d0            ;Alter Inhalt von CACR
  nop
  CPUSHA  BC                 ;Instruction/Data/Branch-Caches flushen
  nop
  movec.l d1,CACR            ;(Instruction)/Data/Branch-Caches aus
  nop
  rte

; ** 68040/060-MMU deaktivieren **
; d0 ... alter Inhalt von TC
; d1 ... alter Inhalt von DTT0
; d2 ... alter Inhalt von DTT1
; d3 ... alter Inhalt von ITT0
; d4 ... alter Inhalt von ITT1
; a0 ... neuer Inhalt von TC
; d5 ... neuer Inhalt von DTT0
; d7 ... neuer Inhalt von DTT1
; d6 ... neuer Inhalt von ITT0
; d7 ... neuer Inhalt von ITT1
  CNOP 0,4
rd_CPU040_060_MMU_off
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  move.l  #$00ffc000,d7      ;DTT1 Cachable, writethrough für Speicherbereich $00000000-$ffffffff (Zorro II/III)
  move.l  #$0000c040,d5      ;DTT0 Cache inhibited, precise für Speicherbereich $00000000-$00ffffff (Zorro II)
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  move.l  d7,d6              ;ITT0 Cachable für Speicherbereich $00000000-$ffffffff (Zorro II/III)
  cmp.b   #OCS,pqe_startmode(a0) ;Startmodus "OCS" ?
  bne.s   rd_no_inhibited_instr_cache ;Nein -> verzweige
  move.l  d5,d6              ;ITT0 Cache inhibited, precise für Speicherbereich $00000000-$00ffffff (Zorro II)
rd_no_inhibited_instr_cache
  sub.l   a0,a0              ;TC = NULL
  movec.l DTT0,d1            ;Alter Inhalt von DTT0-Register
  nop
  movec.l d5,DTT0            ;Daten Cache Transparent Translation an
  nop
  movec.l DTT1,d2            ;Alter Inhalt von DTT1-Register
  nop
  movec.l d7,DTT1            ;Daten Cache Transparent Translation an
  nop
  movec.l ITT0,d3            ;Alter Inhalt von ITT0-Register
  nop
  movec.l d6,ITT0            ;Instruction Cache Transparent Translation an
  nop
  movec.l ITT1,d4            ;Alter Inhalt von ITT1-Register
  nop
  movec.l d7,ITT1            ;Instruction Cache Transparent Translation an
  nop
  PFLUSHA                    ;ATC-Einträge flushen
  nop
  movec.l TC,d0              ;Alter Inhalt von TC-Register
  nop
  movec.l a0,TC              ;MMU aus
  nop
  rte
  
; ** 68030-MMU aus **
  MC68030
; a3 ... Zeiger auf Variablen-Basis der alten und neuen Inhalte der Register
  CNOP 0,4
rd_CPU030_MMU_off
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  PMOVE   TT0,rd_old_030_TT0(a3) ;Alter Inhalt von TT0-Register
  nop
  PMOVE   rd_clr_030_MMU_reg(a3),TT0 ;TT0-Register löschen
  nop
  PMOVE   TT1,rd_old_030_TT1(a3) ;Alter Inhalt von TT1-Register
  nop
  PMOVE   rd_clr_030_MMU_reg(a3),TT1 ;TT1-Register löschen
  nop
  PFLUSHA                    ;ATC-Einträge flushen
  nop
  PMOVE   TC,rd_old_030_TC(a3) ;Alter Inhalt von TC-Register
  nop
  PMOVE   rd_clr_030_MMU_reg(a3),TC ;TC löschen - MMU aus
  nop
  rte

; ** 68060 parallele Verarbeitung aus **
  MC68040
; d0 ... alter Inhalt von PCR
; d1 ... neuer Inhalt von PCR
  CNOP 0,4
rd_CPU060_superscalar_off
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  DC.L    $4e7a0808          ;movec.l PCR,d0: Alter inhalt von PCR
  nop
  DC.L    $4e7b1808          ;movec.l d1,PCR: Parallele Verarbeitung aus
  nop
  rte

; ** 68060-Caches flushen **
  CNOP 0,4
;CPU060_flush_caches
;  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
;  nop
;  CPUSHA  BC                 ;Instruction/Data/Branch-Caches flushen
;  nop
;  rte

; ** Hardware-Register retten **
  CNOP 0,4
rd_save_hardware_regs
  CALLEXEC Disable           ;Interrupts aus
  move.l  #_CUSTOM,a6        ;CUSTOM
  move.w  DMACONR(a6),rd_old_DMACON(a3) ;OS-DMACON
  move.l  #_CIAB,a5          ;CIA-B-Base
  move.w  INTENAR(a6),rd_old_INTENA(a3) ;OS-INTENA
  lea     _CIAA-_CIAB(a5),a4 ;CIA-A-Base
  move.w  ADKCONR(a6),rd_old_ADKCON(a3) ;OS_ADKCON

  move.b  CIAPRA(a4),rd_old_CIAAPRA(a3) ;OS-CIA-A-PRA
  move.b  CIACRA(a4),d0
  move.b  d0,d1              
  move.b  d0,rd_old_ciaa_cra_bits(a3) ;OS-CIA-A CRA
  and.b   #~(CIACRAF_START),d0 ;Timer A stoppen
  or.b    #CIACRAF_LOAD,d0   ;Zählwert laden
  move.b  d0,CIACRA(a4)
  nop
  move.b  CIATALO(a4),rd_old_CIAATALO(a3) ;OS-CIA-A TALO
  move.b  CIATAHI(a4),rd_old_CIAATAHI(a3) ;OS-CIA-A TAHI
  btst    #CIACRAB_RUNMODE,d1 ;Continuous-Modus ?
  bne.s   rd_ciaa_ta_no_continuous ;Nein -> verzweige
  or.b    #CIACRAF_START,d1  ;Ja -> Timer A wieder starten
  move.b  d1,CIACRA(a4)
rd_ciaa_ta_no_continuous

  move.b  CIACRB(a4),d0
  move.b  d0,d1              
  move.b  d0,rd_old_ciaa_crb_bits(a3) ;OS-CIA-A CRB
  and.b   #~(CIACRBF_ALARM-CIACRBF_START),d0 ;Timer B stoppen
  or.b    #CIACRBF_LOAD,d0   ;Zählwert laden
  move.b  d0,CIACRB(a4)
  nop
  move.b  CIATBLO(a4),rd_old_CIAATBLO(a3) ;OS-CIA-A TBLO
  move.b  CIATBHI(a4),rd_old_CIAATBHI(a3) ;OS-CIA-A TBHI
  btst    #CIACRBB_RUNMODE,d1 ;Continuous-Modus ?
  bne.s   rd_ciaa_tb_no_continuous ;Nein -> verzweige
  or.b    #CIACRBF_START,d1  ;Ja -> Timer B starten
  move.b  d1,CIACRB(a4)
rd_ciaa_tb_no_continuous

  move.b  CIAPRB(a5),rd_old_CIABPRB(a3) ;OS-CIA-B PRB
  move.b  CIACRA(a5),d0
  move.b  d0,d1              
  move.b  d0,rd_old_ciaa_cra_bits(a3) ;OS-CIA-B CRA
  and.b   #~(CIACRAF_START),d0 ;Timer A stoppen
  or.b    #CIACRAF_LOAD,d0   ;Zählwert laden
  move.b  d0,CIACRA(a5)
  nop
  move.b  CIATALO(a5),rd_old_CIABTALO(a3) ;OS-CIA-B TALO
  move.b  CIATAHI(a5),rd_old_CIABTAHI(a3) ;OS-CIA-B TAHI
  btst    #CIACRAB_RUNMODE,d1 ;Continuous-Modus ?
  bne.s   rd_ciab_ta_no_continuous ;Nein -> verzweige
  or.b    #CIACRAF_START,d1  ;Ja -> Timer A starten
rd_ciab_ta_no_continuous
  move.b  d1,CIACRA(a5)

  move.b  CIACRB(a5),d0
  move.b  d0,d1              
  move.b  d0,rd_old_ciab_crb_bits(a3) ;OS-CIA-B CRB
  and.b   #~(CIACRBF_ALARM-CIACRBF_START),d0 ;Timer B stoppen
  or.b    #CIACRBF_LOAD,d0   ;Zählwert laden
  move.b  d0,CIACRB(a5)
  nop
  move.b  CIATBLO(a5),rd_old_CIABTBLO(a3) ;OS-CIA-B TBLO
  move.b  CIATBHI(a5),rd_old_CIABTBHI(a3) ;OS-CIA-B TBHI
  btst    #CIACRBB_RUNMODE,d1 ;Continuous-Modus ?
  bne.s   rd_ciab_tb_no_continuous ;Nein -> verzweige
  or.b    #CIACRBF_START,d1  ;Ja -> Timer B starten
  move.b  d1,CIACRB(a5)
rd_ciab_tb_no_continuous
  CALLEXECQ Enable           ;Interrupts an

; ** Demo starten **
  CNOP 0,4
rd_run_demo
  IFEQ level_7_int_handler
    RP_SET_LEVEL_7_RESET_STATE ;Reset-Level-7-Interrupt aktivieren
  ENDC
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  cmp.b   #OCS,pqe_startmode(a0) ;Startmodus "OCS" ?
  beq.s   rd_no_caches_clear ;Ja -> verzweige
  CALLEXEC CacheClearU       ;Caches flushen
rd_no_caches_clear
  tst.w   rd_whdload_slave_active(a3) ;Handelt es sich um eine WHDLoad Slave-Datei ?
  beq.s   rd_execute_whdload_slave ;Ja -> verzweige
  move.l  rd_demofile_seglist(a3),a3 ;Zeiger auf SegList-Struktur
  add.l   a3,a3              ;Zeiger*4, da BCPL-Zeiger
  lea     rd_shell_cmd_line(pc),a0 ;Zeiger auf Command-Line
  add.l   a3,a3
  moveq   #1,d0              ;Command-Line-Länge = 1 Zeichen (Line-Feed)
  jsr     4(a3)              ;Demo ausführen
rd_demo_return
  lea     _CUSTOM+DMACONR,a0
  tst.w   (a0)               ;Wenn A1000/A2000-A dann CUSTOM-CHIP-Adresse lesen
rd_wait_blit
  btst    #DMAB_BLTDONE-8,(a0) ;Sicherheitshalber auf eventuell noch nicht beendete Blits warten
  bne.s   rd_wait_blit
  lea     variables(pc),a3   ;Basiszeiger auf alle Variablen
  tst.w   rd_reset_active(a3) ;Reset ausführen ?
  beq.s   rd_reboot          ;TRUE -> verzweige
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  tst.b   pqe_startmode(a0)  ;Startmodus "FAST" ?
  beq.s   rd_caches_clear    ;Ja  -> verzweige
  rts
  CNOP 0,4
rd_caches_clear
  CALLEXECQ CacheClearU      ;Caches flushen
  CNOP 0,4
rd_reboot
  CALLEXECQ ColdReboot       ;Reset ausführen

; ** WHDLoad Slavedatei ausführen **
  CNOP 0,4
rd_execute_whdload_slave
  lea     rd_whdload_slave_cmd_line(pc),a0
  move.l  a0,d1              ;Zeiger auf Kommandozeile
  moveq   #TRUE,d2           ;NULL = Kein Input
  moveq   #TRUE,d3           ;NULL = Kein Output
  CALLDOS Execute
  tst.l   d0                 ;Fehler aufgetreten ?
  beq.s   rd_execute_whdload_slave_error ;Ja -> verzweige
  CALLLIBS IoErr             
  tst.l   d0                 ;Hat die Ausführung der Kommandozeile einen Fehler ergeben ?
  bne.s   rd_execute_whdload_slave_error2 ;Ja -> verzweige
  bra.s   rd_demo_return
  CNOP 0,4
rd_execute_whdload_slave_error
  lea     rd_error_text24(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_error_text24_end-rd_error_text24,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
  moveq   #RETURN_ERROR,d0
rd_execute_whdload_slave_error2
  move.l  d0,DOS_return_code(a3)
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Wichtige Register löschen **
  CNOP 0,4
rd_clear_important_regs
  CALLEXEC Disable           ;Interrupts aus
  move.l  #_CUSTOM,a6        ;CUSTOM
  move.w  #$7fff,d0          ;Bits 0-14 löschen
  move.w  d0,DMACON(a6)      ;DMA aus
  move.l  #_CIAB,a5          ;CIA-B-Base
  move.w  d0,INTENA(a6)      ;Interrupts aus
  lea     _CIAA-_CIAB(a5),a4 ;CIA-A-Base
  move.w  d0,INTREQ(a6)      ;Interrupts löschen
  move.w  d0,ADKCON(a6)      ;ADKCON löschen

  moveq   #0,d0
  move.w  d0,COPCON(a6)      ;Copper kann nicht auf Blitterregister zugreifen
  move.w  d0,AUD0VOL(a6)     ;Lautstärke aus
  move.w  d0,AUD1VOL(a6)
  move.w  d0,AUD2VOL(a6)
  move.w  d0,AUD3VOL(a6)

  moveq   #$7f,d0
  move.b  d0,CIAICR(a4)      ;CIA-A-Interrupts aus
  move.b  d0,CIAICR(a5)      ;CIA-B-Interrupts aus
  move.b  CIAICR(a4),d0      ;CIA-A-Interrupts löschen
  move.b  CIAICR(a5),d0      ;CIA-B-Interrupts löschen
  rts

; ** Inhalt der Hardware-Register wieder herstellen **
; ----------------------------------------------------
  CNOP 0,4
rd_restore_hardware_regs
  move.b  rd_old_CIAAPRA(a3),CIAPRA(a4) ;Alter Inhalt von CIA-A-PRA

  move.b  rd_old_CIAATALO(a3),CIATALO(a4) ;Alter Inhalt von CIA-A TALO
  nop
  move.b  rd_old_CIAATAHI(a3),CIATAHI(a4) ;Alter Inhalt von CIA-A TAHI

  move.b  rd_old_CIAATBLO(a3),CIATBLO(a4) ;Alter Inhalt von CIA-A TBLO
  nop
  move.b  rd_old_CIAATBHI(a3),CIATBHI(a4) ;Alter Inhalt von CIA-A TBHI

  move.b  rd_old_CIAAICR(a3),d0
  tas     d0                 ;Bit 7 ggf. setzen
  move.b  d0,CIAICR(a4)      ;OS-CIA-A-ICR

  move.b  rd_old_ciaa_cra_bits(a3),d0  ;Alter Inhalt von CIA-A CRA
  btst    #CIACRAB_RUNMODE,d0 ;Continuous-Modus ?
  bne.s   rd_ciaa_ta_no_continuous2 ;Nein -> verzweige
  or.b    #CIACRAF_START,d0  ;Ja -> Timer A starten
rd_ciaa_ta_no_continuous2
  move.b  d0,CIACRA(a4)

  move.b  rd_old_ciaa_crb_bits(a3),d0  ;Alter Inhalt von CIA-A CRB
  btst    #CIACRBB_RUNMODE,d0 ;Continuous-Modus ?
  bne.s   rd_ciaa_tb_no_continuous2 ;Nein -> verzweige
  or.b    #CIACRBF_START,d0  ;Ja -> Timer B starten
rd_ciaa_tb_no_continuous2
  move.b  d0,CIACRB(a4)

  move.b  rd_old_CIABPRB(a3),CIAPRB(a5) ;Alter Inhalt von CIA-B-PRB

  move.b  rd_old_CIABTALO(a3),CIATALO(a5) ;Alter Inhalt von CIA-B TALO
  nop
  move.b  rd_old_CIABTAHI(a3),CIATAHI(a5) ;Alter Inhalt von CIA-B TAHI

  move.b  rd_old_CIABTBLO(a3),CIATBLO(a5) ;Alter Inhalt von CIA-B TBLO
  nop
  move.b  rd_old_CIABTBHI(a3),CIATBHI(a5) ;Alter Inhalt von CIA-B TBHI

  move.b  rd_old_CIABICR(a3),d0
  tas     d0                 ;Bit 7 ggf. setzen
  move.b  d0,CIAICR(a5)      ;OS-CIA-B-ICR

  move.b  rd_old_ciab_cra_bits(a3),d0  ;Alter Inhalt von CIA-B CRA
  btst    #CIACRAB_RUNMODE,d0 ;Continuous-Modus ?
  bne.s   rd_ciab_ta_no_continuous2 ;Nein -> verzweige
  or.b    #CIACRAF_START,d0  ;Ja -> Timer A starten
rd_ciab_ta_no_continuous2
  move.b  d0,CIACRA(a5)

  move.b  rd_old_ciab_crb_bits(a3),d0  ;Alter Inhalt von CIA-B CRB
  btst    #CIACRBB_RUNMODE,d0 ;Continuous-Modus ?
  bne.s   rd_ciab_tb_no_continuous2 ;Nein -> verzweige
  or.b    #CIACRBF_START,d0  ;Ja -> Timer B starten
rd_ciab_tb_no_continuous2
  move.b  d0,CIACRB(a5)

  move.l  rd_old_COP2LC(a3),COP2LCH(a6) ;2. OS-Copperliste
  move.l  rd_old_COP1LC(a3),COP1LCH(a6) ;1. OS-Copperliste
  moveq   #0,d0
  move.w  d0,COPJMP1(a6)

  move.w  rd_old_DMACON(a3),d0 ;OS-DMA
  or.w    #DMAF_SETCLR,d0    ;Bit 15 ggf. setzen
  move.w  d0,DMACON(a6)      ;OS-DMA
  move.w  rd_old_INTENA(a3),d0 ;OS-INTENA
  or.w    #INTF_SETCLR,d0    ;Bit 15 ggf. setzen
  move.w  d0,INTENA(a6)      ;OS-INTENA
  move.w  rd_old_ADKCON(a3),d0 ;OS-ADKCON
  or.w    #ADKF_SETCLR,d0    ;Bit 15 ggf. setzen
  move.w  d0,ADKCON(a6)      ;OS-ADKCON
  CALLEXECQ Enable           ;Interrupts an

; ** Ggf. VBR wiederherstellen, Caches und MMU aktivieren **

  CNOP 0,4
rd_upgrade_CPU
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  tst.b   pqe_startmode(a0)  ;Startmodus "FAST" ?
  beq.s   rd_no_upgrade_CPU  ;Ja -> verzweige
rd_restore_VBR
  move.l  _SysBase(pc),a6   ;Zeiger auf Exec-Base
  move.l  rd_old_VBR(a3),d0  ;Alter Inhalt des VBR
  beq.s   rd_activate_caches_MMU ;Wenn NULL -> verzweige
  lea     rd_write_VBR(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
rd_activate_caches_MMU
  tst.b   AttnFlags+1(a6)    ;68060?
  bmi.s   rd_activate_060_superscalar_caches_MMU ;Ja -> verzweige
; ** 68030-68040 **
rd_activate_caches
  moveq   #FALSE,d0          ;Alle Bits setzen
  move.l  rd_old_CACR(a3),d1 ;Alter Inhalt von CACR
  CALLLIBS CacheControl      ;CPU neu konfigurieren und Caches flushen
; ** 68030-68040 **
rd_activate_MMU
  btst    #AFB_68040,AttnFlags+1(a6) ;68040?
  bne.s   rd_activate_040_MMU ;Ja -> verzweige
  btst    #AFB_68030,AttnFlags+1(a6) ;68030?
  bne.s   rd_activate_030_MMU ;Ja -> verzweige
rd_no_upgrade_CPU
  rts
  CNOP 0,4
rd_activate_030_MMU
  lea     rd_CPU030_MMU_on(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBQ Supervisor
  CNOP 0,4
rd_activate_040_MMU
  movem.l rd_old_TC(a3),d0-d4 ;Alter Inhalt von TC,DTT0,DTT1,ITT0 und ITT1-Registern
  lea     rd_CPU040_060_MMU_on(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBQ Supervisor

  CNOP 0,4
; ** 68060 **
rd_activate_060_superscalar_caches_MMU
  move.l  rd_old_PCR(a3),d1  ;Alter Inhalt des PCR-Registers
  lea     rd_CPU060_superscalar_on(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
rd_activate_060_caches
  move.l  rd_old_CACR(a3),d1   ;Alter Inhalt des CACR-Registers
  lea     rd_CPU060_caches_on(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor
rd_activate_060_MMU
  movem.l rd_old_TC(a3),d0-d4 ;Alter Inhalt von TC,DTT0,DTT1,ITT0 und ITT1-Registern
  lea     rd_CPU040_060_MMU_on(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBQ Supervisor

; ** 68060 parallele Verarbeitung an **
; d1 ... alter Inhalt von PCR
rd_CPU060_superscalar_on
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  DC.L    $4e7b1808          ;movec.l d1,PCR: Alter Inhalt von PCR
  nop
  rte

; ** 68040/060-MMU an **
; d0 ... alter Inhalt von TC
; d1 ... alter Inhalt von DTT0
; d2 ... alter Inhalt von DTT1
; d3 ... alter Inhalt von ITT0
; d4 ... alter Inhalt von ITT1
  CNOP 0,4
rd_CPU040_060_MMU_on
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  movec.l d1,DTT0            ;Alter Inhalt des DTT0-Registers
  nop
  movec.l d2,DTT1            ;Alter Inhalt des DTT1-Registers
  nop
  movec.l d3,ITT0            ;Alter Inhalt des ITT0-Registers
  nop
  movec.l d4,ITT1            ;Alter Inhalt des ITT1-Registers
  nop
  PFLUSHA                    ;ATC-Einträge flushen
  nop
  movec.l d0,TC              ;Alter Inhalt des TC-Registers - MMU an
  nop
  rte
  
  ; ** 68030-MMU an **
    MC68030
  ; a3 ... Zeiger auf Variablen-Basis der alten Register-Inhalte
  CNOP 0,4
rd_CPU030_MMU_on
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  PMOVE   rd_old_030_TT0(a3),TT0 ;Alter Inhalt des TT0-Registers
  nop
  PMOVE   rd_old_030_TT1(a3),TT1 ;Alter Inhalt des TT1-Registers
  nop
  PFLUSHA                    ;ATC-Einträge flushen
  nop
  PMOVE   rd_old_030_TC(a3),TC ;Alter Inhalt des TC-Registers - MMU an
  nop
  rte

; ** 68060-Caches an **
  MC68040
; d1 ... alter Inhalt von CACR
  CNOP 0,4
rd_CPU060_caches_on
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  CPUSHA  BC                 ;Instruction/Data/Branch-Caches flushen
  nop
  movec.l d1,CACR            ;(Instruction)/Data/Branch-Caches an
  nop
  rte

; ** Eigene Trap-Vektoren wieder herstellen **
  CNOP 0,4
rd_restore_own_trap_vectors
  move.l  rd_old_VBR(a3),d0  ;VBR-Inhalt
  beq.s   rd_restore_CHIPMEM_trap_vectors2
rd_restore_FASTMEM_trap_vectors2
  move.l  d0,a1              ;Ziel FASTMEM
  add.w   #TRAP_0_VECTOR,a1  ;Ab Trap0-Vektor
  bsr.s   rd_copy_own_trap_vectors
rd_restore_CHIPMEM_trap_vectors2
  move.w  #TRAP_0_VECTOR,a1  ;Ab Trap0-Vektor
  bsr.s   rd_copy_own_trap_vectors
  CALLEXECQ CacheClearU       ;Caches flushen

  CNOP 0,4
rd_copy_own_trap_vectors
  move.l  rd_own_trap_vectors(a3),a0 ;Eigene Trap-Vektoren
  IFNE level_7_int_handler
    moveq   #7-1,d7            ;Anzahl der Trap-Vektoren
  ENDC
  IFEQ level_7_int_handler
    moveq   #8-1,d7            ;Anzahl der Trap-Vektoren
  ENDC
rd_copy_own_trap_vectors_loop
  move.l  (a0)+,(a1)+         ;Vektor kopieren
  dbf     d7,rd_copy_own_trap_vectors_loop
  rts

; ** Dummy-Screen wieder darstellen **
  CNOP 0,4
rd_restore_display
  sub.l    a1,a1             ;Kein Display
  CALLGRAF LoadView
  CALLLIBS WaitTOF           ;Auf Vertical Blank warten
  CALLLIBS WaitTOF           ;Bei Interlace
  move.l   rd_old_view(a3),a1 ;Alten View laden
  CALLLIBS LoadView
  CALLLIBS WaitTOF           ;Auf Vertical Blank warten
  CALLLIBQ WaitTOF           ;Bei Interlace

; ** String für die serielle Ausgabe initialisieren **
; ----------------------------------------------------
  CNOP 0,4
rd_init_ser_output_string2
  lea     rd_ser_output_string_number(pc),a0 ;Stringadresse
  moveq   #TRUE,d1           ;Sekundenwert = NULL = Timer stoppen
  moveq   #5,d7              ;Stringlänge = Anzahl der Stellen zum Umwandeln
  bsr     rp_dec_to_ascii
  lea     rd_ser_output_string(pc),a0 ;Zeiger auf Ausgabe-String
  moveq   #rd_ser_output_string_checksum-rd_ser_output_string,d7 Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
  bsr     rp_get_ascii_checksum
  bsr     rp_dec_to_hex
  lea     rd_ser_output_string_checksum(pc),a0 ;Zeiger auf String
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bra     rp_hex_to_ascii

; ** Screen einblenden **
  CNOP 0,4
rd_fade_in_screen
  tst.w   rd_nofader_active(a3) ;Wurde Argument "NOFADER" angegeben ?
  beq.s   rd_no_fade_in_screen ;Ja -> verzweige
  move.l  rd_WindowTagList+4(pc),a2 ;Zeiger auf PAL-Screen
rd_sfi_wait_fade_in
  CALLGRAF WaitTOF
  bsr.s   rd_sfi_screenfader_in
  bsr     rd_sf_set_new_scr_colors
  tst.w   rd_sfi_active(a3)
  beq.s   rd_sfi_wait_fade_in
rd_no_fade_in_screen
  rts

; ** Farben einblenden **
  CNOP 0,4
rd_sfi_screenfader_in
  move.l  rd_sf_color_cache32(a3),a0 ;Puffer für Farbwerte
  move.w  #rd_sfi_fader_speed,a4 ;Additions-/Subtraktionswert für RGB-Werte
  move.l  rd_sf_color_values32(a3),a1 ;Sollwerte
  move.w  #256*3,d6          ;Anzahl der Farbwerte*3 = Zähler
  MOVEF.W 256-1,d7           ;Anzahl der Farbwerte
rd_sfi_fader_loop
  moveq   #0,d0
  move.b  (a0),d0            ;8-Bit Rot-Istwert
  moveq   #TRUE,d1
  move.b  4(a0),d1           ;8-Bit Grün-Istwert
  moveq   #TRUE,d2
  move.b  8(a0),d2           ;8-Bit Blau-Istwert
  moveq   #TRUE,d3
  move.b  (a1),d3            ;8-Bit Rot-Sollwert
  moveq   #TRUE,d4
  move.b  4(a1),d4           ;8-Bit Grün-Sollwert
  moveq   #TRUE,d5
  move.b  8(a1),d5           ;8-Bit Blau-Sollwert

; ** Ist-Rotwert mit Soll-Rotwert vergleichen **
  cmp.w   d0,d3              ;Ist-Rotwert mit Soll-Rotwert vergleichen
  blt.s   rd_sfi_decrease_red_value ;Wenn Ist-Rotwert < Soll-Rotwert -> verzweige
  bgt.s   rd_sfi_increase_red_value ;Wenn Ist-Rotwert > Soll-Rotwert -> verzweige
  subq.w  #1,d6              ;Zähler verringern
rd_sfi_rt_fader_loop1

; ** Ist-Grünwert mit Soll-Grünwert vergleichen **
  cmp.w   d1,d4              ;Ist-Grünwert mit Soll-Grünwert vergleichen
  blt.s   rd_sfi_decrease_green_value ;Wenn Ist-Grünwert < Soll-Grünwert -> verzweige
  bgt.s   rd_sfi_increase_green_value ;Wenn Ist-Grünwert > Soll-Grünwert -> verzweige
  subq.w  #1,d6              ;Zähler verringern
rd_sfi_rt_fader_loop2

; ** Ist-Blauwert mit Soll-Blauwert vergleichen **
  cmp.w   d2,d5              ;Ist-Blauwert mit Soll-Blauwert vergleichen
  blt.s   rd_sfi_decrease_blue_value ;Wenn Ist-Blauwert < Soll-Blauwert -> verzweige
  bgt.s   rd_sfi_increase_blue_value ;Wenn Ist-Blauwert > Soll-Blauwert -> verzweige
  subq.w  #1,d6              ;Zähler verringern
rd_sfi_rt_fader_loop3
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d0,(a0)+           ;8-Bit Rotwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d1,(a0)+           ;8-Bit Grünwert in Cache schreiben
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  addq.w  #8,a1              ;nächstes 32-Bit-Tripple (4*3)
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  addq.w  #4,a1              
  move.b  d2,(a0)+           ;8-Bit Blauwert in Cache schreiben
  dbf     d7,rd_sfi_fader_loop
  tst.w   d6                 ;Fertig mit ausblenden ?
  bne.s   rd_sfi_not_finished ;Nein -> verzweige
  moveq   #FALSE,d0
  move.w  d0,rd_sfi_active(a3) ;Fading-In aus
rd_sfi_not_finished
  CALLEXEC CacheClearU       ;Caches flushen
rd_sfi_no_screenfader_in
  rts
  CNOP 0,4
rd_sfi_decrease_red_value
  sub.w   a4,d0              ;Rotanteil verringern
  cmp.w   d0,d3              ;Ist-Rotwert > Soll-Rotwert ?
  blt.s   rd_sfi_rt_fader_loop1 ;Ja -> verzweige
  move.w  d3,d0              ;Ist-Rotwert <= Soll-Rotwert
  bra.s   rd_sfi_rt_fader_loop1
  CNOP 0,4
rd_sfi_increase_red_value
  add.w   a4,d0              ;Rotanteil erhöhen
  cmp.w   d0,d3              ;Ist-Rotwert <= Soll-Rotwert ?
  bgt.s   rd_sfi_rt_fader_loop1 ;Ja -> verzweige
  move.w  d3,d0              ;Ist-Rotwert >= Soll-Rotwert
  bra.s   rd_sfi_rt_fader_loop1
  CNOP 0,4
rd_sfi_decrease_green_value
  sub.w   a4,d1              ;Grünanteil verringern
  cmp.w   d1,d4              ;Ist-Grünwert > Soll-Grünwert ?
  blt.s   rd_sfi_rt_fader_loop2 ;Ja -> verzweige
  move.w  d4,d1              ;Ist-Grünwert <= Soll-Grünwert
  bra.s   rd_sfi_rt_fader_loop2
  CNOP 0,4
rd_sfi_increase_green_value
  add.w   a4,d1              ;Grünanteil erhöhen
  cmp.w   d1,d4              ;Ist-Grünwert < Soll-Grünwert ?
  bgt.s   rd_sfi_rt_fader_loop2 ;Ja -> verzweige
  move.w  d4,d1              ;Ist-Grünwert >= Soll-Grünwert
  bra.s   rd_sfi_rt_fader_loop2
  CNOP 0,4
rd_sfi_decrease_blue_value
  sub.w   a4,d2              ;Blauanteil verringern
  cmp.w   d2,d5              ;Ist-Blauwert > Soll-Blauwert ?
  blt.s   rd_sfi_rt_fader_loop3 ;Ja -> verzweige
  move.w  d5,d2              ;Ist-Blauwert <= Soll-Blauwert
  bra.s   rd_sfi_rt_fader_loop3
  CNOP 0,4
rd_sfi_increase_blue_value
  add.w   a4,d2              ;Blauanteil erhöhen
  cmp.w   d2,d5              ;Ist-Blauwert < Soll-Blauwert ?
  bgt.s   rd_sfi_rt_fader_loop3 ;Ja -> verzweige
  move.w  d5,d2              ;Ist-Blauwert >= Soll-Blauwert
  bra.s   rd_sfi_rt_fader_loop3

; ** Dummy-Window schließen **
  CNOP 0,4
rd_close_dummy_window
  move.l  rd_dummy_window(a3),a0 ;Zeiger auf Fenster
  CALLINTQ CloseWindow

; ** Alte Sprite-Auflösung setzen **
  CNOP 0,4
rd_restore_sprite_resolution
  move.l  rd_WindowTagList+4(pc),a2 ;Zeiger auf PAL-Screen
  lea     rd_VideoControlTagList2(pc),a1 ;Zeiger auf Tagliste
  move.l  sc_ViewPort+vp_ColorMap(a2),a0 ;Zeiger auf ColorMap-Struktur
  move.l  rd_old_sprite_resolution(a3),ti_data(a1) ;Sprite-Auflösung 
  CALLGRAFQ VideoControl      ;Sprite-Auflösung zurücksetzen

; ** PAL-Screen schließen **
  CNOP 0,4
rd_close_PAL_screen
  move.l  rd_WindowTagList+4(pc),a0 ;Zeiger auf PAL-Screen
  CALLINTQ CloseScreen

; ** Altes aktuelles Verzeichnis wieder setzen **
  CNOP 0,4
rd_set_old_current_dir
  move.l  rd_old_current_dir_lock(a3),d1
  CALLDOSQ CurrentDir

; ** Demo-Verzeichnis wieder freigeben **
  CNOP 0,4
rd_unlock_demo_directory
  move.l  rd_demo_dir_lock(a3),d1
  CALLDOSQ Unlock

; ** Demo wieder aus Speicher entfernen **
  CNOP 0,4
rd_unload_demo
  move.l  rd_demofile_seglist(a3),d1 ;Zeiger 
  beq.s   rd_no_unload_demo  ;Wenn NULL -> verzweige
  CALLDOSQ UnLoadSeg
  CNOP 0,4
rd_no_unload_demo
  rts

; ** FAST-Memory ggf. wieder freigeben **
  CNOP 0,4
rd_free_FAST_memory
  move.l  rd_demo_filepath(a3),a0 ;Zeiger auf Eintrag in Playback-Queue
  tst.b   pqe_startmode(a0)  ;Startmodus "FAST" ?
  beq.s   rd_no_free_FAST_memory ;Ja -> verzweige
rd_turn_on_FAST_memory
  move.l  rd_largest_FASTmem_block_pointer(a3),d2 ;Zeiger auf ersten größten Block
  beq.s   rd_no_free_FAST_memory ;Wenn NULL -> verzweige
  move.l  _SysBase(pc),a6   ;Zeiger auf Exec-Base
  move.l  d2,a2              
turn_on_FAST_memory_loop
  move.l  (a2)+,d0           ;Größe des Speicherbereichs 
  beq.s   free_first_FASTmem_block ;Wenn NULL -> verzweige
  move.l  (a2)+,a1           ;Zeiger auf Speicherbereich
  CALLLIBS FreeMem           ;Speichebereich freigeben
  bra.s   turn_on_FAST_memory_loop
  CNOP 0,4
rd_no_free_FAST_memory
  rts
  CNOP 0,4
free_first_FASTmem_block
  move.l  d2,a1              ;Zeiger auf ersten größten Block
  move.l  rd_largest_FASTmem_block_size(a3),d0 ;Größe des ersten größten Blocks
  CALLLIBQ FreeMem

; ** Überprüfen, ob alle Tags der Dateipfade gesetzt sind **

  CNOP 0,4
rd_check_demofile_pathtags
  move.l  entries_buffer(a3),a0 ;Zeiger auf Puffer für Einträge
  ADDF.W  pqe_tag_active,a0   ;Tag-Status
  move.w  entries_num(a3),d7 ;Anzahl der Einträge
  MOVEF.L playback_queue_entry_size,d0
  subq.w  #1,d7              ;-1 wegen dbf
rd_check_demofile_pathtags_loop
  tst.b   (a0)               ;Tag-Status nicht gesetzt ?
  beq.s   rd_not_all_demofile_pathtags_set ;Ja -> verzweige
  add.l   d0,a0              ;nächster Eintrag
  dbf     d7,rd_check_demofile_pathtags_loop
rd_all_demofile_pathtags_set
  tst.w   rd_endless_play_active(a3) ;Endlosschleife aktiviert ?
  beq.s   rd_remove_tags     ;Ja -> verzweige
rd_no_more_demos_left
  clr.w   rd_remove_reset_prg_active(a3) ;TRUE = Reset-Prg entfernen
  moveq   #RETURN_WARN,d0
  move.l  d0,DOS_return_code(a3)
  lea     rd_message_text2(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_message_text2_end-rd_message_text2,d0 ;Textlänge
  bra     print_text         ;Text ausgeben
  CNOP 0,4
rd_remove_tags
  move.l  entries_buffer(a3),a0 ;Zeiger auf Puffer für Einträge
  moveq   #0,d0
  add.w   #pqe_tag_active,a0  ;Tag-Status
  move.w  entries_num(a3),d7 ;Anzahl der Einträge
  MOVEF.L playback_queue_entry_size,d1
  subq.w  #1,d7              ;-1 wegen dbf
rd_remove_tags_loop
  move.b  d0,(a0)            ;Tag-Status löschen
  add.l   d1,a0              ;nächster Eintrag
  dbf     d7,rd_remove_tags_loop
  RP_GET_ENTRIES_OFFSET      ;Zeiger auf Variable rp_entries_offset  -> a0
  moveq   #0,d0
  move.w  d0,(a0)            ;Variable rp_entries_offset zurücksetzen
rd_not_all_demofile_pathtags_set
  rts

; ** Endlosschleifenmodus prüfen **
  CNOP 0,4
rd_check_loop_active
  tst.w   rd_loop_play_active(a3) ;Schleifenmodus (Argument LOOP) an ?
  bne.s   rd_no_replay_loop  ;FALSE -> verzweige
  tst.w   rd_remove_reset_prg_active(a3) ;Reset-Prg entfernen ?
  beq.s   rd_no_replay_loop  ;TRUE -> verzweige
rd_check_errors
  moveq   #RETURN_FAIL,d0
  cmp.l   DOS_return_code(a3),d0 ;Fehlernummer = 20 ?
  beq.s   rd_no_replay_loop  ;Ja -> verzweige
  moveq   #ERROR_FILE_NOT_OBJECT,d0
  cmp.l   DOS_return_code(a3),d0 ;Fehlernummer > 121 ?
  blt.s   rd_no_replay_loop  ;Ja -> verzweige
rd_check_loop_break
  moveq   #0,d0           ;New Signals = NULL
  moveq   #TRUE,d1           ;Signal Mask = NULL
  CALLEXEC SetSignal
  btst    #SIGBREAKB_CTRL_C,d0 ;CRTL-C pressed ?
  bne.s   rd_stop_loop       ;Yes -> skip
rd_reset_variables
  moveq   #TRUE,d0           ;Returncode = OK
  move.l  d0,DOS_return_code(a3) ;Fehlercode zurücksetzen
  move.l  d0,rd_demofile_seglist(a3) ;Zeiger auf Demodatei-Segmentliste auf NULL setzen
  move.l  d0,rd_prerunscript_path(a3) ;Zeiger auf Prerunscript-Pfad auf NULL setzen
  moveq   #FALSE,d1
  move.w  d1,rd_WHDLoad_slave_active(a3) ;FALSE = Demo als normales Executable starten
  tst.w   rd_nofader_active(a3) ;Wurde Argument "NOFADER" angegeben ?
  beq.s   rd_no_fader         ;Ja -> verzweige
  move.w  d0,rd_sfo_active(a3) ;TRUE = Fader-Out wieder aktivieren
  move.w  d0,rd_sfi_active(a3) ;TRUE = Fader-In wieder aktivieren
rd_no_fader
  rts
  CNOP 0,4
rd_stop_loop
  lea     rd_message_text4(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_message_text4_end-rd_message_text4,d0 ;Textlänge
  bsr     print_text         ;Text ausgeben
rd_no_replay_loop
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Speicher für 32-Bit-RGB-Werte Colourcache freigeben **
  CNOP 0,4
rd_sf_free_color_cache_mem
  move.l  rd_sf_color_cache32(a3),a1 ;Zeiger auf Speicherbereich
  move.l  #256*4*3,d0        ;Größe der Speicherbereiches
  CALLEXECQ FreeMem          ;Speicher freigeben

; ** Speicher für 32-Bit-RGB-Werte der Screenfarben freigeben **

  CNOP 0,4
rd_sf_free_color_values_mem
  move.l  rd_sf_color_values32(a3),a1 ;Zeiger auf Speicherbereich
  move.l  #256*4*3,d0        ;Größe der Speicherbereiches
  CALLEXECQ FreeMem          ;Speicher freigeben

; ** Speicher für Sprite-Data-Struktur freigeben **
  CNOP 0,4
rd_free_sprite_data_structure
  move.l  rd_sprite_data_structure(a3),a1 ;Zeiger auf Speicherbereich
  moveq   #6*2,d0            ;Größe der Speicherbereiches
  CALLEXECQ FreeMem          ;Speicher freigeben

; ** Serial-Device schließen **
  CNOP 0,4
rd_close_ser_device
  lea     rd_ser_request_structure(pc),a1 ;Zeiger auf Serial-Request-Struktur
  CALLEXECQ CloseDevice

; ** Serial-Message-Port löschen **
  CNOP 0,4
rd_delete_ser_msg_port
  move.l  rd_ser_msg_port(a3),a0
  CALLEXECQ DeleteMsgPort

; ** Icon-Libary schließen **
  CNOP 0,4
rd_close_icon_lib
  move.l  _IconBase(pc),a1   ;Zeiger auf Icon-Base -> a1
  CALLEXECQ CloseLibrary     ;Icon-Library schließen

; ** Reset-Programm ggf. aus dem Speicher entfernen **
; ----------------------------------------------------
  CNOP 0,4
rd_remove_reset_prg
  tst.w   rd_remove_reset_prg_active(a3) ;Reset-Prg entfernen ?
  bne.s   rd_no_remove_reset_prg ;FALSE -> verzweige
  RP_GET_RESET_PRG_size      ;Inhalt der Variable rp_reset_prg_size  -> d0
  move.l  rd_reset_prg_mem(a3),a1 ;Zeiger auf Speicherbereich des Resetprogramms
  CALLEXEC FreeMem           ;Speicher freigeben
  lea     rd_message_text3(pc),a0 ;Zeiger auf Fehlertext
  moveq   #rd_message_text3_end-rd_message_text3,d0 ;Textlänge
  bra     print_text         ;Text ausgeben
  CNOP 0,4
rd_no_remove_reset_prg
  rts


; ** Reset-Programm **
  CNOP 0,4
rp_reset_prg
  bra.s   rp_skip_ID         ;Kennung überspringen
  DC.B "DL"                  ;Kennung "DL"
rp_skip_ID
  movem.l d0-d7/a0-a6,-(a7)
  move.l  #_CUSTOM,a5
  move.w  #%0000111100000000,POTGO(a5) ;Standart-Wert setzen
  moveq   #5,d2              ;5 Rasterzeilen (~320 µs) warten
  bsr     rp_wait_rasterline
  btst    #2,POTINP(a5)      ;Wurde die rechte Maustaste gedrückt ?
  beq.s   rp_end2            ;Ja -> verzweige
  lea     _SysBase(pc),a0
  move.l  exec_base.w,(a0)   ;Zeiger auf Exec-Base retten
  bsr     rp_init_ser_output_string
  bsr     rp_stop_timer
  bsr     rp_check_demofile_pathtags
  tst.w   d0                 ;Sind alle Tags der Dateipfade gesetzt ?
  beq.s   rp_end2            ;TRUE -> verzweige
rp_reallocate_reset_prg_mem
  move.l  #(rp_reset_prg_end-rp_reset_prg),d0
  move.l  rp_reset_prg_mem(pc),a1 ;Adresse der Reset-Programms im Speicher
  moveq   #TRUE,d1           ;Muss sein!
  move.w  rp_entries_num_max(pc),d1 ;Maximale Anzahl der Einträge in Liste mit Dateipfaden
  MULUF.W playback_queue_entry_size,d1,d2 ;* Größe des Eintrags
  add.l   d1,d0              ;Programmlänge + Puffer für Einträge
  CALLLIBS AllocAbs          ;Speicher nochmals reservieren
  tst.l   d0                 ;Kein Speicher ?
  beq.s   rp_end             ;Ja -> verzweige
  move.w  #$068b,d3          ;RBG-Farbwert Blau = Okay
  bsr     rp_screen_colour_flash
  bsr     rp_restore_own_CoolCapture_vector
  bsr     rp_install_own_exception_vectors
  movem.l (a7)+,d0-d7/a0-a6
  rts
  CNOP 0,4
rp_end
  move.w  #$0d74,d3          ;RBG-Farbwert Orange = Kein Speicher für Reset-Routine oder anderer Fehler
  bsr     rp_screen_colour_flash
rp_end2
  bsr     rp_restore_CoolCapture_vector
  movem.l (a7)+,d0-d7/a0-a6
  rts

; ** x Rasterzeilen warten **
; d2 ... Anzahl der Rasterzeilen
  CNOP 0,4
rp_wait_rasterline
  subq.w  #1,d2              ;-1 wegen dbf
  move.l  #$0001ff00,d3      ;Maske für vertikale Position V0-V8 des Rasterstrahls
rp_wait_rasterline_loop
  move.w  VPOSR(a5),d0       ;VPOSR/VHPOSR getrennt auslesen wegen Übertrag-Bit V8
  swap    d0
  move.w  VHPOSR(a5),d0
  and.l   d3,d0              ;Nur vertikale Position
rp_wait_rasterline_subloop
  move.w  VPOSR(a5),d1       ;VPOSR/VHPOSR getrennt auslesen wegen Übertrag-Bit V8
  swap    d1
  move.w  VHPOSR(a5),d1
  and.l   d3,d1              ;Nur vertikale Position V0-V8
  cmp.l   d1,d0              ;Immer noch gleiche Zeile ?
  beq.s   rp_wait_rasterline_subloop ;Ja -> Schleife
  dbf     d2,rp_wait_rasterline_loop
  rts

; ** String für die serielle Ausgabe initialisieren **
; ----------------------------------------------------
  CNOP 0,4
rp_init_ser_output_string
  lea     rp_ser_output_string_number(pc),a0 ;Stringadresse
  moveq   #TRUE,d1           ;Sekundenwert = NULL = Timer stoppen
  moveq   #5,d7              ;Stringlänge = Anzahl der Stellen zum Umwandeln
  bsr.s   rp_dec_to_ascii
  lea     rp_ser_output_string(pc),a0 ;Zeiger auf Ausgabe-String
  moveq   #rp_ser_output_string_checksum-rp_ser_output_string,d7 Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
  bsr.s   rp_get_ascii_checksum
  bsr.s   rp_dec_to_hex
  lea     rp_ser_output_string_checksum(pc),a0 ;Zeiger auf String
  moveq   #2,d7              ;Anzahl der Stellen zum Umwandeln
  bra.s   rp_hex_to_ascii

; ** Dezimalzahl in ASCII-Zeichen umwandeln **
; a0 ... Stringadresse
; d1 ... Dezimalzahl
; d7 ... Anzahl der Stellen zum Umwandeln
  CNOP 0,4
rp_dec_to_ascii
  lea     rp_dec_tab(pc),a1  ;Stellentabelle
  ext.l   d1                 ;Auf 32 Bit erweitern (Wichtig!)
  lea     (a1,d7.w*4),a1     ;Erste Zehnerpotenz in Stellentabelle ermitteln
  subq.w  #1,d7              ;-1 wegen dbf
rp_dec_to_ascii_loop
  moveq   #FALSE,d3          ;Ziffer = -1
  move.l  -(a1),d2           ;Zehnerpotenz 10^n 
rp_dec_to_ascii_sub_loop
  addq.b  #1,d3              ;Ziffer erhöhen
  sub.l   d2,d1              ;Zehnerpotenz abziehen
  bcc.s   rp_dec_to_ascii_sub_loop ;Wenn kein Übertrag, dann verzweige
  add.b   #"0",d3            ;Ziffer -> ASCII-Zeichen
  add.l   d2,d1              ;Rest berichtigen
  move.b  d3,(a0)+           ;Zeichen in String schreiben
  dbf     d7,rp_dec_to_ascii_loop
  rts

; ** Checksumme aus den ersten 7 ASCII-Zeichen des Ausgabe-Strings bilden **
; a0 ... Zeiger auf String
; d0 ... Rückgabewert Checksumme
; d7 ... Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
  CNOP 0,4
rp_get_ascii_checksum
  moveq   #0,d0           ;Checksumme
  moveq   #TRUE,d1           ;Für Wort-Zugriff
  subq.w  #1,d7              ;-1 wegen dbf
rp_get_ascii_checksum_loop
  move.b  (a0)+,d1           ;ASCII-Wert
  add.w   d1,d0              ;ASCII-Wert dazuaddieren
  dbf     d7,rp_get_ascii_checksum_loop
  rts

; ** Dezimalzahl in Hexadezimalzahl umwandeln **
; d0 ... Dezimalzahl
; d1 ... Rückgabewert Hexadezimalzahl&$ff
  CNOP 0,4
rp_dec_to_hex
  ext.l   d0                 ;Auf 32 Bit erweitern (Wichtig!)
  moveq   #TRUE,d1           ;Ergebnis = Hexadezialzahl
  moveq   #16,d3             ;Hexadezimalzahl-Basis
  moveq   #TRUE,d4           ;1. Nibble-Shiftwert
rp_dec_to_hex_loop
  divu.w  d3,d0              ;/Hexbasis 16
  move.l  d0,d2              ;Ergebnis retten
  swap    d2                 ;Rest der Division 
  lsl.w   d4,d2              ;Nibble in richtige Position bringen
  addq.b  #4,d4              ;nächstes Nibble
  add.w   d2,d1              ;Nibble eintragen
  ext.l   d0                 ;Quotient auf 32 Bit erweitern
  bne.s   rp_dec_to_hex_loop ;Wenn Quotient <> NULL -> Schleife
  and.w   #$00ff,d1          ;Nur Bits 0-7 (lower Byte)
  rts

; ** Hexadezimalzahl in ASCII-Zeichen umwandeln **
; a0 ... Zeiger auf String
; d1 ... Hexadezimalzahl
; d7 ... Anzahl der Stellen zum Umwandeln
  CNOP 0,4
rp_hex_to_ascii
  add.l   d7,a0              ;Zeiger auf Ende des Strings
  ext.l   d1                 ;Auf 32 Bit erweitern (Wichtig!)
  subq.w  #1,d7              ;-1 wegen dbf
rp_hex_to_ascii_loop
  moveq   #$f,d0             ;Nibble-Maske
  and.b   d1,d0              ;Nur Low-Nibble
  add.b   #"0",d0            ;Ziffer -> ASCII-Zeichen
  cmp.b   #"9",d0            ;Zeichen <= "9" ?
  ble.s   rp_hex_to_ascii_ok  ;Ja -< verzweige
  add.b   #39,d0             ;10="a",11="b",...
rp_hex_to_ascii_ok
  lsr.l   #4,d1              ;nächstes Nibble
  move.b  d0,-(a0)           ;Zeichen in String schreiben
  dbf     d7,rp_hex_to_ascii_loop
  rts

; ** String auf seriellem Port ausgeben und Timer stoppen **

  CNOP 0,4
rp_stop_timer
  CALLEXEC Disable           ;Interrupts aus
  lea     rp_ser_output_string(pc),a0 ;Zeiger auf Ausgabe-String
  move.w  ADKCONR(a5),d3     ;Alten Inhalt von ADKCON retten
  move.w  #$0100,d1          ;8 Bits pro Zeichen beim Schreiben, 1 Stoppbit
  move.w  #ADKF_UARTBRK,ADKCON(a5) ;TXD löschen
  move.w  #SERDATRF_TBE,d2
  move.w  #(colourclock_PAL/baud)-1,SERPER(a5) ;Baudrate 2400 bps
  moveq   #(rp_ser_output_string_end-rp_ser_output_string)-1,d7 ;Anzahl der Bytes zum Schreiben
rp_write_string_loop
  move.w  SERDATR(a5),d0     ;SERDAT lesen
  and.w   d2,d0              ;TBE-Bit gesetzt ?
  beq.s   rp_write_string_loop ;Nein -> verzweige
  move.b  (a0)+,d1           ;Datenbyte D0-D7 kopieren
  move.w  d1,SERDAT(a5)      ;und Datenwort übertragen
  dbf     d7,rp_write_string_loop
  move.w  #$7fff,ADKCON(a5)  ;Alle Bits von ADKCON löschen
  or.w    #ADKF_SETCLR,d3    ;Bits setzen
  move.w  d3,ADKCON(a5)      ;Alter Inhalt von ADKCON
  CALLLIBQ Enable            ;Interrupts an

; ** Prüfen, ob alle Demos bereits gestartet wurden **
; ----------------------------------------------------
  CNOP 0,4
rp_check_demofile_pathtags
  lea     rp_entries_buffer+pqe_tag_active(pc),a0 ;Tag-Status
  move.w  rp_entries_num(pc),d7 ;Gesamtzahl der Dateipfade
  MOVEF.L playback_queue_entry_size,d0
  subq.w  #1,d7              ;-1 wegen dbf
rp_check_demofile_pathtags_loop
  tst.b   (a0)               ;Tag-Status nicht gesetzt ?
  beq.s   rp_not_all_demofile_pathtags_set ;Ja -> verzweige
  add.l   d0,a0              ;nächster Eintrag
  dbf     d7,rp_check_demofile_pathtags_loop
rp_all_demofile_pathtags_set
  move.w  rp_endless_play_active(pc),d0 ;Wurde das Argument ENDLESS angegeben ?
  beq.s   rp_remove_tags     ;Ja -> verzweige
  moveq   #TRUE,d0           ;Returncode = TRUE
  rts
  CNOP 0,4
rp_remove_tags
  lea     rp_entries_buffer+pqe_tag_active(pc),a0 ;Tag-Status
  moveq   #0,d0
  move.w  rp_entries_num(pc),d7 ;Anzahl der Dateipfade
  MOVEF.L playback_queue_entry_size,d1
  subq.w  #1,d7              ;-1 wegen dbf
rp_remove_tags_loop
  move.b  d0,(a0)            ;Tag-Status löschen
  add.l   d1,a0              ;nächster Eintrag
  dbf     d7,rp_remove_tags_loop
  lea     rp_entries_offset(pc),a0
  moveq   #0,d0
  move.w  d0,(a0)            ;Offset in Dateipfade-Tabelle zurücksetzen
rp_not_all_demofile_pathtags_set
  moveq   #FALSE,d0          ;Returncode = FALSE
  rts

; ** Playfieldschirm für kurze Zeit (x-mal 50 FPS) umfärben **
; d3 ... RBG-4-Bit Farbwert
  CNOP 0,4
rp_screen_colour_flash
  moveq   #$0001,d2          ;Maske für vertikale Position Bit 8
  moveq   #rp_delay_value-1,d7 ;Anzahl der Frames auf die gewartet wird
rp_delay_loop
  move.w  VPOSR(a5),d0       ;Rasterstrahlposition 
  and.w   d2,d0              ;Nur vertikale Position >=$100
rp_wait_tick
  move.w  d3,COLOR00(a5)     ;Hintergrundfarbe setzen
  move.w  VPOSR(a5),d1       ;Rasterstrahlposition 
  and.w   d2,d1              ;Nur vertikale Position >=$100
  cmp.w   d1,d0              ;Immer noch der gleiche Frame ?
  beq.s   rp_wait_tick       ;Ja -> Schleife
  dbf     d7,rp_delay_loop
  rts

; ** Eigenen CoolCapture-Vektor wieder herstellen **
  CNOP 0,4
rp_restore_own_CoolCapture_vector
  move.l  _SysBase(pc),a6
  moveq   #0,d0
  move.l  rp_reset_prg_mem(pc),CoolCapture(a6) ;Zeiger auf CoolCapture-Programm eintragen
; ** LowMemChkSum in Execbase berechnen **
rp_calculate_LowMemChkSum
  lea     SoftVer(a6),a0     ;Start-Abschnitt in Execbase
  moveq   #24-1,d1           ;Anzahl Worte, über die Checksumme gebildet wird
rp_calculate_LowMemChkSum_loop
  add.w   (a0)+,d0
  dbf     d1,rp_calculate_LowMemChkSum_loop
  not.w   d0                 ;Negieren
  move.w  d0,(a0)            ;Neue Checksumme eintragen
  CALLLIBQ CacheClearU       ;Caches flushen

; ** Eigene Exception-Vektoren installieren **
  CNOP 0,4
rp_install_own_exception_vectors
; ** VBR auslesen **
  lea     rp_read_VBR(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor        ;Routine ausführen
  lea     rp_old_VBR(pc),a1
  move.l  a0,(a1)            ;VBR retten
  IFEQ level_7_int_handler
    lea     rp_level_7_reset_active(pc),a1
    moveq   #FALSE,d0
    move.w  d0,(a1)            ;Sicherheitshalber auf FALSE setzen
; ** Neuen Level-7-Interrupt setzen **
    lea     rp_old_level_7_autovector(pc),a1
    move.l  LEVEL_7_AUTOVECTOR(a0),(a1) ;Zeiger auf alte Level-7 Interrupointeroutine retten
    lea     rp_level_7_prg(pc),a1
    move.l  a1,LEVEL_7_AUTOVECTOR(a0) ;Zeiger auf Level-7-Programm eintragen
  ENDC
; ** Neue TRAP #0-Routine setzen **
  lea     rp_old_trap_0_vector(pc),a1 ;Alte Trap-Vektoren
  lea     rp_own_trap_0_vector(pc),a2 ;Eigene Trap-Vektoren
  move.l  TRAP_0_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap0-routine retten
  lea     rp_trap_0_prg(pc),a4
  move.l  a4,TRAP_0_VECTOR(a0) ;Zeiger auf Trap0-Programm eintragen
  move.l  a4,(a2)+           ;Zeiger auf neue Trap0-routine retten
; ** Neue TRAP #1-Routine setzen **
  move.l  TRAP_1_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap1-routine retten
  lea     rp_trap_1_prg(pc),a4
  move.l  a4,TRAP_1_VECTOR(a0) ;Zeiger auf Trap1-Programm eintragen
  move.l  a4,(a2)+           ;Zeiger auf neue Trap1-routine retten
; ** Neue TRAP #2-Routine setzen **
  move.l  TRAP_2_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap2-routine retten
  lea     rp_trap_2_prg(pc),a4
  move.l  a4,TRAP_2_VECTOR(a0) ;Zeiger auf Trap2-Programm eintragen
  move.l  a4,(a2)+           ;Zeiger auf neue Trap2-routine retten
; ** Neue TRAP #3-Routine setzen **
  move.l  TRAP_3_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap3-routine retten
  lea     rp_trap_3_prg(pc),a4
  move.l  a4,TRAP_3_VECTOR(a0) ;Zeiger auf Trap3-Programm eintragen
  move.l  a4,(a2)+           ;Zeiger auf neue Trap3-routine retten
; ** Neue TRAP #4-Routine setzen **
  move.l  TRAP_4_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap4-routine retten
  lea     rp_trap_4_prg(pc),a4
  move.l  a4,TRAP_4_VECTOR(a0) ;Zeiger auf Trap4-Programm eintragen
  move.l  a4,(a2)+           ;Zeiger auf neue Trap4-routine retten
; ** Neue TRAP #5-Routine setzen **
  move.l  TRAP_5_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap5-routine retten
  lea     rp_trap_5_prg(pc),a4
  move.l  a4,TRAP_5_VECTOR(a0) ;Zeiger auf Trap5-Programm eintragen
  move.l  a4,(a2)+           ;Zeiger auf neue Trap5-routine retten
; ** Neue TRAP #6-Routine setzen **
  IFNE level_7_int_handler
    move.l  TRAP_6_VECTOR(a0),(a1) ;Zeiger auf alte Trap6-routine retten
  ENDC
  IFEQ level_7_int_handler
    move.l  TRAP_6_VECTOR(a0),(a1)+ ;Zeiger auf alte Trap6-routine retten
  ENDC
  lea     rp_trap_6_prg(pc),a4
  move.l  a4,TRAP_6_VECTOR(a0) ;Zeiger auf Trap6-Programm eintragen
  IFNE level_7_int_handler
    move.l  a4,(a2)            ;Zeiger auf neue Trap6-routine retten
  ENDC
  IFEQ level_7_int_handler
    move.l  a4,(a2)+           ;Zeiger auf neue Trap6-routine retten
  ENDC
  IFEQ level_7_int_handler
; ** Neue TRAP #7-Routine setzen **
    move.l  TRAP_7_VECTOR(a0),(a1) ;Zeiger auf alte Trap7-routine retten
    lea     rp_trap_7_prg(pc),a4
    move.l  a4,TRAP_7_VECTOR(a0) ;Zeiger auf Trap7-Programm eintragen
    move.l  a4,(a2)            ;Zeiger auf neue Trap7-routine retten
  ENDC
  CALLLIBQ CacheClearU       ;Caches flushen

; a0 ... Rückgabewert Inhalt von VBR
  CNOP 0,4
rp_read_VBR
  or.w    #SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
  nop
  movec.l VBR,a0             ;VBR -> a0
  nop
  rte

  IFEQ level_7_int_handler
; ** Level-7-Interrupointeroutine **
    CNOP 0,4
rp_level_7_prg
    movem.l d0-d1/a0-a1/a6,-(a7)
    move.w  rp_level_7_reset_active(pc),d0 ;Reset-Status = FALSE?
    bne.s   rp_no_reset        ;Ja -> verzweige
    move.l  _SysBase(pc),a6
    moveq   #0,d0
    move.l  d0,ColdCapture(a6) ;Ggf. ColdCapture-Vektor zurücksetzen
    move.l  rp_reset_prg_mem(pc),CoolCapture(a6) ;Zeiger auf CoolCapture-Programm eintragen
    move.l  d0,WarmCapture(a6) ;Ggf. WarmCapture-Vektor zurücksetzen
; ** LowMemChkSum in Execbase berechnen **
    moveq   #0,d0
    move.w  d0,LowMemChkSum(a6)
    lea     SoftVer(a6),a0     ;Start-Abschnitt in Execbase
    moveq   #24-1,d1           ;Anzahl Worte, über die Checksumme gebildet wird
rp_calculate_LowMemChkSum_loop
    add.w   (a0)+,d0
    dbf     d1,rp_calculate_LowMemChkSum_loop
    not.w   d0                 ;Negieren
    move.w  d0,(a0)            ;Neue Checksumme eintragen
    CALLLIBS CacheClearU       ;Caches flushen
    CALLLIBQ ColdReboot        ;Reset ausführen
    CNOP 0,4
rp_no_reset
    movem.l (a7)+,d0-d1/a0-a1/a6
    nop
    rte
  ENDC

; ** TRAP #0-Routine RP_GET_ENTRIES_NUM **
; a0 ... Rückgabe: Zeiger auf aktuelle Anzahl Einträge
  CNOP 0,4
rp_trap_0_prg
  lea     rp_entries_num(pc),a0 ;Aktuelle Anzahl Einträge
  nop
  rte

; ** TRAP #1-Routine RP_GET_ENTRIES_NUM_max **
; a0 ... Rückgabe: Zeiger auf maximale Anzahl an Einträgen in Liste mit Dateipfaden
  CNOP 0,4
rp_trap_1_prg
  lea     rp_entries_num_max(pc),a0 ;Maximale Anzahl an Einträgen in Liste mit Dateipfaden
  nop
  rte

; ** TRAP #2-Routine RP_GET_ENTRIES_OFFSET **
; a0 ... Rückgabe: Zeiger auf Offset in Liste mit Dateipfaden
  CNOP 0,4
rp_trap_2_prg
  lea     rp_entries_offset(pc),a0 ;Offset in Liste mit Dateipfaden
  nop
  rte

; ** TRAP #3-Routine RP_GET_ENTRIES_BUFFER **
; a0 ... Rückgabe: Zeiger auf Puffer für Dateipfade
  CNOP 0,4
rp_trap_3_prg
  lea     rp_entries_buffer(pc),a0 ;Zeiger auf Puffer für Dateipfade
  nop
  rte

; ** TRAP #4-Routine RP_GET_ENDLESS_PLAY_STATE **
; a0 ... Rückgabe: Zeiger auf den Status des Arguments ENDLESS
  CNOP 0,4
rp_trap_4_prg
  lea     rp_endless_play_active(pc),a0 ;Zeiger auf Variable
  nop
  rte

; ** TRAP #5-Routine RP_GET_OWN_TRAP_0_VECTOR **
; a0 ... Rückgabe: Zeiger auf eigene Trap-Vektoren
  CNOP 0,4
rp_trap_5_prg
  lea     rp_own_trap_0_vector(pc),a0
  nop
  rte

; ** TRAP #6-Routine RP_GET_RESET_PRG_size **
; d0 ... Rückgabe: Gesamtgröße des Reset-Programms
  CNOP 0,4
rp_trap_6_prg
  bsr.s   rp_restore_CoolCapture_vector  ;COOL-Capture-Vektor zurücksetzen
  bsr.s   rp_restore_exception_vectors ;Alte OS-Vektoren wieder setzen
  move.l  rp_reset_prg_size(pc),d0 ;Gesamtgröße des Reset-Programms
  nop
  rte

; ** CoolCapture-Vektor wieder zurücksetzen **
  CNOP 0,4
rp_restore_CoolCapture_vector
  move.l  _SysBase(pc),a6
  moveq   #0,d0
  move.l  d0,CoolCapture(a6) ;NULL = Zeiger auf Reset-Programm. entfernen
  bra     rp_calculate_LowMemChkSum

; ** Alte Exception-Vektoren wieder eintragen **
  CNOP 0,4
rp_restore_exception_vectors
  lea     rp_read_VBR(pc),a5 ;Zeiger auf Supervisor-Routine
  CALLLIBS Supervisor        ;Routine ausführen
  move.l  a0,d0              ;VBR = Null ?
  beq.s   rp_restore_CHIPMEM_trap_vectors ;Ja -> verzweige
rp_restore_FASTMEM_trap_vectors
  IFEQ level_7_int_handler
    move.l  rp_old_level_7_autovector(pc),LEVEL_7_AUTOVECTOR(a0) ;Zeiger alte Level-7-Interrptprogramm eintragen
  ENDC
  add.w   #TRAP_0_VECTOR,a0  ;Ab Trap0-Vektor
  bsr.s   rp_copy_old_trap_vectors
rp_restore_CHIPMEM_trap_vectors
  IFEQ level_7_int_handler
    sub.l   a0,a0            ;Adresse $00000000
    move.l  rp_old_level_7_autovector(pc),LEVEL_7_AUTOVECTOR(a0) ;Zeiger alte Level-7-Interrptprogramm eintragen
  ENDC
  move.w  #TRAP_0_VECTOR,a0  ;Ab Trap0-Vektor
  bsr.s   rp_copy_old_trap_vectors
  CALLEXECQ CacheClearU
                             ;Caches flushen
  CNOP 0,4
rp_copy_old_trap_vectors
  lea     rp_old_trap_0_vector(pc),a1 ;Alte Trap-Vektoren
  IFNE level_7_int_handler
    moveq   #7-1,d7            ;Anzahl der Trap-Vektoren
  ENDC
  IFEQ level_7_int_handler
    moveq   #8-1,d7            ;Anzahl der Trap-Vektoren
  ENDC
rd_copy_old_trap_vectors_loop
  move.l  (a1)+,(a0)+         ;Vektor kopieren
  dbf     d7,rd_copy_old_trap_vectors_loop
  rts

  IFEQ level_7_int_handler
; ** TRAP #8-Routine RP_SET_LEVEL_7_RESET_STATE **
    CNOP 0,4
rp_trap_8_prg
    lea     rp_level_7_reset_active(pc),a0
    clr.w   (a0)               ;Level-7-Interrupointeroutine aktivieren
    nop
    rte
  ENDC


; ## Reset-Programm Speicherstellen für Tabellen und Strukturen  ##


; ** Reset-Programm Tabellen und Strukturen **
;
; ** Stellentabelle für Dezimalzahlumwandlung **
  CNOP 0,4
rp_dec_tab
  DC.L 1,10,100,1000,10000


; ** Reset-Programm Speicherstellen **
_SysBase                 DC.L 0
rp_old_VBR                DC.L 0
rp_reset_prg_mem          DC.L 0
rp_reset_prg_size         DC.L 0

  IFEQ level_7_int_handler
rp_old_level_7_autovector DC.L 0
  ENDC
rp_old_trap_0_vector      DC.L 0
rp_old_trap_1_vector      DC.L 0
rp_old_trap_2_vector      DC.L 0
rp_old_trap_3_vector      DC.L 0
rp_old_trap_4_vector      DC.L 0
rp_old_trap_5_vector      DC.L 0
rp_old_trap_6_vector      DC.L 0
  IFEQ level_7_int_handler
rp_old_trap_7_vector      DC.L 0
  ENDC
rp_own_trap_0_vector      DC.L 0
rp_own_trap_1_vector      DC.L 0
rp_own_trap_2_vector      DC.L 0
rp_own_trap_3_vector      DC.L 0
rp_own_trap_4_vector      DC.L 0
rp_own_trap_5_vector      DC.L 0
rp_own_trap_6_vector      DC.L 0
  IFEQ level_7_int_handler
rp_own_trap_7_vector      DC.L 0
  ENDC
  IFEQ level_7_int_handler
rp_level_7_reset_active   DC.W 0
  ENDC

rp_entries_num            DC.W 0
rp_entries_num_max        DC.W 0
rp_entries_offset         DC.W 0
rp_endless_play_active    DC.W 0


; ** Reset-Programm Speicherstellen für Texte **
; ** String für serielle Übertragung **
rp_ser_output_string
  DC.B "#"                   ;Start-Kennung
rp_ser_output_string_number
  DS.B 5                     ;Dezimal-ASCII-Zahl mit fünf Stellen
rp_ser_output_string_comma
  DC.B ","                   ;Komma-ASCII-Zeichen
rp_ser_output_string_checksum
  DS.B 2                     ;Checksumme Hex-ASCII-Zahl mit zwei Stellen
rp_ser_output_string_line_feed
  DC.B 10                    ;Line-Feed
rp_ser_output_string_end
  EVEN

; ** Beginn Puffer für Dateipfade **
rp_entries_buffer

rp_reset_prg_end


;

; ** Tabellen und Strukturen allgemein **

; ** Easy-Struktur für CoolCapture-Abfrage **
  CNOP 0,4
CoolCapture_req_structure
  DS.B EasyStruct_sizeOF

; ** Ergebniswerte von ReadArgs() für Shell-Befehlszeile **
  CNOP 0,4
cmd_results_array_structure
  DS.B cmd_results_array_size


; ** DemoSelector Tabellen und Strukturen **

; ** Ergebniswerte von ReadArgs() für Playlist-Befehlszeile **
  CNOP 0,4
ds_playlist_results_array_structure
  DS.B ds_playlist_results_array_size

; ** Easy-Struktur für Introstart-Abfrage **
ds_startmode_req_structure
  DS.B EasyStruct_sizeOF

; ** Taglisten für den FileRequester **
  CNOP 0,4
ds_file_requester_taglist
  DS.B ti_sizeOF*11

ds_file_requester_use_taglist
  DS.B ti_sizeOF*2


; ** RunDemo Tabellen und Strukturen **

; ** IO-Request-Struktur für Serial-Device **
rd_ser_request_structure
  DS.B IOEXTSER_size

; ** 32-Bit-Werte für COLOR00 **
  CNOP 0,4
rd_color_table32
  DC.W 0                     ;Anzahl der Farben
  DC.W 0                     ;Ab welcher Farbe
rd_COLOR00_value32
  DS.L 3*1                   ;32-Bit RGB-Werte
  DC.L TRUE                  ;Ende der Tabelle

; ** ScreenTagList-Struktur **
rd_ScreenTagList
  DS.B ti_sizeOF*20

; ** WindowTagList-Struktur **
rd_WindowTagList
  DS.B ti_sizeOF*17

; ** VideoControl-TagList-Strukturen **
rd_VideoControlTagList1
  DS.B ti_sizeOF*2

rd_VideoControlTagList2
  DS.B ti_sizeOF*2

rd_VideoControlTagList3
  DS.B ti_sizeOF*3


; ** Speicherstellen allgemein **
_DOSBase       DC.L 0
_GfxBase       DC.L 0
_IntuitionBase DC.L 0
_ASLBase       DC.L 0
_IconBase      DC.L 0
_CIABase       DC.L 0
variables      DS.B variables_size


; ** Speicherstellen für Namen allgemein **
WB_name
  DC.B "Workbench",0
dos_name
  DC.B "dos.library",0
gfx_name
  DC.B "graphics.library",0
  EVEN
intuition_name
  DC.B "intuition.library",0
asl_name
  DC.B "asl.library",0
icon_name
  DC.B "icon.library",0
  EVEN
  IFEQ workbench_start_enabled
wb_output_window
  DC.B "CON:0/0/640/100/Amiga Demo Launcher error message/AUTO/CLOSE/WAIT",0
    EVEN
  ENDC
CIAA_name
  DC.B "ciaa.resource",0
CIAB_name
  DC.B "ciab.resource",0
serial_device_name
  DC.B "serial.device",0
ScreenName
  DC.B "Amiga Demo Launcher",0
  EVEN
WindowName
  DC.B "Amiga Demo Launcher",0
  EVEN


; ** RunDemo Speicherstellen für Namen **
rd_demo_directory_path
  DS.B demofile_path_length

rd_whdload_tooltype_PRELOAD
  DC.B "PRELOAD",0
rd_whdload_tooltype_PRELOADSIZE
  DC.B "PRELOADSIZE",0
rd_whdload_tooltype_QUITKEY
  DC.B "QUITKEY",0
  EVEN

; ** Speicherstellen für Texte allgemein **
; ** Texte für Requester CoolCapture-Abfrage **
CoolCapture_req_title
  DC.B "Amiga Demo Launcher message",0
  EVEN
CoolCapture_req_text
  DC.B "The CoolCapture vector is already used.",10,10
  DC.B "Should the Amiga Demo Launcher be installed",10
  DC.B "and the other program be removed?",10,0
  EVEN
CoolCapture_req_gadgets_text
  DC.B "Proceed|Quit",0
  EVEN

; ** Befehlsschablone **
cmd_template
  DC.B "HELP/S,MAXENTRIES/K/N,RESETLOADPOS/S,PLAYLIST,NEWENTRY/S,QUIET/S,"
  DC.B "MIN=MINS/K/N,SEC=SECS/K/N,LMBEXIT/K/N,PRERUNSCRIPT/K,SHOWQUEUE/S,PLAYENTRY/K/N,RANDOM/S,ENDLESS/S,LOOP/S,NOFADER/S,SOFTRESET/S,REMOVE/S",0
  EVEN

help_message
  DC.B 10,"For more information about the usage use the argument HELP",10,10
help_message_end
  EVEN

; ** Aufruf der Argumente **
cmd_usage_text
  DC.B 10,"Amiga Demo Launcher arguments description:",10,10
  DC.B "HELP                   This short arguments description",10
  DC.B "MAXENTRIES ",155,"3",109,"number ",155,"0",109,"     Set maximum entries number of playback queue",10
  DC.B "RESETLOADPOS           Reset entry offset of playback queue to zero",10
  DC.B "[PLAYLIST] ",155,"3",109,"file path ",155,"0",109,"  Load and transfer external playlist script file",10
  DC.B "NEWENTRY               Create new entry in playback queue",10
  DC.B "QUIET                  No file requester if no demos left to play",10
  DC.B "MIN/MINS ",155,"3",109,"number ",155,"0",109,"       Playtime in minutes (reset device needed)",10
  DC.B "SEC/SECS ",155,"3",109,"number ",155,"0",109,"       Playtime in seconds (reset device needed)",10
  DC.B "LMBEXIT ",155,"3",109,"number ",155,"0",109,"        Play demo multiparts by LMB exit (reset device needed)",10
  DC.B "PRERUNSCRIPT ",155,"3",109,"file path ",155,"0",109,"Execute prerrun script file before demo is played",10
  DC.B "SHOWQUEUE              Show content of playback queue",10
  DC.B "PLAYENTRY ",155,"3",109,"number ",155,"0",109,"      Play certain entry of playback queue",10
  DC.B "RANDOM                 Play random entry of playback queue",10
  DC.B "ENDLESS                Play entries of playback queue endlessly",10
  DC.B "LOOP                   Play demos until no more entries left to play",10
  DC.B "NOFADER                Don't fade screen to black before demo is played",10
  DC.B "SOFTRESET              Automatic reset after quitting demo",10
  DC.B "REMOVE                 Remove Amiga Demo Launcher out of memory",10,10
cmd_usage_text_end
  EVEN


; ** DemoSelector Speicherstellen für Texte **
; ** Befehlsschablone der Playlist **
ds_playlist_template
  DC.B "demofile,OCS/S,AGA/S,FAST/S,MIN=MINS/K/N,SEC=SECS/K/N,LMBEXIT/K/N,scriptfile",0
  EVEN

; ** Hinweistexte **
ds_message_text
  DC.B "Parsing and transferring playlist to playback queue...",10,0
ds_message_text_end
  EVEN
ds_message_text2
  DC.B "... done",10
  DC.B "Result: "
ds_playlist_succ_entries_num_value
  DC.B "   "
  DC.B "of "
ds_playlist_entries_num_value
  DC.B "   "
  DC.B "entries successfully transferred to playback queue",10
  DC.B "Playback queue has "
ds_not_used_entries_num_value
  DC.B "   "
  DC.B "unused entries left for a transfer",10
ds_message_text2_end
  EVEN

; ** Aktuelles Verzeichnis **
ds_current_drawer_name
  DS.B demofile_path_length
ds_current_drawer_name_end

; ** Texte für Dateirequester **
ds_file_req_title
  DC.B "Choose up to "
ds_files_num_value
  DC.B "   "
  DC.B "demo"
ds_character_s
  DC.B "s",0
  EVEN
ds_file_req_pattern_text
  DC.B "~(#?.bin|#?.dat|#?.diz|#?.info|#?.nfo|#?.pak|#?.readme|#?.txt|#?.vars|_dl.#?)",0
  EVEN
ds_file_req_ok_text
  DC.B "Use",0
  EVEN
ds_file_req_cancel_text1
  DC.B "Quit",0
  EVEN
ds_file_req_cancel_text2
  DC.B "Reboot",0
  EVEN

; ** Texte für Startmode-Requester **
ds_startmode_req_title
  DC.B "Define start mode",0
  EVEN
ds_startmode_req_text
  DC.B "In which mode should the demo start?",10,0
  EVEN
ds_startmode_req_gadgets_text
  DC.B "Stock-OCS|Stock-AGA|Fast-OCS/AGA",0
  EVEN


; ** RunDemo Speicherstellen für Texte **
; ** Hinweistexte **
rd_demo_filename_header
  DC.B "Playing ",34
rd_demo_filename_header_end
  EVEN
rd_demo_filename_tail
  DC.B 34,"...",10
rd_demo_filename_tail_end
  EVEN

rd_show_entry_header
  DC.B "Nr."
rd_show_entry_value
  DC.B "   ",34
rd_show_entry_value_end
  EVEN
rd_show_entry_space
  DC.B 34,"................................................"
rd_show_entry_space_end
  EVEN
rd_tag_active_text1
  DC.B " played",10
rd_tag_active_text1_end
  EVEN
rd_tag_active_text2
  DC.B " not played",10
rd_tag_active_text2_end
  EVEN

rd_message_text
  DC.B "Playback queue has "
rd_not_used_entries_num_value
  DC.B "   "
  DC.B "unused entries left",10
rd_message_text_end
  EVEN

rd_message_text2
  DC.B "No more demos left to play",10
rd_message_text2_end
  EVEN

rd_message_text3
  DC.B "Amiga Demo Launcher removed out of memory",10
rd_message_text3_end
  EVEN

rd_message_text4
  DC.B "Replay loop stopped",10
rd_message_text4_end
  EVEN

rd_whdload_icon_path
  DS.B rd_whdload_icon_path_length
  EVEN

; ** String für serielle Übertragung **
rd_ser_output_string
  DC.B "#"                   ;Start-Kennung
rd_ser_output_string_number
  DS.B 5                     ;Dezimal-ASCII-Zahl mit fünf Stellen
rd_ser_output_string_comma
  DC.B ","                   ;Komma-ASCII-Zeichen
rd_ser_output_string_checksum
  DS.B 2                     ;Checksumme Hex-ASCII-Zahl mit zwei Stellen
rd_ser_output_string_line_feed
  DC.B 10                    ;Line-Feed
rd_ser_output_string_end
  EVEN

; ** Befehlszeile für Execute-Befehl Argument PRERUNSCRIPT **
rd_prerunscript_cmd_line
  DC.B "Execute "
rd_prerunscript_cmd_line_path
  DS.B prerunscript_path_length
  EVEN

; ** Befehlszeile für Execute-Befehl WHDLoad Slave-Datei **
rd_whdload_slave_cmd_line
  DC.B "WHDLoad slave "
rd_whdload_slave_cmd_line_path
  DS.B rd_whdload_slave_path_length
  DS.B rd_PRELOAD_arg_length
  DS.B rd_PRELOADSIZE_arg_length
  DS.B rd_QUITKEY_arg_length
  EVEN

; ** Pseudo-Shell-Befehlszeile **
rd_shell_cmd_line
  DC.B 10,0               ;Nur Line-Feed

; ** Header für PrintFault() **
error_header
  DC.B " ",0


; ** Fehlermeldungen allgmein **
error_text1
  DC.B "Couldnt open graphics.library",10
error_text1_end
  EVEN
error_text2
  DC.B "OS 2.04 or better required",10
error_text2_end
  EVEN
error_text3
  DC.B "MC68020 or better required",10
error_text3_end
  EVEN
;error_text4
;  DC.B "ECS chipset or better required. If it's an AGA-machine, SetPatch needs",10
;  DC.B "to be executed before",10
;error_text4_end
;  EVEN
error_text5
  DC.B "Couldn't open intuition.library",10
error_text5_end
  EVEN

; ** DemoSelector Fehlermeldungen **
ds_error_text1
  DC.B "Maximum number of entries in playback queue already reached",10
ds_error_text1_end
  EVEN
ds_error_text2
  DC.B "Couldn't allocate memory for entries/playback queue buffer",10
ds_error_text2_end
  EVEN
ds_error_text3
  DC.B "Couldn't lock playlist file"
ds_error_text3_end
  EVEN
ds_error_text4
  DC.B "Couldn't allocate memory for FileInfoBlock structure",10
ds_error_text4_end
  EVEN
ds_error_text5
  DC.B "Couldn't examine playlist file",10
ds_error_text5_end
  EVEN
ds_error_text6
  DC.B "Couldn't allocate memory for playlist file",10
ds_error_text6_end
  EVEN
ds_error_text7
  DC.B "Couldn't open playlist file"
ds_error_text7_end
  EVEN
ds_error_text8
  DC.B "Playlist file read error"
ds_error_text8_end
  EVEN
ds_error_text9
  DC.B "Couldn't allocate memory for RDArgs structure",10
ds_error_text9_end
  EVEN
ds_error_text10
  DC.B "Entry "
ds_entries_num_value
  DC.B "   "
  DC.B "could not be transferred. Playlist arguments syntax error",10
ds_error_text10_end
  EVEN
ds_error_text11
  DC.B "Couldn't open asl.library",10
ds_error_text11_end
  EVEN
ds_error_text12
  DC.B "Couldn't get program directory name",10
ds_error_text12_end
  EVEN
ds_error_text13
  DC.B "Couldn't initialize file requester structure",10
ds_error_text13_end
  EVEN
ds_error_text14
  DC.B "Invalid demo pathname"
ds_error_text14_end
  EVEN
ds_error_text15
  DC.B "No demo file selected"
ds_error_text15_end
  EVEN
ds_error_text16
  DC.B "Demo filepath is longer than 123 characters"
ds_error_text16_end
  EVEN
ds_error_text17
  DC.B "Couldn't allocate memory for resident program",10
ds_error_text17_end
  EVEN


; ** RunDemo Fehlermeldungen **
rd_error_text1
  DC.B "Prerun script filepath is longer than 63 characters"
rd_error_text1_end
  EVEN
rd_error_text2
  DC.B "Couldn't open ciax.resource",10
rd_error_text2_end
  EVEN
rd_error_text3
  DC.B "Couldn't open icon.library",10
rd_error_text3_end
  EVEN
rd_error_text4
  DC.B "Couldn't create serial message port",10
rd_error_text4_end
  EVEN
rd_error_text5
  DC.B "Couldn't open serial.device",10
rd_error_text5_end
  EVEN
rd_error_text6
  DC.B "Couldnt allocate memory for sprite data structure",10
rd_error_text6_end
  EVEN
rd_error_text7
  DC.B "Couldnt allocate memory for colour values table",10
rd_error_text7_end
  EVEN
rd_error_text8
  DC.B "Couldnt allocate memory for colour cache",10
rd_error_text8_end
  EVEN
rd_error_text9
  DC.B "Demo already played",10
rd_error_text9_end
  EVEN
rd_error_text10
  DC.B "Couldn't open demo"
rd_error_text10_end
  EVEN
rd_error_text11
  DC.B "No executable demo file"
rd_error_text11_end
  EVEN
rd_error_text12
  DC.B "Couldn't execute prerun scriptfile",10
rd_error_text12_end
  EVEN
rd_error_text13
  DC.B "Couldn't load demo"
rd_error_text13_end
  EVEN
rd_error_text14
  DC.B "Couldn't open WHDLoad .info file"
rd_error_text14_end
  EVEN
rd_error_text15
  DC.B "Couldn't lock demo directory",10
rd_error_text15_end
  EVEN
rd_error_text16
  DC.B "Couldn't open PAL screen",10
rd_error_text16_end
  EVEN
rd_error_text17
  DC.B "Couldn't open dummy window",10
rd_error_text17_end
  EVEN
rd_error_text18
  DC.B "Serial device in use",10
rd_error_text18_end
  EVEN
rd_error_text19
  DC.B "Baud rate not supported by hardware",10
rd_error_text19_end
  EVEN
rd_error_text20
  DC.B "Bad parameter",10
rd_error_text20_end
  EVEN
rd_error_text21
  DC.B "Hardware data overrun",10
rd_error_text21_end
  EVEN
rd_error_text22
  DC.B "No data set ready",10
rd_error_text22_end
  EVEN
rd_error_text23
  DC.B "Write to serial port failed",10
rd_error_text23_end
  EVEN
rd_error_text24
  DC.B "Couldn't execute WHDLoad slave file",10
rd_error_text24_end
  EVEN

program_version DC.B "$VER: Amiga Demo Launcher 1.9 beta © by Dissident of Resistance (11.1.20)",0
  EVEN

  END
