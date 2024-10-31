; Programm:	ClearChipMeme
; Autor:	Christian Gerbig
; Datum		25.10.2024
; Version:	1.0

; Requirements
; CPU:		68000+
; Chipset:	OCS/ECS/AGA
; OS:		1.2+


	SECTION code_and_variables,CODE

	MC68000


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


	INCDIR "Daten:Asm-Sources/normsource-includes/"


	INCLUDE "macros.i"


	INCLUDE "equals.i"


	RSRESET

chip_memory_block		RS.L 1
chip_memory_block_size		RS.L 1

variables_size			RS.B 0


	movem.l d2-d7/a2-a6,-(a7)
	lea	variables(pc),a3
	bsr.s	init_variables
	bsr.s	alloc_chip_memory
wm
	btst	#2,$dff016
	bne.s	wm
	bsr.s	free_chip_memory
	movem.l	(a7)+,d2-d7/a2-a6
	rts


; Input
; Result
; d0.l	... Kein R�ckgabewert
	CNOP 0,4
init_variables
	lea	_SysBase(pc),a0
	move.l	exec_base.w,(a0)
	rts



; Input
; Result
; d0.l	... Kein R�ckgabewert
	CNOP 0,4
alloc_chip_memory
	move.l	#MEMF_CHIP|MEMF_LARGEST,d1
	move.l	d1,d2
	move.l	d1,d3
	or.l	#MEMF_CLEAR,d3
	CALLEXEC AvailMem
	move.l	d0,chip_memory_block_size(a3)
	bne.s	alloc_chip_memory_skip1
	rts
	CNOP 0,4
alloc_chip_memory_skip1
	move.l	d3,d1			; Gr��ten Chip-Memory Block belegen und l�schen
	CALLLIBS AllocMem
	move.l	d0,chip_memory_block(a3)
	move.l	d0,a2
alloc_chip_memory_loop
	move.l	d2,d1			; N�chster gr��ter Chip-Memory Block
	CALLLIBS AvailMem
	move.l	d0,(a2)+
	bne.s	alloc_chip_memory_skip2
	rts
	CNOP 0,4
alloc_chip_memory_skip2
	move.l	d3,d1			; N�chsten gr��ter Chip-Memory Block blegen und l�schen
	CALLLIBS AllocMem
	move.l	d0,(a2)+		; Zeiger auf Speichernlock
	bra.s	alloc_chip_memory_loop


; Input
; Result
; d0.l	... Kein R�ckgabewert
	CNOP 0,4
free_chip_memory
	move.l	chip_memory_block(a3),d2
	beq.s	free_chip_memory_quit
	move.l	d2,a2
	move.l	_SysBase(pc),a6
free_chip_memory_loop
	move.l	(a2)+,d0		; Gr��e des Speicherbereichs
	beq.s	free_chip_memory_skip2
	move.l	(a2)+,a1		; Zeiger auf Speicherbereich
	CALLLIBS FreeMem
	bra.s	free_chip_memory_loop
	CNOP 0,4
free_chip_memory_skip2
	move.l	d2,a1			; Zeiger auf ersten gr��ten Block
	move.l	chip_memory_block_size(a3),d0 ; Gr��e des ersten gr��ten Blocks
	CALLLIBS FreeMem
free_chip_memory_quit
	rts


_SysBase			DC.L 0

variables			DS.B variables_size

  END
