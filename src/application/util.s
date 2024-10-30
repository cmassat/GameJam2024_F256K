;a lo_byte
;b hi_byte
;destruct a,x,y
substract1
	sta POINTER_UTIL
	stx POINTER_UTIL + 1

	ldy #0
	lda (POINTER_UTIL), y 
	sec
	sbc #1
	sta (POINTER_UTIL), y 
	iny
	lda (POINTER_UTIL), y 
	sbc #0
	sta (POINTER_UTIL), y 
rts 