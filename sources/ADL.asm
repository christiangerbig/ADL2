; AmigaDemoLauncher
; Christian Gerbig
; 17.07.2024
; V.1.0

; Requirements
; * 68020+
; * OCS/ECS+
; * OS 2.04+


; Historie

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
; Neues Argument SHOWQUEUE: Anzeigen des Inhalts der Playback Queue mit
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
; "Stock-OCS"	= 68000 downgrade/OCS downgrade/NOFASTMEM
; "Stock-AGA"	= 68020 downgrade/NOFASTMEM
; "Fast-OCS/AGA"	= keine Einschränkungen
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
; Routinen zur Umwandlung von Zahlen umgeschrieben und von Fehlern bereinigt		 		 			<
; Fehler in Routine zum Warten auf eine Rasterzeile bereinigt
; Fehler bei der Berechnung der Länge des Demo-Dateinamens bereinigt
; Das Argument LOOP kann jetzt über CTRL-C abgebrochen werden. Bevor das Demo
; per Mausklick beendet wird, muss die Tastenkombination CTRL-C dauerhaft
; gedrückt werden, damit nach dem Einblenden die Abfrage der Tastenkmbination
; funktioniert
; ADKCON wird jetzt richtig zurückgesetzt, bevor der alte Inhalt hineinge-
; schrieben wird

; V.1.0
; - Code komplett überarbeitet
; - Umbenennung der Start-Modi:
;   "OCS" ->	"OCSVANILLA"
;   "AGA" ->	"AGAVANILLA"
;   "FAST" ->	"TURBO"
; - Neue Werte der Startmodi:
;   STARTMODE_TURBO		= $01
;   STARTMODE_OCS_VANILLA	= $02
;   STARTMODE_AGA_VANILLA	= $03

	SECTION code_and_variables,CODE

	MC68040


	INCDIR "Daten:include3.5/"

	INCLUDE "exec/exec.i"
	INCLUDE "exec/exec_lib.i"

	INCLUDE "dos/dos.i"
	INCLUDE "dos/dos_lib.i"
	INCLUDE "dos/dosextens.i"
	INCLUDE "dos/rdargs.i"

	INCLUDE "graphics/gfxbase.i"
	INCLUDE "graphics/graphics_lib.i"
	INCLUDE "graphics/videocontrol.i"

	INCLUDE "intuition/intuition.i"
	INCLUDE "intuition/intuition_lib.i"

	INCLUDE "libraries/asl.i"
	INCLUDE "libraries/asl_lib.i"
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


	INCLUDE "macros.i"


	INCLUDE "equals.i"


FirstCode			EQU 4	; Offset in SegList

OS_VERSION_MIN			EQU 37

MAGIC_COOKIE			EQU $000003f3

STARTMODE_TURBO			EQU $01
STARTMODE_OCS_VANILLA		EQU $02
STARTMODE_AGA_VANILLA		EQU $03

; **** Amiga-Demo-Launcher ****
adl_level_7_handler_enabled	EQU FALSE

adl_demofile_path_length	EQU 124
adl_prerunscript_path_length	EQU 64

adl_baud			EQU 2400


; **** Demo-Selector ****
ds_entries_number_default_max	EQU 10
ds_entries_number_max		EQU 99

ds_demo_parts_number_min        EQU 2
ds_demo_parts_number_max        EQU 10

ds_file_request_x_size		EQU 320
ds_file_request_y_size		EQU 200

; **** Reset-Programm ****
rp_frames_delay			EQU 50
rp_rasterlines_delay		EQU 5

rp_color_okay			EQU $68b
rp_color_error			EQU $d74

; **** Run-Demo ****
rd_seconds_max			EQU 59
rd_minutes_max			EQU 99

rd_demo_parts_number_min        EQU 2
rd_demo_parts_number_max        EQU 10

rd_load_colors_number           EQU 1

whdl_PRELOAD_length	EQU 8
whdl_PRELOADSIZE_length	EQU 20
whdl_QUITKEY_length	EQU 11
whdl_slave_path_length	EQU 124
whdl_icon_path_length	EQU 124

rd_sprite_x_size		EQU 16
rd_sprite_y_size		EQU 1
rd_sprites_colors_number	EQU 16

rd_screen_left			EQU 0
rd_screen_top			EQU 0
rd_screen_x_size		EQU 2
rd_screen_y_size		EQU 2
rd_screen_depth			EQU 1

rd_window_left			EQU 0
rd_window_top			EQU 0
rd_window_x_size		EQU rd_screen_x_size
rd_window_y_size		EQU rd_screen_y_size

; **** Screen-Fader ****
sf_colors_number_max		EQU 256

; **** Screen-Fader-Out ****
sfo_fader_speed			EQU 6

; **** Screen-Fader-In ****
sfi_fader_speed			EQU 8


RP_POINTER_ENTRIES_NUMBER	MACRO
	trap	#0
	ENDM

RP_POINTER_ENTRIES_NUMBER_MAX	MACRO
	trap	#1
	ENDM

RP_POINTER_ENTRIES_OFFSET	MACRO
	trap	#2
	ENDM

RP_POINTER_ENTRIES_BUFFER	MACRO
	trap	#3
	ENDM

RP_POINTER_ENDLESS_ENABLED	MACRO
	trap	#4
	ENDM

RP_POINTER_CUSTOM_TRAP_VECTORS	MACRO
	trap	#5
	ENDM

RP_REMOVE_RESET_PROGRAM		MACRO
	trap	#6
	ENDM

	IFEQ adl_level_7_handler_enabled
RP_POINTER_LEVEL_7_RESET_ACTIVE	MACRO
		trap	#7
		ENDM
	ENDC


	INCLUDE "except-vectors-offsets.i"


	RSRESET

; **** Amiga-Demo-Launcher ****
adl_output_handle		RS.L 1

adl_dos_return_code		RS.L 1

adl_read_arguments		RS.L 1

adl_entries_buffer		RS.L 1
adl_entries_number		RS.W 1
adl_entries_number_max		RS.W 1

adl_reset_program_active	RS.W 1

; **** Demo-Selector ****
ds_playlist_file_name		RS.L 1
ds_playlist_file_lock		RS.L 1
ds_playlist_file_fib		RS.L 1
ds_playlist_file_length		RS.L 1
ds_playlist_file_buffer		RS.L 1
ds_playlist_file_handle		RS.L 1

ds_file_request			RS.L 1
ds_current_pathname		RS.L 1
ds_multiselect_entries_number	RS.W 1

ds_load_active			RS.W 1

ds_arg_playlist_enabled		RS.W 1
ds_playlist_entries_number	RS.W 1

ds_entries_number_max_enabled	RS.W 1

ds_transmitted_entries_number 	RS.W 1

ds_arg_quiet_enabled		RS.W 1

; **** Run-Demo ****
	RS_ALIGN_LONGWORD
rd_serial_message_port		RS.L 1

rd_available_fast_memory_size	RS.L 1
rd_available_fast_memory	RS.L 1

rd_prerunscript_path		RS.L 1

rd_demofile_path		RS.L 1
rd_demofile_name		RS.L 1
rd_demofile_name_length		RS.L 1
rd_demofile_handle		RS.L 1
rd_demofile_magic_cookie	RS.L 1
rd_demofile_seglist		RS.L 1
rd_demofile_dir_lock		RS.L 1
rd_current_dir_lock		RS.L 1

rd_sprite_data			RS.L 1
rd_window			RS.L 1

rd_custom_trap_vectors		RS.L 1

rd_old_view			RS.L 1
rd_old_sprite_resolution	RS.L 1

rd_old_vbr			RS.L 1
rd_old_cacr			RS.L 1

rd_clear_030_mmu_register	RS.L 1

rd_old_060_pcr			RS.L 1

rd_old_cop1lc			RS.L 1
rd_old_cop2lc			RS.L 1

rd_old_dmacon			RS.W 1
rd_old_intena			RS.W 1
rd_old_adkcon			RS.W 1

rd_old_ciaa_pra			RS.B 1
rd_old_ciaa_talo		RS.B 1
rd_old_ciaa_tahi		RS.B 1
rd_old_ciaa_tblo		RS.B 1
rd_old_ciaa_tbhi		RS.B 1
rd_old_ciaa_icr			RS.B 1
rd_old_ciaa_cra			RS.B 1
rd_old_ciaa_crb			RS.B 1

rd_old_ciab_prb			RS.B 1
rd_old_ciab_talo		RS.B 1
rd_old_ciab_tahi		RS.B 1
rd_old_ciab_tblo		RS.B 1
rd_old_ciab_tbhi		RS.B 1
rd_old_ciab_icr			RS.B 1
rd_old_ciab_cra			RS.B 1
rd_old_ciab_crb			RS.B 1

rd_play_duration		RS.W 1	; Argument MIN[S]/SEC[S]
rd_arg_prerunscript_enabled	RS.W 1
rd_arg_showqueue_enabled	RS.W 1
rd_arg_playentry_offset		RS.W 1
rd_arg_random_enabled		RS.W 1
rd_arg_endless_enabled		RS.W 1
rd_arg_loop_enabled		RS.W 1
rd_arg_nofader_enabled		RS.W 1
rd_arg_softreset_enabled	RS.W 1
rd_arg_remove_enabled		RS.W 1

; **** WHDLoad ****
whdl_slave_enabled		RS.W 1
	RS_ALIGN_LONGWORD
whdl_disk_object		RS.L 1

; **** Reset-Program ****
rp_reset_program_active		RS.W 1

; **** Screen-Fader ****
	RS_ALIGN_LONGWORD
sf_screen_colors_number		RS.L 1
sf_odd_sprite_color_base	RS.L 1
sf_even_sprite_color_base	RS.L 1
sf_color_table			RS.L 1
sf_color_cache			RS.L 1

; **** Screen-Fader-In ****
sfi_active			RS.W 1

; **** Screen-Fader-Out ****
sfo_active			RS.W 1

adl_variables_size		RS.B 0


	RSRESET

cmd_results_array		RS.B 0

; **** Amiga-Demo-Launcher ****
cra_HELP			RS.L 1
; **** Demo-Selector ****
cra_MAXENTRIES			RS.L 1
cra_RESETLOADPOS		RS.L 1
cra_playlist			RS.L 1
cra_NEWENTRY			RS.L 1
cra_QUIET			RS.L 1
; **** Run-Demo ****
cra_MINS			RS.L 1
cra_SECS			RS.L 1
cra_LMBEXIT			RS.L 1
cra_PRERUNSCRIPT		RS.L 1
cra_SHOWQUEUE			RS.L 1
cra_PLAYENTRY			RS.L 1
cra_RANDOM			RS.L 1
cra_ENDLESS			RS.L 1
cra_LOOP			RS.L 1
cra_NOFADER			RS.L 1
cra_SOFTRESET			RS.L 1
cra_REMOVE			RS.L 1

cmd_results_array_size 	RS.B 0


	RSRESET

playlist_results_array		RS.B 0

pra_demofile			RS.L 1
pra_STARTMODE_OCS_VANILLA	RS.L 1
pra_STARTMODE_AGA_VANILLA	RS.L 1
pra_STARTMODE_TURBO		RS.L 1
pra_MINS			RS.L 1
pra_SECS			RS.L 1
pra_LMBEXIT			RS.L 1
pra_prerunscript		RS.L 1

playlist_results_array_size	RS.B 1


	RSRESET

playback_queue_entry		RS.B 0

pqe_demofile_path		RS.B adl_demofile_path_length
pqe_playtime			RS.W 1
pqe_startmode			RS.B 1
pqe_tag_active			RS.B 1
pqe_prerunscript_path		RS.B adl_prerunscript_path_length

playback_queue_entry_size 	RS.B 0


	RSRESET

load_color_table		RS.B 0

lct_colors_number		RS.W 1
lct_start_color			RS.W 1
lct_color00                     RS.L 3	; 3x32 Bit
lct_end				RS.L 1

load_color_table_size		RS.B 0


	RSRESET

old_mmu_registers		RS.B 0

omr_tt0				RS.L 1
omr_tt1				RS.L 1
omr_dtt0                        RS.L 1
omr_dtt1                        RS.L 1
omr_itt0                        RS.L 1
omr_itt1                        RS.L 1
omr_tc	                        RS.L 1

old_mmu_registers_size		RS.B 0


; **** Amiga Demo-Launcher ****
	movem.l d2-d7/a2-a6,-(a7)
	lea	adl_variables(pc),a3
	bsr	adl_init_variables
	bsr	adl_init_structures
	bsr	adl_open_dos_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_quit
	bsr	adl_get_output
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_dos_library
	bsr	adl_open_graphics_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_dos_library
	bsr	adl_check_system
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_graphics_library
	bsr	adl_open_intuition_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_graphics_library
	bsr	adl_check_cool_capture
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_intuition_library
	bsr	adl_check_cmd_line
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
	tst.w	adl_reset_program_active(a3)
	bne.s	ds_start
	tst.w	ds_load_active(a3)
	bne	rd_start

; **** Demo-Selector ****
ds_start
	moveq	#RETURN_WARN,d0
	cmp.l	adl_dos_return_code(a3),d0
	beq     adl_cleanup_read_arguments
 	bsr	ds_alloc_entries_buffer
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
	tst.w	ds_arg_PLAYLIST_enabled(a3)
	bne.s	ds_open_file_request
	bra.s	ds_open_file_request
; ** Es wurde eine Playlist-Datei angegeben **
	bsr	ds_lock_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_entries_buffer
	bsr	ds_alloc_playlist_file_fib
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_locked_playlist_file
	bsr	ds_get_playlist_file_length
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_playlist_file_fib
	bsr	ds_alloc_playlist_file_buffer
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_playlist_file_fib
	bsr	ds_open_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_playlist_file_fib
	bsr	ds_read_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_playlist_file
	bsr	ds_parse_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	moveq	#RETURN_WARN,d1
	cmp.l	d1,d0
	bgt	ds_cleanup_playlist_file
	bra.s	ds_check_entries_number
; ** Es wurde keine Playlist-Datei angegeben **
	CNOP 0,4
ds_open_file_request
	bsr	ds_open_asl_library
	move.l	d0,adl_dos_return_code(a3)
	bne	ds_cleanup_entries_buffer
	lea	ds_current_dir_name(pc),a5
	bsr	ds_get_program_dir
	move.l	d0,adl_dos_return_code(a3)
	bne.s	ds_cleanup_asl_library
ds_open_file_request_loop
	bsr	ds_display_remaining_files
	bsr	ds_init_asl_file_request
	move.l	d0,adl_dos_return_code(a3)
	bne.s	ds_cleanup_asl_library
	bsr	ds_display_file_request
	move.l	d0,adl_dos_return_code(a3)
	bne.s	ds_cleanup_file_request
	bsr	ds_get_demofile_path
	move.l	d0,adl_dos_return_code(a3)
	bne.s	ds_cleanup_file_request
	bsr	ds_free_file_request
	bsr	ds_display_startmode_request
	move.w	adl_entries_number_max(a3),d0
	cmp.w	adl_entries_number(a3),d0
	bne.s	ds_open_file_request_loop
	bsr	ds_entries_number_max_reached
	move.l	d0,adl_dos_return_code(a3)
	bra.s	ds_cleanup_asl_library

	CNOP 0,4
ds_cleanup_file_request
	bsr	ds_free_file_request
ds_cleanup_asl_library
	bsr	ds_close_asl_library
ds_check_entries_number
	tst.w	adl_entries_number(a3)
	beq.s	ds_cleanup_playlist_file
	cmp.l	#ERROR_OBJECT_NOT_FOUND,adl_dos_return_code(a3)
	beq.s	ds_check_reset_program
	moveq	#RETURN_WARN,d0
	cmp.l	adl_dos_return_code(a3),d0
	blt.s	ds_cleanup_playlist_file
ds_check_reset_program
	tst.w	adl_reset_program_active(a3)
	beq.s	ds_update_entries_number
	bsr	ds_init_reset_program
	move.l	d0,adl_dos_return_code(a3)
	bne.s	ds_cleanup_playlist_file
ds_update_entries_number
	RP_POINTER_ENTRIES_NUMBER
	move.l	d0,a0
	move.w	adl_entries_number(a3),(a0)
ds_cleanup_playlist_file
	tst.w	ds_arg_PLAYLIST_enabled(a3)
	bne.s	ds_cleanup_entries_buffer
	bsr	ds_close_playlist_file
	bsr	ds_free_playlist_file_buffer
ds_cleanup_playlist_file_fib
	bsr	ds_free_playlist_file_fib
ds_cleanup_locked_playlist_file
	bsr	ds_unlock_playlist_file
ds_cleanup_entries_buffer
	bsr	ds_free_entries_buffer
	moveq	#RETURN_WARN,d0
	cmp.l	adl_dos_return_code(a3),d0
	blt.s	adl_cleanup_read_arguments
	tst.w	adl_entries_number(a3)
	beq.s	adl_cleanup_read_arguments
	tst.w	rd_arg_softreset_enabled(a3)
	bne.s	adl_cleanup_read_arguments
	CALLEXECQ ColdReboot

; **** Amiga Demo-Launcher ****
	CNOP 0,4
adl_cleanup_read_arguments
	bsr	adl_free_read_arguments
	bsr	adl_print_io_error
adl_cleanup_intuition_library
	bsr	adl_close_intuition_library
adl_cleanup_graphics_library
	bsr	adl_close_graphics_library
adl_cleanup_dos_library
	bsr	adl_close_dos_library
adl_quit
	move.l	adl_dos_return_code(a3),d0
	movem.l (a7)+,d2-d7/a2-a6
	rts


	CNOP 0,4
adl_init_variables
; **** Main ****
	lea	_SysBase(pc),a0
	move.l	exec_base.w,(a0)

; **** Amiga-Demo-Launcher ****
	moveq	#0,d0
	move.l	d0,adl_dos_return_code(a3)

	moveq	#FALSE,d1
	move.w	d1,adl_reset_program_active(a3)

; **** Demo-Selector ****
	move.w  d0,ds_multiselect_entries_number(a3)
	move.w	d1,ds_load_active(a3)

	move.w	d1,ds_arg_PLAYLIST_enabled(a3)
	move.w	d0,ds_playlist_entries_number(a3)
	move.w	d0,ds_transmitted_entries_number(a3)

	move.w	d1,ds_entries_number_max_enabled(a3)

	move.w	d1,ds_arg_quiet_enabled(a3)

; **** Run-Demo ****
	move.l	d0,rd_clear_030_mmu_register(a3)

	move.l	d0,rd_demofile_seglist(a3)
	move.l	d0,rd_prerunscript_path(a3)

	move.w	d1,rd_arg_prerunscript_enabled(a3)
	move.w	d1,rd_arg_showqueue_enabled(a3)
	move.w	d0,rd_arg_playentry_offset(a3)
	move.w	d1,rd_arg_random_enabled(a3)
	move.w	d1,rd_arg_endless_enabled(a3)
	move.w	d1,rd_arg_loop_enabled(a3)
	move.w	d1,rd_arg_nofader_enabled(a3)
	move.w	d1,rd_arg_softreset_enabled(a3)
	move.w	d1,rd_arg_remove_enabled(a3)

; **** WHDLoad ****
	move.w	d1,whdl_slave_enabled(a3)

; **** Screen-Fader-In ****
	move.w	d0,sfi_active(a3)

; **** Screen-Fader-Out ****
	move.w	d0,sfo_active(a3)
	rts


	CNOP 0,4
adl_init_structures
	bsr	adl_init_cool_capture_request
	bsr     ds_init_startmode_request
	bsr	ds_init_file_request
	bsr	ds_init_file_request_use
	bsr	rd_init_load_color_table
	bsr	rd_init_screen
	bsr	rd_init_window
	bra	rd_init_video_control


	CNOP 0,4
adl_init_cool_capture_request
	lea	adl_cool_capture_request(pc),a0
	moveq	#EasyStruct_SIZEOF,d2
	move.l	d2,(a0)+		; Größe der Struktur
	moveq	#0,d0
	move.l	d0,(a0)+		; Keine Flags
	lea	adl_cool_capture_request_title(pc),a1
	move.l	a1,(a0)+		; Zeiger auf Titeltext
	lea	adl_cool_capture_request_body(pc),a1
	move.l	a1,(a0)+		; Zeiger auf Text in Requester
	lea	adl_cool_capture_request_gadgets(pc),a1
	move.l	a1,(a0)			; Zeiger auf Gadgettexte
	rts


	CNOP 0,4
ds_init_startmode_request
	lea	ds_startmode_request(pc),a0
	move.l	d2,(a0)+		; Größe der Struktur
	move.l	d0,(a0)+		; Keine Flags
	lea	ds_startmode_request_title(pc),a1
	move.l	a1,(a0)+		; Zeiger auf Titeltext
	lea	ds_startmode_request_body(pc),a1
	move.l	a1,(a0)+		; Zeiger auf Text in Requester
	lea	ds_startmode_request_gadgets(pc),a1
	move.l	a1,(a0)			; Zeiger auf Gadgettexte
	rts


	CNOP 0,4
ds_init_file_request
	lea	ds_file_request_tag_list(pc),a0
; ** Tags für Fensterbeeinflussung **
	move.l	#ASLFR_Window,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
; ** Texte für Textanzeige **
	move.l	#ASLFR_TitleText,(a0)+
	lea	ds_file_request_title(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_PositiveText,(a0)+
	lea	ds_file_request_ok(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_NegativeText,(a0)+
	lea	ds_file_request_quit(pc),a1
	move.l	a1,(a0)+
; ** Grundparameter für File-Requester **
	move.l	#ASLFR_InitialLeftEdge,(a0)+
	move.l	d0,(a0)+
	move.l	#ASLFR_InitialTopEdge,(a0)+
	move.l	d0,(a0)+
	move.l	#ASLFR_InitialWidth,(a0)+
	move.l	#ds_file_request_x_size,(a0)+
	move.l	#ASLFR_InitialHeight,(a0)+
	move.l	#ds_file_request_y_size,(a0)+
	move.l	#ASLFR_InitialPattern,(a0)+
	lea	ds_file_request_pattern(pc),a1
	move.l	a1,(a0)+
; ** Optionen **
	move.l	#ASLFR_Flags1,(a0)+
	moveq	#FRF_DOPATTERNS+FRF_DOMULTISELECT,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
ds_init_file_request_use
	lea	ds_file_request_use_tag_list(pc),a0
	move.l	#ASLFR_InitialDrawer,(a0)+
	lea	ds_current_dir_name(pc),a1
	move.l	a1,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
rd_init_load_color_table
	lea	rd_load_color_table(pc),a0
	move.w	#rd_load_colors_number,(a0)+ ; Anzahl der Farben zum Laden
	moveq	#0,d0
	move.w	d0,(a0)+		; Erste Farbe COLOR00
	move.l	d0,(a0)+		; 32-Bit Rotwert löschen
	move.l	d0,(a0)+		; 32-Bit Grünwert löschen
	move.l	d0,(a0)+		; 32-Bit Blauwert löschen
	move.l	d0,(a0)			; Ende der Tabelle
	rts


	CNOP 0,4
rd_init_screen
	lea	rd_screen_tag_list(pc),a0
	move.l	#SA_Left,(a0)+
     	moveq	#rd_screen_left,d2
	move.l	d2,(a0)+
	move.l	#SA_Top,(a0)+
     	moveq	#rd_screen_top,d2
	move.l	d2,(a0)+
	move.l	#SA_Width,(a0)+
	moveq	#rd_screen_x_size,d2
	move.l	d2,(a0)+
	move.l	#SA_Height,(a0)+
	moveq	#rd_screen_y_size,d2
	move.l	d2,(a0)+
	move.l	#SA_Depth,(a0)+
	moveq	#rd_screen_depth,d2
	move.l	d2,(a0)+
	move.l	#SA_Title,(a0)+
	lea	rd_screen_name(pc),a1
	move.l	a1,(a0)+
	move.l	#SA_DisplayID,(a0)+
	move.l	#PAL_MONITOR_ID|LORES_KEY,(a0)+
	move.l	#SA_DetailPen,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	#SA_BlockPen,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Font,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_ShowTitle,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Behind,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Quiet,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Type,(a0)+
	move.l	#CUSTOMSCREEN,(a0)+
	move.l	#SA_AutoScroll,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_SysFont,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Draggable,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Interleaved,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Colors32,(a0)+
	lea	rd_load_color_table(pc),a1
	move.l	a1,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
rd_init_window
	lea	rd_window_tag_list(pc),a0
	move.l	#WA_CustomScreen,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+		; Zeiger wird später initialisiert
	move.l	#WA_Left,(a0)+
	moveq	#rd_window_left,d2
	move.l	d2,(a0)+
	move.l	#WA_Top,(a0)+
	moveq	#rd_window_top,d2
	move.l	d2,(a0)+
	move.l	#WA_Width,(a0)+
	moveq	#rd_window_x_size,d2
	move.l	d2,(a0)+
	move.l	#WA_MaxWidth,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_MinWidth,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_Height,(a0)+
	moveq	#rd_window_y_size,d2
	move.l	d2,(a0)+
	move.l	#WA_MaxHeight,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_MinHeight,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_DetailPen,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_BlockPen,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_IDCMP,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_Flags,(a0)+
	move.l	#WFLG_BACKDROP|WFLG_BORDERLESS|WFLG_ACTIVATE,(a0)+
	move.l	#WA_AutoAdjust,(a0)+
	moveq	#FALSE,d2
	move.l	d2,(a0)+
	move.l	#WA_Title,(a0)+
	lea	rd_window_name(pc),a1
	move.l	a1,(a0)+
	move.l	#WA_WindowName,(a0)+
	move.l	a1,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
rd_init_video_control
	lea	rd_video_control_tag_list+(ti_SIZEOF*1)(pc),a0
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
adl_open_dos_library
	lea	dos_library_name(pc),a1
	moveq	#ANY_LIBRARY_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_DOSBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_dos_library_ok
	moveq	#RETURN_FAIL,d0
        rts
	CNOP 0,4
adl_open_dos_library_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_get_output
	CALLDOS Output
	move.l	d0,adl_output_handle(a3)
	bne.s   adl_get_output_ok
	CALLLIBQ IoErr
	CNOP 0,4
adl_get_output_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_open_graphics_library
	lea	graphics_library_name(pc),a1
	moveq	#ANY_LIBRARY_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_GfxBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_graphics_library_ok
	lea	adl_error_text1(pc),a0
	moveq	#adl_error_text1_end-adl_error_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_open_graphics_library_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_check_system
	move.l	_SysBase(pc),a0
	cmp.w	#OS_VERSION_MIN,Lib_Version(a0)
	bge.s	adl_check_system_cpu_min
	lea	adl_error_text2(pc),a0
	moveq	#adl_error_text2_end-adl_error_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_system_cpu_min
	btst	#AFB_68020,AttnFlags+1(a0)
	bne.s	adl_check_system_ok
	lea	adl_error_text3(pc),a0
	move.l	#adl_error_text3_end-adl_error_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_system_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_open_intuition_library
	lea	intuition_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0
	CALLEXEC OpenLibrary
	lea	_IntuitionBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_intuition_library_ok
	lea	adl_error_text4(pc),a0
	moveq	#adl_error_text4_end-adl_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_open_intuition_library_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_check_cool_capture
	move.l	_SysBase(pc),a0
	move.l	CoolCapture(a0),d0
	beq.s   adl_check_cool_capture_ok
	move.l	d0,a0
	cmp.w	#"DL",2(a0)
	beq.s	adl_set_entries_number_max
	move.l	a3,a4			; Inhalt von a3 retten
	sub.l	a0,a0			; Requester erscheint auf Workbench
	lea	adl_cool_capture_request(pc),a1
	move.l	a0,a2			; Keine IDCMP-Flags
	move.l	a0,a3			; Keine Argumentenliste
	CALLINT EasyRequestArgs
	move.l	a4,a3			; Alter Inhalt von a3
	tst.l	d0			; Gadget "Proceed" angeklickt ?
	bne.s	adl_check_cool_capture_ok ; Ja -> verzweige
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_set_entries_number_max
	RP_POINTER_ENTRIES_NUMBER_MAX
	move.l	d0,a0
	move.w	(a0),adl_entries_number_max(a3)
	RP_POINTER_ENTRIES_NUMBER
	move.l	d0,a0
	move.w	(a0),adl_entries_number(a3)
	RP_POINTER_ENTRIES_BUFFER
	move.l	d0,adl_entries_buffer(a3)
	clr.w   adl_reset_program_active(a3)
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
adl_check_cool_capture_ok
	moveq	#ds_entries_number_default_max,d2
	move.w	d2,adl_entries_number_max(a3)
	lea	rp_entries_number_max(pc),a0
	move.w	d2,(a0)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_check_cmd_line
	lea	adl_cmd_template(pc),a0
	move.l	a0,d1			; Zeiger auf Befelsschablone
	lea	adl_cmd_results(pc),a2
	move.l	a2,d2			; Zeiger auf Ergebnis-Felder
	moveq	#0,d3			; Keine eigene RDArgs-Struktur
	CALLDOS ReadArgs
	move.l	d0,adl_read_arguments(a3)
	bne.s   adl_check_arg_help
	bsr	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts

; ** Argument HELP ***
	CNOP 0,4
adl_check_arg_help
	tst.l	cra_HELP(a2)
	beq.s	ds_check_demo_selector_args
	bsr.s	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts


	CNOP 0,4
adl_print_cmd_usage
	lea	adl_cmd_usage_text(pc),a0
	move.l	#adl_cmd_usage_text_end-adl_cmd_usage_text,d0
	bra	adl_print_text


; **** Demo-Selector ****
	CNOP 0,4
ds_check_demo_selector_args
	moveq	#TRUE,d3
	tst.w	adl_reset_program_active(a3)
	beq.s	ds_check_arg_resetloadpos

; ** Argument MAXENTRIES **
	move.l	cra_MAXENTRIES(a2),d0
	beq.s	ds_check_arg_resetloadpos
	move.l	d0,a0			;  Zeiger auf String
	move.l	(a0),d0			;  Wert
	bne.s	ds_check_arg_maxentries_ok
	bsr.s	adl_print_cmd_usage
	MOVEF.L	ERROR_KEY_NEEDS_ARG,d0
	rts
	CNOP 0,4
ds_check_arg_maxentries_ok
	cmp.w	#ds_entries_number_max,d0
	ble.s   ds_update_entries_number_max
	bsr.s	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_update_entries_number_max
	move.w	d0,adl_entries_number_max(a3)
	lea	rp_entries_number_max(pc),a0
	move.w	d0,(a0)

; ** Argument RESETLOADPOS **
ds_check_arg_resetloadpos
	tst.l	cra_RESETLOADPOS(a2)
	beq.s	ds_check_arg_playlist
	move.w	d3,adl_entries_number(a3)

; ** Argument playlist **
ds_check_arg_playlist
	move.l	cra_playlist(a2),ds_playlist_file_name(a3)
	beq.s	ds_check_arg_newentry
	move.w	d3,ds_arg_PLAYLIST_enabled(a3)
	move.w	d3,ds_load_active(a3)
	bra.s	ds_check_arg_quiet

; ** Argument NEWENTRY **
	CNOP 0,4
ds_check_arg_newentry
	tst.l	cra_NEWENTRY(a2)
	beq.s	ds_check_arg_quiet
	move.w	d3,ds_load_active(a3)

; ** Argument QUIET **
ds_check_arg_quiet
	tst.l   cra_QUIET(a2)
	beq.s   ds_check_entries_number_max
	tst.w	adl_reset_program_active(a3)
	beq.s	ds_check_entries_number_max
	moveq 	#RETURN_WARN,d0
	rts


	CNOP 0,4
ds_check_entries_number_max
	tst.w   ds_load_active(a3)
	bne.s   rd_check_run_demo_args
	move.w  adl_entries_number(a3),d0
	cmp.w   adl_entries_number_max(a3),d0
	beq.s	ds_entries_number_max_reached
	moveq   #RETURN_OK,d0
	rts


	CNOP 0,4
ds_entries_number_max_reached
	lea     ds_note_text(pc),a0
	moveq   #ds_note_text_end-ds_note_text,d0
	bsr     adl_print_text
	moveq   #RETURN_WARN,d0
	rts


; **** Run-Demo ****
	CNOP 0,4
rd_check_run_demo_args
	tst.w	adl_reset_program_active(a3)
	bne	rd_check_arg_softreset

; ** Argument REMOVE **
	move.l	cra_REMOVE(a2),d0
	beq.s	rd_check_arg_secs
	not.w	d0
	move.w	d0,rd_arg_remove_enabled(a3) ; Amiga Demo Launcher vorzeitig aus dem Speicher entfernen
	moveq	#RETURN_OK,d0
	rts

; ** Argument SECS **
	CNOP 0,4
rd_check_arg_secs
	move.l	cra_SECS(a2),d0
	beq.s	rd_check_arg_mins
	move.l	d0,a0			; Zeiger auf String
	move.l	(a0),d0			; Sekundenwert
	moveq	#rd_seconds_max,d2
	cmp.l	d2,d0
	ble.s   rd_check_arg_mins
	bsr	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts

; ** Argument MINS **
	CNOP 0,4
rd_check_arg_mins
	move.l	cra_MINS(a2),d1
	beq.s	rd_check_arg_lmbexit
	move.l	d1,a0			; Zeiger auf String
	move.l	(a0),d1			; Minutenwert
	moveq	#rd_minutes_max,d2
	cmp.l	d2,d1
	ble.s   rd_calculate_ms_sum
	bsr	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_calculate_ms_sum
	MULUF.L 60,d1,d2		; Umrechnung Minuten in Sekunden
	add.l	d0,d1			; Gesamtwert Sekunden
	MULUF.L 10,d1,d0		; Umrechnung Sekunden in 100 ms
	beq.s	rd_check_arg_lmbexit	; Eventuell überflüssig ???
	move.w	d1,rd_play_duration(a3)

; ** Argument LMBEXIT **
rd_check_arg_lmbexit
	move.l	cra_LMBEXIT(a2),d0
	beq.s	rd_check_arg_prerunscript
	tst.w	rd_play_duration(a3)
	bne.s   rd_check_arg_lmbexit_ok
	bsr	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_arg_lmbexit_ok
	move.l	d0,a0			; Zeiger auf String
	move.l	(a0),d0			; Anzahl der Demoteile
	bne.s   rd_check_demo_parts_number_min
	bsr     adl_print_cmd_usage
	MOVEF.L	ERROR_KEY_NEEDS_ARG,d0
	rts
	CNOP 0,4
rd_check_demo_parts_number_min
	cmp.w	#rd_demo_parts_number_min,d0
	bge.s   rd_check_demo_parts_number_max
	bsr     adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_demo_parts_number_max
	cmp.w	#rd_demo_parts_number_max,d0
	ble.s   rd_arg_lmbexit_set_play_duration
	bsr     adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_arg_lmbexit_set_play_duration
	subq.w	#1,d0			; Wert anpassen, da intern 1...9 übergeben wird
	add.w	d0,rd_play_duration(a3)

; ** Argument PRERUNSCRIPT **
rd_check_arg_prerunscript
	move.l	cra_PRERUNSCRIPT(a2),d0
	beq.s	rd_check_arg_showqueue
	move.l	d0,rd_prerunscript_path(a3) 
	move.l	d0,a0			; Zeiger auf String
	moveq	#0,d0			; Zähler für Anzahl Zeichen
rd_check_arg_prerunscript_loop
	addq.b	#1,d0
	cmp.b	#adl_prerunscript_path_length-1,d0
	blt.s	rd_check_arg_prerunscript_end
	lea	rd_error_text1(pc),a0
	moveq	#rd_error_text1_end-rd_error_text1,d0
	bsr	adl_print_text
	move.l	#ERROR_INVALID_COMPONENT_NAME,d0
	rts
        CNOP 0,4
rd_check_arg_prerunscript_end
	tst.b	(a0)+
	bne.s	rd_check_arg_prerunscript_loop
	move.w	d3,rd_arg_prerunscript_enabled(a3)

; ** Argument SHOWQUEUE **
rd_check_arg_showqueue
	move.l	cra_SHOWQUEUE(a2),d0
	not.w	d0
	move.w	d0,rd_arg_showqueue_enabled(a3)

; ** Argument PLAYENTRY **
	move.l	cra_PLAYENTRY(a2),d0
	beq.s	rd_check_arg_random
	move.l	d0,a0		; Zeiger auf String
	move.l	(a0),d0		; Entry-Nummer
	bne.s	rd_check_arg_playentry_ok
	bsr	adl_print_cmd_usage
	MOVEF.L	ERROR_KEY_NEEDS_ARG,d0
	rts
	CNOP 0,4
rd_check_arg_playentry_ok
	cmp.w	adl_entries_number(a3),d0
	ble.s   rd_check_arg_playentry_set
	bsr	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_arg_playentry_set
	move.w	d0,rd_arg_playentry_offset(a3)

; ** Argument RANDOM **
rd_check_arg_random
	move.l	cra_RANDOM(a2),d0
	not.w	d0
	move.w	d0,rd_arg_random_enabled(a3)

; ** Argument ENDLESS **
	move.l	cra_ENDLESS(a2),d0
	not.w	d0
	move.w	d0,rd_arg_endless_enabled(a3)

; ** Argument LOOP **
	move.l	cra_LOOP(a2),d0
	not.w	d0
	move.w	d0,rd_arg_loop_enabled(a3)

; ** Argument NOFADER **
	move.l	cra_NOFADER(a2),d0
	not.w	d0
	move.w	d0,rd_arg_nofader_enabled(a3)

; ** Argument SOFTRESET **
rd_check_arg_softreset
	tst.l	cra_SOFTRESET(a2)
	beq.s	rd_check_reset_program_active
	tst.w	rd_arg_loop_enabled(a3)
	beq.s	rd_check_reset_program_active
	moveq	#RETURN_WARN,d0                 ; kann entfallen ???
	cmp.l	adl_dos_return_code(a3),d0	; kann entfallen ???
	beq.s	rd_check_reset_program_active	; kann entfallen ???
	clr.w	rd_arg_softreset_enabled(a3)
rd_check_reset_program_active
	tst.w	adl_reset_program_active(a3)
	beq.s   rd_check_arg_SOFTRESET_ok
	tst.w	rd_arg_softreset_enabled(a3)
	beq.s	rd_check_arg_SOFTRESET_ok
	lea	adl_help_message(pc),a0
	moveq	#adl_help_message_end-adl_help_message,d0
	bsr	adl_print_text
rd_check_arg_SOFTRESET_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_print_io_error
	move.l	adl_dos_return_code(a3),d1
	moveq	#ERROR_NO_FREE_STORE,d0
	cmp.l	d0,d1
	bge.s	adl_print_io_error_ok
	rts
	CNOP 0,4
adl_print_io_error_ok
	lea	adl_error_header(pc),a0
	move.l	a0,d2                   ; Header für Fehlermeldung
	CALLDOSQ PrintFault


	CNOP 0,4
adl_free_read_arguments
	move.l	adl_read_arguments(a3),d1
	bne.s	adl_free_read_arguments_ok
	rts
	CNOP 0,4
adl_free_read_arguments_ok
	CALLDOSQ FreeArgs


	CNOP 0,4
adl_close_intuition_library
	move.l	_IntuitionBase(pc),a1
	CALLEXECQ CloseLibrary


	CNOP 0,4
adl_close_graphics_library
	move.l	_GfxBase(pc),a1
	CALLEXECQ CloseLibrary


	CNOP 0,4
adl_close_dos_library
	move.l	_DOSBase(pc),a1
	CALLEXECQ CloseLibrary


; ** Textstring ausgeben **
; Input
; a0 ... Zeiger auf Fehlertext
; d0 ... Länge des Textes
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
adl_print_text
	move.l	adl_output_handle(a3),d1 ; Zeiger auf Datei-Handle
	move.l	a0,d2			; Zeiger auf Fehlertext
	move.l	d0,d3			; Anzahl der Zeichen zum Schreiben
	CALLDOSQ Write


; **** DemoSelector ****
	CNOP 0,4
ds_alloc_entries_buffer
	tst.w	adl_reset_program_active(a3)
	beq.s	ds_alloc_entries_buffer_ok
	moveq	#0,d0
	move.w	adl_entries_number_max(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Größe des Puffers berechnen
	MOVEF.L MEMF_CLEAR+MEMF_PUBLIC+MEMF_ANY,d1
	CALLEXEC AllocMem
	move.l	d0,adl_entries_buffer(a3)
	bne.s	ds_alloc_entries_buffer_ok
	lea	ds_error_text2(pc),a0
	moveq	#ds_error_text2_end-ds_error_text2,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
ds_alloc_entries_buffer_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_lock_playlist_file
	move.l	ds_playlist_file_name(a3),d1
	moveq	#ACCESS_READ,d2
	CALLDOS Lock		
	move.l	d0,ds_playlist_file_lock(a3)
	bne.s	ds_lock_playlist_file_ok
	lea	ds_error_text3(pc),a0
	moveq	#ds_error_text3_end-ds_error_text3,d0
	bsr	adl_print_text
	CALLLIBQ IoErr
 	CNOP 0,4
ds_lock_playlist_file_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_alloc_playlist_file_fib
	MOVEF.L fib_SIZEOF,d0
	MOVEF.L	MEMF_CLEAR+MEMF_PUBLIC+MEMF_ANY,d1
	CALLEXEC AllocMem
	move.l	d0,ds_playlist_file_fib(a3)
	bne.s	ds_alloc_playlist_file_fib_ok
	lea	ds_error_text4(pc),a0
	moveq	#ds_error_text4_end-ds_error_text4,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
ds_alloc_playlist_file_fib_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_get_playlist_file_length
	move.l	ds_playlist_file_lock(a3),d1
	move.l	ds_playlist_file_fib(a3),d2
	move.l	d2,a2
	CALLDOS Examine
	tst.l	d0		
	bne.s	ds_get_playlist_file_length_ok
	lea	ds_error_text5(pc),a0
	moveq	#ds_error_text5_end-ds_error_text5,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_get_playlist_file_length_ok
	move.l	fib_Size(a2),ds_playlist_file_length(a3) ; Länge der Playlist in Bytes
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_alloc_playlist_file_buffer
	move.l	ds_playlist_file_length(a3),d0
	move.l	#MEMF_CLEAR+MEMF_PUBLIC+MEMF_ANY,d1
	CALLEXEC AllocMem
	move.l	d0,ds_playlist_file_buffer(a3)
	bne.s	ds_alloc_playlist_file_buffer_ok
	lea	ds_error_text6(pc),a0
	moveq	#ds_error_text6_end-ds_error_text6,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
ds_alloc_playlist_file_buffer_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_open_playlist_file
	move.l	ds_playlist_file_name(a3),d1
	move.l	#MODE_OLDFILE,d2
	CALLDOS Open
	move.l	d0,ds_playlist_file_handle(a3)
	bne.s	ds_open_playlist_file_ok
	lea	ds_error_text7(pc),a0
	moveq	#ds_error_text7_end-ds_error_text7,d0
	bsr	adl_print_text
	CALLDOSQ IoErr
	CNOP 0,4
ds_open_playlist_file_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_read_playlist_file
	move.l	ds_playlist_file_handle(a3),d1
	move.l	ds_playlist_file_length(a3),d3
	move.l	ds_playlist_file_buffer(a3),d2
	CALLDOS Read
	tst.l	d0
	bpl.s	ds_read_playlist_file_ok
	lea	ds_error_text8(pc),a0
	moveq	#ds_error_text8_end-ds_error_text8,d0
	bsr	adl_print_text
	CALLDOSQ IoErr
	CNOP 0,4
ds_read_playlist_file_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_parse_playlist_file
	lea	ds_parsing_begin_text(pc),a0
	moveq	#ds_parsing_begin_text_end-ds_parsing_begin_text,d0
	bsr	adl_print_text
        moveq   #0,d0
	move.w	adl_entries_number(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Aktuelles Offset in Puffer ermitteln
	move.l	adl_entries_buffer(a3),a0
	add.l   d0,a0			; Zeiger auf Beginn des Pfadnamens
	move.l	a0,d6			; Zeiger auf Dateipfade-Puffer retten
	move.l	ds_playlist_file_buffer(a3),a2
	move.w	ds_playlist_file_length+WORD_SIZE(a3),d7
ds_parse_playlist_file_loop1
	subq.w	#1,d7			; Wegen dbf
	bpl.s	ds_parse_playlist_file_proceed
	bsr.s	ds_parse_playlist_result
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
ds_parse_playlist_file_proceed
	addq.w	#1,ds_playlist_entries_number(a3)
	move.l	#DOS_RDARGS,d1		; ReadArgs-Struktur erzeugen
	moveq	#0,d2			; Keine Tags
	CALLDOS AllocDosObject
	tst.l	d0
	bne.s	ds_alloc_dos_object_ok
	lea	ds_error_text9(pc),a0
	moveq	#ds_error_text9_end-ds_error_text9,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_alloc_dos_object_ok
	moveq	#0,d4			; Zähler für Länge einer Befehlszeile zurücksetzen
	move.l	d0,a4			; Zeiger auf RDArgs-Struktur
	move.l	a2,CS_Buffer(a4)	; Zeiger auf Playlist-File-Puffer eintragen
ds_parse_playlist_file_loop2
	addq.w	#1,d4
	cmp.b	#ASCII_LINE_FEED,(a2)+
	beq.s	ds_parse_playlist_entry
	dbf	d7,ds_parse_playlist_file_loop2
	bsr.s	ds_parse_playlist_result
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_parse_playlist_result
	move.w	ds_transmitted_entries_number(a3),d1 ; Dezimalzahl
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	ds_transmitted_entries(pc),a0 ; Zeiger auf String
	bsr	rp_dec_to_ascii
	move.w	ds_playlist_entries_number(a3),d1 ; Dezimalzahl
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	ds_playlist_entries(pc),a0 ; Zeiger auf String
	bsr	rp_dec_to_ascii
	move.w	adl_entries_number_max(a3),d1
	sub.w	adl_entries_number(a3),d1 ; Verbleibende Anzahl der zu ladenden Dateien ermitteln
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	ds_not_used_entries(pc),a0 ; Stringadresse
	bsr	rp_dec_to_ascii
	lea	ds_parsing_result_text(pc),a0
	move.l	#ds_parsing_result_text_end-ds_parsing_result_text,d0
	bra	adl_print_text


; ** Befehlszeile in der Playlist-Datei nach Argumenten untersuchen **
; Input
; d4 ... Länge der Befehlszeile
; a4 ... Zeiger auf RDArgs-Struktur
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
ds_parse_playlist_entry
	move.l	d4,CS_Length(a4)
	lea	ds_playlist_results_array(pc),a5
	moveq	#0,d0
	move.l	d0,pra_demofile(a5)	; Alle Arrays der Argumente löschen
	move.l	d0,pra_STARTMODE_OCS_VANILLA(a5)
	move.l	d0,pra_STARTMODE_AGA_VANILLA(a5)
	move.l	d0,pra_STARTMODE_TURBO(a5)
	move.l	d0,pra_SECS(a5)
	move.l	d0,pra_MINS(a5)
	move.l	d0,pra_LMBEXIT(a5)
	move.l	d0,pra_prerunscript(a5)
	lea	ds_playlist_template(pc),a0
	move.l	a0,d1			; Zeiger auf Befelsschablone für Playlist-Argumente
	move.l	a5,d2			; Zeiger auf Ergebnis-Felder für Playlist-Argumente
	move.l	a4,d3			; Eigene RDArgs-Struktur
	CALLDOS ReadArgs
	tst.l	d0
	bne.s	ds_parse_playlist_entry_ok
	bsr	ds_parse_entry_syntax_error
	bra	ds_free_DosObject
	CNOP 0,4
ds_parse_playlist_entry_ok
	move.l	d6,a0			; Zeiger auf Beginn des Pfadnamens
	bsr	ds_clear_playlist_entry
	move.l	d6,a1			; Zeiger auf Eintrag

; ** Argument demofile **
	move.l	pra_demofile(a5),d0
	bne.s	ds_check_arg_demofile_ok
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments
	CNOP 0,4
ds_check_arg_demofile_ok
	move.l	d0,a0			; Zeiger auf Dateiname des Demos
	moveq	#0,d0			; Zähler für Länge des Dateipfads zurücksetzen
ds_copy_demofile_path_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	ds_copy_demofile_path_ok
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments
	CNOP 0,4
ds_copy_demofile_path_ok
	move.b	(a0)+,(a1)+
	bne.s	ds_copy_demofile_path_loop ; Schleife, bis Nullbyte gefunden wurde

; ** Startmodi **
	clr.b	pqe_startmode(a1)
; ** Argument OCSVANILLA **
	tst.l	pra_STARTMODE_OCS_VANILLA(a5)
	beq.s	ds_check_arg_AGAVANILLA
	move.b	#STARTMODE_OCS_VANILLA,pqe_startmode(a1)
	bra.s	ds_check_start_mode

; ** Argument AGAVANILLA **
	CNOP 0,4
ds_check_arg_AGAVANILLA
	tst.l	pra_STARTMODE_AGA_VANILLA(a5)
	beq.s	ds_check_arg_TURBO
	move.b	#STARTMODE_AGA_VANILLA,pqe_startmode(a1)
	bra.s	ds_check_start_mode

; ** Argument TURBO **
	CNOP 0,4
ds_check_arg_TURBO
	tst.l	pra_STARTMODE_TURBO(a5)
	beq.s	ds_check_start_mode
	move.b	#STARTMODE_TURBO,pqe_startmode(a1)

ds_check_start_mode
	tst.b	pqe_startmode(a1)
	bne.s   ds_check_arg_SECS
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments

; ** Argument SECS **
	CNOP 0,4
ds_check_arg_SECS
	move.l	pra_SECS(a5),d0
	beq.s	ds_check_arg_MINS
	move.l	d0,a0			; Zeiger auf String
	move.l	(a0),d0			; Sekundenwert
	moveq	#rd_seconds_max,d2
	cmp.l	d2,d0
	ble.s   ds_check_arg_MINS
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments

; ** Argument MINS **
	CNOP 0,4
ds_check_arg_MINS
	move.l	pra_MINS(a5),d1
	beq.s	ds_calculate_ms_sum
	move.l	d1,a0			; Zeiger auf String
	move.l	(a0),d1			; Minutenwert
	moveq	#rd_minutes_max,d2
	cmp.l	d2,d1
	ble.s	ds_calculate_ms_sum
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments

	CNOP 0,4
ds_calculate_ms_sum
	MULUF.L 60,d1,d2		; *60 = Sekundenwert
	add.l	d0,d1			; + Sekundenwert = Gesamtwert Sekunden
	MULUF.L 10,d1,d0		; *10 = Zählerwert in 100 ms
	move.w	d1,pqe_playtime(a1)
	bne.s	check_arg_LMBEXIT
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments

; ** Argument LMBEXIT **
	CNOP 0,4
check_arg_LMBEXIT
	move.l	pra_LMBEXIT(a5),d0
	beq.s	ds_check_arg_prerunscript
	tst.w	pqe_playtime(a1)	; Kann ggf. entfallen s.o. ???
	bne.s	ds_check_arg_LMBEXIT_ok ; Kann ggf. entfallen ???
	bsr	ds_parse_playlist_entry_error ; Kann ggf. entfallen ???
	bra	ds_free_custom_arguments ; Kann ggf. entfallen ???
	CNOP 0,4			; Kann ggf. entfallen ???
ds_check_arg_LMBEXIT_ok			; Kann ggf. entfallen ???
	move.l	d0,a0			; Zeiger auf String
	move.l	(a0),d0			; Anzahl der Demoteile
	bne.s	ds_check_demo_parts_number_min
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments
	CNOP 0,4
ds_check_demo_parts_number_min
	cmp.w	#ds_demo_parts_number_min,d0
	bge.s	ds_check_demo_parts_number_max
	bsr	ds_parse_playlist_entry_error
	bra	ds_free_custom_arguments
	CNOP 0,4
ds_check_demo_parts_number_max
	cmp.w	#ds_demo_parts_number_max,d0
	ble.s	ds_arg_LMBEXIT_save_playtime
	bsr	ds_parse_playlist_entry_error
	bra.s	ds_free_custom_arguments
	CNOP 0,4
ds_arg_LMBEXIT_save_playtime
	subq.w	#1,d0			; Wert anpassen, da intern 1...9 übergeben wird
	add.w	d0,pqe_playtime(a1)

; ** Argument prerunscxript **
ds_check_arg_prerunscript
	move.l	pra_prerunscript(a5),d0
	beq.s	ds_next_transmitted_entry
	move.l	d0,a0			; Zeiger auf Dateiname des Scriptfiles
	move.l	d6,a1			; Zeiger auf Dateipfade-Puffer
	moveq	#0,d0			; Zähler für Länges des Dateipfads zurücksetzen
	ADDF.W	pqe_prerunscript_path,a1 ; Zeiger auf Prerunscript-Pfad in Dateipfade-Puffer
ds_copy_prerunscript_path_loop
	addq.b	#1,d0
	cmp.b	#adl_prerunscript_path_length-1,d0
	blt.s	ds_copy_prerunscript_ok
	bsr	ds_parse_playlist_entry_error
	bra.s	ds_free_custom_arguments
	CNOP 0,4
ds_copy_prerunscript_ok
	move.b	(a0)+,(a1)+
	bne.s	ds_copy_prerunscript_path_loop ; Schleife, bis Nullbyte gefunden wurd
ds_next_transmitted_entry
	addq.w	#1,ds_transmitted_entries_number(a3)
	addq.w	#1,adl_entries_number(a3)
	move.w	adl_entries_number_max(a3),d0
	cmp.w	adl_entries_number(a3),d0
	bne	ds_next_playlist_cmd_line
	bsr	ds_parse_playlist_result
	bra	ds_entries_number_max_reached
	CNOP 0,4
ds_next_playlist_cmd_line
	add.l	#playback_queue_entry_size,d6 ; Offset in Dateipfade-Puffer erhöhen = nächster Eintrag
ds_free_custom_arguments
	move.l	a4,d1			; Zeiger auf RDArgs-Struktur
	CALLDOS FreeArgs
ds_free_DosObject
	moveq	#DOS_RDARGS,d1		; ReadArgs-Struktur freigeben
	move.l	a4,d2			; Zeiger auf ReadArgs-Struktur
	CALLLIBS FreeDosObject
	bra	ds_parse_playlist_file_loop1


; Fehlerhaften Eintrag ausgeben
; Input
; d6 ... Zeiger auf Dateipfade-Puffer
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
ds_parse_playlist_entry_error
	move.l	d6,a0			; Zeiger auf Eintrag
	bsr.s	ds_clear_playlist_entry
	bra.s 	ds_parse_entry_syntax_error


; a0 ... Zeiger auf den Eintrag zum Löschen
	CNOP 0,4
ds_clear_playlist_entry
	moveq	#0,d0
	moveq	#((playback_queue_entry_size)/LONGWORD_SIZE)-1,d3 ; Länge des Eintrags in Langworten
ds_clear_playlist_entry_loop
	move.l	d0,(a0)+		; 4 Zeichen löschen
	dbf	d3,ds_clear_playlist_entry_loop
	rts


	CNOP 0,4
ds_parse_entry_syntax_error
	move.w	ds_playlist_entries_number(a3),d1 ; Dezimalzahl
	move.w	d7,d4			; Schleifenzähler retten
	lea	ds_entries_string(pc),a0 ; Zeiger auf String
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	move.w	d4,d7			; Schleifenzähler wieder herstellen
	lea	ds_error_text10(pc),a0
	moveq	#ds_error_text10_end-ds_error_text10,d0
	bra	adl_print_text


	CNOP 0,4
ds_open_asl_library
	lea	asl_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0
	CALLEXEC OpenLibrary
	lea	_ASLBase(pc),a0
	move.l	d0,(a0)
	bne.s	ds_open_asl_library_ok
	lea	ds_error_text11(pc),a0
	moveq	#ds_error_text11_end-ds_error_text11,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_open_asl_library_ok
	moveq	#RETURN_OK,d0
	rts


; Programm-Verzeichnis ermitteln
; Input
; a5 ... Zeiger auf Puffer für Verzeichnisnamen
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
ds_get_program_dir
	CALLDOS GetProgramDir
	tst.l	d0
	bne.s	ds_get_program_dir_name
	lea	ds_error_text12a(pc),a0
	moveq	#ds_error_text12a_end-ds_error_text12a,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_get_program_dir_name
	move.l	d0,d1			; Verzeichnis-Lock
	move.l	a5,d2			; Zeiger auf Puffer für Verzeichnisname
	MOVEF.L	adl_demofile_path_length,d3
	CALLLIBS NameFromLock
	tst.l	d0
	bne.s	ds_get_program_dir_name_ok
	lea	ds_error_text12b(pc),a0
	moveq	#ds_error_text12b_end-ds_error_text12b,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_DIR_NOT_FOUND,d0
	rts
	CNOP 0,4
ds_get_program_dir_name_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_display_remaining_files
	lea	ds_remaining_files(pc),a0 ; Stringadresse
	move.w	adl_entries_number_max(a3),d1 ; Maximale Anzahl der Einträge in Liste mit Dateipfaden
	sub.w	adl_entries_number(a3),d1 ; Verbleibende Anzahl der zu ladenden Dateien ermitteln
	cmp.w	#1,d1			; Nur noch ein File?
	bne.s	ds_request_title_ok	; Nein -> verzweige
	clr.b	ds_character_s-ds_remaining_files(a0) ; "s" von Demo"s" löschen
ds_request_title_ok
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bra	rp_dec_to_ascii


	CNOP 0,4
ds_init_asl_file_request
	moveq	#ASL_FileRequest,d0
	lea	ds_file_request_tag_list(pc),a0
	tst.w	rd_arg_softreset_enabled(a3)
	bne.s	ds_do_alloc_asl_request
	lea	ds_file_request_reboot(pc),a1
	move.l	a1,(ti_SIZEOF*3)+ti_data(a0) ; Zeiger auf negativen Text
ds_do_alloc_asl_request
	CALLASL AllocAslRequest
	move.l	d0,ds_file_request(a3)
	bne.s	ds_init_asl_file_request_ok
	lea	ds_error_text13(pc),a0
	moveq	#ds_error_text13_end-ds_error_text13,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_init_asl_file_request_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_display_file_request
	move.l	ds_file_request(a3),a0
	lea	ds_file_request_use_tag_list(pc),a1
	CALLASL AslRequest
	tst.l   d0
	bne.s	ds_display_file_request_ok
	moveq	#RETURN_WARN,d0
	rts
	CNOP 0,4
ds_display_file_request_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_get_demofile_path
	clr.w   ds_multiselect_entries_number(a3)
	move.l	ds_file_request(a3),a2
	move.l	fr_NumArgs(a2),d6
	move.w	d6,d0			; Anzahl retten
	add.w   adl_entries_number(a3),d0
	cmp.w   adl_entries_number_max(a3),d0
	blt.s   ds_entries_number_okay
	move.w  adl_entries_number_max(a3),d6
	sub.w   adl_entries_number(a3),d6 ; noch verbleibende Einträge
ds_entries_number_okay
	move.w  d6,ds_multiselect_entries_number(a3)
	moveq	#0,d5			; Erster Eintrag in ArgLists
	move.l	fr_ArgList(a2),a6
	subq.w	#1,d6			; wegen dbf
ds_multiselect_loop
	move.l	wa_Name(a6,d5.w*8),a0	; Zeiger auf Dateiname
	move.l	fr_Drawer(a2),a1	; Zeiger auf Verzeichnisname
	move.l	a2,-(a7)
	bsr	ds_check_demofile_path
	move.l	(a7)+,a2
	tst.l	d0
	beq.s	ds_next_multiselect_entry
	rts
	CNOP 0,4
ds_next_multiselect_entry
	addq.w	#1,d5			; nächster Eintrag in ArgLists
	dbf	d6,ds_multiselect_loop
	moveq	#RETURN_OK,d0
	rts

; Input
; a0 ... Zeiger auf Dateiname
; a1 ... Zeiger auf Verzeichnisname
; Result
; d0 ... Rückgabewert: DOS Error Code
	CNOP 0,4
ds_check_demofile_path
	tst.b	(a1)			; Verzeichnisname vorhanden?
 	bne.s	ds_check_demofile_name	; Ja -> verzweige
	lea	ds_error_text14(pc),a0
	moveq	#ds_error_text14_end-ds_error_text14,d0
	bsr	adl_print_text
	MOVEF.L ERROR_DIR_NOT_FOUND,d0
	rts
	CNOP 0,4
ds_check_demofile_name
	tst.b	(a0)			; Dateiname vorhanden?
	bne.s	ds_get_playback_entry_offset ; Ja -> verzweige
	lea	ds_error_text15(pc),a0
	moveq	#ds_error_text15_end-ds_error_text15,d0
	bsr	adl_print_text
	MOVEF.L ERROR_OBJECT_NOT_FOUND,d0
	rts
	CNOP 0,4
ds_get_playback_entry_offset
	moveq   #0,d0
	move.w	adl_entries_number(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Aktuelles Offset in Puffer ermitteln
	move.l	adl_entries_buffer(a3),a2 ; Zeiger auf Puffer für kompletten Pfadnamen
	add.l   d0,a2			; Zeiger auf aktuellen kompletten Pfadnamen
	move.l	a2,ds_current_pathname(a3) 
	move.l	a0,d1			; Zeiger auf Dateiname
	move.l	a2,a0			; Zeiger auf Eintrag
	bsr	ds_clear_playlist_entry
	move.l	d1,a0			; Zeiger auf Dateiname
	moveq	#"/",d2
	moveq	#":",d3
ds_check_demo_dir_name
	tst.b	(a1)			; Ende von Verzeichnisname (Nullbyte) ?
	beq.s	ds_copy_demofile_name_loop ; Ja -> verzweige
	cmp.b	(a1),d2			; Bei "/" auch Dateiname kopieren
	bne.s	ds_copy_demo_dir_name	; Sonst Verzeichnisname kopieren
	addq.w	#1,a1			; Nächstes Zeichen im Verzeichnisnamen
	bra.s	ds_check_demo_dir_name
	CNOP 0,4
ds_copy_demo_dir_name
	move.l	a5,a4			; Zeiger auf Puffer für aktuellen Verzeichnisnamen
	moveq	#0,d0			; Zähler für Länge des Dateipfads zurücksetzen
ds_copy_demo_dir_name_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	ds_copy_demo_dir_ok
	move.l	ds_current_pathname(a3),a0 ; Zeiger auf Eintrag
	bsr	ds_clear_playlist_entry
	lea	ds_error_text16(pc),a0
	moveq	#ds_error_text16_end-ds_error_text16,d0
	bsr	adl_print_text
	MOVEF.L ERROR_INVALID_COMPONENT_NAME,d0
	rts
	CNOP 0,4
ds_copy_demo_dir_ok
	move.b	(a1),(a2)+		; Ein Zeichen kopieren
	move.b	(a1)+,(a4)+
	tst.b	(a1)
	bne.s	ds_copy_demo_dir_name_loop ; Schleife, so lange bis Endes des Verzeichnisnamens (Nullbyte) erreicht ist
	clr.b	(a4)			; Nullbyte setzen
	cmp.b	-1(a1),d3		; War letztes Zeichen ein ":" ?
	beq.s	ds_copy_demofile_name_loop ; Ja -> Dateiname kopieren
	cmp.b	-1(a1),d2		; War letztes Zeichen ein "/" ?
	beq.s	ds_copy_demofile_name_loop ; Ja -> Dateiname kopieren
	move.b	d2,(a2)+		; Sonst "/" einfügen
ds_copy_demofile_name_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	ds_copy_demofile_name_ok
	move.l	ds_current_pathname(a3),a0 ; Zeiger auf Eintrag
	bsr	ds_clear_playlist_entry
	lea	ds_error_text16(pc),a0
	moveq	#ds_error_text16_end-ds_error_text16,d0
	bsr	adl_print_text
	MOVEF.L ERROR_INVALID_COMPONENT_NAME,d0
	rts
	CNOP 0,4
ds_copy_demofile_name_ok
	move.b	(a0)+,(a2)+
	cmp.b	(a0),d2			; Nächstes Zeiche ein "/" ?
	bne.s	ds_check_demofile_nullbyte ; Nein -> verzweige
	lea	ds_error_text15(pc),a0
	moveq	#ds_error_text15_end-ds_error_text15,d0
	bsr	adl_print_text
	MOVEF.L ERROR_OBJECT_NOT_FOUND,d0
	rts
	CNOP 0,4
ds_check_demofile_nullbyte
	tst.b	(a0)
	bne.s	ds_copy_demofile_name_loop ; Schleife, so lange bis Endes des Verzeichnisnamens erreicht ist
	clr.b	(a2)			; Nullbyte setzen
	addq.w	#1,adl_entries_number(a3)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_free_file_request
	move.l	ds_file_request(a3),a0
	CALLASLQ FreeAslRequest


	CNOP 0,4
ds_display_startmode_request
	move.l	a3,a4			; Inhalt von a3 retten
	sub.l	a0,a0			; Requester erscheint auf Workbench
	lea	ds_startmode_request(pc),a1
	move.l	a0,a2			; Keine IDCMP-Flags
	move.l	a0,a3			; Keine Argumentenliste
	CALLINT EasyRequestArgs
	move.l	a4,a3			; Alter Inhalt von a3
	move.l	ds_current_pathname(a3),a0
	addq.b  #1,d0                   ; Ergebnis korrigieren
	MOVEF.L playback_queue_entry_size,d1 ; Größe des Eintrags
	move.w	ds_multiselect_entries_number(a3),d7
	subq.w	#1,d7			;wegen dbf
ds_start_loop
	move.b	d0,pqe_startmode(a0)	; Kennung eintragen
	sub.l	d1,a0			; vorheriger Pfadname
	dbf	d7,ds_start_loop
	rts


	CNOP 0,4
ds_init_reset_program
	move.l	#rp_reset_program_end-rp_reset_program,d0 ; Programmlänge
	move.w	d0,d7		
	moveq	#0,d1
	move.w	adl_entries_number_max(a3),d1 ; Maximale Anzahl der Einträge in Liste mit Pfadnamen
	MULUF.L playback_queue_entry_size,d1,d2 ; Offset in Puffer ermitteln
	add.l	d1,d0			; + Länge des Puffers für die Dateipfade
	lea	rp_reset_program_size(pc),a0
	move.l	d0,(a0)			; Gesamtlänge des Reset-Programms mit Einträge-Puffer
	move.l	#MEMF_PUBLIC+MEMF_CHIP+MEMF_CLEAR+MEMF_REVERSE,d1
	CALLEXEC AllocMem
	lea	rp_reset_program_memory(pc),a0
	move.l	d0,(a0)
	bne.s	ds_copy_reset_program
	lea	ds_error_text17(pc),a0
	moveq	#ds_error_text17_end-ds_error_text17,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
ds_copy_reset_program
	lea	rp_reset_program(pc),a0	; Quelle
	move.l	d0,a1			; Ziel: Speicherbereich
	move.l	d0,a2			; Reset-Programm im Speicher
	move.l	d0,CoolCapture(a6)
	subq.w	#1,d7			; wegen dbf
ds_copy_reset_program_loop
	move.b	(a0)+,(a1)+
	dbf	d7,ds_copy_reset_program_loop
	move.l	adl_entries_buffer(a3),a0 ; Quelle
	move.w	adl_entries_number_max(a3),d7
	MULUF.W playback_queue_entry_size,d7,d0 ; Größe zum Kopieren ermitteln
	subq.w	#1,d7			; wegen dbf
ds_copy_entries_buffer_loop
	move.b	(a0)+,(a1)+
	dbf	d7,ds_copy_entries_buffer_loop
	bsr	rp_calculate_checksum
	CALLLIBS CacheClearU
	jsr	rp_install_custom_exception_vectors-rp_reset_program(a2) ; Zeiger auf eigene Exception/Trap-Routinen initialisieren
	lea	rp_read_VBR(pc),a5
	CALLLIBS Supervisor
	tst.l	d0			; VBR = $000000000 ?
	beq.s	ds_install_custom_exceptions_ok ; Ja -> verzweige
	RP_POINTER_CUSTOM_TRAP_VECTORS
	move.l	d0,a0 			; Quelle
	move.w	#TRAP_0_VECTOR,a1	; Ziel: Ab Trap0-Vektor im chip memory
	IFEQ adl_level_7_handler_enabled
  		moveq	#8-1,d7		; Anzahl der Trap-Vektoren
	ELSE
		moveq	#7-1,d7		; Anzahl der Trap-Vektoren
	ENDC
ds_copy_custom_trap_vectors_loop
	move.l	(a0)+,(a1)+
	dbf	d7,ds_copy_custom_trap_vectors_loop
	CALLLIBS CacheClearU
ds_install_custom_exceptions_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
ds_close_asl_library
	move.l	_ASLBase(pc),a1
	CALLEXECQ CloseLibrary


	CNOP 0,4
ds_close_playlist_file
	move.l	ds_playlist_file_handle(a3),d1
	CALLDOSQ Close


	CNOP 0,4
ds_free_playlist_file_buffer
	move.l	ds_playlist_file_buffer(a3),a1
	move.l	ds_playlist_file_length(a3),d0
	CALLEXECQ FreeMem


	CNOP 0,4
ds_free_playlist_file_fib
	move.l	ds_playlist_file_fib(a3),a1
	move.l	#fib_SIZEOF,d0
	CALLEXECQ FreeMem


	CNOP 0,4
ds_unlock_playlist_file
	move.l ds_playlist_file_lock(a3),d1
	CALLDOSQ UnLock


	CNOP 0,4
ds_free_entries_buffer
	tst.w	adl_reset_program_active(a3)
	beq.s	ds_free_entries_buffer_skip
	move.l	adl_entries_buffer(a3),a1
	moveq	#0,d0
	move.w	adl_entries_number_max(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Größe des Puffers ermitteln
	CALLEXECQ FreeMem
	CNOP 0,4
ds_free_entries_buffer_skip
	rts


; **** Run-Demo ****
	CNOP 0,4
rd_start
	tst.w	rd_arg_remove_enabled(a3)
	beq	rd_cleanup_reset_program
	tst.w	rd_arg_showqueue_enabled(a3)
	beq	rd_show_queue
	RP_POINTER_ENDLESS_ENABLED
	move.l	d0,a0
	move.w	rd_arg_endless_enabled(a3),(a0)
	bsr	rd_open_ciaa_resource
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_graphics_library
	bsr	rd_open_ciab_resource
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_graphics_library
	bsr	rd_open_icon_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_graphics_library
	bsr	rd_create_serial_msg_port
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_icon_library
	bsr	rd_init_serial_io
	bsr	rd_open_serial_device
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_serial_message_port
	bsr	rd_alloc_sprite_data
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_serial_device
	bsr	sf_alloc_color_table
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_sprite_data
	bsr	sf_alloc_color_cache
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_color_table
rd_start_loop
	bsr	rd_get_demofile_name
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_open_demofile
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_read_demofile_header
        bsr     rd_close_demofile
	bsr	rd_check_demofile_header
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_init_serial_output_start
	bsr	rd_execute_prerunscript
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_check_fast_memory
	bsr	rd_load_demo
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_fast_memory
	bsr	rd_check_demo_header
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_demofile
	bsr	rd_set_new_current_dir
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_demofile
	bsr	rd_open_screen
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_current_dir
	bsr	rd_downgrade_sprite_resolution
	bsr	rd_open_window
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_screen
	bsr	rd_clear_mousepointer
	bsr	rd_fade_out_screen
	bsr	rd_control_timer
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_screen_colors
	bsr	rd_downgrade_display
	bsr	rd_save_custom_trap_vectors
	bsr	rd_downgrade_CPU
	bsr	rd_save_chips_registers
	bsr	rd_run_demo
	bsr	rd_clear_chips_registers
	bsr	rd_restore_chips_registers
	bsr	rd_upgrade_CPU
	bsr	rd_restore_custom_trap_vectors
	bsr	rd_restore_display
	bsr	rd_init_serial_output_stop
	bsr	rd_set_timer

rd_cleanup_screen_colors
	bsr	rd_fade_in_screen
rs_cleanup_sprites
	bsr	rd_restore_sprite_resolution
rd_cleanup_window
	bsr	rd_close_window
rd_cleanup_screen
	bsr	rd_close_screen
rd_cleanup_current_dir
	bsr	rd_restore_current_dir
rd_cleanup_demo_dir
	bsr	rd_unlock_demo_dir
rd_cleanup_demofile
	bsr	rd_unload_demofile
rd_cleanup_fast_memory
	bsr	rd_free_fast_memory
rd_cleanup_io_error
	bsr	adl_print_io_error
	bsr	rd_check_demofile_pathtags
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_color_cache
	bsr	rd_check_arg_LOOP_enabled
	tst.l	d0
	beq	rd_start_loop
rd_cleanup_color_cache
	bsr	sf_free_color_cache
rd_cleanup_color_table
	bsr	sf_free_color_table
rd_cleanup_sprite_data
	bsr	rd_free_sprite_data
rd_cleanup_serial_device
	bsr	rd_close_serial_device
rd_cleanup_serial_message_port
	bsr	rd_delete_serial_message_port
rd_cleanup_icon_library
	bsr	rd_close_icon_library
rd_cleanup_reset_program
	bsr	rd_remove_reset_program
	bra	adl_cleanup_intuition_library


	CNOP 0,4
rd_show_queue
	moveq	#1,d5			; Zähler für Einträge
	move.l	adl_entries_buffer(a3),a2
	move.w	#playback_queue_entry_size,a4
	move.w	adl_entries_number(a3),d7
	subq.w	#1,d7			; wegen dbf
rd_show_queue_loop
	lea	rd_show_entry_header(pc),a0
	moveq	#rd_show_entry_string-rd_show_entry_header,d0
	bsr	adl_print_text
	move.w	d5,d1			; Wert zum Umwandeln
	move.w	d7,d4		        ; Schleifenzähler retten
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	rd_show_entry_string(pc),a0 ; Zeiger auf ASCII-Wert
	bsr	rp_dec_to_ascii
	move.w	d4,d7			; Schleifenzähler wieder herstellen
	lea	rd_show_entry_string(pc),a0
	moveq	#rd_show_entry_string_end-rd_show_entry_string,d0
	bsr	adl_print_text
	move.l	a2,a0			; Zeiger auf Eintrag in Playback-Queue
	moveq	#adl_demofile_path_length-1,d6
	moveq	#0,d0			; Zähler für Demo-Dateinamen-Länge
	add.l	d6,a0			; Zeiger auf letztes Zeichen (Nullbyte)
	moveq	#"/",d2
	moveq	#":",d3
rd_get_entry_filename_loop
	tst.b	(a0)
	beq.s	rd_get_entry_filename_skip
	addq.w	#1,d0
rd_get_entry_filename_skip
	cmp.b	(a0),d2			; "/" gefunden ?
	beq.s	rd_entry_filename_ok 	; Ja -> verzweige
	cmp.b	(a0),d3			; ":" gefunden ?
	beq.s	rd_entry_filename_ok 	; Ja -> verzweige
	subq.w	#1,a0			; vorgeriges Zeichen in Dateipfad
	dbf	d6,rd_get_entry_filename_loop
rd_entry_filename_ok
	subq.w	#1,d0			; "/" oder ":" abziehen
	addq.w	#1,a0			; "/" oder ":" überspringen
	cmp.w	#rd_show_entry_space_end-rd_show_entry_space-1,d0 ; Länge des Dateinamens <= Füllzeile ?
	ble.s	rd_filename_length_ok	; Ja -> verzweige
	moveq	#rd_show_entry_space_end-rd_show_entry_space-1,d0 ; Textlänge = Länge Füllzeile
rd_filename_length_ok
	move.w	d0,d4			; Länge des Dateinamens
	bsr	adl_print_text
	lea	rd_show_entry_space(pc),a0 ; Zeiger auf "..."-String
	moveq	#rd_show_entry_space_end-rd_show_entry_space-1,d0 ; Textlänge der Füllzeile
	sub.w	d4,d0			; Länge des Dateinamens abziehen
	bsr	adl_print_text
	tst.b	pqe_tag_active(a2)
	beq.s	rd_print_negative_tag_msg
rd_print_positive_tag_msg
	lea	rd_tag_active_text1(pc),a0
	moveq	#rd_tag_active_text1_end-rd_tag_active_text1,d0
	bsr	adl_print_text
	bra.s	rd_tag_msg_skip
	CNOP 0,4
rd_print_negative_tag_msg
	lea	rd_tag_active_text2(pc),a0
	moveq	#rd_tag_active_text2_end-rd_tag_active_text2,d0
	bsr	adl_print_text
rd_tag_msg_skip
	add.l	a4,a2			; nächster Eintrag in Playback Queue
	addq.w	#1,d5
	dbf	d7,rd_show_queue_loop
	lea	rd_not_used_entries_string(pc),a0 ; Stringadresse
	move.w	adl_entries_number_max(a3),d1
	sub.w	adl_entries_number(a3),d1 ; Verbleibende Anzahl der zu ladenden Dateien ermitteln
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	lea	rd_message_text(pc),a0
	moveq	#rd_message_text_end-rd_message_text,d0
	bsr	adl_print_text
	bra	rd_cleanup_icon_library


	CNOP 0,4
rd_open_ciaa_resource
	lea	CIAA_resource_name(pc),a1
	CALLEXEC OpenResource
	lea	_CIABase(pc),a0
	move.l	d0,(a0)
	bne.s	rd_open_ciaa_resource_ok
	lea	rd_error_text2a(pc),a0
	moveq	#rd_error_text2a_end-rd_error_text2a,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_ciaa_resource_ok
	moveq	#0,d0			; Keine Maske
	CALLCIA AbleICR
	move.b	d0,rd_old_ciaa_icr(a3)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_open_ciab_resource
	lea	CIAB_resource_name(pc),a1
	CALLEXEC OpenResource
	lea	_CIABase(pc),a0
	move.l	d0,(a0)
	bne.s	rd_open_ciab_resource_ok
	lea	rd_error_text2b(pc),a0
	moveq	#rd_error_text2b_end-rd_error_text2b,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_ciab_resource_ok
	moveq	#0,d0			; keine Maske
	CALLCIA AbleICR
	move.b	d0,rd_old_ciab_icr(a3) 
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_open_icon_library
	lea	icon_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0 ;Version 2.04+
	CALLEXEC OpenLibrary
	lea	_IconBase(pc),a0
	move.l	d0,(a0)
	bne.s	rd_open_icon_library_ok
	lea	rd_error_text3(pc),a0
	moveq	#rd_error_text3_end-rd_error_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_icon_library_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_create_serial_msg_port
	CALLEXEC CreateMsgPort
	move.l	d0,rd_serial_message_port(a3)
	bne.s	rd_create_serial_msg_port_ok
	lea	rd_error_text4(pc),a0
	moveq	#rd_error_text4_end-rd_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_create_serial_msg_port_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_init_serial_io
	lea	rd_serial_io(pc),a0
	move.l	rd_serial_message_port(a3),MN_ReplyPort(a0)
	moveq	#0,d0
	move.b	d0,LN_Type(a0)
	move.b	d0,LN_Pri(a0)
	move.l	d0,LN_Name(a0)
	rts


	CNOP 0,4
rd_open_serial_device
	lea	serial_device_name(pc),a0
	lea	rd_serial_io(pc),a1
	moveq	#0,d0			; Unit 0
	moveq	#0,d1			; Keine Flags
	CALLEXEC OpenDevice
	tst.l	d0
	beq.s	rd_open_serial_device_ok
	lea	rd_error_text5(pc),a0
	moveq	#rd_error_text5_end-rd_error_text5,d0
	bsr	adl_print_text
	CALLDOSQ IOErr
	CNOP 0,4
rd_open_serial_device_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_alloc_sprite_data
	moveq	#6*WORD_SIZE,d0		; Größe der Speicherbereiches
	move.l	#MEMF_CLEAR+MEMF_CHIP+MEMF_PUBLIC+MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,rd_sprite_data(a3)
	bne.s	rd_alloc_sprite_data_ok
	lea	rd_error_text6(pc),a0
	moveq	#rd_error_text6_end-rd_error_text6,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
rd_alloc_sprite_data_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
sf_alloc_color_table
	move.l	#sf_colors_number_max*3*LONGWORD_SIZE,d0
	move.l	#MEMF_CLEAR+MEMF_ANY+MEMF_PUBLIC+MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,sf_color_table(a3)
	bne.s	sf_alloc_color_table_ok
	lea	rd_error_text7(pc),a0
	moveq	#rd_error_text7_end-rd_error_text7,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
sf_alloc_color_table_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
sf_alloc_color_cache
	move.l	#sf_colors_number_max*3*LONGWORD_SIZE,d0
	move.l	#MEMF_CLEAR+MEMF_ANY+MEMF_PUBLIC+MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,sf_color_cache(a3)
	bne.s	sf_alloc_color_cache_ok
	lea	rd_error_text8(pc),a0
	moveq	#rd_error_text8_end-rd_error_text8,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
sf_alloc_color_cache_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_get_demofile_name
	move.w	rd_arg_playentry_offset(a3),d0
	subq.w	#1,d0			; Zählung beginnt bei Null
	bpl.s	rd_calculate_entry_offset
	tst.w	rd_arg_random_enabled(a3)
	beq	rd_random_entry_offsets
	RP_POINTER_ENTRIES_OFFSET
	move.l	d0,a0
	moveq	#0,d0
	move.w	(a0),d0
	addq.w	#1,(a0)			; Variable rp_entries_offset erhöhen
rd_calculate_entry_offset
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Dateipfade-Puffer berechnen
	move.l	adl_entries_buffer(a3),a0 ; Zeiger auf Puffer für Einträge
	add.l	d0,a0			; Offset in Dateipfade-Puffer
rd_check_demofile_path
	move.l	a0,rd_demofile_path(a3)
	move.l	a0,a2
	moveq	#0,d0			; Zähler für Dateinamen-Länge
	moveq	#"/",d2
	moveq	#":",d3
	moveq	#adl_demofile_path_length-1,d7
	add.l	d7,a0			; Zeiger auf letztes Zeichen (Nullbyte)
rd_get_demofile_name_loop
	tst.b	(a0)
	beq.s	rd_get_demofile_name_skip
	addq.w	#1,d0
rd_get_demofile_name_skip
	cmp.b	(a0),d2			; "/" gefunden ?
	beq.s	rd_demofile_name_ok	; Ja -> verzweige
	cmp.b	(a0),d3			; ":" gefunden ?
	beq.s	rd_demofile_name_ok	; Ja -> verzweige
	subq.w	#1,a0			; vorgeriges Zeichen in Dateipfad
	dbf	d7,rd_get_demofile_name_loop
rd_demofile_name_ok
	addq.w	#1,a0			; "/" oder ":" überspringen
	move.l	a0,rd_demofile_name(a3) ; Zeiger auf Dateinamen retten
	subq.w	#1,d0			; "/" oder ":" abziehen
	move.l	d0,rd_demofile_name_length(a3)
	lea	rd_demofile_name_header(pc),a0
	moveq	#rd_demofile_name_header_end-rd_demofile_name_header,d0
	bsr	adl_print_text
	move.l	rd_demofile_name(a3),a0
	move.l	rd_demofile_name_length(a3),d0
	bsr	adl_print_text
	lea	rd_demofile_name_tail(pc),a0
	moveq	#rd_demofile_name_tail_end-rd_demofile_name_tail,d0
	bsr	adl_print_text
	move.l	a2,a0			; Zeiger auf Eintrag
	tst.b	pqe_tag_active(a0)
	beq.s	rd_check_arguments
	lea	rd_error_text9(pc),a0
	moveq	#rd_error_text9_end-rd_error_text9,d0
	bsr	adl_print_text
	moveq	#RETURN_WARN,d0
	rts
	CNOP 0,4
rd_check_arguments
	tst.w	rd_arg_prerunscript_enabled(a3)
	beq.s	rd_no_prerunscript_path
	lea	pqe_prerunscript_path(a0),a1
	tst.b	(a1)			; Pfad angegeben ?
	beq.s	rd_no_prerunscript_path	; Nein -> verzweige
	move.l	a1,rd_prerunscript_path(a3)
rd_no_prerunscript_path
	move.b	#FALSE,pqe_tag_active(a0) ; Demo wurde ausgeführt
	moveq	#RETURN_OK,d0
	rts

	CNOP 0,4
rd_random_entry_offsets
	move.l	#_CUSTOM+VHPOSR,a1
	move.w	adl_entries_number(a3),d1
	move.l	#_CIAA+CIATODLOW,a2
	move.w	(a1),d0		;f(x)
	move.l	#_CIAB+CIATODLOW,a4
rd_random_entry_offsets_loop
	mulu.w	(a1),d0			; f(x)*a
	move.w	(a1),d2
	swap	d2
	move.b	(a2),d2
	lsl.w	#8,d2
	move.b	(a4),d2			; b
	add.l	d2,d0			; (f(x)*a)+b
	and.l	#$0000ffff,d0		; Nur Low-Word
	divu.w	d1,d0			; f(x+1) = [(f(x)*a)+b]/mod rp_entries_number
	swap	d0			; Rest der Division = Zufallsoffset
	ext.l	d0
	MULUF.L playback_queue_entry_size,d0,d2 ; Offset in Dateipfade-Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0			; Offset in Dateipfade-Puffer
	tst.b	pqe_tag_active(a0)
	bne.s	rd_random_entry_offsets_loop
	bra	rd_check_demofile_path


	CNOP 0,4
rd_open_demofile
	move.l	rd_demofile_path(a3),d1
	move.l	#MODE_OLDFILE,d2
	CALLDOS Open
	move.l	d0,rd_demofile_handle(a3)
	bne.s	rd_open_demofile_ok
	lea	rd_error_text10(pc),a0
	moveq	#rd_error_text10_end-rd_error_text10,d0
	bsr	adl_print_text
	CALLDOSQ IoErr
	CNOP 0,4
rd_open_demofile_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_read_demofile_header
	move.l	rd_demofile_handle(a3),d1
	lea	rd_demofile_MAGIC_COOKIE(a3),a0
	move.l	a0,d2			; Zeiger auf Puffer
	moveq	#LONGWORD_SIZE,d3	; Anzahl der Zeichen zum Lesen
	CALLDOSQ Read


	CNOP 0,4
rd_close_demofile
	move.l	rd_demofile_handle(a3),d1
	CALLDOSQ Close


	CNOP 0,4
rd_check_demofile_header
	cmp.l	#MAGIC_COOKIE,rd_demofile_MAGIC_COOKIE(a3)
	beq.s	rd_check_demofile_header_ok
	lea	rd_error_text11(pc),a0
	moveq	#rd_error_text11_end-rd_error_text11,d0
	bsr	adl_print_text
	MOVEF.L ERROR_FILE_NOT_OBJECT,d0
	rts
	CNOP 0,4
rd_check_demofile_header_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_init_serial_output_start
	move.w	rd_play_duration(a3),d1
	bne.s	rd_create_output_string
	move.l	rd_demofile_path(a3),a0
	add.w	pqe_playtime(a0),d1
	bne.s	rd_create_output_string
	rts


; Output-String mit Spieldauer initialisieren
; Input
; d1 ... Spieldauer
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_create_output_string
	move.w	d1,rd_play_duration(a3)
	moveq	#5,d7			; Anzahl der Stellen zum Umwandeln
	lea	rd_output_string_duration(pc),a0 ; Stringadresse
	bsr	rp_dec_to_ascii
	moveq	#rd_output_string_checksum-rd_output_string,d7 ; Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
	lea	rd_output_string(pc),a0 ; Zeiger auf Ausgabe-String
	bsr	rp_get_ascii_checksum
	move.w  d0,d1
	bsr	rp_dec_to_hex
	move.w  d0,d1
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	rd_output_string_checksum(pc),a0 ; Zeiger auf String
	bra	rp_hex_to_ascii


	CNOP 0,4
rd_execute_prerunscript
	move.l	rd_prerunscript_path(a3),d0
	bne.s	rd_copy_prerunscript_filename
	rts
	CNOP 0,4
rd_copy_prerunscript_filename
	move.l	d0,a0			; Quelle: Prerunscript-Name
	lea	rd_prerunscript_cmd_line_path(pc),a1 ; Ziel: Befehlszeile
	moveq	#adl_prerunscript_path_length-1,d7
rd_copy_prerunscript_filename_loop
	move.b	(a0)+,(a1)+
	dbeq	d7,rd_copy_prerunscript_filename_loop ;Schleife solange, bis Nullbxte gefunden wurde
	lea	rd_prerunscript_cmd_line(pc),a0
	move.l	a0,d1			; Zeiger auf Kommandozeile
	moveq	#0,d2			; Kein Input
	moveq	#0,d3			; Kein Output
	CALLDOS Execute
	tst.l	d0
	bne.s	rd_execute_prerunscript_ok
	lea	rd_error_text12(pc),a0
	moveq	#rd_error_text12_end-rd_error_text12,d0
	bsr	adl_print_text
	moveq	#RETURN_ERROR,d0
        rts
	CNOP 0,4
rd_execute_prerunscript_ok
	CALLLIBQ IoErr


; ** Fast-memory ggf. ausschalten **
	CNOP 0,4
rd_check_fast_memory
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_TURBO,pqe_startmode(a0)
	beq.s	rd_turn_off_fast_memory_ok
rd_turn_off_fast_memory
	move.l	#MEMF_FAST+MEMF_LARGEST,d1
	move.l	d1,d2
	CALLEXEC AvailMem
	move.l	d0,rd_available_fast_memory_size(a3)
	beq.s	rd_turn_off_fast_memory_ok
	move.l	d2,d1			; Größter Fast-memory Block
	CALLLIBS AllocMem		
	move.l	d0,rd_available_fast_memory(a3)
	move.l	d0,a2
rd_turn_off_fast_memory_loop
	move.l	d2,d1			; Größter Fast-memory Block
	CALLLIBS AvailMem
	move.l	d0,(a2)+
	beq.s	rd_turn_off_fast_memory_ok
	move.l	d2,d1			; Größter Fast-memory Block
	CALLLIBS AllocMem
	move.l	d0,(a2)+		; Zeiger auf Speichernlock
	bra.s	rd_turn_off_fast_memory_loop
	CNOP 0,4
rd_turn_off_fast_memory_ok
	rts


	CNOP 0,4
rd_load_demo
	move.l	rd_demofile_path(a3),d1
	CALLDOS LoadSeg
	move.l	d0,rd_demofile_seglist(a3)
	bne.s	rd_load_demo_ok
	lea	rd_error_text13(pc),a0
	moveq	#rd_error_text13_end-rd_error_text13,d0
	bsr	adl_print_text
	CALLDOSQ IoErr
	CNOP 0,4
rd_load_demo_ok
	moveq	#RETURN_OK,d0
	rts


; ** Prüfen, ob es sich um eine WHDLoad Slave-Datei handelt **
	CNOP 0,4
rd_check_demo_header
	move.l	rd_demofile_seglist(a3),a0
	add.l	a0,a0			; BCPL-Zeiger
	add.l	a0,a0
	cmp.l	#"WHDL",8(a0)
	beq.s	rd_check_id_second_part
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
rd_check_id_second_part
	cmp.l	#"OADS",12(a0)
	beq.s	rd_create_whdload_cmd_string
	moveq	#RETURN_OK,d0
        rts
	CNOP 0,4
rd_create_whdload_cmd_string
	clr.w	whdl_slave_enabled(a3)
	move.l	rd_demofile_name(a3),a0
	lea	whdl_slave_cmd_line_path(pc),a1 ; Zeiger auf Dateinamen in Kommand-String
	move.l	rd_demofile_name_length(a3),d7 ; Lämge inklusive Nullbyte
rd_copy_slave_filename_loop
	move.b	(a0)+,(a1)+
	dbf	d7,rd_copy_slave_filename_loop
	move.l	a1,a2			; Zeiger auf Dateipfadende in Kommando-String retten
	move.l	rd_demofile_path(a3),a0 ; Zeiger auf Slave-Dateipfad
	lea	whdl_icon_path(pc),a1 ; Zeiger auf Icon-Dateipfad
	moveq	#adl_demofile_path_length-1,d7
rd_copy_slave_filepath_loop
	move.b	(a0)+,(a1)+
	dbeq	d7,rd_copy_slave_filepath_loop ;Schleife solange, bis Nullbyte gefundne
	subq.w	#7,a1			; Endung ".slave",0 in Icon-Dateipfad überspringen
	clr.b	(a1)			; Nullbyte einfügen
rd_check_icon_tooltypes
	lea	whdl_icon_path(pc),a0
	CALLICON GetDiskObject
	move.l	d0,whdl_disk_object(a3)
	bne.s	whdl_disk_object_ok
	lea	rd_error_text14(pc),a0
	moveq	#rd_error_text14_end-rd_error_text14,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
whdl_disk_object_ok
	move.l	d0,a0
	move.l	do_ToolTypes(a0),a0
	move.l	a0,a4		
	lea	whdl_tooltype_PRELOAD(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; Tooltype "PRELOAD" gefunden ?
	beq.s	rd_check_tooltype_PRELOADSIZE ; Nein -> verzweige
	subq.w	#1,a2			; Zeiger auf Nullbyte
	move.b	#" ",(a2)+		; und durch Space-Zeichen ersetzen
	move.b	#"P",(a2)+		; Argument "Preload" in String einfügen
	move.b	#"r",(a2)+
	move.b	#"e",(a2)+
	move.b	#"l",(a2)+
	move.b	#"o",(a2)+
	move.b	#"a",(a2)+
	move.b	#"d",(a2)+
	clr.b	(a2)+			; Nullbyte einfügen
rd_check_tooltype_PRELOADSIZE
	move.l	a4,a0			; Zeiger auf Tooltypes-Feld
	lea	whdl_tooltype_PRELOADSIZE(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; Tooltype "PRELOADSIZE" gefunden ?
	beq.s	rd_check_tooltype_QUITKEY ; Nein -> verzweige
	subq.w	#1,a2			; Zeiger auf Nullbyte
	move.b	#" ",(a2)+		; und durch Space-Zeichen ersetzen
	move.b	#"P",(a2)+		; Argument "Preloadsize" in String einfügen
	move.b	#"r",(a2)+
	move.b	#"e",(a2)+
	move.b	#"l",(a2)+
	move.b	#"o",(a2)+
	move.b	#"a",(a2)+
	move.b	#"d",(a2)+
	move.b	#"s",(a2)+
	move.b	#"i",(a2)+
	move.b	#"z",(a2)+
	move.b	#"e",(a2)+
	move.b	#" ",(a2)+		; Space
	move.l	d0,a0			; Zeiger auf Wert von Argument "PRELOADSIZE"
rd_copy_PRELOADSIZE_value
	move.b	(a0)+,(a2)+
	bne.s	rd_copy_PRELOADSIZE_value
rd_check_tooltype_QUITKEY
	move.l	a4,a0			; Zeiger auf Tooltypes-Feld
	lea	whdl_tooltype_QUITKEY(pc),a1 ; Zeiger auf String "QUITKEY"
	CALLLIBS FindToolType
	tst.l	d0			; Tooltype "QUITKEY" gefunden ?
	beq.s	rd_free_whdload_disk_object ; Nein -> verzweige
	subq.w	#1,a2			; Zeiger auf Nullbyte
	move.b	#" ",(a2)+		; und durch Space-Zeichen ersetzen
	move.b	#"Q",(a2)+		; Argument "Quitkey" in String einfügen
	move.b	#"u",(a2)+
	move.b	#"i",(a2)+
	move.b	#"t",(a2)+
	move.b	#"k",(a2)+
	move.b	#"e",(a2)+
	move.b	#"y",(a2)+
	move.b	#" ",(a2)+		; Space
	move.l	d0,a0			; Zeiger auf Wert von Argument "QUITKEY"
	cmp.b	#"$",(a0)		; Hex-Zahl ?
	beq.s	rd_convert_QUITKEY_hexvalue ; Ja -> verzweige
rd_copy_QUITKEY_value
	move.b	(a0)+,(a2)+		; QUITKEY-Wert nach Kommando-String kopieren
	bne.s	rd_copy_QUITKEY_value
	bsr.s	rd_convert_QUITKEY_hexvalue
rd_free_whdload_disk_object
	move.l	whdl_disk_object(a3),a0 ; Zeiger auf Disk-Objekt-Struktur
	CALLLIBS FreeDiskObject
	moveq	#RETURN_OK,d0
	rts

; Input
; a0 ...
; a2 ...
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_convert_QUITKEY_hexvalue
	addq.w	#1,a0			; "$"-Zeichen in String überspringen
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr.s	rd_ascii_to_hex
	move.l	a2,a0			; Zeiger auf Kommando-String
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	clr.b	(a0)			; Nullbyte in Kommando-String setzen
	rts


; ** ASCII-Zeichen in Hexadezimalzahl umwandeln **
; Input
; a0 ... Zeiger auf String
; d1 ... Rückgabewert = Hexadezimalzahl
; d7 ... Anzahl der Stellen zum Umwandeln
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_ascii_to_hex
	add.l	d7,a0			; Zeiger auf Ende des Strings
	moveq	#0,d1			; Hexadezimalzahl
	moveq	#0,d2			; Erster Hex-Stellenwert 16^0 als Shiftwert 0
	subq.w	#1,d7			; wegen dbf
rd_ascii_to_hex_loop
	moveq	#0,d0			; 32-Bit Zugriff
	move.b	-(a0),d0		; ASCII-Wert lesen
	sub.b	#"0",d0			; ASCII-Wert "0" abziehen = 0...9
	cmp.b	#9,d0			; Hex-Ziffern 0...9 ?
	ble.s	rd_ascii_to_hex_ok	; Ja -> verzweige
	subq.b	#7,d0			; ASCII-Wert "A" abziehen
	cmp.b	#15,d0			; Hex-Ziffern A...F ?
	ble.s	rd_ascii_to_hex_ok	; Ja -> verzweige
	sub.b	#32,d0			; Ansonsten ASCII-Wert "a" abziehen für Hex-Ziffern a...f
rd_ascii_to_hex_ok
	lsl.l	d2,d0			; *Hex-Stellenwert (16^0,16^1,16^2,...)
	addq.w	#4,d2			; Shiftwert um 16^n erhöhen
	add.l	d0,d1			; Stelle zum Ergebnis addieren
	dbf	d7,rd_ascii_to_hex_loop
	rts


; ** Demo-Verzeichnisname ermitteln und zu aktuellem Verzeichnis erklären **
rd_set_new_current_dir
	moveq	#"/",d2
	moveq	#":",d3
	moveq	#adl_demofile_path_length-1,d7
	move.l	rd_demofile_path(a3),a0 ; Zeiger auf Eintrag in Playback-Queue
	add.l	d7,a0			; Ende des Quellpuffers
	lea	rd_demo_dir_path(pc),a1 ; Zeiger auf Puffer für Demo-Directory-Pfad
	add.l	d7,a1			; Ende des Zielpuffers
rd_get_dir_loop
	move.b	-(a0),d0		; Quell-Pfadename rückwärts byteweise auslesen
	subq.w	#1,d7			; Zähler verringern
	clr.b	-(a1)			; Quell-Pfadename rückwärts byteweise löschen
	cmp.b	d2,d0			; Ende des Verzeichnisnamens gefunden ?
	beq.s	rd_dir_name_found2	; Ja -> verzweige
	cmp.b	d3,d0			; Ende des Gerätenamens gefunden ?
	beq.s	rd_dir_name_found1	; Ja -> verzweige
	bra.s	rd_get_dir_loop
	CNOP 0,4
rd_dir_name_found1
	move.b	d0,(a1)			; ":" eintragen
rd_dir_name_found2
	subq.w	#1,d7			; wegen dbf
rd_copy_character_loop
	move.b	-(a0),-(a1)
	dbf	d7,rd_copy_character_loop
	lea	rd_demo_dir_path(pc),a0 
	move.l	a0,d1			; Zeiger auf Puffer für Demo-Directory-Pfad
	move.l	#ACCESS_READ,d2
	CALLDOS Lock
	move.l	d0,rd_demofile_dir_lock(a3)
	bne.s	rd_demofile_dir_lock_ok
	lea	rd_error_text15(pc),a0
	moveq	#rd_error_text15_end-rd_error_text15,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_demofile_dir_lock_ok
	move.l	d0,d1			; Lock für Programm-Directory
	move.l	d0,d3			; Lock für Current-Directory
	CALLLIBS SetProgramDir		; PRGDIR: = Demo-Directory
	move.l	d3,d1			; Current-Directory-Lock
	CALLLIBS CurrentDir		; Current Directory = Demo-Directory
	move.l	d0,rd_current_dir_lock(a3) ; Lock von altem Current Directory
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_open_screen
	CALLINT ViewAddress
	move.l	d0,rd_old_view(a3) 
	move.l	d0,a0			; View
	lea	rd_load_color_table+lct_color00(pc),a1 ; 32-Bit RGB-Wert ermitteln
	move.l	v_Viewport(a0),a0
	moveq	#0,d0			; Erstes Register (COLOR00)
	move.l	vp_ColorMap(a0),a0
	moveq	#1,d1			; Nur Hintergrundfarbe
	CALLGRAF GetRGB32
	sub.l	a0,a0			; Keine NewScreen-Struktur
	lea	rd_screen_tag_list(pc),a1
	CALLINT OpenScreenTagList
	lea	rd_window_tag_list+ti_data(pc),a0
	move.l	d0,(a0)			; Zeiger auf Screen in WindowTagList eintragen
	bne.s	rd_open_screen_ok
	lea	rd_error_text16(pc),a0
	moveq	#rd_error_text16_end-rd_error_text16,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_screen_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_downgrade_sprite_resolution
	move.l	rd_window_tag_list+ti_data(pc),a2 ;Zeiger auf Screen
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPRITERESN_GET,ti_tag(a1)
	moveq	#0,d0
	move.l	d0,ti_data(a1)
	CALLGRAF VideoControl		; Sprite-Auflösung ermitteln
	lea	rd_video_control_tag_list(pc),a0
	move.l	ti_data(a0),rd_old_sprite_resolution(a3)
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPRITERESN_SET,ti_tag(a1)
	move.l	#SPRITERESN_140NS,ti_data(a1)
	CALLLIBS VideoControl		; Sprite-Auflösung zurücksetzen
	move.l	a2,a0			; Zeiger auf Screen
	CALLINT MakeScreen
	CALLLIBQ RethinkDisplay


	CNOP 0,4
rd_open_window
	sub.l	a0,a0			; Keine NewWindow-Struktur
	lea	rd_window_tag_list(pc),a1
	CALLINT OpenWindowTagList
	move.l	d0,rd_window(a3)
	bne.s	rd_open_window_ok
	lea	rd_error_text17(pc),a0
	moveq	#rd_error_text17_end-rd_error_text17,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_window_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_clear_mousepointer
	move.l	rd_window(a3),a0
	move.l	rd_sprite_data(a3),a1	; Leersprite
	moveq	#rd_sprite_y_size,d0
	moveq	#rd_sprite_x_size,d1
	moveq	#0,d2			; x-Offset
	moveq	#0,d3			; y-Offset
	CALLLIBQ SetPointer


	CNOP 0,4
rd_fade_out_screen
	tst.w	rd_arg_nofader_enabled(a3)
	bne.s	rd_get_sprites_colourbanks
	rts
	CNOP 0,4
rd_get_sprites_colourbanks
	move.l	rd_window_tag_list+ti_data(pc),a2 ; Zeiger auf Screen
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPODD_BASE_GET,ti_tag(a1)
	moveq	#0,d0
	move.l	d0,ti_data(a1)
	CALLGRAF VideoControl		; Odd-Sprite Colourbanks ermitteln
	lea	rd_video_control_tag_list(pc),a0
	move.l	ti_data(a0),sf_odd_sprite_color_base(a3) ; Color-Base der ungeraden Sprites
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPEVEN_BASE_GET,ti_tag(a1)
	moveq	#0,d0
	move.l	d0,ti_data(a1)
	CALLLIBS VideoControl		; Even-Sprite Colourbanks ermitteln
	lea	rd_video_control_tag_list(pc),a0
	move.l	ti_data(a0),sf_even_sprite_color_base(a3) ; Color-Base der geraden Sprites
; ** Tiefe des Workbench-Screens und Anzahl der Farben ermitteln **
	move.l	a2,a0			; Zeiger auf Screen
	CALLINT GetScreenDrawInfo
	move.l	d0,a0			; Zeiger auf Draw-Info-Struktur
	moveq	#1,d0			; Tiefe = 1 Bitplane
	move.w	dri_depth(a0),d7	; Tiefe des Screens
	subq.w	#1,d7			; wegen dbf
sf_screen_depth_loop
	add.w	d0,d0			; 2^n = Anzahl der Farben des Screen
	dbf	d7,sf_screen_depth_loop
	move.l	d0,sf_screen_colors_number(a3)
	move.l	d0,d7		
; ** Screenfarbwerte aus ColorMap-Struktur auslesen **
	move.l	sc_ViewPort+vp_ColorMap(a2),a4 ; Zeiger auf Farbtabelle
	move.l	a4,a0			; Zeiger auf Farbtabelle
	moveq	#0,d0			; Erstes Register COLOR00
	move.l	sf_color_table(a3),a1	; 32-Bit RGB-Werte
	move.l	d7,d1			; Anzahl der Screenfarben
	CALLGRAF GetRGB32
; ** Farbwerte der ungeraden Sprites aus ColorMap-Struktur auslesen **
	move.l	sf_odd_sprite_color_base(a3),d0 ; Erstes Register
	move.l	d0,d1		
	MULUF.L 3,d1,d2
	move.l	sf_color_table(a3),a1	; 32-Bit RGB-Werte
	move.l	a4,a0			; Zeiger auf Farbtabelle
	lea	(a1,d1.w*4),a1		; Offset in Farbtabelle
	moveq	#rd_sprites_colors_number,d1 ; Anzahl der Spritefarben
	CALLLIBS GetRGB32
; ** Farbwerte der geraden Sprites aus ColorMap-Struktur auslesen **
	move.l	sf_even_sprite_color_base(a3),d0 ; Erstes Register
	cmp.l	sf_odd_sprite_color_base(a3),d0 ; Color-Base der ungeraden und gerade Sprites gleich ?
	beq.s	sf_copy_color_values	; Ja -> verzweige
	move.l	d0,d1		
	MULUF.L 3,d1,d2
	move.l	sf_color_table(a3),a1	; 32-Bit RGB-Werte
	move.l	a4,a0			; Zeiger auf Farbtabelle
	lea	(a1,d1.w*4),a1		; Offset in Farbtabelle
	moveq	#rd_sprites_colors_number,d1 ; Anzahl der Spritefarben
	CALLLIBS GetRGB32
; ** 32-Bit RGB-Werte kopieren **
sf_copy_color_values
	move.l	sf_color_table(a3),a0	; Quelle 32-Bit RGB-Werte
	move.l	sf_color_cache(a3),a1	; Ziel 32-Bit RGB-Werte
	MOVEF.W sf_colors_number_max-1,d7 ; Anzahl der Farbwerte
sf_copy_color_values_loop
	move.l	(a0)+,(a1)+		; 32-Bit-Rotwert
	move.l	(a0)+,(a1)+		; 32-Bit-Grünwert
	move.l	(a0)+,(a1)+		; 32-Bit-Blauwert
	dbf	d7,sf_copy_color_values_loop
; ** Screen ausblenden **
sfo_fade_out_loop
	CALLGRAF WaitTOF
	bsr.s	screenfader_out
	bsr	sf_set_new_screen_colors
	tst.w	sfo_active(a3)
	beq.s	sfo_fade_out_loop
	rts

	CNOP 0,4
screenfader_out
	move.w	#sf_colors_number_max*3,d6 ; Zähler
	move.l	sf_color_cache(a3),a0	; Istwerte
	sub.l	a1,a1			; RGB-Sollwert
	move.w	#sfo_fader_speed,a4 	; Additions-/Subtraktionswert RGB-Werte
	MOVEF.W sf_colors_number_max-1,d7 ; Anzahl der Farbwerte
sfo_fader_loop
	moveq	#0,d0
	move.b	(a0),d0			; 8-Bit Rot-Istwert
	move.l	a1,d3			; 8-Bit Rot-Sollwert
	moveq	#0,d1
	swap	d3			; $00Rr
	move.b	4(a0),d1		; 8-Bit Grün-Istwert
	moveq	#0,d2
	move.b	8(a0),d2		; 8-Bit Blau-Istwert
	move.w	a1,d4			; 8-Bit Grün-Sollwert
	moveq	#0,d5
	move.b	d4,d5			; 8-Bit Blau-Sollwert
	lsr.w	#8,d4			; $00Gg
	
; ** Rotwert **
	cmp.w	d3,d0
	bgt.s	sfo_decrease_red
	blt.s	sfo_increase_red
sfo_matched_red
	subq.w	#1,d6			; Rot-Nibble-Sollwert erreicht

; ** Grünwert **
sfo_check_green_nibble
	cmp.w	d4,d1
	bgt.s	sfo_decrease_green
	blt.s	sfo_increase_green
sfo_matched_green
	subq.w	#1,d6			; Grün-Nibble-Sollwert erreicht

; ** Blauwert **
sfo_check_blue_nibble
	cmp.w	d5,d2
	bgt.s	sfo_decrease_blue
	blt.s	sfo_increase_blue
sfo_matched_blue
	subq.w	#1,d6			; Blau-Nibble-Sollwert erreicht

sfo_set_rgb32_nibbles
	move.b	d0,(a0)+		; 4x8-Bit Rotwert in Cache schreiben
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d1,(a0)+		; 4x8-Bit Grünwert in Cache schreiben
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d2,(a0)+		; 4x8-Bit Blauwert in Cache schreiben
	move.b	d2,(a0)+
	move.b	d2,(a0)+
	move.b	d2,(a0)+
	dbf	d7,sfo_fader_loop
	tst.w	d6			; Ausblenden beendet ?
	bne.s	sfo_not_finished	; Nein -> verzweige
	moveq	#FALSE,d0
	move.w	d0,sfo_active(a3)	; Fading-Out aus
sfo_not_finished
	CALLEXECQ CacheClearU
	CNOP 0,4
sfo_decrease_red
	sub.w	a4,d0
	cmp.w	d3,d0
	bgt.s	sfo_check_green_nibble
	move.w	d3,d0
	bra.s	sfo_matched_red
	CNOP 0,4
sfo_increase_red
	add.w	a4,d0
	cmp.w	d3,d0
	blt.s	sfo_check_green_nibble
	move.w	d3,d0
	bra.s	sfo_matched_red
	CNOP 0,4
sfo_decrease_green
	sub.w	a4,d1
	cmp.w	d4,d1
	bgt.s	sfo_check_blue_nibble
	move.w	d4,d1
	bra.s	sfo_matched_green
	CNOP 0,4
sfo_increase_green
	add.w	a4,d1
	cmp.w	d4,d1
	bgt.s	sfo_check_blue_nibble
	move.w	d4,d1
	bra.s	sfo_matched_green
	CNOP 0,4
sfo_decrease_blue
	sub.w	a4,d2
	cmp.w	d5,d2
	bgt.s	sfo_set_rgb32_nibbles
	move.w	d5,d2
	bra.s	sfo_matched_blue
	CNOP 0,4
sfo_increase_blue
	add.w	a4,d2
	cmp.w	d5,d2
	bgt.s	sfo_set_rgb32_nibbles
	move.w	d5,d2
	bra.s	sfo_matched_blue


	CNOP 0,4
sf_set_new_screen_colors
	moveq	#0,d6			; Erste Farbregisternummer COLOR00
	move.l	sf_color_cache(a3),a4	; Puffer für Farbwerte
	move.l	sf_screen_colors_number(a3),d7	; Anzahl der Screenfarbwerte
	subq.w	#1,d7			; wegen dbf
	bsr.s	sf_set_colors_loop
	cmp.l	#sf_colors_number_max,sf_screen_colors_number(a3)
	bne.s	sf_set_odd_sprites_colors
	rts
	CNOP 0,4
sf_set_odd_sprites_colors
	move.l	sf_odd_sprite_color_base(a3),d6 ; Farbregisternummer
	move.l	d6,d0		
	MULUF.L 3*LONGWORD_SIZE,d0,d1
	move.l	sf_color_cache(a3),a4	; Puffer für Farbwerte
	add.l	d0,a4			; Offset in Farbtabelle
	moveq	#rd_sprites_colors_number-1,d7 ; Anzahl der Farbwerte
	bsr.s	sf_set_colors_loop

	move.l	sf_even_sprite_color_base(a3),d6
	cmp.l	sf_odd_sprite_color_base(a3),d6
	bne.s	sf_set_even_sprites_colors
	rts
	CNOP 0,4
sf_set_even_sprites_colors
	move.l	d6,d0
	MULUF.L 3*LONGWORD_SIZE,d0,d1
	move.l	sf_color_cache(a3),a4	; Puffer für Farbwerte
	add.l	d0,a4			; Offset in Farbtabelle
	moveq	#rd_sprites_colors_number-1,d7 ; Anzahl der Farbwerte
	bsr.s	sf_set_colors_loop
 	rts


	CNOP 0,4
sf_set_colors_loop
	move.l	(a4)+,d1		; 32-Bit-Rotwert
	move.l	d6,d0			; Farbnummer
	move.l	(a4)+,d2		; 32-Bit-Grünwert
	lea	sc_ViewPort(a2),a0 	; Zeiger auf Viewport
	move.l	(a4)+,d3		; 32-Bit-Blauwert
	CALLGRAF SetRGB32
	addq.w	#1,d6			; Farbnummer erhöhen
	dbf	d7,sf_set_colors_loop
	rts


	CNOP 0,4
rd_control_timer
	tst.w	rd_play_duration(a3)
	beq.s	rd_set_timer_play_duration
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
rd_set_timer_play_duration
	bsr.s	rd_set_timer
	tst.l	d0
	beq.s	rd_control_timer_ok
	rts
	CNOP 0,4
rd_control_timer_ok
	bra	rd_write_timer


	CNOP 0,4
rd_set_timer
	lea	rd_serial_io(pc),a1
	move.l	a1,a2
	move.w	#SDCMD_SETPARAMS,io_Command(a1)
	move.l	#adl_baud,io_Baud(a1)
	move.b	#8,io_Writelen(a1)
	move.b	#1,io_Stopbits(a1)
	move.b	#SERF_XDISABLED,io_Serflags(a1)
	CALLEXEC DoIO
	move.b	io_Error(a2),d0
	beq.s	rs_set_timer_ok
	cmp.b	#SerErr_DevBusy,d0	; Serial-Device bereits in Benutzung ?
	bne.s	ds_check_baud_mismatch	; Ja -> verzweige
	lea	rd_error_text18(pc),a0
	moveq	#rd_error_text18_end-rd_error_text18,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_check_baud_mismatch
	cmp.b	#SerErr_BaudMismatch,d0	; Baudrate nicht von der Hardware unterstützt ?
	bne.s	ds_check_invalid_parameters
	lea	rd_error_text19(pc),a0
	moveq	#rd_error_text19_end-rd_error_text19,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_check_invalid_parameters
	cmp.b	#SerErr_InvParam,d0	; Falsche Parameter ?
	bne.s	ds_check_line_error
	lea	rd_error_text20(pc),a0
	moveq	#rd_error_text20_end-rd_error_text20,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_check_line_error
	cmp.b	#SerErr_LineErr,d0 	; Überlauf der Daten ?
	bne.s	ds_check_no_data_set_ready
	lea	rd_error_text21(pc),a0
	moveq	#rd_error_text21_end-rd_error_text21,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
ds_check_no_data_set_ready
	cmp.b	#SerErr_NoDSR,d0	; Data-Set nicht bereit ?
	bne.s	rs_set_timer_ok
	lea	rd_error_text22(pc),a0
	moveq	#rd_error_text22_end-rd_error_text22,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rs_set_timer_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_write_timer
	lea	rd_serial_io(pc),a1
	move.w	#CMD_WRITE,io_Command(a1)
	moveq	#rd_output_string_end-rd_output_string,d0
	move.l	d0,io_Length(a1)
	lea	rd_output_string(pc),a0
	move.l	a0,io_Data(a1)
	CALLEXEC DoIO
	tst.l	d0
	beq.s	rd_write_timer_ok
	lea	rd_error_text23(pc),a0
	moveq	#rd_error_text23_end-rd_error_text23,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_write_timer_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_downgrade_display
	sub.l	a1,a1			; Hardware-Register auf PAL-Werte zurücksetzen
	CALLGRAF LoadView
	CALLLIBS WaitTOF		; Warten bis Änderung sichtbar ist
	CALLLIBS WaitTOF		; Warten bis Interlace-Screens mit 2 Copperlisten auch voll geändert sind
	tst.l	gb_ActiView(a6)		; Erschien zwischenzeitlich ein anderer View ?
	bne.s	rd_downgrade_display	; Dann neuer Versuch
	move.l	gb_Copinit(a6),rd_old_cop1lc(a3)
	move.l	gb_LOFlist(a6),rd_old_cop2lc(a3) ; (LOFlist, da OS das LOF-Bit bei non-Interlaced immer setzt!) retten
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_OCS_VANILLA,pqe_startmode(a0)
	bne.s	rd_downgrade_display_ok
	moveq	#0,d0
	move.l	d0,_CUSTOM+BPL1MOD	; OCS-komptible Moduli BPL1MOD & BPL2MOD
rd_downgrade_display_ok
	rts


	CNOP 0,4
rd_save_custom_trap_vectors
	RP_POINTER_CUSTOM_TRAP_VECTORS
	move.l	d0,rd_custom_trap_vectors(a3)
	rts


	CNOP 0,4
rd_downgrade_cpu
	lea	rp_read_vbr(pc),a5
	CALLEXEC Supervisor
	move.l	d0,rd_old_vbr(a3)
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_TURBO,pqe_startmode(a0)
	bne.s	rd_check_vbr1
	rts
	CNOP 0,4
rd_check_vbr1
	tst.l	rd_old_vbr(a3)
	beq.s	rd_check_060_cpu1
	moveq	#0,d0
	lea	rd_write_vbr(pc),a5
	CALLLIBS Supervisor		; VBR auf $000000 zurücksetzen
rd_check_060_cpu1
	tst.b	AttnFlags+1(a6)
	bpl.s	rd_disable_caches_mmu
; ** 68060 **
	moveq	#0,d1			; Alle Bits in CACR löschen
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_AGA_VANILLA,pqe_startmode(a0)
	bne.s	rd_disable_060_caches
	or.w	#CACR060F_FIC+CACR060F_EIC,d1 ; 1/2 Instruction-Cache an
rd_disable_060_caches
	lea	rd_060_caches_off(pc),a5
	CALLLIBS Supervisor
	move.l	d0,rd_old_cacr(a3)
	lea     rd_old_mmu_registers(pc),a1
	lea	rd_040_060_mmu_off(pc),a5
	CALLLIBS Supervisor
	moveq	#0,d1			; Alle Bits in PCR-Register löschen
	lea	rd_060_superscalar_off(pc),a5
	CALLLIBS Supervisor
	move.l	d0,rd_old_060_pcr(a3)
	rts
; ** 68020-68040 **
	CNOP 0,4
rd_disable_caches_mmu
	moveq	#0,d0			; Alle Bits löschen
	move.l	#CACRF_EnableI|CACRF_IBE|CACRF_EnableD|CACRF_DBE|CACRF_WriteAllocate|CACRF_EnableE|CACRF_CopyBack,d1 ; Caches ausschalten
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_AGA_VANILLA,pqe_startmode(a0)
	bne.s	rd_disable_caches
	and.b	#~(CACRF_EnableI),d1	; Instruction-Cache nicht ausschalten
rd_disable_caches
	CALLLIBS CacheControl		; CPU neu konfigurieren und Caches flushen
	move.l	d0,rd_old_cacr(a3)

	btst	#AFB_68040,AttnFlags+1(a6)
	beq.s   rd_check_030_cpu1
	lea	rd_040_060_mmu_off(pc),a5
	CALLLIBQ Supervisor
	CNOP 0,4
rd_check_030_cpu1
	btst	#AFB_68030,AttnFlags+1(a6)
	bne.s	rd_disable_030_mmu
	rts
	CNOP 0,4
rd_disable_030_mmu
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_030_mmu_off(pc),a5
	CALLLIBQ Supervisor


; ** VBR beschreiben **
; Input
; d0 ... neuer Inhalt von VBR
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_write_vbr
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	movec.l d0,VBR
	nop
	rte


; ** 68060-Caches aus **
; Input
; d0 ... alter Inhalt von CACR
; d1 ... neuer Inhalt von CACR
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_060_caches_off
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	movec.l CACR,d0
	nop
	CPUSHA	BC			; Instruction/Data/Branch-Caches flushen
	nop
	movec.l d1,CACR
	nop
	rte


; ** 68040/060-MMU deaktivieren **
; Input
; a1 ... Zeiger auf Speicherbereich für alte Werte
; a3 ... Zeiger auf Variablen-Base
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_040_060_mmu_off
	move.l	#$0000c040,d1		; DTT0 Cache inhibited, precise für Speicherbereich $00000000-$00ffffff (Zorro II)
	move.l	#$00ffc000,d2		; DTT1/ITT1 Cachable, writethrough für Speicherbereich $00000000-$ffffffff (Zorro II/III)
	move.l	d2,d3			; ITT0=DTT1 Cachable für Speicherbereich $00000000-$ffffffff (Zorro II/III)
	moveq	#0,d4			; TC MMU aus
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_OCS_VANILLA,pqe_startmode(a0)
	bne.s	rd_set_translation_registers
	move.l	d1,d3			; ITT0=DTT0 Cache inhibited, precise für Speicherbereich $00000000-$00ffffff (Zorro II)
rd_set_translation_registers
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	movec.l DTT0,d0
	nop
	move.l	d0,omr_dtt0(a1)
	nop
	movec.l d1,DTT0
	nop
	movec.l DTT1,d0
	nop
	move.l	d0,omr_dtt1(a1)
	nop
	movec.l d2,DTT1
	nop
	movec.l ITT0,d0
	nop
	move.l	d0,omr_itt0(a1)
	nop
	movec.l d3,ITT0
	nop
	movec.l ITT1,d0
	nop
	move.l	d0,omr_itt1(a1)
	nop
	movec.l d2,ITT1
	nop
	PFLUSHA
	nop
	movec.l TC,d0
	nop
	move.l	d0,omr_tc(a1)
	nop
	movec.l d4,TC
	nop
	rte


; ** 68030-MMU deaktivieren **
	MC68030
; Input
; a1 ... Zeiger auf Speicherbereich für alte Werte
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_030_mmu_off
	lea	rd_clear_030_mmu_register(a3),a0
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	PMOVE	TT0,omr_tt0(a1)
	nop
	PMOVE	(a0),TT0
	nop
	PMOVE	TT1,omr_tt1(a1)
	nop
	PMOVE	(a0),TT1
	nop
	PFLUSHA
	nop
	PMOVE	TC,omr_tc(a1)
	nop
	PMOVE	(a0),TC
	nop
	rte


; ** 68060 parallele Verarbeitung aus **
	MC68040
; Input
; d1 ... neuer Inhalt von PCR
; Result
; d0 ... Alter Inhalt von PCR
	CNOP 0,4
rd_060_superscalar_off
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
	nop
	DC.L	$4e7a0808		; movec.l PCR,d0: Alter inhalt von PCR
	nop
	DC.L	$4e7b1808		; movec.l d1,PCR: Parallele Verarbeitung aus
	nop
	rte


; ** 68060-Caches flushen **
; 	CNOP 0,4
; flush_060_caches
;	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
; 	nop
; 	CPUSHA	BC			; Instruction/Data/Branch-Caches flushen
; 	nop
; 	rte


	CNOP 0,4
rd_save_chips_registers
	CALLEXEC Disable
	move.l	#_CUSTOM,a6
	move.w	DMACONR(a6),rd_old_dmacon(a3)
	move.w	INTENAR(a6),rd_old_intena(a3)
	move.w	ADKCONR(a6),rd_old_adkcon(a3)

	move.l	#_CIAB,a5
	lea	_CIAA-_CIAB(a5),a4	; CIA-A-Base
	move.b	CIAPRA(a4),rd_old_ciaa_pra(a3)
	move.b	CIACRA(a4),d0
	move.b	d0,d1		
	move.b	d0,rd_old_ciaa_cra(a3)
	and.b	#~(CIACRAF_START),d0	; Timer stoppen
	or.b	#CIACRAF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRA(a4)
	nop
	move.b	CIATALO(a4),rd_old_ciaa_talo(a3)
	move.b	CIATAHI(a4),rd_old_ciaa_tahi(a3)
	btst	#CIACRAB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciaa_cra1	; Nein -> verzweige
	or.b	#CIACRAF_START,d1	; Timer wieder starten
rd_set_ciaa_cra1
	move.b	d1,CIACRA(a4)
	move.b	CIACRB(a4),d0
	move.b	d0,d1		
	move.b	d0,rd_old_ciaa_crb(a3)
	and.b	#~(CIACRBF_ALARM-CIACRBF_START),d0 ; Timer stoppen
	or.b	#CIACRBF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRB(a4)
	nop
	move.b	CIATBLO(a4),rd_old_ciaa_tblo(a3)
	move.b	CIATBHI(a4),rd_old_ciaa_tbhi(a3)
	btst	#CIACRBB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciaa_crb1	; Nein -> verzweige
	or.b	#CIACRBF_START,d1	; Timer wieder starten
rd_set_ciaa_crb1
	move.b	d1,CIACRB(a4)

	move.b	CIAPRB(a5),rd_old_ciab_prb(a3)
	move.b	CIACRA(a5),d0
	move.b	d0,d1		
	move.b	d0,rd_old_ciaa_cra(a3)
	and.b	#~(CIACRAF_START),d0	; Timer stoppen
	or.b	#CIACRAF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRA(a5)
	nop
	move.b	CIATALO(a5),rd_old_ciab_talo(a3)
	move.b	CIATAHI(a5),rd_old_ciab_tahi(a3)
	btst	#CIACRAB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciab_cra1	; Nein -> verzweige
	or.b	#CIACRAF_START,d1	; Timer wieder starten
rd_set_ciab_cra1
	move.b	d1,CIACRA(a5)
	move.b	CIACRB(a5),d0
	move.b	d0,d1		
	move.b	d0,rd_old_ciab_crb(a3)
	and.b	#~(CIACRBF_ALARM-CIACRBF_START),d0 ;Timer stoppen
	or.b	#CIACRBF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRB(a5)
	nop
	move.b	CIATBLO(a5),rd_old_ciab_tblo(a3)
	move.b	CIATBHI(a5),rd_old_ciab_tbhi(a3)
	btst	#CIACRBB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciab_crb1	; Nein -> verzweige
	or.b	#CIACRBF_START,d1	; Timer wieder starten
rd_set_ciab_crb1
	move.b	d1,CIACRB(a5)
	CALLEXECQ Enable


	CNOP 0,4
rd_run_demo
	IFEQ adl_level_7_handler_enabled
		RP_SET_LEVEL_7_RESET_STATE ; Reset-Level-7-Interrupt aktivieren
	ENDC
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_OCS_VANILLA,pqe_startmode(a0)
	beq.s	check_whdload_slave
	CALLEXEC CacheClearU
check_whdload_slave
	tst.w	whdl_slave_enabled(a3)
	beq.s	rd_execute_whdload_slave
	moveq	#1,d0			; Command-Line-Länge = 1 Zeichen (Line-Feed)
	lea	rd_shell_cmd_line(pc),a0
	move.l	a3,-(a7)
	move.l	rd_demofile_seglist(a3),a3
	add.l	a3,a3			; BCPL-Zeiger
	add.l	a3,a3
	jsr	FirstCode(a3)		; Demo ausführen
	move.l	(a7)+,a3
	move.l	#_CUSTOM+DMACONR,a0
	tst.w	(a0)			; Bei A1000/A2000-A Custom-Chip-Adresse lesen wegen Blitter-Bug
rd_cleanup_demo_loop
	btst	#DMAB_BLTDONE-8,(a0)	; Sicherheitshalber auf eventuell noch nicht beendete Blits warten
	bne.s	rd_cleanup_demo_loop
	tst.w	rd_arg_softreset_enabled(a3)
	bne.s	rd_check_startmode
	CALLEXECQ ColdReboot
	CNOP 0,4
rd_check_startmode
	move.l	rd_demofile_path(a3),a0
	cmp.b	#STARTMODE_TURBO,pqe_startmode(a0)
	beq.s	rd_clear_caches
	rts
	CNOP 0,4
rd_clear_caches
	CALLEXECQ CacheClearU
	CNOP 0,4
rd_execute_whdload_slave
	lea	whdl_slave_cmd_line(pc),a0
	move.l	a0,d1			; Zeiger auf Kommandozeile
	moveq	#0,d2			; Kein Input
	moveq	#0,d3			; Kein Output
	CALLDOS Execute
	tst.l	d0
	bne.s	rd_execute_whdload_slave_ok
	lea	rd_error_text24(pc),a0
	moveq	#rd_error_text24_end-rd_error_text24,d0
	bsr	adl_print_text
	moveq	#RETURN_ERROR,d0
	rts
	CNOP 0,4
rd_execute_whdload_slave_ok
	CALLLIBQ IoErr			; Fehler bei Ausführung der Whdload-Slave-Datei berücksichtigen


	CNOP 0,4
rd_clear_chips_registers
	CALLEXEC Disable
	move.l	#_CUSTOM,a6
	move.w	#$7fff,d0
	move.w	d0,DMACON(a6)		; DMA aus

	move.w	d0,INTENA(a6)		; Interrupts aus
	move.w	d0,INTREQ(a6)		; Interrupts löschen
	move.w	d0,ADKCON(a6)

	moveq	#0,d0
	move.w	d0,COPCON(a6)		; Copper kann nicht auf Blitterregister zugreifen
	move.w	d0,AUD0VOL(a6)		; Lautstärke aus
	move.w	d0,AUD1VOL(a6)
	move.w	d0,AUD2VOL(a6)
	move.w	d0,AUD3VOL(a6)

	move.l	#_CIAB,a5
	lea	_CIAA-_CIAB(a5),a4 	; CIA-A-Base
	moveq	#$7f,d0
	move.b	d0,CIAICR(a4)		; Interrupts aus
	move.b	d0,CIAICR(a5)
	move.b	CIAICR(a4),d0		; Interrupts löschen
	move.b	CIAICR(a5),d0
	rts


	CNOP 0,4
rd_restore_chips_registers
	move.b	rd_old_ciaa_pra(a3),CIAPRA(a4)

	move.b	rd_old_ciaa_talo(a3),CIATALO(a4)
	nop
	move.b	rd_old_ciaa_tahi(a3),CIATAHI(a4)

	move.b	rd_old_ciaa_tblo(a3),CIATBLO(a4)
	nop
	move.b	rd_old_ciaa_tbhi(a3),CIATBHI(a4)

	move.b	rd_old_ciaa_icr(a3),d0
	tas	d0			; Bit 7 ggf. setzen
	move.b	d0,CIAICR(a4)

	move.b	rd_old_ciaa_cra(a3),d0
	btst	#CIACRAB_RUNMODE,d0	; Continuous-Modus ?
	bne.s	rd_set_ciaa_cra2	; Nein -> verzweige
	or.b	#CIACRAF_START,d0	; Timer wieder starten
rd_set_ciaa_cra2
	move.b	d0,CIACRA(a4)

	move.b	rd_old_ciaa_crb(a3),d0
	btst	#CIACRBB_RUNMODE,d0 	; Continuous-Modus ?
	bne.s	rd_set_ciaa_crb2	; Nein -> verzweige
	or.b	#CIACRBF_START,d0	; Timer wieder starten
rd_set_ciaa_crb2
	move.b	d0,CIACRB(a4)

	move.b	rd_old_ciab_prb(a3),CIAPRB(a5)

	move.b	rd_old_ciab_talo(a3),CIATALO(a5)
	nop
	move.b	rd_old_ciab_tahi(a3),CIATAHI(a5)

	move.b	rd_old_ciab_tblo(a3),CIATBLO(a5)
	nop
	move.b	rd_old_ciab_tbhi(a3),CIATBHI(a5)

	move.b	rd_old_ciab_icr(a3),d0
	tas	d0			; Bit 7 ggf. setzen
	move.b	d0,CIAICR(a5)

	move.b	rd_old_ciab_cra(a3),d0
	btst	#CIACRAB_RUNMODE,d0 	; Continuous-Modus ?
	bne.s	rd_set_ciab_cra2 	; Nein -> verzweige
	or.b	#CIACRAF_START,d0	; Timer wieder starten
rd_set_ciab_cra2
	move.b	d0,CIACRA(a5)

	move.b	rd_old_ciab_crb(a3),d0
	btst	#CIACRBB_RUNMODE,d0	; Continuous-Modus ?
	bne.s	rd_set_ciab_crb2	; Nein -> verzweige
	or.b	#CIACRBF_START,d0	; Timer wieder starten
rd_set_ciab_crb2
	move.b	d0,CIACRB(a5)

	move.l	rd_old_cop2lc(a3),COP2LCH(a6)
	move.l	rd_old_cop1lc(a3),COP1LCH(a6)
	moveq	#0,d0
	move.w	d0,COPJMP1(a6)

	move.w	rd_old_dmacon(a3),d0
	or.w	#DMAF_SETCLR,d0
	move.w	d0,DMACON(a6)
	move.w	rd_old_intena(a3),d0
	or.w	#INTF_SETCLR,d0
	move.w	d0,INTENA(a6)
	move.w	rd_old_adkcon(a3),d0
	or.w	#ADKF_SETCLR,d0
	move.w	d0,ADKCON(a6)
	CALLEXECQ Enable


	CNOP 0,4
rd_upgrade_cpu
	move.l	rd_demofile_path(a3),a0
	cmp.b   #STARTMODE_TURBO,pqe_startmode(a0)
	bne.s	rd_restore_vbr
	rts
	CNOP 0,4
rd_restore_vbr
	move.l	_SysBase(pc),a6
	move.l	rd_old_vbr(a3),d0
	beq.s	rd_check_060_cpu2
	lea	rd_write_vbr(pc),a5
	CALLEXEC Supervisor
rd_check_060_cpu2
	tst.b	AttnFlags+1(a6)
	bpl.s	rd_enable_caches_mmu
; ** 68060 **
	move.l	rd_old_060_pcr(a3),d1
	lea	rd_060_superscalar_on(pc),a5
	CALLLIBS Supervisor
	move.l	rd_old_cacr(a3),d1
	lea	rd_060_caches_on(pc),a5
	CALLLIBS Supervisor
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_040_060_mmu_on(pc),a5
	CALLLIBQ Supervisor
; ** 68030-68040 **
	CNOP 0,4
rd_enable_caches_mmu
	moveq	#FALSE,d0		; Alle Bits setzen
	move.l	rd_old_cacr(a3),d1
	CALLLIBS CacheControl		; CPU neu konfigurieren und Caches flushen
	btst	#AFB_68040,AttnFlags+1(a6)
	beq.s	rd_check_030_cpu2
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_040_060_mmu_on(pc),a5
	CALLLIBQ Supervisor
	CNOP 0,4
rd_check_030_cpu2
	btst	#AFB_68030,AttnFlags+1(a6)
	bne.s	rd_enable_030_mmu
	rts
	CNOP 0,4
rd_enable_030_mmu
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_030_mmu_on(pc),a5
	CALLLIBQ Supervisor


; ** 68060 parallele Verarbeitung an **
; Input
; d1 ... alter Inhalt von PCR
; Result
; d0 ... Kein Rückgabewert
rd_060_superscalar_on
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	DC.L	$4e7b1808		; movec.l d1,PCR: Alter Inhalt von PCR
	nop
	rte


; ** 68040/060-MMU an **
; Input
; a1 ... Zeiger auf Speicherbereich für alte Werte
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rd_040_060_mmu_on
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	move.l	omr_dtt0(a1),d0
	nop
	movec.l d0,DTT0
	nop
	move.l	omr_dtt1(a1),d0
	nop
	movec.l d0,DTT1
	nop
	move.l	omr_itt0(a1),d0
	nop
	movec.l d0,ITT0
	nop
	move.l	omr_itt1(a1),d0
	nop
	movec.l d0,ITT1
	nop
	PFLUSHA
	nop
	move.l	omr_tc(a1),d0
	nop
	movec.l d0,TC
	nop
	rte


; ** 68030-MMU an **
; Input
; a1 ... Zeiger auf Speicherbereich für alte Werte
; Result
; d0 ... Kein Rückgabewert
	MC68030
	CNOP 0,4
rd_030_mmu_on
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	PMOVE	omr_tt0(a1),TT0
	nop
	PMOVE	omr_tt1(a1),TT1
	nop
	PFLUSHA
	nop
	PMOVE	omr_tc(a1),TC
	nop
	rte


; ** 68060-Caches an **
	MC68040
; d1 ... alter Inhalt von CACR
	CNOP 0,4
rd_060_caches_on
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	CPUSHA	BC			; Instruction/Data/Branch-Caches flushen
	nop
	movec.l d1,CACR
	nop
	rte


	CNOP 0,4
rd_restore_custom_trap_vectors
	move.l	rd_old_vbr(a3),d0
	beq.s	rd_restore_trap_vectors_chip
	move.l	d0,a1			; Ziel: Fast-Memory
	add.w	#TRAP_0_VECTOR,a1	; Ab Trap0-Vektor
	bsr.s	rd_copy_custom_trap_vectors
rd_restore_trap_vectors_chip
	move.w	#TRAP_0_VECTOR,a1	; Ab Trap0-Vektor
	bsr.s	rd_copy_custom_trap_vectors
	CALLEXECQ CacheClearU


	CNOP 0,4
rd_copy_custom_trap_vectors
	move.l	rd_custom_trap_vectors(a3),a0
	IFEQ adl_level_7_handler_enabled
		moveq	#8-1,d7		; Anzahl der Trap-Vektoren
	ELSE
		moveq	#7-1,d7		; Anzahl der Trap-Vektoren
	ENDC
rd_copy_custom_trap_vectors_loop
	move.l	(a0)+,(a1)+	 	; Vektor kopieren
	dbf	d7,rd_copy_custom_trap_vectors_loop
	rts


	CNOP 0,4
rd_restore_display
	sub.l	a1,a1			; Kein Display
	CALLGRAF LoadView
	CALLLIBS WaitTOF		; Auf Vertical Blank warten
	CALLLIBS WaitTOF		; Bei Interlace
	move.l	rd_old_view(a3),a1 	; Alten View laden
	CALLLIBS LoadView
	CALLLIBS WaitTOF		; Auf Vertical Blank warten
	CALLLIBQ WaitTOF		; Bei Interlace


	CNOP 0,4
rd_init_serial_output_stop
	moveq	#0,d1			; Timer stoppen
	bra     rd_create_output_string


	CNOP 0,4
rd_fade_in_screen
	tst.w	rd_arg_nofader_enabled(a3)
	bne.s	sfi_get_screen
	rts
	CNOP 0,4
sfi_get_screen
	move.l	rd_window_tag_list+ti_data(pc),a2 ; Zeiger auf Screen
sfi_fade_in_loop
	CALLGRAF WaitTOF
	bsr.s	screenfader_in
	bsr	sf_set_new_screen_colors
	tst.w	sfi_active(a3)
	beq.s	sfi_fade_in_loop
	rts


	CNOP 0,4
screenfader_in
	move.l	sf_color_cache(a3),a0	; Puffer für Farbwerte
	move.w	#sfi_fader_speed,a4	; Additions-/Subtraktionswert für RGB-Werte
	move.l	sf_color_table(a3),a1	; Sollwerte
	move.w	#sf_colors_number_max*3,d6 ; Anzahl der Farbwerte*3 = Zähler
	MOVEF.W sf_colors_number_max-1,d7 ; Anzahl der Farbwerte
sfi_fader_loop
	moveq	#0,d0
	move.b	(a0),d0			; 8-Bit Rot-Istwert
	moveq	#0,d1
	move.b	4(a0),d1		; 8-Bit Grün-Istwert
	moveq	#0,d2
	move.b	8(a0),d2		; 8-Bit Blau-Istwert
	moveq	#0,d3
	move.b	(a1),d3			; 8-Bit Rot-Sollwert
	moveq	#0,d4
	move.b	4(a1),d4		; 8-Bit Grün-Sollwert
	moveq	#0,d5
	move.b	8(a1),d5		; 8-Bit Blau-Sollwert

; ** Rotwert **
	cmp.w	d3,d0
	bgt.s	sfi_decrease_red
	blt.s	sfi_increase_red
sfi_matched_red
	subq.w	#1,d6			; Rot-Nibble-Sollwert erreicht

; ** Grünwert **
sfi_check_green_nibble
	cmp.w	d4,d1
	bgt.s	sfi_decrease_green
	blt.s	sfi_increase_green
sfi_matched_green
	subq.w	#1,d6			; Grün-Nibble-Sollwert erreicht

; ** Blauwert **
sfi_check_blue_nibble
	cmp.w	d5,d2
	blt.s	sfi_decrease_blue
	bgt.s	sfi_increase_blue
sfi_matched_blue
	subq.w	#1,d6			; Blau-Nibble-Sollwert erreicht

sfi_set_rgb_nibbles
	move.b	d0,(a0)+		; 8-Bit Rotwert in Cache schreiben
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d1,(a0)+		; 8-Bit Grünwert in Cache schreiben
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d2,(a0)+		; 8-Bit Blauwert in Cache schreiben
	move.b	d2,(a0)+
	addq.w	#8,a1			; nächstes 32-Bit-Tripple (4*3)
	move.b	d2,(a0)+
	addq.w	#4,a1		
	move.b	d2,(a0)+
	dbf	d7,sfi_fader_loop
	tst.w	d6			; Ausblenden beendet?
	bne.s	sfi_not_finished	; Nein -> verzweige
	moveq	#FALSE,d0
	move.w	d0,sfi_active(a3)	; Fading-In aus
sfi_not_finished
	CALLEXECQ CacheClearU
	CNOP 0,4
sfi_decrease_red
	sub.w	a4,d0
	cmp.w	d3,d0
	bgt.s	sfi_check_green_nibble
	move.w	d3,d0
	bra.s	sfi_matched_red
	CNOP 0,4
sfi_increase_red
	add.w	a4,d0
	cmp.w	d3,d0
	blt.s	sfi_check_green_nibble
	move.w	d3,d0
	bra.s	sfi_matched_red
	CNOP 0,4
sfi_decrease_green
	sub.w	a4,d1
	cmp.w	d4,d1
	bgt.s	sfi_check_blue_nibble
	move.w	d4,d1
	bra.s	sfi_matched_green
	CNOP 0,4
sfi_increase_green
	add.w	a4,d1
	cmp.w	d4,d1
	blt.s	sfi_check_blue_nibble
	move.w	d4,d1
	bra.s	sfi_matched_green
	CNOP 0,4
sfi_decrease_blue
	sub.w	a4,d2
	cmp.w	d5,d2
	bgt.s	sfi_set_rgb_nibbles
	move.w	d5,d2
	bra.s	sfi_matched_blue
	CNOP 0,4
sfi_increase_blue
	add.w	a4,d2
	cmp.w	d5,d2
	bgt.s	sfi_set_rgb_nibbles
	move.w	d5,d2
	bra.s	sfi_matched_blue


	CNOP 0,4
rd_restore_sprite_resolution
	move.l	rd_window_tag_list+ti_data(pc),a0 ; Zeiger auf Screen
	move.l	sc_ViewPort+vp_ColorMap(a0),a0 ; Zeiger auf ColorMap-Struktur
	lea	rd_video_control_tag_list(pc),a1 ; Zeiger auf Tagliste
	move.l	#VTAG_SPRITERESN_SET,ti_tag(a1)
	move.l	#SPRITERESN_140NS,ti_data(a1)
	move.l	rd_old_sprite_resolution(a3),ti_data(a1)
	CALLGRAFQ VideoControl		; Sprite-Auflösung zurücksetzen


	CNOP 0,4
rd_close_window
	move.l	rd_window(a3),a0
	CALLINTQ CloseWindow


	CNOP 0,4
rd_close_screen
	move.l	rd_window_tag_list+ti_data(pc),a0 ;Zeiger auf Screen
	CALLINTQ CloseScreen


	CNOP 0,4
rd_restore_current_dir
	move.l	rd_current_dir_lock(a3),d1
	CALLDOSQ CurrentDir


	CNOP 0,4
rd_unlock_demo_dir
	move.l	rd_demofile_dir_lock(a3),d1
	CALLDOSQ Unlock


	CNOP 0,4
rd_unload_demofile
	move.l	rd_demofile_seglist(a3),d1
	bne.s	rd_unload_demofile_ok
	rts
	CNOP 0,4
rd_unload_demofile_ok
	CALLDOSQ UnLoadSeg


	CNOP 0,4
rd_free_fast_memory
	move.l	rd_demofile_path(a3),a0
	cmp.b   #STARTMODE_TURBO,pqe_startmode(a0)
	bne.s	rd_check_available_fast_memory
	rts
	CNOP 0,4
rd_check_available_fast_memory
	move.l	rd_available_fast_memory(a3),d2
	bne.s	rd_turn_on_fast__memory
	rts
	CNOP 0,4
rd_turn_on_fast__memory
	move.l	_SysBase(pc),a6
	move.l	d2,a2		
turn_on_fast_memory_loop
	move.l	(a2)+,d0		; Größe des Speicherbereichs
	beq.s	free_first_fast_memory_block
	move.l	(a2)+,a1		; Zeiger auf Speicherbereich
	CALLLIBS FreeMem
	bra.s	turn_on_fast_memory_loop
	CNOP 0,4
free_first_fast_memory_block
	move.l	d2,a1			; Zeiger auf ersten größten Block
	move.l	rd_available_fast_memory_size(a3),d0 ; Größe des ersten größten Blocks
	CALLLIBQ FreeMem


	CNOP 0,4
rd_check_demofile_pathtags
	MOVEF.L	playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	ADDF.W	pqe_tag_active,a0	; Tag-Status
	move.w	adl_entries_number(a3),d7 ; Anzahl der Einträge
	subq.w 	#1,d7			; wegen dbf
rd_check_demofile_pathtags_loop
	tst.b	(a0)			; Tag-Status nicht gesetzt ?
	beq.s	rd_not_all_demofile_pathtags_set ;Ja -> verzweige
	add.l	d0,a0              ;nächster Eintrag
	dbf	d7,rd_check_demofile_pathtags_loop

rd_all_demofile_pathtags_set
	tst.w 	rd_arg_endless_enabled(a3) ;Endlosschleife aktiviert ?
	beq.s	rd_remove_tags     ;Ja -> verzweige
rd_no_more_demos_left
	clr.w	rd_arg_remove_enabled(a3) ;TRUE = Reset-Prg entfernen
	lea	rd_message_text2(pc),a0
	moveq	#rd_message_text2_end-rd_message_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_WARN,d0
	rts
  CNOP 0,4
rd_remove_tags
	moveq 	#0,d0
	MOVEF.L	playback_queue_entry_size,d1
	move.l	adl_entries_buffer(a3),a0
	ADDF.W	pqe_tag_active,a0	; Tag-Status
	move.w	adl_entries_number(a3),d7 ; Anzahl der Einträge
	subq.w  #1,d7			; wegen dbf
rd_remove_tags_loop
	move.b	d0,(a0)			;Tag-Status löschen
	add.l	d1,a0			;nächster Eintrag
	dbf	d7,rd_remove_tags_loop
	RP_POINTER_ENTRIES_OFFSET
	move.l	d0,a0
	clr.w	(a0)			; Variable rp_entries_offset zurücksetzen
rd_not_all_demofile_pathtags_set
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_check_arg_LOOP_enabled
	tst.w	rd_arg_loop_enabled(a3)
	beq.s	rd_check_arg_remove_enabled
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_arg_remove_enabled
	tst.w	rd_arg_remove_enabled(a3)
	beq.s	rd_check_loop_mode_ok
	moveq	#RETURN_FAIL,d0
	cmp.l	adl_dos_return_code(a3),d0
	bne.s	rd_check_dos_error_code
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_loop_mode_ok
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
rd_check_dos_error_code
	moveq	#ERROR_FILE_NOT_OBJECT,d0
	cmp.l	adl_dos_return_code(a3),d0
	bge.s	rd_check_break
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_break
	moveq	#0,d0			; No New Signals
	moveq	#0,d1			; Signal Mask
	CALLEXEC SetSignal
	btst	#SIGBREAKB_CTRL_C,d0
	beq.s	rd_check_break_proceed
	lea	rd_message_text4(pc),a0
	moveq	#rd_message_text4_end-rd_message_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_break_proceed
	moveq	#0,d0
	move.l	d0,rd_demofile_seglist(a3)
	move.l	d0,rd_prerunscript_path(a3)
	move.w	#FALSE,whdl_slave_enabled(a3)
	tst.w	rd_arg_nofader_enabled(a3)
	beq.s   rd_check_break_skip
	move.w	d0,sfo_active(a3)	; Fader-Out wieder aktivieren
	move.w	d0,sfi_active(a3)	; Fader-In wieder aktivieren
rd_check_break_skip
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
sf_free_color_cache
	move.l	sf_color_cache(a3),a1
	move.l	#sf_colors_number_max*LONGWORD_SIZE*3,d0
	CALLEXECQ FreeMem


	CNOP 0,4
sf_free_color_table
	move.l	sf_color_table(a3),a1
	move.l	#sf_colors_number_max*LONGWORD_SIZE*3,d0
	CALLEXECQ FreeMem


	CNOP 0,4
rd_free_sprite_data
	move.l	rd_sprite_data(a3),a1
	moveq	#6*WORD_SIZE,d0
	CALLEXECQ FreeMem


	CNOP 0,4
rd_close_serial_device
	lea	rd_serial_io(pc),a1
	CALLEXECQ CloseDevice


	CNOP 0,4
rd_delete_serial_message_port
	move.l	rd_serial_message_port(a3),a0
	CALLEXECQ DeleteMsgPort


	CNOP 0,4
rd_close_icon_library
	move.l	_IconBase(pc),a1
	CALLEXECQ CloseLibrary


	CNOP 0,4
rd_remove_reset_program
	tst.w	rd_arg_remove_enabled(a3)
	beq.s	rd_free_reset_programm_memory
	rts
	CNOP 0,4
rd_free_reset_programm_memory
	RP_REMOVE_RESET_PROGRAM
	move.l	d0,a0
	move.l	(a0)+,a1
	move.l	(a0),d0
	CALLEXEC FreeMem
	lea	rd_message_text3(pc),a0
	moveq	#rd_message_text3_end-rd_message_text3,d0
	bra	adl_print_text


; **** Reset-Program ****
	CNOP 0,4
rp_reset_program
	bra.s	rp_reset_program_skip	; Kennung überspringen
	DC.B "DL"			; Kennung "DL"
rp_reset_program_skip
	movem.l d0-d7/a0-a6,-(a7)
	move.l	#_CUSTOM,a5
	move.l	exec_base.w,a6
	move.w	#%0000111100000000,POTGO(a5) ; Standart-Wert
	moveq	#rp_rasterlines_delay,d7 ; ~320 µs warten
	bsr	rp_wait_rasterline
	btst	#POTINPB_DATLY-8,POTINP(a5) ; Wurde die rechte Maustaste gedrückt ?
	bne.s	rp_reset_program_proceed
	bsr	rp_clear_cool_capture
	bra.s	rp_reset_program_quit
	CNOP 0,4
rp_reset_program_proceed
	bsr	rp_init_serial_output_string
	bsr	rp_stop_timer
	bsr	rp_check_demofile_pathtags
	tst.l	d0			; Sind alle Tags der Dateipfade gesetzt ?
	bne.s	rp_alloc_reset_program_memory
	bsr	rp_clear_cool_capture
	bra.s	rp_reset_program_quit
	CNOP 0,4
rp_alloc_reset_program_memory
	move.l	#(rp_reset_program_end-rp_reset_program),d0
	move.l	rp_reset_program_memory(pc),a1
	moveq	#0,d1
	move.w	rp_entries_number_max(pc),d1
	MULUF.L playback_queue_entry_size,d1,d2 ;Größe des Puffers für Einträge ermitteln
	add.l	d1,d0			; Programmlänge + Puffer für Einträge
	CALLLIBS AllocAbs		; Speicher nochmals reservieren
	tst.l	d0
	bne.s	rp_reset_program_ok
	move.w	#rp_color_error,d3
	bsr	rp_screen_colour_flash
	bsr	rp_clear_cool_capture
	bra.s	rp_reset_program_quit
	CNOP 0,4
rp_reset_program_ok
	move.w	#rp_color_okay,d3
	bsr	rp_screen_colour_flash
	bsr	rp_restore_custom_cool_capture
	bsr	rp_install_custom_exception_vectors
rp_reset_program_quit
	movem.l (a7)+,d0-d7/a0-a6
	rts


; ** n Rasterzeilen warten **
; d7 ... Anzahl der Rasterzeilen
	CNOP 0,4
rp_wait_rasterline
	move.l	#$0001ff00,d2		; Maske für vertikale Position V0-V8 des Rasterstrahls
	subq.w	#1,d7			; wegen dbf
rp_wait_rasterline_loop
	move.w	VPOSR(a5),d0		; VPOSR/VHPOSR getrennt auslesen wegen Übertrag-Bit V8
	swap	d0
	move.w	VHPOSR(a5),d0
	and.l	d2,d0			; Nur vertikale Position
rp_wait_rasterline_subloop
	move.w	VPOSR(a5),d1		; VPOSR/VHPOSR getrennt auslesen wegen Übertrag-Bit V8
	swap	d1
	move.w	VHPOSR(a5),d1
	and.l	d2,d1			; Nur vertikale Position V0-V8
	cmp.l	d1,d0			; Immer noch gleiche Zeile ?
	beq.s	rp_wait_rasterline_subloop ; Ja -> Schleife
	dbf	d7,rp_wait_rasterline_loop
	rts


; ** String für die serielle Ausgabe initialisieren **
	CNOP 0,4
rp_init_serial_output_string
	moveq	#0,d1			; Timer stoppen
	moveq	#5,d7			; Stringlänge = Anzahl der Stellen zum Umwandeln
	lea	rp_output_string_number(pc),a0 ; Stringadresse
	bsr.s	rp_dec_to_ascii
	moveq	#rp_output_string_checksum-rp_output_string,d7 ; Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
	lea	rp_output_string(pc),a0 ; Zeiger auf Ausgabe-String
	bsr.s	rp_get_ascii_checksum
	move.l	d0,d1
	bsr.s	rp_dec_to_hex
	move.l	d0,d1
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	rp_output_string_checksum(pc),a0 ; Zeiger auf String
	bra.s	rp_hex_to_ascii


; ** Dezimalzahl in Hexadezimalzahl umwandeln **
; Input
; d1 ... Dezimalzahl
; Result
; d0 ... Rückgabewert: Hexadezimalzahl & $ff
	CNOP 0,4
rp_dec_to_hex
	ext.l	d1
	moveq	#0,d0			; Ergebnis = Hexadezialzahl
	moveq	#16,d3			; Hexadezimalzahl-Basis
	moveq	#0,d4			; 1. Nibble-Shiftwert
rp_dec_to_hex_loop
	divu.w	d3,d1			; /Hexadezimalzahl-Basis
	move.l	d1,d2			; Ergebnis retten
	swap	d2			; Rest der Division
	lsl.w	d4,d2			; Nibble in richtige Position bringen
	addq.b	#4,d4			; nächstes Nibble
	add.w	d2,d0			; Nibble eintragen
	ext.l	d1			; Quotient auf 32 Bit erweitern
	bne.s	rp_dec_to_hex_loop	; Wenn Quotient <> NULL -> Schleife
	and.w	#$00ff,d0		; Nur Bits 0-7 (lower Byte)
	rts


; ** Dezimalzahl in ASCII-Zeichen umwandeln **
; Input
; d1 ... Dezimalzahl
; d7 ... Anzahl der Stellen zum Umwandeln
; a0 ... Stringadresse
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rp_dec_to_ascii
	ext.l	d1
	lea	rp_dec_table(pc),a1	; Stellentabelle
	lea	(a1,d7.w*4),a1		; Erste Zehnerpotenz in Stellentabelle ermitteln
	subq.w	#1,d7			; wegen dbf
rp_dec_to_ascii_loop1
	moveq	#-1,d3			; Ziffer
	move.l	-(a1),d2		; Zehnerpotenz 10^n
rp_dec_to_ascii_loop2
	addq.b	#1,d3			; Ziffer erhöhen
	sub.l	d2,d1			; Zehnerpotenz abziehen
	bcc.s	rp_dec_to_ascii_loop2	; Wenn kein Übertrag, dann verzweige
	add.b	#"0",d3			; Ziffer -> ASCII-Zeichen
	add.l	d2,d1			; Rest berichtigen
	move.b	d3,(a0)+		; Zeichen in String schreiben
	dbf	d7,rp_dec_to_ascii_loop1
	rts


; ** Hexadezimalzahl in ASCII-Zeichen umwandeln **
; Input
; d1 ... Hexadezimalzahl
; d7 ... Anzahl der Stellen zum Umwandeln
; a0 ... Zeiger auf String
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rp_hex_to_ascii
	ext.l	d1
	add.l	d7,a0			; Zeiger auf Ende des Strings
	subq.w	#1,d7			; wegen dbf
rp_hex_to_ascii_loop
	moveq	#$f,d0			; Nibble-Maske
	and.b	d1,d0			; Nur Low-Nibble
	add.b	#"0",d0			; Ziffer -> ASCII-Zeichen
	cmp.b	#"9",d0			; Zeichen <= "9" ?
	ble.s	rp_hex_to_ascii_ok	; Ja -> verzweige
	add.b	#39,d0			; 10="a",11="b",..
rp_hex_to_ascii_ok
	lsr.l	#4,d1			; nächstes Nibble
	move.b	d0,-(a0)		; Zeichen in String schreiben
	dbf	d7,rp_hex_to_ascii_loop
	rts


; ** Checksumme aus den ersten 7 ASCII-Zeichen des Ausgabe-Strings bilden **
; Input
; d7 ... Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
; a0 ... Zeiger auf String
; Result
; d0 ... Rückgabewert: Checksumme
	CNOP 0,4
rp_get_ascii_checksum
	moveq	#0,d0			; Checksumme
	moveq	#0,d1
	subq.w	#1,d7			; wegen dbf
rp_get_ascii_checksum_loop
	move.b	(a0)+,d1		; ASCII-Wert
	add.w	d1,d0
	dbf	d7,rp_get_ascii_checksum_loop
	rts


; ** String auf seriellem Port ausgeben und Timer stoppen **
	CNOP 0,4
rp_stop_timer
	CALLLIBS Disable
	move.w	#$0100,d1		; 8 Bits pro Zeichen beim Schreiben, 1 Stoppbit
	move.w	#SERDATRF_TBE,d2
	move.w	ADKCONR(a5),d3		; Alten Inhalt von ADKCON retten
	lea	rp_output_string(pc),a0
	move.w	#ADKF_UARTBRK,ADKCON(a5) ; TXD löschen
	move.w	#(PAL_CLOCK_CONSTANT/adl_baud)-1,SERPER(a5)
	moveq	#(rp_output_string_end-rp_output_string)-1,d7 ; Anzahl der Bytes zum Schreiben
rp_write_string_loop
	move.w	SERDATR(a5),d0
	and.w	d2,d0			; TBE-Bit gesetzt ?
	beq.s	rp_write_string_loop	; Nein -> verzweige
	move.b	(a0)+,d1		; Datenbyte D0-D7 kopieren
	move.w	d1,SERDAT(a5)		; und Datenwort übertragen
	dbf	d7,rp_write_string_loop
	move.w	#$7fff,ADKCON(a5)	; Alle Bits von ADKCON löschen
	or.w	#ADKF_SETCLR,d3		; Bits setzen
	move.w	d3,ADKCON(a5)		; Alter Inhalt von ADKCON
	CALLLIBQ Enable


; ** Prüfen, ob alle Demos bereits gestartet wurden **
	CNOP 0,4
rp_check_demofile_pathtags
	MOVEF.L playback_queue_entry_size,d0
	lea	rp_entries_buffer+pqe_tag_active(pc),a0
	move.w	rp_entries_number(pc),d7
	subq.w	#1,d7			; wegen dbf
rp_check_demofile_pathtags_loop
	tst.b	(a0)			; Tag-Status nicht gesetzt ?
	beq.s	rp_not_all_demofile_pathtags_set ; Ja -> verzweige
	add.l	d0,a0			; nächster Eintrag
	dbf	d7,rp_check_demofile_pathtags_loop
rp_all_demofile_pathtags_set
	move.w	rp_endless_enabled(pc),d0
	beq.s	rp_remove_tags
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
rp_remove_tags
	moveq	#0,d0
	MOVEF.L playback_queue_entry_size,d1
	lea	rp_entries_buffer+pqe_tag_active(pc),a0
	move.w	rp_entries_number(pc),d7 ; Anzahl der Dateipfade
	subq.w	#1,d7			; wegen dbf
rp_remove_tags_loop
	move.b	d0,(a0)			; Tag-Status löschen
	add.l	d1,a0			; nächster Eintrag
	dbf	d7,rp_remove_tags_loop
	lea	rp_entries_offset(pc),a0
	clr.w	(a0)			; Offset in Dateipfade-Tabelle zurücksetzen
rp_not_all_demofile_pathtags_set
	moveq	#RETURN_ERROR,d0
	rts


; ** Bildschirm für kurze Zeit (n-mal 50 FPS) umfärben **
; d3 ... RBG4 Farbwert
	CNOP 0,4
rp_screen_colour_flash
	moveq	#$0001,d2		; Maske für vertikale Position Bit 8
	moveq	#rp_frames_delay-1,d7	; Anzahl der Frames auf die gewartet wird
rp_delay_loop
	move.w	VPOSR(a5),d0
	and.w	d2,d0			; Nur vertikale Position >=$100
rp_wait_tick
	move.w	d3,COLOR00(a5)
	move.w	VPOSR(a5),d1
	and.w	d2,d1			; Nur vertikale Position >=$100
	cmp.w	d1,d0			; Immer noch der gleiche Frame ?
	beq.s	rp_wait_tick		; Ja -> Schleife
	dbf	d7,rp_delay_loop
	rts


	CNOP 0,4
rp_restore_custom_cool_capture
	move.l	rp_reset_program_memory(pc),CoolCapture(a6)
	bsr.s	rp_calculate_checksum
	CALLLIBQ CacheClearU


; ** Checksumm für Exec-Base berechnen **
; Input
; a6 ... Exec-Base
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rp_calculate_checksum
	moveq	#0,d0
	move.w	d0,LowMemChkSum(a6)	; Checksumme in Execbase löschen
	lea	SoftVer(a6),a0		; Start-Abschnitt in Execbase
	moveq	#((ChkSum-SoftVer)/WORD_SIZE)-1,d1 ; Anzahl Worte, über die Checksumme gebildet wird
rp_calculate_checksum_loop
	add.w	(a0)+,d0
	dbf	d1,rp_calculate_checksum_loop
	not.w	d0
	move.w	d0,(a0)			; Neue Checksumme
	rts


	CNOP 0,4
rp_install_custom_exception_vectors
	lea	rp_read_vbr(pc),a5
	CALLLIBS Supervisor
	move.l	d0,a0
	IFEQ adl_level_7_handler_enabled
		lea	rp_level_7_reset_active(pc),a1
		moveq	#FALSE,d0
		move.w	d0,(a1)		; Sicherheitshalber auf FALSE setzen
		lea	rp_old_level_7_autovector(pc),a1
		move.l	LEVEL_7_AUTOVECTOR(a0),(a1)
		lea	rp_level_7_program(pc),a1
		move.l	a1,LEVEL_7_AUTOVECTOR(a0)
	ENDC

	lea	rp_old_trap_0_vector(pc),a1
	lea	rp_custom_trap_0_vector(pc),a2

	move.l	TRAP_0_VECTOR(a0),(a1)+
	lea	rp_trap_0_program(pc),a4
	move.l	a4,TRAP_0_VECTOR(a0)
	move.l	a4,(a2)+

	move.l	TRAP_1_VECTOR(a0),(a1)+
	lea	rp_trap_1_program(pc),a4
	move.l	a4,TRAP_1_VECTOR(a0)
	move.l	a4,(a2)+

	move.l	TRAP_2_VECTOR(a0),(a1)+
	lea	rp_trap_2_program(pc),a4
	move.l	a4,TRAP_2_VECTOR(a0)
	move.l	a4,(a2)+

	move.l	TRAP_3_VECTOR(a0),(a1)+
	lea	rp_trap_3_program(pc),a4
	move.l	a4,TRAP_3_VECTOR(a0)
	move.l	a4,(a2)+

	move.l	TRAP_4_VECTOR(a0),(a1)+
	lea	rp_trap_4_program(pc),a4
	move.l	a4,TRAP_4_VECTOR(a0)
	move.l	a4,(a2)+

	move.l	TRAP_5_VECTOR(a0),(a1)+
	lea	rp_trap_5_program(pc),a4
	move.l	a4,TRAP_5_VECTOR(a0)
	move.l	a4,(a2)+

	IFEQ adl_level_7_handler_enabled
		move.l	TRAP_6_VECTOR(a0),(a1)+
	ELSE
		move.l	TRAP_6_VECTOR(a0),(a1)
	ENDC
	lea	rp_trap_6_program(pc),a4
	move.l	a4,TRAP_6_VECTOR(a0)
	IFEQ adl_level_7_handler_enabled
		move.l	a4,(a2)+
	ELSE
		move.l	a4,(a2)
 	ENDC

	IFEQ adl_level_7_handler_enabled
		move.l	TRAP_7_VECTOR(a0),(a1)
		lea	rp_trap_7_program(pc),a4
		move.l	a4,TRAP_7_VECTOR(a0)
		move.l	a4,(a2)
	ENDC

	CALLLIBQ CacheClearU


; d0 ... Rückgabewert Inhalt von VBR
	CNOP 0,4
rp_read_vbr
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	movec.l VBR,d0
	nop
	rte


	IFEQ adl_level_7_handler_enabled
		CNOP 0,4
rp_level_7_program
		movem.l d0-d1/a0-a1/a6,-(a7)
		move.w	rp_level_7_reset_active(pc),d0
		bne.s	rp_no_reset
		move.l	_SysBase(pc),a6
		move.l	rp_reset_program_memory(pc),CoolCapture(a6)
		moveq	#0,d0
		move.l	d0,WarmCapture(a6)
		move.w	d0,LowMemChkSum(a6)
		bsr.s   rp_calculate_checksum
		CALLLIBS CacheClearU
		CALLLIBQ ColdReboot
		CNOP 0,4
rp_no_reset
		movem.l (a7)+,d0-d1/a0-a1/a6
		nop
		rte
	ENDC


; ** RP_POINTER_ENTRIES_NUMBER **
; Input
; Result
; d0 ... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_0_program
	lea	rp_entries_number(pc),a0
	move.l	a0,d0
	nop
	rte


; ** RP_POINTER_ENTRIES_NUMBER_MAX **
; Input
; Result
; d0 ... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_1_program
	lea	rp_entries_number_max(pc),a0
	move.l	a0,d0
	nop
	rte


; ** RP_POINTER_ENTRIES_OFFSET **
; Input
; Result
; d0 ... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_2_program
	lea	rp_entries_offset(pc),a0
	move.l	a0,d0
	nop
	rte


; ** RP_POINTER_ENTRIES_BUFFER **
; Input
; Result
; d0 ... Rückgabewert: Zeiger auf Puffer für Dateipfade
	CNOP 0,4
rp_trap_3_program
	lea	rp_entries_buffer(pc),a0
	move.l	a0,d0
	nop
	rte


; ** RP_POINTER_ENDLESS_ENABLED **
; Input
; Result
; d0 ... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_4_program
	lea	rp_endless_enabled(pc),a0
	move.l	a0,d0
	nop
	rte


; ** RP_POINTER_CUSTOM_VECTORS **
; Input
; Result
; d0 ... Rückgabewert: Zeiger auf eigene Trap-Vektoren
	CNOP 0,4
rp_trap_5_program
	lea	rp_custom_trap_0_vector(pc),a0
	move.l	a0,d0
	nop
	rte


; ** RP_REMOVE_RESET_PROGRAM **
; Input
; Result
; d0 ... Rückgabewert: Gesamtgröße des Reset-Programms
	CNOP 0,4
rp_trap_6_program
	movem.l	a5-a6,-(a7)
	move.l	exec_base.w,a6
	bsr.s	rp_clear_cool_capture
	bsr.s	rp_old_exception_vectors
	lea	rp_reset_program_memory(pc),a0
	move.l	a0,d0
	movem.l	(a7)+,a5-a6
	nop
	rte


; Input
; a6 ... Exec-Base
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rp_clear_cool_capture
	moveq	#0,d0
	move.l	d0,CoolCapture(a6)
	bsr	rp_calculate_checksum
	CALLLIBQ CacheClearU


; Input
; a6 ... Exec-Base
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rp_old_exception_vectors
	lea	rp_read_vbr(pc),a5
	CALLLIBS Supervisor
	tst.l	d0			; VBR = $000000 ?
	beq.s	rp_chip_memory_old_trap_vectors ; Ja -> verzweige
	move.l	d0,a0
	IFEQ adl_level_7_handler_enabled
		move.l	rp_old_level_7_autovector(pc),LEVEL_7_AUTOVECTOR(a0) ; Zeiger alte Level-7-Interrptprogramm eintragen
	ENDC
	add.w	#TRAP_0_VECTOR,a0	; Ab Trap0-Vektor
	bsr.s	rp_copy_old_trap_vectors
rp_chip_memory_old_trap_vectors
	IFEQ adl_level_7_handler_enabled
		move.l	d0,a0
		move.l	rp_old_level_7_autovector(pc),LEVEL_7_AUTOVECTOR(a0) ; Zeiger alte Level-7-Interrptprogramm eintragen
	ENDC
	move.w	#TRAP_0_VECTOR,a0	; Ab Trap0-Vektor
	bsr.s	rp_copy_old_trap_vectors
	CALLLIBQ CacheClearU


; Alte Trap-Vektoren wieder setzen
; Input
; a0 ... Ziel Trap#0-Vektor
; Result
; d0 ... Kein Rückgabewert
	CNOP 0,4
rp_copy_old_trap_vectors
	lea	rp_old_trap_0_vector(pc),a1
	IFEQ adl_level_7_handler_enabled
		moveq	#8-1,d7		; Anzahl der Trap-Vektoren
	ELSE
		moveq	#7-1,d7		; Anzahl der Trap-Vektoren
	ENDC
rd_copy_old_trap_vectors_loop
	move.l	(a1)+,(a0)+		; Vektor kopieren
	dbf	d7,rd_copy_old_trap_vectors_loop
	rts


	IFEQ adl_level_7_handler_enabled
; ** RP_SET_LEVEL_7_RESET_ACTIVE **
		CNOP 0,4
rp_trap_7_program
		lea	rp_level_7_reset_active(pc),a0
		clr.w	(a0)
		nop
		rte
	ENDC


	CNOP 0,4
rp_dec_table
	DC.L 1,10,100,1000,10000

rp_reset_program_memory		DC.L 0
rp_reset_program_size		DC.L 0

	IFEQ adl_level_7_handler_enabled
rp_old_level_7_autovector	DC.L 0
	ENDC
rp_old_trap_0_vector		DC.L 0
rp_old_trap_1_vector		DC.L 0
rp_old_trap_2_vector		DC.L 0
rp_old_trap_3_vector		DC.L 0
rp_old_trap_4_vector		DC.L 0
rp_old_trap_5_vector		DC.L 0
rp_old_trap_6_vector		DC.L 0
	IFEQ adl_level_7_handler_enabled
rp_old_trap_7_vector		DC.L 0
	ENDC
rp_custom_trap_0_vector		DC.L 0
rp_custom_trap_1_vector		DC.L 0
rp_custom_trap_2_vector		DC.L 0
rp_custom_trap_3_vector		DC.L 0
rp_custom_trap_4_vector		DC.L 0
rp_custom_trap_5_vector		DC.L 0
rp_custom_trap_6_vector		DC.L 0
	IFEQ adl_level_7_handler_enabled
rp_custom_trap_7_vector		DC.L 0
rp_level_7_reset_active		DC.W 0
	ENDC

rp_entries_number		DC.W 0
rp_entries_number_max		DC.W 0
rp_entries_offset	 	DC.W 0
rp_endless_enabled		DC.W 0


; ** String für serielle Übertragung **
rp_output_string
	DC.B "#" 			; Start-Kennung
rp_output_string_number
	DS.B 5				; Dezimal-ASCII-Zahl mit fünf Stellen
rp_output_string_comma
	DC.B ","			; Komma-ASCII-Zeichen
rp_output_string_checksum
	DS.B 2				; Checksumme Hex-ASCII-Zahl mit zwei Stellen
rp_output_string_line_feed
	DC.B ASCII_LINE_FEED
rp_output_string_end
	EVEN


rp_entries_buffer			; Puffergröße wird später berechnet

rp_reset_program_end


	CNOP 0,4
adl_cool_capture_request
	DS.B EasyStruct_SIZEOF


	CNOP 0,4
adl_cmd_results
	DS.B cmd_results_array_size


; **** Demo-Selector ****
	CNOP 0,4
ds_playlist_results_array
	DS.B playlist_results_array_size


ds_startmode_request
	DS.B EasyStruct_SIZEOF


	CNOP 0,4
ds_file_request_tag_list
	DS.B ti_SIZEOF*11

ds_file_request_use_tag_list
	DS.B ti_SIZEOF*2


; **** RunDemo ****
rd_serial_io
	DS.B IOEXTSER_size


	CNOP 0,4
rd_load_color_table
	DC.W 0				; Anzahl der Farben
	DC.W 0				; Ab welcher Farbe
rd_color00
	DS.L 3*1			; 32-Bit RGB-Werte
	DC.L 0				; Ende der Tabelle


rd_screen_tag_list
	DS.B ti_SIZEOF*20

rd_window_tag_list
	DS.B ti_SIZEOF*17

rd_video_control_tag_list
	DS.B ti_SIZEOF*2


_SysBase			DC.L 0
_DOSBase			DC.L 0
_GfxBase			DC.L 0
_IntuitionBase			DC.L 0
_ASLBase			DC.L 0
_IconBase			DC.L 0
_CIABase			DC.L 0
adl_variables			DS.B adl_variables_size


dos_library_name		DC.B "dos.library",0
	EVEN
graphics_library_name		DC.B "graphics.library",0
	EVEN
intuition_library_name		DC.B "intuition.library",0
	EVEN
asl_library_name		DC.B "asl.library",0
	EVEN
icon_library_name		DC.B "icon.library",0
	EVEN
ciaa_resource_name		DC.B "ciaa.resource",0
	EVEN
ciab_resource_name		DC.B "ciab.resource",0
	EVEN
serial_device_name		DC.B "serial.device",0
	EVEN

; **** Run-Demo ****
rd_screen_name			DC.B "Amiga Demo Launcher",0
	EVEN
rd_window_name			DC.B "Amiga Demo Launcher",0
	EVEN

rd_demo_dir_path		DS.B adl_demofile_path_length

whdl_tooltype_PRELOAD	DC.B "PRELOAD",0
whdl_tooltype_PRELOADSIZE	DC.B "PRELOADSIZE",0
whdl_tooltype_QUITKEY	DC.B "QUITKEY",0
	EVEN


adl_cmd_line			DC.B ASCII_LINE_FEED
adl_cmd_line_end
	EVEN


; ** Requester CoolCapture-Abfrage **
adl_cool_capture_request_title
	DC.B "Amiga Demo Launcher message",0
	EVEN
adl_cool_capture_request_body
	DC.B "The CoolCapture vector is already used.",ASCII_LINE_FEED,ASCII_LINE_FEED
	DC.B "Should the Amiga Demo Launcher be installed",ASCII_LINE_FEED
	DC.B "and the other program be removed?",ASCII_LINE_FEED,0
	EVEN
adl_cool_capture_request_gadgets
	DC.B "Proceed|Quit",0
	EVEN


; ** Befehlsschablone **
adl_cmd_template
	DC.B "HELP/S,"
; ** Demo-Selector **
	DC.B "MAXENTRIES/K/N,"
	DC.B "RESETLOADPOS/S,"
	DC.B "PLAYLIST,"
	DC.B "NEWENTRY/S,"
	DC.B "QUIET/S,"
; ** Run-Demo **
	DC.B "MIN=MINS/K/N,"
	DC.B "SEC=SECS/K/N,"
	DC.B "LMBEXIT/K/N,"
	DC.B "PRERUNSCRIPT/K,"
	DC.B "SHOWQUEUE/S,"
	DC.B "PLAYENTRY/K/N,"
	DC.B "RANDOM/S,"
	DC.B "ENDLESS/S,"
	DC.B "LOOP/S,"
	DC.B "NOFADER/S,"
	DC.B "SOFTRESET/S,"
	DC.B "REMOVE/S",0
	EVEN


adl_help_message
	DC.B 10,"For more information about the usage use the argument HELP",10,10
adl_help_message_end
	EVEN


adl_cmd_usage_text
	DC.B ASCII_LINE_FEED,"Amiga Demo Launcher arguments description:",ASCII_LINE_FEED,ASCII_LINE_FEED
	DC.B "HELP                   This short arguments description",ASCII_LINE_FEED
	DC.B "MAXENTRIES ",155,"3",109,"number ",155,"0",109,"     Set maximum entries number of playback queue",ASCII_LINE_FEED
	DC.B "RESETLOADPOS           Reset entry offset of playback queue to zero",ASCII_LINE_FEED
	DC.B "[PLAYLIST] ",155,"3",109,"file path ",155,"0",109,"  Load and transfer external playlist script file",ASCII_LINE_FEED
	DC.B "NEWENTRY               Create new entry in playback queue",ASCII_LINE_FEED
	DC.B "QUIET                  No file requester if no demos left to play",ASCII_LINE_FEED
	DC.B "MIN/MINS ",155,"3",109,"number ",155,"0",109,"       Playtime in minutes (reset device needed)",ASCII_LINE_FEED
	DC.B "SEC/SECS ",155,"3",109,"number ",155,"0",109,"       Playtime in seconds (reset device needed)",ASCII_LINE_FEED
	DC.B "LMBEXIT ",155,"3",109,"number ",155,"0",109,"        Play demo multiparts by LMB exit (reset device needed)",ASCII_LINE_FEED
	DC.B "PRERUNSCRIPT ",155,"3",109,"file path ",155,"0",109,"Execute prerrun script file before demo is played",ASCII_LINE_FEED
	DC.B "SHOWQUEUE              Show content of playback queue",ASCII_LINE_FEED
	DC.B "PLAYENTRY ",155,"3",109,"number ",155,"0",109,"      Play certain entry of playback queue",ASCII_LINE_FEED
	DC.B "RANDOM                 Play random entry of playback queue",ASCII_LINE_FEED
	DC.B "ENDLESS                Play entries of playback queue endlessly",ASCII_LINE_FEED
	DC.B "LOOP                   Play demos until no more entries left to play",ASCII_LINE_FEED
	DC.B "NOFADER                Don't fade screen to black before demo is played",ASCII_LINE_FEED
	DC.B "SOFTRESET              Automatic reset after quitting demo",ASCII_LINE_FEED
	DC.B "REMOVE                 Remove Amiga Demo Launcher out of memory",ASCII_LINE_FEED,ASCII_LINE_FEED
adl_cmd_usage_text_end
	EVEN


; **** Demo-Selector ****
; ** Befehlsschablone der Playlist **
ds_playlist_template
	DC.B "demofile,"
	DC.B "OCSVANILLA/S,"		; Start-Modi
	DC.B "AGAVANILLA/S,"
	DC.B "TURBO/S,"
	DC.B "MIN=MINS/K/N,"		; Abspieldauer
	DC.B "SEC=SECS/K/N,"
	DC.B "LMBEXIT/K/N,"
	DC.B "scriptfile",0
	EVEN


ds_parsing_begin_text
	DC.B "Parsing and transferring playlist to playback queue...",ASCII_LINE_FEED,0
ds_parsing_begin_text_end
	EVEN
ds_parsing_result_text
	DC.B "... done",ASCII_LINE_FEED
	DC.B "Result: "
ds_transmitted_entries
	DC.B "  "
	DC.B "of "
ds_playlist_entries
	DC.B "  "
	DC.B "entries successfully transferred to playback queue",ASCII_LINE_FEED
	DC.B "Playback queue has "
ds_not_used_entries
	DC.B "  "
	DC.B "unused entries left for a transfer",ASCII_LINE_FEED
ds_parsing_result_text_end
	EVEN


ds_current_dir_name
	DS.B adl_demofile_path_length


ds_file_request_title
	DC.B "Choose up to "
ds_remaining_files
	DC.B "   "
	DC.B "demo"
ds_character_s
	DC.B "s",0
	EVEN


ds_file_request_pattern
	DC.B "~(#?.bin|"
	DC.B "#?.dat|"
	DC.B "#?.diz|"
	DC.B "#?.info|"
	DC.B "#?.nfo|"
	DC.B "#?.pak|"
	DC.B "#?.readme|"
	DC.B "#?.txt|"
	DC.B "#?.vars|"
	DC.B "_dl.#?)",0
	EVEN
ds_file_request_ok
	DC.B "Use",0
	EVEN
ds_file_request_quit
	DC.B "Quit",0
	EVEN
ds_file_request_reboot
	DC.B "Reboot",0
	EVEN


; ** Startmode-Requester **
ds_startmode_request_title
	DC.B "Define start mode",0
	EVEN
ds_startmode_request_body
	DC.B "In which mode should the demo start?",ASCII_LINE_FEED,0
	EVEN
ds_startmode_request_gadgets
	DC.B "OCS vanilla|AGA vanilla|turbo",0
	EVEN

        CNOP 0,4
rd_old_mmu_registers
 	DS.B old_mmu_registers_size


rd_demofile_name_header
	DC.B "Playing ",34
rd_demofile_name_header_end
	EVEN
rd_demofile_name_tail
	DC.B 34,"...",ASCII_LINE_FEED
rd_demofile_name_tail_end
	EVEN


rd_show_entry_header
	DC.B "Nr."
rd_show_entry_string
	DC.B "  ",34
rd_show_entry_string_end
	EVEN
rd_show_entry_space
	DC.B 34,"................................................"
rd_show_entry_space_end
	EVEN
rd_tag_active_text1
	DC.B " played",ASCII_LINE_FEED
rd_tag_active_text1_end
	EVEN
rd_tag_active_text2
	DC.B " not played",ASCII_LINE_FEED
rd_tag_active_text2_end
	EVEN


rd_message_text
	DC.B "Playback queue has "
rd_not_used_entries_string
	DC.B "   "
	DC.B "unused entries left",ASCII_LINE_FEED
rd_message_text_end
	EVEN

rd_message_text2
	DC.B "No more demos left to play",ASCII_LINE_FEED
rd_message_text2_end
	EVEN

rd_message_text3
	DC.B "Amiga Demo Launcher now removed from memory",ASCII_LINE_FEED
rd_message_text3_end
	EVEN

rd_message_text4
	DC.B "Replay loop stopped",ASCII_LINE_FEED
rd_message_text4_end
	EVEN


whdl_icon_path
	DS.B whdl_icon_path_length
	EVEN


rd_output_string
	DC.B "#"			; Start-Kennung
rd_output_string_duration
	DS.B 5				; Dezimal-ASCII-Zahl mit fünf Stellen
rd_output_string_comma
	DC.B ","			; Komma-ASCII-Zeichen
rd_output_string_checksum
	DS.B 2				; Checksumme Hex-ASCII-Zahl mit zwei Stellen
rd_output_string_line_feed
	DC.B ASCII_LINE_FEED
rd_output_string_end
	EVEN


; ** Befehlszeile für Execute-Befehl Argument PRERUNSCRIPT **
rd_prerunscript_cmd_line
	DC.B "Execute "
rd_prerunscript_cmd_line_path
	DS.B adl_prerunscript_path_length
	EVEN


; ** Befehlszeile für Execute-Befehl WHDLoad Slave-Datei **
whdl_slave_cmd_line
	DC.B "WHDLoad slave "
whdl_slave_cmd_line_path
	DS.B whdl_slave_path_length
	DS.B whdl_PRELOAD_length
	DS.B whdl_PRELOADSIZE_length
	DS.B whdl_QUITKEY_length
	EVEN


; ** Pseudo-Shell-Befehlszeile **
rd_shell_cmd_line
	DC.B ASCII_LINE_FEED,0


; ** Header für PrintFault() **
adl_error_header
	DC.B " ",0


; ** Fehlermeldungen **
; **** Amiga-Demo-Launcher ****
adl_error_text1
	DC.B "Couldnt open graphics.library",ASCII_LINE_FEED
adl_error_text1_end
	EVEN
adl_error_text2
	DC.B "OS 2.04 or better required",ASCII_LINE_FEED
adl_error_text2_end
	EVEN
adl_error_text3
	DC.B "MC68020 or better required",ASCII_LINE_FEED
adl_error_text3_end
	EVEN
adl_error_text4
	DC.B "Couldn't open intuition.library",ASCII_LINE_FEED
adl_error_text4_end
	EVEN


; **** Demo-Selector ****
ds_note_text
	DC.B "Maximum number of entries in playback queue already reached",ASCII_LINE_FEED
ds_note_text_end
	EVEN
ds_error_text2
	DC.B "Couldn't allocate memory for entries/playback queue buffer",ASCII_LINE_FEED
ds_error_text2_end
	EVEN
ds_error_text3
	DC.B "Couldn't lock playlist file"
ds_error_text3_end
	EVEN
ds_error_text4
	DC.B "Couldn't allocate memory for file info block structure",ASCII_LINE_FEED
ds_error_text4_end
	EVEN
ds_error_text5
	DC.B "Couldn't examine playlist file",ASCII_LINE_FEED
ds_error_text5_end
	EVEN
ds_error_text6
	DC.B "Couldn't allocate memory for playlist file",ASCII_LINE_FEED
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
	DC.B "Couldn't allocate dos object",ASCII_LINE_FEED
ds_error_text9_end
	EVEN
ds_error_text10
	DC.B "Entry "
ds_entries_string
	DC.B "	"
	DC.B "could not be transferred. Playlist arguments syntax error",ASCII_LINE_FEED
ds_error_text10_end
	EVEN
ds_error_text11
	DC.B "Couldn't open asl.library",ASCII_LINE_FEED
ds_error_text11_end
	EVEN
ds_error_text12a
	DC.B "Couldn't lock program directory",ASCII_LINE_FEED
ds_error_text12a_end
	EVEN
ds_error_text12b
	DC.B "Couldn't get program directory name",ASCII_LINE_FEED
ds_error_text12b_end
	EVEN
ds_error_text13
	DC.B "Couldn't initialize file requester structure",ASCII_LINE_FEED
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
	DC.B "Couldn't allocate memory for resident program",ASCII_LINE_FEED
ds_error_text17_end
	EVEN


; **** Run-Demo ****
rd_error_text1
	DC.B "Prerun script filepath is longer than 63 characters"
rd_error_text1_end
	EVEN
rd_error_text2a
	DC.B "Couldn't open ciaa.resource",ASCII_LINE_FEED
rd_error_text2a_end
	EVEN
rd_error_text2b
	DC.B "Couldn't open ciab.resource",ASCII_LINE_FEED
rd_error_text2b_end
	EVEN
rd_error_text3
	DC.B "Couldn't open icon.library",ASCII_LINE_FEED
rd_error_text3_end
	EVEN
rd_error_text4
	DC.B "Couldn't create serial message port",ASCII_LINE_FEED
rd_error_text4_end
	EVEN
rd_error_text5
	DC.B "Couldn't open serial.device",ASCII_LINE_FEED
rd_error_text5_end
	EVEN
rd_error_text6
	DC.B "Couldnt allocate memory for sprite data structure",ASCII_LINE_FEED
rd_error_text6_end
	EVEN
rd_error_text7
	DC.B "Couldnt allocate memory for colour values table",ASCII_LINE_FEED
rd_error_text7_end
	EVEN
rd_error_text8
	DC.B "Couldnt allocate memory for colour cache",ASCII_LINE_FEED
rd_error_text8_end
	EVEN
rd_error_text9
	DC.B "Demo already played",ASCII_LINE_FEED
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
	DC.B "Couldn't execute prerun scriptfile",ASCII_LINE_FEED
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
	DC.B "Couldn't lock demo directory",ASCII_LINE_FEED
rd_error_text15_end
	EVEN
rd_error_text16
	DC.B "Couldn't open PAL screen",ASCII_LINE_FEED
rd_error_text16_end
	EVEN
rd_error_text17
	DC.B "Couldn't open dummy window",ASCII_LINE_FEED
rd_error_text17_end
	EVEN
rd_error_text18
	DC.B "Serial device in use",ASCII_LINE_FEED
rd_error_text18_end
	EVEN
rd_error_text19
	DC.B "Baud rate not supported by hardware",ASCII_LINE_FEED
rd_error_text19_end
	EVEN
rd_error_text20
	DC.B "Bad parameter",ASCII_LINE_FEED
rd_error_text20_end
	EVEN
rd_error_text21
	DC.B "Hardware data overrun",ASCII_LINE_FEED
rd_error_text21_end
	EVEN
rd_error_text22
	DC.B "No data set ready",ASCII_LINE_FEED
rd_error_text22_end
	EVEN
rd_error_text23
	DC.B "Write to serial port failed",ASCII_LINE_FEED
rd_error_text23_end
	EVEN
rd_error_text24
	DC.B "Couldn't execute WHDLoad slave file",ASCII_LINE_FEED
rd_error_text24_end
	EVEN


	DC.B "$VER: Amiga Demo Launcher 1.0 (17.7.24)",0
	EVEN

	END
