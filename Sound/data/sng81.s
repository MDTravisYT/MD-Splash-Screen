;=======================================================;
;			*$$SNG81.S	(Song Data)						;
;						ORG. MDSNG115.S					;
;				'Sound-Source'							;
;				 for Mega Drive (68K)					;
;						Ver  1.1 / 1990.9.1				;
;									  By  H.Kubota		;
;=======================================================;

;		public	S81

;		list off
;		include	mdEQ11.LIB
;		include	mdMCR11.LIB
;		include	mdTB11.LIB
;		list on

		even

;===============================================;
;												;
;					 ASSIGN						;
;												;
;===============================================;
;=====< S81 CHANNEL TOTAL >=====;
FM81	EQU		7				; FM Channel Total
PSG81	EQU		3				; PSG Channel Total
;=========< S81 TEMPO >=========;
TP81	EQU		1				; Tempo
DL81	EQU		80				; Delay
;==========< S81 BIAS >=========;
FB810	EQU		0				; FM 0ch
FB811	EQU		-12				; FM 1ch
FB812	EQU		-12				; FM 2ch
FB814	EQU		0				; FM 4ch
FB815	EQU		0				; FM 5ch
FB816	EQU		0				; FM 6ch (if don't use PCM drum)
PB818	EQU		-24				; PSG 80ch
PB81A	EQU		-24				; PSG A0ch
PB81C	EQU		0				; PSG C0ch
;==========< S81 VOLM >=========;
FA810	EQU		8				; FM 0ch
FA811	EQU		6				; FM 1ch
FA812	EQU		10				; FM 2ch
FA814	EQU		14				; FM 4ch
FA815	EQU		14				; FM 5ch
FA816	EQU		0				; FM 6ch (if don't use PCM drum)
PA818	EQU		0				; PSG 80ch
PA81A	EQU		0				; PSG A0ch
PA81C	EQU		1				; PSG C0ch
;==========< S81 ENVE >=========;
PE818	EQU		3				; PSG 80ch
PE81A	EQU		3				; PSG A0ch
PE81C	EQU		1				; PSG C0ch

;===============================================;
;												;
;					 HEADER						;
;												;
;===============================================;
S81:
		TDW		TIMB81,S81				; Voice Top Address
		DC.B	FM81,PSG81,TP81,DL81	; FM Total,PSG Total,Tempo,Delay

		TDW		TAB81D,S81				; PCM Drum Table Pointer
		DC.B	0,0						; Bias,Volm (Dummy)

		TDW		TAB810,S81				; FM 0ch Table Pointer
		DC.B	FB810,FA810				; Bias,Volm

		TDW		TAB811,S81				; FM 1ch Table Pointer
		DC.B	FB811,FA811				; Bias,Volm

		TDW		TAB812,S81				; FM 2ch Table Pointer
		DC.B	FB812,FA812				; Bias,Volm

		TDW		TAB814,S81				; FM 4ch Table Pointer
		DC.B	FB814,FA814				; Bias,Volm

		TDW		TAB815,S81				; FM 5ch Table Pointer
		DC.B	FB815,FA815				; Bias,Volm

		TDW		TAB816,S81				; FM 6ch Table Pointer
		DC.B	FB816,FA816				; Bias,Volm (if don't use PCM drum)

		TDW		TAB818,S81				; PSG 80ch Table Pointer
		DC.B	PB818,PA818,0,PE818		; Bias,Volm,Dummy,Enve

		TDW		TAB81A,S81				; PSG A0ch Table Pointer
		DC.B	PB81A,PA81A,0,PE81A		; Bias,Volm,Dummy,Enve

		TDW		TAB81C,S81				; PSG C0ch Table Pointer
		DC.B	PB81C,PA81C,0,PE81C		; Bias,Volm,Dummy,Enve

;===============================================;
;												;
;				   SONG TABLE					;
;												;
;===============================================;
;===============================================;
;					 FM 0ch						;
;===============================================;
TAB810	EQU		*
		DC.B	FEV,0,CMCALL
		JDW		T8101
		DC.B	EN2,6,NL,EN2,NL,CMCALL
		JDW		T8101
		DC.B	EN2,6,EN3,4,NL,2,EN2,6,NL,CMCALL
		JDW		T8101
		DC.B	EN2,6,NL,BN2,12,NL,AN2,078H,EN2
		DC.B	6,AN2,BN2,DN3,CMCALL
		JDW		T8102
		DC.B	CMVADD,9,CMCALL
		JDW		T8102
		DC.B	CMVADD,9,CMCALL
		JDW		T8102
		DC.B	CMVADD,9,CMCALL
		JDW		T8102
		DC.B	CMEND
T8101	EQU		*
		DC.B	DN3,6,EN3,4,NL,2,CMRET
T8102	EQU		*
		DC.B	EN3,8,NL,4,CMRET
;===============================================;
;					 FM 1ch						;
;===============================================;
TAB811	EQU		*
		DC.B	FEV,1,CMCALL
		JDW		T8111
		DC.B	CMCALL
		JDW		T8112
		DC.B	FVR,3,1,5,5,CMCALL
		JDW		T8113
		DC.B	CMEND
T8111	EQU		*
		DC.B	NL,048H,NL,12,CMRET
T8112	EQU		*
		DC.B	FS4,3,AN4,BN4,DN5,EN5,12,EN4,3
		DC.B	AN4,BN4,EN5,CMRET
T8113	EQU		*
		DC.B	GS5,078H,CMRET
;===============================================;
;					 FM 2ch						;
;===============================================;
TAB812	EQU		*
		DC.B	LRPAN,RSET,FVR,3,1,9,5,FEV,1
		DC.B	CMCALL
		JDW		T8111
		DC.B	NL,6,CMCALL
		JDW		T8112
		DC.B	CMCALL
		JDW		T8113
		DC.B	CMEND
;===============================================;
;					 FM 4ch						;
;===============================================;
TAB814	EQU		*
		DC.B	FEV,2,LRPAN,LSET,CMCALL
		JDW		T8141
		DC.B	CMCALL
		JDW		T8142
		DC.B	CMVADD,8,CMCALL
		JDW		T8142
		DC.B	CMVADD,-9,FVR,3,1,6,5,BN4,078H
		DC.B	CMEND
T8141	EQU		*
		DC.B	NL,060H,CMRET
T8142	EQU		*
		DC.B	GS4,8,NL,4,CMRET
;===============================================;
;					 FM 5ch						;
;===============================================;
TAB815	EQU		*
		DC.B	FEV,2,LRPAN,RSET,CMCALL
		JDW		T8141
		DC.B	CMCALL
		JDW		T8151
		DC.B	CMVADD,8,CMCALL
		JDW		T8151
		DC.B	CMVADD,-9,FVR,3,1,6,5,EN4,078H
		DC.B	CMEND
T8151	EQU		*
		DC.B	CS4,8,NL,4,CMRET
;===============================================;
;		  FM 6ch (if don't use PCM drum)		;
;===============================================;
TAB816	EQU		*
		DC.B	FEV,4,FS3,12
		DC.B	FEV,3,DN1,DN1
		DC.B	FEV,4,FS3
		DC.B	FEV,3,DN1,DN1
		DC.B	FEV,4,FS3,FS3,4,4,4
		DC.B	FEV,3,DN1,12
		DC.B	FEV,4,FS3,4,4,4
		DC.B	FEV,3,DN1,078H
		DC.B	FEV,4,FS3,6,6,6,6
		DC.B	FEV,3,DN1,048H
		DC.B	CMEND
;===============================================;
;					 PSG 80ch					;
;===============================================;
TAB818	EQU		*
		DC.B	PVADD,3
		DC.B	NL,12,BN3,3,NL,BN3,NL
		DC.B	NL,12,BN3,3,NL,BN3,NL
		DC.B	NL,6,BN3,3,NL,BN3
		DC.B	NL,9,BN3,3,NL,BN3,NL,15
		DC.B	BN3,12,NL,FVR,12,1,2,5,PVADD,-3
		DC.B	AN3,078H,VROFF
		DC.B	EN4,3,FS4,GS4,AN4,BN4,CN5,CS5,DN5
		DC.B	EN5,6,NL,PVADD,7,EN5,6,NL,PVADD,3
		DC.B	EN5,6,NL
		DC.B	CMEND
;===============================================;
;					 PSG A0ch					;
;===============================================;
TAB81A	EQU		*
		DC.B	PVADD,3
		DC.B	NL,12,GS4,3,NL,GS4,NL
		DC.B	NL,12,GS4,3,NL,GS4,NL
		DC.B	NL,6,GS4,3,NL,GS4
		DC.B	NL,9,GS4,3,NL,GS4,NL,15
		DC.B	GS4,12,NL,FVR,12,1,2,5,PVADD,-3
		DC.B	BN4,078H,VROFF,PVADD,5,FDT,0
		DC.B	NL,3,NL,NL,EN4,FS4,GS4,AN4,BN4
		DC.B	CN5,CS5,DN5,EN5,6,NL,PVADD,5
		DC.B	EN5,6,NL,PVADD,3,EN5,6,NL
		DC.B	CMEND
;===============================================;
;					 PSG C0ch					;
;===============================================;
TAB81C	EQU		*
		DC.B	CMNOIS,NOIS7
		DC.B	0C6H,24,0C6H,0C6H,12,0C6H,6,0C6H
		DC.B	0C6H,24,EV,2,0C6H,24,0C6H,078H
		DC.B	EV,2,0C6H,12,0C6H,0C6H,48
		DC.B	CMEND
;===============================================;
;					 PCM DRUM					;
;===============================================;
TAB81D	EQU		*
		DC.B	CMEND

;===============================================;
;												;
;					  VOICE						;
;												;
;===============================================;
TIMB81	EQU		*

	dc.b	$00
	dc.b	$27, $37, $30, $20, 	$1F, $1F, $1F, $1F, 	$07, $06, $09, $06
	dc.b	$07, $06, $06, $08, 	$20, $10, $10, $0F, 	$19, $37, $18, $80

	dc.b	$04
	dc.b	$17, $03, $06, $74, 	$5F, $5F, $5F, $5F, 	$00, $08, $00, $00
	dc.b	$00, $00, $00, $0A, 	$0F, $FF, $0F, $0F, 	$1C, $88, $23, $88

	dc.b	$3A
	dc.b	$01, $07, $31, $71, 	$8E, $8E, $8D, $53, 	$0E, $0E, $0E, $03
	dc.b	$00, $00, $00, $07, 	$1F, $FF, $1F, $0F, 	$18, $28, $27, $80

	dc.b	$3B
	dc.b	$01, $03, $00, $01, 	$1F, $1F, $1F, $1F, 	$13, $13, $10, $10
	dc.b	$14, $12, $13, $10, 	$45, $75, $35, $2A, 	$1A, $17, $18, $00

	dc.b	$3C
	dc.b	$0F, $00, $02, $01, 	$1F, $5F, $1F, $9F, 	$00, $10, $1F, $0F
	dc.b	$00, $0F, $0F, $0D, 	$06, $3C, $F6, $7C, 	$0C, $04, $06, $00

; vim: set ft=asm68k sw=4 ts=4 noet:
