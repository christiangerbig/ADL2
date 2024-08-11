; DetectADL2
; Christian Gerbig
; 11.08.2024
; V.1.0 beta

; Requirements
; * 68020+
; * OS 3.0+


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

OS_VERSION_MIN			EQU 39


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

	bsr	check_system
	move.l	d0,dos_return_code(a3)
	bne	cleanup_dos_library

	bsr	check_cool_capture
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
check_system
	move.l	_SysBase(pc),a0
	cmp.w	#OS_VERSION_MIN,Lib_Version(a0)
	bge.s	check_system_cpu_min
	lea	error_text2(pc),a0
	moveq	#error_text2_end-error_text2,d0
	bsr	print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
check_system_cpu_min
	btst	#AFB_68020,AttnFlags+1(a0)
	bne.s	check_system_ok
	lea	error_text3(pc),a0
	move.l	#error_text3_end-error_text3,d0
	bsr	print_text
	moveq	#RETURN_FAIL,d0
	rts
	CNOP 0,4
check_system_ok
	moveq	#RETURN_OK,d0
	rts


; Input
; Result
; d0.l	Rückgabewert: Return-Code
	CNOP 0,4
check_cool_capture
	move.l	_SysBase(pc),a0
	move.l	CoolCapture(a0),d0
	beq.s   check_cool_capture_warn
	move.l	d0,a0
	cmp.w	#"DL",2(a0)
	bne.s	check_cool_capture_warn
	moveq	#RETURN_OK,d0
	rts
	CNOP 0,4
check_cool_capture_warn
	moveq	#RETURN_WARN,d0
	rts


	CNOP 0,4
close_dos_library
	move.l	_DOSBase(pc),a1
	CALLEXECQ CloseLibrary


; Input
; a0	... Zeiger auf Fehlertext
; d0.l	... Länge des Textes
; Result
; d0	... Kein Rückgabewert
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


error_text2
	DC.B ASCII_LINE_FEED,"OS 3.0 or better required",ASCII_LINE_FEED
error_text2_end
	EVEN
error_text3
	DC.B ASCII_LINE_FEED,"68020 or better required",ASCII_LINE_FEED
error_text3_end
	EVEN


	DC.B "$VER: DetectADL2 1.0 beta (11.8.24)",0
	EVEN


	END
