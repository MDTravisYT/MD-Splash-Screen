sound_top:
	include		"sound/data/tb.asm"
	include		"sound/data/sng81.s"
	include		"sound/data/sng82.s"
	
	even
	include		"sound/src/cnt.asm"
	include		"sound/src/cmd.asm"
	include		"sound/src/psg.asm"
;	include		"sound/src/pcm.asm"