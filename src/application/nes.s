init_nes
	lda #%10000101
	sta $D880
	rts

handle_nes
   ;lda #$01
;	sta $D880

	lda #%10000101
	sta $D880
_wait
	;lda $D880
	;and #%01000000
	;cmp #%01000000
;	bra _wait
	;lda #$01
	;sta $D880
	rts

is_nes_right
	lda $D884
	and #%00000001
	cmp #%00000001
	beq _yes
	sec
	rts
_yes
	clc
	rts
