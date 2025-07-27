; Requirements
; 68000+
; OCS/ECS PAL+
; 2.0+


; History/changes

; V.2.0
; - code completely revised
; - demoSelector = Demo Charger
; - all texts changed
; - renaming of the run modes for the playlist:
;   OCS -> OCSVANILLA
;   AGA -> AGAVANILLA
;   FAST -> TURBO
; - new values and names for the run modes:
;   RUNMODE_PLAIN_TURBO = $01
;   RUNMODE_OCS_VANILLA = $02
;   RUNMODE_AGA_VANILLA = $03
; - argument NOFADER -> FADER (reversal of the logic), the active screen is
;   now faded out and no longer the custom screen
; - change of the minimum config: 68020/OS3.0/AGA chipset
; - bugfix argument RESETLOADPOS: The entries_number was set to zero instead
;   of 1.
; - option: Query of the WB message removed, as it can happen that this is
;   done by a demo and the message cannot be requested twice.
; - prerunscript check completely revised, in LOOP mode the same prerun script
;   is used for each demo.
; - QUIET argument: removed
; - argument RANDOM: completely revised
; - argument ENDLESS: completely revised
; - argument LMBEXIT: code can be optionally activated
; - file requester: There is no reboot button anymore, the complete logic
;   has been removed
; - PLAYLIST argument: The keyword PLAYLIST must now be specified, otherwise
;   all argument characters are interpreted as a playlist file name.
; - arguments check: Separate error query for keywords without value removed,
;   as this is already taken over by ReadArgs() and the function function
;   returns a zero
; - new logic argument PRERUNSCRIPT in connection with a transferred playlist:
;   If no PRERUNSCRIPT argument has been specified, then a prerun script file
;   that may have been specified via playlist is executed for the entry.
;   In LOOP mode, a separate prerun script file is executed for each demo.
; - argument REMOVE: query is moved at the top
; - argument PLAYLIST: After the playlist has been transferred to memory
;   now the playback queue is printed
; - new argument CLEARQUEUE: Deletes the complete playback list in memory
; - argument RESETLOADPOS renamed to RESETQUEUE
; - when all demos from the list have been played, the ADL is no longer
;   automatically removed from memory
; - file requester: The filter now also takes the extension ".data" into
;   account
; - n ew argument EDITQUEUE: All entries can be edited one after the other
; - new label prefix: Queue handler qh_
; - edit window: Gadgets for entry number, run mode and entry state.
;   Changes can be saved in the playback queue
; - new argument EDITENTRY: - A specific single ebtry can be edited
; - renaming of the FADER argument to SCREENFADER
; - bugfix: The values from the playlist for the run mode and the playing time
;   were no longer saved in the playback queue.

; V.2.01
; - bugfix: If the last entry in the list is manually set to "not played"
;   and the ADL is then restarted, the following empty entry is no longer
;   played, but a warning message is printed.
; - screen degrader routine completely revised.
; - new argument RESTORESYSTIME: System time is corrected after an entry was
;   executed which turns off the system.

; V.2.02
; - minimal configuration changed: 68000/OS2.0/OCS chipset
; - bugfix: After checking the PLAYENTRY argument, further checks are carried
;   out so that it can be combined with the SCREENFADER argument
; - color table of the custom screen is created correctly again and assigned
;   to the tag list
; - sprite resolution is determined via the active screen
; - screen tag SA_VideoControl is used to set the sprite resolution to Lores
; - Use of register CFG0 to change the CPU clock frequency (Yulquen74 turbo
;   board solution)
; - new argument MULTIPART: For use of WHDLoad demos where parts are
;   terminated via LMB.
; - guide revised
; - argument RUNMODE_TURBO renamed to RUNMODE_PLAIN_TURBO
; - on 68000: Runmode-Check, if Runmode "AGA vanilla" on 68000-Config,
;   then error output with subsequent reset after 2 seconds if no LOOP
;   argument was given
; - SCREENFADER argument removed
; - bugfix: PAL bit is now queried via the Exec-Base->VBlankFrequency
; - bugfix: LoadView(NULL) only starting with OS2.0

; V.2.03
; - bugfix: If no playing time was specified either by argument or via
;   playlist, then the command string was not initialized and as a
;   consequence sent without a converted 0 playing time:
;   "$23 00 00 00 00 00 $2c 00,0a" according to Yulquen74
; - change of the format string. A line feed is inserted before the #
;   character. The calculation of the checksum does not change. It still
;   takes place starting with the # character.

; V.2.04
; - bugfix: Checksum was determined incorrectly. It was calculated from the #
;   character, but with one byte too little, i.e. the argument MULTIPART was
;   never taken into account.
; - the memory is now searched at the beginning for the identifier "-DL-"
;   to check whether the ADL already exists
; - if the ADL has become inactive due to an entry, the exceptions and the
;   CoolCapture vector are restored.
; - REMOVE argument: The ADL identifier is also deleted.
; - black downgrade screen now also under OS 2.0

; V.2.05
; - command string now with two line feeds before the # character so that the
;   timer also starts after a cold start.
; - QUIET argument: added again, suppression of the file requester
; - guide updated
; - file requester: All tags via a tag list passed to AllocAslRequest()
; - bugfix: After removing the ADL via RMB during the reset, it was reactivated
;   when called again. Now the reset program also deletes the id in memory
; - code for Yulquen can now be activated via boolean variable

; V.2.06
; - QUIET argument: Included again. Now the start message is also suppressed.
; - new argument RESETONERROR: After every run-demo error a reset is executed
;   after 2 seconds.
; - for each run-demo error, the index number of the entry that generated
;   the error is now printed.
; - bugfix: "No more demos left to play" was printed twice, because the check
;   was called twice

; V.2.07
; - all comments translated to English
; - error text output improved regarding line feeds
; - Bugfix: during reset the timer was not stopped with the proper value via SERDAT
;   d1 may have random values

; V.2.08
; - argument RESETONERROR: error output with subsequent reset now after 4 seconds
;                          if no LOOP argument was given
; - on 68000: Runmode-Check, if Runmode "AGA vanilla" on 68000-Config,
;   then error output with subsequent reset after 4 seconds if no LOOP
;   argument and argument RESETONERROR was given
; - guide updated

; V.2.09
; - CPUSHA IC is executed before the PCR register is set, because the branch
;   cache will be disabled and before that, the branch cache should be flushed
; - exceptions vectors restored before old VBR content set
; - Code optimized
; - Bugfix: Sprite degrader to lores

; V.2.10
; - Identifier changed from "-DL-" to NOT("ADL2")
; - code cleared


; OS2.x bugs which have an impact on the ADL
; - DIWHIGH = $00ff (first copperlist) -> Blank screen with some old OCS intros,
;   which use a second custom copperlist called by the first system copperlist.
; - Asl file requester: Filter for file extensions does not work properly.
;   If the filter string is longer than 32 characters, no files are displayed,
;   because only a string length of 32 characters is taken into account. The
;   rest is truncated and thus the string is made unsuitable.


	MC68000


	INCDIR "include3.5:"

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


	INCDIR "custom-includes-ocs:"


	INCLUDE "macros.i"


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


	INCLUDE "equals.i"

FirstCode			EQU 4	; offset in SegList

MAGIC_COOKIE			EQU $000003f3
magic_cookie_length		EQU LONGWORD_SIZE

RUNMODE_PLAIN_TURBO		EQU $01
RUNMODE_OCS_VANILLA		EQU $02
RUNMODE_AGA_VANILLA		EQU $03

RESET_DEVICE_STOP		EQU 0

ASCII_QUOTATION_MARKS		EQU 34

; Amiga Demo Launcher
adl_demofile_path_length	EQU 124
adl_prerunscript_path_length	EQU 64

adl_entries_number_min		EQU 1

adl_seconds_factor		EQU 60
adl_seconds_max			EQU 59
adl_minutes_max			EQU 99

adl_baud			EQU 2400

adl_multipart_min		EQU 2
adl_multipart_max		EQU 16

adl_used_trap_vectors_number	EQU 7

; Demo Charger
dc_entries_number_default_max	EQU 10
dc_entries_number_max		EQU 99

dc_file_request_left		EQU 0
dc_file_request_top		EQU 0
dc_file_request_x_size		EQU 320
dc_file_request_y_size		EQU 200

; Queue Handler
qh_edit_window_left		EQU 0
qh_edit_window_top		EQU 0
qh_edit_window_x_size		EQU 260
qh_edit_window_y_size		EQU 130

qh_text_gadget_x_size		EQU 240
qh_text_gadget_y_size		EQU 12
qh_text_gadget_x_position	EQU ((qh_edit_window_x_size-qh_text_gadget_x_size)*50)/100
qh_text_gadget_y_position	EQU ((qh_edit_window_y_size-qh_text_gadget_y_size)*5)/100

qh_backward_button_x_size	EQU 30
qh_backward_button_y_size	EQU 12
qh_backward_button_x_position	EQU ((qh_edit_window_x_size-qh_backward_button_x_size)*25)/100
qh_backward_button_y_position	EQU ((qh_edit_window_y_size-qh_backward_button_y_size)*20)/100
qh_backward_button_id		EQU 1

qh_integer_gadget_x_size	EQU 30
qh_integer_gadget_y_size	EQU 12
qh_integer_gadget_x_position	EQU ((qh_edit_window_x_size-qh_integer_gadget_x_size)*50)/100
qh_integer_gadget_y_position	EQU ((qh_edit_window_y_size-qh_integer_gadget_y_size)*20)/100
qh_integer_gadget_digits_number	EQU 2
qh_integer_gadget_id		EQU 2

qh_foreward_button_x_size	EQU 30
qh_foreward_button_y_size	EQU 12
qh_foreward_button_x_position	EQU ((qh_edit_window_x_size-qh_foreward_button_x_size)*75)/100
qh_foreward_button_y_position	EQU ((qh_edit_window_y_size-qh_foreward_button_y_size)*20)/100
qh_foreward_button_id		EQU 3

qh_cycle_gadget_x_size		EQU 130
qh_cycle_gadget_y_size		EQU 12
qh_cycle_gadget_x_position	EQU ((qh_edit_window_x_size-qh_cycle_gadget_x_size)*50)/100
qh_cycle_gadget_y_position1	EQU ((qh_edit_window_y_size-qh_cycle_gadget_y_size)*30)/100
qh_cycle_gadget_y_position2	EQU ((qh_edit_window_y_size-qh_cycle_gadget_y_size)*40)/100
qh_cycle_gadget_id		EQU 4
qh_cycle_gadget_init_choice	EQU 0	; ordinal number for first choice

qh_mx_gadget_x_size		EQU 105
qh_mx_gadget_y_size		EQU 11
qh_mx_gadget_x_position		EQU ((qh_edit_window_x_size-qh_mx_gadget_x_size)*50)/100
qh_mx_gadget_y_position1	EQU ((qh_edit_window_y_size-qh_mx_gadget_y_size)*55)/100
qh_mx_gadget_y_position2	EQU ((qh_edit_window_y_size-qh_mx_gadget_y_size)*60)/100
qh_mx_gadget_id			EQU 5
qh_mx_gadget_init_choice	EQU 0	; ordinal number for first choice

qh_positive_button_x_size	EQU 70
qh_positive_button_y_size	EQU 12
qh_positive_button_x_position	EQU ((qh_edit_window_x_size-qh_positive_button_x_size)*4)/100
qh_positive_button_y_position	EQU ((qh_edit_window_y_size-qh_positive_button_y_size)*89)/100
qh_positive_button_id		EQU 6

qh_negative_button_x_size	EQU 70
qh_negative_button_y_size	EQU 12
qh_negative_button_x_position	EQU ((qh_edit_window_x_size-qh_negative_button_x_size)*96)/100
qh_negative_button_y_position	EQU ((qh_edit_window_y_size-qh_negative_button_y_size)*89)/100
qh_negative_button_id		EQU 7

; Run Demo
rd_yulquen74_code_enabled	EQU TRUE

rd_nnnn_size			EQU 4
rd_r_size			EQU 1
rd_cc_size			EQU 2
rd_duration_shift		EQU 16

rd_error_message_delay		EQU PAL_FPS*4 ; 4 seconds

; WHD Load
whdl_preload_length		EQU 8
whdl_preloadsize_length		EQU 20
whdl_quitkey_length		EQU 11
whdl_slave_path_length		EQU 124
whdl_icon_path_length		EQU 124

; Reset Program
rp_frames_delay			EQU 50
rp_rasterlines_delay		EQU 5

rp_color_okay			EQU $68b
rp_color_error			EQU $d74


	INCLUDE "except-vectors.i"


	INCLUDE "taglists.i"


	RSRESET

cmd_results_array		RS.B 0

; Amiga Demo Launcher
cra_HELP			RS.L 1
cra_REMOVE			RS.L 1
; Demo Charger
cra_MAXENTRIES			RS.L 1
cra_NEWENTRY			RS.L 1
cra_PLAYLIST			RS.L 1
cra_QUIET			RS.L 1
; Queue Handler
cra_SHOWQUEUE			RS.L 1
cra_EDITENTRY			RS.L 1
cra_EDITQUEUE			RS.L 1
cra_CLEARQUEUE			RS.L 1
cra_RESETQUEUE			RS.L 1
; Run Demo
cra_PLAYENTRY			RS.L 1
cra_PRERUNSCRIPT		RS.L 1
cra_MINS			RS.L 1
cra_SECS			RS.L 1
cra_MULTIPART			RS.L 1
cra_RANDOM			RS.L 1
cra_ENDLESS			RS.L 1
cra_LOOP			RS.L 1
cra_RESTORESYSTIME		RS.L 1
cra_SOFTRESET			RS.L 1
cra_RESETONERROR		RS.L 1

cmd_results_array_size		RS.B 0


	RSRESET

playlist_results_array		RS.B 0

pra_demofile			RS.L 1
pra_OCSVANILLA			RS.L 1
pra_AGAVANILLA			RS.L 1
pra_PLAINTURBO			RS.L 1
pra_MINS			RS.L 1
pra_SECS			RS.L 1
pra_MULTIPART			RS.L 1
pra_PRERUNSCRIPT		RS.L 1

playlist_results_array_size	RS.B 1


	RSRESET

playback_queue_entry		RS.B 0

pqe_demofile_path		RS.B adl_demofile_path_length
pqe_playtime			RS.W 1
pqe_runmode			RS.B 1
pqe_entry_active		RS.B 1
pqe_prerunscript_path		RS.B adl_prerunscript_path_length

playback_queue_entry_size	RS.B 0


	RSRESET

command_string			RS.B 0

cs_line_feed1			RS.B 1
cs_line_feed2			RS.B 1
cs_hash				RS.B 1
cs_delay_counter		RS.B rd_nnnn_size ; decimal number
cs_parts			RS.B rd_r_size ; hexadecimal number
cs_separator			RS.B 1
cs_checksum			RS.B rd_cc_size ; hexadecimal number
cs_line_feed3			RS.B 1

command_string_size		RS.B 0


	RSRESET

file_request_tag_list		RS.B 0

frtl_ASLFR_Window		RS.L 2
frtl_ASLFR_TitleText		RS.L 2
frtl_ASLFR_PositiveText		RS.L 2
frtl_ASLFR_NegativeText		RS.L 2
frtl_ASLFR_InitialLeftEdge	RS.L 2
frtl_ASLFR_InitialTopEdge	RS.L 2
frtl_ASLFR_InitialWidth		RS.L 2
frtl_ASLFR_InitialHeight	RS.L 2
frtl_ASLFR_InitialDrawer	RS.L 2
frtl_ASLFR_InitialPattern	RS.L 2
frtl_ASLFR_Flags1		RS.L 2
frtl_TAG_DONE			RS.L 1

file_request_tag_list_size	RS.B 0


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


	RSRESET

sprite_pointer_data		RS.B 0

spd_control_word1		RS.W 1	; 1x bandwidth
spd_control_word2		RS.W 1
spd_color_descriptor		RS.W 2
spd_end_of_data			RS.W 2

sprite_pointer_data_size	RS.B 0


	RSRESET

old_mmu_registers		RS.B 0

omr_tt0				RS.L 1
omr_tt1				RS.L 1
omr_dtt0                        RS.L 1
omr_dtt1                        RS.L 1
omr_itt0                        RS.L 1
omr_itt1                        RS.L 1
omr_tc				RS.L 1

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


; Variables
	RSRESET

; Amiga Demo Launcher
adl_os_version			RS.W 1
adl_cpu_flags			RS.W 1

adl_abort			RS.W 1
	RS_ALIGN_LONGWORD
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

; Demo Charger
dc_arg_newentry_enabled		RS.W 1
dc_arg_playlist_enabled		RS.W 1
dc_arg_quiet_enabled		RS.W 1

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
dc_transmitted_entries_number	RS.W 1

; Queue Handler
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

qh_text_gadget			RS.L 1
qh_backward_button_gadget	RS.L 1
qh_integer_gadget		RS.L 1
qh_foreward_button_gadget	RS.L 1
qh_cycle_gadget			RS.L 1
qh_mx_gadget			RS.L 1

qh_check_window_events_active	RS.W 1

	RS_ALIGN_LONGWORD
qh_edit_entry			RS.L 1
qh_edit_entry_demo_filename	RS.L 1
qh_edit_entry_offset		RS.W 1
qh_edit_runmode			RS.B 1
qh_edit_entry_active		RS.B 1

; Run Demo
rd_arg_prerunscript_enabled	RS.W 1
rd_arg_random_enabled		RS.W 1
rd_arg_endless_enabled		RS.W 1
rd_arg_loop_enabled		RS.W 1
rd_arg_restoresystime_enabled	RS.W 1
rd_arg_softreset_enabled	RS.W 1
rd_arg_resetonerror_enabled	RS.W 1

	RS_ALIGN_LONGWORD
rd_serial_msg_port		RS.L 1
rd_playtimer_delay		RS.W 1

	RS_ALIGN_LONGWORD
rd_tod_time			RS.L 1

rd_play_duration		RS.W 1

rd_entry_offset			RS.W 1

	RS_ALIGN_LONGWORD
rd_demo_filename		RS.L 1
rd_demo_filename_end		RS.L 1
rd_demo_filename_length		RS.L 1
rd_demofile_path		RS.L 1
rd_demofile_handle		RS.L 1
rd_demofile_magic_cookie	RS.L 1
rd_demofile_seglist		RS.L 1
rd_demofile_dir_lock		RS.L 1

rd_prerunscript_path		RS.L 1

rd_active_screen		RS.L 1
rd_active_screen_mode		RS.L 1
rd_first_window			RS.L 1
rd_pal_screen			RS.L 1
rd_invisible_window		RS.L 1
rd_mouse_pointer_data		RS.L 1
rd_old_sprite_resolution	RS.L 1

rd_fast_memory_block		RS.L 1
rd_fast_memory_block_size	RS.L 1

rd_old_current_dir_lock		RS.L 1

rd_custom_traps			RS.L 1

rd_old_vbr			RS.L 1
rd_old_cacr			RS.L 1
rd_old_060_pcr			RS.L 1
rd_clear_030_mmu_register	RS.L 1
	IFEQ rd_yulquen74_code_enabled
rd_old_cfg0			RS.W 1
	ENDC

; WHD-Load
whdl_slave_enabled		RS.W 1
	RS_ALIGN_LONGWORD
whdl_disk_object		RS.L 1

adl_variables_size		RS.B 0


	SECTION code,CODE


; Amiga Demo-Launcher
	movem.l d2-d7/a2-a6,-(a7)
	lea	adl_variables(pc),a3	; base for all variables
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
	bsr	adl_open_intuition_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_graphics_library
	bsr	adl_open_gadtools_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_intuition_library
	bsr	adl_open_asl_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_gadtools_library
	bsr	adl_open_icon_library
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_asl_library

	bsr	adl_check_system_props
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_icon_library

	bsr	adl_search_id

	tst.w	adl_abort(a3)
	beq	adl_cleanup_icon_library

	bsr	adl_check_cmd_line
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

	tst.w	adl_arg_help_enabled(a3)
	beq     adl_cleanup_read_arguments
	tst.w	adl_arg_remove_enabled(a3)
	beq	adl_cleanup_read_arguments


; Queue Handler arguments
	tst.w	qh_arg_showqueue_enabled(a3)
	bne.s	qh_precheck_arg_editentry
	bsr	qh_show_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
qh_precheck_arg_editentry
	tst.w	qh_arg_editentry_enabled(a3)
	bne.s	qh_precheck_arg_editqueue
	bsr	qh_edit_single_entry
	bra	adl_cleanup_read_arguments
	CNOP 0,4
qh_precheck_arg_editqueue
	tst.w	qh_arg_editqueue_enabled(a3)
	bne.s	qh_precheck_arg_clearqueue
	bsr	qh_edit_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
qh_precheck_arg_clearqueue
	tst.w	qh_arg_clearqueue_enabled(a3)
	bne.s	qh_precheck_arg_resetqueue
	bsr	qh_clear_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
qh_precheck_arg_resetqueue
	tst.w	qh_arg_resetqueue_enabled(a3)
        bne.s	qh_precheck_queue_empty
	bsr	qh_reset_queue
	bra	adl_cleanup_read_arguments
	CNOP 0,4
qh_precheck_queue_empty
	bsr	qh_check_queue_empty
	tst.l	d0
	bne.s	dc_start


; Demo Charger
	tst.w	dc_arg_newentry_enabled(a3)
	beq.s	dc_start
	tst.w	dc_arg_playlist_enabled(a3)
	beq.s	dc_start

	tst.w	adl_reset_program_active(a3)
	beq	rd_start

dc_start
	tst.w	dc_arg_quiet_enabled(a3)
	beq.s	dc_start_skip
	bsr	adl_print_intro_message
dc_start_skip
	bsr	dc_check_entries_number_max
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_reset_program
	bsr	dc_alloc_entries_buffer
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_reset_program
	tst.w	dc_arg_playlist_enabled(a3)
	beq.s	dc_check_playlist

; No playlist file given by argument - New entries via file requester
	tst.w	dc_arg_quiet_enabled(a3)
	beq.s	dc_cleanup_entries_buffer
	bsr	dc_get_program_dir
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
dc_demo_charge_loop
	bsr	dc_display_remaining_files
	bsr	dc_make_file_request
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
	bsr	dc_display_file_request
	move.l	d0,adl_dos_return_code(a3)
	bne.s	dc_cleanup_file_request
	bsr	dc_get_demo_filepath
	move.l	d0,adl_dos_return_code(a3)
	bne.s	dc_cleanup_file_request
	bsr	dc_free_file_request
	bsr	dc_display_runmode_request
        bsr	dc_check_entries_number_max
	move.l	d0,adl_dos_return_code(a3)
	beq.s	dc_demo_charge_loop

	bra.s	dc_cleanup_reset_program
	CNOP 0,4
dc_cleanup_file_request
	bsr	dc_free_file_request
dc_cleanup_reset_program
	bsr	dc_init_reset_program
	move.l	d0,adl_dos_return_code(a3)
	bne 	adl_cleanup_read_arguments
dc_cleanup_entries_buffer
	bsr	dc_free_entries_buffer
	bra	adl_cleanup_read_arguments

; Playlist file given by argument
	CNOP 0,4
dc_check_playlist
	bsr	dc_lock_playlist_file
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_entries_buffer
	bsr	dc_alloc_playlist_file_fib
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_locked_playlist_file
	bsr	dc_get_playlist_filelength
	move.l	d0,adl_dos_return_code(a3)
	bne	dc_cleanup_playlist_file_fib
	bsr	dc_alloc_playlist_filebuffer
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


; Amiga Demo-Launcher
	CNOP 0,4
adl_cleanup_read_arguments
	bsr	adl_free_read_arguments
	bsr	adl_print_io_error
adl_cleanup_reset_program
	bsr	adl_remove_reset_program
adl_cleanup_icon_library
	bsr	adl_close_icon_library
adl_cleanup_asl_library
	bsr	adl_close_asl_library
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


; input
; result
	CNOP 0,4
adl_init_variables

; Main
	lea	_SysBase(pc),a0
	move.l	exec_base.w,(a0)

; Amiga Demo Launcher
	moveq	#FALSE,d1
	move.w	d1,adl_abort(a3)

	moveq	#TRUE,d0
	move.l	d0,adl_dos_return_code(a3)

	move.w	d1,adl_reset_program_active(a3)

	move.w	d1,adl_arg_help_enabled(a3)
	move.w	d1,adl_arg_remove_enabled(a3)

	move.w	d0,adl_entries_number(a3)
	move.w	#dc_entries_number_default_max,adl_entries_number_max(a3)

; Demo Charger
	move.w	d1,dc_arg_newentry_enabled(a3)
	move.w	d1,dc_arg_playlist_enabled(a3)
	move.w	d1,dc_arg_quiet_enabled(a3)

	move.w  d0,dc_multiselect_entries_number(a3)

	move.w	d0,dc_playlist_entries_number(a3)
	move.w	d0,dc_transmitted_entries_number(a3)

; Queue Handler
	move.w	d1,qh_arg_showqueue_enabled(a3)
	move.w	d1,qh_arg_editentry_enabled(a3)
	move.w	d1,qh_arg_editqueue_enabled(a3)
	move.w	d1,qh_arg_clearqueue_enabled(a3)
	move.w	d1,qh_arg_resetqueue_enabled(a3)

	move.w	#adl_entries_number_min,qh_edit_entry_offset(a3)

	move.w	d0,qh_check_window_events_active(a3)

; Run Demo
	move.w	d1,rd_arg_prerunscript_enabled(a3)
	move.w	d1,rd_arg_random_enabled(a3)
	move.w	d1,rd_arg_endless_enabled(a3)
	move.w	d1,rd_arg_loop_enabled(a3)
	move.w	d1,rd_arg_restoresystime_enabled(a3)
	move.w	d1,rd_arg_softreset_enabled(a3)
	move.w	d1,rd_arg_resetonerror_enabled(a3)

	move.w	d0,rd_playtimer_delay(a3)
	move.w	d0,rd_play_duration(a3)

	move.w	#adl_entries_number_min,rd_entry_offset(a3)

	move.l	d0,rd_demofile_seglist(a3)

	move.l	d0,rd_prerunscript_path(a3)

	move.l	d0,rd_clear_030_mmu_register(a3)

; WHD Load
	move.w	d1,whdl_slave_enabled(a3)

; Reset Program
	lea	rp_entries_number_max(pc),a0
	move.w	#dc_entries_number_default_max,(a0)

	lea	rp_entry_offset(pc),a0
	move.w	#adl_entries_number_min,(a0)

	lea	rp_endless_enabled(pc),a0
	move.w	d1,(a0)

	rts


; input
; result
	CNOP 0,4
adl_init_structures
	bsr.s	adl_init_cool_capture_request
	bsr.s	adl_init_command_string
	bsr.s	dc_init_runmode_request
	bsr	dc_init_file_request_tags
	bsr	qh_init_get_visual_info_tags
	bsr	qh_init_edit_window_tags
	bsr	qh_init_gadgets
	bsr	rd_init_pal_screen_tags
	bsr	rd_init_pal_screen_color_spec
	bsr	rd_init_pal_screen_rgb4_colors
	bsr	rd_init_pal_screen_rgb32_colors
	bsr	rd_init_video_control_tags
	bsr	rd_init_invisible_window_tags
	bsr	rd_init_serial_io
	bsr	rd_init_timer_io
	rts


; input
; result
	CNOP 0,4
adl_init_cool_capture_request
	lea	adl_cool_capture_request(pc),a0
	moveq	#EasyStruct_SIZEOF,d2
	move.l	d2,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+		; no flags
	lea	adl_install_request_title(pc),a1
	move.l	a1,(a0)+
	lea	adl_install_request_text_body(pc),a1
	move.l	a1,(a0)+
	lea	adl_install_request_text_gadgets(pc),a1
	move.l	a1,(a0)
	rts


; input
; result
	CNOP 0,4
adl_init_command_string
	lea	rp_command_string(pc),a0
	move.b	#ASCII_LINE_FEED,cs_line_feed1(a0)
	move.b	#ASCII_LINE_FEED,cs_line_feed2(a0)
	move.b	#"#",cs_hash(a0)
	move.b	#",",cs_separator(a0)
	move.b	#ASCII_LINE_FEED,cs_line_feed3(a0)
	rts


; input
; result
	CNOP 0,4
dc_init_runmode_request
	lea	dc_runmode_request(pc),a0
	moveq	#EasyStruct_SIZEOF,d2
	move.l	d2,(a0)+
	move.l	d0,(a0)+		; no flags
	lea	dc_runmode_request_title(pc),a1
	move.l	a1,(a0)+
	lea	dc_runmode_request_text_body(pc),a1
	move.l	a1,(a0)+
	lea	dc_runmode_request_text_gadgets(pc),a1
	move.l	a1,(a0)
	rts


; input
; result
	CNOP 0,4
dc_init_file_request_tags
	lea	dc_file_request_tags(pc),a0
; window tags
	move.l	#ASLFR_Window,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+		; will be initializer later
; text tags
	move.l	#ASLFR_TitleText,(a0)+
	lea	dc_file_request_title(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_PositiveText,(a0)+
	lea	dc_file_request_positive_text(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_NegativeText,(a0)+
	lea	dc_file_request_negative_text(pc),a1
	move.l	a1,(a0)+
; file requester tags
	move.l	#ASLFR_InitialLeftEdge,(a0)+
	moveq	#dc_file_request_left,d2
	move.l	d2,(a0)+
	move.l	#ASLFR_InitialTopEdge,(a0)+
	moveq	#dc_file_request_top,d2
	move.l	d2,(a0)+
	move.l	#ASLFR_InitialWidth,(a0)+
	move.l	#dc_file_request_x_size,(a0)+
	move.l	#ASLFR_InitialHeight,(a0)+
	move.l	#dc_file_request_y_size,(a0)+
	move.l	#ASLFR_InitialDrawer,(a0)+
	lea	dc_current_dir_name(pc),a1
	move.l	a1,(a0)+
	move.l	#ASLFR_InitialPattern,(a0)+
	move.l	d0,(a0)+		; will be initialized later
; option tags
	move.l	#ASLFR_Flags1,(a0)+
	moveq	#FRF_DOPATTERNS|FRF_DOMULTISELECT,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


; input
; result
	CNOP 0,4
qh_init_get_visual_info_tags
	lea	qh_get_visual_info_tags(pc),a0
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


; input
; result
	CNOP 0,4
qh_init_edit_window_tags
	lea	qh_edit_window_tags(pc),a0
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
	moveq	#BOOL_TRUE,d2
	move.l	d2,(a0)+
	move.l	#WA_Flags,(a0)+
	move.l	#WFLG_CLOSEGADGET|WFLG_ACTIVATE|WFLG_DEPTHGADGET|WFLG_DRAGBAR,(a0)+
	move.l	#WA_Gadgets,(a0)+
	move.l	d0,(a0)+		; will be initialized later
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


; input
; result
	CNOP 0,4
qh_init_gadgets
; CreateContext()
	lea	qh_gadget_list(pc),a0
	clr.l	(a0)
; NewGadget()
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
	bsr	qh_init_text_gadget
	bsr	qh_init_button_gadgets
	bsr	qh_init_integer_gadget
	bsr	qh_init_cycle_gadget
	bsr	qh_init_mx_gadget
	rts

; Input
; Result
	CNOP 0,4
qh_init_text_gadget
	lea	qh_text_gadget_tags(pc),a0
	move.l	#GTTX_Text,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	#GTTX_Border,(a0)+
	moveq	#BOOL_TRUE,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)

	lea	qh_set_text_gadget_tags(pc),a0
	move.l	#GTTX_Text,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	d2,(a0)
	rts

; Input
; Result
	CNOP 0,4
qh_init_button_gadgets
	lea	qh_button_tags(pc),a0
	move.l	#GA_Disabled,(a0)+
	moveq	#BOOL_FALSE,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)

	lea	qh_set_button_tags(pc),a0
	move.l	#GA_Disabled,(a0)+
	moveq	#BOOL_FALSE,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts

; Input
; Result
	CNOP 0,4
qh_init_integer_gadget
	lea	qh_integer_gadget_tags(pc),a0
	move.l	#GTIN_Number,(a0)+
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	move.l	d0,(a0)+
	move.l	#GTIN_MaxChars,(a0)+
	moveq	#qh_integer_gadget_digits_number,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)

	lea	qh_set_integer_gadget_tags(pc),a0
	move.l	#GTIN_Number,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)+
	move.l	d2,(a0)
	rts

; Input
; Result
	CNOP 0,4
qh_init_cycle_gadget
	lea	qh_cycle_gadget_array(pc),a0
	lea	qh_cycle_gadget_choice_text1(pc),a1
	move.l	a1,(a0)+
	lea	qh_cycle_gadget_choice_text2(pc),a1
	move.l	a1,(a0)+
	lea	qh_cycle_gadget_choice_text3(pc),a1
	move.l	a1,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)			; terminate array

	lea	qh_cycle_gadget_tags(pc),a0
	move.l	#GTCY_Labels,(a0)+
	lea	qh_cycle_gadget_array(pc),a1
	move.l	a1,(a0)+
	move.l	#GTCY_Active,(a0)+
	moveq	#qh_cycle_gadget_init_choice,d2
	move.l	d2,(a0)+		
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)

	lea	qh_set_cycle_gadget_tags(pc),a0
	move.l	#GTCY_Active,(a0)+
	moveq	#qh_cycle_gadget_init_choice,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts

; Input
; Result
	CNOP 0,4
qh_init_mx_gadget
	lea	qh_mx_gadget_array(pc),a0
	lea	qh_mx_gadget_choice_text1(pc),a1
	move.l	a1,(a0)+
	lea	qh_mx_gadget_choice_text2(pc),a1
	move.l	a1,(a0)+
	moveq	#0,d0
	move.l	d0,(a0)			; terminate array

	lea	qh_mx_gadget_tags(pc),a0
	move.l	#GTMX_Labels,(a0)+
	lea	qh_mx_gadget_array(pc),a1
	move.l	a1,(a0)+
	move.l	#GTMX_Active,(a0)+
	moveq	#qh_mx_gadget_init_choice,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)

	lea	qh_set_mx_gadget_tags(pc),a0
	move.l	#GTMX_Active,(a0)+
	moveq	#qh_mx_gadget_init_choice,d2
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


; input
; result
	CNOP 0,4
rd_init_pal_screen_tags
	lea	rd_pal_screen_tags(pc),a0
	move.l	#SA_Left,(a0)+
    	moveq	#pal_screen_left,d2
	move.l	d2,(a0)+
	move.l	#SA_Top,(a0)+
    	moveq	#pal_screen_top,d2
	move.l	d2,(a0)+
	move.l	#SA_Width,(a0)+
	moveq	#pal_screen_x_size,d2
	move.l	d2,(a0)+
	move.l	#SA_Height,(a0)+
	moveq	#pal_screen_y_size,d2
	move.l	d2,(a0)+
	move.l	#SA_Depth,(a0)+
	moveq	#pal_screen_depth,d2
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
	lea	rd_pal_screen_rgb32_colors(pc),a1
	move.l	a1,(a0)+
	move.l	#SA_VideoControl,(a0)+
	lea	rd_video_control_tags(pc),a1
	move.l	#VTAG_SPRITERESN_SET,vctl_VTAG_SPRITERESN+ti_Tag(a1)
	move.l	#SPRITERESN_140NS,vctl_VTAG_SPRITERESN+ti_Data(a1)
	move.l	a1,(a0)+
	move.l	#SA_Font,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_SysFont,(a0)+
	move.l	d0,(a0)+
	move.l	#SA_Type,(a0)+
	move.l	#CUSTOMSCREEN,(a0)+
	move.l	#SA_Behind,(a0)+
	moveq   #BOOL_FALSE,d2
	move.l	d2,(a0)+
	move.l	#SA_Quiet,(a0)+
	move.l	d2,(a0)+
	move.l	#SA_ShowTitle,(a0)+
	move.l	d2,(a0)+
	move.l	#SA_AutoScroll,(a0)+
	move.l	d2,(a0)+
	move.l	#SA_Draggable,(a0)+
	move.l	d2,(a0)+
	move.l	#SA_Interleaved,(a0)+
	move.l	d2,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


; Input
; Result
		CNOP 0,4
rd_init_pal_screen_color_spec
		lea	rd_pal_screen_color_spec(pc),a0 ; OS2.x
		moveq	#0,d0		; black
		moveq	#0,d1		; color index
		MOVEF.W	pal_screen_colors_number-1,d7
rd_init_pal_screen_color_spec_loop
		move.w	d1,(a0)+	; color index
		move.w	d0,(a0)+	; R4
		move.w	d0,(a0)+	; G4
		addq.w	#1,d1
		move.w	d0,(a0)+	; B4
		dbf	d7,rd_init_pal_screen_color_spec_loop
		move.w	#-1,(a0)	; terminate array
		rts


; input
; result
	CNOP 0,4
rd_init_pal_screen_rgb4_colors
	lea	rd_pal_screen_rgb4_colors(pc),a0 ; for LoadRGB4()
	moveq	#$000,d0		; black
	moveq	#pal_screen_colors_number-1,d7
rd_init_pal_screen_rgb4_colors_loop
	move.w	d0,(a0)+		; RGB4
        dbf	d7,rd_init_pal_screen_rgb4_colors_loop
	rts


; input
; result
	CNOP 0,4
rd_init_pal_screen_rgb32_colors
	lea	rd_pal_screen_rgb32_colors(pc),a0 ; for LoadRGB32()
	move.w	#pal_screen_colors_number,(a0)+
	moveq	#0,d0
	move.w	d0,(a0)+		; start with COLOR00
	MOVEF.W	pal_screen_colors_number-1,d7
rd_init_pal_screen_rgb32_colors_loop
	move.l	d0,(a0)+		; R32
	move.l	d0,(a0)+		; G32
	move.l	d0,(a0)+		; B32
	dbf	d7,rd_init_pal_screen_rgb32_colors_loop
	move.l	d0,(a0)			; terminate list
	rts


; input
; result
	CNOP 0,4
rd_init_video_control_tags
	lea	rd_video_control_tags(pc),a0
	moveq	#TAG_DONE,d2
	move.l	d2,vctl_TAG_DONE(a0)
	rts


; input
; result
	CNOP 0,4
rd_init_invisible_window_tags
	lea	rd_invisible_window_tags(pc),a0
	move.l	#WA_Left,(a0)+
	moveq	#invisible_window_left,d2
	move.l	d2,(a0)+
	move.l	#WA_Top,(a0)+
	moveq	#invisible_window_top,d2
	move.l	d2,(a0)+
	move.l	#WA_Width,(a0)+
	moveq	#invisible_window_x_size,d2
	move.l	d2,(a0)+
	move.l	#WA_Height,(a0)+
	moveq	#invisible_window_y_size,d2
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
	move.l	d0,(a0)+		; will be initialized later
	move.l	#WA_MinWidth,(a0)+
	moveq	#invisible_window_x_size,d2
	move.l	d2,(a0)+
	move.l	#WA_MinHeight,(a0)+
	moveq	#invisible_window_y_size,d2
	move.l	d2,(a0)+
	move.l	#WA_MaxWidth,(a0)+
	moveq	#invisible_window_x_size,d2
	move.l	d2,(a0)+
	move.l	#WA_MaxHeight,(a0)+
	moveq	#invisible_window_y_size,d2
	move.l	d2,(a0)+
	move.l	#WA_AutoAdjust,(a0)+
	moveq	#BOOL_TRUE,d2
	move.l	d2,(a0)+
	move.l	#WA_Flags,(a0)+
	move.l	#WFLG_BACKDROP|WFLG_BORDERLESS|WFLG_ACTIVATE,(a0)+
	moveq	#TAG_DONE,d2
	move.l	d2,(a0)
	rts


; input
; result
	CNOP 0,4
rd_init_serial_io
	lea	rd_serial_io(pc),a0
	moveq	#0,d0
	move.b	d0,LN_Type(a0)
	move.b	d0,LN_Pri(a0)
	move.l	d0,LN_Name(a0)
	move.l	d0,MN_ReplyPort(a0)	; will be initialized later
	rts


; input
; result
	CNOP 0,4
rd_init_timer_io
	lea	rd_timer_io(pc),a0
	moveq	#0,d0
	move.b	d0,LN_Type(a0)
	move.b	d0,LN_Pri(a0)
	move.l	d0,LN_Name(a0)
	move.l	d0,MN_ReplyPort(a0)
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_open_dos_library
	lea	dos_library_name(pc),a1
	moveq	#ANY_LIBRARY_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_DOSBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_dos_library_ok
	moveq	#RETURN_FAIL,d0
adl_open_dos_library_quit
	rts
	CNOP 0,4
adl_open_dos_library_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_open_dos_library_quit


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
adl_get_output
	CALLDOS Output
	move.l	d0,adl_output_handle(a3)
	bne.s   adl_get_output_ok
	CALLLIBS IoErr
adl_get_output_quit
	rts
	CNOP 0,4
adl_get_output_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_get_output_quit


; input
; result
; d0.l	Screen structure active screen
	CNOP 0,4
rd_get_active_screen
	moveq	#0,d0			; all locks
	CALLINT LockIBase
	move.l	d0,a0
	move.l	ib_ActiveScreen(a6),a2
	CALLLIBS UnlockIBase
	move.l	a2,d0
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_check_system_props
	move.l	_SysBase(pc),a0
	move.w	AttnFlags(a0),adl_cpu_flags(a3)
	move.w	Lib_Version(a0),d0
	move.w	d0,adl_os_version(a3)
	cmp.w	#OS2_VERSION,d0
	bge.s	adl_check_system_props_skip
	lea	adl_error_text1(pc),a0
	moveq	#adl_error_text1_end-adl_error_text1,d0
	bsr	adl_print_text
adl_check_system_props_fail
	moveq	#RETURN_FAIL,d0
adl_check_system_props_quit
	rts
	CNOP 0,4
adl_check_system_props_skip
	cmp.b	#PAL_FPS,VBlankFrequency(a0) ; OS1.3+
	beq.s	adl_check_system_props_ok
	lea	adl_error_text2(pc),a0
	move.l	#adl_error_text2_end-adl_error_text2,d0
	bsr	adl_print_text
	bra.s	adl_check_system_props_fail
	CNOP 0,4
adl_check_system_props_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_check_system_props_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_open_graphics_library
	lea	graphics_library_name(pc),a1
	moveq	#OS2_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_GfxBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_graphics_library_ok
	lea	adl_error_text3(pc),a0
	moveq	#adl_error_text3_end-adl_error_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
adl_open_graphics_library_quit
	rts
	CNOP 0,4
adl_open_graphics_library_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_open_graphics_library_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_open_intuition_library
	lea	intuition_library_name(pc),a1
	moveq	#OS2_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_IntuitionBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_intuition_library_ok
	lea	adl_error_text4(pc),a0
	moveq	#adl_error_text4_end-adl_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
adl_open_intuition_library_quit
	rts
	CNOP 0,4
adl_open_intuition_library_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_open_intuition_library_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_open_gadtools_library
	lea	gadtools_library_name(pc),a1
	moveq	#OS2_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_GadToolsBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_gadtools_library_ok
	lea	adl_error_text5(pc),a0
	moveq	#adl_error_text5_end-adl_error_text5,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
adl_open_gadtools_library_quit
	rts
	CNOP 0,4
adl_open_gadtools_library_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_open_gadtools_library_quit


; input
; result
; d0.l	.Return code
	CNOP 0,4
adl_open_asl_library
	lea	asl_library_name(pc),a1
	moveq	#OS2_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_ASLBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_asl_library_ok
	lea	adl_error_text6(pc),a0
	moveq	#adl_error_text6_end-adl_error_text6,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
adl_open_asl_library_quit
	rts
	CNOP 0,4
adl_open_asl_library_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_open_asl_library_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_open_icon_library
	lea	icon_library_name(pc),a1
	moveq	#OS2_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_IconBase(pc),a0
	move.l	d0,(a0)
	bne.s	adl_open_icon_library_ok
	lea	adl_error_text7(pc),a0
	moveq	#adl_error_text7_end-adl_error_text7,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
adl_open_icon_library_quit
	rts
	CNOP 0,4
adl_open_icon_library_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_open_icon_library_quit


; input
; result
	CNOP 0,4
adl_search_id
	move.l	#~("ADL2"),d4		; encrypted id
	move.w	#QUADWORD_SIZE*2,a1
	move.l	MaxLocMem(a6),a2
	move.l	a2,d7
	lsr.l	#4,d7			; chip memory size in 16 byte steps
	subq.l	#1,d7			; loopend at false
adl_search_id_loop
	sub.l	a1,a2
	movem.l	(a2),d0-d3		; fetch 16 bytes
	cmp.l	d4,d0
	beq.s	adl_search_id_skip1
	cmp.l	d4,d1
	beq.s	adl_search_id_skip2
	cmp.l	d4,d2
	beq.s	adl_search_id_skip3
	cmp.l	d4,d3
	beq.s	adl_search_id_skip4
	subq.l	#1,d7
	bpl.s	adl_search_id_loop
; No ADL2 id found
	bsr	adl_init_values
adl_search_id_quit
	rts
	CNOP 0,4
adl_search_id_skip1
	subq.w	#LONGWORD_SIZE,a2	; pointer reset program
	bsr.s	adl_init_values
	bra.s	adl_search_id_quit
	CNOP 0,4
adl_search_id_skip2
	bsr.s	adl_init_values
	bra.s	adl_search_id_quit
	CNOP 0,4
adl_search_id_skip3
	addq.w	#LONGWORD_SIZE,a2	; pointer reset program
	bsr.s	adl_init_values
	bra.s	adl_search_id_quit
	CNOP 0,4
adl_search_id_skip4
	add.w	#QUADWORD_SIZE,a2	; pointer reset program
	bsr.s	adl_init_values
	bra.s	adl_search_id_quit


; Input
; a2.l	Pointer reset program in memory
; Result
	CNOP 0,4
adl_init_values
	move.l	_SysBase(pc),a6
	move.l	CoolCapture(a6),d0
	bne.s	adl_init_values_skip1
; Enable inactive ADL2 in memory
	bsr.s	adl_init_cool_capture
	jsr	rp_init_custom_traps-rp_start(a2) ; init custom traps
	bsr.s	adl_update_values
adl_init_values_quit
	rts
	CNOP 0,4
adl_init_values_skip1
; Cool Capture already in use
	cmp.l	a2,d0
	bne.s   adl_init_values_skip2
	bsr.s	adl_update_values
	bra.s	adl_init_values_quit
	CNOP 0,4
adl_init_values_skip2
; Cool Capture already used by different reset program
	bsr.s	adl_do_request
	cmp.l	#BOOL_TRUE,d0		; requester gadget "Proceed" clicked ?
	beq.s	adl_init_values_skip3
	clr.w	adl_abort(a3)
	bra.s	adl_init_values_quit
	CNOP 0,4
adl_init_values_skip3
	bsr.s	adl_set_default_values
	bra.s	adl_init_values_quit


; Input
; a2.l	Pointer reset program in memory
; a6.l	Exec base
; Result
	CNOP 0,4
adl_init_cool_capture
	move.l	a2,CoolCapture(a6)
	bsr	rp_update_exec_checksum
	CALLLIBS CacheClearU
	rts


; Input
; Output
; d0.l	Boolean value for clicked gadget
	CNOP 0,4
adl_do_request
	sub.l	a0,a0			; requester on workbench/public screen
	lea	adl_cool_capture_request(pc),a1
	move.l	a0,a2			; no IDCMP flags
	move.l	a3,-(a7)
	move.l	a0,a3			; no arguments list
	CALLINT EasyRequestArgs
	move.l	(a7)+,a3
	rts


; input
; result
	CNOP 0,4
adl_update_values
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
	rts


; input
; result
	CNOP 0,4
adl_set_default_values
	moveq	#dc_entries_number_default_max,d2
	move.w	d2,adl_entries_number_max(a3)
	lea	rp_entries_number_max(pc),a0
	move.w	d2,(a0)
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
adl_check_cmd_line
	lea	adl_cmd_template(pc),a0
	move.l	a0,d1
	lea	adl_cmd_results(pc),a2
	move.l	a2,d2
	moveq	#0,d3			; no custom RDArgs structure
	CALLDOS ReadArgs
	move.l	d0,adl_read_arguments(a3)
	bne.s   adl_check_arg_help
adl_check_cmd_line_fail
	bsr.s	adl_print_cmd_usage
	moveq	#RETURN_FAIL,d0
adl_check_cmd_line_quit
	rts
	CNOP 0,4
adl_check_cmd_line_ok
	moveq	#RETURN_OK,d0
	bra.s	adl_check_cmd_line_quit


; input
; result
	CNOP 0,4
adl_print_cmd_usage
	lea	adl_cmd_usage_text(pc),a0
	move.l	#adl_cmd_usage_text_end-adl_cmd_usage_text,d0
	bsr	adl_print_text
	rts


; ADL argument HELP
	CNOP 0,4
adl_check_arg_help
	move.l	cra_HELP(a2),d0
	beq.s	adl_check_arg_remove
	clr.w	adl_arg_help_enabled(a3)
	bsr.s	adl_print_cmd_usage
	bra.s	adl_check_cmd_line_ok

; ADL argument REMOVE
	CNOP 0,4
adl_check_arg_remove
	move.l	cra_REMOVE(a2),d0
	beq.s	adl_check_arg_maxentries
	clr.w	adl_arg_remove_enabled(a3)
	bra.s	adl_check_cmd_line_ok

; Demo Charger argument MAXENTRIES
	CNOP 0,4
adl_check_arg_maxentries
	move.l	cra_MAXENTRIES(a2),d0
	beq.s	adl_check_arg_newentry
	tst.w	adl_reset_program_active(a3)
	beq.s	adl_check_arg_newentry
	move.l	d0,a0
	move.l	(a0),d0			; number of entries
	cmp.w	#dc_entries_number_max,d0
	ble.s   adl_check_arg_maxentries_skip
	bra.s	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_maxentries_skip
	move.w	d0,adl_entries_number_max(a3)
	lea	rp_entries_number_max(pc),a0
	move.w	d0,(a0)

; Demo Charger argument NEWENTRY
adl_check_arg_newentry
	move.l	cra_NEWENTRY(a2),d0
	beq.s	adl_check_arg_playlist
	clr.w	dc_arg_newentry_enabled(a3)
	bra	adl_check_cmd_line_ok

; Demo Charger argument PLAYLIST
	CNOP 0,4
adl_check_arg_playlist
	move.l	cra_PLAYLIST(a2),dc_playlist_file_name(a3)
	beq.s	adl_check_arg_quiet
	clr.w	dc_arg_playlist_enabled(a3)
	bra	adl_check_cmd_line_ok

; Demo Charger argument QUIET
	CNOP 0,4
adl_check_arg_quiet
	move.l	cra_QUIET(a2),d0
	not.w	d0
	move.w	d0,dc_arg_quiet_enabled(a3)

; Queue Handler argument SHOWQUEUE
	move.l	cra_SHOWQUEUE(a2),d0
	beq.s	adl_check_arg_editentry
	clr.w	qh_arg_showqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; Queue Handler argument EDITENTRY
	CNOP 0,4
adl_check_arg_editentry
	move.l	cra_EDITENTRY(a2),d0
	beq.s	adl_check_arg_editqueue
	move.l	d0,a0
	move.l	(a0),d0		; entry number
	cmp.w	#adl_entries_number_min,d0
	bge.s	arg_check_arg_editentry_skip1
	bra	adl_check_cmd_line_fail
	CNOP 0,4
arg_check_arg_editentry_skip1
	cmp.w	adl_entries_number(a3),d0
	ble.s   adl_check_arg_editentry_skip2
	bra	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_editentry_skip2
	move.w	d0,qh_edit_entry_offset(a3)
	clr.w	qh_arg_editentry_enabled(a3)
	bra	adl_check_cmd_line_ok

; Queue Handler argument EDITQUEUE
	CNOP 0,4
adl_check_arg_editqueue
	move.l	cra_EDITQUEUE(a2),d0
	beq.s	adl_check_arg_clearqueue
	clr.w	qh_arg_editqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; Queue Handler argument CLEARQUEUE
	CNOP 0,4
adl_check_arg_clearqueue
	move.l	cra_CLEARQUEUE(a2),d0
	beq.s	adl_check_arg_resetqueue
	clr.w	qh_arg_clearqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; Queue Handler argument RESETQUEUE
	CNOP 0,4
adl_check_arg_resetqueue
	move.l	cra_RESETQUEUE(a2),d0
	beq.s	adl_check_arg_playentry
	clr.w	qh_arg_resetqueue_enabled(a3)
	bra	adl_check_cmd_line_ok

; Run Demo argument PLAYENTRY
	CNOP 0,4
adl_check_arg_playentry
	move.l	cra_PLAYENTRY(a2),d0
	beq.s	adl_check_arg_prerunscript
	move.l	d0,a0
	move.l	(a0),d0		; entry number
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

; Run Demo argument PRERUNSCRIPT
adl_check_arg_prerunscript
	move.l	cra_PRERUNSCRIPT(a2),rd_prerunscript_path(a3)
	beq.s	adl_check_arg_secs
	clr.w	rd_arg_prerunscript_enabled(a3)

; Run Demo argument SECS
adl_check_arg_secs
	move.l	cra_SECS(a2),d0
	beq.s	adl_check_arg_mins
	move.l	d0,a0
	move.l	(a0),d0			; seconds value
	moveq	#adl_seconds_max,d2
	cmp.l	d2,d0
	ble.s   adl_check_arg_mins
	bra	adl_check_cmd_line_fail

; Run Demo argument MINS
	CNOP 0,4
adl_check_arg_mins
	move.l	cra_MINS(a2),d1
	beq.s	adl_calculate_playtime
	move.l	d1,a0
	move.l	(a0),d1			; minutes value
	moveq	#adl_minutes_max,d2
	cmp.l	d2,d1
	ble.s   adl_calculate_playtime
	bra	adl_check_cmd_line_fail

; Input
; Result
	CNOP 0,4
adl_calculate_playtime
	MULUF.W	adl_seconds_factor,d1,d2 ; conversion minutes to seconds
	add.w	d0,d1			; total value in seconds
	MULUF.W	rd_duration_shift,d1,d0
	move.w	d1,rd_play_duration(a3)

; Run Demo argument MULTIPART
	move.l	cra_MULTIPART(a2),d0
	beq.s   adl_check_arg_random
	tst.w	rd_play_duration(a3)
	bne.s   adl_check_arg_multipart_skip1
	bra	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_multipart_skip1
	move.l	d0,a0
	move.l	(a0),d0			; number of demo parts
	cmp.b	#adl_multipart_min,d0
	bge.s   adl_check_arg_multipart_skip2
	bra	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_multipart_skip2
	cmp.b	#adl_multipart_max,d0
	ble.s   adl_check_arg_multipart_skip3
	bra	adl_check_cmd_line_fail
	CNOP 0,4
adl_check_arg_multipart_skip3
	subq.b	#1,d0			; only values 1..15
	or.b	d0,rd_play_duration+BYTE_SIZE(a3)

; Run Demo argument RANDOM
adl_check_arg_random
	move.l	cra_RANDOM(a2),d0
	not.w	d0
	move.w	d0,rd_arg_random_enabled(a3)

; Run Demo argument ENDLESS
	move.l	cra_ENDLESS(a2),d0
	not.w	d0
	move.w	d0,rd_arg_endless_enabled(a3)
	tst.w	adl_reset_program_active(a3)
	bne.s	adl_update_endless_skip
	move.l	d0,d2
	GET_RESIDENT_ENDLESS_ENABLED
	move.l	d0,a0
	move.w	d2,(a0)
	bra.s	adl_check_arg_loop
	CNOP 0,4
adl_update_endless_skip
	lea	rp_endless_enabled(pc),a0
	move.w	d0,(a0)

; Run Demo argument LOOP
adl_check_arg_loop
	move.l	cra_LOOP(a2),d0
	not.w	d0
	move.w	d0,rd_arg_loop_enabled(a3)

; Run Demo argument RESTORESYSTIME
	move.l	cra_RESTORESYSTIME(a2),d0
	not.w	d0
	move.w	d0,rd_arg_restoresystime_enabled(a3)

; Run Demo argument SOFTRESET
	move.l	cra_SOFTRESET(a2),d0
	beq.s	rd_check_arg_resetonerror
	tst.w	rd_arg_loop_enabled(a3)
	beq.s	rd_check_arg_resetonerror
	clr.w	rd_arg_softreset_enabled(a3)

; Run Demo argument RESETONERROR
rd_check_arg_resetonerror
	move.l	cra_RESETONERROR(a2),d0
	tst.w	rd_arg_loop_enabled(a3)
	beq	adl_check_cmd_line_ok
	clr.w	rd_arg_resetonerror_enabled(a3)
	bra	adl_check_cmd_line_ok


; input
; result
	CNOP 0,4
adl_print_intro_message
	tst.w	adl_reset_program_active(a3)
	bne.s	adl_print_intro_message_skip
adl_print_intro_message_quit
	rts
	CNOP 0,4
adl_print_intro_message_skip
	tst.w	dc_arg_playlist_enabled(a3)
	beq.s	adl_print_intro_message_quit
	lea	adl_intro_message_text(pc),a0
	move.l	#adl_intro_message_text_end-adl_intro_message_text,d0
	bsr	adl_print_text
	bra.s	adl_print_intro_message_quit


; Demo Charger

; input
; result
; d0.l	Return code/error code
	CNOP 0,4
dc_alloc_entries_buffer
	tst.w	adl_reset_program_active(a3)
	beq.s	dc_alloc_entries_buffer_ok
	move.w	adl_entries_number_max(a3),d0
	mulu.w	#playback_queue_entry_size,d0 ; total size of playback queue
	move.l	#MEMF_CLEAR|MEMF_ANY|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,adl_entries_buffer(a3)
	bne.s	dc_alloc_entries_buffer_ok
	lea	dc_error_text1(pc),a0
	moveq	#dc_error_text1_end-dc_error_text1,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
dc_alloc_entries_buffer_quit
	rts
	CNOP 0,4
dc_alloc_entries_buffer_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_alloc_entries_buffer_quit


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
dc_get_program_dir
	CALLDOS GetProgramDir
	tst.l	d0
	bne.s	dc_get_program_dir_skip
	lea	dc_error_text10(pc),a0
	moveq	#dc_error_text10_end-dc_error_text10,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
dc_get_program_dir_quit
	rts
	CNOP 0,4
dc_get_program_dir_skip
	move.l	d0,d1			; directory lock
	lea	dc_current_dir_name(pc),a0
	move.l	a0,d2			; buffer for directory name
	MOVEF.L	adl_demofile_path_length,d3
	CALLLIBS NameFromLock
	tst.l	d0
	bne.s	dc_get_program_dir_ok
	lea	dc_error_text11(pc),a0
	moveq	#dc_error_text11_end-dc_error_text11,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_DIR_NOT_FOUND,d0
	bra.s	dc_get_program_dir_quit
	CNOP 0,4
dc_get_program_dir_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_get_program_dir_quit


; input
; result
	CNOP 0,4
dc_display_remaining_files
	lea	dc_file_request_remaining_files(pc),a0
	moveq	#0,d1
	move.w	adl_entries_number_max(a3),d1
	sub.w	adl_entries_number(a3),d1 ; remaining number of free entries
	cmp.w	#adl_entries_number_min,d1
	bne.s	dc_display_remaining_files_skip
	clr.b	dc_file_request_char_s-dc_file_request_remaining_files(a0) ; delete letter "s" of demos
dc_display_remaining_files_skip
	moveq	#2,d7			; number of digits to convert
	bsr	rp_dec_to_ascii
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_make_file_request
	moveq	#ASL_FileRequest,d0
	lea	dc_file_request_tags(pc),a0
	lea	dc_file_request_pattern_os3x(pc),a1
	cmp.w	#OS3_VERSION,adl_os_version(a3)
	bge.s	dc_make_file_request_skip
	lea	dc_file_request_pattern_os2x(pc),a1 ; OS2.x only considers 32 characters string length
dc_make_file_request_skip
	move.l	a1,frtl_ASLFR_InitialPattern+ti_Data(a0)
	CALLASL AllocAslRequest
	move.l	d0,dc_file_request(a3)
	bne.s	dc_make_file_request_ok
	lea	dc_error_text12(pc),a0
	moveq	#dc_error_text12_end-dc_error_text12,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
dc_make_file_request_quit
	rts
	CNOP 0,4
dc_make_file_request_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_make_file_request_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_display_file_request
	move.l	dc_file_request(a3),a0
	sub.l	a1,a1			; no tag list
	CALLASL AslRequest
	tst.l   d0
	bne.s	dc_display_file_request_ok
	moveq	#RETURN_FAIL,d0
dc_display_file_request_quit
	rts
	CNOP 0,4
dc_display_file_request_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_display_file_request_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_get_demo_filepath
	clr.w   dc_multiselect_entries_number(a3)
	move.l	dc_file_request(a3),a2
	move.l	fr_NumArgs(a2),d6
	move.w	d6,d0			; number of selected files
	add.w   adl_entries_number(a3),d0
	cmp.w   adl_entries_number_max(a3),d0
	blt.s   dc_get_demo_filepath_skip1
	move.w  adl_entries_number_max(a3),d6
	sub.w   adl_entries_number(a3),d6 ; remaining number of free entries
dc_get_demo_filepath_skip1
	move.w  d6,dc_multiselect_entries_number(a3)
	moveq	#0,d5			; first entry in ArgLists
	move.l	fr_ArgList(a2),a6
	subq.w	#1,d6			; loopend at false
dc_get_demo_filepath_loop
	move.w	d5,d0
	MULUF.W	8,d0,d1
	move.l	wa_Name(a6,d0.w),a0	; pointer file name
	move.l	fr_Drawer(a2),a1	; pointer directory name
	move.l	a2,-(a7)
	bsr.s	dc_check_demo_filepath
	move.l	(a7)+,a2
	tst.l	d0
	beq.s	dc_get_demo_filepath_skip2
dc_get_demo_filepath_quit
	rts
	CNOP 0,4
dc_get_demo_filepath_skip2
	addq.w	#1,d5			; next entry in ArgLists
	dbf	d6,dc_get_demo_filepath_loop
	moveq	#RETURN_OK,d0
	bra.s	dc_get_demo_filepath_quit


; input
; a0.l	File name
; a1.l	Directory name
; result
; d0.l	Return code/Error Code
	CNOP 0,4
dc_check_demo_filepath
	tst.b	(a1)			; directory name string empty ?
	bne.s	dc_check_demo_filepath_skip1
	lea	dc_error_text13(pc),a0
	moveq	#dc_error_text13_end-dc_error_text13,d0
	bsr	adl_print_text
	MOVEF.L ERROR_DIR_NOT_FOUND,d0
dc_check_demo_filepath_quit
	rts
	CNOP 0,4
dc_check_demo_filepath_skip1
	tst.b	(a0)			; file name string empty ?
	bne.s	dc_check_demo_filepath_skip2
	lea	dc_error_text14(pc),a0
	moveq	#dc_error_text14_end-dc_error_text14,d0
	bsr	adl_print_text
	MOVEF.L ERROR_OBJECT_NOT_FOUND,d0
	bra.s	dc_check_demo_filepath_quit
	CNOP 0,4
dc_check_demo_filepath_skip2
	move.w	adl_entries_number(a3),d0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a2
	add.l   d0,a2			; pointer current entry in playback queue
	move.l	a2,dc_current_entry(a3)
	move.l	a0,-(a7)
	move.l	a2,a0			; pointer current entry in playback queue
	bsr	dc_clear_playlist_entry
	move.l	(a7)+,a0		; pointer file name
dc_check_demo_filepath_loop1
	tst.b	(a1)			; nullbyte ?
	beq.s	dc_check_demo_filepath_loop2
	cmp.b	#"/",(a1)
	bne.s	dc_check_demo_filepath_skip3
	addq.w	#BYTE_SIZE,a1		; next character in directory name
	bra.s	dc_check_demo_filepath_loop1
	CNOP 0,4
dc_check_demo_filepath_skip3
	lea	dc_current_dir_name(pc),a4
	moveq	#0,d0			; length counter directory path
dc_check_demo_filepath_loop2
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	dc_check_demo_filepath_skip4
	move.l	dc_current_entry(a3),a0
	bsr	dc_clear_playlist_entry
	lea	dc_error_text15(pc),a0
	moveq	#dc_error_text15_end-dc_error_text15,d0
	bsr	adl_print_text
	MOVEF.L ERROR_INVALID_COMPONENT_NAME,d0
	bra	dc_check_demo_filepath_quit
	CNOP 0,4
dc_check_demo_filepath_skip4
	move.b	(a1),(a2)+
	move.b	(a1)+,(a4)+
	tst.b	(a1)
	bne.s	dc_check_demo_filepath_loop2
	clr.b	(a4)			; insert nullbyte
	cmp.b	#":",-1(a1)
	beq.s	dc_check_demo_filepath_loop3
	cmp.b	#"/",-1(a1)
	beq.s	dc_check_demo_filepath_loop3
	move.b	#"/",(a2)+
dc_check_demo_filepath_loop3
	addq.b	#BYTE_SIZE,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	dc_check_demo_filepath_skip5
	move.l	dc_current_entry(a3),a0
	bsr	dc_clear_playlist_entry
	lea	dc_error_text15(pc),a0
	moveq	#dc_error_text15_end-dc_error_text15,d0
	bsr	adl_print_text
	MOVEF.L ERROR_INVALID_COMPONENT_NAME,d0
	bra	dc_check_demo_filepath_quit
	CNOP 0,4
dc_check_demo_filepath_skip5
	move.b	(a0)+,(a2)+
	cmp.b	#":",(a0)
	bne.s	dc_check_demo_filepath_skip6
	lea	dc_error_text16(pc),a0
	moveq	#dc_error_text16_end-dc_error_text16,d0
	bsr	adl_print_text
	MOVEF.L ERROR_OBJECT_NOT_FOUND,d0
	bra	dc_check_demo_filepath_quit
	CNOP 0,4
dc_check_demo_filepath_skip6
	tst.b	(a0)			; nullbyte ?
	bne.s	dc_check_demo_filepath_loop3
	clr.b	(a2)			; insert nullbyte
	addq.w	#1,adl_entries_number(a3)
	moveq	#RETURN_OK,d0
	bra	dc_check_demo_filepath_quit


; input
; result
	CNOP 0,4
dc_free_file_request
	move.l	dc_file_request(a3),a0
	CALLASL FreeAslRequest
	rts


; input
; result
	CNOP 0,4
dc_display_runmode_request
	sub.l	a0,a0			; requester on workbench/public screen
	lea	dc_runmode_request(pc),a1
	move.l	a0,a2			; no IDCMP flags
	move.l	a3,-(a7)
	move.l	a0,a3			; no arguments list
	CALLINT EasyRequestArgs
	move.l	(a7)+,a3
	addq.b  #1,d0                   ; adjust result
	MOVEF.L playback_queue_entry_size,d1
	move.l	dc_current_entry(a3),a0
	ADDF.W	pqe_runmode,a0
	move.w	dc_multiselect_entries_number(a3),d7
	subq.w	#1,d7			; loopend at false
dc_display_runmode_request_loop
	move.b	d0,(a0)			; store selected runmode
	sub.l	d1,a0			; previous entry
	dbf	d7,dc_display_runmode_request_loop
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_check_entries_number_max
	move.w  adl_entries_number(a3),d0
	cmp.w   adl_entries_number_max(a3),d0
	bne.s	dc_check_entries_number_max_ok
	bsr.s	dc_print_entries_max_message
	moveq   #RETURN_WARN,d0
dc_check_entries_number_max_quit
	rts
	CNOP 0,4
dc_check_entries_number_max_ok
	moveq   #RETURN_OK,d0
	bra.s	dc_check_entries_number_max_quit


; input
; result
	CNOP 0,4
dc_print_entries_max_message
	lea     dc_message_text(pc),a0
	moveq   #dc_message_text_end-dc_message_text,d0
	bsr     adl_print_text
	rts


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
dc_init_reset_program
	tst.w	adl_entries_number(a3)
	bne.s	dc_init_reset_program_skip1
dc_init_reset_program_ok
	moveq	#RETURN_OK,d0
dc_init_reset_program_quit
	rts
	CNOP 0,4
dc_init_reset_program_skip1
	tst.w	adl_reset_program_active(a3)
	beq	dc_init_reset_program_skip3
	lea	rp_entry_offset(pc),a0
	move.w	rd_entry_offset(a3),(a0)
	move.l	#rp_entries_buffer-rp_start,d0 ; reset program size
	move.w	d0,d7
	move.w	adl_entries_number_max(a3),d1
	mulu.w	#playback_queue_entry_size,d1 ; total playback queue size
	add.l	d1,d0			; total size of reset program section with playback queue
	lea	rp_reset_program_size(pc),a0
	move.l	d0,(a0)
	move.l	#MEMF_CLEAR|MEMF_CHIP|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	lea	rp_reset_program_memory(pc),a0
	move.l	d0,(a0)
	bne.s	dc_init_reset_program_skip2
	lea	dc_error_text17(pc),a0
	moveq	#dc_error_text17_end-dc_error_text17,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
	bra.s	dc_init_reset_program_quit
	CNOP 0,4
dc_init_reset_program_skip2
	lea	rp_start(pc),a0		; source
	move.l	d0,a1			; destination
	move.l	d0,a2			; store pointer reset program
	move.l	d0,CoolCapture(a6)
	subq.w	#1,d7			; loopend at false
dc_init_reset_program_loop1
	move.b	(a0)+,(a1)+
	dbf	d7,dc_init_reset_program_loop1
	move.l	adl_entries_buffer(a3),a0 ; source
	move.w	adl_entries_number_max(a3),d7
	mulu.w	#playback_queue_entry_size,d7 ; total size of reset program section with playback queue
	subq.w	#1,d7			; loopend at false
dc_init_reset_program_loop2
	move.b	(a0)+,(a1)+
	dbf	d7,dc_init_reset_program_loop2
	bsr	rp_update_exec_checksum
	CALLLIBS CacheClearU
	jsr	rp_init_custom_traps-rp_start(a2) ; init custom traps
	tst.b	adl_cpu_flags+BYTE_SIZE(a3)
	beq.s	dc_init_reset_program_skip3
	lea	rp_read_VBR(pc),a5
	CALLLIBS Supervisor
	tst.l	d0			; VBR = $000000 ?
	beq.s	dc_init_reset_program_skip3
	GET_CUSTOM_TRAP_VECTORS
	move.l	d0,a0			; source
	move.w	#TRAP_0_VECTOR,a1	; destination chip memory
	moveq	#adl_used_trap_vectors_number-1,d7
dc_init_reset_program_loop3
	move.l	(a0)+,(a1)+
	dbf	d7,dc_init_reset_program_loop3
	CALLLIBS CacheClearU
dc_init_reset_program_skip3
	GET_RESIDENT_ENTRIES_NUMBER
	move.l	d0,a0
	move.w	adl_entries_number(a3),(a0)
	bra	dc_init_reset_program_ok


; input
; result
; d0.l	Return code
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
dc_lock_playlist_file_quit
	rts
	CNOP 0,4
dc_lock_playlist_file_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_lock_playlist_file_quit


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
dc_alloc_playlist_file_fib
	MOVEF.L fib_SIZEOF,d0
	move.l	#MEMF_CLEAR|MEMF_ANY|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,dc_playlist_file_fib(a3)
	bne.s	dc_alloc_playlist_file_fib_ok
	lea	dc_error_text3(pc),a0
	moveq	#dc_error_text3_end-dc_error_text3,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
dc_alloc_playlist_file_fib_quit
	rts
	CNOP 0,4
dc_alloc_playlist_file_fib_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_alloc_playlist_file_fib_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_get_playlist_filelength
	move.l	dc_playlist_file_lock(a3),d1
	move.l	dc_playlist_file_fib(a3),d2
	move.l	d2,a2
	CALLDOS Examine
	tst.l	d0
	bne.s	dc_get_playlist_filelength_ok
	lea	dc_error_text4(pc),a0
	moveq	#dc_error_text4_end-dc_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
dc_get_playlist_filelength_quit
	rts
	CNOP 0,4
dc_get_playlist_filelength_ok
	move.l	fib_Size(a2),dc_playlist_file_length(a3)
	moveq	#RETURN_OK,d0
	bra.s	dc_get_playlist_filelength_quit


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
dc_alloc_playlist_filebuffer
	move.l	dc_playlist_file_length(a3),d0
	move.l	#MEMF_CLEAR|MEMF_ANY|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,dc_playlist_file_buffer(a3)
	bne.s	dc_alloc_playlist_filebuffer_ok
	lea	dc_error_text5(pc),a0
	moveq	#dc_error_text5_end-dc_error_text5,d0
	bsr	adl_print_text
	MOVEF.L	ERROR_NO_FREE_STORE,d0
dc_alloc_playlist_filebuffer_quit
	rts
	CNOP 0,4
dc_alloc_playlist_filebuffer_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_alloc_playlist_filebuffer_quit


; input
; result
; d0.l	Return code
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
dc_open_playlist_file_quit
	rts
	CNOP 0,4
dc_open_playlist_file_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_open_playlist_file_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_read_playlist_file
	move.l	dc_playlist_file_handle(a3),d1
	move.l	dc_playlist_file_buffer(a3),d2
	move.l	dc_playlist_file_length(a3),d3
	CALLDOS Read
	tst.l	d0
	bne.s	dc_read_playlist_file_ok
	lea	dc_error_text7(pc),a0
	moveq	#dc_error_text7_end-dc_error_text7,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
dc_read_playlist_file_quit
	rts
	CNOP 0,4
dc_read_playlist_file_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_read_playlist_file_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_parse_playlist_file
	lea	dc_parsing_begin_text(pc),a0
	moveq	#dc_parsing_begin_text_end-dc_parsing_begin_text,d0
	bsr	adl_print_text
	move.w	adl_entries_number(a3),d0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	add.l   d0,a0			; entry in playback queue
	move.l	a0,d6
	move.l	dc_playlist_file_buffer(a3),a2
	move.l	dc_playlist_file_length(a3),d7
dc_parse_playlist_file_loop1
	subq.w	#1,d7			; loopend at false
	bpl.s	dc_parse_playlist_file_skip1
	bsr	dc_parse_playlist_file_result
	moveq	#RETURN_OK,d0
dc_parse_playlist_file_quit
	rts
	CNOP 0,4
dc_parse_playlist_file_skip1
	addq.w	#1,dc_playlist_entries_number(a3)
	MOVEF.L	DOS_RDARGS,d1
	moveq	#0,d2			; no tag list														; no tags
	CALLDOS AllocDosObject
	tst.l	d0
	bne.s	dc_parse_playlist_file_skip2
	lea	dc_error_text8(pc),a0
	moveq	#dc_error_text8_end-dc_error_text8,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	bra.s	dc_parse_playlist_file_quit
	CNOP 0,4
dc_parse_playlist_file_skip2
	moveq	#0,d4			; counter length of command line
	move.l	d0,a4			; RDArgs structure
	move.l	a2,CS_Buffer(a4)	; playlist file buffer
dc_parse_playlist_file_loop2
	addq.w	#1,d4
	cmp.b	#ASCII_LINE_FEED,(a2)+
	beq.s	dc_parse_playlist_entry
	dbf	d7,dc_parse_playlist_file_loop2
	bsr	dc_parse_playlist_file_result
	moveq	#RETURN_OK,d0
	bra.s	dc_parse_playlist_file_quit

	CNOP 0,4
dc_parse_playlist_entry
	move.l	d4,CS_Length(a4)
	lea	dc_playlist_results_array(pc),a5
	moveq	#0,d0
	move.l	d0,pra_demofile(a5)	; clear results array
	move.l	d0,pra_OCSVANILLA(a5)
	move.l	d0,pra_AGAVANILLA(a5)
	move.l	d0,pra_PLAINTURBO(a5)
	move.l	d0,pra_SECS(a5)
	move.l	d0,pra_MINS(a5)
	move.l	d0,pra_MULTIPART(a5)
	move.l	d0,pra_PRERUNSCRIPT(a5)
	lea	dc_playlist_template(pc),a0
	move.l	a0,d1			; playlist template
	move.l	a5,d2			; playlist results array
	move.l	a4,d3			; own RDArgs structure
	CALLDOS ReadArgs
	tst.l	d0
	bne.s	dc_parse_playlist_entry_skip
	bsr	dc_parse_entry_syntax_error
	bra	dc_free_DosObject
	CNOP 0,4
dc_parse_playlist_entry_skip
	move.l	d6,a0			; entry in playback queue
	bsr	dc_clear_playlist_entry

; Playlist argument: demofile
	move.l	pra_demofile(a5),d0
	bne.s	dc_copy_demofile_path
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

	CNOP 0,4
dc_copy_demofile_path
	move.l	d0,a0			; entry file name
	move.l	d6,a1			; entry in playback queue
	moveq	#0,d0			; counter length of file path
dc_copy_demofile_path_loop
	addq.b	#1,d0
	cmp.b	#adl_demofile_path_length-1,d0
	blt.s	dc_copy_demofile_path_skip
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments
	CNOP 0,4
dc_copy_demofile_path_skip
	move.b	(a0)+,(a1)+
	bne.s	dc_copy_demofile_path_loop ; loop until nullbyte
	move.l	d6,a1			; entry in playback queue
	clr.b	pqe_runmode(a1)

; Playlist argument: OCSVANILLA
	tst.l	pra_OCSVANILLA(a5)
	beq.s	dc_check_arg_AGAVANILLA
	move.b	#RUNMODE_OCS_VANILLA,pqe_runmode(a1)
	bra.s	dc_check_entry_run_mode

; Playlist argument: AGAVANILLA
	CNOP 0,4
dc_check_arg_agavanilla
	tst.l	pra_AGAVANILLA(a5)
	beq.s	dc_check_arg_turbo
	move.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a1)
	bra.s	dc_check_entry_run_mode

; Playlist argument: PLAINTURBO
	CNOP 0,4
dc_check_arg_turbo
	tst.l	pra_PLAINTURBO(a5)
	beq.s	dc_check_entry_run_mode
	move.b	#RUNMODE_PLAIN_TURBO,pqe_runmode(a1)

dc_check_entry_run_mode
	move.l	d6,a1			; entry in playback queue
	tst.b	pqe_runmode(a1)
	bne.s   dc_check_arg_secs
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

; Playlist argument: SECS
	CNOP 0,4
dc_check_arg_secs
	move.l	d6,a1			; entry in playback queue
	move.l	pra_SECS(a5),d0
	beq.s	dc_check_arg_mins
	move.l	d0,a0
	move.l	(a0),d0			; seconds value
	moveq	#adl_seconds_max,d2
	cmp.l	d2,d0
	ble.s   dc_check_arg_mins
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

; Playlist argument: MINS
	CNOP 0,4
dc_check_arg_mins
	move.l	pra_MINS(a5),d1
	beq.s	dc_calculate_playtime
	move.l	d1,a0
	move.l	(a0),d1			; minutes value
	moveq	#adl_minutes_max,d2
	cmp.l	d2,d1
	ble.s	dc_calculate_playtime
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments

	CNOP 0,4
dc_calculate_playtime
	MULUF.W	adl_seconds_factor,d1,d2 ; conversion minutes to seconds
	add.l	d0,d1			; total value in seconds
	MULUF.W	rd_duration_shift,d1,d0
	move.w	d1,pqe_playtime(a1)

; Playlist argument: MULTIPART
	move.l	d6,a1			; entry in playback queue
	move.l	pra_MULTIPART(a5),d0
	beq.s	dc_check_arg_prerunscript
	move.l	d0,a0
	move.l	(a0),d0			; number of demo parts
	bne.s	dc_check_arg_multipart_skip1
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments
	CNOP 0,4
dc_check_arg_multipart_skip1
	cmp.b	#adl_multipart_min,d0
	bge.s	dc_check_arg_multipart_skip2
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra	dc_free_custom_arguments
	CNOP 0,4
dc_check_arg_multipart_skip2
	cmp.b	#adl_multipart_max,d0
	ble.s	dc_check_arg_multipart_skip3
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra.s	dc_free_custom_arguments
	CNOP 0,4
dc_check_arg_multipart_skip3
	subq.b	#1,d0			; only values 1..15
	or.b	d0,pqe_playtime+BYTE_SIZE(a1)

; Playlist argument: PRERUNSCRIPT
dc_check_arg_prerunscript
	move.l	pra_PRERUNSCRIPT(a5),d0
	beq.s	dc_foreward_transmitted_entry
	move.l	d0,a0			; script file name
	move.l	d6,a1			; entry in playback queue
	ADDF.W	pqe_prerunscript_path,a1
	moveq	#0,d0			; counter length of file path
dc_check_arg_prerunscript_loop
	addq.b	#1,d0
	cmp.b	#adl_prerunscript_path_length-1,d0
	blt.s	dc_copy_prerunscript_skip
	move.l	d6,a0			; entry in playback queue
	bsr	dc_parse_playlist_entry_error
	bra.s	dc_free_custom_arguments
	CNOP 0,4
dc_copy_prerunscript_skip
	move.b	(a0)+,(a1)+
	bne.s	dc_check_arg_prerunscript_loop ; loop until nullbyte
dc_foreward_transmitted_entry
	addq.w	#1,dc_transmitted_entries_number(a3)
	addq.w	#1,adl_entries_number(a3)
	move.w	adl_entries_number_max(a3),d0
	cmp.w	adl_entries_number(a3),d0
	bne.s	dc_foreward_playlist_cmd_line
	bsr.s	dc_parse_playlist_file_result
	bra	dc_print_entries_max_message
	CNOP 0,4
dc_foreward_playlist_cmd_line
	add.l	#playback_queue_entry_size,d6 ; next entry
dc_free_custom_arguments
	move.l	a4,d1			; RDArgs structure
	CALLDOS FreeArgs
dc_free_DosObject
	moveq	#DOS_RDARGS,d1
	move.l	a4,d2			; RDArgs structure
	CALLLIBS FreeDosObject
	bra	dc_parse_playlist_file_loop1


; input
; result
	CNOP 0,4
dc_parse_playlist_file_result
	moveq	#0,d1
	move.w	dc_transmitted_entries_number(a3),d1 ; decimal number
	moveq	#2,d7			; number of digits to convert
	lea	dc_transmitted_entries(pc),a0 ; string
	bsr	rp_dec_to_ascii
	moveq	#0,d1
	move.w	dc_playlist_entries_number(a3),d1 ; decimal number
	moveq	#2,d7			; number of digits to convert
	lea	dc_playlist_entries(pc),a0 ; string
	bsr	rp_dec_to_ascii
	lea	dc_parsing_result_text(pc),a0
	move.l	#dc_parsing_result_text_end-dc_parsing_result_text,d0
	bsr	adl_print_text
	bsr	qh_show_queue
	rts


; input
; a0.l	Entry in playback queue
; result
	CNOP 0,4
dc_parse_playlist_entry_error
	bsr.s	dc_clear_playlist_entry
	bsr.s	dc_parse_entry_syntax_error
	rts


; input
; a0.l	Entry to delete
; result
	CNOP 0,4
dc_clear_playlist_entry
	moveq	#0,d0
	MOVEF.W	playback_queue_entry_size-1,d3
dc_clear_playlist_entry_loop
	move.b	d0,(a0)+
	dbf	d3,dc_clear_playlist_entry_loop
	rts


; input
; result
	CNOP 0,4
dc_parse_entry_syntax_error
	moveq	#0,d1
	move.w	dc_playlist_entries_number(a3),d1 ; decimal number
	lea	dc_entries_string(pc),a0 ; string
	move.w	d7,-(a7)
	moveq	#2,d7			; number of digits to convert
	bsr	rp_dec_to_ascii
	move.w	(a7)+,d7
	lea	dc_error_text9(pc),a0
	moveq	#dc_error_text9_end-dc_error_text9,d0
	bsr	adl_print_text
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
dc_check_entries_number_min
	tst.w	adl_entries_number(a3)
	bne.s   dc_check_entries_number_min_ok
	moveq	#RETURN_FAIL,d0
dc_check_entries_number_min_quit
	rts
	CNOP 0,4
dc_check_entries_number_min_ok
	moveq	#RETURN_OK,d0
	bra.s	dc_check_entries_number_min_quit


; input
; result
	CNOP 0,4
dc_close_playlist_file
	move.l	dc_playlist_file_handle(a3),d1
	CALLDOS Close
	rts


; input
; result
	CNOP 0,4
dc_free_playlist_file_buffer
	move.l	dc_playlist_file_buffer(a3),a1
	move.l	dc_playlist_file_length(a3),d0
	CALLEXEC FreeMem
	rts


; input
; result
	CNOP 0,4
dc_free_playlist_file_fib
	move.l	dc_playlist_file_fib(a3),a1
	MOVEF.L	fib_SIZEOF,d0
	CALLEXEC FreeMem
	rts


; input
; result
	CNOP 0,4
dc_unlock_playlist_file
	move.l dc_playlist_file_lock(a3),d1
	CALLDOS UnLock
	rts


; input
; result
	CNOP 0,4
dc_free_entries_buffer
	tst.w	adl_reset_program_active(a3)
	bne.s	dc_free_entries_buffer_skip
dc_free_entries_buffer_quit
	rts
	CNOP 0,4
dc_free_entries_buffer_skip
	move.l	adl_entries_buffer(a3),a1
	move.w	adl_entries_number_max(a3),d0
	mulu.w	#playback_queue_entry_size,d0 ; total playback queue size
	CALLEXEC FreeMem
	bra.s	dc_free_entries_buffer_quit


; Queue Handler
; input
; result
	CNOP 0,4
qh_show_queue
	move.l	adl_entries_buffer(a3),a2
	tst.b	(a2)			; buffer empty ?
	bne.s	qh_show_queue_skip
        lea	qh_info_message_text1(pc),a0
	moveq	#qh_info_message_text1_end-qh_info_message_text1,d0
	bsr	adl_print_text
qh_show_queue_quit
	rts
	CNOP 0,4
qh_show_queue_skip
	moveq	#1,d5			; first order number
	move.w	adl_entries_number(a3),d7
	subq.w	#1,d7			; loopend at false
qh_show_queue_loop
	lea	qh_show_entry_header(pc),a0
	moveq	#qh_show_entry_current_number-qh_show_entry_header,d0
	bsr	adl_print_text
	move.l	d5,d1			; decimal number
	lea	qh_show_entry_current_number(pc),a0 ; string
	move.w	d7,-(a7)
	moveq	#2,d7			; number of digits to convert
	bsr	rp_dec_to_ascii
	move.w	(a7)+,d7
	lea	qh_show_entry_current_number(pc),a0
	moveq	#qh_show_entry_current_number_end-qh_show_entry_current_number,d0
	bsr	adl_print_text
	bsr.s   qh_get_entry_filename
	ADDF.W	playback_queue_entry_size,a2 ; next entry
	addq.w	#1,d5			; increase order number
	dbf	d7,qh_show_queue_loop
	lea	qh_not_used_entries_string(pc),a0
	moveq	#0,d1
	move.w	adl_entries_number_max(a3),d1
	sub.w	adl_entries_number(a3),d1 ; remaining number of entries to load
	moveq	#2,d7			; number of digits to convert
	bsr	rp_dec_to_ascii
	lea	qh_info_message_text2(pc),a0
	moveq	#qh_info_message_text2_end-qh_info_message_text2,d0
	bsr	adl_print_text
	bra.s	qh_show_queue_quit


; input
; a2.l	Entry in playback queue
; result
	CNOP 0,4
qh_get_entry_filename
	moveq	#0,d0			; counter file name length
	moveq	#"/",d2
	moveq	#":",d3
	moveq	#adl_demofile_path_length-1,d6
	move.l	a2,a0
	add.l	d6,a0			; last character (nullbyte)
qh_get_entry_filename_loop
	tst.b	(a0)
	beq.s	qh_get_entry_filename_skip1
	addq.w	#1,d0
qh_get_entry_filename_skip1
	cmp.b	(a0),d2			; "/" found ?
	beq.s	qh_get_entry_filename_skip2
	cmp.b	(a0),d3			; ":" found ?
	beq.s	qh_get_entry_filename_skip2
	subq.w	#BYTE_SIZE,a0		; previous character in file path
	dbf	d6,qh_get_entry_filename_loop
qh_get_entry_filename_skip2
	subq.w	#1,d0			; substract "/" or ":"
	addq.w	#1,a0			; skip "/" or ":"
	cmp.w	#qh_show_entry_space_end-qh_show_entry_space-1,d0 ; output line length max ?
	ble.s	qh_get_entry_filename_skip3
	moveq	#qh_show_entry_space_end-qh_show_entry_space-1,d0
qh_get_entry_filename_skip3
	move.w	d0,d4			; file name length
	bsr	adl_print_text
	lea	qh_show_entry_space(pc),a0 ; output string
	moveq	#qh_show_entry_space_end-qh_show_entry_space-1,d0 ; length output line
	sub.w	d4,d0			; substract file name length
	bsr	adl_print_text
	tst.b	pqe_entry_active(a2)
	bne.s	qh_print_entry_active_text2
	lea	qh_entry_active_text1(pc),a0
	moveq	#qh_entry_active_text1_end-qh_entry_active_text1,d0
	bsr	adl_print_text
qh_get_entry_filename_quit
	rts
	CNOP 0,4
qh_print_entry_active_text2
	lea	qh_entry_active_text2(pc),a0
	moveq	#qh_entry_active_text2_end-qh_entry_active_text2,d0
	bsr	adl_print_text
	bra.s	qh_get_entry_filename_quit


; input
; result
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


; input
; result
	CNOP 0,4
qh_edit_queue
	move.l	adl_entries_buffer(a3),a0
	tst.b	(a0)			; buffer empty ?
	bne.s	qh_edit_queue_skip
        lea	qh_info_message_text1(pc),a0
	moveq	#qh_info_message_text1_end-qh_info_message_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
	move.l	d0,adl_dos_return_code(a3)
qh_edit_queue_quit
	rts
	CNOP 0,4
qh_edit_queue_skip
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
	bra.s	qh_edit_queue_quit


; input
; result
; d0.l	Return-Code
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
qh_lock_workbench_quit
	rts
	CNOP 0,4
qh_lock_workbench_ok
	moveq	#RETURN_OK,d0
	bra.s	qh_lock_workbench_quit


; input
; result
; d0.l	Return-Code
	CNOP 0,4
qh_get_screen_visual_info
	move.l	qh_workbench_screen(a3),a0
	lea	qh_get_visual_info_tags(pc),a1
	CALLGADTOOLS GetVisualInfoA
	move.l	d0,qh_screen_visual_info(a3)
	bne.s	qh_get_screen_visual_info_ok
	lea	qh_error_text2(pc),a0
	moveq	#qh_error_text2_end-qh_error_text2,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
qh_get_screen_visual_info_quit
	rts
	CNOP 0,4
qh_get_screen_visual_info_ok
	moveq	#RETURN_OK,d0
	bra.s	qh_get_screen_visual_info_quit


; input
; result
; d0.l	Return-Code
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
qh_create_context_gadget_quit
	rts
	CNOP 0,4
qh_create_context_gadget_ok
	moveq	#RETURN_OK,d0
	bra.s	qh_create_context_gadget_quit


; input
; result
; d0.l	Return-Code
	CNOP 0,4
qh_create_gadgets
	move.l	qh_workbench_screen(a3),a0
	add.b	sc_WBorTop(a0),d2
	move.l	sc_Font(a0),a0
	move.w	ta_YSize(a0),d2
	addq.w	#1,d2			; window title bar height
	move.l	qh_context_gadget(a3),a4
	bsr	qh_create_text_gadget
	move.l	d0,a4

	tst.w	qh_arg_editentry_enabled(a3)
	beq.s	qh_create_gadgets_skip
	bsr	qh_create_backward_button
	move.l	d0,a4
	bsr	qh_create_integer_gadget
	move.l	d0,a4
	bsr	qh_create_forward_button
	move.l	d0,a4
qh_create_gadgets_skip

	bsr	qh_create_cycle_gadget
	move.l	d0,a4
	bsr	qh_create_mx_gadget
	move.l	d0,a4
	bsr	qh_create_positive_button
	move.l	d0,a4
	bsr	qh_create_negative_button
	tst.l	d0
	bne.s	qh_create_gadgets_ok
	lea	qh_error_text4(pc),a0
	moveq	#qh_error_text4_end-qh_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
qh_create_gadgets_quit
	rts
	CNOP 0,4
qh_create_gadgets_ok
	moveq	#RETURN_OK,d0
	bra.s	qh_create_gadgets_quit


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_text_gadget
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
	move.w	qh_edit_entry_offset(a3),d0
	subq.w	#1,d0			; count starts at 0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
 	add.l	d0,a0			; entry in playback queue
	move.l	a0,qh_edit_entry(a3)
	bsr	qh_get_demofile_title
	move.l	d0,qh_edit_entry_demo_filename(a3)
	move.l	a4,a0 			; previous gadget
	lea	qh_text_gadget_tags(pc),a2
	move.l	d0,ti_Data(a2)		; file name
	move.l	#TEXT_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,qh_text_gadget(a3)
	rts


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_backward_button
	lea	qh_new_gadget(pc),a1
	move.w	#qh_backward_button_x_position,gng_LeftEdge(a1)
	moveq	#qh_backward_button_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_backward_button_x_size,gng_Width(a1)
	move.w	#qh_backward_button_y_size,gng_Height(a1)
	lea	qh_backward_button_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_backward_button_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	moveq	#BOOL_FALSE,d0		; gadget state: active
	cmp.w	#adl_entries_number_min,qh_edit_entry_offset(a3)
        bne.s	qh_create_backward_button_skip
	moveq	#BOOL_TRUE,d0		; gadget state: inactive
qh_create_backward_button_skip
	move.l	a4,a0			; previous gadget
	lea	qh_button_tags(pc),a2
 	move.l	d0,ti_Data(a2)		; gadget state
	move.l	#BUTTON_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,qh_backward_button_gadget(a3)
	rts


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_integer_gadget
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
	move.l	a4,a0			; previous gadget
	lea	qh_integer_gadget_tags(pc),a2
	move.l	#INTEGER_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,qh_integer_gadget(a3)
	rts


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_forward_button
	lea	qh_new_gadget(pc),a1
	move.w	#qh_foreward_button_x_position,gng_LeftEdge(a1)
	moveq	#qh_foreward_button_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_foreward_button_x_size,gng_Width(a1)
	move.w	#qh_foreward_button_y_size,gng_Height(a1)
	lea	qh_foreward_button_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_foreward_button_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	moveq	#BOOL_FALSE,d0		; gadget state: active
	move.w	qh_edit_entry_offset(a3),d1
	cmp.w	adl_entries_number(a3),d1
        blt.s	qh_create_forward_button_skip
	moveq	#BOOL_TRUE,d0		; gadget state: inactive
qh_create_forward_button_skip
	move.l	a4,a0			; previous gadget
	lea	qh_button_tags(pc),a2
 	move.l	d0,ti_Data(a2)		; gadget state
	move.l	#BUTTON_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,qh_foreward_button_gadget(a3)
	rts


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_cycle_gadget
	lea	qh_new_gadget(pc),a1
	move.w	#qh_cycle_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_cycle_gadget_y_position1,d0
	tst.w	qh_arg_editentry_enabled(a3)
	beq.s	qh_create_cycle_gadget_skip
	moveq	#qh_cycle_gadget_y_position2,d0
qh_create_cycle_gadget_skip
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_cycle_gadget_x_size,gng_Width(a1)
	move.w	#qh_cycle_gadget_y_size,gng_Height(a1)
	moveq	#0,d0
	move.l  d0,gng_GadgetText(a1)
	move.w	#qh_cycle_gadget_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.w	qh_edit_entry_offset(a3),d0
	subq.w	#1,d0			; count starts at 0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0			; entry in playback queue
	moveq	#0,d0
	move.b	pqe_runmode(a0),d0
	subq.b	#1,d0			; order number selection text
	move.l	a4,a0			; previous gadget
	lea	qh_cycle_gadget_tags(pc),a2
	move.l	d0,(1*ti_SIZEOF)+ti_Data(a2) ; order number selection text
	move.l	#CYCLE_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,qh_cycle_gadget(a3)
	rts


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_mx_gadget
	lea	qh_new_gadget(pc),a1
	move.w	#qh_mx_gadget_x_position,gng_LeftEdge(a1)
	moveq	#qh_mx_gadget_y_position1,d0
	tst.w	qh_arg_editentry_enabled(a3)
	beq.s	qh_create_mx_gadget_skip
	moveq	#qh_mx_gadget_y_position2,d0
qh_create_mx_gadget_skip
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	moveq	#0,d0
	move.l  d0,gng_GadgetText(a1)
        move.w	#qh_mx_gadget_id,gng_GadgetID(a1)
	moveq	#PLACETEXT_RIGHT,d0
	move.l	d0,gng_Flags(a1)
	move.w	qh_edit_entry_offset(a3),d0
	subq.w	#1,d0			; count starts at 0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0			; entry in playback queue
	moveq	#0,d0
	move.b	pqe_entry_active(a0),d0
        neg.b	d0			; order number selection text
	move.l	a4,a0			; previous gadget
	lea	qh_mx_gadget_tags(pc),a2
	move.l	d0,(1*ti_SIZEOF)+ti_Data(a2) ; order number selection text
	move.l	#MX_KIND,d0
	CALLGADTOOLS CreateGadgetA
	move.l	d0,qh_mx_gadget(a3)
	rts


; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
; d0.l	This gadget structure
	CNOP 0,4
qh_create_positive_button
	lea	qh_new_gadget(pc),a1
	move.w	#qh_positive_button_x_position,gng_LeftEdge(a1)
	moveq	#qh_positive_button_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_positive_button_x_size,gng_Width(a1)
	move.w	#qh_positive_button_y_size,gng_Height(a1)
	lea	qh_positive_button_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_positive_button_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.l	a4,a0			; previous gadget
	lea	qh_button_tags(pc),a2
	moveq	#BOOL_FALSE,d0		; gadget state: active
 	move.l	d0,ti_Data(a2)		; gadget state
	move.l	#BUTTON_KIND,d0
	CALLGADTOOLS CreateGadgetA
	rts

; Input
; d2.w	Window title bar height
; a4.l	Previous gadget structure
; Result
	CNOP 0,4
qh_create_negative_button
	lea	qh_new_gadget(pc),a1
	move.w	#qh_negative_button_x_position,gng_LeftEdge(a1)
	moveq	#qh_negative_button_y_position,d0
	add.w	d2,d0
	move.w	d0,gng_TopEdge(a1)
	move.w	#qh_negative_button_x_size,gng_Width(a1)
	move.w	#qh_negative_button_y_size,gng_Height(a1)
	lea	qh_negative_button_text(pc),a0
	move.l  a0,gng_GadgetText(a1)
        move.w	#qh_negative_button_id,gng_GadgetID(a1)
	moveq	#0,d0
	move.l	d0,gng_Flags(a1)
	move.l	a4,a0			; previous gadget
	lea	qh_button_tags(pc),a2
	move.l	#BUTTON_KIND,d0
	CALLGADTOOLS CreateGadgetA
	rts


; input
; a0.l	Entry in playback queue
; result
; d0.l	File name
	CNOP 0,4
qh_get_demofile_title
	moveq	#adl_demofile_path_length-1,d6
	add.l	d6,a0			; end of path
qh_get_demofile_title_loop
	cmp.b	#"/",(a0)
	beq.s	qh_get_demofile_title_skip
	cmp.b	#":",(a0)
	beq.s	qh_get_demofile_title_skip
	subq.w	#BYTE_SIZE,a0		; previous character in file path
	dbf	d6,qh_get_demofile_title_loop
qh_get_demofile_title_skip
	addq.w	#BYTE_SIZE,a0		; skip "/" or ":"
	move.l	a0,d0
	rts


; input
; result
; d0.l	Return-Code
	CNOP 0,4
qh_open_edit_window
	sub.l	a0,a0			; no NewWindow structure
	lea	qh_edit_window_tags(pc),a1
	move.l	qh_gadget_list(pc),ewtl_WA_Gadgets+ti_Data(a1)
	CALLINT OpenWindowTagList
	move.l	d0,qh_edit_window(a3)
	bne.s	qh_open_edit_window_skip1
	lea	qh_error_text5(pc),a0
	moveq	#qh_error_text5_end-qh_error_text5,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
qh_open_edit_window_quit
	rts
	CNOP 0,4
qh_open_edit_window_skip1
	move.l	d0,a2			; store window structure
	move.l	d0,a0			; window structure
	sub.l	a1,a1			; no requester
	CALLGADTOOLS GT_RefreshWindow
        move.l	a2,a0			; window structure
	lea	qh_edit_window_name1(pc),a1 ; new window title
	tst.w	qh_arg_editentry_enabled(a3)
	beq.s	qh_open_edit_window_skip2
	lea	qh_edit_window_name2(pc),a1 ; new window title
qh_open_edit_window_skip2
	move.w	#-1,a2			; screen title remains the same
	CALLINT SetWindowTitles
	moveq	#RETURN_OK,d0
	bra.s	qh_open_edit_window_quit


; input
; result
	CNOP 0,4
qh_process_window_events
	move.l	qh_edit_window(a3),a0
	move.l	wd_UserPort(a0),a2
	moveq	#0,d0
        move.b	MP_SigBit(a2),d1
	bset	d1,d0			; signal number
	move.l	a2,a0			; port
	CALLEXEC Wait
	move.l	a2,a0
	CALLGADTOOLS GT_GetIMsg
	move.l	d0,a4			; intuition message
	move.l	im_Class(a4),d0		; IDCMP

	cmp.l	#IDCMP_GADGETUP,d0
	bne	qh_process_window_events_skip10
	move.l	im_IAddress(a4),a0

	cmp.w	#qh_backward_button_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_skip2
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	cmp.w	#adl_entries_number_min,d0
	beq.s   qh_process_window_events_skip1
        subq.w	#1,d0			; previous entry
qh_process_window_events_skip1
	move.w	d0,qh_edit_entry_offset(a3)
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	bsr	qh_edit_fetch_entry
	moveq	#0,d2
	move.w	qh_edit_entry_offset(a3),d2
	move.l	qh_edit_entry_demo_filename(a3),a2
	move.l	qh_edit_entry(a3),a5
	bsr	qh_update_gadgets
	bra	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip2
	cmp.w	#qh_integer_gadget_id,gg_GadgetID(a0)
	bne	qh_process_window_events_skip5
	move.l	gg_SpecialInfo(a0),a0
	move.l	si_Buffer(a0),a0	; string
	moveq	#2,d7			; number of digits to convert
	bsr	qh_ascii_to_dec
	cmp.w	#adl_entries_number_min,d0
	bge.s	qh_process_window_events_skip3
	move.l	qh_workbench_screen(a3),a0
	CALLINT DisplayBeep
	moveq	#adl_entries_number_min,d0
	bra.s	qh_process_window_events_skip4
	CNOP 0,4
qh_process_window_events_skip3
	moveq	#0,d2
	move.w	adl_entries_number(a3),d2
	cmp.w	d2,d0
	ble.s   qh_process_window_events_skip4
	move.l	qh_workbench_screen(a3),a0
	CALLINT DisplayBeep
	move.l	d2,d0
qh_process_window_events_skip4
	move.w	d0,qh_edit_entry_offset(a3)
	bsr	qh_edit_fetch_entry
	moveq	#0,d2
	move.w	qh_edit_entry_offset(a3),d2
	move.l	qh_edit_entry_demo_filename(a3),a2
	move.l	qh_edit_entry(a3),a5
	bsr	qh_update_gadgets
	bra	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip5
	cmp.w	#qh_foreward_button_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_skip7
	move.w	qh_edit_entry_offset(a3),d0
	cmp.w	adl_entries_number(a3),d0
	beq.s   qh_process_window_events_skip6
        addq.w	#1,d0			; next entry
qh_process_window_events_skip6
	move.w	d0,qh_edit_entry_offset(a3)
	moveq	#0,d0
	move.w	qh_edit_entry_offset(a3),d0
	bsr	qh_edit_fetch_entry
	moveq	#0,d2
	move.w	qh_edit_entry_offset(a3),d2
	move.l	qh_edit_entry_demo_filename(a3),a2
	move.l	qh_edit_entry(a3),a5
	bsr	qh_update_gadgets
	bra	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip7
	cmp.w	#qh_cycle_gadget_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_skip8
	move.w	im_Code(a4),d0
	addq.b	#1,d0
	move.b	d0,qh_edit_runmode(a3)
	bra	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip8
	cmp.w	#qh_positive_button_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_skip9
	move.l	qh_edit_entry(a3),a0
	move.b	qh_edit_runmode(a3),pqe_runmode(a0)
	move.b	qh_edit_entry_active(a3),pqe_entry_active(a0)
	move.w	#FALSE,qh_check_window_events_active(a3)
	bra.s	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip9
	cmp.w	#qh_negative_button_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_ok
	move.w	#FALSE,qh_check_window_events_active(a3)
	bra.s	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip10
	cmp.l	#IDCMP_GADGETDOWN,d0
	bne.s	qh_process_window_events_skip11
	move.l	im_IAddress(a4),a0
	cmp.w	#qh_mx_gadget_id,gg_GadgetID(a0)
	bne.s	qh_process_window_events_ok
	move.w	im_Code(a4),d0
	neg.b	d0
	move.b	d0,qh_edit_entry_active(a3)
	bra.s	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip11
	cmp.l	#IDCMP_CLOSEWINDOW,d0
	bne.s	qh_process_window_events_skip12
	move.w	#FALSE,qh_check_window_events_active(a3)
      	bra.s	qh_process_window_events_ok

	CNOP 0,4
qh_process_window_events_skip12
	cmp.l	#IDCMP_REFRESHWINDOW,d0
	bne.s   qh_process_window_events_ok
	move.l	qh_edit_window(a3),a5
	move.l	a5,a0
	CALLGADTOOLS GT_BeginRefresh
	move.l	a5,a0			; window structure
	moveq	#BOOL_TRUE,d0		; completed
	CALLLIBS GT_EndRefresh
qh_process_window_events_ok
	move.l	a4,a1			; intuition message
	move.l	qh_edit_window(a3),a0
	move.l	wd_UserPort(a0),a2
	CALLGADTOOLS GT_ReplyIMsg
	tst.w	qh_check_window_events_active(a3)
	beq	qh_process_window_events
	rts


; input
; a0.l	String
; d7.l	Number of digits to convert
; result
; d0.l	Decimal number
	CNOP 0,4
qh_ascii_to_dec
	tst.b	1(a0)
	bne.s	qh_ascii_to_dec_skip
	subq.w	#1,d7			; adjust number of digits
qh_ascii_to_dec_skip
	add.l	d7,a0			; end of string
	lea	rp_dec_table(pc),a1
	moveq	#0,d0			; result decimal number
	subq.w	#1,d7			; loopend at false
qh_ascii_to_dec_loop
	move.l	(a1)+,d2                ; decimal digits value [1,10,..]
	moveq	#0,d3
	move.b	-(a0),d3		; ascii value
	sub.b	#"0",d3			; substract ascii value "0" = 0..9
	mulu.w	d2,d3			; decimale base
	add.l	d3,d0			; add digit to result
	dbf	d7,qh_ascii_to_dec_loop
	rts


; input
; d0.l	Entry index number [1..n]
; result
	CNOP 0,4
qh_edit_fetch_entry
	subq.w	#1,d0			; count starts at 0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0                   ; entry in playback queue
	move.l	a0,qh_edit_entry(a3)
	bsr	qh_get_demofile_title
	move.l	d0,qh_edit_entry_demo_filename(a3)
	rts


; input
; d2.l	Entry index number [1..n]
; a2.l	file name
; a5.l	entry in playback queue
; result
	CNOP 0,4
qh_update_gadgets
	move.l	qh_text_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	move.l	a3,-(a7)
	lea	qh_set_text_gadget_tags(pc),a3
	move.l	a2,ti_Data(a3)		; file name
	sub.l	a2,a2			; no requester
 	CALLGADTOOLS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_backward_button_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; no requester
	moveq	#BOOL_FALSE,d0		; gadget state: active
	cmp.w	#adl_entries_number_min,qh_edit_entry_offset(a3)
        bne.s	qh_update_gadgets_skip1
	moveq	#BOOL_TRUE,d0		; gadget state: inactive
qh_update_gadgets_skip1
	move.l	a3,-(a7)
	lea	qh_set_button_tags(pc),a3
	move.l	d0,ti_Data(a3)		; gadget state
 	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_integer_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; no requester
	move.l	a3,-(a7)
	lea	qh_set_integer_gadget_tags(pc),a3
	move.l	d2,ti_Data(a3)
 	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3
; Forward button gadget
	move.l	qh_foreward_button_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; no requester
	moveq	#BOOL_FALSE,d0		; gadget state: active
	move.w	qh_edit_entry_offset(a3),d1
	cmp.w	adl_entries_number(a3),d1
        blt.s	qh_update_gadgets_skip2
	moveq	#BOOL_TRUE,d0		; gadget state: inactive
qh_update_gadgets_skip2
	move.l	a3,-(a7)
	lea	qh_set_button_tags(pc),a3
	move.l	d0,ti_Data(a3)		; gadget state
 	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_cycle_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; no requester
	move.l	a3,-(a7)
	lea	qh_set_cycle_gadget_tags(pc),a3
	moveq	#0,d0
	move.b	pqe_runmode(a5),d0
	subq.b	#1,d0
	move.l	d0,ti_Data(a3)		; index number selection text
 	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3

	move.l	qh_mx_gadget(a3),a0
	move.l	qh_edit_window(a3),a1
	sub.l	a2,a2			; no requester
	move.l	a3,-(a7)
	lea	qh_set_mx_gadget_tags(pc),a3
	moveq	#0,d0
	move.b	pqe_entry_active(a5),d0
	neg.b	d0
	move.l	d0,ti_Data(a3)		; index number selection text
 	CALLLIBS GT_SetGadgetAttrsA
	move.l	(a7)+,a3
	rts


; input
; result
	CNOP 0,4
qh_close_edit_window
	move.l	qh_edit_window(a3),a0
	CALLINT CloseWindow
	rts


; input
; result
	CNOP 0,4
qh_free_gadgets
	move.l	qh_gadget_list(pc),a0
	CALLGADTOOLS FreeGadgets
	rts


; input
; result
	CNOP 0,4
qh_free_screen_visual_info
	move.l	qh_screen_visual_info(a3),a0
	CALLGADTOOLS FreeVisualInfo
	rts


; input
; result
	CNOP 0,4
qh_unlock_workbench
	sub.l	a0,a0			; no name
	move.l	qh_workbench_screen(a3),a1
	CALLINT UnLockPubScreen
	rts


; input
; result
	CNOP 0,4
qh_clear_queue
	move.l	adl_entries_buffer(a3),a0
	tst.b	(a0)			; empty buffer ?
	bne.s   qh_clear_queue_ok
	lea	qh_info_message_text4(pc),a0
	moveq	#qh_info_message_text4_end-qh_info_message_text4,d0
	bsr	adl_print_text
qh_clear_queue_quit
	rts
	CNOP 0,4
qh_clear_queue_ok
	move.w	adl_entries_number(a3),d7
	subq.w	#1,d7			; loopend at false
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
	lea	qh_info_message_text5(pc),a0
	moveq	#qh_info_message_text5_end-qh_info_message_text5,d0
	bsr	adl_print_text
	bra.s	qh_clear_queue_quit


; input
; result
	CNOP 0,4
qh_free_visual_info
	move.l	qh_screen_visual_info(a3),a0
	CALLGADTOOLS FreeVisualInfo
	rts


; input
; result
	CNOP 0,4
qh_reset_queue
	cmp.w	#adl_entries_number_min,rd_entry_offset(a3)
        bne.s	qh_reset_queue_ok
	lea	qh_info_message_text6(pc),a0
	moveq	#qh_info_message_text6_end-qh_info_message_text6,d0
	bsr	adl_print_text
qh_reset_queue_quit
	rts
	CNOP 0,4
qh_reset_queue_ok
	move.w	#adl_entries_number_min,rd_entry_offset(a3)
	bsr	rd_deactivate_queue
	lea	qh_info_message_text7(pc),a0
	moveq	#qh_info_message_text7_end-qh_info_message_text7,d0
	bsr	adl_print_text
	bra.s	qh_reset_queue_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
qh_check_queue_empty
	move.l	adl_entries_buffer(a3),a2
	tst.b	(a2)			; buffer empty ?
	bne.s	qh_check_queue_empty_ok
	moveq	#RETURN_WARN,d0
qh_check_queue_empty_quit
	rts
	CNOP 0,4
qh_check_queue_empty_ok
	moveq	#RETURN_OK,d0
	bra.s	qh_check_queue_empty_quit


; Amiga Demo Launcher

; input
; result
	CNOP 0,4
adl_free_read_arguments
	move.l	adl_read_arguments(a3),d1
	bne.s	adl_free_read_arguments_skip
adl_free_read_arguments_quit
	rts
	CNOP 0,4
adl_free_read_arguments_skip
	CALLDOS FreeArgs
	bra.s	adl_free_read_arguments_quit


; input
; result
	CNOP 0,4
adl_print_io_error
	move.l	adl_dos_return_code(a3),d1
	moveq	#ERROR_NO_FREE_STORE,d0
	cmp.l	d0,d1
	bge.s	adl_print_io_error_skip1
adl_print_io_error_quit
	rts
	CNOP 0,4
adl_print_io_error_skip1
	lea	adl_error_text_header(pc),a0
	move.l	a0,d2                   ; header error message
	CALLDOS PrintFault
	lea	adl_error_text_tail(pc),a0 ; error text
	moveq	#adl_error_text_tail_end-adl_error_text_tail,d0 ; length of text
	bsr	adl_print_text
	bra.s	adl_print_io_error_quit


; input
; result
	CNOP 0,4
adl_remove_reset_program
	tst.w	adl_arg_remove_enabled(a3)
	beq.s	adl_remove_reset_program_skip1
	rts
	CNOP 0,4
adl_remove_reset_program_skip1
	tst.w	adl_reset_program_active(a3)
	beq.s	adl_remove_reset_program_skip2
	lea	adl_message_text2(pc),a0
	moveq	#adl_message_text2_end-adl_message_text2,d0
	bsr	adl_print_text
adl_remove_reset_program_quit
	rts
	CNOP 0,4
adl_remove_reset_program_skip2
	REMOVE_RESET_PROGRAM
	move.l	d0,a0
	move.l	(a0)+,a1		; pointer reset program		
	moveq	#0,d0
	move.l	d0,LONGWORD_SIZE(a1)	; clear ADL id
	move.l	(a0),d0			; total size of reset program section including playback queue
	CALLEXEC FreeMem
	lea	adl_message_text1(pc),a0
	moveq	#adl_message_text1_end-adl_message_text1,d0
	bsr	adl_print_text
	bra.s	adl_remove_reset_program_quit


; input
; result
	CNOP 0,4
adl_close_icon_library
	move.l	_IconBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; input
; result
	CNOP 0,4
adl_close_asl_library
	move.l	_ASLBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; input
; result
	CNOP 0,4
adl_close_gadtools_library
	move.l	_GadToolsBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; input
; result
	CNOP 0,4
adl_close_intuition_library
	move.l	_IntuitionBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; input
; result
	CNOP 0,4
adl_close_graphics_library
	move.l	_GfxBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; input
; result
	CNOP 0,4
adl_close_dos_library
	move.l	_DOSBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; input
; a0.l	text
; d0.l	Length of text
; result
	CNOP 0,4
adl_print_text
	move.l	adl_output_handle(a3),d1
	move.l	a0,d2			; text
	move.l	d0,d3			; number of characters to write
	CALLDOS Write
	rts


; Run Demo
	CNOP 0,4
rd_start
	bsr	rd_open_ciaa_resource
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
	bsr	rd_open_ciab_resource
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments

	bsr	rd_create_serial_msg_port
	move.l	d0,adl_dos_return_code(a3)
	bne	adl_cleanup_read_arguments
	
	bsr	rd_open_serial_device
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_serial_msg_port

	bsr	rd_open_timer_device
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_serial_device

	bsr	rd_alloc_mouse_pointer_data
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_timer_device

	bsr	rd_get_active_screen
	move.l	d0,rd_active_screen(a3)
	bsr	rd_get_first_window
	move.l	d0,rd_first_window(a3)
	bsr	rd_check_screen_mode
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_mouse_pointer_data
	bsr	rd_get_sprite_resolution

rd_play_loop
	bsr	rd_check_queue
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_mouse_pointer_data
	bsr	rd_get_new_entry_offset
	bsr	rd_get_demo_filename
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_print_demofile_start_message
	bsr	rd_check_runmode
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_io_error
	bsr	rd_check_demofile_state
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

	bsr	rd_open_pal_screen
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_original_screen
	bsr	rd_load_pal_screen_colors
	bsr	rd_check_pal_screen_mode
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_original_screen
	bsr	rd_open_invisible_window
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_pal_screen
	bsr	rd_clear_mousepointer
	bsr	rd_blank_display
	bsr	rd_wait_monitor_switch

	bsr	rd_disable_fast_memory
	bsr	rd_load_demofile
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_fast_memory
	bsr	rd_check_whdloadfile
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_demofile

	bsr	adl_wait_drives_motor

	bsr	rd_init_playtimer_start
	bsr	rd_start_playtimer
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_demofile

	bsr	rd_get_system_time

	bsr	rd_save_custom_traps
	bsr	rd_downgrade_cpu
	IFEQ rd_yulquen74_code_enabled
		bsr	rd_downgrade_cpu_clock
	ENDC
	bsr	rd_get_tod_time
	bsr	rd_save_chips_registers

	bsr	rd_run_dos_file
	bsr	rd_execute_whdload_slave
	move.l	d0,adl_dos_return_code(a3)
	bne	rd_cleanup_demofile
	bsr	rd_check_softreset

	bsr	rd_clear_chips_registers
	bsr	rd_restore_chips_registers
	bsr	rd_get_tod_duration
	IFEQ rd_yulquen74_code_enabled
		bsr	rd_upgrade_cpu_clock
	ENDC
	bsr	rd_restore_custom_traps
	bsr	rd_upgrade_cpu

	bsr	rd_init_playtimer_stop
	bsr	rd_stop_playtimer
	move.l	d0,adl_dos_return_code(a3)

	bsr	rd_update_system_time

rd_cleanup_demofile
	bsr	rd_unload_demofile

rd_cleanup_fast_memory
	bsr	rd_enable_fast_memory

	bsr	rd_restore_sprite_resolution
	bsr	rd_wait_monitor_switch
	bsr	rd_close_invisible_window
rd_cleanup_pal_screen
	bsr	rd_close_pal_screen

rd_cleanup_original_screen
	bsr	rd_activate_first_window

rd_cleanup_current_dir
	bsr	rd_restore_current_dir

rd_cleanup_io_error
	bsr	adl_print_io_error

	bsr	rd_check_user_break
	move.l	d0,adl_dos_return_code(a3)
	bne.s	rd_cleanup_mouse_pointer_data

	bsr	rd_reset_demo_variables

	bsr	rd_check_arg_loop_enabled
	tst.l	d0
	beq	rd_play_loop

rd_cleanup_mouse_pointer_data
	bsr	rd_free_mouse_pointer_data

rd_cleanup_timer_device
	bsr	rd_close_timer_device

rd_cleanup_serial_device
	bsr	rd_close_serial_device
rd_cleanup_serial_msg_port
	bsr	rd_delete_serial_msg_port

rd_quit
	bra	adl_cleanup_read_arguments


; input
; a0.l	error text
; d0.l	Text length
; result
	CNOP 0,4
rd_print_error_text
	movem.l	d0/a0,-(a7)
	lea	rd_error_text_header_index(pc),a0
	move.w	rd_entry_offset(a3),d1
	subq.w	#1,d1			; count starts at 0
        moveq	#2,d7
	bsr	rp_dec_to_ascii
	move.l	adl_output_handle(a3),d1
	lea	rd_error_text_header(pc),a0
	move.l	a0,d2
	moveq	#rd_error_text_header_end-rd_error_text_header,d3 ; number of characters to write
	CALLDOS Write
	movem.l	(a7)+,d0/a0
	move.l	adl_output_handle(a3),d1
	move.l	a0,d2			; text
	move.l	d0,d3			; number of characters to write
	CALLLIBS Write
	tst.w	rd_arg_resetonerror_enabled(a3)
	bne.s	rd_print_error_text_quit
	MOVEF.L	rd_error_message_delay,d1
	CALLLIBS Delay
	CALLEXEC ColdReboot
rd_print_error_text_quit
	rts


; input
; result
; d0.l	Return code
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
rd_open_ciaa_resource_quit
	rts
	CNOP 0,4
rd_open_ciaa_resource_skip
	moveq	#0,d0			; no mask
	CALLCIA AbleICR
	lea	rd_old_chips_registers+ocr_ciaa_icr(pc),a0
	move.b	d0,(a0)
	moveq	#RETURN_OK,d0
	bra.s	rd_open_ciaa_resource_quit


; input
; result
; d0.l	Return code
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
rd_open_ciab_resource_quit
	rts
	CNOP 0,4
rd_open_ciab_resource_skip
	moveq	#0,d0			; no mask
	CALLCIA AbleICR
	lea	rd_old_chips_registers+ocr_ciab_icr(pc),a0
	move.b	d0,(a0)
	moveq	#RETURN_OK,d0
	bra.s	rd_open_ciab_resource_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_create_serial_msg_port
	CALLEXEC CreateMsgPort
	move.l	d0,rd_serial_msg_port(a3)
	bne.s	rd_create_serial_msg_port_ok
	lea	rd_error_text3(pc),a0
	moveq	#rd_error_text3_end-rd_error_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_create_serial_msg_port_quit
	rts
	CNOP 0,4
rd_create_serial_msg_port_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_create_serial_msg_port_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_open_serial_device
	lea	serial_device_name(pc),a0
	lea	rd_serial_io(pc),a1
	move.l	rd_serial_msg_port(a3),MN_ReplyPort(a1)
	moveq	#0,d0			; unit 0
	moveq	#0,d1			; no flags
	CALLEXEC OpenDevice
	tst.l	d0
	beq.s	rd_open_serial_device_ok
	lea	rd_error_text4(pc),a0
	moveq	#rd_error_text4_end-rd_error_text4,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_open_serial_device_quit
	rts
	CNOP 0,4
rd_open_serial_device_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_open_serial_device_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_open_timer_device
	lea	timer_device_name(pc),a0
	lea	rd_timer_io(pc),a1
	moveq	#UNIT_MICROHZ,d0
	moveq	#0,d1			; no flags
	CALLEXEC OpenDevice
	tst.l	d0
	beq.s	rd_open_timer_device_ok
	lea	rd_error_text5(pc),a0
	moveq	#rd_error_text5_end-rd_error_text5,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_open_timer_device_quit
	rts
	CNOP 0,4
rd_open_timer_device_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_open_timer_device_quit


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
rd_alloc_mouse_pointer_data
	moveq	#sprite_pointer_data_size,d0
	move.l	#MEMF_CLEAR|MEMF_CHIP|MEMF_PUBLIC|MEMF_REVERSE,d1
	CALLEXEC AllocMem
	move.l	d0,rd_mouse_pointer_data(a3)
	bne.s	rd_alloc_mouse_pointer_data_ok
	lea	rd_error_text6(pc),a0
	moveq	#rd_error_text6_end-rd_error_text6,d0
	bsr	adl_print_text
	moveq	#ERROR_NO_FREE_STORE,d0
rd_alloc_mouse_pointer_data_quit
	rts
	CNOP 0,4
rd_alloc_mouse_pointer_data_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_alloc_mouse_pointer_data_quit


; input
; result
	CNOP 0,4
rd_get_sprite_resolution
	move.l	rd_active_screen(a3),d0
	bne.s	rd_get_sprite_resolution_skip
rd_get_sprite_resolution_quit
	rts
	CNOP 0,4
rd_get_sprite_resolution_skip
	move.l	d0,a0
	move.l  sc_ViewPort+vp_ColorMap(a0),a0
	lea	rd_video_control_tags(pc),a1
	move.l	a1,a2
	move.l	#VTAG_SPRITERESN_GET,vctl_VTAG_SPRITERESN+ti_tag(a1)
	clr.l	vctl_VTAG_SPRITERESN+ti_Data(a1)
	CALLGRAF VideoControl
	move.l  vctl_VTAG_SPRITERESN+ti_Data(a2),rd_old_sprite_resolution(a3)
	bra.s	rd_get_sprite_resolution_quit


; Input
; Result
; d0.l  Window structure first window
		CNOP 0,4
rd_get_first_window
		move.l	rd_active_screen(a3),d0
		bne.s	rd_get_first_window_skip
rd_get_first_window_quit
		rts
		CNOP 0,4
rd_get_first_window_skip
		move.l	d0,a0
		move.l	sc_FirstWindow(a0),d0
		bra.s	rd_get_first_window_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_screen_mode
	move.l	rd_active_screen(a3),d0
	beq.s	rd_check_screen_mode_ok
	move.l	d0,a0
	ADDF.W	sc_ViewPort,a0
	CALLGRAF GetVPModeID
	cmp.l	#INVALID_ID,d0
	bne.s	rd_check_screen_mode_skip
	lea	rd_error_text7(pc),a0
	moveq	#rd_error_text7_end-rd_error_text7,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_check_screen_mode_quit
	rts
	CNOP 0,4
rd_check_screen_mode_skip
	and.l	#MONITOR_ID_MASK,d0	; without resolution
	move.l	d0,rd_active_screen_mode(a3)
rd_check_screen_mode_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_screen_mode_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_queue
	move.l	adl_entries_buffer(a3),a0
	ADDF.W	pqe_entry_active,a0
	MOVEF.L	playback_queue_entry_size,d0
	move.w	adl_entries_number(a3),d7
	subq.w	#1,d7			; loopend at false
rd_check_queue_loop
	tst.b	(a0)
	beq.s	rd_check_queue_ok
	add.l	d0,a0			; next entry
	dbf	d7,rd_check_queue_loop
	tst.w	rd_arg_endless_enabled(a3)
	beq.s   rd_check_queue_skip
	lea	rd_info_message_text1(pc),a0
	moveq	#rd_info_message_text1_end-rd_info_message_text1,d0
	bsr	adl_print_text
	moveq	#RETURN_WARN,d0
rd_check_queue_quit
	rts
	CNOP 0,4
rd_check_queue_skip	
	bsr.s	rd_deactivate_queue
rd_check_queue_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_queue_quit


; input
; result
	CNOP 0,4
rd_deactivate_queue
	MOVEF.L	playback_queue_entry_size,d1
	move.l	adl_entries_buffer(a3),a0
	ADDF.W	pqe_entry_active,a0
	move.w	adl_entries_number(a3),d7
	subq.w  #1,d7			; loopend at false
rd_deactivate_queue_loop
	clr.b	(a0)			; entry state played
	add.l	d1,a0			; next entry
	dbf	d7,rd_deactivate_queue_loop
	move.w	#adl_entries_number_min,rd_entry_offset(a3)
	GET_RESIDENT_ENTRY_OFFSET
	move.l	d0,a0
	move.w	#adl_entries_number_min,(a0)
	rts


; input
; result
	CNOP 0,4
rd_get_new_entry_offset
	tst.w	rd_arg_random_enabled(a3)
	bne.s	rd_get_random_entry_skip1
rd_get_random_entry_loop
	moveq	#0,d2
	move.w	adl_entries_number(a3),d2
	bsr.s	rd_get_random_entry
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0			; entry in playback queue
	tst.b	pqe_entry_active(a0)	; entry already played ?
	bne.s	rd_get_random_entry_loop
	bra.s	rd_get_random_entry_skip2
	CNOP 0,4
rd_get_random_entry_skip1
	move.w	rd_entry_offset(a3),d0
	subq.w	#1,d0			; count starts at 0
	mulu.w	#playback_queue_entry_size,d0
	move.l	adl_entries_buffer(a3),a0
	add.l	d0,a0			; entry in playback queue
rd_get_random_entry_skip2
	move.l	a0,rd_demofile_path(a3)
	rts


; input
; d2.w	Number of entries
; result
; d0.l	Random offset
	CNOP 0,4
rd_get_random_entry
	move.w	_CUSTOM+VHPOSR,d0	; f(x)
	mulu.w	_CUSTOM+VHPOSR,d0	; f(x)*a
	move.w	_CUSTOM+VHPOSR,d1
	swap	d1
	move.b	_CIAA+CIATODLOW,d1
	lsl.w	#8,d1
	move.b	_CIAB+CIATODLOW,d1	; b
	add.l	d1,d0			; (f(x)*a)+b
	and.l	#$0000ffff,d0		; only low word
	divu.w	d2,d0			; f(x+1) = [(f(x)*a)+b]/mod rp_entries_number
	swap	d0			; remainder of division = random offset
	ext.l	d0
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_get_demo_filename
	move.l	rd_demofile_path(a3),a0
	moveq	#0,d0			; counter length of file name
	moveq	#"/",d2
	moveq	#":",d3
	moveq	#adl_demofile_path_length-1,d7
	add.l	d7,a0			; last character (nullbyte)
rd_get_demo_filename_loop
	tst.b	(a0)
	beq.s	rd_get_demo_filename_skip2
	addq.w	#1,d0			; decrement counter
rd_get_demo_filename_skip2
	cmp.b	(a0),d2			; "/" found ?
	beq.s	rd_get_demo_filename_skip3
	cmp.b	(a0),d3			; ":" found ?
	beq.s	rd_get_demo_filename_skip3
	subq.w	#BYTE_SIZE,a0		; previous character
	dbf	d7,rd_get_demo_filename_loop
rd_get_demo_filename_skip3
	addq.w	#BYTE_SIZE,a0		; skip "/" or ":"
	move.l	a0,rd_demo_filename(a3)
	subq.w	#BYTE_SIZE,d0		; substract length for "/" or ":"
	move.l	d0,rd_demo_filename_length(a3)
	addq.w	#1,rd_entry_offset(a3)
	GET_RESIDENT_ENTRY_OFFSET
	move.l	d0,a0
	addq.w	#1,(a0)
	moveq	#RETURN_OK,d0
	rts


; input
; result
	CNOP 0,4
rd_print_demofile_start_message
	lea	rd_demo_filename_header(pc),a0
	moveq	#rd_demo_filename_header_end-rd_demo_filename_header,d0
	bsr	adl_print_text
	move.l	rd_demo_filename(a3),a0
	move.l	rd_demo_filename_length(a3),d0
	bsr	adl_print_text
	lea	rd_demo_filename_tail(pc),a0
	moveq	#rd_demo_filename_tail_end-rd_demo_filename_tail,d0
	bsr	adl_print_text
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_runmode
	btst	#AFB_68020,adl_cpu_flags+BYTE_SIZE(a3) ; 68020+ ?
	beq.s	rd_check_runmode_skip
rd_check_runmode_ok
	moveq	#RETURN_OK,d0
rd_check_runmode_quit
	rts
	CNOP 0,4
rd_check_runmode_skip
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a0)
	bne.s   rd_check_runmode_ok
	move.l	rd_demofile_path(a3),a0
	move.b	#FALSE,pqe_entry_active(a0) ; entry state: played
	lea	rd_error_text8(pc),a0
	moveq	#rd_error_text8_end-rd_error_text8,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
	bsr.s	rd_check_runmode_quit
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_demofile_state
	move.l	rd_demofile_path(a3),a0
	tst.b	pqe_entry_active(a0)
	beq.s   rd_check_demofile_state_ok
	lea	rd_info_message_text2(pc),a0
	moveq	#rd_info_message_text2_end-rd_info_message_text2,d0
	bsr	rd_print_error_text
	moveq	#RETURN_WARN,d0
rd_check_demofile_state_quit
	rts
	CNOP 0,4
rd_check_demofile_state_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_demofile_state_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_open_demofile
	move.l	rd_demofile_path(a3),a0
	move.b	#FALSE,pqe_entry_active(a0) ; entry state: played
	move.l	a0,d1
	MOVEF.L	MODE_OLDFILE,d2
	CALLDOS Open
	move.l	d0,rd_demofile_handle(a3)
	bne.s	rd_open_demofile_ok
	lea	rd_error_text9(pc),a0
	moveq	#rd_error_text9_end-rd_error_text9,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_open_demofile_quit
	rts
	CNOP 0,4
rd_open_demofile_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_open_demofile_quit


; input
; result
	CNOP 0,4
rd_read_demofile_header
	move.l	rd_demofile_handle(a3),d1
	lea	rd_demofile_MAGIC_COOKIE(a3),a0
	move.l	a0,d2
	moveq	#magic_cookie_length,d3	; number of characters to read
	CALLDOS Read
	rts


; input
; result
	CNOP 0,4
rd_close_demofile
	move.l	rd_demofile_handle(a3),d1
	CALLDOS Close
	rts


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
rd_check_demofile_header
	cmp.l	#MAGIC_COOKIE,rd_demofile_MAGIC_COOKIE(a3)
	beq.s	rd_check_demofile_header_ok
	lea	rd_error_text10(pc),a0
	moveq	#rd_error_text10_end-rd_error_text10,d0
	bsr	rd_print_error_text
	MOVEF.L ERROR_FILE_NOT_OBJECT,d0
rd_check_demofile_header_quit
	rts
	CNOP 0,4
rd_check_demofile_header_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_demofile_header_quit


; input
; result
	CNOP 0,4
rd_get_demofile_dir_path
	moveq	#adl_demofile_path_length-1,d7
	move.l	rd_demofile_path(a3),a0 ; source
	add.l	d7,a0			; end of source
	lea	rd_demo_dir_path(pc),a1 ; destination
	add.l	d7,a1			; end of destination
rd_get_demofile_dir_path_loop1
	move.b	-(a0),d0
	subq.w	#1,d7
	clr.b	-(a1)
	cmp.b	#"/",d0			; beginning of file name found ?
	beq.s	rd_get_demofile_dir_path_skip2
	cmp.b	#":",d0			; end of device name found ?
	beq.s	rd_get_demofile_dir_path_skip1
	bra.s	rd_get_demofile_dir_path_loop1
	CNOP 0,4
rd_get_demofile_dir_path_skip1
	move.b	d0,(a1)			; set ":"
rd_get_demofile_dir_path_skip2
	subq.w	#1,d7			; loopend at false
rd_get_demofile_dir_path_loop2
	move.b	-(a0),-(a1)
	dbf	d7,rd_get_demofile_dir_path_loop2
        rts


; input
; result
; d0.l	Return code
rd_set_new_current_dir
	lea	rd_demo_dir_path(pc),a0
	move.l	a0,d1
	MOVEF.L	ACCESS_READ,d2
	CALLDOS Lock
	move.l	d0,rd_demofile_dir_lock(a3)
	bne.s	rd_set_new_current_dir_skip
	lea	rd_error_text11(pc),a0
	moveq	#rd_error_text11_end-rd_error_text11,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_set_new_current_dir_quit
	rts
	CNOP 0,4
rd_set_new_current_dir_skip
	move.l	d0,d1			; lock program directory
	move.l	d0,d3			; lock current directory
	CALLLIBS SetProgramDir		; program directory = entry directory
	move.l	d3,d1			; lock current directory
	CALLLIBS CurrentDir		; current directory = entry directory
	move.l	d0,rd_old_current_dir_lock(a3)
	moveq	#RETURN_OK,d0
	bra.s	rd_set_new_current_dir_quit


; input
; result
	CNOP 0,4
rd_get_prerunscript_path
	tst.w	rd_arg_prerunscript_enabled(a3)
	bne.s	rd_get_prerunscript_path_skip1
rd_get_prerunscript_path_quit
	rts
	CNOP 0,4
rd_get_prerunscript_path_skip1
	move.l	rd_demofile_path(a3),a0
	ADDF.W	pqe_prerunscript_path,a0
	tst.b	(a0)			; file path exists ?
	beq.s	rd_get_prerunscript_path_quit
	move.l	a0,rd_prerunscript_path(a3)
	bra.s	rd_get_prerunscript_path_quit


; input
; result
; d0.l	Return code/error code
	CNOP 0,4
rd_check_prerunscript_path
	move.l	rd_prerunscript_path(a3),d0
	bne.s	rd_check_prerunscript_path_skip1
rd_check_prerunscript_path_quit
	rts
	CNOP 0,4
rd_check_prerunscript_path_skip1
	move.l	d0,a0
	moveq	#0,d0			; counter: length of prerun script path
rd_check_prerunscript_path_loop
	addq.b	#1,d0			; decrement counter
	cmp.b	#adl_prerunscript_path_length-1,d0
	blt.s	rd_check_prerunscript_path_skip2
	lea	rd_error_text12(pc),a0
	moveq	#rd_error_text12_end-rd_error_text12,d0
	bsr	rd_print_error_text
	MOVEF.L	ERROR_INVALID_COMPONENT_NAME,d0
	bra.s	rd_check_prerunscript_path_quit
        CNOP 0,4
rd_check_prerunscript_path_skip2
	tst.b	(a0)+			; nullbyte ?
	bne.s	rd_check_prerunscript_path_loop
	moveq	#RETURN_OK,d0
	bra.s	rd_check_prerunscript_path_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_execute_prerunscript
	move.l	rd_prerunscript_path(a3),d0
	bne.s	rd_execute_prerunscript_skip
rd_execute_prerunscript_quit
	rts
	CNOP 0,4
rd_execute_prerunscript_skip
	move.l	d0,a0			; source: prerun script path
	lea	rd_prerunscript_cmd_line_path(pc),a1 ; destination: command line
	moveq	#adl_prerunscript_path_length-1,d7
rd_execute_prerunscript_loop
	move.b	(a0)+,(a1)+		; nullbyte ?
	dbeq	d7,rd_execute_prerunscript_loop
	lea	rd_prerunscript_cmd_line(pc),a0
	move.l	a0,d1			; command line
	moveq	#0,d2			; no tags
	CALLDOS	SystemTagList
	tst.l	d0
	beq.s	rd_execute_prerunscript_ok
	lea	rd_error_text13(pc),a0
	moveq	#rd_error_text13_end-rd_error_text13,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
	bra.s	rd_execute_prerunscript_quit
	CNOP 0,4
rd_execute_prerunscript_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_execute_prerunscript_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_open_pal_screen
	sub.l	a0,a0			; no NewScreen structure
	lea	rd_pal_screen_tags(pc),a1
	CALLINT OpenScreenTagList
	move.l	d0,rd_pal_screen(a3)
	bne.s	rd_open_pal_screen_ok
	lea	rd_error_text14(pc),a0
	moveq	#rd_error_text14_end-rd_error_text14,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_open_pal_screen_quit
	rts
	CNOP 0,4
rd_open_pal_screen_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_open_pal_screen_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_load_pal_screen_colors
	cmp.w	#OS3_VERSION,adl_os_version(a3)
	blt.s   rd_load_pal_screen_colors_skip
rd_load_pal_screen_colors_quit
	rts
	CNOP 0,4
rd_load_pal_screen_colors_skip
	move.l	rd_pal_screen(a3),a0
	ADDF.W	sc_ViewPort,a0
	lea	rd_pal_screen_rgb4_colors(pc),a1
	moveq	#pal_screen_colors_number,d0
	CALLGRAF LoadRGB4
	bra.s	rd_load_pal_screen_colors_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_pal_screen_mode
	move.l	rd_pal_screen(a3),a0
	ADDF.W	sc_ViewPort,a0
	CALLGRAF GetVPModeID
	cmp.l	#PAL_MONITOR_ID|LORES_KEY,d0
	beq.s	rd_check_pal_screen_mode_ok
	lea	rd_error_text15(pc),a0
	moveq	#rd_error_text15_end-rd_error_text15,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_check_pal_screen_mode_quit
	rts
	CNOP 0,4
rd_check_pal_screen_mode_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_pal_screen_mode_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_open_invisible_window
	lea	rd_invisible_window_tags(pc),a1
	move.l	rd_pal_screen(a3),wtl_WA_CustomScreen+ti_Data(a1)
	sub.l	a0,a0			; no NewWindow structure
	CALLINT OpenWindowTagList
	move.l	d0,rd_invisible_window(a3)
	bne.s	rd_open_invisible_window_ok
	lea	rd_error_text16(pc),a0
	moveq	#rd_error_text16_end-rd_error_text16,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_open_invisible_window_quit
	rts
	CNOP 0,4
rd_open_invisible_window_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_open_invisible_window_quit


; input
; result
	CNOP 0,4
rd_clear_mousepointer
	move.l	rd_invisible_window(a3),a0
	move.l	rd_mouse_pointer_data(a3),a1
	moveq	#cleared_sprite_y_size,d0
	moveq	#cleared_sprite_x_size,d1
	moveq	#cleared_sprite_x_offset,d2
	moveq	#cleared_sprite_y_offset,d3
	CALLINT SetPointer
	rts


; input
; result
	CNOP 0,4
rd_blank_display
	sub.l	a1,a1			; no view
	CALLGRAF LoadView
	CALLLIBS WaitTOF
	CALLLIBS WaitTOF		; wait for interlace screens with two copperlists
	tst.l	gb_ActiView(a6)		; did another view appear in the meantime ?
	bne.s	rd_blank_display
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_OCS_VANILLA,pqe_runmode(a0)
	bne.s	rd_blank_display_quit
	moveq	#0,d0
	move.l	d0,_CUSTOM+BPL1MOD	; standard screen moduli OS1.x
rd_blank_display_quit
	rts


; input
; result
	CNOP 0,4
rd_wait_monitor_switch
	move.l	rd_active_screen_mode(a3),d0
	beq.s	rd_wait_monitor_switch_quit
	cmp.l	#DEFAULT_MONITOR_ID,d0
	beq.s	rd_wait_monitor_switch_quit
	cmp.l	#PAL_MONITOR_ID,d0
	bne.s	rd_wait_monitor_switch_skip
rd_wait_monitor_switch_quit
	rts
	CNOP 0,4
rd_wait_monitor_switch_skip
	MOVEF.L	monitor_switch_delay,d1
	CALLDOS Delay
	bra.s	rd_wait_monitor_switch_quit


; input
; result
	CNOP 0,4
rd_disable_fast_memory
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_PLAIN_TURBO,pqe_runmode(a0)
	bne.s	rd_disable_fast_memory_skip1
rd_disable_fast_memory_quit
	rts
	CNOP 0,4
rd_disable_fast_memory_skip1
	move.l	#MEMF_FAST|MEMF_LARGEST,d1
	move.l	d1,d2
	CALLEXEC AvailMem
	move.l	d0,rd_fast_memory_block_size(a3)
	bne.s	rd_disable_fast_memory_skip2
	bra.s	rd_disable_fast_memory_quit
	CNOP 0,4
rd_disable_fast_memory_skip2
	move.l	d2,d1			; attributes: fast memory
	CALLLIBS AllocMem
	move.l	d0,rd_fast_memory_block(a3)
	move.l	d0,a2
rd_disable_fast_memory_loop
	move.l	d2,d1			; attributes: fast memory
	CALLLIBS AvailMem
	move.l	d0,(a2)+		; store memory block
	bne.s	rd_disable_fast_memory_skip3
	bra.s	rd_disable_fast_memory_quit
	CNOP 0,4
rd_disable_fast_memory_skip3
	move.l	d2,d1			; attributes; fast memory
	CALLLIBS AllocMem
	move.l	d0,(a2)+		; fast memory block
	bra.s	rd_disable_fast_memory_loop


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_load_demofile
	move.l	rd_demofile_path(a3),d1
	CALLDOS LoadSeg
	move.l	d0,rd_demofile_seglist(a3)
	bne.s	rd_load_demofile_ok
	lea	rd_error_text17(pc),a0
	moveq	#rd_error_text17_end-rd_error_text17,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_load_demofile_quit
	rts
	CNOP 0,4
rd_load_demofile_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_load_demofile_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_whdloadfile
	move.l	rd_demofile_seglist(a3),a0
	MULUF.L	4,a0,a1			; convert BCPL pointer
	cmp.l	#"WHDL",8(a0)
	beq.s	rd_check_whdloadfile_skip1
rd_check_whdloadfile_ok
	moveq	#RETURN_OK,d0
rd_check_whdloadfile_quit
	rts
	CNOP 0,4
rd_check_whdloadfile_skip1
	cmp.l	#"OADS",12(a0)
	bne.s	rd_check_whdloadfile_ok
	clr.w	whdl_slave_enabled(a3)
	move.l	rd_demo_filename(a3),a0
	lea	whdl_slave_cmd_line_path(pc),a1
	move.l	rd_demo_filename_length(a3),d7 ; length including nullbyte
rd_check_whdloadfile_loop1
	move.b	(a0)+,(a1)+
	dbf	d7,rd_check_whdloadfile_loop1
	move.l	a1,rd_demo_filename_end(a3) ; file path end in command string
	move.l	whdl_disk_object(a3),a0
	move.l	rd_demo_filename_end(a3),a2
	bsr	rd_check_tooltypes
	bra.s	rd_check_whdloadfile_quit


; Input
; a2.l	command string
; Result
; d0.l	Return code
	CNOP 0,4
rd_check_tooltypes
	move.l	rd_demofile_path(a3),a0
	lea	whdl_icon_path(pc),a1
	moveq	#adl_demofile_path_length-1,d7
rd_check_tooltypes_loop1
	move.b	(a0)+,(a1)+		; copy path
	dbeq	d7,rd_check_tooltypes_loop1
	subq.w	#7,a1			; skip suffix ".slave",0
	clr.b	(a1)			; insert nullbyte
	lea	whdl_icon_path(pc),a0
	CALLICON GetDiskObject
	move.l	d0,whdl_disk_object(a3)
	bne.s	rd_check_tooltypes_skip1
	lea	rd_error_text18(pc),a0
	moveq	#rd_error_text18_end-rd_error_text18,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_check_tooltypes_quit
	rts
	CNOP 0,4
rd_check_tooltypes_skip1
	move.l	d0,a0
	move.l	do_ToolTypes(a0),a0
	move.l	a0,a4			; store tooltypes field
	lea	whdl_tooltype_PRELOAD(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; tooltype: PRELOAD ?
	beq.s	rd_check_tooltypes_skip2
	move.b	#" ",-BYTE_SIZE(a2)	; insert space character
	move.b	#"P",(a2)+		; insert argument "Preload" in string
	move.b	#"r",(a2)+
	move.b	#"e",(a2)+
	move.b	#"l",(a2)+
	move.b	#"o",(a2)+
	move.b	#"a",(a2)+
	move.b	#"d",(a2)+
	clr.b	(a2)+			; insert nullbyte
rd_check_tooltypes_skip2
	move.l	a4,a0			; tooltypes field
	lea	whdl_tooltype_PRELOADSIZE(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; tooltype: PRELOADSIZE ?
	beq.s	rd_check_tooltypes_skip3
	move.b	#" ",-BYTE_SIZE(a2)	; insert space character
	move.b	#"P",(a2)+		; insert argument "Preloadsize" in string
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
	move.b	#" ",(a2)+		; insert space character
	move.l	d0,a0			; argument PRELOADSIZE value
rd_check_tooltypes_loop2
	move.b	(a0)+,(a2)+
	bne.s	rd_check_tooltypes_loop2
rd_check_tooltypes_skip3
	move.l	a4,a0			; tooltypes field
	lea	whdl_tooltype_QUITKEY(pc),a1
	CALLLIBS FindToolType
	tst.l	d0			; tooltype: QUITKEY ?
	beq.s	rd_check_tooltypes_skip4
	move.b	#" ",-BYTE_SIZE(a2)	; insert space character
	move.b	#"Q",(a2)+		; insert argument "Quitkey" in string
	move.b	#"u",(a2)+
	move.b	#"i",(a2)+
	move.b	#"t",(a2)+
	move.b	#"k",(a2)+
	move.b	#"e",(a2)+
	move.b	#"y",(a2)+
	move.b	#" ",(a2)+		; insert space character
	move.l	d0,a0			; argument QUITKEY value
rd_check_tooltypes_loop3
	move.b	(a0)+,(a2)+		; copy QUITKEY value to command string
	bne.s	rd_check_tooltypes_loop3
rd_check_tooltypes_skip4
	move.l	whdl_disk_object(a3),a0
	CALLLIBS FreeDiskObject
	moveq	#RETURN_OK,d0
	bra	rd_check_tooltypes_quit


; input
; result
	CNOP 0,4
adl_wait_drives_motor
	MOVEF.L	drives_motor_delay,d1
	CALLDOS Delay
	rts


; input
; result
	CNOP 0,4
rd_init_playtimer_start
	moveq	#0,d1
	move.w	rd_play_duration(a3),d1
	beq.s	rd_init_playtimer_start_skip
	move.w	d1,rd_playtimer_delay(a3)
	bsr	rp_create_command_string
rd_init_playtimer_start_quit
	rts
	CNOP 0,4
rd_init_playtimer_start_skip
	move.l	rd_demofile_path(a3),a0
	add.w	pqe_playtime(a0),d1
	beq.s	rd_init_playtimer_start_quit
	move.w	d1,rd_playtimer_delay(a3)
	bsr	rp_create_command_string
	bra.s	rd_init_playtimer_start_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_start_playtimer
	tst.w	rd_playtimer_delay(a3)
	bne.s	rd_start_playtimer_skip
	moveq	#RETURN_OK,d0
rd_start_playtimer_quit
	rts
	CNOP 0,4
rd_start_playtimer_skip
	bsr.s	rd_set_playtimer
	tst.l	d0
	bne.s	rd_start_playtimer_quit 	
	bsr	rd_write_playtimer
	bra.s	rd_start_playtimer_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_set_playtimer
	lea	rd_serial_io(pc),a1
	move.l	a1,a2
	move.w	#SDCMD_SETPARAMS,io_Command(a1)
	move.l	#adl_baud,io_Baud(a1)
	move.b	#8,io_Writelen(a1)
	move.b	#1,io_Stopbits(a1)
	move.b	#SERF_XDISABLED,io_Serflags(a1)
	CALLEXEC DoIO
	move.b	io_Error(a2),d0
	beq.s	rd_set_playtimer_ok
	cmp.b	#SerErr_DevBusy,d0
	bne.s	rd_set_playtimer_skip1
	lea	rd_error_text19a(pc),a0
	moveq	#rd_error_text19a_end-rd_error_text19a,d0
	bsr	rd_print_error_text
rd_set_playtimer_fail
	moveq	#RETURN_FAIL,d0
rd_set_playtimer_quit
	rts
	CNOP 0,4
rd_set_playtimer_skip1
	cmp.b	#SerErr_BaudMismatch,d0
	bne.s	rd_set_playtimer__skip2
	lea	rd_error_text19b(pc),a0
	moveq	#rd_error_text19b_end-rd_error_text19b,d0
	bsr	rd_print_error_text
	bra.s	rd_set_playtimer_fail
	CNOP 0,4
rd_set_playtimer__skip2
	cmp.b	#SerErr_InvParam,d0
	bne.s	rd_set_playtimer__skip3
	lea	rd_error_text19c(pc),a0
	moveq	#rd_error_text19c_end-rd_error_text19c,d0
	bsr	rd_print_error_text
	bra.s	rd_set_playtimer_fail
	CNOP 0,4
rd_set_playtimer__skip3
	cmp.b	#SerErr_LineErr,d0
	bne.s	rd_set_playtimer__skip4
	lea	rd_error_text19d(pc),a0
	moveq	#rd_error_text19d_end-rd_error_text19d,d0
	bsr	rd_print_error_text
	bra.s	rd_set_playtimer_fail
	CNOP 0,4
rd_set_playtimer__skip4
	cmp.b	#SerErr_NoDSR,d0
	bne.s	rd_set_playtimer_ok
	lea	rd_error_text19e(pc),a0
	moveq	#rd_error_text19e_end-rd_error_text19e,d0
	bsr	rd_print_error_text
	bra.s	rd_set_playtimer_fail
	CNOP 0,4
rd_set_playtimer_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_set_playtimer_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_write_playtimer
	lea	rd_serial_io(pc),a1
	move.w	#CMD_WRITE,io_Command(a1)
	moveq	#command_string_size,d0
	move.l	d0,io_Length(a1)
	lea	rp_command_string(pc),a0
	move.l	a0,io_Data(a1)
	CALLEXEC DoIO
	move.b	io_Error(a2),d0
	beq.s	rd_write_playtimer_ok
	lea	rd_error_text20(pc),a0
	moveq	#rd_error_text20_end-rd_error_text20,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_write_playtimer_quit
	rts
	CNOP 0,4
rd_write_playtimer_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_write_playtimer_quit


; input
; result
	CNOP 0,4
rd_get_system_time
	lea	rd_timer_io(pc),a1
	move.w	#TR_GETSYSTIME,IO_command(a1)
	CALLEXEC DoIO
	rts


; input
; result
	CNOP 0,4
rd_save_custom_traps
	GET_CUSTOM_TRAP_VECTORS
	move.l	d0,rd_custom_traps(a3)
	rts


; input
; result
	CNOP 0,4
rd_downgrade_cpu
	tst.b	adl_cpu_flags+BYTE_SIZE(a3) ; 680x0 ?
	bne.s	rd_downgrade_cpu_skip1
rd_downgrade_cpu_quit
	rts
	CNOP 0,4
rd_downgrade_cpu_skip1
	lea	rp_read_vbr(pc),a5
	CALLEXEC Supervisor
	move.l	d0,rd_old_vbr(a3)
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_PLAIN_TURBO,pqe_runmode(a0)
	beq.s	rd_downgrade_cpu_quit
	tst.l	rd_old_vbr(a3)
	beq.s	rd_downgrade_cpu_skip2
	moveq	#0,d0			; VBR = $000000
	lea	rd_write_vbr(pc),a5
	CALLLIBS Supervisor
rd_downgrade_cpu_skip2
	tst.b	adl_cpu_flags+BYTE_SIZE(a3) ; 68060 ?
	bpl.s	rd_downgrade_cpu_skip4
	moveq	#0,d1			; clear all bits in CACR
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a0)
	bne.s	rd_downgrade_cpu_skip3
	or.w	#CACR060F_FIC|CACR060F_EIC,d1 ; 68060: enable 1/2 instruction cache
rd_downgrade_cpu_skip3
	lea	rd_060_set_cacr(pc),a5
	CALLLIBS Supervisor
	move.l	d0,rd_old_cacr(a3)
	lea     rd_old_mmu_registers(pc),a1
	lea	rd_040_060_mmu_off(pc),a5
	CALLLIBS Supervisor
	moveq	#0,d1			; 68060: clear all bits in PCR
	lea	rd_060_set_pcr(pc),a5
	CALLLIBS Supervisor
	move.l	d0,rd_old_060_pcr(a3)
	bra.s	rd_downgrade_cpu_quit
	CNOP 0,4
rd_downgrade_cpu_skip4
	moveq	#0,d0			; clear all bits
	move.l	#CACRF_EnableI|CACRF_IBE|CACRF_EnableD|CACRF_DBE|CACRF_WriteAllocate|CACRF_EnableE|CACRF_CopyBack,d1 ; 68020/030/040: disable caches
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_AGA_VANILLA,pqe_runmode(a0)
	bne.s	rd_downgrade_cpu_skip5
	and.b	#~(CACRF_EnableI),d1	; 68020/030/040: exclude instruction cache
rd_downgrade_cpu_skip5
	CALLEXEC CacheControl
	move.l	d0,rd_old_cacr(a3)
	btst	#AFB_68040,adl_cpu_flags+BYTE_SIZE(a3) ; 68040 ?
	beq.s   rd_downgrade_cpu_skip6
	lea	rd_040_060_mmu_off(pc),a5
	CALLLIBS Supervisor
	bra	rd_downgrade_cpu_quit
	CNOP 0,4
rd_downgrade_cpu_skip6
	btst	#AFB_68030,AttnFlags+BYTE_SIZE(a6) ; 68030 ?
	beq	rd_downgrade_cpu_quit
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_030_mmu_off(pc),a5
	CALLLIBS Supervisor
	bra	rd_downgrade_cpu_quit


	IFEQ rd_yulquen74_code_enabled
; input
; result
		CNOP 0,4
rd_downgrade_cpu_clock
		btst	#AFB_68020,adl_cpu_flags+BYTE_SIZE(a3) ; 68020+ ?
		beq.s	rd_downgrade_cpu_clock_skip
rd_downgrade_cpu_clock_quit
		rts
		CNOP 0,4
rd_downgrade_cpu_clock_skip
		move.l	rd_demofile_path(a3),a0
		cmp.b	#RUNMODE_PLAIN_TURBO,pqe_runmode(a0)
		beq.s	rd_downgrade_cpu_clock_quit
		lea	CFG0,a0
		move.w	(a0),d0
		move.w	d0,rd_old_cfg0(a3)
		and.w	#~(CFG0F_CLKSEL0|CFG0F_CLKSEL1),d0 ; clear SELx bits
		or.w	#CFG0F_CLKSEL1,d0	; stock speed mode with 7 MHz
		move.w	d0,(a0)
		bra.s	rd_downgrade_cpu_clock_quit
	ENDC


; input
; result
	CNOP 0,4
rd_get_tod_time
	CALLEXEC Disable
	move.l	#_CIAA,a4
	moveq	#0,d0
	move.b	CIATODHI(a4),d0		; TOD clock bits 16..23
	swap	d0			; adjust bits
	move.b	CIATODMID(a4),d0	; TOD clock bits 8..15
	lsl.w	#8,d0			; adjust bits
	move.b	CIATODLOW(a4),d0	; TOD clock Bits 0..7
	move.l	d0,rd_tod_time(a3)
	CALLLIBS Enable
	rts


; input
; result
	CNOP 0,4
rd_save_chips_registers
	CALLEXEC Disable
	lea	rd_old_chips_registers(pc),a0
	move.l	#_CUSTOM,a1
	move.w	DMACONR(a1),ocr_dmacon(a0)
	move.w	INTENAR(a1),ocr_intena(a0)
	move.w	ADKCONR(a1),ocr_adkcon(a0)
	move.l	#_CIAB,a5
	lea	_CIAA-_CIAB(a5),a4	; CIA-A base

	move.b	CIAPRA(a4),ocr_ciaa_pra(a0)
	move.b	CIACRA(a4),d0
	move.b	d0,d1
	move.b	d0,ocr_ciaa_cra(a0)
	and.b	#~(CIACRAF_START),d0	; stop timer a
	or.b	#CIACRAF_LOAD,d0
	move.b	d0,CIACRA(a4)
	nop
	move.b	CIATALO(a4),ocr_ciaa_talo(a0)
	move.b	CIATAHI(a4),ocr_ciaa_tahi(a0)
	btst	#CIACRAB_RUNMODE,d1	; continuous mode ?
	bne.s	rd_save_chips_registers_skip1
	or.b	#CIACRAF_START,d1	; restart timer a
rd_save_chips_registers_skip1
	move.b	d1,CIACRA(a4)
	move.b	CIACRB(a4),d0
	move.b	d0,d1
	move.b	d0,ocr_ciaa_crb(a0)
	and.b	#~(CIACRBF_ALARM-CIACRBF_START),d0 ; stop timer b
	or.b	#CIACRBF_LOAD,d0
	move.b	d0,CIACRB(a4)
	nop
	move.b	CIATBLO(a4),ocr_ciaa_tblo(a0)
	move.b	CIATBHI(a4),ocr_ciaa_tbhi(a0)
	btst	#CIACRBB_RUNMODE,d1	; continuous mode ?
	bne.s	rd_save_chips_registers_skip2
	or.b	#CIACRBF_START,d1	; restart timer b
rd_save_chips_registers_skip2
	move.b	d1,CIACRB(a4)

	move.b	CIAPRB(a5),ocr_ciab_prb(a0)
	move.b	CIACRA(a5),d0
	move.b	d0,d1
	move.b	d0,ocr_ciaa_cra(a0)
	and.b	#~(CIACRAF_START),d0	; stop timer a
	or.b	#CIACRAF_LOAD,d0
	move.b	d0,CIACRA(a5)
	nop
	move.b	CIATALO(a5),ocr_ciab_talo(a0)
	move.b	CIATAHI(a5),ocr_ciab_tahi(a0)
	btst	#CIACRAB_RUNMODE,d1	; continuous mode ?
	bne.s	rd_save_chips_registers_skip3
	or.b	#CIACRAF_START,d1	; restart timer a
rd_save_chips_registers_skip3
	move.b	d1,CIACRA(a5)
	move.b	CIACRB(a5),d0
	move.b	d0,d1
	move.b	d0,ocr_ciab_crb(a0)
	and.b	#~(CIACRBF_ALARM-CIACRBF_START),d0 ; stop timer b
	or.b	#CIACRBF_LOAD,d0
	move.b	d0,CIACRB(a5)
	nop
	move.b	CIATBLO(a5),ocr_ciab_tblo(a0)
	move.b	CIATBHI(a5),ocr_ciab_tbhi(a0)
	btst	#CIACRBB_RUNMODE,d1	; continuous mode ?
	bne.s	rd_save_chips_registers_skip4
	or.b	#CIACRBF_START,d1	; restart timer b
rd_save_chips_registers_skip4
	move.b	d1,CIACRB(a5)
	CALLLIBS Enable
	rts


; input
; result
	CNOP 0,4
rd_run_dos_file
	tst.w	whdl_slave_enabled(a3)
	bne.s	rd_run_dos_file_skip
rd_run_dos_file_quit
	rts
	CNOP 0,4
rd_run_dos_file_skip
	moveq	#rd_shell_no_op_cmd_line_end-rd_shell_no_op_cmd_line,d0
	lea	rd_shell_no_op_cmd_line(pc),a0
	move.l	a3,-(a7)
	move.l	rd_demofile_seglist(a3),a3
	MULUF.L	4,a3,a4			; convert BCPL pointer
	jsr	FirstCode(a3)		; execute entry
	move.l	(a7)+,a3
	CALLGRAF WaitBlit
	bra.s	rd_run_dos_file_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_execute_whdload_slave
	tst.w	whdl_slave_enabled(a3)
	bne.s	rd_execute_whdload_slave_ok
	lea	whdl_slave_cmd_line(pc),a0
	move.l	a0,d1
	moveq	#0,d2			; no tags
	CALLDOS SystemTagList
	tst.l	d0
	beq.s	rd_execute_whdload_slave_skip
	lea	rd_error_text21(pc),a0
	moveq	#rd_error_text21_end-rd_error_text21,d0
	bsr	rd_print_error_text
	moveq	#RETURN_FAIL,d0
rd_execute_whdload_slave_quit
	rts
	CNOP 0,4
rd_execute_whdload_slave_skip
	CALLGRAF WaitBlit
rd_execute_whdload_slave_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_execute_whdload_slave_quit


; input
; result
	CNOP 0,4
rd_check_softreset
	tst.w	rd_arg_softreset_enabled(a3)
	beq.s	rd_check_softreset_skip
rd_check_softreset_quit
	rts
	CNOP 0,4
rd_check_softreset_skip
	CALLEXEC ColdReboot
	bra.s	rd_check_softreset_quit


; input
; result
	CNOP 0,4
rd_clear_chips_registers
	CALLEXEC Disable
	move.l	#_CUSTOM,a0
	move.w	#$7fff,d0
	move.w	d0,DMACON(a0)		; disable DMA
	move.w	d0,INTENA(a0)		; disable interrupts
	move.w	d0,INTREQ(a0)		; clear interrupts
	move.w	d0,ADKCON(a0)
	moveq	#0,d0
	move.w	d0,COPCON(a0)		; copper can't access blitter registers
	move.w	d0,AUD0VOL(a0)		; channel volume off
	move.w	d0,AUD1VOL(a0)
	move.w	d0,AUD2VOL(a0)
	move.w	d0,AUD3VOL(a0)

	move.l	#_CIAB,a5
	lea	_CIAA-_CIAB(a5),a4	; CIA-A base
	moveq	#$7f,d0
	move.b	d0,CIAICR(a4)		; disable all CIA interrupts
	move.b	d0,CIAICR(a5)
	move.b	CIAICR(a4),d0		; clear all CIA interrupts
	move.b	CIAICR(a5),d0
	CALLLIBS Enable
	rts


; input
; result
	CNOP 0,4
rd_restore_chips_registers
	CALLEXEC Disable
	lea	rd_old_chips_registers(pc),a0
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

	move.b	ocr_ciaa_pra(a0),CIAPRA(a4)
	move.b	ocr_ciaa_talo(a0),CIATALO(a4)
	nop
	move.b	ocr_ciaa_tahi(a0),CIATAHI(a4)
	move.b	ocr_ciaa_tblo(a0),CIATBLO(a4)
	nop
	move.b	ocr_ciaa_tbhi(a0),CIATBHI(a4)
	move.b	ocr_ciaa_icr(a0),d0
	or.b	#CIAICRF_SETCLR,d0
	move.b	d0,CIAICR(a4)
	move.b	ocr_ciaa_cra(a0),d0
	btst	#CIACRAB_RUNMODE,d0	; continuous mode ?
	bne.s	rd_restore_chips_registers_skip1
	or.b	#CIACRAF_START,d0	; restart timer a
rd_restore_chips_registers_skip1
	move.b	d0,CIACRA(a4)
	move.b	ocr_ciaa_crb(a0),d0
	btst	#CIACRBB_RUNMODE,d0	; continuous mode ?
	bne.s	rd_restore_chips_registers_skip2
	or.b	#CIACRBF_START,d0	; restart timer b
rd_restore_chips_registers_skip2
	move.b	d0,CIACRB(a4)

	move.b	ocr_ciab_prb(a0),CIAPRB(a5)
	move.b	ocr_ciab_talo(a0),CIATALO(a5)
	nop
	move.b	ocr_ciab_tahi(a0),CIATAHI(a5)
	move.b	ocr_ciab_tblo(a0),CIATBLO(a5)
	nop
	move.b	ocr_ciab_tbhi(a0),CIATBHI(a5)
	move.b	ocr_ciab_icr(a0),d0
	or.b	#CIAICRF_SETCLR,d0
	move.b	d0,CIAICR(a5)
	move.b	ocr_ciab_cra(a0),d0
	btst	#CIACRAB_RUNMODE,d0	; continuous mode ?
	bne.s	rd_restore_chips_registers_skip3
	or.b	#CIACRAF_START,d0	; restart timer a
rd_restore_chips_registers_skip3
	move.b	d0,CIACRA(a5)
	move.b	ocr_ciab_crb(a0),d0
	btst	#CIACRBB_RUNMODE,d0	; continuous mode ?
	bne.s	rd_restore_chips_registers_skip4
	or.b	#CIACRBF_START,d0	; restart timer b
rd_restore_chips_registers_skip4
	move.b	d0,CIACRB(a5)
	CALLLIBS Enable
	rts


; input
; result
	CNOP 0,4
rd_get_tod_duration
	CALLEXEC Disable
	move.l	#_CIAA,a4
	move.l	rd_tod_time(a3),d0	; timer before start of entry
	moveq	#0,d1
	move.b	CIATODHI(a4),d1		; bits 16..23
	swap	d1			; adjust bits
	move.b	CIATODMID(a4),d1	; bits 8..15
	lsl.w	#8,d1			; adjust bits
	move.b	CIATODLOW(a4),d1	; bits 0..7
	cmp.l	d0,d1			; TOD overflow ?
	bge.s	rd_get_tod_duration_skip1
	move.l	#TOD_MAX,d2
	sub.l	d0,d2			; difference until overflow
	add.l	d2,d1			; add timer value
	bra.s	rd_get_tod_duration_skip2
	CNOP 0,4
rd_get_tod_duration_skip1
	sub.l	d0,d1			; normal difference
rd_get_tod_duration_skip2
	move.l	d1,rd_tod_time(a3)
	CALLLIBS Enable
	rts


	IFEQ rd_yulquen74_code_enabled
; input
; result
		CNOP 0,4
rd_upgrade_cpu_clock
		btst	#AFB_68020,adl_cpu_flags+BYTE_SIZE(a3) ; 68020+ ?
		beq.s	rd_upgrade_cpu_clock_skip
rd_upgrade_cpu_clock_quit
		rts
		CNOP 0,4
rd_upgrade_cpu_clock_skip
		move.l	rd_demofile_path(a3),a0
		cmp.b	#RUNMODE_PLAIN_TURBO,pqe_runmode(a0)
		beq.s	rd_upgrade_cpu_clock_quit
		move.w	rd_old_cfg0(a3),CFG0
		bra.s	rd_upgrade_cpu_clock_quit
	ENDC


; input
; result
	CNOP 0,4
rd_restore_custom_traps
	move.l	rd_old_vbr(a3),d0
	beq.s	rd_restore_custom_traps_skip
	move.l	d0,a1			; destination: fast memory
	ADDF.W	TRAP_0_VECTOR,a1
	bsr.s	rd_copy_custom_traps
rd_restore_custom_traps_skip
	move.w	#TRAP_0_VECTOR,a1	; destination: chip memory
	bsr.s	rd_copy_custom_traps
	CALLEXEC CacheClearU
	rts


; input
; result
	CNOP 0,4
rd_copy_custom_traps
	move.l	rd_custom_traps(a3),a0
	moveq	#adl_used_trap_vectors_number-1,d7
rd_copy_custom_traps_loop
	move.l	(a0)+,(a1)+
	dbf	d7,rd_copy_custom_traps_loop
	rts


; input
; result
	CNOP 0,4
rd_upgrade_cpu
	move.l	rd_demofile_path(a3),a0
	cmp.b   #RUNMODE_PLAIN_TURBO,pqe_runmode(a0)
	bne.s	rd_upgrade_cpu_skip1
rd_upgrade_cpu_quit
	rts
	CNOP 0,4
rd_upgrade_cpu_skip1
	tst.b	adl_cpu_flags+BYTE_SIZE(a3) ; 680x0 ?
	beq.s	rd_upgrade_cpu_quit
	move.l	_SysBase(pc),a6
	move.l	rd_old_vbr(a3),d0
	beq.s	rd_upgrade_cpu_skip2
	lea	rd_write_vbr(pc),a5
	CALLLIBS Supervisor
rd_upgrade_cpu_skip2
	tst.b	adl_cpu_flags+BYTE_SIZE(a3) ; 68060 ?
	bpl.s	rd_upgrade_cpu_skip3
	move.l	rd_old_060_pcr(a3),d1
	lea	rd_060_set_pcr(pc),a5
	CALLLIBS Supervisor
	move.l	rd_old_cacr(a3),d1
	lea	rd_060_set_cacr(pc),a5
	CALLLIBS Supervisor
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_040_060_mmu_on(pc),a5
	CALLLIBS Supervisor
	bra.s	rd_upgrade_cpu_quit
	CNOP 0,4
rd_upgrade_cpu_skip3
	moveq	#-1,d0			; set all bits
	move.l	rd_old_cacr(a3),d1	; 68020/030/040: CACR
	CALLEXEC CacheControl
	btst	#AFB_68040,adl_cpu_flags+BYTE_SIZE(a3) ; 68040 ?
	beq.s	rd_upgrade_cpu_skip4
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_040_060_mmu_on(pc),a5
	CALLLIBS Supervisor
	bra.s	rd_upgrade_cpu_quit
	CNOP 0,4
rd_upgrade_cpu_skip4
	btst	#AFB_68030,adl_cpu_flags+BYTE_SIZE(a3) ; 68030 ?
	beq.s	rd_upgrade_cpu_quit
	lea	rd_old_mmu_registers(pc),a1
	lea	rd_030_mmu_on(pc),a5
	CALLLIBS Supervisor
	bra	rd_upgrade_cpu_quit


; input
; result
	CNOP 0,4
rd_init_playtimer_stop
	tst.w	rd_playtimer_delay(a3)
	bne.s   rd_init_playtimer_stop_skip
rd_init_playtimer_stop_quit
	rts
	CNOP 0,4
rd_init_playtimer_stop_skip
	moveq	#RESET_DEVICE_STOP,d1
	bsr     rp_create_command_string
	bra.s	rd_init_playtimer_stop_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_stop_playtimer
	tst.w	rd_playtimer_delay(a3)
	bne.s   rd_stop_playtimer_skip
	moveq	#RETURN_OK,d0
rd_stop_playtimer_quit
	rts
	CNOP 0,4
rd_stop_playtimer_skip
	bsr	rd_set_playtimer
	tst.l	d0
	bne.s	rd_stop_playtimer_quit
	bsr	rd_write_playtimer
	bra.s	rd_stop_playtimer_quit


; input
; result
	CNOP 0,4
rd_update_system_time
	tst.w	rd_arg_restoresystime_enabled(a3)
	beq.s	rd_update_system_time_skip
rd_update_system_time_quit
	rts
	CNOP 0,4
rd_update_system_time_skip
	move.l	_SysBase(pc),a6
	move.l	rd_tod_time(a3),d0	; period of disabled system
	moveq	#0,d1
	move.b	VBlankFrequency(a6),d1
	divu.w	d1,d0			; / vertical frequency (50Hz) = Unix seconds
	lea	rd_timer_io(pc),a1
	move.w	#TR_SETSYSTIME,IO_command(a1)
	move.l	d0,d1
	ext.l	d0
	swap	d1			; remainder of division
	add.l	d0,IO_size+TV_SECS(a1)
	mulu.w	#10000,d1
	add.l	d1,IO_size+TV_MICRO(a1)
	CALLLIBS DoIO
	bra.s	rd_update_system_time_quit


; input
; result
	CNOP 0,4
rd_unload_demofile
	move.l	rd_demofile_seglist(a3),d1
	bne.s	rd_unload_demofile_skip
rd_unload_demofile_quit
	rts
	CNOP 0,4
rd_unload_demofile_skip
	CALLDOS UnLoadSeg
	bra.s	rd_unload_demofile_quit


; input
; result
	CNOP 0,4
rd_enable_fast_memory
	move.l	rd_demofile_path(a3),a0
	cmp.b   #RUNMODE_PLAIN_TURBO,pqe_runmode(a0)
	bne.s	rd_enable_fast_memory_skip1
rd_enable_fast_memory_quit
	rts
	CNOP 0,4
rd_enable_fast_memory_skip1
	move.l	rd_fast_memory_block(a3),d2
	beq.s	rd_enable_fast_memory_quit
	move.l	d2,a2
	move.l	_SysBase(pc),a6
rd_enable_fast_memory_loop
	move.l	(a2)+,d0		; memory block size
	beq.s	rd_enable_fast_memory_skip2
	move.l	(a2)+,a1		; memory block
	CALLLIBS FreeMem
	bra.s	rd_enable_fast_memory_loop
	CNOP 0,4
rd_enable_fast_memory_skip2
	move.l	d2,a1			; memory block
	move.l	rd_fast_memory_block_size(a3),d0
	CALLLIBS FreeMem
	bra.s	rd_enable_fast_memory_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_restore_sprite_resolution
	move.l	rd_pal_screen(a3),a2
	move.l	sc_ViewPort+vp_ColorMap(a2),a0
	lea	rd_video_control_tags(pc),a1
	move.l	#VTAG_SPRITERESN_SET,vctl_VTAG_SPRITERESN+ti_tag(a1)
	move.l	rd_old_sprite_resolution(a3),vctl_VTAG_SPRITERESN+ti_Data(a1)
	CALLGRAF VideoControl
	move.l	a2,a0			; screen
	CALLINT MakeScreen
	CALLLIBS RethinkDisplay
	rts


; input
; result
	CNOP 0,4
rd_close_invisible_window
	move.l	rd_invisible_window(a3),a0
	CALLINT CloseWindow
	rts


; input
; result
	CNOP 0,4
rd_close_pal_screen
	move.l	rd_pal_screen(a3),a0
	CALLINT CloseScreen
	rts


; Input
; Result
		CNOP 0,4
rd_activate_first_window
		move.l	rd_first_window(a3),d0
		bne.s	rd_activate_first_window_skip
rd_activate_first_window_quit
		rts
		CNOP 0,4
rd_activate_first_window_skip
		move.l	d0,a0
		CALLINT ActivateWindow
		bra.s	rd_activate_first_window_quit


; input
; result
	CNOP 0,4
rd_restore_current_dir
	move.l	rd_old_current_dir_lock(a3),d1
	CALLDOS CurrentDir
	move.l	rd_demofile_dir_lock(a3),d1
	CALLLIBS Unlock
	rts


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_user_break
	moveq	#0,d0			; no new signals
	moveq	#0,d1			; signal mask
	CALLEXEC SetSignal
	btst	#SIGBREAKB_CTRL_C,d0
	beq.s	rd_check_user_break_ok
	lea	rd_info_message_text3(pc),a0
	moveq	#rd_info_message_text3_end-rd_info_message_text3,d0
	bsr	adl_print_text
	moveq	#RETURN_FAIL,d0
rd_check_user_break_quit
	rts
	CNOP 0,4
rd_check_user_break_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_user_break_quit


; input
; result
	CNOP 0,4
rd_reset_demo_variables
	tst.w	rd_arg_loop_enabled(a3)
        beq.s	rd_reset_demo_variables_skip1
rd_reset_demo_variables_quit
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
	bra.s	rd_reset_demo_variables_quit


; input
; result
; d0.l	Return code
	CNOP 0,4
rd_check_arg_loop_enabled
	tst.w	rd_arg_loop_enabled(a3)
	beq.s	rd_check_loop_mode_ok
	moveq	#RETURN_FAIL,d0
rd_check_arg_loop_enabled_quit
	rts
	CNOP 0,4
rd_check_loop_mode_ok
	moveq	#RETURN_OK,d0
	bra.s	rd_check_arg_loop_enabled_quit


; input
; result
	CNOP 0,4
rd_free_mouse_pointer_data
	move.l	rd_mouse_pointer_data(a3),a1
	moveq	#sprite_pointer_data_size,d0
	CALLEXEC FreeMem
	rts


; input
; result
	CNOP 0,4
rd_close_timer_device
	lea	rd_timer_io(pc),a1
	CALLEXEC CloseDevice
	rts


; input
; result
	CNOP 0,4
rd_close_serial_device
	lea	rd_serial_io(pc),a1
	CALLEXEC CloseDevice
	rts


; input
; result
	CNOP 0,4
rd_delete_serial_msg_port
	move.l	rd_serial_msg_port(a3),a0
	CALLEXEC DeleteMsgPort
	rts


; Exception routines

	MC68020
; input
; d0.l	VBR new content
; result
	CNOP 0,4
rd_write_vbr
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
	nop
	movec.l d0,VBR
	nop
	rte


	MC68040
; input
; d1.l	CACR new content
; result
; d0.l	CACR old content
	CNOP 0,4
rd_060_set_cacr
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
	nop
	movec.l CACR,d0
	nop
	CPUSHA	BC			; 68060: flush instruction/data/branch caches
	nop
	movec.l d1,CACR
	nop
	rte


	MC68040
; input
; a1.l	Buffer for old values
; a3.l	Variables_base
; result
	CNOP 0,4
rd_040_060_mmu_off
	move.l	#$0000c040,d1		; DTT0 cache inhibited, precise for $00000000-$00ffffff (Zorro II)
	move.l	#$00ffc000,d2		; DTT1/ITT1 cachable, writethrough for $00000000-$ffffffff (Zorro II/III)
	move.l	d2,d3			; ITT0=DTT1 cachable for $00000000-$ffffffff (Zorro II/III)
	moveq	#0,d4			; TC MMU off
	move.l	rd_demofile_path(a3),a0
	cmp.b	#RUNMODE_OCS_VANILLA,pqe_runmode(a0)
	bne.s	rd_040_060_mmu_off_skip
	move.l	d1,d3			; ITT0=DTT0 cache inhibited, precise for $00000000-$00ffffff (Zorro II)
rd_040_060_mmu_off_skip
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
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


	MC68030
; input
; a1.l	buffer for old values
; result
	CNOP 0,4
rd_030_mmu_off
	lea	rd_clear_030_mmu_register(a3),a0
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
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


	MC68040
; input
; d1.l	PCR new content
; result
; d0.l	PCR old content
	CNOP 0,4
rd_060_set_pcr
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ;highest interrupt priority
	nop
	DC.L	$4e7a0808		; movec.l PCR,d0
	nop
	CPUSHA	IC			; 68060: flush instruction and also branch cache
	nop
	DC.L	$4e7b1808		; movec.l d1,PCR
	nop
	rte


	MC68040
; input
; a1.l	buffer for old values
; result
	CNOP 0,4
rd_040_060_mmu_on
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
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


	MC68030
; input
; a1.l	buffer for old values
; result
	CNOP 0,4
rd_030_mmu_on
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
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


; Reset Program

	MC68000

	CNOP 0,4
rp_start
	bra.s	rp_start_skip1		; skip ADL id
	CNOP 0,4
rp_start_id			DC.L ~("ADL2")
rp_start_skip1
	movem.l d0-d7/a0-a6,-(a7)
	move.l	#_CUSTOM,a5
	move.l	exec_base.w,a6
	move.w	#POTGOF_OUTLY|POTGOF_DATLY|POTGOF_OUTLX|POTGOF_DATLX,POTGO(a5)
	moveq	#rp_rasterlines_delay,d7 ; wait ~320 µs
	bsr	rp_wait_rasterline
	btst	#POTINPB_DATLY-8,POTINP(a5) ; RMB ?
	bne.s	rp_start_skip2
	bsr	rp_clear_cool_capture
	bsr	rp_clear_id
	bra.s	rp_start_quit
	CNOP 0,4
rp_start_skip2
	bsr	rp_init_playtimer_stop
	bsr	rp_stop_playtimer
	move.l	#rp_entries_buffer-rp_start,d0
	move.l	rp_reset_program_memory(pc),a1
	move.w	rp_entries_number_max(pc),d1
	mulu.w	#playback_queue_entry_size,d1 ; total playback queue size
	add.l	d1,d0			; reset program section size
	CALLLIBS AllocAbs
	tst.l	d0
	bne.s	rp_start_skip3
	move.l	#rp_color_error,d3
	bsr	rp_screen_colour_flash
	bsr	rp_clear_cool_capture
	bsr	rp_clear_id
	bra.s	rp_start_quit
	CNOP 0,4
rp_start_skip3
	move.l	#rp_color_okay,d3
	bsr	rp_screen_colour_flash
	bsr	rp_restore_custom_cool_capture
	bsr	rp_init_custom_traps
rp_start_quit
	movem.l (a7)+,d0-d7/a0-a6
	rts


; input
; d7.l	Number of rasterlines to wait
; result
	CNOP 0,4
rp_wait_rasterline
	move.l	#$0001ff00,d2		; mask V0..8
	subq.w	#1,d7			; loopend at false
rp_wait_rasterline_loop1
	move.w	VPOSR(a5),d0		; VPOSR/VHPOSR separate reads because of overflow bit V8
	swap	d0
	move.w	VHPOSR(a5),d0
	and.l	d2,d0			; only bits V0..8
rp_wait_rasterline_loop2
	move.w	VPOSR(a5),d1		; VPOSR/VHPOSR separate reads because of overflow bit V8
	swap	d1
	move.w	VHPOSR(a5),d1
	and.l	d2,d1			; only bits V0..8
	cmp.l	d1,d0			; still same rasterline ?
	beq.s	rp_wait_rasterline_loop2
	dbf	d7,rp_wait_rasterline_loop1
	rts


; input
; a6.l	Exec base
; result
	CNOP 0,4
rp_clear_cool_capture
	moveq	#0,d0
	move.l	d0,CoolCapture(a6)
	bsr	rp_update_exec_checksum
	CALLLIBS CacheClearU
	rts


; input
; result
	CNOP 0,4
rp_clear_id
	lea	rp_start_id(pc),a0
	clr.l	(a0)
	rts


; input
; result
	CNOP 0,4
rp_init_playtimer_stop
	moveq	#RESET_DEVICE_STOP,d1
	bsr.s	rp_create_command_string
	rts


; input
; result
	CNOP 0,4
rp_stop_playtimer
	bsr	rp_set_playtimer
 	bsr	rp_write_playtimer
	rts


; input
; d1.l	Timer value
; Result
	CNOP 0,4
rp_create_command_string
	lea	rp_command_string(pc),a2
	move.l	d1,-(a7)
	lsr.w	#4,d1			; correction decimal number
	moveq	#rd_nnnn_size,d7	; number of digits to convert
	lea	cs_delay_counter(a2),a0	; string
	bsr.s	rp_dec_to_ascii

	moveq	#NIBBLE_MASK_LOW,d1
	and.l	(a7)+,d1		; number of demo parts [1..15]
	bsr.s	rp_dec_to_hex
	move.l	d0,d1			; return value hexadecimal number
	moveq	#rd_r_size,d7		; number of digits to convert
	lea	cs_parts(a2),a0         ; string
	bsr.s	rp_hex_to_ascii

	moveq	#cs_checksum-cs_hash,d7 ; number of characters for checksum
	lea	cs_hash(a2),a0		; start with "#"
	bsr	rp_update_command_checksum
	move.l	d0,d1			; decimal number
	bsr.s	rp_dec_to_hex
	move.l	d0,d1			; return value hexadecimal number
	moveq	#2,d7			; number of digits to convert
	lea	cs_checksum(a2),a0      ; string
	bsr.s	rp_hex_to_ascii
	rts


; input
; d1.l	Decimal number
; result
; d0.l	Hexadecimal number & $ff
	CNOP 0,4
rp_dec_to_hex
	moveq	#0,d0			; result
	moveq	#16,d3			; hexadecimal base
	moveq	#0,d4			; first nibble shift value
rp_dec_to_hex_loop
	divu.w	d3,d1			; / hexadecimal base
	move.l	d1,d2			; result
	swap	d2			; remainder of division
	lsl.w	d4,d2			; adjust nibble
	addq.b	#4,d4			; next nibble shift value
	add.w	d2,d0			; set nibble
	ext.l	d1
	bne.s	rp_dec_to_hex_loop
	and.l	#$000000ff,d0		; only low byte
	rts


; input
; a0.l	string
; d1.l	Decimal number
; d7.l	Number of didits to convert
; result
	CNOP 0,4
rp_dec_to_ascii
	lea	rp_dec_table(pc),a1
	move.l	d7,d0
	MULUF.L	4,d0,d2
	lea	(a1,d0.l),a1		; digit value
	subq.w	#1,d7			; loopend at false
rp_dec_to_ascii_loop1
	moveq	#-1,d3			; number
	move.l	-(a1),d2		; digit value 10^n
rp_dec_to_ascii_loop2
	addq.b	#1,d3			; increase number
	sub.l	d2,d1			; substzract digit value
	bcc.s	rp_dec_to_ascii_loop2
	add.b	#"0",d3			; number -> ascii character
	add.l	d2,d1			; adjust remainder
	move.b	d3,(a0)+
	dbf	d7,rp_dec_to_ascii_loop1
	rts


; input
; a0.l	string
; d1.l	Hexadecimal number
; d7.l	Number of digits to convert
; result
	CNOP 0,4
rp_hex_to_ascii
	add.l	d7,a0			; end of string
	subq.w	#1,d7			; loopend at false
rp_hex_to_ascii_loop
	moveq	#NIBBLE_MASK_LOW,d0
	and.b	d1,d0			; only low nibble
	add.b	#"0",d0			; number -> ascii character
	cmp.b	#"9",d0			; character <= "9" ?
	ble.s	rp_hex_to_ascii_skip
	add.b	#39,d0			; a..f 10="a",11="b",..
rp_hex_to_ascii_skip
	lsr.l	#4,d1			; next nibble
	move.b	d0,-(a0)
	dbf	d7,rp_hex_to_ascii_loop
	rts


; input
; a0.l	string
; d7.l	Number of ascii characters
; result
; d0.l	Command checksum
	CNOP 0,4
rp_update_command_checksum
	moveq	#0,d0			; checksum
	moveq	#0,d1
	subq.w	#1,d7			; loopend at false
rp_update_command_checksum_loop
	move.b	(a0)+,d1		; ascii value
	add.w	d1,d0
	dbf	d7,rp_update_command_checksum_loop
	ext.l	d0
	rts


; input
; result
	CNOP 0,4
rp_set_playtimer
	CALLLIBS Disable
	lea	rp_old_adkcon(pc),a0
	move.w	ADKCONR(a5),(a0)
	move.w	#ADKF_UARTBRK,ADKCON(a5) ; clear TXD
	move.w	#(PAL_CLOCK_CONSTANT/adl_baud)-1,SERPER(a5)
	CALLLIBS Enable
	rts


; input
; result
	CNOP 0,4
rp_write_playtimer
	CALLLIBS Disable
	move.w	#%0000000100000000,d1	; SERDAT: 8 data bits, 1 stop bit
	MOVEF.W	SERDATRF_TBE,d2
	lea	rp_command_string(pc),a0
	moveq	#command_string_size-1,d7 ; number of bytes to write
rp_write_playtimer_loop
	move.w	SERDATR(a5),d0
	and.w	d2,d0			; TBE bit set ?
	beq.s	rp_write_playtimer_loop
	move.b	(a0)+,d1		; data byte d0-d7
	move.w	d1,SERDAT(a5)
	dbf	d7,rp_write_playtimer_loop
	move.w	#$7fff,ADKCON(a5)
	move.w	rp_old_adkcon(pc),d0
	or.w	#ADKF_SETCLR,d0
	move.w	d0,ADKCON(a5)
	CALLLIBS Enable
	rts


; input
; d3.w	RGB4 value
; result
	CNOP 0,4
rp_screen_colour_flash
	moveq	#$0001,d2		; mask for V8
	moveq	#rp_frames_delay-1,d7
rp_screen_colour_flash_loop1
	move.w	VPOSR(a5),d0
	and.w	d2,d0			; only V8
rp_screen_colour_flash_loop2
	move.w	d3,COLOR00(a5)
	move.w	VPOSR(a5),d1
	and.w	d2,d1			; only V8
	cmp.w	d1,d0			; still the same frame ?
	beq.s	rp_screen_colour_flash_loop2
	dbf	d7,rp_screen_colour_flash_loop1
	rts


; input
; a6.l	Exec base
; result
	CNOP 0,4
rp_restore_custom_cool_capture
	move.l	rp_reset_program_memory(pc),CoolCapture(a6)
	bsr.s	rp_update_exec_checksum
	CALLLIBS CacheClearU
	rts


; input
; a6.l	Exec base
; result
	CNOP 0,4
rp_update_exec_checksum
	moveq	#0,d0
	move.w	d0,LowMemChkSum(a6)
	lea	SoftVer(a6),a0
	moveq	#((ChkSum-SoftVer)/WORD_SIZE)-1,d1
rp_update_exec_checksum_loop
	add.w	(a0)+,d0
	dbf	d1,rp_update_exec_checksum_loop
	not.w	d0
	move.w	d0,(a0)			; new checksum
	rts


; input
; a6.l	Exec base
; result
	CNOP 0,4
rp_init_custom_traps
	sub.l	a0,a0			; vectors base = $000000
	tst.b	AttnFlags(a6)		; 680x0 ?
	beq.s	rp_init_custom_traps_skip
	lea	rp_read_vbr(pc),a5
	CALLLIBS Supervisor
	move.l	d0,a0
rp_init_custom_traps_skip
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

	move.l	TRAP_6_VECTOR(a0),(a1)
	lea	rp_trap_6_program(pc),a4
	move.l	a4,TRAP_6_VECTOR(a0)
	move.l	a4,(a2)

	CALLLIBS CacheClearU
	rts


; input
; a6.l	Exec base
; result
	CNOP 0,4
rp_restore_old_traps
	sub.l	a1,a1			; vectors base = $000000
	tst.b	AttnFlags(a6)		; 680x0 ?
	beq.s   rp_restore_old_traps_skip1
	lea	rp_read_vbr(pc),a5
	CALLLIBS Supervisor
	tst.l	d0			; VBR = $000000 ?
	beq.s	rp_restore_old_traps_skip2
	move.l	d0,a1
rp_restore_old_traps_skip1
	add.w	#TRAP_0_VECTOR,a1	; vector fast memory
	bsr.s	rp_copy_old_trap_vectors
rp_restore_old_traps_skip2
	move.w	#TRAP_0_VECTOR,a1	; vector chip memory
	bsr.s	rp_copy_old_trap_vectors
	CALLLIBS CacheClearU
	rts


; input
; a1.l	Target: trap #0 vector
; result
	CNOP 0,4
rp_copy_old_trap_vectors
	lea	rp_old_trap_0_vector(pc),a0
	moveq	#adl_used_trap_vectors_number-1,d7
rd_copy_old_trap_vectors_loop
	move.l	(a0)+,(a1)+
	dbf	d7,rd_copy_old_trap_vectors_loop
	rts


; Trap routines

; GET_RESIDENT_ENTRIES_NUMBER
; input
; result
; d0.l	variable
	CNOP 0,4
rp_trap_0_program
	lea	rp_entries_number(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENTRIES_NUMBER_MAX
; input
; result
; d0.l	variable
	CNOP 0,4
rp_trap_1_program
	lea	rp_entries_number_max(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENTRY_OFFSET
; input
; result
; d0.l	variable
	CNOP 0,4
rp_trap_2_program
	lea	rp_entry_offset(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENTRIES_BUFFER
; input
; result
; d0.l	variable
	CNOP 0,4
rp_trap_3_program
	lea	rp_entries_buffer(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_ENDLESS_ENABLED
; input
; result
; d0.l	variable
	CNOP 0,4
rp_trap_4_program
	lea	rp_endless_enabled(pc),a0
	move.l	a0,d0
	nop
	rte


; GET_RESIDENT_CUSTOM_VECTORS
; input
; result
; d0.l	own trap vectors
	CNOP 0,4
rp_trap_5_program
	lea	rp_custom_trap_0_vector(pc),a0
	move.l	a0,d0
	nop
	rte


; REMOVE_RESET_PROGRAM
; input
; result
; d0.l	reset program
	CNOP 0,4
rp_trap_6_program
	movem.l	a5-a6,-(a7)
	move.l	exec_base.w,a6
	bsr	rp_clear_cool_capture
	bsr	rp_restore_old_traps
	lea	rp_reset_program_memory(pc),a0
	move.l	a0,d0
	movem.l	(a7)+,a5-a6
	nop
	rte


	MC68020
; input
; result
; d0.l	VBR content
	CNOP 0,4
rp_read_vbr
	or.w	#SRF_I0|SRF_I1|SRF_I2,SR ; highest interrupt priority
	nop
	movec.l VBR,d0
	nop
	rte


; Reset program
rp_reset_program_memory		DC.L 0
rp_reset_program_size		DC.L 0

rp_old_trap_0_vector		DC.L 0
rp_old_trap_1_vector		DC.L 0
rp_old_trap_2_vector		DC.L 0
rp_old_trap_3_vector		DC.L 0
rp_old_trap_4_vector		DC.L 0
rp_old_trap_5_vector		DC.L 0
rp_old_trap_6_vector		DC.L 0

rp_custom_trap_0_vector		DC.L 0
rp_custom_trap_1_vector		DC.L 0
rp_custom_trap_2_vector		DC.L 0
rp_custom_trap_3_vector		DC.L 0
rp_custom_trap_4_vector		DC.L 0
rp_custom_trap_5_vector		DC.L 0
rp_custom_trap_6_vector		DC.L 0

rp_old_adkcon			DC.W 0

rp_entries_number		DC.W 0
rp_entries_number_max		DC.W 0
rp_entry_offset			DC.W 0
rp_endless_enabled		DC.W 0

rp_command_string		DS.B command_string_size

	CNOP 0,4
rp_dec_table
	DC.L 1,10,100,1000,10000

rp_entries_buffer			; size will be calculated later


	CNOP 0,4
_SysBase			DC.L 0
_DOSBase			DC.L 0
_GfxBase			DC.L 0
_IntuitionBase			DC.L 0
_GadToolsBase			DC.L 0
_ASLBase			DC.L 0
_IconBase			DC.L 0
_CIABase			DC.L 0


dos_library_name
	DC.B "dos.library",0
	EVEN

graphics_library_name
	DC.B "graphics.library",0
	EVEN

intuition_library_name
	DC.B "intuition.library",0
	EVEN

gadtools_library_name
	DC.B "gadtools.library",0
	EVEN

asl_library_name
	DC.B "asl.library",0
	EVEN

icon_library_name
	DC.B "icon.library",0
	EVEN

ciaa_resource_name
	DC.B "ciaa.resource",0
	EVEN

ciab_resource_name
	DC.B "ciab.resource",0
	EVEN

serial_device_name
	DC.B "serial.device",0
	EVEN

timer_device_name
	DC.B "timer.device",0
	EVEN

workbench_screen_name
	DC.B "Workbench",0
	EVEN

topaz_font_name
	DC.B "topaz.font",0
	EVEN


; Amiga Demo Launcher
	CNOP 0,4
adl_variables
	DS.B adl_variables_size


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
	DC.B ASCII_LINE_FEED
	DC.B "For more information about the usage use the argument HELP"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_intro_message_text_end
	EVEN


adl_install_request_title
	DC.B "Amiga Demo Launcher message",0
	EVEN


adl_install_request_text_body
	DC.B "CoolCapture vector already used."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
	DC.B "Should the Amiga Demo Launcher be installed"
	DC.B ASCII_LINE_FEED
	DC.B "and other reset programs be disabled?"
	DC.B ASCII_LINE_FEED,0
	EVEN


adl_install_request_text_gadgets
	DC.B "Proceed|Quit",0
	EVEN


adl_cmd_usage_text
	DC.B ASCII_LINE_FEED
	DC.B "Amiga Demo Launcher arguments description:"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
; Amiga Demo Launcher
	DC.B "HELP                   This short arguments description"
	DC.B ASCII_LINE_FEED
	DC.B "REMOVE                 Remove Amiga Demo Launcher from memory"
	DC.B ASCII_LINE_FEED
; Demo Charger
	DC.B "MAXENTRIES ",155,"3",109,"number 1..n",155,"0",109," Set maximum entries number of playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "NEWENTRY               Create new entry in playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "PLAYLIST ",155,"3",109,"file path ",155,"0",109,"    Load and transfer external playlist to playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "QUIET                  Supress the file requester"
	DC.B ASCII_LINE_FEED
; Queue Handler
	DC.B "SHOWQUEUE              Show content of playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "EDITENTRY ",155,"3",109,"number 1..n",155,"0",109,"  Edit entry of playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "EDITQUEUE              Edit content of playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "CLEARQUEUE             Clear whole playback queue with all its entries"
	DC.B ASCII_LINE_FEED
	DC.B "RESETQUEUE             Reset playback queue offset and all entry states"
	DC.B ASCII_LINE_FEED
; Run Demo
	DC.B "PLAYENTRY ",155,"3",109,"number 1..n",155,"0",109,"  Play entry of playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "PRERUNSCRIPT ",155,"3",109,"file path ",155,"0",109,"Execute prerrun script file before entry is played"
	DC.B ASCII_LINE_FEED
	DC.B "MIN/MINS ",155,"3",109,"number 0..99",155,"0",109,"  Playtime in minutes /w reset device"
	DC.B ASCII_LINE_FEED
	DC.B "SEC/SECS ",155,"3",109,"number 0..59",155,"0",109,"  Playtime in seconds /w reset device"
	DC.B ASCII_LINE_FEED
	DC.B "MULTIPART ",155,"3",109,"number 2..16",155,"0",109," Play multiparts by automatic LMB click /w reset device"
	DC.B ASCII_LINE_FEED
	DC.B "RANDOM                 Play random entry of playback queue"
	DC.B ASCII_LINE_FEED
	DC.B "ENDLESS                Play entries of playback queue endlessly"
	DC.B ASCII_LINE_FEED
	DC.B "LOOP                   Play entries until no more entries left to play"
	DC.B ASCII_LINE_FEED
	DC.B "RESTORESYSTIME         Restore system time after entry was played"
	DC.B ASCII_LINE_FEED
	DC.B "SOFTRESET              Automatic reset after (manually) quitting entry"
	DC.B ASCII_LINE_FEED
	DC.B "RESETONERROR           Automatic reset after an error during entry execution"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_cmd_usage_text_end
	EVEN


adl_cmd_template
; Amiga Demo Launcher
	DC.B "HELP/S,"
	DC.B "REMOVE/S,"
; Demo Charger
	DC.B "MAXENTRIES/K/N,"
	DC.B "NEWENTRY/S,"
	DC.B "PLAYLIST/K,"
	DC.B "QUIET/S,"
; Queue Handler
	DC.B "SHOWQUEUE/S,"
	DC.B "EDITENTRY/K/N,"
	DC.B "EDITQUEUE/S,"
	DC.B "CLEARQUEUE/S,"
	DC.B "RESETQUEUE/S,"
; Run Demo
	DC.B "PLAYENTRY/K/N,"
	DC.B "PRERUNSCRIPT/K,"
	DC.B "MIN=MINS/K/N,"
	DC.B "SEC=SECS/K/N,"
	DC.B "MULTIPART/K/N,"
	DC.B "RANDOM/S,"
	DC.B "ENDLESS/S,"
	DC.B "LOOP/S,"
	DC.B "RESTORESYSTIME/S,"
	DC.B "SOFTRESET/S,"
	DC.B "RESETONERROR/S",0
	EVEN


adl_message_text1
	DC.B ASCII_LINE_FEED
	DC.B "Amiga Demo Launcher now removed from memory."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_message_text1_end
	EVEN

adl_message_text2
	DC.B ASCII_LINE_FEED
	DC.B "Amiga Demo Launcher not found in memory."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_message_text2_end
	EVEN


adl_error_text_header
	DC.B " ",0
	EVEN

adl_error_text_tail
	DC.B ASCII_LINE_FEED
adl_error_text_tail_end
	EVEN

adl_error_text1
	DC.B ASCII_LINE_FEED
	DC.B "OS 2.0 or better required"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_error_text1_end
	EVEN

adl_error_text2
	DC.B ASCII_LINE_FEED
	DC.B "PAL machine required"
	DC.B ASCII_LINE_FEED
adl_error_text2_end
	EVEN

adl_error_text3
	DC.B ASCII_LINE_FEED
	DC.B "Couldnt open graphics.library"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_error_text3_end
	EVEN

adl_error_text4
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open intuition.library"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_error_text4_end
	EVEN

adl_error_text5
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open gadtools.library"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_error_text5_end
	EVEN

adl_error_text6
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open asl.library"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_error_text6_end
	EVEN

adl_error_text7
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open icon.library"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
adl_error_text7_end
	EVEN


; Demo Charger
	CNOP 0,4
dc_playlist_results_array
	DS.B playlist_results_array_size


	CNOP 0,4
dc_runmode_request
	DS.B EasyStruct_SIZEOF


	CNOP 0,4
dc_file_request_tags
	DS.B file_request_tag_list_size


dc_playlist_template
	DC.B "demofile,"
	DC.B "OCSVANILLA/S,"
	DC.B "AGAVANILLA/S,"
	DC.B "PLAINTURBO/S,"
	DC.B "MIN=MINS/K/N,"
	DC.B "SEC=SECS/K/N,"
	DC.B "MULTIPART/K/N,"
	DC.B "PRERUNSCRIPT/K",0
	EVEN


dc_parsing_begin_text
	DC.B ASCII_LINE_FEED
	DC.B "Parsing and transferring playlist to playback queue......"
dc_parsing_begin_text_end
	EVEN

dc_parsing_result_text
	DC.B "done",ASCII_LINE_FEED,ASCII_LINE_FEED
	DC.B "result: "
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
dc_file_request_remaining_files
	DC.B "   "
	DC.B "demo"
dc_file_request_char_s
	DC.B "s",0
	EVEN

dc_file_request_pattern_os2x
	DC.B "~(#?.diz|"
	DC.B "#?.#?nfo|"
	DC.B "#?.txt|"
	DC.B "_dl.#?)",0
	EVEN

dc_file_request_pattern_os3x
	DC.B "~(#?.bin|"
	DC.B "#?.dat#?|"
	DC.B "#?.diz|"
	DC.B "#?.#?nfo|"
	DC.B "#?.pak|"
	DC.B "#?.readme|"
	DC.B "#?.txt|"
	DC.B "#?.vars|"
	DC.B "_dl.#?)",0
	EVEN

dc_file_request_positive_text
	DC.B "Use",0
	EVEN

dc_file_request_negative_text
	DC.B "Quit",0
	EVEN


dc_runmode_request_title
	DC.B "Define run mode",0
	EVEN

dc_runmode_request_text_body
	DC.B "In which mode should the demo run?"
	DC.B ASCII_LINE_FEED,0
	EVEN

dc_runmode_request_text_gadgets
	DC.B "OCS vanilla|AGA vanilla|Plain/Turbo",0
	EVEN


dc_message_text
	DC.B ASCII_LINE_FEED
	DC.B "Maximum number of entries in playback queue already reached."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
dc_message_text_end
	EVEN


dc_error_text1
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't allocate entries/playback queue buffer"
dc_error_text1_end
	EVEN

dc_error_text2
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't find playlist file"
	DC.B ASCII_LINE_FEED
dc_error_text2_end
	EVEN

dc_error_text3
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't allocate file info block structure"
dc_error_text3_end
	EVEN

dc_error_text4
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't examine playlist file"
	DC.B ASCII_LINE_FEED
dc_error_text4_end
	EVEN

dc_error_text5
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't allocate memory for playlist file"
dc_error_text5_end
	EVEN

dc_error_text6
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open playlist file"
	DC.B ASCII_LINE_FEED
dc_error_text6_end
	EVEN

dc_error_text7
	DC.B ASCII_LINE_FEED
	DC.B "Playlist file read error"
	DC.B ASCII_LINE_FEED
dc_error_text7_end
	EVEN

dc_error_text8
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't allocate dos object"
	DC.B ASCII_LINE_FEED
dc_error_text8_end
	EVEN

dc_error_text9
	DC.B ASCII_LINE_FEED
	DC.B "Entry "
dc_entries_string
	DC.B "	"
	DC.B "could not be transferred. Playlist arguments syntax error"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
dc_error_text9_end
	EVEN

dc_error_text10
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't find program directory"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
dc_error_text10_end
	EVEN

dc_error_text11
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't get program directory name"
dc_error_text11_end
	EVEN

dc_error_text12
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't initialize file requester structure"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
dc_error_text12_end
	EVEN

dc_error_text13
	DC.B ASCII_LINE_FEED
	DC.B "Directory not found"
dc_error_text13_end
	EVEN

dc_error_text14
	DC.B ASCII_LINE_FEED
	DC.B "No demo file selected"
dc_error_text14_end
	EVEN

dc_error_text15
	DC.B ASCII_LINE_FEED
	DC.B "Demo filepath is longer than 123 characters"
dc_error_text15_end
	EVEN

dc_error_text16
	DC.B ASCII_LINE_FEED
	DC.B "Demo file not found"
dc_error_text16_end
	EVEN

dc_error_text17
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't allocate memory for resident program"
dc_error_text17_end
	EVEN


; Queue Handler
	CNOP 0,4
qh_get_visual_info_tags
	DS.L 1


	CNOP 0,4
qh_gadget_list
	DS.L 1


	CNOP 0,4
qh_new_gadget
	DS.B gng_SIZEOF

	CNOP 0,4
qh_topaz_80
	DS.B ta_SIZEOF


	CNOP 0,4
qh_button_tags
	DS.B ti_SIZEOF*2


	CNOP 0,4
qh_set_button_tags
	DS.B ti_SIZEOF*2


	CNOP 0,4
qh_text_gadget_tags
	DS.B ti_SIZEOF*3

	CNOP 0,4
qh_set_text_gadget_tags
	DS.B ti_SIZEOF*2


	CNOP 0,4
qh_integer_gadget_tags
	DS.B ti_SIZEOF*3

	CNOP 0,4
qh_set_integer_gadget_tags
	DS.B ti_SIZEOF*2


	CNOP 0,4
qh_cycle_gadget_tags
	DS.B ti_SIZEOF*3

	CNOP 0,4
qh_set_cycle_gadget_tags
	DS.B ti_SIZEOF*2

	CNOP 0,4
qh_cycle_gadget_array
	DS.L 4


	CNOP 0,4
qh_mx_gadget_tags
	DS.B ti_SIZEOF*3

	CNOP 0,4
qh_set_mx_gadget_tags
	DS.B ti_SIZEOF*2

	CNOP 0,4
qh_mx_gadget_array
	DS.B ti_SIZEOF*2


	CNOP 0,4
qh_edit_window_tags
	DS.B edit_window_tag_list_size


qh_backward_button_text
	DC.B "<",0
	EVEN

qh_foreward_button_text
	DC.B ">",0
	EVEN


qh_cycle_gadget_choice_text1
	DC.B "plain/turbo",0
	EVEN

qh_cycle_gadget_choice_text2
	DC.B "OCS vanilla",0
	EVEN

qh_cycle_gadget_choice_text3
	DC.B "AGA vanilla",0
	EVEN


qh_mx_gadget_choice_text1
	DC.B "not played",0
	EVEN

qh_mx_gadget_choice_text2
	DC.B "played",0
	EVEN


qh_positive_button_text
	DC.B "Save",0
	EVEN

qh_negative_button_text
	DC.B "Quit",0
	EVEN


qh_show_entry_header
	DC.B ASCII_LINE_FEED
	DC.B "#"
qh_show_entry_current_number
	DS.B 2
	DC.B " ",34
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
	DC.B " [  played  ]"
qh_entry_active_text2_end
	EVEN


qh_edit_window_name1
	DC.B "Edit entry",0
	EVEN

qh_edit_window_name2
	DC.B "Edit queue",0
	EVEN


qh_info_message_text1
	DC.B ASCII_LINE_FEED
	DC.B "Playback queue is empty."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text1_end
	EVEN

qh_info_message_text2
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
	DC.B "Playback queue has "
qh_not_used_entries_string
	DS.B 2
	DC.B " "
	DC.B "unused entries left."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text2_end
	EVEN

qh_info_message_text3
	DC.B ASCII_LINE_FEED
	DC.B "The playback queue is empty."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text3_end
	EVEN

qh_info_message_text4
	DC.B ASCII_LINE_FEED
	DC.B "No playback queue entries to clear."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text4_end
	EVEN

qh_info_message_text5
	DC.B ASCII_LINE_FEED
	DC.B "Playback queue entries cleared."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text5_end
	EVEN

qh_info_message_text6
	DC.B ASCII_LINE_FEED
	DC.B "Queue already set back."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text6_end
	EVEN

qh_info_message_text7
	DC.B ASCII_LINE_FEED
	DC.B "Queue position set back to first entry. All demo play states cleared."
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
qh_info_message_text7_end
	EVEN


qh_error_text1
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't lock workbench"
	DC.B ASCII_LINE_FEED
qh_error_text1_end
	EVEN

qh_error_text2
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't get workbench visuals"
	DC.B ASCII_LINE_FEED
qh_error_text2_end
	EVEN

qh_error_text3
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't create context gadget"
	DC.B ASCII_LINE_FEED
qh_error_text3_end
	EVEN

qh_error_text4
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't create gadget"
	DC.B ASCII_LINE_FEED
qh_error_text4_end
	EVEN

qh_error_text5
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open edit window"
	DC.B ASCII_LINE_FEED
qh_error_text5_end
	EVEN


; Run Demo
	CNOP 0,4
rd_serial_io
	DS.B IOEXTSER_size


	CNOP 0,4
rd_timer_io
	DS.B IOTV_SIZE


	CNOP 0,4
rd_pal_screen_tags
	DS.B screen_tag_list_size

	CNOP 0,2
rd_pal_screen_color_spec
	DS.B cs2_SIZEOF*(pal_screen_colors_number+1)

	CNOP 0,2
rd_pal_screen_rgb4_colors
	DS.W pal_screen_colors_number

	CNOP 0,4
rd_pal_screen_rgb32_colors
	DS.L pal_screen_colors_number*3


	CNOP 0,4
rd_video_control_tags
	DS.B video_control_tag_list_size


	CNOP 0,4
rd_invisible_window_tags
	DS.B window_tag_list_size


        CNOP 0,4
rd_old_mmu_registers
	DS.B old_mmu_registers_size


	CNOP 0,2
rd_old_chips_registers
	DS.B old_chips_registers_size


rd_pal_screen_name
	DC.B "Amiga Demo Launcher 2",0
	EVEN


rd_invisible_window_name
	DC.B "Amiga Demo Launcher 2",0
	EVEN


rd_demo_dir_path
	DS.B adl_demofile_path_length
	EVEN


rd_demo_filename_header
	DC.B ASCII_LINE_FEED
	DC.B "Playing entry "
	DC.B ASCII_QUOTATION_MARKS
rd_demo_filename_header_end
	EVEN

rd_demo_filename_tail
	DC.B ASCII_QUOTATION_MARKS
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_demo_filename_tail_end
	EVEN


rd_prerunscript_cmd_line
	DC.B "Execute "
rd_prerunscript_cmd_line_path
	DS.B adl_prerunscript_path_length
	EVEN


rd_shell_no_op_cmd_line
	DC.B ASCII_LINE_FEED,0
rd_shell_no_op_cmd_line_end
	EVEN


rd_info_message_text1
	DC.B ASCII_LINE_FEED
	DC.B "End of playback queue reached"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_info_message_text1_end
	EVEN

rd_info_message_text2
	DC.B ASCII_LINE_FEED
	DC.B "Entry already played"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_info_message_text2_end
	EVEN

rd_info_message_text3
	DC.B ASCII_LINE_FEED
	DC.B "Replay loop stopped"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_info_message_text3_end
	EVEN


rd_error_text_header
	DC.B "#"
rd_error_text_header_index
	DS.B 2
	DC.B " "
rd_error_text_header_end
	EVEN

rd_error_text1
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open ciaa.resource"
	DC.W ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text1_end
	EVEN

rd_error_text2
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open ciab.resource"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text2_end
	EVEN

rd_error_text3
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't create serial message port"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text3_end
	EVEN

rd_error_text4
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open serial.device"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text4_end
	EVEN

rd_error_text5
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open timer.device"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text5_end
	EVEN

rd_error_text6
	DC.B ASCII_LINE_FEED
	DC.B "Couldnt allocate sprite pointer data"
rd_error_text6_end
	EVEN

rd_error_text7
	DC.B ASCII_LINE_FEED
	DC.B "Invalid monitor ID"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text7_end
	EVEN

rd_error_text8
	DC.B "Run mode AGA vanilla not supported on this config"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text8_end
	EVEN

rd_error_text9
	DC.B "Couldn't open demo file"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text9_end
	EVEN

rd_error_text10
	DC.B "No executable demo file"
rd_error_text10_end
	EVEN

rd_error_text11
	DC.B "Couldn't find demo directory"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text11_end
	EVEN

rd_error_text12
	DC.B "Prerun script filepath is longer than 63 characters"
rd_error_text12_end
	EVEN

rd_error_text13
	DC.B "Couldn't execute prerun script file"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text13_end
	EVEN

rd_error_text14
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open degrade screen"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text14_end
	EVEN

rd_error_text15
	DC.B ASCII_LINE_FEED
	DC.B "Lores PAL screen not supported"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text15_end
	EVEN

rd_error_text16
	DC.B ASCII_LINE_FEED
	DC.B "Couldn't open invisible window"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text16_end
	EVEN

rd_error_text17
	DC.B "Couldn't load demo file"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text17_end
	EVEN

rd_error_text18
	DC.B "Couldn't open WHDLoad .info file"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text18_end
	EVEN

rd_error_text19a
	DC.B ASCII_LINE_FEED
	DC.B "Serial device in use"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text19a_end
	EVEN

rd_error_text19b
	DC.B ASCII_LINE_FEED
	DC.B "Baud rate not supported by hardware"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text19b_end
	EVEN

rd_error_text19c
	DC.B ASCII_LINE_FEED
	DC.B "Bad parameter"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text19c_end
	EVEN

rd_error_text19d
	DC.B ASCII_LINE_FEED
	DC.B "Hardware data overrun"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text19d_end
	EVEN

rd_error_text19e
	DC.B ASCII_LINE_FEED
	DC.B "No data set ready"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text19e_end
	EVEN

rd_error_text20
	DC.B ASCII_LINE_FEED
	DC.B "Write to serial port failed"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text20_end
	EVEN

rd_error_text21
	DC.B "Couldn't execute WHDLoad slave file"
	DC.B ASCII_LINE_FEED
	DC.B ASCII_LINE_FEED
rd_error_text21_end
	EVEN


; WHD-Load
whdl_tooltype_PRELOAD
	DC.B "PRELOAD",0
	EVEN

whdl_tooltype_PRELOADSIZE
	DC.B "PRELOADSIZE",0
	EVEN

whdl_tooltype_QUITKEY
	DC.B "QUITKEY",0
	EVEN


whdl_icon_path
	DS.B whdl_icon_path_length
	EVEN


whdl_slave_cmd_line
	DC.B "WHDLoad slave "
whdl_slave_cmd_line_path
	DS.B whdl_slave_path_length
	DS.B whdl_PRELOAD_length
	DS.B whdl_PRELOADSIZE_length
	DS.B whdl_QUITKEY_length
	EVEN


	DC.B "$VER: "
	DC.B "Amiga Demo Launcher "
	DC.B "2.10 "
	DC.B "(27.7.25) "
	DC.B "© 2025 by Resistance",0
	EVEN

	END

