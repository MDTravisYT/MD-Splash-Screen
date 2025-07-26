;=======================================================;
;			*$$SNG81.S	(Song Data)						;
;						ORG. MDSNG115.S					;
;				'Sound-Source'							;
;				 for Mega Drive (68K)					;
;						Ver  1.1 / 1990.9.1				;
;									  By  H.Kubota		;
;=======================================================;

;		public	S82

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
;=====< S82 CHANNEL TOTAL >=====;
FM82	EQU		7				; FM Channel Total
PSG82	EQU		3				; PSG Channel Total
;=========< S82 TEMPO >=========;
TP82	EQU		1				; Tempo
DL82	EQU		1				; Delay
;==========< S82 BIAS >=========;
FB820	EQU		0				; FM 0ch
FB821	EQU		0				; FM 1ch
FB822	EQU		0				; FM 2ch
FB824	EQU		0				; FM 4ch
FB825	EQU		0				; FM 5ch
FB826	EQU		0				; FM 6ch (if don't use PCM drum)
PB828	EQU		0				; PSG 80ch
PB82A	EQU		0				; PSG A0ch
PB82C	EQU		0				; PSG C0ch
;==========< S82 VOLM >=========;
FA820	EQU		7Fh			; FM 0ch
FA821	EQU		7Fh			; FM 1ch
FA822	EQU		7Fh				; FM 2ch
FA824	EQU		7Fh				; FM 4ch
FA825	EQU		7Fh				; FM 5ch
FA826	EQU		7Fh				; FM 6ch (if don't use PCM drum)
PA828	EQU		0Fh			; PSG 80ch
PA82A	EQU		0Fh			; PSG A0ch
PA82C	EQU		0Fh			; PSG C0ch
;==========< S82 ENVE >=========;
PE828	EQU		0				; PSG 80ch
PE82A	EQU		0				; PSG A0ch
PE82C	EQU		0				; PSG C0ch

;===============================================;
;												;
;					 HEADER						;
;												;
;===============================================;
S82:
		TDW		TIMB82,S82				; Voice Top Address
		DC.B	FM82,PSG82,TP82,DL82	; FM Total,PSG Total,Tempo,Delay

		TDW		TAB82D,S82				; PCM Drum Table Pointer
		DC.B	0,0						; Bias,Volm (Dummy)

		TDW		TAB820,S82				; FM 0ch Table Pointer
		DC.B	FB820,FA820				; Bias,Volm

		TDW		TAB821,S82				; FM 1ch Table Pointer
		DC.B	FB821,FA821				; Bias,Volm

		TDW		TAB822,S82				; FM 2ch Table Pointer
		DC.B	FB822,FA822				; Bias,Volm

		TDW		TAB824,S82				; FM 4ch Table Pointer
		DC.B	FB824,FA824				; Bias,Volm

		TDW		TAB825,S82				; FM 5ch Table Pointer
		DC.B	FB825,FA825				; Bias,Volm

		TDW		TAB826,S82				; FM 6ch Table Pointer
		DC.B	FB826,FA826				; Bias,Volm (if don't use PCM drum)

		TDW		TAB828,S82				; PSG 80ch Table Pointer
		DC.B	PB828,PA828,0,PE828		; Bias,Volm,Dummy,Enve

		TDW		TAB82A,S82				; PSG A0ch Table Pointer
		DC.B	PB82A,PA82A,0,PE82A		; Bias,Volm,Dummy,Enve

		TDW		TAB82C,S82				; PSG C0ch Table Pointer
		DC.B	PB82C,PA82C,0,PE82C		; Bias,Volm,Dummy,Enve

;===============================================;
;												;
;				   SONG TABLE					;
;												;
;===============================================;
;===============================================;
;					 FM 0ch						;
;===============================================;
TAB820	EQU		*
		DC.B	CMEND
;===============================================;
;					 FM 1ch						;
;===============================================;
TAB821	EQU		*
		DC.B	CMEND
;===============================================;
;					 FM 2ch						;
;===============================================;
TAB822	EQU		*
		DC.B	CMEND
;===============================================;
;					 FM 4ch						;
;===============================================;
TAB824	EQU		*
		DC.B	CMEND
;===============================================;
;					 FM 5ch						;
;===============================================;
TAB825	EQU		*
		DC.B	CMEND
;===============================================;
;		  FM 6ch (if don't use PCM drum)		;
;===============================================;
TAB826	EQU		*
		DC.B	CMEND
;===============================================;
;					 PSG 80ch					;
;===============================================;
TAB828	EQU		*
		DC.B	CMEND
;===============================================;
;					 PSG A0ch					;
;===============================================;
TAB82A	EQU		*
		DC.B	CMEND
;===============================================;
;					 PSG C0ch					;
;===============================================;
TAB82C	EQU		*
		DC.B	CMEND
;===============================================;
;					 PCM DRUM					;
;===============================================;
TAB82D	EQU		*
		DC.B	CMEND

;===============================================;
;												;
;					  VOICE						;
;												;
;===============================================;
TIMB82	EQU		*

; vim: set ft=asm68k sw=4 ts=4 noet:
