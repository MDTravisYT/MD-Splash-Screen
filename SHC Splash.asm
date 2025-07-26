; ===========================================================================
; SHC Splash Screen v1.0.0 by Naoto_NTP
; ===========================================================================
; This is a re-implementation of the 'lite' SHC splash screen created
; by MarkeyJester for use in SHC entries from 2021-2023. 
;
; This new version is open-source and strives to minimize any disruptions that
; may arise from modifying the main program's state; it does not require any
; additional RAM beyond the stack and restores CPU registers to what they 
; are prior to running the splash screen. 
; 
; It also attempts to restore any VDP registers used by the splash screen to 
; their default value in the base mainline sonic games (S1-S3K). If you have 
; modified the VDP configuration in any way, you may need to modify this code
; to reflect those changes. See you next contest!
; ---------------------------------------------------------------------------

	opt	l+,ws+

	include		"Sound/src/tb.lib"
	include		"Sound/src/eq.lib"
	include		"Sound/src/mcr.lib"

; ===========================================================================
; ---------------------------------------------------------------------------
; Macros
; ---------------------------------------------------------------------------
SHC_DMAToVRAM	macro	source, length, destination
		move.l	#($94000000+(((\length>>1)&$FF00)<<8)+$9300+((\length>>1)&$FF)),(a6)
		move.l	#($96000000+(((\source>>1)&$FF00)<<8)+$9500+((\source>>1)&$FF)),(a6)
		move.w	#($9700+((((\source>>1)&$FF0000)>>16)&$7F)),(a6)
		move.w	#($4000+((\destination)&$3FFF)),(a6)
		move.w	#($80+(((\destination)&$C000)>>14)),(a6)
		endm
; ---------------------------------------------------------------------------

; ===========================================================================
; ---------------------------------------------------------------------------
; Plane A nametable address VDP register value equates
; ---------------------------------------------------------------------------
SHC_frame0	equ ($6000>>10)			; address of the 1st splash screen animation frame (unlit sonic logo)
SHC_frame1	equ ($8000>>10)			; address of the 2nd splash screen animation frame (half-lit sonic logo)
SHC_frame2	equ ($A000>>10)			; address of the 3rd splash screen animation frame (fully-lit sonic logo)

SHC_gamePlnA	equ ($C000>>10)			; default address of the plane A nametable used in the main-line sonic games
; ---------------------------------------------------------------------------

; ===========================================================================
; ---------------------------------------------------------------------------
; Program Entry Point (Run the Splash Screen)
; ---------------------------------------------------------------------------
SHC_RunSplash:
		move	sr,-(sp)		; save the state of the status register 
		ori	#$700,sr		; disable interrupts
		movem.l	d0-a6,-(sp)		; back-up data and address registers

		move.w	#$100,($A11100).l	; issue a request to stop the Z80

.waitZ80:		
		btst	#0,($A11100).l		; wait until the Z80 has stopped
		bne.s	.waitZ80		; ^

		lea	($C00004).l,a6		; load the VDP control port into a6
		move.w	#$8134,(a6)		; disable display

		bsr.w	SHC_ClearScreen		; clear VRAM, CRAM, and VSRAM

		lea	SHC_Art(pc),a0		; decompress the splash screen art
		lea	($FF0000).l,a1		; ^
		bsr.w	SHC_KosPlusDec		; ^

	SHC_DMAToVRAM	$FF0000, $5FA0, $0000	; transfer the splash screen art to VRAM

		lea	SHC_Map(pc),a0		; decompress the splash screen nametables
		lea	($FF0000).l,a1		; ^
		bsr.w	SHC_KosPlusDec		; ^

	SHC_DMAToVRAM	$FF0000, $5000, $6000	; transfer the splash screen nametables to VRAM

		move.w	#$8200+SHC_frame0,d5	; initialize the animation frame value
		move.w	d5,(a6)			; set the plane A nametable address to $6000

		move.w	#$8174,(a6)		; enable display
		
		moveq	#0,d6			; initialize the palette fade counter
		moveq	#20-1,d7		; set the duration of the fade in

		move.w	#$82,(sound_ram+buf1).l	; queue the silence track
		move.b	#$FF,$D(a6)		; mute the PSG noise channel immediately
		
.fadeIn:
		addq.w	#1,d6			; increment the palette fade counter
		bsr.w	SHC_UpdateScreen	; send the screen updates for this frame

		movem.l	d0-a6,-(sp)		; back-up data and address registers
		jsr	sound(pc)		; run the SMPS driver
		movem.l	(sp)+,d0-a6		; restore data and address registers

		dbf	d7,.fadeIn		; loop until the screen has completely faded in from black

		lea	SHC_Anim(pc),a0		; load the address of the animation script into a0
		lea	($A10002+1).l,a1	; load the base address of the IO ports into a1
		move.w	#$81,(sound_ram+buf1).l	; queue the jingle sound

.loadAnim:
		clr.w	d7			; clear the frame duration counter
		move.b	(a0)+,d7		; load the duration of the current frame
		bmi.s	.endAnim		; if the duration's sign bit it set, we've reached the end; branch to fade-out
		move.b	(a0)+,d5		; otherwise, update the VDP register value of the next frame to display

.runAnim:
		bsr.s	SHC_UpdateScreen	; send the screen updates for this frame

		movem.l	d0-a6,-(sp)		; back-up data and address registers
		jsr	sound(pc)		; run the SMPS driver
		movem.l	(sp)+,d0-a6		; restore data and address registers

		move.b	#0,(a1)			; request controller 1 input
		or.l	d0,d0			; wait 8 cycles
		btst.b	#5,(a1)			; is start pressed on controller 1?
		beq.s	.endAnim		; if so, skip to the fade out
		
		move.b	#0,2(a1)		; request controller 2 input
		or.l	d0,d0			; wait 8 cycles
		btst.b	#5,2(a1)		; is start pressed on controller 2?
		beq.s	.endAnim		; if so, skip to the fade out

		dbf	d7,.runAnim		; loop until the timer for this animation frame has expired
		bra.s	.loadAnim		; branch back and load the parameters for the next animation frame 

.endAnim:		
		move.w	d6,d7			; use the palette fade couter as the duration of the fade out
		move.w	#$82,(sound_ram+buf1).l	; queue the silence track
		move.b	#$FF,$D(a6)		; mute the PSG noise channel immediately

.fadeOut:
		subq.w	#1,d6			; decrement the palette fade counter
		bsr.s	SHC_UpdateScreen	; send the screen updates for this frame

		movem.l	d0-a6,-(sp)		; back-up data and address registers
		jsr	sound(pc)		; run the SMPS driver
		movem.l	(sp)+,d0-a6		; restore data and address registers

		dbf	d7,.fadeOut		; loop until the screen has completely faded to black
		
		move.w	#$8200+SHC_gamePlnA,(a6); restore the plane A address to $C000 (default plane A address in S1, S2, and S3K)
		bsr.s	SHC_ClearScreen		; clear VRAM, CRAM, and VSRAM

		move.w	#0,($A11100).l		; start the Z80
		movem.l	(sp)+,d0-a6		; restore data and address registers
		rtr				; restore the status register and return to normal game execution
; ---------------------------------------------------------------------------

; ===========================================================================
; ---------------------------------------------------------------------------
; Update The Screen
; ---------------------------------------------------------------------------
SHC_UpdateScreen:
		move.w	(a6),ccr		; is v-blank active?
		bpl.s	SHC_UpdateScreen	; if not, wait for it to start

		move.w	d5,($C00004).l		; update the animation frame (plane A nametable address)

.updatePalette:
		move.l	#$9400930A,(a6)		; set the DMA transfer size (10 colors)
		
		lea	SHC_Pal(pc),a5		; load the base address of the palette data (pc relative)
		move.l	a5,d0			; move the address to a data register so we can modify it
		add.l	d6,d0			; add the displacement specified by the fade counter
		lsr.l	#1,d0			; divide by two (also aligns the displacement to be even)

		move.w	#$9500,d1		; set the low byte of the transfer source address
		move.b	d0,d1			; ^
		move.w	d1,(a6)			; ^

		lsr.l	#8,d0			; set the middle byte of the transfer source address
		move.w	#$9600,d1		; ^
		move.b	d0,d1			; ^
		move.w	d1,(a6)			; ^

		lsr.l	#8,d0			; set the high byte of the transfer source address
		move.w	#$9700,d1		; ^
		move.b	d0,d1			; ^
		move.w	d1,(a6)			; ^

		move.l	#$C0020080,(a6)		; set the destination palette index and begin the transfer

.waitForScan:	move.w	(a6),ccr		; is v-blank still active?
		bmi.s	.waitForScan		; if so, wait for active scan before returning
		rts				; return
; ---------------------------------------------------------------------------

; ===========================================================================
; ---------------------------------------------------------------------------
; Clear The Screen
; ---------------------------------------------------------------------------
SHC_ClearScreen:
		move.w	#$8F01,(a6)		; set auto-incremement size to byte
		moveq	#0,d0			; clear register d0

		move.l	#$94FF93FF,(a6)		; Clear the VRAM
		move.w	#$9780,(a6)		; ^
		move.l	#$40000080,(a6)		; ^
		move.w	d0,-4(a6)		; ^

		lea	($FF0000).l,a0		; Clear 32Kb of RAM while VRAM Clears
		move.w	#($8000/4)-1,d7		; ^
.loopRAMClr:	move.l	d0,(a0)+		; ^
		dbf	d7,.loopRAMClr		; ^

.waitVRAMClr:	move.w	(a6),ccr		; is a DMA in progress?
		bvs.s	.waitVRAMClr		; if so, loop until DMA is complete

		move.w	#$8F02,(a6)		; set auto-incremement size to word

		move.l	#$C0000000,(a6)		; Clear the CRAM
		moveq	#$1F,d7			; ^
.loopCRAMClr:	move.l	d0,-4(a6)		; ^
		dbf	d7,.loopCRAMClr		; ^

		move.l	#$40000010,(a6)		; Clear the VSRAM
		moveq	#$13,d7			; ^
.loopVSRAMClr:	move.l	d0,-4(a6)		; ^
		dbf	d7,.loopVSRAMClr	; ^

		rts				; return
; ---------------------------------------------------------------------------

	include	"Library/Kosinski Plus.asm"

; ---------------------------------------------------------------------------

SHC_Pal:	; the first set of entries are null on purpose to allow for a simpler fade-to/from-black logic
	dc.w	$000, $000, $000, $000, $000, $000, $000, $000, $000, $000
	dc.w	$200, $400, $600, $800, $A00, $C00, $E00, $E80, $EC8, $EEE

SHC_Anim:	; duration, frame
	dc.b	86-1, SHC_frame0

	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	3-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	3-1, SHC_frame1
	dc.b	1-1, SHC_frame2
	dc.b	2-1, SHC_frame1
	dc.b	2-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	7-1, SHC_frame2

	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	3-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	3-1, SHC_frame1
	dc.b	1-1, SHC_frame2
	dc.b	2-1, SHC_frame1
	dc.b	2-1, SHC_frame2
	dc.b	1-1, SHC_frame1

	dc.b	117-1, SHC_frame2

	dc.b	1-1, SHC_frame0
	dc.b	2-1, SHC_frame2
	dc.b	1-1, SHC_frame0
	dc.b	3-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	3-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame2
	dc.b	2-1, SHC_frame0
	dc.b	1-1, SHC_frame2
	dc.b	3-1, SHC_frame0
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	2-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame2
	dc.b	1-1, SHC_frame1
	dc.b	1-1, SHC_frame0
	dc.b	1-1, SHC_frame1

	dc.b	86-1, SHC_frame0
	dc.b	-1, -1				; end flag

SHC_Art:	incbin "Art/Logo Art.kosp"
		even

SHC_Map:	incbin "Art/Plane Map.kosp"
		even

	include	"Sound/smps.asm"