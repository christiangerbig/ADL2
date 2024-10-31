; Programm:	DetectADL2
; Autor:	Christian Gerbig
; Datum:	27.10.2024
; Version:	1.1 beta

; Requirements
; CPU:	68000+
; OS:	2.0+

; History

; V.1.0 beta
; - First Release

; V.1.1 beta
; - Erkennung der ID angepasst. Es wird jetzt unabhängig vom CoolCapture-Vektor
;   nach dem Langwort im Speicher gesucht


	SECTION code_and_variables,CODE

	MC68020

	INCDIR "Daten:include3.5/"

	INCLUDE "exec/exec.i"
	INCLUDE "exec/exec_lib.i"

	INCLUDE "dos/dos.i"
	INCLUDE "dos/dos_lib.i"
	INCLUDE "dos/dosextens.i"
	INCLUDE "dos/rdargs.i"

	INCLUDE "libraries/any_lib.i"

	INCLUDE "hardware/adkbits.i"
	INCLUDE "hardware/cia.i"
	INCLUDE "hardware/custom.i"
	INCLUDE "hardware/dmabits.i"
	INCLUDE "hardware/intbits.i"


	INCDIR "Daten:Asm-Sources.AGA/normsource-includes/"


	INCLUDE "macros.i"


	INCLUDE "equals.i"


	RSRESET

output_handle			RS.L 1
dos_return_code			RS.L 1

variables_size			RS.B 0


	movem.l d2-d7/a2-a6,-(a7)
	lea	variables(pc),a3
	bsr	init_variables

	bsr	open_dos_library
	move.l	d0,dos_return_code(a3)
	bne	quit
	bsr	get_output
	move.l	d0,dos_return_code(a3)
	bne	cleanup_dos_library

	bsr	check_system_properties
	move.l	d0,dos_return_code(a3)
	bne	cleanup_dos_library

	bsr	search_id
	move.l	d0,dos_return_code(a3)

cleanup_dos_library
	bsr	close_dos_library

quit
	move.l	dos_return_code(a3),d0
	movem.l (a7)+,d2-d7/a2-a6
	rts


	CNOP 0,4
init_variables
	lea	_SysBase(pc),a0
	move.l	exec_base.w,(a0)
	moveq	#TRUE,d0
	move.l	d0,dos_return_code(a3)
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
open_dos_library
	lea	dos_library_name(pc),a1
	moveq	#ANY_LIBRARY_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_DOSBase(pc),a0
	move.l	d0,(a0)
	bne.s	open_dos_library_ok
	moveq	#RETURN_FAIL,d0
        rts
	CNOP 0,4
open_dos_library_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code/Error-Code
	CNOP 0,4
get_output
	CALLDOS Output
	move.l	d0,output_handle(a3)
	bne.s   get_output_ok
	CALLLIBQ IoErr
	CNOP 0,4
get_output_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
check_system_properties
	move.l	_SysBase(pc),a0
	cmp.w	#OS2_VERSION,Lib_Version(a0)
	bge.s	check_system_properties_ok
	lea	error_text(pc),a0
	moveq	#error_text_end-error_text,d0
	bsr	print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
check_system_properties_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
search_id
	move.l	#~("-DL-"),d4
	move.l	_SysBase(pc),a6
	move.w	#4*LONGWORD_SIZE,a1
	move.l	MaxLocMem(a6),a2
	move.l	a2,d7
	lsr.l	#4,d7			; Chip-Memory Größe in 16 Bytes
	subq.l	#1,d7			; Loopend at false
search_id_loop
	sub.l	a1,a2
	movem.l	(a2),d0-d3
	not.l	d0
	cmp.l	d4,d0
	beq.s	search_id_ok
	not.l	d1
	cmp.l	d4,d1
	beq.s	search_id_ok
	not.l	d2
	cmp.l	d4,d2
	beq.s	search_id_ok
	not.l	d3
	cmp.l	d4,d3
	beq.s	search_id_ok
	subq.l	#1,d7
	bpl.s	search_id_loop
	moveq	#RETURN_WARN,d0
	rts
	CNOP 0,4
search_id_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	... Rückgabewert: Return-Code
	CNOP 0,4
close_dos_library
	move.l	_DOSBase(pc),a1
	CALLEXECQ CloseLibrary


; Input
; a0	... Zeiger auf Fehlertext
; d0.l	... Länge des Textes
; Result
; d0.l	... Kein Rückgabewert
	CNOP 0,4
print_text
	move.l	output_handle(a3),d1
	move.l	a0,d2			; Zeiger auf Fehlertext
	move.l	d0,d3			; Anzahl der Zeichen zum Schreiben
	CALLDOSQ Write


	CNOP 0,4
_SysBase			DC.L 0
_DOSBase			DC.L 0


dos_library_name		DC.B "dos.library",0
	EVEN


	CNOP 0,4
variables			DS.B variables_size


error_text
	DC.B ASCII_LINE_FEED,"OS 2.0 or better required",ASCII_LINE_FEED
error_text_end
	EVEN


	DC.B "$VER: DetectADL2 1.1 beta (27.10.24)",0
	EVEN


	END
