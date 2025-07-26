;=======================================================;
;			*$$SETB.ASM  (Sound S.E. Address Table)		;
;						ORG. MDSETB11.ASM				;
;				'Sound-Source'							;
;				 for Mega Drive (68K)					;
;						Ver  1.1 / 1990.9.1				;
;									  By  H.Kubota		;
;=======================================================;

;		public	setb,backtb

;		extern	SA0,SA1,SA2,SA3,SA4,SA5,SA6,SA7,SA8
;		extern	SA9,SAA,SAB,SAC,SAD,SAE,SAF
;		extern	SD0,SD1,SD2,SD3

;		include mdEQ11.lib

;		ifz		prg
;		org		se_top
;		endif

		even

;=======================================;
;										;
;			S.E. ADDRESS TABLE			;
;										;
;=======================================;
setb:
		if		seend>0A0H-1
				DC.L	SA0-setb
		endif
		if		seend>0A1H-1
				DC.L	SA1-setb
		endif
		if		seend>0A2H-1
				DC.L	SA2-setb
		endif
		if		seend>0A3H-1
				DC.L	SA3-setb
		endif
		if		seend>0A4H-1
				DC.L	SA4-setb
		endif
		if		seend>0A5H-1
				DC.L	SA5-setb
		endif
		if		seend>0A6H-1
				DC.L	SA6-setb
		endif
		if		seend>0A7H-1
				DC.L	SA7-setb
		endif
		if		seend>0A8H-1
				DC.L	SA8-setb
		endif
		if		seend>0A9H-1
				DC.L	SA9-setb
		endif
		if		seend>0AAH-1
				DC.L	SAA-setb
		endif
		if		seend>0ABH-1
				DC.L	SAB-setb
		endif
		if		seend>0ACH-1
				DC.L	SAC-setb
		endif
		if		seend>0ADH-1
				DC.L	SAD-setb
		endif
		if		seend>0AEH-1
				DC.L	SAE-setb
		endif
		if		seend>0AFH-1
				DC.L	SAF-setb
		endif
		if		seend>0B0H-1
				DC.L	SB0-setb
		endif
		if		seend>0B1H-1
				DC.L	SB1-setb
		endif
		if		seend>0B2H-1
				DC.L	SB2-setb
		endif
		if		seend>0B3H-1
				DC.L	SB3-setb
		endif
		if		seend>0B4H-1
				DC.L	SB4-setb
		endif
		if		seend>0B5H-1
				DC.L	SB5-setb
		endif
		if		seend>0B6H-1
				DC.L	SB6-setb
		endif
		if		seend>0B7H-1
				DC.L	SB7-setb
		endif
		if		seend>0B8H-1
				DC.L	SB8-setb
		endif
		if		seend>0B9H-1
				DC.L	SB9-setb
		endif
		if		seend>0BAH-1
				DC.L	SBA-setb
		endif
		if		seend>0BBH-1
				DC.L	SBB-setb
		endif
		if		seend>0BCH-1
				DC.L	SBC-setb
		endif
		if		seend>0BDH-1
				DC.L	SBD-setb
		endif
		if		seend>0BEH-1
				DC.L	SBE-setb
		endif
		if		seend>0BFH-1
				DC.L	SBF-setb
		endif
		if		seend>0C0H-1
				DC.L	SC0-setb
		endif
		if		seend>0C1H-1
				DC.L	SC1-setb
		endif
		if		seend>0C2H-1
				DC.L	SC2-setb
		endif
		if		seend>0C3H-1
				DC.L	SC3-setb
		endif
		if		seend>0C4H-1
				DC.L	SC4-setb
		endif
		if		seend>0C5H-1
				DC.L	SC5-setb
		endif
		if		seend>0C6H-1
				DC.L	SC6-setb
		endif
		if		seend>0C7H-1
				DC.L	SC7-setb
		endif
		if		seend>0C8H-1
				DC.L	SC8-setb
		endif
		if		seend>0C9H-1
				DC.L	SC9-setb
		endif
		if		seend>0CAH-1
				DC.L	SCA-setb
		endif
		if		seend>0CBH-1
				DC.L	SCB-setb
		endif
		if		seend>0CCH-1
				DC.L	SCC-setb
		endif
		if		seend>0CDH-1
				DC.L	SCD-setb
		endif
		if		seend>0CEH-1
				DC.L	SCE-setb
		endif
		if		seend>0CFH-1
				DC.L	SCF-setb
		endif

backtb:
				DC.L	SD0-backtb
				DC.L	SD1-backtb
				DC.L	SD2-backtb
				DC.L	SD3-backtb

; vim: set ft=asm68k sw=4 ts=4 noet:
