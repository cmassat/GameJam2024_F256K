.section code 
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

; numerator / denominator
mac_divide_8bit .macro
	ldx #0
_div	
	lda m_math_n 
	sbc m_math_d
	sta m_math_n
	bpl _add 
	bra _calc_completed
_add
	inx
	bra _div
_calc_completed
	txa 
.endmacro


fn_multiply_8bit
	sta m_mult_a
	stx m_mult_b
	stz m_mult_result 
	ldy #0
_loop
	lda m_mult_result
	clc 
	adc m_mult_a
	sta m_mult_result
	iny 
	cpy m_mult_b
	bcc _loop 
	lda m_mult_result
	rts 

fn_divide_8bit
	sta m_math_n
	stx m_math_d
	#mac_divide_8bit
	rts

.endsection
.section variables 
m_math_n
	.byte 0
m_math_d
	.byte 0
m_mult_a
	.byte 0
m_mult_b 
	.byte 0
m_mult_result
	.byte 0
.endsection