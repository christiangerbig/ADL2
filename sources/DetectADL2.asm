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
	move.l	#~("-DL-"),d4
	move.l	_SysBase(pc),a6
	move.w	#4*LONGWORD_SIZE,a1
	move.l	MaxLocMem(a6),a2
	move.l	a2,d7
	lsr.l	#4,d7			; chip memory size in 16 steps
	subq.l	#1,d7			; loopend at false
search_adl_id_loop
	sub.l	a1,a2
	movem.l	(a2),d0-d3
	not.l	d0
	cmp.l	d4,d0
	beq.s	search_adl_id_ok
	not.l	d1
	cmp.l	d4,d1
	beq.s	search_adl_id_ok
	not.l	d2
	cmp.l	d4,d2
	beq.s	search_adl_id_ok
	not.l	d3
	cmp.l	d4,d3
	beq.s	search_adl_id_ok
	subq.l	#1,d7
	bpl.s	search_adl_id_loop
	moveq	#RETURN_WARN,d0
search_adl_id_quit
	rts
	CNOP 0,4
search_adl_id_ok
	moveq	#RETURN_OK,d0
	bra.s	search_adl_id_quit


	CNOP 0,4
_SysBase			DC.L 0


	CNOP 0,4
variables
	DS.B variables_size


	DC.B "$VER: "
	DC.B "DetectADL2 "
	DC.B "1.0 "
	DC.B "(7.7.25)",0
	EVEN

	END
