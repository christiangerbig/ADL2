; Requirements
; 68000+
; 1.x+

; History

; V.1.0 beta
; - 1st release

; V.1.1 beta
; - ID detection improved. The ID is searched in memory regardless of the
;   CoolCapture vector

; V.1.0
; - Check for minimum requirements Kickstart version removed
; - Code optimized


	MC68000


	INCDIR "Daten:include3.5/"

	INCLUDE "exec/exec.i"
	INCLUDE "exec/exec_lib.i"

	INCLUDE "dos/dos.i"
	INCLUDE "dos/dos_lib.i"

	INCLUDE "hardware/custom.i"


	INCDIR "custom-includes-ocs:"


	INCLUDE "macros.i"


	INCLUDE "equals.i"


	RSRESET

dos_return_code			RS.L 1

variables_size			RS.B 0


	SECTION code,CODE


	movem.l d2-d7/a2-a6,-(a7)
	lea	variables(pc),a3
	bsr	init_variables

	bsr	search_adl_id
	move.l	d0,dos_return_code(a3)

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
search_adl_id
	move.l	#"A"<<24,d2		; id "ADL2SYNC"
	or.l	#"D"<<16,d2
	move.w	#"L"<<8,d2
	move.b	#"2",d2
	move.l	#"S"<<24,d4
	or.l	#"Y"<<16,d4
	move.w	#"N"<<8,d4
	move.b	#"C",d4
	move.l	_SysBase(pc),a0
	move.l	MaxLocMem(a0),a2
	move.l	a2,d7
	lsr.l	#2,d7			; chip memory size in 4 byte steps
	subq.l	#1,d7			; loopend at false
search_adl_id_loop
	subq.w	#LONGWORD_SIZE,a2
	movem.l	(a2),d0-d1		; fetch 8 bytes
	cmp.l	d4,d1                   ; "SYNC" ?
	beq.s	search_adl_id_skip2
search_adl_id_skip1
	subq.l	#1,d7
	bpl.s	search_adl_id_loop
	moveq	#RETURN_OK,d0
search_adl_id_quit
	rts
	CNOP 0,4
search_adl_id_skip2
	cmp.l	d2,d0			; "ADL2" ?
	bne.s	search_adl_id_skip1
search_id_warn
	wait_mouse
	moveq	#RETURN_WARN,d0
	bra.s	search_adl_id_quit


	CNOP 0,4
_SysBase			DC.L 0


	CNOP 0,4
variables
	DS.B variables_size


	DC.B "$VER: "
	DC.B "DetectADL2 "
	DC.B "1.1"
	DC.B "(30.7.25)",0
	EVEN

	END
