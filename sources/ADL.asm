; AmigaDemoLauncher (ADL)
; Christian Gerbig
; 27.08.2024
; V.2.0

; Requirements
; * 68020+
; * 2 MB+
; * AGA
; * OS 3.0+


; Historie

; Lader für Intros und Demos "DemoSelector"
; Mit CoolCapture-Abfrage
; Level-7-Interrupt: Code kan optional aktiviert werden
;                    Funktion: Mit einem Level7-Taster kann per Level-7-Interrupt
;                    ein Softare-Reset ausgelöst werdem und das Reset-Programm
;                    wird wieder als CoolCapture installiert. Sehr hilfreich bei
;                    Intros wie "Tristar-Party", die die Coolcapture löschen
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
; Änderung des Arguments scriptfile in PRERUNSCRIPT

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
; ohne dass die WB geladen ist. Lösung: Eine neue Variable "dc_reset_active"
; wird nun abgefragt und nur auf TRUE gesetzt, wenn im File-Requester der
; Button "Reboot" existiert
; Longword-Alignment bei Variablen durch Dummies garantiert
; Reihenfolge der Aktivierung MMU/Caches bei "AGA 020"-Modus geändert: Erst
; werden die Caches aktiviert, dann die MMU
; "No AGA" runmode: Nun wird auch die MMU deaktiviert
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
; über die Funktion SystemTagList() ausgeführt wird und das Demo über WHDLoad
; startet
; Neues Argument LMBEXIT n: n=2..10 Bei einem Demo mit mehreren Teilen wird
; vom Reset Device automatisch das Drücken der linken Maustaste n-mal nach
; der vorgegebenen Spielzeit simuliert und somit zum nächsten Teil gesprungen.
; Die Spielzeit wird dabei wieder zurückgesetzt und von Neuem heruntergezählt.
; Intern wird mit n=1..9 gearbeitet und n zu der Spielzeit einfach dazu-
; addiert, bevor der Sekundenwert in Hex/ASCII umgewandelt wird. Wird keine
; Spielzeit angegeben, dann wird das Argument ignoriert und eine Fehlermeldung
; ausgegeben.
; Abbruch einer LOOP-Ausführung erst bei Fehlernummer = 20 (DOS-ERROR FAIL)
; oder > 121 (Datei ist nicht ausführbar)
; Routinen zur Umwandlung von Zahlen umgeschrieben und Fehler bereinigt		 		 			<
; Fehler in Routine zum Warten auf eine Rasterzeile bereinigt
; Fehler bei der Berechnung der Länge des Demo-Dateinamens bereinigt
; Das Argument LOOP kann jetzt über CTRL-C abgebrochen werden. Bevor das Demo
; per Mausklick beendet wird, muss die Tastenkombination CTRL-C dauerhaft
; gedrückt werden, damit nach dem Einblenden die Abfrage der Tastenkmbination
; funktioniert
; ADKCON wird jetzt richtig zurückgesetzt, bevor der alte Inhalt hineinge-
; schrieben wird

; V.2.0
; - Code komplett überarbeitet
; - DemoSelector = Demo-Charger
; - Texte geändert
; - Umbenennung der Start-Modi für die Playlist:
;   "OCS" ->	"OCSVANILLA"
;   "AGA" ->	"AGAVANILLA"
;   "FAST" ->	"TURBO"
; - Neue Werte und Bezeichnung der Start-Modi:
;   RUNMODE_TURBO	= $01
;   RUNMODE_OCS_VANILLA	= $02
;   RUNMODE_AGA_VANILLA	= $03
; - Argument NOFADER -> FADER (Umkehrung der Logik), es wird jetzt der aktive
;   Screen ausgefadet und nicht mehr der Custom-Screen
; - Änderung der Minimum-Config: 68020/OS3.0/AGA-Chipset
; - Bugfix Argument RESETLOADPOS: Es wurde die "entries_number" auf Null ge-
;   setzt, anstatt auf den Wert 1
; - Option: Abfrage der WB-Message entfernt, da es passieren kann, dass dies
;   berets von einem Demo gemacht wird und 2x die WB-Message nicht beant-
;   wortet werden kann
; - Prerunscript-Check völlig überarbeitet, in LOOP-Modus wird für jedes Demo
;   das gleiche Prerun-Script ausgeführt, wenn es über das Argument PRERUNSCRIPT
;   angegeben wurde
; - Argument QUIET: wieder herausgenommen
; - Argument RANDOM: komplett überarbeitet
; - Argument ENDLESS: komplett überarbeitet
; - Argument LMBEXIT: Code kann optional aktiviert werden
; - File-Requester: Es gibt keinen Reboot-Button mehr, die komplette Logik
;                   wurde entfernet
; - Argument playlist: Es muss nun das Keyword PLAYLIST mit angegeben werden,
;   da sonst alle angegebenen Zeichen als Playlist interpretiert werden
; - Argumente-Check: Gesonderte Fehlerabfrage für Keywords ohne Wert entfernt,
;                    da dies schon von ReadArgs() übernommen wird und die Funktion
;                    eine Null zurückgibt
; - Neue Logik Argument PRERUNSCRIPT in Verbindung mit einer eingespielten
;   Playliste: Wenn kein Argument PRERUNSCRIPT angegeben wurde, dann wird ein
;   eventuell per Playlist angegebenes Prerun-Scriptfile zum Demo ausgeführt.
;   Im LOOP-Modus wird dann für jedes Demo ein separates Prerun-Scriptfile
;   ausgeführt
; - Abfrage des Arguments REMOVE vorverlegt
; - Argument PLAYLIST: Nach dem Übertragen der Playlist in den Speicher wird
;                      nun diePlayback-Queue ausgegeben
; - Neues Argument CLEARQUEUE: Löschen der kompletten Playback-Liste im Speicher
; - Argument RESETLOADPOS in RESETQUEUE umbenannt
; - Wenn alle Demos aus der Liste gespielt wurden wird der ADL nicht mehr
;   automtisch aus dem Speicher entfernt
; - File-Requester: Der Filter berücksichtigt jetzt auch die Endung ".data"
; - Neues Argument: EDITQUEUE
; - Neuer Bereich: Queue-Handler qh_
; - Edit-Window: Gadgets für Entry-Nummer, Runmode und Entry-Active,
;                Änderungrn können in der Playback-Queue gespeichert werden
; - Neues Argument: EDITENTRY n


	SECTION code_and_variables,CODE

	MC68020

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

	INCLUDE "libraries/gadtools.i"
	INCLUDE "libraries/gadtools_lib.i"
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

OS_VERSION_MIN			EQU 39

MAGIC_COOKIE			EQU $000003f3

RUNMODE_TURBO			EQU $01
RUNMODE_OCS_VANILLA		EQU $02
RUNMODE_AGA_VANILLA		EQU $03


; **** Amiga-Demo-Launcher ****
adl_drives_motor_delay		EQU PAL_FPS/2 ; 500 ms

adl_restore_adl_code_enabled	EQU FALSE
adl_lmbexit_code_enabled	EQU FALSE

adl_demofile_path_length	EQU 124
adl_prerunscript_path_length	EQU 64

adl_entries_number_min		EQU 1

adl_seconds_max			EQU 59
adl_minutes_max			EQU 99

adl_baud			EQU 2400

	IFEQ adl_lmbexit_code_enabled
adl_lmbexit_parts_number_min	EQU 2
adl_lmbexit_parts_number_max	EQU 10
	ENDC


; **** Demo-Charger ****
dc_entries_number_default_max	EQU 10
dc_entries_number_max		EQU 99

dc_file_request_x_size		EQU 320
dc_file_request_y_size		EQU 200


; **** Queue-Handler ****
qh_edit_window_left		EQU 0
qh_edit_window_top		EQU 0
qh_edit_window_x_size		EQU 260
qh_edit_window_y_size		EQU 130

qh_text_gadget_x_size		EQU 240
qh_text_gadget_y_size		EQU 12
qh_text_gadget_x_position	EQU ((qh_edit_window_x_size-qh_text_gadget_x_size)*50)/100
qh_text_gadget_y_position	EQU ((qh_edit_window_y_size-qh_text_gadget_y_size)*5)/100

qh_bwd_button_gadget_x_size	EQU 30
qh_bwd_button_gadget_y_size	EQU 12
qh_bwd_button_gadget_x_position	EQU ((qh_edit_window_x_size-qh_bwd_button_gadget_x_size)*25)/100
qh_bwd_button_gadget_y_position	EQU ((qh_edit_window_y_size-qh_bwd_button_gadget_y_size)*20)/100
qh_bwd_button_gadget_id		EQU 1

qh_integer_gadget_x_size	EQU 30
qh_integer_gadget_y_size	EQU 12
qh_integer_gadget_x_position	EQU ((qh_edit_window_x_size-qh_integer_gadget_x_size)*50)/100
qh_integer_gadget_y_position	EQU ((qh_edit_window_y_size-qh_integer_gadget_y_size)*20)/100
qh_integer_gadget_id		EQU 2

qh_fwd_button_gadget_x_size	EQU 30
qh_fwd_button_gadget_y_size	EQU 12
qh_fwd_button_gadget_x_position	EQU ((qh_edit_window_x_size-qh_fwd_button_gadget_x_size)*75)/100
qh_fwd_button_gadget_y_position	EQU ((qh_edit_window_y_size-qh_fwd_button_gadget_y_size)*20)/100
qh_fwd_button_gadget_id		EQU 3

qh_cycle_gadget_x_size		EQU 130
qh_cycle_gadget_y_size		EQU 12
qh_cycle_gadget_x_position	EQU ((qh_edit_window_x_size-qh_cycle_gadget_x_size)*50)/100
qh_cycle_gadget_y_position	EQU ((qh_edit_window_y_size-qh_cycle_gadget_y_size)*40)/100
qh_cycle_gadget_id		EQU 4

qh_mx_gadget_x_size		EQU 105
qh_mx_gadget_y_size		EQU 11
qh_mx_gadget_x_position 	EQU ((qh_edit_window_x_size-qh_mx_gadget_x_size)*50)/100
qh_mx_gadget_y_position 	EQU ((qh_edit_window_y_size-qh_mx_gadget_y_size)*60)/100
qh_mx_gadget_id			EQU 5

qh_pos_button_gadget_x_size	EQU 70
qh_pos_button_gadget_y_size	EQU 12
qh_pos_button_gadget_x_position	EQU ((qh_edit_window_x_size-qh_pos_button_gadget_x_size)*4)/100
qh_pos_button_gadget_y_position	EQU ((qh_edit_window_y_size-qh_pos_button_gadget_y_size)*90)/100
qh_pos_button_gadget_id		EQU 6
qh_neg_button_gadget_x_size	EQU 70
qh_neg_button_gadget_y_size	EQU 12
qh_neg_button_gadget_x_position	EQU ((qh_edit_window_x_size-qh_neg_button_gadget_x_size)*96)/100
qh_neg_button_gadget_y_position	EQU ((qh_edit_window_y_size-qh_neg_button_gadget_y_size)*90)/100
qh_neg_button_gadget_id		EQU 7


; **** Run-Demo ****
rd_cleared_sprite_x_size	EQU 16
rd_cleared_sprite_y_size	EQU 1
rd_sprites_colors_number	EQU 16
rd_pal_screen_left		EQU 0
rd_pal_screen_top		EQU 0
rd_pal_screen_x_size		EQU 2
rd_pal_screen_y_size		EQU 2
rd_pal_screen_depth		EQU 1
rd_pal_screen_colors_number	EQU 2
rd_invisible_window_left	EQU 0
rd_invisible_window_top		EQU 0
rd_invisible_window_x_size	EQU rd_pal_screen_x_size
rd_invisible_window_y_size	EQU rd_pal_screen_y_size
rd_monitor_switch_delay		EQU PAL_FPS*3 ; 3 Sekunden


; **** WHD-Load ****
whdl_preload_length		EQU 8
whdl_preloadsize_length		EQU 20
whdl_quitkey_length		EQU 11
whdl_slave_path_length		EQU 124
whdl_icon_path_length		EQU 124


; **** Reset-Programm ****
rp_frames_delay			EQU 50
rp_rasterlines_delay		EQU 5

rp_color_okay			EQU $68b
rp_color_error			EQU $d74


; **** Screen-Fader ****
sf_colors_number		EQU 256

; **** Screen-Fader-Out ****
sfo_fader_speed			EQU 6

; **** Screen-Fader-In ****
sfi_fader_speed			EQU 10



GET_RESIDENT_ENTRIES_NUMBER	MACRO
	trap	#0
	ENDM

GET_RESIDENT_ENTRIES_NUMBER_MAX	MACRO
	trap	#1
	ENDM

GET_RESIDENT_ENTRY_OFFSET	MACRO
	trap	#2
	ENDM

GET_RESIDENT_ENTRIES_BUFFER	MACRO
	trap	#3
	ENDM

GET_RESIDENT_ENDLESS_ENABLED	MACRO
	trap	#4
	ENDM

GET_CUSTOM_TRAP_VECTORS		MACRO
	trap	#5
	ENDM

REMOVE_RESET_PROGRAM		MACRO
	trap	#6
	ENDM

	IFEQ adl_restore_adl_code_enabled
SET_RESTORE_ADL_ACTIVE		MACRO
		trap	#7
		ENDM
	ENDC


WAIT_MOUSE		MACRO

wm
 move.w $dff006,$dff180
 btst #2,$dff016
 bne.s wm
	ENDM



	INCLUDE "except-vectors-offsets.i"


	INCLUDE "screen-taglist-offsets.i"


	INCLUDE "window-taglist-offsets.i"


	INCLUDE "videocontrol-taglist-offsets.i"


	RSRESET

; **** Amiga-Demo-Launcher ****
adl_output_handle		RS.L 1

adl_dos_return_code		RS.L 1

adl_read_arguments		RS.L 1
adl_arg_help_enabled		RS.W 1
adl_arg_remove_enabled		RS.W 1

	RS_ALIGN_LONGWORD
adl_entries_buffer		RS.L 1
adl_entries_number		RS.W 1
adl_entries_number_max		RS.W 1

adl_reset_program_active	RS.W 1


; **** Demo-Charger ****
dc_arg_newentry_enabled		RS.W 1
dc_arg_playlist_enabled		RS.W 1

	RS_ALIGN_LONGWORD
dc_file_request			RS.L 1
dc_current_entry		RS.L 1
dc_multiselect_entries_number	RS.W 1

	RS_ALIGN_LONGWORD
dc_playlist_file_name		RS.L 1
dc_playlist_file_lock		RS.L 1
dc_playlist_file_fib		RS.L 1
dc_playlist_file_length		RS.L 1
dc_playlist_file_buffer		RS.L 1
dc_playlist_file_handle		RS.L 1
dc_playlist_entries_number	RS.W 1
dc_transmitted_entries_number 	RS.W 1


; **** Queue-handler ****
qh_arg_showqueue_enabled	RS.W 1
qh_arg_editentry_enabled	RS.W 1
qh_arg_editqueue_enabled	RS.W 1
qh_arg_clearqueue_enabled       RS.W 1
qh_arg_resetqueue_enabled	RS.W 1

	RS_ALIGN_LONGWORD

qh_workbench_screen		RS.L 1
qh_edit_window			RS.L 1

qh_screen_visual_info		RS.L 1
qh_context_gadget		RS.L 1
qh_text_gadget_gadget		RS.L 1
qh_bwd_button_gadget_gadget	RS.L 1
qh_integer_gadget_gadget	RS.L 1
qh_fwd_button_gadget_gadget	RS.L 1
qh_cycle_gadget_gadget		RS.L 1
qh_mx_gadget_gadget		RS.L 1

qh_check_window_events_active	RS.W 1

qh_edit_entry			RS.L 1
qh_edit_entry_demofile_name	RS.L 1
qh_edit_entry_offset		RS.W 1
qh_edit_runmode			RS.B 1
qh_edit_entry_active		RS.B 1


; **** Run-Demo ****
rd_arg_prerunscript_enabled	RS.W 1
rd_arg_random_enabled		RS.W 1
rd_arg_endless_enabled		RS.W 1
rd_arg_loop_enabled		RS.W 1
rd_arg_fader_enabled		RS.W 1
rd_arg_softreset_enabled	RS.W 1

	RS_ALIGN_LONGWORD
rd_serial_message_port		RS.L 1
rd_timer_delay			RS.W 1

rd_play_duration		RS.W 1

rd_entry_offset		RS.W 1

	RS_ALIGN_LONGWORD
rd_demofile_name		RS.L 1
rd_demofile_name_length		RS.L 1
rd_demofile_path		RS.L 1
rd_demofile_handle		RS.L 1
rd_demofile_magic_cookie	RS.L 1
rd_demofile_seglist		RS.L 1
rd_demofile_dir_lock		RS.L 1

rd_prerunscript_path		RS.L 1

	RS_ALIGN_LONGWORD
rd_active_screen		RS.L 1
rd_active_screen_mode		RS.L 1
rd_pal_screen			RS.L 1
rd_invisible_window		RS.L 1
rd_cleared_sprite_pointer_data	RS.L 1
rd_old_sprite_resolution	RS.L 1

rd_available_fast_memory_size	RS.L 1
rd_available_fast_memory	RS.L 1

rd_old_current_dir_lock		RS.L 1

rd_custom_trap_vectors		RS.L 1

rd_old_vbr			RS.L 1
rd_old_cacr			RS.L 1
rd_old_060_pcr			RS.L 1
rd_clear_030_mmu_register	RS.L 1


; **** WHD-Load ****
whdl_slave_enabled		RS.W 1
	RS_ALIGN_LONGWORD
whdl_disk_object		RS.L 1


; **** Screen-Fader ****
	RS_ALIGN_LONGWORD
sf_screen_colors_number		RS.L 1
sf_screen_color_table		RS.L 1
sf_screen_color_cache		RS.L 1

; **** Screen-Fader-In ****
sfi_active			RS.W 1

; **** Screen-Fader-Out ****
sfo_active			RS.W 1

adl_variables_size		RS.B 0


	RSRESET

cmd_results_array		RS.B 0

; **** Amiga-Demo-Launcher ****
cra_HELP			RS.L 1
cra_REMOVE			RS.L 1
; **** Demo-Charger ****
cra_MAXENTRIES			RS.L 1
cra_NEWENTRY			RS.L 1
cra_PLAYLIST			RS.L 1
; **** Queue-Handler ****
cra_SHOWQUEUE			RS.L 1
cra_EDITENTRY			RS.L 1
cra_EDITQUEUE			RS.L 1
cra_CLEARQUEUE			RS.L 1
cra_RESETQUEUE			RS.L 1
; **** Run-Demo ****
cra_PLAYENTRY			RS.L 1
cra_PRERUNSCRIPT		RS.L 1
cra_MINS			RS.L 1
cra_SECS			RS.L 1
	IFEQ adl_lmbexit_code_enabled
cra_LMBEXIT			RS.L 1
	ENDC
cra_RANDOM			RS.L 1
cra_ENDLESS			RS.L 1
cra_LOOP			RS.L 1
cra_FADER			RS.L 1
cra_SOFTRESET			RS.L 1

cmd_results_array_size		RS.B 0


	RSRESET

playlist_results_array		RS.B 0

pra_demofile			RS.L 1
pra_OCSVANILLA			RS.L 1
pra_AGAVANILLA			RS.L 1
pra_TURBO			RS.L 1
pra_MINS			RS.L 1
pra_SECS			RS.L 1
	IFEQ adl_lmbexit_code_enabled
pra_LMBEXIT			RS.L 1
	ENDC
pra_PRERUNSCRIPT		RS.L 1

playlist_results_array_size	RS.B 1


	RSRESET

playback_queue_entry		RS.B 0

pqe_demofile_path		RS.B adl_demofile_path_length
pqe_playtime			RS.W 1
pqe_runmode			RS.B 1
pqe_entry_active		RS.B 1
pqe_prerunscript_path		RS.B adl_prerunscript_path_length

playback_queue_entry_size 	RS.B 0


	RSRESET

load_color_table		RS.B 0

lct_colors_number		RS.W 1
lct_start_color			RS.W 1
lct_color00                     RS.L 3	; 3 x 32 Bit
lct_end				RS.L 1

load_color_table_size		RS.B 0


	RSRESET

sprite_pointer_data		RS.B 0

spd_control_word1		RS.W 1
spd_control_word2		RS.W 1
spd_color_descriptor		RS.W 2
spd_end_of_data			RS.W 2

sprite_pointer_data_size	RS.B 0


	RSRESET

pal_screen_colors		RS.B 0

psc_colors_number		RS.W 1
psc_start_color			RS.W 1
psc_color00			RS.L 3
psc_color01			RS.L 3
psc_end				RS.L 1

pal_screen_colors_size		RS.B 0


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


	RSRESET

old_chips_registers		RS.B 0

ocr_dmacon			RS.W 1
ocr_intena			RS.W 1
ocr_adkcon			RS.W 1

ocr_ciaa_pra			RS.B 1
ocr_ciaa_talo			RS.B 1
ocr_ciaa_tahi			RS.B 1
ocr_ciaa_tblo			RS.B 1
ocr_ciaa_tbhi			RS.B 1
ocr_ciaa_icr			RS.B 1
ocr_ciaa_cra			RS.B 1
ocr_ciaa_crb			RS.B 1

ocr_ciab_prb			RS.B 1
ocr_ciab_talo			RS.B 1
ocr_ciab_tahi			RS.B 1
ocr_ciab_tblo			RS.B 1
ocr_ciab_tbhi			RS.B 1
ocr_ciab_icr			RS.B 1
ocr_ciab_cra			RS.B 1
ocr_ciab_crb			RS.B 1

old_chips_registers_size	RS.B 0


	RSRESET

output_string			RS.B 0

os_start_id			RS.B 1
os_duration			RS.B 5
os_comma			RS.B 1
os_checksum			RS.B 2
os_line_feed			RS.B 1

output_string_size		RS.B 0


  RSRESET

edit_window_tag_list		RS.B 0

ewtl_WA_Left			RS.L 2
ewtl_WA_Top			RS.L 2
ewtl_WA_Width			RS.L 2
ewtl_WA_Height			RS.L 2
ewtl_WA_DetailPen		RS.L 2
ewtl_WA_BlockPen		RS.L 2
ewtl_WA_IDCMP			RS.L 2
ewtl_WA_Title			RS.L 2
ewtl_WA_PubScreenName		RS.L 2
ewtl_WA_MinWidth		RS.L 2
ewtl_WA_MinHeight		RS.L 2
ewtl_WA_MaxWidth		RS.L 2
ewtl_WA_MaxHeight		RS.L 2
ewtl_WA_AutoAdjust		RS.L 2
ewtl_WA_Flags			RS.L 2
ewtl_WA_Gadgets			RS.L 2
ewtl_TAG_DONE			RS.L 1

edit_window_tag_list_size	RS.B 0


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
	bsr	adl_open_gadtools_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_intuition_library
	bsr	adl_check_cool_capture
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_intuition_library

	bsr	adl_check_cmd_line
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

	tst.w	adl_arg_help_enabled(a3)
	beq     adl_cleanup_read_arguments
	tst.w	adl_arg_remove_enabled(a3)
	beq	adl_cleanup_read_arguments

	tst.w	qh_arg_showqueue_enabled(a3)
	bne.s	adl_check_arg_editentry_enabled
	bsr	qh_show_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
adl_check_arg_editentry_enabled
	tst.w	qh_arg_editentry_enabled(a3)
	bne.s	adl_check_arg_editqueue_enabled
	bsr	qh_edit_single_entry
	bra	adl_cleanup_read_arguments
	CNOP 0,4
adl_check_arg_editqueue_enabled
	tst.w	qh_arg_editqueue_enabled(a3)
	bne.s	adl_check_arg_clearqueue_enabled
	bsr	qh_edit_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
adl_check_arg_clearqueue_enabled
	tst.w	qh_arg_clearqueue_enabled(a3)
	bne.s	adl_check_arg_resetqueue_enabled
	bsr	qh_clear_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
adl_check_arg_resetqueue_enabled
	tst.w	qh_arg_resetqueue_enabled(a3)
        bne.s	adl_check_queue_empty
	bsr	qh_reset_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
adl_check_queue_empty
	bsr	qh_check_queue_empty
	tst.l	d0
	bne.s	dc_start

	tst.w	dc_arg_newentry_enabled(a3)
	beq.s	dc_start
	tst.w	dc_arg_playlist_enabled(a3)
	beq.s	dc_start
	tst.w	adl_reset_program_active(a3)
	beq	rd_start

	bsr	adl_print_intro_message_text


; **** Demo-Charger ****
dc_start
	bsr	dc_check_entries_number_max
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

 	bsr	dc_alloc_entries_buffer
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

	tst.w	dc_arg_playlist_enabled(a3)
	beq.s	dc_check_playlist

; ** Playlist-Datei nicht angegeben - Neue Einträge über File-Requester **
	bsr	dc_open_asl_library
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_entries_buffer
	bsr	dc_get_program_dir
	move.l	d0,adl_dos_return_code(a3)
	bne.s	dc_cleanup_asl_library

dc_demo_charge_loop
	bsr	dc_display_remaining_files
	bsr	dc_make_file_request
	move.l	d0,adl_dos_return_code(a3)
	bne.s	dc_cleanup_asl_library
	bsr	dc_display_file_request
	move.l	d0,adl_dos_return_code(a3)
	bne.s	dc_cleanup_file_request

	bsr	dc_get_demofile_path
	move.l	d0,adl_dos_return_code(a3)
	bne.s	dc_cleanup_file_request
	bsr	dc_free_file_request
	bsr	dc_display_runmode_request
        bsr	dc_check_entries_number_max
	move.l	d0,adl_dos_return_code(a3)
	beq.s	dc_demo_charge_loop

	bra.s	dc_cleanup_asl_library
	CNOP 0,4
dc_cleanup_file_request
	bsr	dc_free_file_request

dc_cleanup_asl_library
	bsr	dc_close_asl_library

dc_cleanup_reset_program
	bsr	dc_init_reset_program
	move.l	d0,adl_dos_return_code(a3)
	bne  	adl_cleanup_read_arguments

dc_cleanup_entries_buffer
	bsr	dc_free_entries_buffer

	bra	adl_cleanup_read_arguments

; ** Playlist-Datei angegeben **
	CNOP 0,4
dc_check_playlist
	bsr	dc_lock_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_entries_buffer

	bsr	dc_alloc_playlist_file_fib
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_locked_playlist_file

	bsr	dc_get_playlist_file_length
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_playlist_file_fib

	bsr	dc_alloc_playlist_file_buffer
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_playlist_file_fib

	bsr	dc_open_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_playlist_file_buffer

	bsr	dc_read_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_playlist_file

	bsr	dc_parse_playlist_file
	move.l	d0,adl_dos_return_code(a3)
        bne.s   dc_cleanup_playlist_file

	bsr	dc_check_entries_number_min
	move.l	d0,adl_dos_return_code(a3)

dc_cleanup_playlist_file
	bsr	dc_close_playlist_file

dc_cleanup_playlist_file_buffer
	bsr	dc_free_playlist_file_buffer

dc_cleanup_playlist_file_fib
	bsr	dc_free_playlist_file_fib

dc_cleanup_locked_playlist_file
	bsr	dc_unlock_playlist_file

        bra	dc_cleanup_reset_program


; **** Amiga Demo-Launcher ****
	CNOP 0,4
adl_cleanup_read_arguments
	bsr	adl_free_read_arguments
	bsr	adl_print_io_error

adl_cleanup_reset_program
	bsr	adl_remove_reset_program

adl_cleanup_gadtools_library
	bsr	adl_close_gadtools_library

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
	moveq	#TRUE,d0
	move.l	d0,adl_dos_return_code(a3)

	moveq	#FALSE,d1
	move.w	d1,adl_reset_program_active(a3)

	move.w	d1,adl_arg_help_enabled(a3)
	move.w	d1,adl_arg_remove_enabled(a3)

	move.w	d0,adl_entries_number(a3)
	move.w	#dc_entries_number_default_max,adl_entries_number_max(a3)


; **** Demo-Charger ****
	move.w	d1,dc_arg_newentry_enabled(a3)
	move.w	d1,dc_arg_playlist_enabled(a3)

	move.w  d0,dc_multiselect_entries_number(a3)

	move.w	d0,dc_playlist_entries_number(a3)
	move.w	d0,dc_transmitted_entries_number(a3)


; **** Queue-Handler ****
	move.w	d1,qh_arg_showqueue_enabled(a3)
	move.w	d1,qh_arg_editentry_enabled(a3)
	move.w	d1,qh_arg_editqueue_enabled(a3)
	move.w	d1,qh_arg_clearqueue_enabled(a3)
	move.w	d1,qh_arg_resetqueue_enabled(a3)

	move.w	#adl_entries_number_min,qh_edit_entry_offset(a3)

	move.w	d0,qh_check_window_events_active(a3)


; **** Run-Demo ****
	move.w	d1,rd_arg_prerunscript_enabled(a3)
	move.w	d1,rd_arg_random_enabled(a3)
	move.w	d1,rd_arg_endless_enabled(a3)
	move.w	d1,rd_arg_loop_enabled(a3)
	move.w	d1,rd_arg_fader_enabled(a3)
	move.w	d1,rd_arg_softreset_enabled(a3)

	move.w	d0,rd_timer_delay(a3)
	move.w	d0,rd_play_duration(a3)

	move.w	#adl_entries_number_min,rd_entry_offset(a3)

	move.l	d0,rd_demofile_seglist(a3)

	move.l	d0,rd_prerunscript_path(a3)

	move.l	d0,rd_clear_030_mmu_register(a3)


; **** WHD-Load ****
	move.w	d1,whdl_slave_enabled(a3)


; **** Screen-Fader-In ****
	move.w	d0,sfi_active(a3)

; **** Screen-Fader-Out ****
	move.w	d0,sfo_active(a3)


; **** Reset-Programm ****
	lea	rp_entries_number_max(pc),a0
	move.w	#dc_entries_number_default_max,(a0)

	lea	rp_entry_offset(pc),a0
	move.w	#adl_entries_number_min,(a0)

	lea	rp_endless_enabled(pc),a0
	move.w	d1,(a0)
	rts


	CNOP 0,4
adl_init_structures
	bsr	adl_init_cool_capture_request
	bsr	adl_init_output_string
	bsr     dc_init_runmode_request
	bsr	dc_init_file_request_tags
	bsr	qh_init_get_visual_info_tags
	bsr	qh_init_edit_window_tags
	bsr	qh_init_gadgets
	bsr	rd_init_pal_screen_colors
	bsr	rd_init_pal_screen_tags
	bsr	rd_init_invisible_window_tags
	bra	rd_init_video_control_tags


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
adl_init_output_string
	lea	rp_output_string(pc),a0
	move.b	#"#",os_start_id(a0)
	move.b	#",",os_comma(a0)
	move.b	#ASCII_LINE_FEED,os_line_feed(a0)
	rts


	CNOP 0,4
dc_init_runmode_request
	lea	dc_runmode_request(pc),a0
	move.l	d2,(a0)+		; Größe der Struktur
	move.l	d0,(a0)+		; Keine Flags
	lea	dc_runmode_request_title(pc),a1
	move.l	a1,(a0)+		; Zeiger auf Titeltext
	lea	dc_runmode_request_body(pc),a1
	move.l	a1,(a0)+		; Zeiger auf Text in Requester
	lea	dc_runmode_request_gadgets(pc),a1
	move.l	a1,(a0)			; Zeiger auf Gadgettexte
	rts


	CNOP 0,4
dc_init_file_request_tags
	lea	dc_file_request_init_tag_list(pc),a0
; ** Tags für Fensterbeeinflussung **
	move.l	#ASLFR_Window,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
; ** Texte für Textanzeige **
	move.l	#ASLFR_TitleText,(a0)+
	lea	dc_file_request_title(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_PositiveText,(a0)+
	lea	dc_file_request_ok(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_NegativeText,(a0)+
	lea	dc_file_request_quit(pc),a1
	move.l	a1,(a0)+
; ** Grundparameter für File-Requester **
	move.l	#ASLFR_InitialLeftEdge,(a0)+
	move.l	d0,(a0)+
	move.l	#ASLFR_InitialTopEdge,(a0)+
	move.l	d0,(a0)+
	move.l	#ASLFR_InitialWidth,(a0)+
	move.l	#dc_file_request_x_size,(a0)+
	move.l	#ASLFR_InitialHeight,(a0)+
	move.l	#dc_file_request_y_size,(a0)+
	move.l	#ASLFR_InitialPattern,(a0)+
	lea	dc_file_request_pattern(pc),a1
	move.l	a1,(a0)+
; ** Optionen **
	move.l	#ASLFR_Flags1,(a0)+
	moveq	#FRF_DOPATTERNS+FRF_DOMULTISELECT,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)

	lea	dc_file_request_display_tag_list(pc),a0
	move.l	#ASLFR_InitialDrawer,(a0)+
	lea	dc_current_dir_name(pc),a1
	move.l	a1,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
qh_init_get_visual_info_tags
	lea	qh_get_visual_info_tag_list(pc),a0
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
qh_init_edit_window_tags
	lea	qh_edit_window_tag_list(pc),a0
	move.l	#WA_Left,(a0)+
	moveq	#qh_edit_window_left,d2
	move.l	d2,(a0)+
	move.l	#WA_Top,(a0)+
	moveq	#qh_edit_window_top,d2
	move.l	d2,(a0)+
	move.l	#WA_Width,(a0)+
	move.l	#qh_edit_window_x_size,(a0)+
	move.l	#WA_Height,(a0)+
	move.l	#qh_edit_window_y_size,(a0)+
	move.l	#WA_DetailPen,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	#WA_BlockPen,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_IDCMP,(a0)+
	move.l	#IDCMP_CLOSEWINDOW|IDCMP_REFRESHWINDOW|IDCMP_GADGETUP|IDCMP_GADGETDOWN,(a0)+
	move.l	#WA_Title,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_PubScreenName,(a0)+
	lea	workbench_screen_name(pc),a1
	move.l	a1,(a0)+
	move.l	#WA_MinWidth,(a0)+
	move.l	#qh_edit_window_x_size,(a0)+
	move.l	#WA_MinHeight,(a0)+
	move.l	#qh_edit_window_y_size,(a0)+
	move.l	#WA_MaxWidth,(a0)+
	move.l	#qh_edit_window_x_size,(a0)+
	move.l	#WA_MaxHeight,(a0)+
	move.l	#qh_edit_window_y_size,(a0)+
	move.l	#WA_AutoAdjust,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_Flags,(a0)+
	move.l	#WFLG_CLOSEGADGET|WFLG_ACTIVATE|WFLG_DEPTHGADGET|WFLG_DRAGBAR,(a0)+
	move.l	#WA_Gadgets,(a0)+
	move.l	d0,(a0)+		; Wird später initialisiert
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
qh_init_gadgets
; ** CreateContext() **
	lea	qh_gadget_list(pc),a0
	clr.l	(a0)

; ** NewGadget **
	lea	qh_topaz_80(pc),a0
	lea	topaz_font_name(pc),a1
	move.l	a1,ta_name(a0)
	move.w	#8,ta_ysize(a0)
	moveq	#0,d0
	move.b	d0,ta_style(a0)
	move.b	d0,ta_flags(a0)

	lea	qh_new_gadget(pc),a0
	lea	qh_topaz_80(pc),a1
	move.l	a1,gng_TextAttr(a0)
	moveq	#0,d0
   	move.l	d0,gng_UserData(a0)

; ** Text Gadget **
	lea	qh_text_gadget_tag_list(pc),a0
	move.l	#GTTX_Text,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	#GTTX_Border,(a0)+
	moveq	#BOOL_TRUE,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

	lea	qh_set_text_gadget_tag_list(pc),a0
	move.l	#GTTX_Text,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

; ** Button Gadgets **
	lea	qh_button_gadget_tag_list(pc),a0
	move.l	#GA_Disabled,(a0)+
	moveq	#BOOL_FALSE,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

	lea	qh_set_button_gadget_tag_list(pc),a0
	move.l	#GA_Disabled,(a0)+
	moveq	#BOOL_FALSE,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

; ** Integer Gadget **
	lea	qh_integer_gadget_tag_list(pc),a0
	move.l	#GTIN_Number,(a0)+
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	move.l	d0,(a0)+
	move.l	#GTIN_MaxChars,(a0)+
	moveq	#2,d0			; 2 Stellen
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

	lea	qh_set_integer_gadget_tag_list(pc),a0
	move.l	#GTIN_Number,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

; ** Cycle Gadget **
	lea	qh_cycle_gadget_array(pc),a0
	lea	qh_cycle_gadget_choice_text1(pc),a1
	move.l	a1,(a0)+
	lea	qh_cycle_gadget_choice_text2(pc),a1
	move.l	a1,(a0)+
	lea	qh_cycle_gadget_choice_text3(pc),a1
	move.l	a1,(a0)+
	moveq	#0,d0
	move.w	d0,(a0)

	lea	qh_cycle_gadget_tag_list(pc),a0
	move.l	#GTCY_Labels,(a0)+
	lea	qh_cycle_gadget_array(pc),a1
	move.l	a1,(a0)+
	move.l	#GTCY_Active,(a0)+
	moveq	#2,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

	lea	qh_set_cycle_gadget_tag_list(pc),a0
	move.l	#GTCY_Active,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

; ** Mutually-Exclusive Gadget **
	lea	qh_mx_gadget_array(pc),a0
	lea	qh_mx_gadget_text1(pc),a1
	move.l	a1,(a0)+
	lea	qh_mx_gadget_text2(pc),a1
	move.l	a1,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)

	lea	qh_mx_gadget_tag_list(pc),a0
	move.l	#GTMX_Labels,(a0)+
	lea	qh_mx_gadget_array(pc),a1
	move.l	a1,(a0)+
	move.l	#GTMX_Active,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)

	lea	qh_set_mx_gadget_tag_list(pc),a0
	move.l	#GTMX_Active,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d0
	move.l	d0,(a0)
	rts


	CNOP 0,4
rd_init_pal_screen_colors
	lea	rd_pal_screen_colors(pc),a0
	move.w	#rd_pal_screen_colors_number,(a0)+
	moveq	#0,d0
	move.w	d0,(a0)+		; Erste Farbe COLOR00
	move.l	d0,(a0)+		; COLOR00 32-Bit Rotwert
	move.l	d0,(a0)+		; COLOR00 32-Bit Grünwert
	move.l	d0,(a0)+		; COLOR00 32-Bit Blauwert
	move.l	d0,(a0)+		; COLOR01 32-Bit Rotwert
	move.l	d0,(a0)+		; COLOR01 32-Bit Grünwert
	move.l	d0,(a0)+		; COLOR01 32-Bit Blauwert
	move.l	d0,(a0)			; Ende der Tabelle
	rts


	CNOP 0,4
rd_init_pal_screen_tags
	lea	rd_pal_screen_tag_list(pc),a0
	move.l	#SA_Left,(a0)+
     	moveq	#rd_pal_screen_left,d2
	move.l	d2,(a0)+
	move.l	#SA_Top,(a0)+
     	moveq	#rd_pal_screen_top,d2
	move.l	d2,(a0)+
	move.l	#SA_Width,(a0)+
	moveq	#rd_pal_screen_x_size,d2
	move.l	d2,(a0)+
	move.l	#SA_Height,(a0)+
	moveq	#rd_pal_screen_y_size,d2
	move.l	d2,(a0)+
	move.l	#SA_Depth,(a0)+
	moveq	#rd_pal_screen_depth,d2
	move.l	d2,(a0)+
	move.l	#SA_DisplayID,(a0)+
	move.l	#PAL_MONITOR_ID|LORES_KEY,(a0)+
	move.l	#SA_DetailPen,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	#SA_BlockPen,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Title,(a0)+
	lea	rd_pal_screen_name(pc),a1
	move.l	a1,(a0)+
	move.l	#SA_Colors32,(a0)+
	lea	rd_pal_screen_colors(pc),a1
	move.l	a1,(a0)+
	move.l	#SA_Font,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_SysFont,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Type,(a0)+
	move.l	#CUSTOMSCREEN,(a0)+
	move.l	#SA_Behind,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Quiet,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_ShowTitle,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_AutoScroll,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Draggable,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Interleaved,(a0)+
	move.l	d0,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
rd_init_invisible_window_tags
	lea	rd_invisible_window_tag_list(pc),a0
	move.l	#WA_Left,(a0)+
	moveq	#rd_invisible_window_left,d2
	move.l	d2,(a0)+
	move.l	#WA_Top,(a0)+
	moveq	#rd_invisible_window_top,d2
	move.l	d2,(a0)+
	move.l	#WA_Width,(a0)+
	moveq	#rd_invisible_window_x_size,d2
	move.l	d2,(a0)+
	move.l	#WA_Height,(a0)+
	moveq	#rd_invisible_window_y_size,d2
	move.l	d2,(a0)+
	move.l	#WA_DetailPen,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	#WA_BlockPen,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_IDCMP,(a0)+
	move.l	d0,(a0)+
	move.l	#WA_Title,(a0)+
	lea	rd_invisible_window_name(pc),a1
	move.l	a1,(a0)+
	move.l	#WA_CustomScreen,(a0)+
	move.l	d0,(a0)+		; Zeiger wird später initialisiert
	move.l	#WA_MinWidth,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_MinHeight,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_MaxWidth,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_MaxHeight,(a0)+
	move.l	d2,(a0)+
	move.l	#WA_AutoAdjust,(a0)+
	moveq	#FALSE,d2
	move.l	d2,(a0)+
	move.l	#WA_Flags,(a0)+
	move.l	#WFLG_BACKDROP|WFLG_BORDERLESS|WFLG_ACTIVATE,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


	CNOP 0,4
rd_init_video_control_tags
	lea	rd_video_control_tag_list(pc),a0
	moveq	#TAG_DONE,d2
	move.l	d2,vctl_TAG_DONE(a0)
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
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


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
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


; Input
; Result
; d0.l	Rückgabewert: Return-Code
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


; Input
; Result
; d0.l	Rückgabewert: Return-Code
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
	bne.s	adl_check_aga_chipset
	lea	adl_error_text3(pc),a0
	move.l	#adl_error_text3_end-adl_error_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_aga_chipset
	move.l	_GfxBase(pc),a1
	move.b	gb_ChipRevBits0(a1),d0
	btst	#GFXB_AA_ALICE,d0
	bne.s   adl_check_lisa
	lea	adl_error_text4(pc),a0
	move.l	#adl_error_text4_end-adl_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_lisa
	btst	#GFXB_AA_LISA,d0
	bne.s	adl_check_pal
	lea	adl_error_text4(pc),a0
	move.l	#adl_error_text4_end-adl_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_pal
	btst	#REALLY_PALn,gb_DisplayFlags+1(a1)
	bne.s	adl_check_system_ok
	lea	adl_error_text5(pc),a0
	move.l	#adl_error_text5_end-adl_error_text5,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_system_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
adl_open_gadtools_library
	lea	gadtools_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0
	CALLEXEC OpenLibrary
	lea	_GadToolsBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_gadtools_library_ok
	lea	adl_error_text6(pc),a0
	moveq	#adl_error_text6_end-adl_error_text6,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_open_gadtools_library_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
adl_open_intuition_library
	lea	intuition_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0
	CALLEXEC OpenLibrary
	lea	_IntuitionBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_intuition_library_ok
	lea	adl_error_text7(pc),a0
	moveq	#adl_error_text7_end-adl_error_text7,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_open_intuition_library_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
adl_check_cool_capture
	move.l	_SysBase(pc),a0
	move.l	CoolCapture(a0),d0
	beq.s   adl_set_default_values
	move.l	d0,a0
	cmp.w	#"DL",2(a0)
	beq.s	adl_update_variables
	move.l	a3,-(a7)
	sub.l	a0,a0			; Requester erscheint auf Workbench
	lea	adl_cool_capture_request(pc),a1
	move.l	a0,a2			; Keine IDCMP-Flags
	move.l	a0,a3			; Keine Argumentenliste
	CALLINT EasyRequestArgs
	move.l	(a7)+,a3
	tst.l	d0			; Gadget "Proceed" ?
	bne.s	adl_set_default_values	; Ja -> verzweige
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_update_variables
	GET_RESIDENT_ENTRIES_NUMBER_MAX
	move.l	d0,a0
	move.w	(a0),adl_entries_number_max(a3)
	GET_RESIDENT_ENTRIES_NUMBER
	move.l	d0,a0
	move.w	(a0),adl_entries_number(a3)
	GET_RESIDENT_ENTRIES_BUFFER
	move.l	d0,adl_entries_buffer(a3)
	GET_RESIDENT_ENTRY_OFFSET
	move.l	d0,a0
	move.w	(a0),rd_entry_offset(a3)
	clr.w   adl_reset_program_active(a3)
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
adl_set_default_values
	moveq	#dc_entries_number_default_max,d2
	move.w	d2,adl_entries_number_max(a3)
	lea	rp_entries_number_max(pc),a0
	move.w	d2,(a0)
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
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
adl_check_cmd_line_fail
	bsr.s	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
adl_check_cmd_line_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
adl_print_cmd_usage
	lea	adl_cmd_usage_text(pc),a0
	move.l	#adl_cmd_usage_text_end-adl_cmd_usage_text,d0
	bra	adl_print_text


; ** ADL-Argument HELP ***
	CNOP 0,4
adl_check_arg_help
	move.l	cra_HELP(a2),d0
	beq.s	adl_check_arg_remove
	not.w	d0
	move.w	d0,adl_arg_help_enabled(a3)
	bsr.s	adl_print_cmd_usage
	bra.s	adl_check_cmd_line_ok

; ** ADL-Argument REMOVE **
	CNOP 0,4
adl_check_arg_remove
	move.l	cra_REMOVE(a2),d0
	beq.s	adl_check_arg_maxentries
	not.w	d0
	move.w	d0,adl_arg_remove_enabled(a3)
	bra.s	adl_check_cmd_line_ok


; ** Demo-Charger Argument MAXENTRIES **
	CNOP 0,4
adl_check_arg_maxentries
	move.l	cra_MAXENTRIES(a2),d0
	beq.s	adl_check_arg_newentry
	tst.w	adl_reset_program_active(a3)
	beq.s	adl_check_arg_newentry
	move.l	d0,a0
	move.l	(a0),d0			;  Anzahl
	cmp.w	#dc_entries_number_max,d0
	ble.s   adl_update_entries_number_max
	bra.s	adl_check_cmd_line_fail
	CNOP 0,4
adl_update_entries_number_max
	move.w	d0,adl_entries_number_max(a3)
	lea	rp_entries_number_max(pc),a0
	move.w	d0,(a0)

; ** Demo-Charger Argument NEWENTRY **
adl_check_arg_newentry
	move.l	cra_NEWENTRY(a2),d0
	beq.s	adl_check_arg_playlist
        not.w	d0
	move.w	d0,dc_arg_newentry_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Demo-Charger Argument PLAYLIST **
	CNOP 0,4
adl_check_arg_playlist
	move.l	cra_PLAYLIST(a2),dc_playlist_file_name(a3)
	beq.s	adl_check_arg_showqueue
	clr.w	dc_arg_playlist_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Queue-Handler Argument SHOWQUEUE **
	CNOP 0,4
adl_check_arg_showqueue
	move.l	cra_SHOWQUEUE(a2),d0
	beq.s	adl_check_arg_editentry
	not.w	d0
	move.w	d0,qh_arg_showqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Queue-Handler Argument EDITENTRY **
	CNOP 0,4
adl_check_arg_editentry
	move.l	cra_EDITENTRY(a2),d0
	beq.s	adl_check_arg_editqueue
	move.l	d0,a0
	move.l	(a0),d0		; Entry-Nummer
	cmp.w	#adl_entries_number_min,d0
	bge.s	arg_check_arg_editentry_max
	bra	adl_check_cmd_line_fail
	CNOP 0,4
arg_check_arg_editentry_max
	cmp.w	adl_entries_number(a3),d0
	ble.s   adl_check_arg_editentry_set
	bra	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_editentry_set
	move.w	d0,qh_edit_entry_offset(a3)
	clr.w	qh_arg_editentry_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Queue-Handler Argument EDITQUEUE **
	CNOP 0,4
adl_check_arg_editqueue
	move.l	cra_EDITQUEUE(a2),d0
	beq.s	adl_check_arg_clearqueue
	not.w	d0
	move.w	d0,qh_arg_editqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Queue-Handler Argument CLEARQUEUE **
	CNOP 0,4
adl_check_arg_clearqueue
	move.l	cra_CLEARQUEUE(a2),d0
	beq.s	adl_check_arg_resetqueue
	not.w	d0
	move.w	d0,qh_arg_clearqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Queue-Handler Argument RESETQUEUE **
	CNOP 0,4
adl_check_arg_resetqueue
	move.l	cra_RESETQUEUE(a2),d0
	beq.s	adl_check_playentry
	not.w	d0
	move.w	d0,qh_arg_resetqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; ** Run-Demo Argument PLAYENTRY **
	CNOP 0,4
adl_check_playentry
	move.l	cra_PLAYENTRY(a2),d0
	beq.s	adl_check_arg_prerunscript
	move.l	d0,a0
	move.l	(a0),d0		; Entry-Nummer
	cmp.w	#adl_entries_number_min,d0
	bge.s	arg_check_arg_playentry_max
	bra	adl_check_cmd_line_fail
	CNOP 0,4
arg_check_arg_playentry_max
	cmp.w	adl_entries_number(a3),d0
	ble.s   adl_check_arg_playentry_set
	bra	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_playentry_set
	move.w	d0,rd_entry_offset(a3)
	bra	adl_check_cmd_line_ok

; ** Run-Demo Argument PRERUNSCRIPT **
	CNOP 0,4
adl_check_arg_prerunscript
	move.l	cra_PRERUNSCRIPT(a2),rd_prerunscript_path(a3)
	beq.s	adl_check_arg_secs
	clr.w	rd_arg_prerunscript_enabled(a3)

; ** Run-Demo Argument SECS **
adl_check_arg_secs
	move.l	cra_SECS(a2),d0
	beq.s	adl_check_arg_mins
	move.l	d0,a0
	move.l	(a0),d0			; Sekundenwert
	moveq	#adl_seconds_max,d2
	cmp.l	d2,d0
	ble.s   adl_check_arg_mins
	bra	adl_check_cmd_line_fail

; ** Run-Demo Argument MINS **
	CNOP 0,4
adl_check_arg_mins
	move.l	cra_MINS(a2),d1
	beq.s	adl_calculate_playtime
	move.l	d1,a0
	move.l	(a0),d1			; Minutenwert
	moveq	#adl_minutes_max,d2
	cmp.l	d2,d1
	ble.s   adl_calculate_playtime
	bra	adl_check_cmd_line_fail

	CNOP 0,4
adl_calculate_playtime
	MULUF.L 60,d1,d2		; Umrechnung Minuten in Sekunden
	add.l	d0,d1			; Gesamtwert Sekunden
	MULUF.L 10,d1,d0		; Linksshift
	move.w	d1,rd_play_duration(a3)

	IFEQ adl_lmbexit_code_enabled
; ** Run-Demo Argument LMBEXIT **
		move.l	cra_LMBEXIT(a2),d0
		beq.s   adl_check_arg_random
		tst.w	rd_play_duration(a3)
		bne.s   adl_check_arg_lmbexit_skip
		bra	adl_check_cmd_line_fail
		CNOP 0,4
adl_check_arg_lmbexit_skip
		move.l	d0,a0		; Zeiger auf String
		move.l	(a0),d0		; Anzahl der Demoteile
		cmp.w	#adl_lmbexit_parts_number_min,d0
		bge.s   adl_check_demo_parts_number_max
		bra	adl_check_cmd_line_fail
		CNOP 0,4
adl_check_demo_parts_number_max
		cmp.w	#adl_lmbexit_parts_number_max,d0
		ble.s   adl_arg_lmbexit_set_play_duration
		bra	adl_check_cmd_line_fail
		CNOP 0,4
adl_arg_lmbexit_set_play_duration
		subq.w	#1,d0		; Wert anpassen, da intern 1..9 übergeben wird
		add.w	d0,rd_play_duration(a3)
	ENDC

; ** Run-Demo Argument RANDOM **
adl_check_arg_random
	move.l	cra_RANDOM(a2),d0
	not.w	d0
	move.w	d0,rd_arg_random_enabled(a3)

; ** Run-Demo Argument ENDLESS **
	move.l	cra_ENDLESS(a2),d0
	not.w	d0
	move.w	d0,rd_arg_endless_enabled(a3)
	tst.w	adl_reset_program_active(a3)
	bne.s	adl_update_endless_enabled
	move.l	d0,d2
	GET_RESIDENT_ENDLESS_ENABLED
	move.l	d0,a0
	move.w	d2,(a0)
	bra.s	adl_check_arg_loop
	CNOP 0,4
adl_update_endless_enabled
	lea	rp_endless_enabled(pc),a0
	move.w	d0,(a0)

; ** Run-Demo Argument LOOP **
adl_check_arg_loop
	move.l	cra_LOOP(a2),d0
	not.w	d0
	move.w	d0,rd_arg_loop_enabled(a3)

; ** Run-Demo Argument FADER **
	move.l	cra_FADER(a2),d0
	not.w	d0
	move.w	d0,rd_arg_fader_enabled(a3)

; ** Run-Demo Argument SOFTRESET **
	move.l	cra_SOFTRESET(a2),d0
	beq.s	adl_check_arg_softreset_skip
	tst.w	rd_arg_loop_enabled(a3)
	beq.s	adl_check_arg_softreset_skip
	not.w	d0
	move.w	d0,rd_arg_softreset_enabled(a3)
adl_check_arg_softreset_skip
	bra	adl_check_cmd_line_ok


	CNOP 0,4
adl_print_intro_message_text
	tst.w	adl_reset_program_active(a3)
	bne.s	adl_check_arg_playlist_enabled
	rts
	CNOP 0,4
adl_check_arg_playlist_enabled
	tst.w	dc_arg_playlist_enabled(a3)
	bne.s   adl_print_intro_message_text_skip
	rts
	CNOP 0,4
adl_print_intro_message_text_skip
	lea	adl_intro_message_text(pc),a0
	move.l	#adl_intro_message_text_end-adl_intro_message_text,d0
	bra	adl_print_text


; **** Demo-Charger ****
; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
dc_alloc_entries_buffer
	tst.w	adl_reset_program_active(a3)
	beq.s	dc_alloc_entries_buffer_ok
	moveq	#0,d0
	move.w	adl_entries_number_max(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Größe des Puffers berechnen
	MOVEF.L MEMF_CLEAR|MEMF_PUBLIC|MEMF_ANY,d1
	CALLEXEC AllocMem
	move.l	d0,adl_entries_buffer(a3)
	bne.s	dc_alloc_entries_buffer_ok
	lea	dc_error_text1(pc),a0
	moveq	#dc_error_text1_end-dc_error_text1,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
dc_alloc_entries_buffer_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_open_asl_library
	lea	asl_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0
	CALLEXEC OpenLibrary
	lea	_ASLBase(pc),a0
	move.l	d0,(a0)
	bne.s	dc_open_asl_library_ok
	lea	dc_error_text10(pc),a0
	moveq	#dc_error_text10_end-dc_error_text10,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_open_asl_library_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
dc_get_program_dir
	CALLDOS GetProgramDir
	tst.l	d0
	bne.s	dc_get_program_dir_name
	lea	dc_error_text11(pc),a0
	moveq	#dc_error_text11_end-dc_error_text11,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_get_program_dir_name
	move.l	d0,d1			; Verzeichnis-Lock
	lea	dc_current_dir_name(pc),a0
	move.l	a0,d2			; Zeiger auf Puffer für Verzeichnisname
	MOVEF.L	adl_demofile_path_length,d3
	CALLLIBS NameFromLock
	tst.l	d0
	bne.s	dc_get_program_dir_name_ok
	lea	dc_error_text12(pc),a0
	moveq	#dc_error_text12_end-dc_error_text12,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_DIR_NOT_FOUND,d0
	rts
	CNOP 0,4
dc_get_program_dir_name_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
dc_display_remaining_files
	lea	dc_remaining_files(pc),a0 ; Stringadresse
	move.w	adl_entries_number_max(a3),d1
	sub.w	adl_entries_number(a3),d1 ; Verbleibende Anzahl der zu ladenden Dateien berechnen
	cmp.w	#adl_entries_number_min,d1 ; Nur noch ein File?
	bne.s	dc_request_title_skip	; Nein -> verzweige
	clr.b	dc_character_s-dc_remaining_files(a0) ; "s" von Demo"s" löschen
dc_request_title_skip
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bra	rp_dec_to_ascii


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_make_file_request
	moveq	#ASL_FileRequest,d0
	lea	dc_file_request_init_tag_list(pc),a0
	CALLASL AllocAslRequest
	move.l	d0,dc_file_request(a3)
	bne.s	dc_make_file_request_ok
	lea	dc_error_text13(pc),a0
	moveq	#dc_error_text13_end-dc_error_text13,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_make_file_request_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_display_file_request
	move.l	dc_file_request(a3),a0
	lea	dc_file_request_display_tag_list(pc),a1
	CALLASL AslRequest
	tst.l   d0
	bne.s	dc_display_file_request_ok
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_display_file_request_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_get_demofile_path
	clr.w   dc_multiselect_entries_number(a3)
	move.l	dc_file_request(a3),a2
	move.l	fr_NumArgs(a2),d6
	move.w	d6,d0			; Anzahl der ausgewählten Dateien
	add.w   adl_entries_number(a3),d0
	cmp.w   adl_entries_number_max(a3),d0
	blt.s   dc_entries_number_skip
	move.w  adl_entries_number_max(a3),d6
	sub.w   adl_entries_number(a3),d6 ; noch verbleibende Einträge
dc_entries_number_skip
	move.w  d6,dc_multiselect_entries_number(a3)
	moveq	#0,d5			; Erster Eintrag in ArgLists
	move.l	fr_ArgList(a2),a6
	subq.w	#1,d6			; wegen dbf
dc_multiselect_loop
	move.l	wa_Name(a6,d5.w*8),a0	; Zeiger auf Dateiname
	move.l	fr_Drawer(a2),a1	; Zeiger auf Verzeichnisname
	move.l	a2,-(a7)
	bsr.s	dc_check_demofile_path
	move.l	(a7)+,a2
	tst.l	d0
	beq.s	dc_fwd_multiselect_entry
	rts
	CNOP 0,4
dc_fwd_multiselect_entry
	addq.w	#1,d5			; nächster Eintrag in ArgLists
	dbf	d6,dc_multiselect_loop
	moveq	#RETURN_OK,d0
	rts


; Input
; a0	... Zeiger auf Dateiname
; a1 	... Zeiger auf Verzeichnisname
; Result
; d0.l	... Rückgabewert: Return-Code/Error Code
	CNOP 0,4
dc_check_demofile_path
	tst.b	(a1)			; Verzeichnisname vorhanden ?
 	bne.s	dc_check_demofile_name	; Ja -> verzweige
	lea	dc_error_text14(pc),a0
	moveq	#dc_error_text14_end-dc_error_text14,d0
	bsr	adl_print_text
	MOVEF.L ERROR_DIR_NOT_FOUND,d0
	rts
	CNOP 0,4
dc_check_demofile_name
	tst.b	(a0)			; Dateiname vorhanden ?
	bne.s	dc_get_playback_entry_offset ; Ja -> verzweige
	lea	dc_error_text15(pc),a0
	moveq	#dc_error_text15_end-dc_error_text15,d0
	bsr	adl_print_text
	MOVEF.L ERROR_OBJECT_NOT_FOUND,d0
	rts
	CNOP 0,4
dc_get_playback_entry_offset
	moveq   #0,d0
	move.w	adl_entries_number(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a2
	add.l   d0,a2			; Zeiger auf Eintrag im Puffer
	move.l	a2,dc_current_entry(a3)
	move.l	a0,-(a7)
	move.l	a2,a0			; Zeiger auf Eintrag im Puffer
	bsr	dc_clear_playlist_entry
	move.l	(a7)+,a0		; Zeiger auf Dateiname
dc_check_demo_dir_name
	tst.b	(a1)			; Ende von Verzeichnisname (Nullbyte) ?
	beq.s	dc_copy_demofile_name_loop ; Ja -> verzweige
	cmp.b	#"/",(a1)
	bne.s	dc_copy_demo_dir_name
	addq.w	#1,a1			; Nächstes Zeichen im Verzeichnisnamen
	bra.s	dc_check_demo_dir_name
	CNOP 0,4
dc_copy_demo_dir_name
	lea	dc_current_dir_name(pc),a4 ; Zeiger auf Puffer für aktuellen Verzeichnisnamen
	moveq	#0,d0			; Zähler für Länge des Dateipfads zurücksetzen
dc_copy_demo_dir_name_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	dc_copy_demo_dir_skip
	move.l	dc_current_entry(a3),a0
	bsr	dc_clear_playlist_entry
	lea	dc_error_text16(pc),a0
	moveq	#dc_error_text16_end-dc_error_text16,d0
	bsr	adl_print_text
	MOVEF.L ERROR_INVALID_COMPONENT_NAME,d0
	rts
	CNOP 0,4
dc_copy_demo_dir_skip
	move.b	(a1),(a2)+
	move.b	(a1)+,(a4)+
	tst.b	(a1)
	bne.s	dc_copy_demo_dir_name_loop ; Schleife, so lange bis Endes des Verzeichnisnamens erreicht ist
	clr.b	(a4)			; Nullbyte setzen
	cmp.b	#":",-1(a1)
	beq.s	dc_copy_demofile_name_loop
	cmp.b	#"/",-1(a1)
	beq.s	dc_copy_demofile_name_loop
	move.b	#"/",(a2)+
dc_copy_demofile_name_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	dc_copy_demofile_name_skip
	move.l	dc_current_entry(a3),a0
	bsr	dc_clear_playlist_entry
	lea	dc_error_text16(pc),a0
	moveq	#dc_error_text16_end-dc_error_text16,d0
	bsr	adl_print_text
	MOVEF.L ERROR_INVALID_COMPONENT_NAME,d0
	rts
	CNOP 0,4
dc_copy_demofile_name_skip
	move.b	(a0)+,(a2)+
	cmp.b	#":",(a0)
	bne.s	dc_check_demofile_nullbyte
	lea	dc_error_text17(pc),a0
	moveq	#dc_error_text17_end-dc_error_text17,d0
	bsr	adl_print_text
	MOVEF.L ERROR_OBJECT_NOT_FOUND,d0
	rts
	CNOP 0,4
dc_check_demofile_nullbyte
	tst.b	(a0)
	bne.s	dc_copy_demofile_name_loop ; Schleife bis Endes des Verzeichnisnamens erreicht
	clr.b	(a2)			; Nullbyte setzen
	addq.w	#1,adl_entries_number(a3)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
dc_free_file_request
	move.l	dc_file_request(a3),a0
	CALLASLQ FreeAslRequest


	CNOP 0,4
dc_display_runmode_request
	move.l	a3,-(a7)
	sub.l	a0,a0			; Requester erscheint auf Workbench
	lea	dc_runmode_request(pc),a1
	move.l	a0,a2			; Keine IDCMP-Flags
	move.l	a0,a3			; Keine Argumentenliste
	CALLINT EasyRequestArgs
	move.l	(a7)+,a3
	addq.b  #1,d0                   ; Ergebnis korrigieren
	MOVEF.L playback_queue_entry_size,d1 ; Größe des Eintrags
	move.l	dc_current_entry(a3),a0
	move.w	dc_multiselect_entries_number(a3),d7
	subq.w	#1,d7			;wegen dbf
dc_start_loop
	move.b	d0,pqe_runmode(a0)	; Kennung eintragen
	sub.l	d1,a0			; vorheriger Pfadname
	dbf	d7,dc_start_loop
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_check_entries_number_max
	move.w  adl_entries_number(a3),d0
	cmp.w   adl_entries_number_max(a3),d0
	bne.s	dc_check_entries_number_max_ok
	bsr.s	dc_print_entries_max_message_text
	moveq   #RETURN_WARN,d0
	rts
	CNOP 0,4
dc_check_entries_number_max_ok
	moveq   #RETURN_OK,d0
	rts


	CNOP 0,4
dc_print_entries_max_message_text
	lea     dc_message_text(pc),a0
	moveq   #dc_message_text_end-dc_message_text,d0
	bra     adl_print_text


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
dc_init_reset_program
	tst.w	adl_entries_number(a3)
	bne.s	dc_check_reset_program_active
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
dc_check_reset_program_active
	tst.w	adl_reset_program_active(a3)
	beq	dc_update_entries_number
	lea	rp_entry_offset(pc),a0
	move.w	rd_entry_offset(a3),(a0)
	move.l	#rp_entries_buffer-rp_start,d0 ; Programmgröße
	move.w	d0,d7		
	moveq	#0,d1
	move.w	adl_entries_number_max(a3),d1
	MULUF.L playback_queue_entry_size,d1,d2 ; Größe des Puffers berechnen
	add.l	d1,d0			; Gesamtlänge inkusive Puffergröße
	lea	rp_reset_program_size(pc),a0
	move.l	d0,(a0)
	MOVEF.L	MEMF_PUBLIC+MEMF_CHIP+MEMF_CLEAR+MEMF_REVERSE,d1
	CALLEXEC AllocMem
	lea	rp_reset_program_memory(pc),a0
	move.l	d0,(a0)
	bne.s	dc_copy_reset_program
	lea	dc_error_text18(pc),a0
	moveq	#dc_error_text18_end-dc_error_text18,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
dc_copy_reset_program
	lea	rp_start(pc),a0		; Quelle
	move.l	d0,a1			; Ziel: Speicherbereich
	move.l	d0,a2			; Reset-Programm im Speicher
	move.l	d0,CoolCapture(a6)
	subq.w	#1,d7			; wegen dbf
dc_copy_reset_program_loop
	move.b	(a0)+,(a1)+
	dbf	d7,dc_copy_reset_program_loop
	move.l	adl_entries_buffer(a3),a0 ; Quelle
	move.w	adl_entries_number_max(a3),d7
	MULUF.W playback_queue_entry_size,d7,d0 ; Puffergröße zum Kopieren berechnen
	subq.w	#1,d7			; wegen dbf
dc_copy_entries_buffer_loop
	move.b	(a0)+,(a1)+
	dbf	d7,dc_copy_entries_buffer_loop
	bsr	rp_update_exec_checksum
	CALLLIBS CacheClearU
	jsr	rp_init_custom_exceptions-rp_start(a2) ; Zeiger auf eigene Exception/Trap-Routinen initialisieren
	lea	rp_read_VBR(pc),a5
	CALLLIBS Supervisor
	tst.l	d0			; VBR = $000000 ?
	beq.s	dc_update_entries_number ; Ja -> verzweige
	GET_CUSTOM_TRAP_VECTORS
	move.l	d0,a0 			; Quelle
	move.w	#TRAP_0_VECTOR,a1	; Ziel: Ab Trap0-Vektor im chip memory
	IFEQ adl_restore_adl_code_enabled
  		moveq	#8-1,d7		; Anzahl der Trap-Vektoren
	ELSE
		moveq	#7-1,d7		; Anzahl der Trap-Vektoren
	ENDC
dc_copy_custom_trap_vectors_loop
	move.l	(a0)+,(a1)+
	dbf	d7,dc_copy_custom_trap_vectors_loop
	CALLLIBS CacheClearU
dc_update_entries_number
	GET_RESIDENT_ENTRIES_NUMBER
	move.l	d0,a0
	move.w	adl_entries_number(a3),(a0)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
dc_close_asl_library
	move.l	_ASLBase(pc),a1
	CALLEXECQ CloseLibrary


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_lock_playlist_file
	move.l	dc_playlist_file_name(a3),d1
	MOVEF.L ACCESS_READ,d2
	CALLDOS Lock		
	move.l	d0,dc_playlist_file_lock(a3)
	bne.s	dc_lock_playlist_file_ok
	lea	dc_error_text2(pc),a0
	moveq	#dc_error_text2_end-dc_error_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
 	CNOP 0,4
dc_lock_playlist_file_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
dc_alloc_playlist_file_fib
	MOVEF.L fib_SIZEOF,d0
	MOVEF.L	MEMF_CLEAR|MEMF_PUBLIC|MEMF_ANY,d1
	CALLEXEC AllocMem
	move.l	d0,dc_playlist_file_fib(a3)
	bne.s	dc_alloc_playlist_file_fib_ok
	lea	dc_error_text3(pc),a0
	moveq	#dc_error_text3_end-dc_error_text3,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
dc_alloc_playlist_file_fib_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_get_playlist_file_length
	move.l	dc_playlist_file_lock(a3),d1
	move.l	dc_playlist_file_fib(a3),d2
	move.l	d2,a2
	CALLDOS Examine
	tst.l	d0		
	bne.s	dc_get_playlist_file_length_ok
	lea	dc_error_text4(pc),a0
	moveq	#dc_error_text4_end-dc_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_get_playlist_file_length_ok
	move.l	fib_Size(a2),dc_playlist_file_length(a3) ; Länge der Playlist in Bytes
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
dc_alloc_playlist_file_buffer
	move.l	dc_playlist_file_length(a3),d0
	MOVEF.L	MEMF_CLEAR|MEMF_PUBLIC|MEMF_ANY,d1
	CALLEXEC AllocMem
	move.l	d0,dc_playlist_file_buffer(a3)
	bne.s	dc_alloc_playlist_file_buffer_ok
	lea	dc_error_text5(pc),a0
	moveq	#dc_error_text5_end-dc_error_text5,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
dc_alloc_playlist_file_buffer_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_open_playlist_file
	move.l	dc_playlist_file_name(a3),d1
	MOVEF.L	MODE_OLDFILE,d2
	CALLDOS Open
	move.l	d0,dc_playlist_file_handle(a3)
	bne.s	dc_open_playlist_file_ok
	lea	dc_error_text6(pc),a0
	moveq	#dc_error_text6_end-dc_error_text6,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_open_playlist_file_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_read_playlist_file
	move.l	dc_playlist_file_handle(a3),d1
	move.l	dc_playlist_file_length(a3),d3
	move.l	dc_playlist_file_buffer(a3),d2
	CALLDOS Read
	tst.l	d0
	bne.s	dc_read_playlist_file_ok
	lea	dc_error_text7(pc),a0
	moveq	#dc_error_text7_end-dc_error_text7,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_read_playlist_file_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_parse_playlist_file
	lea	dc_parsing_begin_text(pc),a0
	moveq	#dc_parsing_begin_text_end-dc_parsing_begin_text,d0
	bsr	adl_print_text
        moveq   #0,d0
	move.w	adl_entries_number(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l   d0,a0			; Zeiger auf Eintrag im Puffer
	move.l	a0,d6
	move.l	dc_playlist_file_buffer(a3),a2
	move.l	dc_playlist_file_length(a3),d7
dc_parse_playlist_file_loop1
	subq.w	#1,d7			; Wegen dbf
	bpl.s	dc_parse_playlist_file_proceed
	bsr	dc_parse_playlist_file_result
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
dc_parse_playlist_file_proceed
	addq.w	#1,dc_playlist_entries_number(a3)
	MOVEF.L	DOS_RDARGS,d1		; ReadArgs-Struktur erzeugen
	moveq	#0,d2			; Keine Tags
	CALLDOS AllocDosObject
	tst.l	d0
	bne.s	dc_parse_playlist_file_skip
	lea	dc_error_text8(pc),a0
	moveq	#dc_error_text8_end-dc_error_text8,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_parse_playlist_file_skip
	moveq	#0,d4			; Zähler für Länge einer Befehlszeile zurücksetzen
	move.l	d0,a4			; Zeiger auf RDArgs-Struktur
	move.l	a2,CS_Buffer(a4)	; Zeiger auf Playlist-File-Puffer eintragen
dc_parse_playlist_file_loop2
	addq.w	#1,d4
	cmp.b	#ASCII_LINE_FEED,(a2)+
	beq.s	dc_parse_playlist_entry
	dbf	d7,dc_parse_playlist_file_loop2
	bsr	dc_parse_playlist_file_result
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
dc_parse_playlist_entry
	move.l	d4,CS_Length(a4)
	lea	dc_playlist_results_array(pc),a5
	moveq	#0,d0
	move.l	d0,pra_demofile(a5)	; Alle Ergebnis-Felder der Argumente löschen
	move.l	d0,pra_OCSVANILLA(a5)
	move.l	d0,pra_AGAVANILLA(a5)
	move.l	d0,pra_TURBO(a5)
	move.l	d0,pra_SECS(a5)
	move.l	d0,pra_MINS(a5)
	IFEQ adl_lmbexit_code_enabled
		move.l	d0,pra_LMBEXIT(a5)
        ENDC
	move.l	d0,pra_PRERUNSCRIPT(a5)
	lea	dc_playlist_template(pc),a0
	move.l	a0,d1			; Zeiger auf Befelsschablone für Playlist-Argumente
	move.l	a5,d2			; Zeiger auf Ergebnis-Felder für Playlist-Argumente
	move.l	a4,d3			; Eigene RDArgs-Struktur
	CALLDOS ReadArgs
	tst.l	d0
	bne.s	dc_parse_playlist_entry_skip
	bsr	dc_parse_entry_syntax_error
	bra	dc_free_DosObject
	CNOP 0,4
dc_parse_playlist_entry_skip
	move.l	d6,a0			; Zeiger auf Eintrag im Puffer
	bsr	dc_clear_playlist_entry

; ** Playlist-Argument demofile **
	move.l	pra_demofile(a5),d0
	bne.s	dc_copy_demofile_path
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments
	CNOP 0,4
dc_copy_demofile_path
	move.l	d0,a0			; Zeiger auf Dateiname des Demos
	move.l	d6,a1			; Zeiger auf Eintrag im Puffer
	moveq	#0,d0			; Zähler für Länge des Dateipfads
dc_copy_demofile_path_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	dc_copy_demofile_path_skip
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments
	CNOP 0,4
dc_copy_demofile_path_skip
	move.b	(a0)+,(a1)+
	bne.s	dc_copy_demofile_path_loop ; Schleife, bis Nullbyte gefunden wurde

	move.l	d6,a1			; Zeiger auf Eintrag im Puffer
	clr.b	pqe_runmode(a1)
; ** Playlist-Argument OCSVANILLA **
	tst.l	pra_OCSVANILLA(a5)
	beq.s	dc_check_arg_AGAVANILLA
	move.b	#RUNMODE_OCS_VANILLA,pqe_runmode(a1)
	bra.s	dc_check_entry_start_mode

; ** Playlist-Argument AGAVANILLA **
	CNOP 0,4
dc_check_arg_agavanilla
	tst.l	pra_AGAVANILLA(a5)
	beq.s	dc_check_arg_turbo
	move.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a1)
	bra.s	dc_check_entry_start_mode

; ** Playlist-Argument TURBO **
	CNOP 0,4
dc_check_arg_turbo
	tst.l	pra_TURBO(a5)
	beq.s	dc_check_entry_start_mode
	move.b	#RUNMODE_TURBO,pqe_runmode(a1)

dc_check_entry_start_mode
	tst.b	pqe_runmode(a1)
	bne.s   dc_check_arg_secs
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

; ** Playlist-Argument SECS **
	CNOP 0,4
dc_check_arg_secs
	move.l	pra_SECS(a5),d0
	beq.s	dc_check_arg_mins
	move.l	d0,a0
	move.l	(a0),d0			; Sekundenwert
	moveq	#adl_seconds_max,d2
	cmp.l	d2,d0
	ble.s   dc_check_arg_mins
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

; ** Playlist-Argument MINS **
	CNOP 0,4
dc_check_arg_mins
	move.l	pra_MINS(a5),d1
	beq.s	dc_calculate_playtime
	move.l	d1,a0
	move.l	(a0),d1			; Minutenwert
	moveq	#adl_minutes_max,d2
	cmp.l	d2,d1
	ble.s	dc_calculate_playtime
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

	CNOP 0,4
dc_calculate_playtime
	MULUF.L 60,d1,d2		; Sekundenwert
	add.l	d0,d1			; + Sekundenwert = Gesamtwert Sekunden
	MULUF.L 10,d1,d0		; Zählerwert in 100 ms
	move.w	d1,pqe_playtime(a1)

	IFEQ adl_lmbexit_code_enabled
; ** Playlist-Argument LMBEXIT **
;		CNOP 0,4
;dc_check_arg_lmbexit
		move.l	pra_LMBEXIT(a5),d0
		beq.s	dc_check_arg_prerunscript
		move.l	d0,a0
		move.l	(a0),d0		; Anzahl der Demoteile
		bne.s	dc_check_demo_parts_number_min
		bsr	dc_parse_playlist_entry_error
		bra	dc_free_custom_arguments
		CNOP 0,4
dc_check_demo_parts_number_min
		cmp.w	#adl_lmbexit_parts_number_min,d0
		bge.s	dc_check_demo_parts_number_max
		bsr	dc_parse_playlist_entry_error
		bra	dc_free_custom_arguments
		CNOP 0,4
dc_check_demo_parts_number_max
		cmp.w	#adl_lmbexit_parts_number_max,d0
		ble.s	dc_arg_lmbexit_save_playtime
		bsr	dc_parse_playlist_entry_error
		bra.s	dc_free_custom_arguments
		CNOP 0,4
dc_arg_lmbexit_save_playtime
		subq.w	#1,d0		; Wert anpassen, da intern 1..9 übergeben wird
		add.w	d0,pqe_playtime(a1)
	ENDC

; ** Playlist-Argument PRERUNSCRIPT **
dc_check_arg_prerunscript
	move.l	pra_PRERUNSCRIPT(a5),d0
	beq.s	dc_fwd_transmitted_entry
	move.l	d0,a0			; Zeiger auf Dateiname des Scriptfiles
	move.l	d6,a1			; Zeiger auf Eintrag im Puffer
	ADDF.W	pqe_prerunscript_path,a1 ; Zeiger auf Prerunscript-Pfad in Puffer
	moveq	#0,d0			; Zähler für Länges des Dateipfads
dc_copy_prerunscript_path_loop
	addq.b	#1,d0
	cmp.b	#adl_prerunscript_path_length-1,d0
	blt.s	dc_copy_prerunscript_skip
	bsr	dc_parse_playlist_entry_error
	bra.s	dc_free_custom_arguments
	CNOP 0,4
dc_copy_prerunscript_skip
	move.b	(a0)+,(a1)+
	bne.s	dc_copy_prerunscript_path_loop ; Schleife, bis Nullbyte gefunden wurd
dc_fwd_transmitted_entry
	addq.w	#1,dc_transmitted_entries_number(a3)
	addq.w	#1,adl_entries_number(a3)
	move.w	adl_entries_number_max(a3),d0
	cmp.w	adl_entries_number(a3),d0
	bne.s	dc_fwd_playlist_cmd_line
	bsr.s	dc_parse_playlist_file_result
	bra	dc_print_entries_max_message_text
	CNOP 0,4
dc_fwd_playlist_cmd_line
	add.l	#playback_queue_entry_size,d6 ; nächster Eintrag
dc_free_custom_arguments
	move.l	a4,d1			; Zeiger auf RDArgs-Struktur
	CALLDOS FreeArgs
dc_free_DosObject
	moveq	#DOS_RDARGS,d1		; ReadArgs-Struktur freigeben
	move.l	a4,d2			; Zeiger auf ReadArgs-Struktur
	CALLLIBS FreeDosObject
	bra	dc_parse_playlist_file_loop1


	CNOP 0,4
dc_parse_playlist_file_result
	move.w	dc_transmitted_entries_number(a3),d1 ; Dezimalzahl
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	dc_transmitted_entries(pc),a0 ; Zeiger auf String
	bsr	rp_dec_to_ascii
	move.w	dc_playlist_entries_number(a3),d1 ; Dezimalzahl
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	lea	dc_playlist_entries(pc),a0 ; Zeiger auf String
	bsr	rp_dec_to_ascii
	lea	dc_parsing_result_text(pc),a0
	move.l	#dc_parsing_result_text_end-dc_parsing_result_text,d0
	bsr	adl_print_text
	bra	qh_show_queue


; Input
; d6.l	... Zeiger auf Eintrag im Puffer
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
dc_parse_playlist_entry_error
	move.l	d6,a0			; Zeiger auf Eintrag im Puffer
	bsr.s	dc_clear_playlist_entry
	bra.s 	dc_parse_entry_syntax_error


; Input
; a0	... Zeiger auf den Eintrag zum Löschen
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
dc_clear_playlist_entry
	moveq	#0,d0
	MOVEF.W	playback_queue_entry_size-1,d3 ; Länge des Eintrags
dc_clear_playlist_entry_loop
	move.b	d0,(a0)+
	dbf	d3,dc_clear_playlist_entry_loop
	rts


	CNOP 0,4
dc_parse_entry_syntax_error
	move.w	dc_playlist_entries_number(a3),d1 ; Dezimalzahl
	move.w	d7,d4			; Schleifenzähler retten
	lea	dc_entries_string(pc),a0 ; Zeiger auf String
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	move.w	d4,d7			; Schleifenzähler wieder herstellen
	lea	dc_error_text9(pc),a0
	moveq	#dc_error_text9_end-dc_error_text9,d0
	bra	adl_print_text


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
dc_check_entries_number_min
	tst.w	adl_entries_number(a3)
	bne.s   dc_check_entries_number_min_ok
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
dc_check_entries_number_min_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
dc_close_playlist_file
	move.l	dc_playlist_file_handle(a3),d1
	CALLDOSQ Close


	CNOP 0,4
dc_free_playlist_file_buffer
	move.l	dc_playlist_file_buffer(a3),a1
	move.l	dc_playlist_file_length(a3),d0
	CALLEXECQ FreeMem


	CNOP 0,4
dc_free_playlist_file_fib
	move.l	dc_playlist_file_fib(a3),a1
	MOVEF.L	fib_SIZEOF,d0
	CALLEXECQ FreeMem


	CNOP 0,4
dc_unlock_playlist_file
	move.l dc_playlist_file_lock(a3),d1
	CALLDOSQ UnLock


	CNOP 0,4
dc_free_entries_buffer
	tst.w	adl_reset_program_active(a3)
	bne.s	dc_do_free_entries_buffer
	rts
	CNOP 0,4
dc_do_free_entries_buffer
	move.l	adl_entries_buffer(a3),a1
	moveq	#0,d0
	move.w	adl_entries_number_max(a3),d0
	MULUF.L playback_queue_entry_size,d0,d1 ; Größe des Puffers berechnen
	CALLEXECQ FreeMem



; **** Queue-Handler ****
	CNOP 0,4
qh_show_queue
	move.l	adl_entries_buffer(a3),a2
	tst.b	(a2)
	bne.s	qh_show_queue_ok
        lea	qh_message_text1(pc),a0
	moveq	#qh_message_text1_end-qh_message_text1,d0
	bra	adl_print_text
	CNOP 0,4
qh_show_queue_ok
	moveq	#1,d5			; Laufende Nummer für Einträge
	move.w	adl_entries_number(a3),d7
	subq.w	#1,d7			; wegen dbf
qh_show_queue_loop
	lea	qh_show_entry_header(pc),a0
	moveq	#qh_show_entry_current_number-qh_show_entry_header,d0
	bsr	adl_print_text
	move.w	d5,d1			; Wert zum Umwandeln
	lea	qh_show_entry_current_number(pc),a0 ; Zeiger auf ASCII-Wert
	move.w	d7,-(a7)
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	move.w	(a7)+,d7
	lea	qh_show_entry_current_number(pc),a0
	moveq	#qh_show_entry_current_number_end-qh_show_entry_current_number,d0
	bsr	adl_print_text
	bsr.s   qh_get_entry_filename
	ADDF.W	playback_queue_entry_size,a2 ; nächster Eintrag in Playback Queue
	addq.w	#1,d5			; laufende Nummer erhöhen
	dbf	d7,qh_show_queue_loop
	lea	qh_not_used_entries_string(pc),a0
	move.w	adl_entries_number_max(a3),d1
	sub.w	adl_entries_number(a3),d1 ; Verbleibende Anzahl der zu ladenden Dateien berechnen
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	lea	qh_message_text2(pc),a0
	moveq	#qh_message_text2_end-qh_message_text2,d0
	bra	adl_print_text


; Input
; a2 ... Zeiger auf Eintrag in Playback-Queue
; Result
; d0 ... kein Rückgabewert
	CNOP 0,4
qh_get_entry_filename
	moveq	#0,d0			; Zähler für Demo-Dateinamen-Länge
	moveq	#"/",d2
	moveq	#":",d3
	moveq	#adl_demofile_path_length-1,d6
	move.l	a2,a0
	add.l	d6,a0			; Zeiger auf letztes Zeichen (Nullbyte)
qh_get_entry_filename_loop
	tst.b	(a0)
	beq.s	qh_get_entry_filename_skip1
	addq.w	#1,d0
qh_get_entry_filename_skip1
	cmp.b	(a0),d2			; "/" gefunden ?
	beq.s	qh_get_entry_filename_skip2 ; Ja -> verzweige
	cmp.b	(a0),d3			; ":" gefunden ?
	beq.s	qh_get_entry_filename_skip2 ; Ja -> verzweige
	subq.w	#1,a0			; vorgeriges Zeichen in Dateipfad
	dbf	d6,qh_get_entry_filename_loop
qh_get_entry_filename_skip2
	subq.w	#1,d0			; "/" oder ":" abziehen
	addq.w	#1,a0			; "/" oder ":" überspringen
	cmp.w	#qh_show_entry_space_end-qh_show_entry_space-1,d0 ; Länge des Dateinamens <= Füllzeile ?
	ble.s	qh_get_entry_filename_skip3 ; Ja -> verzweige
	moveq	#qh_show_entry_space_end-qh_show_entry_space-1,d0 ; Textlänge = Länge Füllzeile
qh_get_entry_filename_skip3
	move.w	d0,d4			; Länge des Dateinamens
	bsr	adl_print_text
	lea	qh_show_entry_space(pc),a0 ; Zeiger auf "...."-String
	moveq	#qh_show_entry_space_end-qh_show_entry_space-1,d0 ; Textlänge der Füllzeile
	sub.w	d4,d0			; Abzüglich Länge des Dateinamens
	bsr	adl_print_text

	tst.b	pqe_entry_active(a2)
	bne.s	qh_print_entry_active_text2
	lea	qh_entry_active_text1(pc),a0
	moveq	#qh_entry_active_text1_end-qh_entry_active_text1,d0
	bra	adl_print_text
	CNOP 0,4
qh_print_entry_active_text2
	lea	qh_entry_active_text2(pc),a0
	moveq	#qh_entry_active_text2_end-qh_entry_active_text2,d0
	bra	adl_print_text


	CNOP 0,4
qh_edit_single_entry
	bsr	qh_lock_workbench
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_entry_quit
	bsr	qh_get_screen_visual_info
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_entry_cleanup_wb_lock
	bsr	qh_create_context_gadget
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_entry_cleanup_wb_lock
	bsr	qh_create_gadgets
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_entry_cleanup_gadgets
	bsr	qh_open_edit_window
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_entry_cleanup_gadgets
	bsr	qh_process_window_events

	bsr	qh_close_edit_window
qh_edit_entry_cleanup_gadgets
	bsr	qh_free_gadgets
qh_edit_entry_cleanup_visual_info
	bsr	qh_free_screen_visual_info
qh_edit_entry_cleanup_wb_lock
	bsr	qh_unlock_workbench
qh_edit_entry_quit
	rts


	CNOP 0,4
qh_edit_queue
	move.l	adl_entries_buffer(a3),a0
	tst.b	(a0)
	bne.s	qh_init_gadgets_environment
        lea	qh_message_text1(pc),a0
	moveq	#qh_message_text1_end-qh_message_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	move.l	d0,adl_dos_return_code(a3)
	rts
	CNOP 0,4
qh_init_gadgets_environment
	bsr.s	qh_lock_workbench
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_queue_quit
	bsr.s	qh_get_screen_visual_info
	move.l	d0,adl_dos_return_code(a3)
	bne	qh_edit_queue_cleanup_wb_lock
	bsr	qh_create_context_gadget
	move.l	d0,adl_dos_return_code(a3)
	bne	qh_edit_queue_cleanup_wb_lock
	bsr	qh_create_gadgets
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_queue_cleanup_gadgets
	bsr	qh_open_edit_window
	move.l	d0,adl_dos_return_code(a3)
	bne.s	qh_edit_queue_cleanup_gadgets
	bsr	qh_process_window_events

	bsr	qh_close_edit_window
qh_edit_queue_cleanup_gadgets
	bsr	qh_free_gadgets
qh_edit_queue_cleanup_visual_info
	bsr	qh_free_screen_visual_info
qh_edit_queue_cleanup_wb_lock
	bsr	qh_unlock_workbench
qh_edit_queue_quit
	rts


; Input
; Result
; d0.l	... Return-Code
	CNOP 0,4
qh_lock_workbench
	lea	workbench_screen_name(pc),a0
	CALLINT LockPubScreen
	move.l	d0,qh_workbench_screen(a3)
	bne.s	qh_lock_workbench_ok
	lea	qh_error_text1(pc),a0
	moveq	#qh_error_text1_end-qh_error_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
qh_lock_workbench_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Return-Code
	CNOP 0,4
qh_get_screen_visual_info
	move.l	qh_workbench_screen(a3),a0
	lea	qh_get_visual_info_tag_list(pc),a1
	CALLGADTOOLS GetVisualInfoA
	move.l	d0,qh_screen_visual_info(a3)
	bne.s	qh_get_screen_visual_info_ok
	lea	qh_error_text2(pc),a0
	moveq	#qh_error_text2_end-qh_error_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
qh_get_screen_visual_info_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Return-Code
	CNOP 0,4
qh_create_context_gadget
	lea	qh_gadget_list(pc),a0
	CALLGADTOOLS CreateContext
	move.l	d0,qh_context_gadget(a3)
	bne.s	qh_create_context_gadget_ok
	lea	qh_error_text3(pc),a0
	moveq	#qh_error_text3_end-qh_error_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
qh_create_context_gadget_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Return-Code
	CNOP 0,4
qh_create_gadgets
	move.l	qh_workbench_screen(a3),a0
	add.b	sc_WBorTop(a0),d2
	move.l	sc_Font(a0),a0
	move.w	ta_YSize(a0),d2
	addq.w	#1,d2			; Höhe der Titelleiste des Fensters

; ** Text Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_text_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_text_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_text_gadget_x_size,gng_Width(a1)
	move.w	#qh_text_gadget_y_size,gng_Height(a1)
	moveq	#0,d0
	move.l  d0,gng_GadgetText(a1)
        move.w	d0,gng_GadgetID(a1)
	move.l	d0,gng_Flags(a1)
	move.l	qh_screen_visual_info(a3),gng_VisualInfo(a1)
	lea	qh_text_gadget_tag_list(pc),a2
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	subq.w	#1,d0			; Zählung ab 0
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
  	add.l	d0,a0
	move.l	a0,qh_edit_entry(a3)
	bsr	qh_get_demofile_title
	move.l	d0,qh_edit_entry_demofile_name(a3)
	move.l	d0,ti_data(a2)
	move.l	#TEXT_KIND,d0
	move.l	qh_context_gadget(a3),a0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4
	move.l	d0,qh_text_gadget_gadget(a3)

	tst.w	qh_arg_editentry_enabled(a3)
	beq	qh_create_cycle_gadget
; ** Backwards-Button Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_bwd_button_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_bwd_button_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_bwd_button_gadget_x_size,gng_Width(a1)
	move.w	#qh_bwd_button_gadget_y_size,gng_Height(a1)
	lea	qh_bwd_button_gadget_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_bwd_button_gadget_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.l	a4,a0
	lea	qh_button_gadget_tag_list(pc),a2
	moveq	#BOOL_TRUE,d0
  	move.l	d0,ti_data(a2)		; Gadget aktiv
	move.l	#BUTTON_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4
	move.l	d0,qh_bwd_button_gadget_gadget(a3)

; ** Integer Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_integer_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_integer_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_integer_gadget_x_size,gng_Width(a1)
	move.w	#qh_integer_gadget_y_size,gng_Height(a1)
	moveq	#0,d0
	move.l  d0,gng_GadgetText(a1)
        move.w	#qh_integer_gadget_id,gng_GadgetID(a1)
	move.l	d0,gng_Flags(a1)

	move.l	#INTEGER_KIND,d0
	move.l	a4,a0
	lea	qh_integer_gadget_tag_list(pc),a2
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4
	move.l	d0,qh_integer_gadget_gadget(a3)

; ** Forward-Button Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_fwd_button_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_fwd_button_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_fwd_button_gadget_x_size,gng_Width(a1)
	move.w	#qh_fwd_button_gadget_y_size,gng_Height(a1)
	lea	qh_fwd_button_gadget_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_fwd_button_gadget_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.l	a4,a0
	lea	qh_button_gadget_tag_list(pc),a2
	moveq	#BOOL_FALSE,d0
  	move.l	d0,ti_data(a2)		; Gadget aktiv
	move.l	#BUTTON_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4
	move.l	d0,qh_fwd_button_gadget_gadget(a3)

; ** Cycle Gadget **
qh_create_cycle_gadget
	lea	qh_new_gadget(pc),a1
	move.w	#qh_cycle_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_cycle_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_cycle_gadget_x_size,gng_Width(a1)
	move.w	#qh_cycle_gadget_y_size,gng_Height(a1)
	moveq	#0,d0
	move.l  d0,gng_GadgetText(a1)
        move.w	#qh_cycle_gadget_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	lea	qh_cycle_gadget_tag_list(pc),a2
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	subq.w	#1,d0			; Zählung ab 0
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0
	moveq	#0,d0
	move.b	pqe_runmode(a0),d0
	subq.b	#1,d0			; Zählung von Null
	move.l	d0,(1*ti_SIZEOF)+ti_Data(a2)
	move.l	#CYCLE_KIND,d0
	move.l	a4,a0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4
	move.l	d0,qh_cycle_gadget_gadget(a3)

; ** Mutually-Exclusive Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_mx_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_mx_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	moveq	#0,d0
	move.l  d0,gng_GadgetText(a1)
        move.w	#qh_mx_gadget_id,gng_GadgetID(a1)
	moveq	#PLACETEXT_RIGHT,d0
	move.l	d0,gng_Flags(a1)
	lea	qh_mx_gadget_tag_list(pc),a2
	moveq   #0,d0
	move.w	qh_edit_entry_offset(a3),d0
	subq.w	#1,d0			; Zählung von 0
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0
	moveq	#0,d0
	move.b	pqe_entry_active(a0),d0
        neg.b	d0
	move.l	d0,(1*ti_SIZEOF)+ti_Data(a2)
	move.l	#MX_KIND,d0
	move.l	a4,a0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4
	move.l	d0,qh_mx_gadget_gadget(a3)

; ** Positive-Button Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_pos_button_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_pos_button_gadget_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_pos_button_gadget_x_size,gng_Width(a1)
	move.w	#qh_pos_button_gadget_y_size,gng_Height(a1)
	lea	qh_pos_button_gadget_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_pos_button_gadget_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.l	#BUTTON_KIND,d0
	move.l	a4,a0
	lea	qh_button_gadget_tag_list(pc),a2
	CALLGADTOOLS CreateGadgetA
	move.l	d0,a4

; ** Negative-Button-Gadget **
	lea	qh_new_gadget(pc),a1
	move.w	#qh_neg_button_gadget_x_position,gng_LeftEdge(a1)
	move.w	#qh_neg_button_gadget_x_size,gng_Width(a1)
	move.w	#qh_neg_button_gadget_y_size,gng_Height(a1)
	lea	qh_neg_button_gadget_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_neg_button_gadget_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.l	#BUTTON_KIND,d0
	move.l	a4,a0
	lea	qh_button_gadget_tag_list(pc),a2
	CALLGADTOOLS CreateGadgetA

	tst.l	d0
	bne.s	qh_create_gadgets_ok
	lea	qh_error_text4(pc),a0
	moveq	#qh_error_text4_end-qh_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
qh_create_gadgets_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; a0	... Zeiger auf Eintrag in Playback-Queue
; Result
; d0.l	... Zeiger auf Dateinamen
	CNOP 0,4
qh_get_demofile_title
	moveq	#adl_demofile_path_length-1,d6
	add.l	d6,a0			; Zeiger auf letztes Zeichen (Nullbyte)
qh_get_demofile_title_loop
	tst.b	(a0)
	cmp.b	#"/",(a0)
	beq.s	qh_get_demofile_title_skip
	cmp.b	#":",(a0)
	beq.s	qh_get_demofile_title_skip
	subq.w	#1,a0			; vorgeriges Zeichen in Dateipfad
	dbf	d6,qh_get_demofile_title_loop
qh_get_demofile_title_skip
	addq.w	#1,a0			; "/" oder ":" überspringen
	move.l	a0,d0
	rts


; Input
; Result
; d0.l	... Return-Code
	CNOP 0,4
qh_open_edit_window
	sub.l	a0,a0			; Keine NewWindow-Struktur
	lea	qh_edit_window_tag_list(pc),a1
	move.l	qh_gadget_list(pc),ewtl_WA_Gadgets+ti_Data(a1)
	CALLINT OpenWindowTagList
	move.l	d0,qh_edit_window(a3)
	bne.s	qh_do_open_edit_window
	lea	qh_error_text5(pc),a0
	moveq	#qh_error_text5_end-qh_error_text5,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
qh_do_open_edit_window
	move.l	d0,a2
	move.l	d0,a0			; Window
	sub.l	a1,a1			; Kein Requester
	CALLGADTOOLS GT_RefreshWindow
        move.l	a2,a0			; Window
	lea	qh_edit_window_name1(pc),a1 ; Neuer Window-Titel
	tst.w	qh_arg_editentry_enabled(a3)
	beq.s	qh_open_edit_window_skip
	lea	qh_edit_window_name2(pc),a1 ; Neuer Window-Titel
qh_open_edit_window_skip
	move.w	#-1,a2			; Screen-Titel beibehalten
	CALLINT SetWindowTitles
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
qh_process_window_events
	move.l	qh_edit_window(a3),a0
	move.l	wd_UserPort(a0),a2
	moveq	#0,d0
        move.b	MP_SigBit(a2),d1
	bset	d1,d0			; Signal-Nummer
	move.l	a2,a0			; Port
	CALLEXEC Wait
	move.l	a2,a0
	CALLGADTOOLS GT_GetIMsg
	move.l	d0,a4			; Intuition-Message
	move.l 	im_Class(a4),d0		; IDCMP

; ** Event Gadget-Up **
	cmp.l	#IDCMP_GADGETUP,d0
	bne	qh_check_event_gadget_down
	move.l	im_IAddress(a4),a0
; * Backwards Button Gadget *
	cmp.w	#qh_bwd_button_gadget_id,gg_GadgetID(a0)
	bne.s	qh_check_integer_gadget_event
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	cmp.w	#adl_entries_number_min,d0
	beq.s   qh_bwd_button_gadget_event_skip
        subq.w	#1,d0			; vorheriger Eintrag
qh_bwd_button_gadget_event_skip
	move.w	d0,qh_edit_entry_offset(a3)
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	bsr	qh_edit_fetch_entry
	moveq	#0,d2
	move.w	qh_edit_entry_offset(a3),d2
	move.l	qh_edit_entry_demofile_name(a3),a2
	move.l	qh_edit_entry(a3),a5
	bsr	qh_update_gadgets
	bra	qh_process_window_events_ok
; * Integer Gadget *
	CNOP 0,4
qh_check_integer_gadget_event
	cmp.w	#qh_integer_gadget_id,gg_GadgetID(a0)
	bne	qh_check_fwd_button_gadget_event
	move.l	gg_SpecialInfo(a0),a0
	move.l	si_Buffer(a0),a0	; Zeiger auf String
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	qh_ascii_to_dec		; Rückgabewert d0 = Dezimalzahl
	cmp.w	#adl_entries_number_min,d0
	bge.s	qh_check_integer_gadget_max
	move.l	qh_workbench_screen(a3),a0
	CALLINT DisplayBeep
	moveq	#adl_entries_number_min,d0
	bra.s	qh_check_integer_gadget_ok
	CNOP 0,4
qh_check_integer_gadget_max
	moveq	#0,d2
	move.w	adl_entries_number(a3),d2
	cmp.w	d2,d0
	ble.s   qh_check_integer_gadget_ok
	move.l	qh_workbench_screen(a3),a0
	CALLINT DisplayBeep
	move.l	d2,d0
qh_check_integer_gadget_ok
	move.w	d0,qh_edit_entry_offset(a3)
	bsr	qh_edit_fetch_entry
	moveq	#0,d2
	move.w	qh_edit_entry_offset(a3),d2
	move.l	qh_edit_entry_demofile_name(a3),a2
	move.l	qh_edit_entry(a3),a5
	bsr	qh_update_gadgets
	bra	qh_process_window_events_ok
; * Fowrward-Button Gadget *
	CNOP 0,4
qh_check_fwd_button_gadget_event
	cmp.w	#qh_fwd_button_gadget_id,gg_GadgetID(a0)
	bne.s	qh_check_cycle_gadget_event
	move.w	qh_edit_entry_offset(a3),d0
	cmp.w	adl_entries_number(a3),d0
	beq.s   qh_fwd_button_gadget_event_skip
        addq.w	#1,d0			; nächster Eintrag
qh_fwd_button_gadget_event_skip
	move.w	d0,qh_edit_entry_offset(a3)
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	bsr	qh_edit_fetch_entry
	moveq	#0,d2
	move.w	qh_edit_entry_offset(a3),d2
	move.l	qh_edit_entry_demofile_name(a3),a2
	move.l	qh_edit_entry(a3),a5
	bsr	qh_update_gadgets
	bra	qh_process_window_events_ok
; * Cycle Gadget *
	CNOP 0,4
qh_check_cycle_gadget_event
	cmp.w	#qh_cycle_gadget_id,gg_GadgetID(a0)
	bne.s	qh_check_pos_button_gadget_event
	move.w	im_Code(a4),d0
	addq.b	#1,d0
	move.b	d0,qh_edit_runmode(a3)
	bra	qh_process_window_events_ok
; * Positive-Button Gadget *
	CNOP 0,4
qh_check_pos_button_gadget_event
	cmp.w	#qh_pos_button_gadget_id,gg_GadgetID(a0)
	bne.s	qh_check_neg_button_gadget_event
	move.l	qh_edit_entry(a3),a0
	move.b	qh_edit_runmode(a3),pqe_runmode(a0)
	move.b	qh_edit_entry_active(a3),pqe_entry_active(a0)
	move.w	#FALSE,qh_check_window_events_active(a3)
	bra.s	qh_process_window_events_ok
; * Negative-Button Gadget *
	CNOP 0,4
qh_check_neg_button_gadget_event
	cmp.w	#qh_neg_button_gadget_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_ok
	move.w	#FALSE,qh_check_window_events_active(a3)
	bra.s	qh_process_window_events_ok

; ** Gadget-Down **
	CNOP 0,4
qh_check_event_gadget_down
	cmp.l	#IDCMP_GADGETDOWN,d0
	bne.s	qh_check_event_close_window
	move.l	im_IAddress(a4),a0
	cmp.w	#qh_mx_gadget_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_ok
	move.w	im_Code(a4),d0
	neg.b	d0
	move.b	d0,qh_edit_entry_active(a3)
	bra.s	qh_process_window_events_ok

; ** Close_window **
	CNOP 0,4
qh_check_event_close_window
	cmp.l	#IDCMP_CLOSEWINDOW,d0
	bne.s	qh_check_event_refresh_window
	move.w	#FALSE,qh_check_window_events_active(a3)
       	bra.s	qh_process_window_events_ok

; ** Refresh-Window **
	CNOP 0,4
qh_check_event_refresh_window
	cmp.l	#IDCMP_REFRESHWINDOW,d0
	bne.s   qh_process_window_events_ok
	move.l	qh_edit_window(a3),a5
	move.l	a5,a0
	CALLGADTOOLS GT_BeginRefresh
	move.l	a5,a0			; Window
	moveq	#TRUE,d0
	CALLLIBS GT_EndRefresh

qh_process_window_events_ok
	move.l	a4,a1			; Intuition-Message
	move.l	qh_edit_window(a3),a0
	move.l	wd_UserPort(a0),a2
	CALLGADTOOLS GT_ReplyIMsg
	tst.w	qh_check_window_events_active(a3)
	beq	qh_process_window_events
	rts


; Input
; a0	... Zeiger auf String
; d7.l	... Anzahl der Stellen zum Umwandeln
; Result
; d0.l	... Rückgabewert: Dezimalzahl
	CNOP 0,4
qh_ascii_to_dec
	tst.b	1(a0)
	bne.s	qh_ascii_to_dec_skip
	subq.w	#1,d7		        ; Nur eine Stelle umwandeln
qh_ascii_to_dec_skip
	add.l	d7,a0			; Zeiger auf Ende des Strings
	moveq	#0,d0			; Dezimalzahl
	moveq	#1,d2			; Erster Dezimal-Stellenwert 1
	subq.w	#1,d7			; wegen dbf
qh_ascii_to_dec_loop
	moveq	#0,d3
	move.b	-(a0),d3		; ASCII-Wert lesen
	sub.b	#"0",d3			; ASCII-Wert "0" abziehen = 0..9
	mulu.w	d2,d3			; Dezimal-Stellenwert (1,10,..)
	MULUF.L	10,d2,d1		; nächste Zehnerprotenz
	add.l	d3,d0			; Stelle zum Ergebnis addieren
	dbf	d7,qh_ascii_to_dec_loop
	rts


; Input
; d0.l	... Nummer des Eintrags (1..n)
; Result
; d0.l	... Kein Rückgabewert
	CNOP 0,4
qh_edit_fetch_entry
	subq.l	#1,d0			; Zählung ab 0
	MULUF.L	playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0
	move.l	a0,qh_edit_entry(a3)
	bsr	qh_get_demofile_title
	move.l	d0,qh_edit_entry_demofile_name(a3)
	rts


; Input
; d2.l	... Nummer des Eintrags
; a2	... Zeiger auf Dateinamen des Demos
; a5	... Zeiger auf Eintrag
; Result
; d0.l	... Kein Rückgabewert
	CNOP 0,4
qh_update_gadgets
	move.l	qh_text_gadget_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	move.l	a3,-(a7)
	lea	qh_set_text_gadget_tag_list(pc),a3
	move.l	a2,ti_data(a3)		; Zeiger auf Dateinamen des Demos
	sub.l	a2,a2			; Kein Requester
  	CALLGADTOOLS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_bwd_button_gadget_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; Kein Requester
	moveq	#BOOL_FALSE,d0		; Gadget aktiv
	cmp.w	#adl_entries_number_min,qh_edit_entry_offset(a3)
        bne.s	qh_update_gadgets_skip1
	moveq	#BOOL_TRUE,d0		; Gadget inaktiv
qh_update_gadgets_skip1
	move.l	a3,-(a7)
	lea	qh_set_button_gadget_tag_list(pc),a3
	move.l	d0,ti_data(a3)		; Button aktivieren/deaktivieren
  	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_integer_gadget_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; Kein Requester
	move.l	a3,-(a7)
	lea	qh_set_integer_gadget_tag_list(pc),a3
	move.l	d2,ti_data(a3)
  	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_fwd_button_gadget_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; Kein Requester
	moveq	#BOOL_FALSE,d0		; Gadget aktiv
	move.w	qh_edit_entry_offset(a3),d1
	cmp.w	adl_entries_number(a3),d1
        blt.s	qh_update_gadgets_skip2
	moveq	#BOOL_TRUE,d0		; Gadget inaktiv
qh_update_gadgets_skip2
	move.l	a3,-(a7)
	lea	qh_set_button_gadget_tag_list(pc),a3
	move.l	d0,ti_data(a3)		; Button aktivieren/deaktivieren
  	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_cycle_gadget_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; Kein Requester
	move.l	a3,-(a7)
	lea	qh_set_cycle_gadget_tag_list(pc),a3
	moveq	#0,d0
	move.b	pqe_runmode(a5),d0
	subq.b	#1,d0
	move.l	d0,ti_data(a3)		; Ordnungsnummer
  	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_mx_gadget_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; Kein Requester
	move.l	a3,-(a7)
	lea	qh_set_mx_gadget_tag_list(pc),a3
	moveq	#0,d0
	move.b	pqe_entry_active(a5),d0
	neg.b	d0
	move.l	d0,ti_data(a3)
  	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3
	rts


	CNOP 0,4
qh_close_edit_window
	move.l	qh_edit_window(a3),a0
	CALLINTQ CloseWindow


	CNOP 0,4
qh_free_gadgets
	move.l	qh_gadget_list(pc),a0
	CALLGADTOOLSQ FreeGadgets


	CNOP 0,4
qh_free_screen_visual_info
	move.l	qh_screen_visual_info(a3),a0
	CALLGADTOOLSQ FreeVisualInfo


	CNOP 0,4
qh_unlock_workbench
	sub.l	a0,a0			; Kein Name
	move.l	qh_workbench_screen(a3),a1
	CALLINTQ UnLockPubScreen


	CNOP 0,4
qh_clear_queue
	move.l	adl_entries_buffer(a3),a0
	tst.b	(a0)
	bne.s   qh_clear_queue_ok
	lea	qh_message_text4(pc),a0
	moveq	#qh_message_text4_end-qh_message_text4,d0
	bra	adl_print_text
	CNOP 0,4
qh_clear_queue_ok
	move.w	adl_entries_number(a3),d7
	subq.w	#1,d7			; wegen dbf
qh_clear_queue_loop
	bsr	dc_clear_playlist_entry
	dbf	d7,qh_clear_queue_loop
	clr.w	adl_entries_number(a3)
	move.w	#adl_entries_number_min,rd_entry_offset(a3)
	tst.w	adl_reset_program_active(a3)
	bne.s	qh_clear_queue_skip
	GET_RESIDENT_ENTRIES_NUMBER
	move.l	d0,a0
	clr.w	(a0)
	GET_RESIDENT_ENTRY_OFFSET
	move.l	d0,a0
	move.w	#adl_entries_number_min,(a0)
qh_clear_queue_skip
	lea	qh_message_text5(pc),a0
	moveq	#qh_message_text5_end-qh_message_text5,d0
	bra	adl_print_text


	CNOP 0,4
qh_free_visual_info
	move.l	qh_screen_visual_info(a3),a0
	CALLGADTOOLSQ FreeVisualInfo



	CNOP 0,4
qh_reset_queue
	cmp.w	#adl_entries_number_min,rd_entry_offset(a3)
        bne.s	qh_reset_queue_ok
	lea	qh_message_text6(pc),a0
	moveq	#qh_message_text6_end-qh_message_text6,d0
	bsr	adl_print_text
	bra	adl_check_cmd_line_ok
	CNOP 0,4
qh_reset_queue_ok
	move.w	#adl_entries_number_min,rd_entry_offset(a3)
	bsr	rd_deactivate_queue
	lea	qh_message_text7(pc),a0
	moveq	#qh_message_text7_end-qh_message_text7,d0
	bsr	adl_print_text


	CNOP 0,4
qh_check_queue_empty
	move.l	adl_entries_buffer(a3),a2
	tst.b	(a2)
	bne.s	qh_check_queue_empty_ok
	moveq	#RETURN_WARN,d0
	rts
	CNOP 0,4
qh_check_queue_empty_ok
	moveq	#RETURN_OK,d0
	rts



; **** Amiga-Demo-Launcher ****
	CNOP 0,4
adl_free_read_arguments
	move.l	adl_read_arguments(a3),d1
	beq.s	adl_free_read_arguments_skip
	CALLDOSQ FreeArgs
	CNOP 0,4
adl_free_read_arguments_skip
	rts


	CNOP 0,4
adl_print_io_error
	move.l	adl_dos_return_code(a3),d1
	moveq	#ERROR_NO_FREE_STORE,d0
	cmp.l	d0,d1
	bge.s	adl_print_io_error_skip
	rts
	CNOP 0,4
adl_print_io_error_skip
	lea	adl_error_header(pc),a0
	move.l	a0,d2                   ; Header für Fehlermeldung
	CALLDOSQ PrintFault


	CNOP 0,4
adl_remove_reset_program
	tst.w	adl_arg_remove_enabled(a3)
	beq.s	adl_check_reset_program_active2
	rts
	CNOP 0,4
adl_check_reset_program_active2
	tst.w	adl_reset_program_active(a3)
	beq.s	adl_free_reset_programm_memory
	lea	adl_message_text2(pc),a0
	moveq	#adl_message_text2_end-adl_message_text2,d0
	bra	adl_print_text
	CNOP 0,4
adl_free_reset_programm_memory
	REMOVE_RESET_PROGRAM
	move.l	d0,a0
	move.l	(a0)+,a1
	move.l	(a0),d0
	CALLEXEC FreeMem
	lea	adl_message_text1(pc),a0
	moveq	#adl_message_text1_end-adl_message_text1,d0
	bra	adl_print_text


	CNOP 0,4
adl_close_gadtools_library
	move.l	_GadToolsBase(pc),a1
	CALLEXECQ CloseLibrary


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


; Input
; a0	... Zeiger auf Fehlertext
; d0.l	... Länge des Textes
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
adl_print_text
	move.l	adl_output_handle(a3),d1
	move.l	a0,d2			; Zeiger auf Fehlertext
	move.l	d0,d3			; Anzahl der Zeichen zum Schreiben
	CALLDOSQ Write


; **** Run-Demo ****
	CNOP 0,4
rd_start
	bsr	rd_open_ciaa_resource
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
	bsr	rd_open_ciab_resource
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

	bsr	rd_open_icon_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

	bsr	rd_create_serial_message_port
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_icon_library
	bsr	rd_init_serial_io
	bsr	rd_open_serial_device
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_serial_message_port

	bsr	rd_alloc_cleared_sprite_data
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_serial_device

	bsr	sf_alloc_screen_color_table
	move.l	d0,adl_dos_return_code(a3)
	bne     rd_cleanup_cleared_sprite_data
	bsr	sf_alloc_screen_color_cache
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_screen_color_table

	bsr	rd_get_active_screen
	bsr	rd_get_active_screen_mode
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_screen_color_table
	bsr	sf_get_active_screen_colors
	bsr	sf_copy_screen_color_table

rd_play_loop
	bsr	rd_check_queue
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_screen_color_cache

	bsr	rd_get_demofile_name
	bsr	rd_print_demofile_start_message
	bsr	rd_check_demofile_play_state
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_open_demofile
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_read_demofile_header
	bsr	rd_close_demofile
	bsr	rd_check_demofile_header
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_get_demofile_dir_path
	bsr	rd_set_new_current_dir
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error

	bsr	rd_get_prerunscript_path
	bsr	rd_check_prerunscript_path
	move.l	d0,adl_dos_return_code(a3)
	bne     rd_cleanup_current_dir
	bsr	rd_execute_prerunscript
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_current_dir

	bsr	sf_fade_out_active_screen
	bsr	rd_open_pal_screen
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_active_screen_colors
	bsr	rd_check_pal_screen_mode
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_active_screen_colors
	bsr	rd_open_invisible_window
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_pal_screen
	bsr	rd_clear_mousepointer
	bsr	rd_get_sprite_resolution
	bsr	rd_set_ocs_sprite_resolution
 	bsr	rd_blank_display
	bsr	rd_wait_monitor_switch

	bsr	rd_turn_off_fast_memory
	bsr	rd_load_demofile
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_fast_memory
	bsr	rd_check_whdloadfile
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_demofile

	bsr	adl_wait_drives_motor

	bsr	rd_init_timer_start
	bsr	rd_start_timer
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_demofile

	bsr	rd_save_custom_trap_vectors
	bsr	rd_downgrade_CPU
	bsr	rd_save_chips_registers

	bsr	rd_run_demofile
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_demofile

	bsr	rd_clear_chips_registers
	bsr	rd_restore_chips_registers
	bsr	rd_upgrade_CPU
	bsr	rd_restore_custom_trap_vectors

	bsr	rd_init_timer_stop
	bsr	rd_stop_timer
	move.l	d0,adl_dos_return_code(a3)
	
rd_cleanup_demofile
	bsr	rd_unload_demofile

rd_cleanup_fast_memory
	bsr	rd_free_fast_memory
rd_cleanup_display
	bsr	rd_restore_sprite_resolution
	bsr	rd_wait_monitor_switch
rd_cleanup_invisible_window
	bsr	rd_close_invisible_window
rd_cleanup_pal_screen
	bsr	rd_close_pal_screen
rd_cleanup_active_screen_colors
	bsr	sf_fade_in_screen
	bsr	rd_check_active_screen_priority

rd_cleanup_current_dir
	bsr	rd_restore_current_dir

rd_cleanup_io_error
	move.l	rd_demofile_path(a3),a0
	bsr	adl_print_io_error

	bsr	rd_check_queue
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_screen_color_cache

	bsr	rd_check_user_break
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_screen_color_cache

	bsr	rd_reset_demo_variables

	bsr	rd_check_arg_loop_enabled
	tst.l	d0
	beq	rd_play_loop

rd_cleanup_screen_color_cache
	bsr	sf_free_screen_color_cache
rd_cleanup_screen_color_table
	bsr	sf_free_screen_color_table
rd_cleanup_cleared_sprite_data
	bsr	rd_free_cleared_sprite_data

rd_cleanup_serial_device
	bsr	rd_close_serial_device
rd_cleanup_serial_message_port
	bsr	rd_delete_serial_message_port

rd_cleanup_icon_library
	bsr	rd_close_icon_library

rd_quit
	bra	adl_cleanup_read_arguments


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_open_ciaa_resource
	lea	CIAA_resource_name(pc),a1
	CALLEXEC OpenResource
	lea	_CIABase(pc),a0
	move.l	d0,(a0)
	bne.s	rd_open_ciaa_resource_skip
	lea	rd_error_text1(pc),a0
	moveq	#rd_error_text1_end-rd_error_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_ciaa_resource_skip
	moveq	#0,d0			; Keine Maske
	CALLCIA AbleICR
	lea	rd_old_chips_registers+ocr_ciaa_icr(pc),a0
	move.b	d0,(a0)
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_open_ciab_resource
	lea	CIAB_resource_name(pc),a1
	CALLEXEC OpenResource
	lea	_CIABase(pc),a0
	move.l	d0,(a0)
	bne.s	rd_open_ciab_resource_skip
	lea	rd_error_text2(pc),a0
	moveq	#rd_error_text2_end-rd_error_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_ciab_resource_skip
	moveq	#0,d0			; keine Maske
	CALLCIA AbleICR
	lea	rd_old_chips_registers+ocr_ciab_icr(pc),a0
	move.b	d0,(a0)
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_open_icon_library
	lea	icon_library_name(pc),a1
	moveq	#OS_VERSION_MIN,d0
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


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_create_serial_message_port
	CALLEXEC CreateMsgPort
	move.l	d0,rd_serial_message_port(a3)
	bne.s	rd_create_serial_message_port_ok
	lea	rd_error_text4(pc),a0
	moveq	#rd_error_text4_end-rd_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_create_serial_message_port_ok
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


; Input
; Result
; d0.l	Rückgabewert: Return-Code
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
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_serial_device_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
rd_alloc_cleared_sprite_data
	moveq	#sprite_pointer_data_size,d0
	MOVEF.L	MEMF_CLEAR|MEMF_CHIP|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,rd_cleared_sprite_pointer_data(a3)
	bne.s	rd_alloc_cleared_sprite_data_ok
	lea	rd_error_text6(pc),a0
	moveq	#rd_error_text6_end-rd_error_text6,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
rd_alloc_cleared_sprite_data_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
sf_alloc_screen_color_table
	tst.w	rd_arg_fader_enabled(a3)
	bne.s	sf_alloc_screen_color_table_ok
	MOVEF.L	sf_colors_number*3*LONGWORD_SIZE,d0
	MOVEF.L	MEMF_CLEAR|MEMF_ANY|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,sf_screen_color_table(a3)
	bne.s	sf_alloc_screen_color_table_ok
	lea	rd_error_text7(pc),a0
	moveq	#rd_error_text7_end-rd_error_text7,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
sf_alloc_screen_color_table_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
sf_alloc_screen_color_cache
	tst.w	rd_arg_fader_enabled(a3)
	bne.s	sf_alloc_screen_color_cache_ok
	MOVEF.L	(1+(sf_colors_number*3)+1)*LONGWORD_SIZE,d0
	MOVEF.L	MEMF_CLEAR|MEMF_ANY|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,sf_screen_color_cache(a3)
	bne.s	sf_alloc_screen_color_cache_ok
	lea	rd_error_text8(pc),a0
	moveq	#rd_error_text8_end-rd_error_text8,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	rts
	CNOP 0,4
sf_alloc_screen_color_cache_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
sf_get_active_screen_colors
	tst.w	rd_arg_fader_enabled(a3)
	bne.s	sf_get_active_screen_colors_skip
	move.l	rd_active_screen(a3),d0
	beq.s	sf_get_active_screen_colors_skip
	move.l	d0,a0
	move.l	sc_ViewPort+vp_ColorMap(a0),a0
	move.l	sf_screen_color_table(a3),a1 ; 32-Bit RGB-Werte
	moveq	#0,d0			; Ab COLOR00
	MOVEF.L	sf_colors_number,d1 ; Alle 256 Farben
 	CALLGRAFQ GetRGB32
	CNOP 0,4
sf_get_active_screen_colors_skip
	rts


	CNOP 0,4
sf_copy_screen_color_table
	tst.w	rd_arg_fader_enabled(a3)
	beq.s	sf_copy_screen_color_table_skip
	rts
	CNOP 0,4
sf_copy_screen_color_table_skip
	move.l	sf_screen_color_table(a3),a0 ; Quelle 32-Bit RGB-Werte
	move.l	sf_screen_color_cache(a3),a1 ; Ziel 32-Bit RGB-Werte
	move.w	#sf_colors_number,(a1)+ ; Anzahl der Farben
	moveq	#0,d0
	move.w	d0,(a1)+		; Ab COLOR00
	MOVEF.W	sf_colors_number-1,d7 ; Anzahl der Farbwerte
sf_copy_screen_color_table_loop
	move.l	(a0)+,(a1)+		; 32-Bit-Rotwert
	move.l	(a0)+,(a1)+		; 32-Bit-Grünwert
	move.l	(a0)+,(a1)+		; 32-Bit-Blauwert
	dbf	d7,sf_copy_screen_color_table_loop
	move.l	d0,(a1)			; Listenende
        rts


	CNOP 0,4
rd_get_demofile_name
	tst.w	rd_arg_random_enabled(a3)
	bne.s	rd_get_fixed_entry
rd_get_random_entry_loop
	move.w	adl_entries_number(a3),d1
	bsr	rd_get_random_entry
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0
	tst.b	pqe_entry_active(a0)	; Demo bereits ausgeführt ?
	bne.s	rd_get_random_entry_loop ; Ja -> neue Berechnung
	bra.s	rd_check_demofile_path
	CNOP 0,4
rd_get_fixed_entry
	move.w	rd_entry_offset(a3),d0
	subq.w	#1,d0			; Zählung ab 0
	MULUF.L playback_queue_entry_size,d0,d1 ; Offset in Puffer berechnen
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0
rd_check_demofile_path
	move.l	a0,rd_demofile_path(a3)
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
	beq.s	rd_demofile_name_skip	; Ja -> verzweige
	cmp.b	(a0),d3			; ":" gefunden ?
	beq.s	rd_demofile_name_skip	; Ja -> verzweige
	subq.w	#1,a0			; vorgeriges Zeichen in Dateipfad
	dbf	d7,rd_get_demofile_name_loop
rd_demofile_name_skip
	addq.w	#1,a0			; "/" oder ":" überspringen
	move.l	a0,rd_demofile_name(a3) ; Zeiger auf Dateinamen retten
	subq.w	#1,d0			; "/" oder ":" abziehen
	move.l	d0,rd_demofile_name_length(a3)
	addq.w	#1,rd_entry_offset(a3)
	GET_RESIDENT_ENTRY_OFFSET
	move.l	d0,a0
	addq.w	#1,(a0)
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_print_demofile_start_message
	lea	rd_demofile_name_header(pc),a0
	moveq	#rd_demofile_name_header_end-rd_demofile_name_header,d0
	bsr	adl_print_text
	move.l	rd_demofile_name(a3),a0
	move.l	rd_demofile_name_length(a3),d0
	bsr	adl_print_text
	lea	rd_demofile_name_tail(pc),a0
	moveq	#rd_demofile_name_tail_end-rd_demofile_name_tail,d0
	bra	adl_print_text


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_check_demofile_play_state
	move.l	rd_demofile_path(a3),a0
	tst.b	pqe_entry_active(a0)
	beq.s   rd_check_demofile_play_state_ok
	lea	rd_error_text9(pc),a0
	moveq	#rd_error_text9_end-rd_error_text9,d0
	bsr	adl_print_text
	moveq	#RETURN_WARN,d0
	rts
	CNOP 0,4
rd_check_demofile_play_state_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; d1.w	... Anzahl der Einträge
; Result
; d0.l	... Rückgabewert: Zufallswert für Offset
	CNOP 0,4
rd_get_random_entry
	move.w	_CUSTOM+VHPOSR,d0	; f(x)
	mulu.w	_CUSTOM+VHPOSR,d0	; f(x)*a
	move.w	_CUSTOM+VHPOSR,d2
	swap	d2
	move.b	_CIAA+CIATODLOW,d2
	lsl.w	#8,d2
	move.b	_CIAB+CIATODLOW,d2	; b
	add.l	d2,d0			; (f(x)*a)+b
	and.l	#$0000ffff,d0		; Nur Low-Word
	divu.w	d1,d0			; f(x+1) = [(f(x)*a)+b]/mod rp_entries_number
	swap	d0			; Rest der Division = Zufallsoffset
	ext.l	d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_open_demofile
	move.l	rd_demofile_path(a3),a0
	move.b	#FALSE,pqe_entry_active(a0) ; Demo wurde abgespielt
	move.l	a0,d1
	MOVEF.L	MODE_OLDFILE,d2
	CALLDOS Open
	move.l	d0,rd_demofile_handle(a3)
	bne.s	rd_open_demofile_ok
	lea	rd_error_text10(pc),a0
	moveq	#rd_error_text10_end-rd_error_text10,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
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


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
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
rd_get_demofile_dir_path
	moveq	#"/",d2
	moveq	#":",d3
	moveq	#adl_demofile_path_length-1,d7
	move.l	rd_demofile_path(a3),a0 ; Zeiger auf Eintrag in Playback-Queue
	add.l	d7,a0			; Ende des Quellpuffers
	lea	rd_demo_dir_path(pc),a1 ; Zeiger auf Puffer für Demo-Directory-Pfad
	add.l	d7,a1			; Ende des Zielpuffers
rd_get_dir_loop
	move.b	-(a0),d0		; Quell-Pfadename rückwärts byteweise auslesen
	subq.w	#1,d7
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
rd_copy_characters_loop
	move.b	-(a0),-(a1)
	dbf	d7,rd_copy_characters_loop
        rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
rd_set_new_current_dir
	lea	rd_demo_dir_path(pc),a0
	move.l	a0,d1			; Zeiger auf Puffer für Pfadnamen
	MOVEF.L	ACCESS_READ,d2
	CALLDOS Lock
	move.l	d0,rd_demofile_dir_lock(a3)
	bne.s	rd_demofile_dir_lock_skip
	lea	rd_error_text12(pc),a0
	moveq	#rd_error_text12_end-rd_error_text12,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_demofile_dir_lock_skip
	move.l	d0,d1			; Lock für Programm-Directory
	move.l	d0,d3			; Lock für Current-Directory
	CALLLIBS SetProgramDir		; PRGDIR: = Demo-Directory
	move.l	d3,d1			; Current-Directory-Lock
	CALLLIBS CurrentDir		; Current Directory = Demo-Directory
	move.l	d0,rd_old_current_dir_lock(a3) ; Lock von altem Current Directory
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_get_prerunscript_path
	tst.w	rd_arg_prerunscript_enabled(a3)
	bne.s	rd_get_queue_prerunscript_path
	rts
	CNOP 0,4
rd_get_queue_prerunscript_path
	move.l	rd_demofile_path(a3),a0
	ADDF.W	pqe_prerunscript_path,a0
	tst.b	(a0)			; Wurde Pfad angegeben ?
	bne.s	rd_get_prerunscript_path_save
	rts
	CNOP 0,4
rd_get_prerunscript_path_save
	move.l	a0,rd_prerunscript_path(a3)
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
rd_check_prerunscript_path
	move.l	rd_prerunscript_path(a3),d0
	bne.s	rd_do_check_prerunscript_path
	rts
	CNOP 0,4
rd_do_check_prerunscript_path
	move.l	d0,a0
	moveq	#0,d0			; Zähler für Anzahl Zeichen
rd_check_prerunscript_path_loop
	addq.b	#1,d0
	cmp.b	#adl_prerunscript_path_length-1,d0
	blt.s	rd_check_prerunscript_path_skip
	lea	rd_error_text13(pc),a0
	moveq	#rd_error_text13_end-rd_error_text13,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_INVALID_COMPONENT_NAME,d0
	rts
        CNOP 0,4
rd_check_prerunscript_path_skip
	tst.b	(a0)+
	bne.s	rd_check_prerunscript_path_loop
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_execute_prerunscript
	move.l	rd_prerunscript_path(a3),d0
	bne.s	rd_copy_prerunscript_path
	rts
	CNOP 0,4
rd_copy_prerunscript_path
	move.l	d0,a0			; Quelle: Prerunscript-Pfad
	lea	rd_prerunscript_cmd_line_path(pc),a1 ; Ziel: Befehlszeile
	moveq	#adl_prerunscript_path_length-1,d7
rd_copy_prerunscript_path_loop
	move.b	(a0)+,(a1)+
	dbeq	d7,rd_copy_prerunscript_path_loop ;Schleife solange, bis Nullbxte gefunden wurde
	lea	rd_prerunscript_cmd_line(pc),a0
	move.l	a0,d1			; Zeiger auf Kommandozeile
	moveq	#0,d2			; Keine Tags
	CALLDOS	SystemTagList
	tst.l	d0
	beq.s	rd_execute_prerunscript_ok
	lea	rd_error_text14(pc),a0
	moveq	#rd_error_text14_end-rd_error_text14,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_execute_prerunscript_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_get_active_screen
	moveq	#0,d0			; Alle Locks
	CALLINT LockIBase
	move.l	d0,a0
	move.l	ib_ActiveScreen(a6),a2
	CALLLIBS UnlockIBase
	move.l	a2,rd_active_screen(a3)
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_get_active_screen_mode
	move.l	rd_active_screen(a3),d0
	beq.s	rd_get_active_screen_mode_ok
	move.l	d0,a0
	ADDF.W	sc_ViewPort,a0
	CALLGRAF GetVPModeID
	cmp.l	#INVALID_ID,d0
	bne.s	rd_get_active_screen_mode_save
	lea	rd_error_text15(pc),a0
	moveq	#rd_error_text15_end-rd_error_text15,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_get_active_screen_mode_save
	and.l	#MONITOR_ID_MASK,d0	; Ohne Auflösung
	move.l	d0,rd_active_screen_mode(a3)
rd_get_active_screen_mode_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
sf_fade_out_active_screen
	tst.w	rd_arg_fader_enabled(a3)
	beq.s	sf_fade_out_active_screen_loop
	rts
	CNOP 0,4
sf_fade_out_active_screen_loop
	CALLGRAF WaitTOF
	bsr.s	screen_fader_out
	bsr	sf_set_new_colors
	tst.w	sfo_active(a3)
	beq.s	sf_fade_out_active_screen_loop
	rts


      CNOP 0,4
screen_fader_out
	MOVEF.W	sf_colors_number*3,d6 ; Zähler
	move.l	sf_screen_color_cache(a3),a0 ; Istwerte
	addq.w  #4,a0			; Offset überspringen
	sub.l	a1,a1			; Sollwert ($000000)
	move.w  #sfo_fader_speed,a4	; Additions-/Subtraktionswert RGB-Werte
	MOVEF.W sf_colors_number-1,d7 ;Anzahl der Farbwerte
screen_fader_out_loop
	moveq   #0,d0
	move.b  (a0),d0			; 8-Bit Rot-Istwert
	move.l  a1,d3			
	swap    d3                      ; 8-Bit Rot-Sollwert
	moveq   #0,d1
	move.b  4(a0),d1		; 8-Bit Grün-Istwert
	move.w  a1,d4			
	lsr.w   #8,d4                   ; 8-Bit Grün-Sollwert
	moveq   #0,d2
	move.b  8(a0),d2		; 8-Bit Blau-Istwert
	move.w  a1,d5
	and.w	#$00ff,d5		; 8-Bit Blau-Sollwert

	cmp.w	d3,d0
	bgt.s	sfo_decrease_red
	blt.s	sfo_increase_red
sfo_matched_red
	subq.w  #1,d6			; Ziel-Rotwert erreicht
sfo_check_green_byte
	cmp.w	d4,d1
	bgt.s	sfo_decrease_green
	blt.s	sfo_increase_green
sfo_matched_green
	subq.w  #1,d6			; Ziel-Grünwert erreicht
sfo_check_blue_byte
	cmp.w	d5,d2
	bgt.s	sfo_decrease_blue
	blt.s	sfo_increase_blue
sfo_matched_blue
	subq.w	#1,d6			; Ziel-Blauwert erreicht
sfo_set_rgb_bytes
	move.b	d0,(a0)+		; 4x 8-Bit Rotwert in Cache schreiben
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d1,(a0)+		; 4x 8-Bit Grünwert in Cache schreiben
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d2,(a0)+		; 4x 8-Bit Blauwert in Cache schreiben
	move.b	d2,(a0)+
	move.b	d2,(a0)+
	move.b	d2,(a0)+
	dbf	d7,screen_fader_out_loop
	tst.w   d6			; Fertig mit ausblenden ?
	bne.s   sfo_flush_caches	; Nein -> verzweige
	move.w  #FALSE,sfo_active(a3)	; Fading-Out aus
sfo_flush_caches
	CALLEXECQ CacheClearU
	CNOP 0,4
sfo_decrease_red
	sub.w	a4,d0
	cmp.w	d3,d0
	bgt.s	sfo_check_green_byte
	move.w	d3,d0
	bra.s	sfo_matched_red
	CNOP 0,4
sfo_increase_red
	add.w	a4,d0
	cmp.w	d3,d0
	blt.s	sfo_check_green_byte
	move.w	d3,d0
	bra.s	sfo_matched_red
	CNOP 0,4
sfo_decrease_green
	sub.w	a4,d1
	cmp.w	d4,d1
	bgt.s	sfo_check_blue_byte
	move.w	d4,d1
	bra.s	sfo_matched_green
	CNOP 0,4
sfo_increase_green
	add.w	a4,d1
	cmp.w	d4,d1
	blt.s	sfo_check_blue_byte
	move.w	d4,d1
	bra.s	sfo_matched_green
	CNOP 0,4
sfo_decrease_blue
	sub.w	a4,d2
	cmp.w	d5,d2
	bgt.s	sfo_set_rgb_bytes
	move.w	d5,d2
	bra.s	sfo_matched_blue
	CNOP 0,4
sfo_increase_blue
	add.w	a4,d2
	cmp.w	d5,d2
	blt.s	sfo_set_rgb_bytes
	move.w	d5,d2
	bra.s	sfo_matched_blue


	CNOP 0,4
sf_set_new_colors
	move.l	rd_active_screen(a3),d0
	bne.s   sf_set_new_colors_skip
	rts
	CNOP 0,4
sf_set_new_colors_skip
	move.l	d0,a0
	ADDF.W	sc_ViewPort,a0
	move.l	sf_screen_color_cache(a3),a1
	CALLGRAFQ LoadRGB32


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_open_pal_screen
	lea	rd_pal_screen_tag_list(pc),a1
	sub.l	a0,a0			; Keine NewScreen-Struktur
	CALLINT OpenScreenTagList
	move.l	d0,rd_pal_screen(a3)
	bne.s	rd_open_pal_screen_ok
	lea	rd_error_text16(pc),a0
	moveq	#rd_error_text16_end-rd_error_text16,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_pal_screen_ok
	moveq	#RETURN_OK,d0
	rts

; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_check_pal_screen_mode
	move.l	rd_pal_screen(a3),d0
	beq.s	rd_check_pal_screen_mode_ok
	move.l	d0,a0
	ADDF.W	sc_ViewPort,a0
	CALLGRAF GetVPModeID
	cmp.l	#PAL_MONITOR_ID|LORES_KEY,d0
	beq.s	rd_check_pal_screen_mode_ok
	lea	rd_error_text17(pc),a0
	moveq	#rd_error_text17_end-rd_error_text17,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
rd_check_pal_screen_mode_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_open_invisible_window
	sub.l	a0,a0			; Keine NewWindow-Struktur
	lea	rd_invisible_window_tag_list(pc),a1
	move.l	rd_pal_screen(a3),wtl_WA_CustomScreen+ti_data(a1)
	CALLINT OpenWindowTagList
	move.l	d0,rd_invisible_window(a3)
	bne.s	rd_open_invisible_window_ok
	lea	rd_error_text18(pc),a0
	moveq	#rd_error_text18_end-rd_error_text18,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_open_invisible_window_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_clear_mousepointer
	move.l	rd_invisible_window(a3),a0
	move.l	rd_cleared_sprite_pointer_data(a3),a1
	moveq	#rd_cleared_sprite_y_size,d0
	moveq	#rd_cleared_sprite_x_size,d1
	moveq	#0,d2			; x-Offset
	moveq	#0,d3			; y-Offset
	CALLINTQ SetPointer


	CNOP 0,4
rd_get_sprite_resolution
	move.l	rd_pal_screen(a3),a0
	move.l  sc_ViewPort+vp_ColorMap(a0),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPRITERESN_GET,vctl_VTAG_SPRITERESN+ti_tag(a1)
	clr.l	ti_data(a1)
	CALLGRAF VideoControl
	lea     rd_video_control_tag_list(pc),a0
	move.l  vctl_VTAG_SPRITERESN+ti_Data(a0),rd_old_sprite_resolution(a3)
	rts


	CNOP 0,4
rd_set_ocs_sprite_resolution
	move.l	rd_pal_screen(a3),a2
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPRITERESN_SET,+vctl_VTAG_SPRITERESN+ti_tag(a1)
	move.l	#SPRITERESN_140NS,vctl_VTAG_SPRITERESN+ti_data(a1)
	CALLGRAF VideoControl		; Sprite-Auflösung auf 140 ns Pixel zurücksetzen
	move.l	a2,a0			; Zeiger auf Screen
	CALLINT MakeScreen
	CALLLIBQ RethinkDisplay


	CNOP 0,4
rd_blank_display
	sub.l	a1,a1			; View auf ECS-Werte zurücksetzen
	CALLGRAF LoadView
	CALLLIBS WaitTOF		; Warten bis Änderung sichtbar ist
	CALLLIBS WaitTOF		; Warten bis Interlace-Screens mit 2 Copperlisten auch voll geändert sind
	tst.l	gb_ActiView(a6)		; Erschien zwischenzeitlich ein anderer View ?
	bne.s	rd_blank_display	; Ja -> neuer Versuch
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_OCS_VANILLA,pqe_runmode(a0)
	bne.s	rd_blank_display_skip
	moveq	#0,d0
	move.l	d0,_CUSTOM+BPL1MOD
rd_blank_display_skip
	rts


	CNOP 0,4
rd_wait_monitor_switch
	move.l	rd_active_screen_mode(a3),d0
	beq.s	rd_wait_monitor_switch_skip1
	cmp.l	#DEFAULT_MONITOR_ID,d0
	beq.s	rd_wait_monitor_switch_skip1
	cmp.l	#PAL_MONITOR_ID,d0
	bne.s	rd_wait_monitor_switch_skip2
rd_wait_monitor_switch_skip1
	rts
	CNOP 0,4
rd_wait_monitor_switch_skip2
	MOVEF.L	rd_monitor_switch_delay,d1
	CALLDOSQ Delay


	CNOP 0,4
rd_turn_off_fast_memory
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_TURBO,pqe_runmode(a0)
	bne.s	rd_turn_off_fast_memory_skip
	rts
	CNOP 0,4
rd_turn_off_fast_memory_skip
	MOVEF.L	MEMF_FAST|MEMF_LARGEST,d1
	move.l	d1,d2
	CALLEXEC AvailMem
	move.l	d0,rd_available_fast_memory_size(a3)
	bne.s	rd_turn_off_fast_memory_proceed1
	rts
	CNOP 0,4
rd_turn_off_fast_memory_proceed1
	move.l	d2,d1			; Größter Fast-memory Block
	CALLLIBS AllocMem		
	move.l	d0,rd_available_fast_memory(a3)
	move.l	d0,a2
rd_turn_off_fast_memory_loop
	move.l	d2,d1			; Größter Fast-memory Block
	CALLLIBS AvailMem
	move.l	d0,(a2)+
	bne.s	rd_turn_off_fast_memory_proceed2
	rts
	CNOP 0,4
rd_turn_off_fast_memory_proceed2
	move.l	d2,d1			; Größter Fast-memory Block
	CALLLIBS AllocMem
	move.l	d0,(a2)+		; Zeiger auf Speichernlock
	bra.s	rd_turn_off_fast_memory_loop


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_load_demofile
	move.l	rd_demofile_path(a3),d1
	CALLDOS LoadSeg
	move.l	d0,rd_demofile_seglist(a3)
	bne.s	rd_load_demofile_ok
	lea	rd_error_text18(pc),a0
	moveq	#rd_error_text18_end-rd_error_text18,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_load_demofile_ok
	CALLEXEC CacheClearU
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_check_whdloadfile
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
	move.l	rd_demofile_name_length(a3),d7 ; Länge inklusive Nullbyte
rd_copy_slave_filename_loop
	move.b	(a0)+,(a1)+
	dbf	d7,rd_copy_slave_filename_loop
	move.l	a1,a2			; Zeiger auf Dateipfadende in Kommando-String retten
	move.l	rd_demofile_path(a3),a0 ; Zeiger auf Slave-Dateipfad
	lea	whdl_icon_path(pc),a1	; Zeiger auf Icon-Dateipfad
	moveq	#adl_demofile_path_length-1,d7
rd_copy_slave_filepath_loop
	move.b	(a0)+,(a1)+
	dbeq	d7,rd_copy_slave_filepath_loop ; Schleife bis Nullbyte gefunden
	subq.w	#7,a1			; Endung ".slave",0 in Icon-Dateipfad überspringen
	clr.b	(a1)			; Nullbyte einfügen
rd_check_icon_tooltypes
	lea	whdl_icon_path(pc),a0
	CALLICON GetDiskObject
	move.l	d0,whdl_disk_object(a3)
	bne.s	rd_check_tooltype_preload
	lea	rd_error_text20(pc),a0
	moveq	#rd_error_text20_end-rd_error_text20,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts

; ** WHD-Load Tooltype PRELOAD **
	CNOP 0,4
rd_check_tooltype_preload
	move.l	d0,a0
	move.l	do_ToolTypes(a0),a0
	move.l	a0,a4		
	lea	whdl_tooltype_PRELOAD(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; Tooltype "PRELOAD" gefunden ?
	beq.s	rd_check_tooltype_preloadsize ; Nein -> verzweige
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

; ** WHD-Load Tooltype PRELOADSIZE **
rd_check_tooltype_preloadsize
	move.l	a4,a0			; Zeiger auf Tooltypes-Feld
	lea	whdl_tooltype_PRELOADSIZE(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; Tooltype "PRELOADSIZE" gefunden ?
	beq.s	rd_check_tooltype_quitkey ; Nein -> verzweige
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
rd_copy_preloadsize_value_loop
	move.b	(a0)+,(a2)+
	bne.s	rd_copy_preloadsize_value_loop

; ** WHD-Load Tooltype QUITKEY **
rd_check_tooltype_quitkey
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
	beq.s	rd_convert_quitkey_hexvalue ; Ja -> verzweige
rd_copy_quitkey_value_loop
	move.b	(a0)+,(a2)+		; QUITKEY-Wert nach Kommando-String kopieren
	bne.s	rd_copy_quitkey_value_loop
	bsr.s	rd_convert_quitkey_hexvalue
rd_free_whdload_disk_object
	move.l	whdl_disk_object(a3),a0 ; Zeiger auf Disk-Objekt-Struktur
	CALLLIBS FreeDiskObject
	moveq	#RETURN_OK,d0
	rts


; Input
; a0	... Zeiger auf String
; a2	... Zeiger auf Kommando-String
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rd_convert_quitkey_hexvalue
	addq.w	#1,a0			; "$"-Zeichen in String überspringen
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr.s	rd_ascii_to_hex
	move.l	d0,d1			; Dezimalzahl
	move.l	a2,a0			; Zeiger auf Kommando-String
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bsr	rp_dec_to_ascii
	clr.b	(a0)			; Nullbyte in Kommando-String setzen
	rts


; Input
; a0	... Zeiger auf String
; d7.l	... Anzahl der Stellen zum Umwandeln
; Result
; d0.l	... Rückgabewert: Hexadezimalzahl
	CNOP 0,4
rd_ascii_to_hex
	add.l	d7,a0			; Zeiger auf Ende des Strings
	moveq	#0,d0			; Hexadezimalzahl
	moveq	#0,d2			; Erster Hex-Stellenwert 16^0 als Shiftwert 0
	subq.w	#1,d7			; wegen dbf
rd_ascii_to_hex_loop
	moveq	#0,d1
	move.b	-(a0),d1		; ASCII-Wert lesen
	sub.b	#"0",d1			; ASCII-Wert "0" abziehen = 0..9
	cmp.b	#9,d1			; Hex-Ziffern 0..9 ?
	ble.s	rd_ascii_to_hex_skip	; Ja -> verzweige
	subq.b	#7,d1			; ASCII-Wert "A" abziehen
	cmp.b	#15,d1			; Hex-Ziffern A..F ?
	ble.s	rd_ascii_to_hex_skip	; Ja -> verzweige
	sub.b	#32,d1			; Ansonsten ASCII-Wert "a" abziehen für Hex-Ziffern a..f
rd_ascii_to_hex_skip
	lsl.l	d2,d1			; Hex-Stellenwert (16^0,16^1,16^2,...)
	addq.w	#4,d2			; Shiftwert um 16^n erhöhen
	add.l	d1,d0			; Stelle zum Ergebnis addieren
	dbf	d7,rd_ascii_to_hex_loop
	rts


	CNOP 0,4
adl_wait_drives_motor
	MOVEF.L	adl_drives_motor_delay,d1
	CALLDOSQ Delay


	CNOP 0,4
rd_init_timer_start
	move.w	rd_play_duration(a3),d1
	move.w	d1,rd_timer_delay(a3)
	bne	rp_create_output_string
	move.l	rd_demofile_path(a3),a0
	add.w	pqe_playtime(a0),d1
	bne	rp_create_output_string
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_start_timer
	tst.w	rd_timer_delay(a3)
	bne.s	rd_set_timer_play_duration
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
rd_set_timer_play_duration
	bsr.s	rd_set_timer
	tst.l	d0
	beq  	rd_write_timer
	rts


; ** Parameter für serielle Schnittstelle initialisieren **
; Input
; Result
; d0.l	... Rückgabewert: Return-Code
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
	beq.s	rd_set_timer_ok
	cmp.b	#SerErr_DevBusy,d0	; Serial-Device bereits in Benutzung ?
	bne.s	rd_check_baud_mismatch	; Ja -> verzweige
	lea	rd_error_text21a(pc),a0
	moveq	#rd_error_text21a_end-rd_error_text21a,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_baud_mismatch
	cmp.b	#SerErr_BaudMismatch,d0	; Baudrate nicht von der Hardware unterstützt ?
	bne.s	rd_check_invalid_parameters
	lea	rd_error_text21b(pc),a0
	moveq	#rd_error_text21b_end-rd_error_text21b,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_invalid_parameters
	cmp.b	#SerErr_InvParam,d0	; Falsche Parameter ?
	bne.s	rd_check_line_error
	lea	rd_error_text21c(pc),a0
	moveq	#rd_error_text21c_end-rd_error_text21c,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_line_error
	cmp.b	#SerErr_LineErr,d0 	; Überlauf der Daten ?
	bne.s	rd_check_no_data_set_ready
	lea	rd_error_text21d(pc),a0
	moveq	#rd_error_text21d_end-rd_error_text21d,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_no_data_set_ready
	cmp.b	#SerErr_NoDSR,d0	; Data-Set nicht bereit ?
	bne.s	rd_set_timer_ok
	lea	rd_error_text21e(pc),a0
	moveq	#rd_error_text21e_end-rd_error_text21e,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_set_timer_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_write_timer
	lea	rd_serial_io(pc),a1
	move.l	a1,a2
	move.w	#CMD_WRITE,io_Command(a1)
	moveq	#output_string_size,d0
	move.l	d0,io_Length(a1)
	lea	rp_output_string(pc),a0
	move.l	a0,io_Data(a1)
	CALLEXEC DoIO
	move.b	io_Error(a2),d0
	beq.s	rd_write_timer_ok
	lea	rd_error_text22(pc),a0
	moveq	#rd_error_text22_end-rd_error_text22,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_write_timer_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_save_custom_trap_vectors
	GET_CUSTOM_TRAP_VECTORS
	move.l	d0,rd_custom_trap_vectors(a3)
	rts


	CNOP 0,4
rd_downgrade_cpu
	lea	rp_read_vbr(pc),a5
	CALLEXEC Supervisor
	move.l	d0,rd_old_vbr(a3)
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_TURBO,pqe_runmode(a0)
	bne.s	rd_check_vbr1
	rts
	CNOP 0,4
rd_check_vbr1
	tst.l	rd_old_vbr(a3)
	beq.s	rd_check_060_cpu1
	moveq	#0,d1
	lea	rd_write_vbr(pc),a5
	CALLLIBS Supervisor		; VBR auf $000000 zurücksetzen
rd_check_060_cpu1
	tst.b	AttnFlags+1(a6)
	bpl.s	rd_disable_caches_mmu
; ** 68060 **
	moveq	#0,d1			; Alle Bits in CACR löschen
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a0)
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
	cmp.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a0)
	bne.s	rd_disable_caches
	and.b	#~(CACRF_EnableI),d1	; Instruction-Cache nicht ausschalten
rd_disable_caches
	CALLEXEC CacheControl		; CPU neu konfigurieren und Caches flushen
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


	CNOP 0,4
rd_save_chips_registers
	CALLEXEC Disable
	lea	rd_old_chips_registers(pc),a0
	move.l	#_CUSTOM,a6
	move.w	DMACONR(a6),ocr_dmacon(a0)
	move.w	INTENAR(a6),ocr_intena(a0)
	move.w	ADKCONR(a6),ocr_adkcon(a0)

	move.l	#_CIAB,a5
	lea	_CIAA-_CIAB(a5),a4	; CIA-A-Base
	move.b	CIAPRA(a4),ocr_ciaa_pra(a0)
	move.b	CIACRA(a4),d0
	move.b	d0,d1		
	move.b	d0,ocr_ciaa_cra(a0)
	and.b	#~(CIACRAF_START),d0	; Timer stoppen
	or.b	#CIACRAF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRA(a4)
	nop
	move.b	CIATALO(a4),ocr_ciaa_talo(a0)
	move.b	CIATAHI(a4),ocr_ciaa_tahi(a0)
	btst	#CIACRAB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciaa_cra1	; Nein -> verzweige
	or.b	#CIACRAF_START,d1	; Timer wieder starten
rd_set_ciaa_cra1
	move.b	d1,CIACRA(a4)
	move.b	CIACRB(a4),d0
	move.b	d0,d1		
	move.b	d0,ocr_ciaa_crb(a0)
	and.b	#~(CIACRBF_ALARM-CIACRBF_START),d0 ; Timer stoppen
	or.b	#CIACRBF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRB(a4)
	nop
	move.b	CIATBLO(a4),ocr_ciaa_tblo(a0)
	move.b	CIATBHI(a4),ocr_ciaa_tbhi(a0)
	btst	#CIACRBB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciaa_crb1	; Nein -> verzweige
	or.b	#CIACRBF_START,d1	; Timer wieder starten
rd_set_ciaa_crb1
	move.b	d1,CIACRB(a4)

	move.b	CIAPRB(a5),ocr_ciab_prb(a0)
	move.b	CIACRA(a5),d0
	move.b	d0,d1		
	move.b	d0,ocr_ciaa_cra(a0)
	and.b	#~(CIACRAF_START),d0	; Timer stoppen
	or.b	#CIACRAF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRA(a5)
	nop
	move.b	CIATALO(a5),ocr_ciab_talo(a0)
	move.b	CIATAHI(a5),ocr_ciab_tahi(a0)
	btst	#CIACRAB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciab_cra1	; Nein -> verzweige
	or.b	#CIACRAF_START,d1	; Timer wieder starten
rd_set_ciab_cra1
	move.b	d1,CIACRA(a5)
	move.b	CIACRB(a5),d0
	move.b	d0,d1		
	move.b	d0,ocr_ciab_crb(a0)
	and.b	#~(CIACRBF_ALARM-CIACRBF_START),d0 ;Timer stoppen
	or.b	#CIACRBF_LOAD,d0	; Zählwert laden
	move.b	d0,CIACRB(a5)
	nop
	move.b	CIATBLO(a5),ocr_ciab_tblo(a0)
	move.b	CIATBHI(a5),ocr_ciab_tbhi(a0)
	btst	#CIACRBB_RUNMODE,d1	; Continuous-Modus ?
	bne.s	rd_set_ciab_crb1	; Nein -> verzweige
	or.b	#CIACRBF_START,d1	; Timer wieder starten
rd_set_ciab_crb1
	move.b	d1,CIACRB(a5)
	CALLEXECQ Enable


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_run_demofile
	IFEQ adl_restore_adl_code_enabled
		SET_RESTORE_ADL_ACTIVE ; Reset-Level-7-Interrupt aktivieren
	ENDC
	tst.w	whdl_slave_enabled(a3)
	beq.s	rd_execute_whdload_slave
	moveq	#rd_shell_cmd_line_end-rd_shell_cmd_line,d0
	lea	rd_shell_cmd_line(pc),a0
	move.l	a3,-(a7)
	move.l	rd_demofile_seglist(a3),a3
	add.l	a3,a3			; BCPL-Zeiger
	add.l	a3,a3
	jsr	FirstCode(a3)		; Demo ausführen
	move.l	(a7)+,a3
	move.l	#_CUSTOM+DMACONR,a0
rd_run_demofile_loop
	btst	#DMAB_BLTDONE-8,(a0)	; Auf eventuell noch laufende Blits warten
	bne.s	rd_run_demofile_loop
	tst.w	rd_arg_softreset_enabled(a3)
	bne.s   rd_run_demofile_ok
	move.l	rd_demofile_path(a3),a0
	CALLEXECQ ColdReboot
	CNOP 0,4
rd_run_demofile_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_execute_whdload_slave
	lea	whdl_slave_cmd_line(pc),a0
	move.l	a0,d1			; Zeiger auf Kommandozeile
	moveq	#0,d2			; Keine Tags
	CALLDOS SystemTagList
	tst.l	d0
	beq.s	rd_check_arg_softreset_enabled
	lea	rd_error_text23(pc),a0
	moveq	#rd_error_text23_end-rd_error_text23,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_arg_softreset_enabled
	tst.w	rd_arg_softreset_enabled(a3)
	bne.s	rd_execute_whdload_slave_ok
	move.l	rd_demofile_path(a3),a0
	CALLEXECQ ColdReboot
	CNOP 0,4
rd_execute_whdload_slave_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_clear_chips_registers
	CALLEXEC Disable
	move.l	#_CUSTOM,a0
	move.w	#$7fff,d0
	move.w	d0,DMACON(a0)		; DMA aus

	move.w	d0,INTENA(a0)		; Interrupts aus
	move.w	d0,INTREQ(a0)		; Interrupts löschen
	move.w	d0,ADKCON(a0)

	moveq	#0,d0
	move.w	d0,COPCON(a0)		; Copper kann nicht auf Blitterregister zugreifen
	move.w	d0,AUD0VOL(a0)		; Lautstärke aus
	move.w	d0,AUD1VOL(a0)
	move.w	d0,AUD2VOL(a0)
	move.w	d0,AUD3VOL(a0)

	move.l	#_CIAB,a5
	lea	_CIAA-_CIAB(a5),a4 	; CIA-A-Base
	moveq	#$7f,d0
	move.b	d0,CIAICR(a4)		; Interrupts aus
	move.b	d0,CIAICR(a5)
	move.b	CIAICR(a4),d0		; Interrupts löschen
	move.b	CIAICR(a5),d0
	CALLLIBQ Enable


	CNOP 0,4
rd_restore_chips_registers
	CALLEXEC Disable
	lea	rd_old_chips_registers(pc),a0
	move.b	ocr_ciaa_pra(a0),CIAPRA(a4)

	move.b	ocr_ciaa_talo(a0),CIATALO(a4)
	nop
	move.b	ocr_ciaa_tahi(a0),CIATAHI(a4)

	move.b	ocr_ciaa_tblo(a0),CIATBLO(a4)
	nop
	move.b	ocr_ciaa_tbhi(a0),CIATBHI(a4)

	move.b	ocr_ciaa_icr(a0),d0
	tas	d0			; Bit 7 ggf. setzen
	move.b	d0,CIAICR(a4)

	move.b	ocr_ciaa_cra(a0),d0
	btst	#CIACRAB_RUNMODE,d0	; Continuous-Modus ?
	bne.s	rd_set_ciaa_cra2	; Nein -> verzweige
	or.b	#CIACRAF_START,d0	; Timer wieder starten
rd_set_ciaa_cra2
	move.b	d0,CIACRA(a4)

	move.b	ocr_ciaa_crb(a0),d0
	btst	#CIACRBB_RUNMODE,d0 	; Continuous-Modus ?
	bne.s	rd_set_ciaa_crb2	; Nein -> verzweige
	or.b	#CIACRBF_START,d0	; Timer wieder starten
rd_set_ciaa_crb2
	move.b	d0,CIACRB(a4)

	move.b	ocr_ciab_prb(a0),CIAPRB(a5)

	move.b	ocr_ciab_talo(a0),CIATALO(a5)
	nop
	move.b	ocr_ciab_tahi(a0),CIATAHI(a5)

	move.b	ocr_ciab_tblo(a0),CIATBLO(a5)
	nop
	move.b	ocr_ciab_tbhi(a0),CIATBHI(a5)

	move.b	ocr_ciab_icr(a0),d0
	tas	d0			; Bit 7 ggf. setzen
	move.b	d0,CIAICR(a5)

	move.b	ocr_ciab_cra(a0),d0
	btst	#CIACRAB_RUNMODE,d0 	; Continuous-Modus ?
	bne.s	rd_set_ciab_cra2 	; Nein -> verzweige
	or.b	#CIACRAF_START,d0	; Timer wieder starten
rd_set_ciab_cra2
	move.b	d0,CIACRA(a5)

	move.b	ocr_ciab_crb(a0),d0
	btst	#CIACRBB_RUNMODE,d0	; Continuous-Modus ?
	bne.s	rd_set_ciab_crb2	; Nein -> verzweige
	or.b	#CIACRBF_START,d0	; Timer wieder starten
rd_set_ciab_crb2
	move.b	d0,CIACRB(a5)

	move.l	#_CUSTOM,a1
	move.w	ocr_dmacon(a0),d0
	or.w	#DMAF_SETCLR,d0
	move.w	d0,DMACON(a1)
	move.w	ocr_intena(a0),d0
	or.w	#INTF_SETCLR,d0
	move.w	d0,INTENA(a1)
	move.w	ocr_adkcon(a0),d0
	or.w	#ADKF_SETCLR,d0
	move.w	d0,ADKCON(a1)
	CALLLIBQ Enable


	CNOP 0,4
rd_upgrade_cpu
	move.l	rd_demofile_path(a3),a0
	cmp.b   #RUNMODE_TURBO,pqe_runmode(a0)
	bne.s	rd_restore_vbr
	rts
	CNOP 0,4
rd_restore_vbr
	move.l	_SysBase(pc),a6
	move.l	rd_old_vbr(a3),d1
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
	CALLEXEC CacheControl		; CPU neu konfigurieren und Caches flushen
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


	CNOP 0,4
rd_restore_custom_trap_vectors
	move.l	rd_old_vbr(a3),d0
	beq.s	rd_restore_only_chip_memory
	move.l	d0,a1			; Ziel: Fast-Memory
	add.w	#TRAP_0_VECTOR,a1	; Ab Trap0-Vektor
	bsr.s	rd_copy_custom_trap_vectors
rd_restore_only_chip_memory
	move.w	#TRAP_0_VECTOR,a1	; Ab Trap0-Vektor
	bsr.s	rd_copy_custom_trap_vectors
	CALLEXECQ CacheClearU


	CNOP 0,4
rd_copy_custom_trap_vectors
	move.l	rd_custom_trap_vectors(a3),a0
	IFEQ adl_restore_adl_code_enabled
		moveq	#8-1,d7		; Anzahl der Trap-Vektoren
	ELSE
		moveq	#7-1,d7		; Anzahl der Trap-Vektoren
	ENDC
rd_copy_custom_trap_vectors_loop
	move.l	(a0)+,(a1)+	 	; Vektor kopieren
	dbf	d7,rd_copy_custom_trap_vectors_loop
	rts


	CNOP 0,4
rd_init_timer_stop
	tst.w	rd_timer_delay(a3)
	bne.s   rd_init_timer_stop_skip
	rts
	CNOP 0,4
rd_init_timer_stop_skip
	moveq	#0,d1			; Timer stoppen
	bra     rp_create_output_string


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
rd_stop_timer
	bsr	rd_set_timer
	tst.l	d0
	beq	rd_write_timer
	rts


	CNOP 0,4
rd_unload_demofile
	move.l	rd_demofile_seglist(a3),d1
	bne.s	rd_unload_demofile_skip
	rts
	CNOP 0,4
rd_unload_demofile_skip
	CALLDOSQ UnLoadSeg


	CNOP 0,4
rd_free_fast_memory
	move.l	rd_demofile_path(a3),a0
	cmp.b   #RUNMODE_TURBO,pqe_runmode(a0)
	bne.s	rd_check_available_fast_memory
	rts
	CNOP 0,4
rd_check_available_fast_memory
	move.l	rd_available_fast_memory(a3),d2
	bne.s	rd_turn_on_fast_memory
	rts
	CNOP 0,4
rd_turn_on_fast_memory
	move.l	_SysBase(pc),a6
	move.l	d2,a2		
rd_turn_on_fast_memory_loop
	move.l	(a2)+,d0		; Größe des Speicherbereichs
	beq.s	rd_free_first_memory_block
	move.l	(a2)+,a1		; Zeiger auf Speicherbereich
	CALLLIBS FreeMem
	bra.s	rd_turn_on_fast_memory_loop
	CNOP 0,4
rd_free_first_memory_block
	move.l	d2,a1			; Zeiger auf ersten größten Block
	move.l	rd_available_fast_memory_size(a3),d0 ; Größe des ersten größten Blocks
	CALLLIBQ FreeMem


	CNOP 0,4
rd_restore_sprite_resolution
	move.l	rd_pal_screen(a3),a2
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tag_list(pc),a1
	move.l	#VTAG_SPRITERESN_SET,vctl_VTAG_SPRITERESN+ti_tag(a1)
	move.l	rd_old_sprite_resolution(a3),vctl_VTAG_SPRITERESN+ti_data(a1)
	CALLGRAF VideoControl		; Sprite-Auflösung zurücksetzen
	move.l	a2,a0			; Zeiger auf Screen
	CALLINT MakeScreen
	CALLLIBQ RethinkDisplay


	CNOP 0,4
rd_close_invisible_window
	move.l	rd_invisible_window(a3),a0
	CALLINTQ CloseWindow


	CNOP 0,4
rd_close_pal_screen
	move.l	rd_pal_screen(a3),a0
	CALLINTQ CloseScreen


	CNOP 0,4
sf_fade_in_screen
	tst.w	rd_arg_fader_enabled(a3)
	beq.s	sf_fade_in_screen_loop
	rts
	CNOP 0,4
sf_fade_in_screen_loop
	CALLGRAF WaitTOF
	bsr	screen_fader_in
	bsr	sf_set_new_colors
	tst.w	sfi_active(a3)
	beq.s	sf_fade_in_screen_loop
	rts


	CNOP 0,4
screen_fader_in
	MOVEF.W	sf_colors_number*3,d6 ; Zähler
	move.l	sf_screen_color_cache(a3),a0 ; Puffer für Farbwerte
	addq.w	#4,a0                   ; Offset überspringen
	move.w	#sfi_fader_speed,a4	; Additions-/Subtraktionswert für RGB-Werte
	move.l	sf_screen_color_table(a3),a1 ; Sollwerte
	MOVEF.W	sf_colors_number-1,d7 ; Anzahl der Farben
screen_fader_in_loop
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

	cmp.w	d3,d0
	bgt.s	sfi_decrease_red
	blt.s	sfi_increase_red
sfi_matched_red
	subq.w	#1,d6			; Ziel-Rotwert erreicht
sfi_check_green_byte
	cmp.w	d4,d1
	bgt.s	sfi_decrease_green
	blt.s	sfi_increase_green
sfi_matched_green
	subq.w	#1,d6			; Ziel-Grünwert erreicht
sfi_check_blue_byte
	cmp.w	d5,d2
	bgt.s	sfi_decrease_blue
	blt.s	sfi_increase_blue
sfi_matched_blue
	subq.w	#1,d6			; Ziel-Blauwert erreicht

sfi_set_rgb_bytes
	move.b	d0,(a0)+		; 4x 8-Bit Rotwert in Cache schreiben
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d0,(a0)+
	move.b	d1,(a0)+		; 4x 8-Bit Grünwert in Cache schreiben
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d1,(a0)+
	move.b	d2,(a0)+		; 4x 8-Bit Blauwert in Cache schreiben
	move.b	d2,(a0)+
	addq.w	#8,a1			; nächstes 32-Bit-Tripple (4*3)
	move.b	d2,(a0)+
	addq.w	#4,a1
	move.b	d2,(a0)+
	dbf	d7,screen_fader_in_loop
	tst.w	d6			; Fertig mit ausblenden ?
	bne.s	sfi_flush_caches	; Nein -> verzweige
	move.w	#FALSE,sfi_active(a3)	; Fading-In aus
sfi_flush_caches
	CALLEXEC CacheClearU
	rts
	CNOP 0,4
sfi_decrease_red
	sub.w	a4,d0
	cmp.w	d3,d0
	bgt.s	sfi_check_green_byte
	move.w	d3,d0
	bra.s	sfi_matched_red
	CNOP 0,4
sfi_increase_red
	add.w   a4,d0
	cmp.w   d3,d0
	blt.s   sfi_check_green_byte
	move.w  d3,d0
	bra.s   sfi_matched_red
	CNOP 0,4
sfi_decrease_green
	sub.w	a4,d1
	cmp.w	d4,d1
	bgt.s	sfi_check_blue_byte
	move.w	d4,d1
	bra.s	sfi_matched_green
	CNOP 0,4
sfi_increase_green
	add.w	a4,d1
	cmp.w	d4,d1
	blt.s	sfi_check_blue_byte
	move.w	d4,d1
	bra.s	sfi_matched_green
	CNOP 0,4
sfi_decrease_blue
	sub.w	a4,d2
	cmp.w	d5,d2
	bgt.s	sfi_set_rgb_bytes
	move.w	d5,d2
	bra.s	sfi_matched_blue
	CNOP 0,4
sfi_increase_blue
	add.w	a4,d2
	cmp.w	d5,d2
	blt.s	sfi_set_rgb_bytes
	move.w	d5,d2
	bra.s	sfi_matched_blue


	CNOP 0,4
rd_check_active_screen_priority
	tst.l	rd_active_screen(a3)
	bne.s	rd_get_first_screen
	rts
	CNOP 0,4
rd_get_first_screen
	moveq	#0,d0			; alle Locks
	CALLINT LockIBase
	move.l	d0,a0
	move.l	ib_FirstScreen(a6),a2
	CALLLIBS UnLockIBase
	cmp.l	rd_active_screen(a3),a2
	bne.s	rd_active_screen_to_front
	rts
	CNOP 0,4
rd_active_screen_to_front
	move.l	rd_active_screen(a3),a0
	CALLLIBQ ScreenToFront


	CNOP 0,4
rd_restore_current_dir
	move.l	rd_old_current_dir_lock(a3),d1
	CALLDOS CurrentDir
	move.l	rd_demofile_dir_lock(a3),d1
	CALLLIBQ Unlock


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_check_queue
	move.l	adl_entries_buffer(a3),a0
	ADDF.W	pqe_entry_active,a0
	MOVEF.L	playback_queue_entry_size,d0
	move.w	adl_entries_number(a3),d7
	subq.w 	#1,d7			; wegen dbf
rd_check_queue_loop
	tst.b	(a0)
	beq.s	rd_check_queue_ok
	add.l	d0,a0			; nächster Eintrag
	dbf	d7,rd_check_queue_loop
	tst.w 	rd_arg_endless_enabled(a3)
	bne.s   rd_queue_played
	bsr.s	rd_deactivate_queue
rd_check_queue_ok
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
rd_queue_played
	lea	rd_message_text1(pc),a0
	moveq	#rd_message_text1_end-rd_message_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_WARN,d0
	rts


	CNOP 0,4
rd_deactivate_queue
	moveq 	#0,d0
	MOVEF.L	playback_queue_entry_size,d1
	move.l	adl_entries_buffer(a3),a0
	ADDF.W	pqe_entry_active,a0
	move.w	adl_entries_number(a3),d7
	subq.w  #1,d7			; wegen dbf
rd_deactivate_queue_loop
	move.b	d0,(a0)			; Status löschen
	add.l	d1,a0			; nächster Eintrag
	dbf	d7,rd_deactivate_queue_loop
	move.w	#adl_entries_number_min,rd_entry_offset(a3)
	GET_RESIDENT_ENTRY_OFFSET
	move.l	d0,a0
	move.w	#adl_entries_number_min,(a0)
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_check_user_break
	moveq	#0,d0			; Keine neuen Signale
	moveq	#0,d1			; Signal-Maske
	CALLEXEC SetSignal
	btst	#SIGBREAKB_CTRL_C,d0
	beq.s	rd_check_user_break_ok
	lea	rd_message_text2(pc),a0
	moveq	#rd_message_text2_end-rd_message_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_user_break_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
rd_reset_demo_variables
	tst.w	rd_arg_loop_enabled(a3)
        beq.s	rd_reset_demo_variables_skip1
	rts
	CNOP 0,4
rd_reset_demo_variables_skip1
	moveq	#0,d0
	move.l	d0,rd_demofile_seglist(a3)
	tst.w	rd_arg_prerunscript_enabled(a3)
	beq.s	rd_reset_demo_variables_skip2
	move.l	d0,rd_prerunscript_path(a3)
rd_reset_demo_variables_skip2
	move.w	#FALSE,whdl_slave_enabled(a3)
	move.w	rd_arg_fader_enabled(a3),sfo_active(a3)
	move.w	rd_arg_fader_enabled(a3),sfi_active(a3)
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
rd_check_arg_loop_enabled
	tst.w	rd_arg_loop_enabled(a3)
	beq.s	rd_check_loop_mode_ok
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
rd_check_loop_mode_ok
	moveq	#RETURN_OK,d0
	rts


	CNOP 0,4
sf_free_screen_color_cache
	move.l	sf_screen_color_cache(a3),d0
	bne.s	sf_free_screen_color_cache_skip
	rts
	CNOP 0,4
sf_free_screen_color_cache_skip
	move.l	d0,a1
	MOVEF.L	(1+(sf_colors_number*3)+1)*LONGWORD_SIZE,d0
	CALLEXECQ FreeMem


	CNOP 0,4
sf_free_screen_color_table
	move.l	sf_screen_color_table(a3),d0
	bne.s	sf_free_screen_color_table_skip
	rts
	CNOP 0,4
sf_free_screen_color_table_skip
	move.l	d0,a1
	MOVEF.L	sf_colors_number*3*LONGWORD_SIZE,d0
	CALLEXECQ FreeMem


	CNOP 0,4
rd_free_cleared_sprite_data
	move.l	rd_cleared_sprite_pointer_data(a3),a1
	moveq	#sprite_pointer_data_size,d0
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


; **** Exception-Routinen ****

; Input
; d1.l	... neuer Inhalt von VBR
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rd_write_vbr
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	movec.l d1,VBR
	nop
	rte


; Input
; d1.l	... neuer Inhalt von CACR
; Result
; d0.l	... Rückgabewert: alter Inhalt von CACR
	MC68040
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


; Input
; a1	... Zeiger auf Speicherbereich für alte Werte
; a3	... Zeiger auf Variablen-Base
; Result
; d0	... Kein Rückgabewert
	MC68040
	CNOP 0,4
rd_040_060_mmu_off
	move.l	#$0000c040,d1		; DTT0 Cache inhibited, precise für Speicherbereich $00000000-$00ffffff (Zorro II)
	move.l	#$00ffc000,d2		; DTT1/ITT1 Cachable, writethrough für Speicherbereich $00000000-$ffffffff (Zorro II/III)
	move.l	d2,d3			; ITT0=DTT1 Cachable für Speicherbereich $00000000-$ffffffff (Zorro II/III)
	moveq	#0,d4			; TC MMU aus
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_OCS_VANILLA,pqe_runmode(a0)
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


; Input
; a1	... Zeiger auf Speicherbereich für alte Werte
; Result
; d0	... Kein Rückgabewert
	MC68030
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


; Input
; d1.l	... neuer Inhalt von PCR
; Result
; d0.l	... alter Inhalt von PCR
	MC68040
	CNOP 0,4
rd_060_superscalar_off
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ;Level-7-Interruptebene
	nop
	DC.L	$4e7a0808		; movec.l PCR,d0: Alter Inhalt
	nop
	DC.L	$4e7b1808		; movec.l d1,PCR: Neuer Inhalt
	nop
	rte


; Input
; d1.l	... alter Inhalt von PCR
; Result
; d0	... Kein Rückgabewert
	MC68040
	CNOP 0,4
rd_060_superscalar_on
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	DC.L	$4e7b1808		; movec.l d1,PCR
	nop
	rte


; Input
; a1	... Zeiger auf Speicherbereich für alte Werte
; Result
; d0	... Kein Rückgabewert
	MC68040
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


; Input
; a1	... Zeiger auf Speicherbereich für alte Werte
; Result
; d0	... Kein Rückgabewert
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


; Input
; d1.l	... alter Inhalt von CACR
; Result
; d0	... Kein Rückgabewert
	MC68040
	CNOP 0,4
rd_060_caches_on
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	CPUSHA	BC			; Instruction/Data/Branch-Caches flushen
	nop
	movec.l d1,CACR
	nop
	rte


; **** Reset-Programm ****
	MC68020
	CNOP 0,4
rp_start
	bra.s	rp_skip1		; Kennung überspringen
	DC.B "DL"			; Kennung "DL"
rp_skip1
	movem.l d0-d7/a0-a6,-(a7)
	move.l	#_CUSTOM,a5
	move.l	exec_base.w,a6
	move.w	#POTGOF_OUTLY+POTGOF_DATLY+POTGOF_OUTLX+POTGOF_DATLX,POTGO(a5)
	moveq	#rp_rasterlines_delay,d7 ; ~320 µs mach Beschreiben des Registers warten
	bsr	rp_wait_rasterline
	btst	#POTINPB_DATLY-8,POTINP(a5)
	bne.s	rp_proceed
	bsr	rp_clear_cool_capture
	bra.s	rp_quit
	CNOP 0,4
rp_proceed
	bsr	rp_init_timer_stop
	bsr	rp_stop_timer
	move.l	#rp_entries_buffer-rp_start,d0
	move.l	rp_reset_program_memory(pc),a1
	moveq	#0,d1
	move.w	rp_entries_number_max(pc),d1
	MULUF.L playback_queue_entry_size,d1,d2 ; Größe des Puffers für Einträge berechnen
	add.l	d1,d0			; Programmlänge + Puffer für Einträge
	CALLLIBS AllocAbs		; Speicher nochmals reservieren
	tst.l	d0
	bne.s	rp_skip2
	move.w	#rp_color_error,d3
	bsr	rp_screen_colour_flash
	bsr	rp_clear_cool_capture
	bra.s	rp_quit
	CNOP 0,4
rp_skip2
	move.w	#rp_color_okay,d3
	bsr	rp_screen_colour_flash
	bsr	rp_restore_custom_cool_capture
	bsr	rp_init_custom_exceptions
rp_quit
	movem.l (a7)+,d0-d7/a0-a6
	rts


; Input
; d7.w	... Anzahl der Rasterzeilen
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rp_wait_rasterline
	move.l	#$0001ff00,d2		; Maske für vertikale Position V0-V8 des Rasterstrahls
	subq.w	#1,d7			; wegen dbf
rp_wait_rasterline_loop1
	move.w	VPOSR(a5),d0		; VPOSR/VHPOSR getrennt auslesen wegen Übertrag-Bit V8
	swap	d0
	move.w	VHPOSR(a5),d0
	and.l	d2,d0			; Nur vertikale Position
rp_wait_rasterline_loop2
	move.w	VPOSR(a5),d1		; VPOSR/VHPOSR getrennt auslesen wegen Übertrag-Bit V8
	swap	d1
	move.w	VHPOSR(a5),d1
	and.l	d2,d1			; Nur vertikale Position V0-V8
	cmp.l	d1,d0			; Immer noch gleiche Zeile ?
	beq.s	rp_wait_rasterline_loop2 ; Ja -> Schleife
	dbf	d7,rp_wait_rasterline_loop1
	rts


; Input
; a6	... Exec-Base
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rp_clear_cool_capture
	moveq	#0,d0
	move.l	d0,CoolCapture(a6)
	bsr	rp_update_exec_checksum
	CALLLIBQ CacheClearU


	CNOP 0,4
rp_init_timer_stop
	moveq	#0,d1			; Timer stoppen
	bra.s	rp_create_output_string


	CNOP 0,4
rp_stop_timer
	bsr	rp_set_timer
  	bra	rp_write_timer


	CNOP 0,4
rp_create_output_string
	lea	rp_output_string(pc),a2
	lea	os_duration(a2),a0
	moveq	#5,d7			; Stringlänge = Anzahl der Stellen zum Umwandeln
	bsr.s	rp_dec_to_ascii
	move.l	a2,a0
	moveq	#os_checksum-output_string,d7 ; Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
	bsr	rp_update_output_checksum
	move.w	d0,d1			; Dezimalzahl
	bsr.s	rp_dec_to_hex
	move.w	d0,d1			; Hexzahl
	lea	os_checksum(a2),a0
	moveq	#2,d7			; Anzahl der Stellen zum Umwandeln
	bra.s	rp_hex_to_ascii


; Input
; d1.w	... Dezimalzahl
; Result
; d0.w	... Rückgabewert: Hexadezimalzahl & $ff
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
	bne.s	rp_dec_to_hex_loop	; Solange Quotient nicht Null -> Schleife
	and.w	#$00ff,d0		; Nur Bits 0-7 (lower Byte)
	rts


; Input
; d1.w	... Dezimalzahl
; d7.w	... Anzahl der Stellen zum Umwandeln
; a0	... Stringadresse
; Result
; d0	... Kein Rückgabewert
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
	bcc.s	rp_dec_to_ascii_loop2	; Wenn kein Übertrag -> verzweige
	add.b	#"0",d3			; Ziffer -> ASCII-Zeichen
	add.l	d2,d1			; Rest berichtigen
	move.b	d3,(a0)+		; Zeichen in String schreiben
	dbf	d7,rp_dec_to_ascii_loop1
	rts


; Input
; d1.w	... Hexadezimalzahl
; d7.w	... Anzahl der Stellen zum Umwandeln
; a0	... Zeiger auf String
; Result
; d0	... Kein Rückgabewert
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
	ble.s	rp_hex_to_ascii_skip	; Ja -> verzweige
	add.b	#39,d0			; 10="a",11="b",..
rp_hex_to_ascii_skip
	lsr.l	#4,d1			; nächstes Nibble
	move.b	d0,-(a0)		; Zeichen in String schreiben
	dbf	d7,rp_hex_to_ascii_loop
	rts


; ** Checksumme aus den ersten 7 ASCII-Zeichen des Ausgabe-Strings bilden **
; Input
; d7.w	... Anzahl der ASCII-Zeichen über die die Checksumme gebildet werden soll
; a0	... Zeiger auf String
; Result
; d0.w	... Rückgabewert: Checksumme
	CNOP 0,4
rp_update_output_checksum
	moveq	#0,d0			; Checksumme
	moveq	#0,d1
	subq.w	#1,d7			; wegen dbf
rp_update_output_checksum_loop
	move.b	(a0)+,d1		; ASCII-Wert
	add.w	d1,d0
	dbf	d7,rp_update_output_checksum_loop
	rts


	CNOP 0,4
rp_set_timer
	CALLLIBS Disable
	move.w	#$0100,d1		; 8 Bits pro Zeichen beim Schreiben, 1 Stoppbit
	lea	rp_old_adkcon(pc),a0
	move.w	ADKCONR(a5),(a0)	; Alten Inhalt von ADKCON retten
	move.w	#ADKF_UARTBRK,ADKCON(a5) ; TXD löschen
	move.w	#(PAL_CLOCK_CONSTANT/adl_baud)-1,SERPER(a5)
	CALLLIBQ Enable


	CNOP 0,4
rp_write_timer
	CALLLIBS Disable
	MOVEF.W	SERDATRF_TBE,d2
	lea	rp_output_string(pc),a0
	moveq	#output_string_size-1,d7 ; Anzahl der Bytes zum Schreiben
rp_write_timer_loop
	move.w	SERDATR(a5),d0
	and.w	d2,d0			; TBE-Bit gesetzt ?
	beq.s	rp_write_timer_loop	; Nein -> verzweige
	move.b	(a0)+,d1		; Datenbyte D0-D7 kopieren
	move.w	d1,SERDAT(a5)		; und Datenwort übertragen
	dbf	d7,rp_write_timer_loop
	move.w	#$7fff,ADKCON(a5)
	move.w	rp_old_adkcon(pc),d0
	or.w	#ADKF_SETCLR,d0
	move.w	d0,ADKCON(a5)
	CALLLIBQ Enable


; Input
; d3.w	... RBG4-Farbwert
; Result
; d0	... Kein Rückgabewert
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
	bsr.s	rp_update_exec_checksum
	CALLLIBQ CacheClearU


; Input
; a6	... Exec-Base
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rp_update_exec_checksum
	moveq	#0,d0
	move.w	d0,LowMemChkSum(a6)	; Checksumme in Execbase löschen
	lea	SoftVer(a6),a0		; Start-Abschnitt in Execbase
	moveq	#((ChkSum-SoftVer)/WORD_SIZE)-1,d1 ; Anzahl Worte, über die Checksumme gebildet wird
rp_update_exec_checksum_loop
	add.w	(a0)+,d0
	dbf	d1,rp_update_exec_checksum_loop
	not.w	d0
	move.w	d0,(a0)			; Neue Checksumme
	rts


	CNOP 0,4
rp_init_custom_exceptions
	lea	rp_read_vbr(pc),a5
	CALLLIBS Supervisor
	move.l	d0,a0
	IFEQ adl_restore_adl_code_enabled
		lea	rp_restore_adl_active(pc),a1
		move.w	#FALSE,(a1)	; Sicherheitshalber
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

	IFEQ adl_restore_adl_code_enabled
		move.l	TRAP_6_VECTOR(a0),(a1)+
	ELSE
		move.l	TRAP_6_VECTOR(a0),(a1)
	ENDC
	lea	rp_trap_6_program(pc),a4
	move.l	a4,TRAP_6_VECTOR(a0)
	IFEQ adl_restore_adl_code_enabled
		move.l	a4,(a2)+
	ELSE
		move.l	a4,(a2)
 	ENDC

	IFEQ adl_restore_adl_code_enabled
		move.l	TRAP_7_VECTOR(a0),(a1)
		lea	rp_trap_7_program(pc),a4
		move.l	a4,TRAP_7_VECTOR(a0)
		move.l	a4,(a2)
	ENDC

	CALLLIBQ CacheClearU


; Input
; a6	... Exec-Base
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rp_restore_old_exceptions
	lea	rp_read_vbr(pc),a5
	CALLLIBS Supervisor
	tst.l	d0			; VBR = $000000 ?
	beq.s	rp_restore_chip_memory	; Ja -> verzweige
	move.l	d0,a1
	IFEQ adl_restore_adl_code_enabled
		move.l	rp_old_level_7_autovector(pc),LEVEL_7_AUTOVECTOR(a1) ; Zeiger alte Level-7-Interrptprogramm eintragen
	ENDC
	add.w	#TRAP_0_VECTOR,a1	; Ab Trap0-Vektor
	bsr.s	rp_copy_old_trap_vectors
rp_restore_chip_memory
	IFEQ adl_restore_adl_code_enabled
		move.l	d0,a1
		move.l	rp_old_level_7_autovector(pc),LEVEL_7_AUTOVECTOR(a1) ; Zeiger alte Level-7-Interrptprogramm eintragen
	ENDC
	move.w	#TRAP_0_VECTOR,a1	; Ab Trap0-Vektor
	bsr.s	rp_copy_old_trap_vectors
	CALLLIBQ CacheClearU


; Input
; a1	... Ziel: Trap#0-Vektor
; Result
; d0	... Kein Rückgabewert
	CNOP 0,4
rp_copy_old_trap_vectors
	lea	rp_old_trap_0_vector(pc),a0
	IFEQ adl_restore_adl_code_enabled
		moveq	#8-1,d7		; Anzahl der Trap-Vektoren
	ELSE
		moveq	#7-1,d7		; Anzahl der Trap-Vektoren
	ENDC
rd_copy_old_trap_vectors_loop
	move.l	(a0)+,(a1)+		; Vektor kopieren
	dbf	d7,rd_copy_old_trap_vectors_loop
	rts


; **** Exception-Routinen ****
	IFEQ adl_restore_adl_code_enabled
		CNOP 0,4
rp_level_7_program
		movem.l d0-d1/a0-a1/a6,-(a7)
		move.w	rp_restore_adl_active(pc),d0
		bne.s	rp_no_reset
		move.l	exec_base.w,a6
		move.l	rp_reset_program_memory(pc),CoolCapture(a6)
		moveq	#0,d0
		move.l	d0,WarmCapture(a6)
		bsr	rp_update_exec_checksum
		CALLLIBS CacheClearU
		CALLLIBQ ColdReboot
		CNOP 0,4
rp_no_reset
		movem.l (a7)+,d0-d1/a0-a1/a6
		nop
		rte
	ENDC


; GET_RESIDENT_ENTRIES_NUMBER
; Input
; Result
; d0.l	... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_0_program
	lea	rp_entries_number(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENTRIES_NUMBER_MAX
; Input
; Result
; d0.l	... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_1_program
	lea	rp_entries_number_max(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENTRY_OFFSET
; Input
; Result
; d0.l	... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_2_program
	lea	rp_entry_offset(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENTRIES_BUFFER
; Input
; Result
; d0.l	... Rückgabewert: Zeiger auf Puffer
	CNOP 0,4
rp_trap_3_program
	lea	rp_entries_buffer(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENDLESS_ENABLED
; Input
; Result
; d0.l	... Rückgabewert: Zeiger auf Variable
	CNOP 0,4
rp_trap_4_program
	lea	rp_endless_enabled(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_CUSTOM_VECTORS
; Input
; Result
; d0.l	... Rückgabewert: Zeiger auf eigene Trap-Vektoren
	CNOP 0,4
rp_trap_5_program
	lea	rp_custom_trap_0_vector(pc),a0
	move.l	a0,d0
	nop
	rte


; REMOVE_RESET_PROGRAM
; Input
; Result
; d0.l	... Rückgabewert: Größe des Reset-Programms mit Puffer
	CNOP 0,4
rp_trap_6_program
	movem.l	a5-a6,-(a7)
	move.l	exec_base.w,a6
	bsr	rp_clear_cool_capture
	bsr	rp_restore_old_exceptions
	lea	rp_reset_program_memory(pc),a0
	move.l	a0,d0
	movem.l	(a7)+,a5-a6
	nop
	rte


	IFEQ adl_restore_adl_code_enabled
; SET_RESTORE_ADL_ACTIVE
		CNOP 0,4
rp_trap_7_program
		lea	rp_restore_adl_active(pc),a0
		clr.w	(a0)
		nop
		rte
	ENDC


; Input
; Result
; d0.l	... Rückgabewert: Inhalt von VBR
	CNOP 0,4
rp_read_vbr
	or.w	#SRF_I0+SRF_I1+SRF_I2,SR ; Level-7-Interruptebene
	nop
	movec.l VBR,d0
	nop
	rte


	CNOP 0,4
rp_dec_table
	DC.L 1,10,100,1000,10000

rp_reset_program_memory		DC.L 0
rp_reset_program_size		DC.L 0

	IFEQ adl_restore_adl_code_enabled
rp_old_level_7_autovector	DC.L 0
	ENDC
rp_old_trap_0_vector		DC.L 0
rp_old_trap_1_vector		DC.L 0
rp_old_trap_2_vector		DC.L 0
rp_old_trap_3_vector		DC.L 0
rp_old_trap_4_vector		DC.L 0
rp_old_trap_5_vector		DC.L 0
rp_old_trap_6_vector		DC.L 0
	IFEQ adl_restore_adl_code_enabled
rp_old_trap_7_vector		DC.L 0
	ENDC
rp_custom_trap_0_vector		DC.L 0
rp_custom_trap_1_vector		DC.L 0
rp_custom_trap_2_vector		DC.L 0
rp_custom_trap_3_vector		DC.L 0
rp_custom_trap_4_vector		DC.L 0
rp_custom_trap_5_vector		DC.L 0
rp_custom_trap_6_vector		DC.L 0
	IFEQ adl_restore_adl_code_enabled
rp_custom_trap_7_vector		DC.L 0
rp_restore_adl_active		DC.W 0
	ENDC

rp_old_adkcon			DC.W 0

rp_entries_number		DC.W 0
rp_entries_number_max		DC.W 0
rp_entry_offset 		DC.W 0
rp_endless_enabled		DC.W 0

rp_output_string		DS.B output_string_size

rp_entries_buffer			; Größe wird später berechnet


; **** Main ****
	CNOP 0,4
_SysBase			DC.L 0
_DOSBase			DC.L 0
_GfxBase			DC.L 0
_IntuitionBase			DC.L 0
_GadToolsBase			DC.L 0
_ASLBase			DC.L 0
_IconBase			DC.L 0
_CIABase			DC.L 0


dos_library_name		DC.B "dos.library",0
	EVEN
graphics_library_name		DC.B "graphics.library",0
	EVEN
intuition_library_name		DC.B "intuition.library",0
	EVEN
gadtools_library_name		DC.B "gadtools.library",0
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
workbench_screen_name		DC.B "Workbench",0
	EVEN
topaz_font_name			DC.B "topaz.font",0
	EVEN


; **** Amiga-Demo-Launcher ****
	CNOP 0,4
adl_variables			DS.B adl_variables_size


	CNOP 0,4
adl_cool_capture_request
	DS.B EasyStruct_SIZEOF


	CNOP 0,4
adl_cmd_results
	DS.B cmd_results_array_size


adl_intro_message_text
	DC.B ASCII_LINE_FEED
	DC.B "    /|  |--\     |      ----+",ASCII_LINE_FEED
	DC.B "   / |  |   \    |         / ",ASCII_LINE_FEED
	DC.B "  /--|  |    \   |        /  ",ASCII_LINE_FEED
	DC.B " /   |  |-----\  |----   +-- ",ASCII_LINE_FEED
	DC.B "                             ",ASCII_LINE_FEED
	DC.B "  B Y   R E S I S T A N C E  ",ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED,"For more information about the usage use the argument HELP",ASCII_LINE_FEED,ASCII_LINE_FEED
adl_intro_message_text_end
	EVEN


adl_cool_capture_request_title
	DC.B "Amiga Demo Launcher message",0
	EVEN
adl_cool_capture_request_body
	DC.B "The CoolCapture vector is already used.",ASCII_LINE_FEED,ASCII_LINE_FEED
	DC.B "Should the Amiga Demo Launcher be installed",ASCII_LINE_FEED
	DC.B "and the other program be disabled?",ASCII_LINE_FEED,0
	EVEN
adl_cool_capture_request_gadgets
	DC.B "Proceed|Quit",0
	EVEN


adl_cmd_usage_text
	DC.B ASCII_LINE_FEED,"Amiga Demo Launcher arguments description:",ASCII_LINE_FEED,ASCII_LINE_FEED
; ** Amiga-Demo-Launcher **
	DC.B "HELP                   This short arguments description",ASCII_LINE_FEED
	DC.B "REMOVE                 Remove Amiga Demo Launcher out of memory",ASCII_LINE_FEED
; ** Demo-Charger **
	DC.B "MAXENTRIES ",155,"3",109,"number 1..n",155,"0",109,"     Set maximum entries number of playback queue",ASCII_LINE_FEED
	DC.B "NEWENTRY               Create new entry in playback queue",ASCII_LINE_FEED
	DC.B "PLAYLIST ",155,"3",109,"file path ",155,"0",109,"    Load and transfer external playlist script file",ASCII_LINE_FEED
; ** Queue-Handler **
	DC.B "SHOWQUEUE              Show content of playback queue",ASCII_LINE_FEED
	DC.B "EDITENTRY ",155,"3",109,"number 1..n",155,"0",109,"      Edit a certain entry of playback queue",ASCII_LINE_FEED
	DC.B "EDITQUEUE              Edit content of playback queue",ASCII_LINE_FEED
	DC.B "CLEARQUEUE             Clear the whole playback queue with all its entries",ASCII_LINE_FEED
	DC.B "RESETQUEUE             Reset entry offset of playback queue to zero and reset all play states",ASCII_LINE_FEED
; ** Run-Demo **
	DC.B "PLAYENTRY ",155,"3",109,"number ",155,"0",109,"      Play a certain entry of playback queue",ASCII_LINE_FEED
	DC.B "PRERUNSCRIPT ",155,"3",109,"file path ",155,"0",109,"Execute prerrun script file before demo is played",ASCII_LINE_FEED
	DC.B "MIN/MINS ",155,"3",109,"number ",155,"0",109,"       Playtime in minutes (reset device needed)",ASCII_LINE_FEED
	DC.B "SEC/SECS ",155,"3",109,"number ",155,"0",109,"       Playtime in seconds (reset device needed)",ASCII_LINE_FEED
	IFEQ adl_lmbexit_code_enabled
		DC.B "LMBEXIT ",155,"3",109,"number 1..9",155,"0",109,"        Play demo multiparts by LMB exit (reset device needed)",ASCII_LINE_FEED
        ENDC
	DC.B "RANDOM                 Play random entry of playback queue",ASCII_LINE_FEED
	DC.B "ENDLESS                Play entries of playback queue endlessly",ASCII_LINE_FEED
	DC.B "LOOP                   Play demos until no more entries left to play",ASCII_LINE_FEED
	DC.B "FADER                  Fade screen to black before demo is played",ASCII_LINE_FEED
	DC.B "SOFTRESET              Automatic reset after quitting demo",ASCII_LINE_FEED,ASCII_LINE_FEED
adl_cmd_usage_text_end
	EVEN


adl_cmd_template
; ** Amiga-Demo-Launcher **
	DC.B "HELP/S,"
	DC.B "REMOVE/S,"
; ** Demo-Charger **
	DC.B "MAXENTRIES/K/N,"
	DC.B "NEWENTRY/S,"
	DC.B "PLAYLIST/K,"
; ** Queue-Handler **
	DC.B "SHOWQUEUE/S,"
	DC.B "EDITENTRY/K/N,"
	DC.B "EDITQUEUE/S,"
	DC.B "CLEARQUEUE/S,"
	DC.B "RESETQUEUE/S,"
; ** Run-Demo **
	DC.B "PLAYENTRY/K/N,"
	DC.B "PRERUNSCRIPT/K,"
	DC.B "MIN=MINS/K/N,"
	DC.B "SEC=SECS/K/N,"
	IFEQ adl_lmbexit_code_enabled
		DC.B "LMBEXIT/K/N,"
        ENDC
	DC.B "RANDOM/S,"
	DC.B "ENDLESS/S,"
	DC.B "LOOP/S,"
	DC.B "FADER/S,"
	DC.B "SOFTRESET/S",0
	EVEN


adl_message_text1
	DC.B ASCII_LINE_FEED,"Amiga Demo Launcher now removed from memory",ASCII_LINE_FEED,ASCII_LINE_FEED
adl_message_text1_end
	EVEN

adl_message_text2
	DC.B ASCII_LINE_FEED,"Amiga Demo Launcher not found",ASCII_LINE_FEED,ASCII_LINE_FEED
adl_message_text2_end
	EVEN


; ** Header für PrintFault() **
adl_error_header
	DC.B " ",0
	EVEN

adl_error_text1
	DC.B ASCII_LINE_FEED,"Couldnt open graphics.library",ASCII_LINE_FEED
adl_error_text1_end
	EVEN
adl_error_text2
	DC.B ASCII_LINE_FEED,"OS 3.0 or better required",ASCII_LINE_FEED
adl_error_text2_end
	EVEN
adl_error_text3
	DC.B ASCII_LINE_FEED,"68020 or better required",ASCII_LINE_FEED
adl_error_text3_end
	EVEN
adl_error_text4
	DC.B ASCII_LINE_FEED,"AGA chipset required",ASCII_LINE_FEED
adl_error_text4_end
	EVEN
adl_error_text5
	DC.B ASCII_LINE_FEED,"PAL machine required",ASCII_LINE_FEED
adl_error_text5_end
	EVEN
adl_error_text6
	DC.B ASCII_LINE_FEED,"Couldn't open gadtools.library",ASCII_LINE_FEED
adl_error_text6_end
	EVEN
adl_error_text7
	DC.B ASCII_LINE_FEED,"Couldn't open intuition.library",ASCII_LINE_FEED
adl_error_text7_end
	EVEN


; **** Demo-Charger ****
	CNOP 0,4
dc_playlist_results_array
	DS.B playlist_results_array_size


	CNOP 0,4
dc_runmode_request
	DS.B EasyStruct_SIZEOF


	CNOP 0,4
dc_file_request_init_tag_list
	DS.B ti_SIZEOF*11

	CNOP 0,4
dc_file_request_display_tag_list
	DS.B ti_SIZEOF*2


dc_playlist_template
	DC.B "demofile,"
	DC.B "OCSVANILLA/S,"
	DC.B "AGAVANILLA/S,"
	DC.B "TURBO/S,"
	DC.B "MIN=MINS/K/N,"
	DC.B "SEC=SECS/K/N,"
	IFEQ adl_lmbexit_code_enabled
		DC.B "LMBEXIT/K/N,"
        ENDC
	DC.B "PRERUNSCRIPT/K",0
	EVEN


dc_parsing_begin_text
	DC.B ASCII_LINE_FEED,"Parsing and transferring playlist to playback queue......"
dc_parsing_begin_text_end
	EVEN
dc_parsing_result_text
	DC.B "done",ASCII_LINE_FEED,ASCII_LINE_FEED
	DC.B "Result: "
dc_transmitted_entries
	DC.B "   "
	DC.B "of "
dc_playlist_entries
	DC.B "   "
	DC.B "entries successfully transferred to playback queue",ASCII_LINE_FEED
dc_parsing_result_text_end
	EVEN


dc_current_dir_name
	DS.B adl_demofile_path_length
	EVEN


dc_file_request_title
	DC.B "Choose up to "
dc_remaining_files
	DC.B "   "
	DC.B "demo"
dc_character_s
	DC.B "s",0
	EVEN


dc_file_request_pattern
	DC.B "~(#?.bin|"
	DC.B "#?.dat|"
	DC.B "#?.data|"
	DC.B "#?.diz|"
	DC.B "#?.info|"
	DC.B "#?.nfo|"
	DC.B "#?.pak|"
	DC.B "#?.readme|"
	DC.B "#?.txt|"
	DC.B "#?.vars|"
	DC.B "_dl.#?)",0
	EVEN
dc_file_request_ok
	DC.B "Use",0
	EVEN
dc_file_request_quit
	DC.B "Quit",0
	EVEN


dc_runmode_request_title
	DC.B "Define run mode",0
	EVEN
dc_runmode_request_body
	DC.B "In which mode should the demo run?",ASCII_LINE_FEED,0
	EVEN
dc_runmode_request_gadgets
	DC.B "OCS vanilla|AGA vanilla|turbo",0
	EVEN


dc_message_text
	DC.B ASCII_LINE_FEED,"Maximum number of entries in playback queue already reached",ASCII_LINE_FEED,ASCII_LINE_FEED
dc_message_text_end
	EVEN

dc_error_text1
	DC.B ASCII_LINE_FEED,"Couldn't allocate entries/playback queue buffer"
dc_error_text1_end
	EVEN
dc_error_text2
	DC.B ASCII_LINE_FEED,"Couldn't find playlist file",ASCII_LINE_FEED
dc_error_text2_end
	EVEN
dc_error_text3
	DC.B ASCII_LINE_FEED,"Couldn't allocate file info block structure"
dc_error_text3_end
	EVEN
dc_error_text4
	DC.B ASCII_LINE_FEED,"Couldn't examine playlist file",ASCII_LINE_FEED
dc_error_text4_end
	EVEN
dc_error_text5
	DC.B ASCII_LINE_FEED,"Couldn't allocate memory for playlist file"
dc_error_text5_end
	EVEN
dc_error_text6
	DC.B ASCII_LINE_FEED,"Couldn't open playlist file",ASCII_LINE_FEED
dc_error_text6_end
	EVEN
dc_error_text7
	DC.B ASCII_LINE_FEED,"Playlist file read error",ASCII_LINE_FEED
dc_error_text7_end
	EVEN
dc_error_text8
	DC.B ASCII_LINE_FEED,"Couldn't allocate dos object",ASCII_LINE_FEED
dc_error_text8_end
	EVEN
dc_error_text9
	DC.B ASCII_LINE_FEED,"Entry "
dc_entries_string
	DC.B "	  "
	DC.B "could not be transferred. Playlist arguments syntax error",ASCII_LINE_FEED,ASCII_LINE_FEED
dc_error_text9_end
	EVEN
dc_error_text10
	DC.B ASCII_LINE_FEED,"Couldn't open asl.library",ASCII_LINE_FEED
dc_error_text10_end
	EVEN
dc_error_text11
	DC.B ASCII_LINE_FEED,"Couldn't find program directory",ASCII_LINE_FEED
dc_error_text11_end
	EVEN
dc_error_text12
	DC.B ASCII_LINE_FEED,"Couldn't get program directory name"
dc_error_text12_end
	EVEN
dc_error_text13
	DC.B ASCII_LINE_FEED,"Couldn't initialize file requester structure",ASCII_LINE_FEED
dc_error_text13_end
	EVEN
dc_error_text14
	DC.B ASCII_LINE_FEED,"Directory not found"
dc_error_text14_end
	EVEN
dc_error_text15
	DC.B ASCII_LINE_FEED,"No demo file selected"
dc_error_text15_end
	EVEN
dc_error_text16
	DC.B ASCII_LINE_FEED,"Demo filepath is longer than 123 characters"
dc_error_text16_end
	EVEN
dc_error_text17
	DC.B ASCII_LINE_FEED,"Demo file not found"
dc_error_text17_end
	EVEN
dc_error_text18
	DC.B ASCII_LINE_FEED,"Couldn't allocate memory for resident program"
dc_error_text18_end
	EVEN


; **** Queue-Handler ****
	CNOP 0,4
qh_get_visual_info_tag_list	DS.L 1


	CNOP 0,4
qh_edit_window_tag_list		DS.B edit_window_tag_list_size


	CNOP 0,4
qh_button_gadget_tag_list	DS.L 3

	CNOP 0,4
qh_set_button_gadget_tag_list	DS.L 3


	CNOP 0,4
qh_text_gadget_tag_list		DS.L 5

	CNOP 0,4
qh_set_text_gadget_tag_list	DS.L 3


	CNOP 0,4
qh_integer_gadget_tag_list	DS.L 5

	CNOP 0,4
qh_set_integer_gadget_tag_list	DS.L 3


	CNOP 0,4
qh_cycle_gadget_tag_list	DS.L 5


	CNOP 0,4
qh_set_cycle_gadget_tag_list	DS.L 3


	CNOP 0,4
qh_cycle_gadget_array		DS.L 4


	CNOP 0,4
qh_mx_gadget_tag_list		DS.L 5

	CNOP 0,4
qh_set_mx_gadget_tag_list 	DS.L 3

	CNOP 0,4
qh_mx_gadget_array		DS.L 3


	CNOP 0,4
qh_gadget_list			DS.L 1


	CNOP 0,4
qh_new_gadget			DS.B gng_SIZEOF


	CNOP 0,4
qh_topaz_80			DS.B ta_SIZEOF


qh_bwd_button_gadget_text	DC.B "<",0
	EVEN

qh_fwd_button_gadget_text	DC.B ">",0
	EVEN

qh_cycle_gadget_choice_text1	DC.B "Turbo",0
	EVEN

qh_cycle_gadget_choice_text2	DC.B "OCS vanilla",0
	EVEN

qh_cycle_gadget_choice_text3	DC.B "AGA vanilla",0
	EVEN


qh_mx_gadget_text1		DC.B "Not played",0
	EVEN

qh_mx_gadget_text2		DC.B "Played",0
	EVEN


qh_pos_button_gadget_text	DC.B "Save",0
	EVEN

qh_neg_button_gadget_text	DC.B "Quit",0
	EVEN


qh_show_entry_header
	DC.B ASCII_LINE_FEED,"Nr."
qh_show_entry_current_number
	DC.B "   ",34
qh_show_entry_current_number_end
	EVEN
qh_show_entry_space
	DC.B 34," ................................................"
qh_show_entry_space_end
	EVEN
qh_entry_active_text1
	DC.B " [not played]"
qh_entry_active_text1_end
	EVEN
qh_entry_active_text2
	DC.B " [played]"
qh_entry_active_text2_end
	EVEN


qh_edit_window_name1		DC.B "Edit entry",0
	EVEN

qh_edit_window_name2		DC.B "Edit queue",0
	EVEN


qh_message_text1
	DC.B ASCII_LINE_FEED,"Playback queue is empty",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text1_end
	EVEN
qh_message_text2
	DC.B ASCII_LINE_FEED,ASCII_LINE_FEED,"Playback queue has "
qh_not_used_entries_string
	DC.B "   "
	DC.B "unused entries left",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text2_end
	EVEN
qh_message_text3
	DC.B ASCII_LINE_FEED,"The playback queue is empty",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text3_end
	EVEN
qh_message_text4
	DC.B ASCII_LINE_FEED,"No playback queue entries to clear",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text4_end
	EVEN
qh_message_text5
	DC.B ASCII_LINE_FEED,"Playback queue entries cleared",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text5_end
	EVEN
qh_message_text6
	DC.B ASCII_LINE_FEED,"Queue already set back.",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text6_end
	EVEN
qh_message_text7
	DC.B ASCII_LINE_FEED,"Queue position set back to first entry. All demo play states cleared",ASCII_LINE_FEED,ASCII_LINE_FEED
qh_message_text7_end
	EVEN



qh_error_text1
	DC.B ASCII_LINE_FEED,"Couldn't lock workbench",ASCII_LINE_FEED
qh_error_text1_end
	EVEN
qh_error_text2
	DC.B ASCII_LINE_FEED,"Couldn't get workbench visuals",ASCII_LINE_FEED
qh_error_text2_end
	EVEN
qh_error_text3
	DC.B ASCII_LINE_FEED,"Couldn't create context gadget",ASCII_LINE_FEED
qh_error_text3_end
	EVEN
qh_error_text4
	DC.B ASCII_LINE_FEED,"Couldn't create gadget",ASCII_LINE_FEED
qh_error_text4_end
	EVEN
qh_error_text5
	DC.B ASCII_LINE_FEED,"Couldn't open edit window",ASCII_LINE_FEED
qh_error_text5_end
	EVEN



; **** Run-Demo ****
	CNOP 0,4
rd_serial_io
	DS.B IOEXTSER_size


	CNOP 0,4
rd_pal_screen_colors
	DS.B pal_screen_colors_size

	CNOP 0,4
rd_pal_screen_tag_list
	DS.B screen_tag_list_size

	CNOP 0,4
rd_invisible_window_tag_list
	DS.B window_tag_list_size

	CNOP 0,4
rd_video_control_tag_list
	DS.B video_control_tag_list_size


        CNOP 0,4
rd_old_mmu_registers
 	DS.B old_mmu_registers_size


	CNOP 0,2
rd_old_chips_registers
	DS.B old_chips_registers_size


rd_pal_screen_name		DC.B "Amiga Demo Launcher 2",0
	EVEN
rd_invisible_window_name	DC.B "Amiga Demo Launcher 2",0
	EVEN

rd_demo_dir_path		DS.B adl_demofile_path_length


rd_demofile_name_header
	DC.B ASCII_LINE_FEED,"Playing ",34
rd_demofile_name_header_end
	EVEN
rd_demofile_name_tail
	DC.B 34,ASCII_LINE_FEED
rd_demofile_name_tail_end
	EVEN


rd_prerunscript_cmd_line
	DC.B "Execute "
rd_prerunscript_cmd_line_path
	DS.B adl_prerunscript_path_length
	EVEN


; ** Pseudo-Shell-Befehlszeile **
rd_shell_cmd_line
	DC.B ASCII_LINE_FEED,0
rd_shell_cmd_line_end
	EVEN


rd_message_text1
	DC.B ASCII_LINE_FEED,"No more demos left to play",ASCII_LINE_FEED,ASCII_LINE_FEED
rd_message_text1_end
	EVEN
rd_message_text2
	DC.B ASCII_LINE_FEED,"Replay loop stopped",ASCII_LINE_FEED,ASCII_LINE_FEED
rd_message_text2_end
	EVEN

rd_error_text1
	DC.B ASCII_LINE_FEED,"Couldn't open ciaa.resource",ASCII_LINE_FEED
rd_error_text1_end
	EVEN
rd_error_text2
	DC.B ASCII_LINE_FEED,"Couldn't open ciab.resource",ASCII_LINE_FEED
rd_error_text2_end
	EVEN
rd_error_text3
	DC.B ASCII_LINE_FEED,"Couldn't open icon.library",ASCII_LINE_FEED
rd_error_text3_end
	EVEN
rd_error_text4
	DC.B ASCII_LINE_FEED,"Couldn't create serial message port",ASCII_LINE_FEED
rd_error_text4_end
	EVEN
rd_error_text5
	DC.B ASCII_LINE_FEED,"Couldn't open serial.device",ASCII_LINE_FEED
rd_error_text5_end
	EVEN
rd_error_text6
	DC.B ASCII_LINE_FEED,"Couldnt allocate sprite data structure"
rd_error_text6_end
	EVEN
rd_error_text7
	DC.B ASCII_LINE_FEED,"Couldnt allocate colour values table"
rd_error_text7_end
	EVEN
rd_error_text8
	DC.B ASCII_LINE_FEED,"Couldnt allocate colour cache"
rd_error_text8_end
	EVEN
rd_error_text9
	DC.B ASCII_LINE_FEED,"Demo already played",ASCII_LINE_FEED
rd_error_text9_end
	EVEN
rd_error_text10
	DC.B ASCII_LINE_FEED,"Couldn't open demo file",ASCII_LINE_FEED
rd_error_text10_end
	EVEN
rd_error_text11
	DC.B ASCII_LINE_FEED,"No executable demo file"
rd_error_text11_end
	EVEN
rd_error_text12
	DC.B ASCII_LINE_FEED,"Couldn't find demo directory",ASCII_LINE_FEED
rd_error_text12_end
	EVEN
rd_error_text13
	DC.B ASCII_LINE_FEED,"Prerun script filepath is longer than 63 characters"
rd_error_text13_end
	EVEN
rd_error_text14
	DC.B ASCII_LINE_FEED,"Couldn't execute prerun script file",ASCII_LINE_FEED
rd_error_text14_end
	EVEN
rd_error_text15
	DC.B ASCII_LINE_FEED,"Invalid monitor ID",ASCII_LINE_FEED
rd_error_text15_end
	EVEN
rd_error_text16
	DC.B ASCII_LINE_FEED,"Couldn't open pal screen",ASCII_LINE_FEED
rd_error_text16_end
	EVEN
rd_error_text17
	DC.B ASCII_LINE_FEED,"Pal screen not supported",ASCII_LINE_FEED
rd_error_text17_end
	EVEN
rd_error_text18
	DC.B ASCII_LINE_FEED,"Couldn't open invisible window",ASCII_LINE_FEED
rd_error_text18_end
	EVEN
rd_error_text19
	DC.B ASCII_LINE_FEED,"Couldn't load demo file",ASCII_LINE_FEED
rd_error_text19_end
	EVEN
rd_error_text20
	DC.B ASCII_LINE_FEED,"Couldn't open WHDLoad .info file",ASCII_LINE_FEED
rd_error_text20_end
	EVEN
rd_error_text21a
	DC.B ASCII_LINE_FEED,"Serial device in use",ASCII_LINE_FEED
rd_error_text21a_end
	EVEN
rd_error_text21b
	DC.B ASCII_LINE_FEED,"Baud rate not supported by hardware",ASCII_LINE_FEED
rd_error_text21b_end
	EVEN
rd_error_text21c
	DC.B ASCII_LINE_FEED,"Bad parameter",ASCII_LINE_FEED
rd_error_text21c_end
	EVEN
rd_error_text21d
	DC.B ASCII_LINE_FEED,"Hardware data overrun",ASCII_LINE_FEED
rd_error_text21d_end
	EVEN
rd_error_text21e
	DC.B ASCII_LINE_FEED,"No data set ready",ASCII_LINE_FEED
rd_error_text21e_end
	EVEN
rd_error_text22
	DC.B ASCII_LINE_FEED,"Write to serial port failed",ASCII_LINE_FEED
rd_error_text22_end
	EVEN
rd_error_text23
	DC.B ASCII_LINE_FEED,"Couldn't execute WHDLoad slave file",ASCII_LINE_FEED
rd_error_text23_end
	EVEN


; **** WHD-Load ****
whdl_tooltype_PRELOAD		DC.B "PRELOAD",0
whdl_tooltype_PRELOADSIZE	DC.B "PRELOADSIZE",0
whdl_tooltype_QUITKEY		DC.B "QUITKEY",0
	EVEN


whdl_icon_path
	DS.B whdl_icon_path_length
	EVEN


; ** Befehlszeile für Ausführung der Slave-Datei **
whdl_slave_cmd_line
	DC.B "WHDLoad slave "
whdl_slave_cmd_line_path
	DS.B whdl_slave_path_length
	DS.B whdl_PRELOAD_length
	DS.B whdl_PRELOADSIZE_length
	DS.B whdl_QUITKEY_length
	EVEN


; **** Main ****
	DC.B "$VER: Amiga Demo Launcher 2.0 (27.8.24)",0
	EVEN


	END
