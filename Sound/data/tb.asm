;=======================================================;
;			*$$TB.ASM  (Sound Adddress & Data Table)	;
;						ORG. MDTB11.ASM					;
;				'Sound-Source'							;
;				 for Mega Drive (68K)					;
;						Ver  1.1 / 1990.9.1				;
;									  By  H.Kubota		;
;=======================================================;

;		list off
;		include mdEQ11.lib
;		include mdMCR11.lib
;		include mdTB11.lib
;		list on

;		public	adrtb
;		public	bgmtb,envetb,prtb
;		extern	S81,S82,S83,S84,S85,S86,S87,S88,S89,S8A,S8B,S8C,S8D,S8E,S8F
;		extern	S90,S91,S92,S93,S94,S95,S96,S97

;		if		prg
;		extern	sound
;		extern	setb
;		extern	backtb
;		org		sound_top
;		else
;sound	equ		control_top
;setb	equ		se_top
;backtb	equ		setb+(seend-sestrt+1)*4
;		org		song_top
;		endif

;=======================================;
;										;
;			 TABLE.ASM START			;
;										;
;=======================================;


;=======================================;
;										;
;			  ADDRESS TABLE				;
;										;
;=======================================;

adrtb:
		dc.l	prtb					; priority
		dc.l	prtb					; back se
		dc.l	bgmtb					; bgm
		dc.l	prtb					; s.e
		dc.l	prtb					; dmy (vibr)
		dc.l	envetb					; envelope
		dc.l	sestrt					; se start no.
		dc.l	sound					; 7th fix (for sound editor)

;=======================================;
;										;
;			  ENVELOPE TABLE			;
;										;
;=======================================;
envetb:
		DC.L	EV1-envetb,EV2-envetb,EV3-envetb,EV4-envetb

EV1		EQU		*
		DC.B	0,1,3,7,16,TBEND
EV2		EQU		*
		DC.B	0,0,0,0,1,1,1,1,2,2,3,3
		DC.B	4,5,5,6,7,8,8,9,10,10,11
		DC.B	12,13,14,TBEND
EV3		EQU		*
		DC.B	0,0,0,0,1,2,2,2,2,3,3,3
		DC.B	4,4,5,5,5,6,6,7,7,7,8,8
		DC.B	8,8,9,9,10,10,10,11,11
		DC.B	12,12,13,13,14,14,TBEND
EV4		EQU		*
		DC.B	0,1,1,2,3,4,5,6,7,8,TBEND

		even
;=======================================;
;										;
;			SONG ADDRESS TABLE			;
;										;
;=======================================;
bgmtb:
		DC.L	S81-bgmtb					; 81
		DC.L	S82-bgmtb					; 82

;=======================================;
;										;
;			  PRIORITY TABLE			;
;										;
;=======================================;
prtb:

;=======================================;
;			  END OF FILE				;
;=======================================;

; vim: set ft=asm68k sw=4 ts=4 noet:
