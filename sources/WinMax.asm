; Requirements
; 68000+
; 1.x+

; History

; V.1.0 beta
; - 1st release


	MC68000


	INCDIR "include3.5:"

	INCLUDE "exec/exec.i"
	INCLUDE "exec/exec_lib.i"

	INCLUDE "dos/dos.i"
	INCLUDE "dos/dos_lib.i"

	INCLUDE "graphics/gfxbase.i"
	INCLUDE "graphics/graphics_lib.i"

	INCLUDE "libraries/any_lib.i"

	INCLUDE "intuition/intuition.i"
	INCLUDE "intuition/intuition_lib.i"

	INCLUDE "hardware/custom.i"


	INCDIR "custom-includes-ocs:"


	INCLUDE "macros.i"


	INCLUDE "equals.i"


	RSRESET

dos_return_code			RS.L 1

output_handle			RS.L 1

active_screen			RS.L 1
first_window			RS.L 1

variables_size			RS.B 0


	SECTION code,CODE


	movem.l d2-d7/a2-a6,-(a7)
	lea	variables(pc),a3
	bsr	init_variables

	bsr.s	open_dos_library
	move.l	d0,dos_return_code(a3)
	bne	quit
	bsr	get_output
	move.l	d0,dos_return_code(a3)
	bne	cleanup_dos_library
	bsr.s	open_intuition_library
	move.l	d0,dos_return_code(a3)
	bne.s	cleanup_dos_library

        bsr	get_active_screen
	move.l	d0,active_screen(a3)
	bsr	get_first_window
	move.l	d0,first_window(a3)
	bsr	change_window_size

	bsr	close_intuition_library

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
	moveq	#RETURN_OK,d0
	move.l	d0,dos_return_code(a3)
	rts


; Input
; Result
; d0.l	Return code
	CNOP 0,4
open_dos_library
	lea	dos_library_name(pc),a1
	moveq	#ANY_LIBRARY_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_DOSBase(pc),a0
	move.l	d0,(a0)
	bne.s	open_dos_library_ok
	moveq	#RETURN_FAIL,d0
open_dos_library_quit
        rts
	CNOP 0,4
open_dos_library_ok
	moveq	#RETURN_OK,d0
	bra.s	open_dos_library_quit


; Input
; Result
; d0.l	Return code/error code
	CNOP 0,4
get_output
	CALLDOS Output
	move.l	d0,output_handle(a3)
	bne.s   get_output_ok
	CALLLIBS IoErr
	RTS
get_output_quit
	rts
	CNOP 0,4
get_output_ok
	moveq	#RETURN_OK,d0
	bra.s	get_output_quit


; Input
; Result
; d0.l	Return code
	CNOP 0,4
open_intuition_library
	lea	intuition_library_name(pc),a1
	moveq	#ANY_LIBRARY_VERSION,d0
	CALLEXEC OpenLibrary
	lea	_IntuitionBase(pc),a0
	move.l	d0,(a0)
	bne.s	open_intuition_library_ok
	lea	error_message1(pc),a0
	moveq	#error_message1_end-error_message1,d0
	bsr.s	print_text
	moveq	#RETURN_FAIL,d0
open_intuition_library_quit
        rts
	CNOP 0,4
open_intuition_library_ok
	moveq	#RETURN_OK,d0
	bra.s	open_intuition_library_quit


; input
; result
; d0.l	Screen structure active screen
	CNOP 0,4
get_active_screen
	moveq	#0,d0			; all locks
	CALLINT LockIBase
	move.l	d0,a0
	move.l	ib_ActiveScreen(a6),a2
	CALLLIBS UnlockIBase
	move.l	a2,d0
	rts


; Input
; Result
; d0.l	Window structure first window
	CNOP 0,4
get_first_window
	move.l	active_screen(a3),d0
	bne.s	get_first_window_skip
get_first_window_quit
	rts
	CNOP 0,4
get_first_window_skip
	move.l	d0,a0
	move.l	sc_FirstWindow(a0),d0
	bra.s	get_first_window_quit


; Input
; Result
	CNOP 0,4
change_window_size
        move.l	first_window(a3),d0
	beq.s	change_window_size_quit
	move.l	d0,a0
	move.l	active_screen(a3),d0
	beq.s	change_window_size_quit
	move.l	d0,a1
	move.w	sc_width(a1),d0
	sub.w	wd_width(a0),d0		; delta x
	move.w	sc_height(a1),d1
	sub.w	wd_height(a0),d1	; delta y
	CALLINT SizeWindow
change_window_size_quit
	rts


; Input
; Result
	CNOP 0,4
close_intuition_library
	move.l	_IntuitionBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; Input
; Result
	CNOP 0,4
close_dos_library
	move.l	_DOSBase(pc),a1
	CALLEXEC CloseLibrary
	rts


; Input
; a0.l	Error text
; d0.l	Error text length
; Result
	CNOP 0,4
print_text
	move.l	output_handle(a3),d1
	move.l	a0,d2			; error text
	move.l	d0,d3			; number of characters
	CALLDOS Write
	rts


	CNOP 0,4
_SysBase			DC.L 0
_DOSBase			DC.L 0
_IntuitionBase			DC.L 0


	CNOP 0,4
variables			DS.B variables_size


dos_library_name		DC.B "dos.library",0
	EVEN
intuition_library_name		DC.B "intuition.library",0
	EVEN


error_message1
	DC.B "Couldn't open intuition library!"
error_message1_end
	EVEN


	DC.B "$VER: "
	DC.B "WinMax "
	DC.B "1.0 beta"
	DC.B "(10.7.25)",0
	EVEN

	END
