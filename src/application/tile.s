


get_x_coord
	lda m_set_x
	ldx m_set_x + 1
	rts 
;a
; 10 30
get_tile_pixel_x
    sta m_tile_hi
	lda m_tile_hi 
	cmp #20
	bcc _set_default
	bra _calc_lo 
_set_default
	
	stz m_tile_low
	bra _end_find_tiles
_calc_lo
	lda m_tile_hi
	sbc #20
	sta m_tile_low
	
_end_find_tiles 
	lda m_x_scroll_tile
	cmp m_tile_low
	bcs _ok
	
	sec 
    rts
_ok
	
    lda m_x_scroll_tile 
	cmp m_tile_hi 
	bcc _ok_hi
	;lda m_temp
    ;adc #20
    ;sta m_temp
    ;lda m_x_scroll_tile
    ;cmp m_temp
    ;bcc _ok_hi
    sec
    rts
_ok_hi

    clc
     lda m_tile_hi
	 sec
     sbc m_x_scroll_tile
	 sta m_temp
     sta $DE00
     lda #0
	 sbc #0
     sta $DE01
     lda #16
     sta $DE02
     lda #0
     sta $DE03
     lda $DE10
     sec
     sbc m_x_scroll_pxl
     sta m_set_x
     lda $DE11
     sbc #0
     sta m_set_x + 1
     clc
	 
    rts

.section variables
    m_tile_low 
        .byte 0
	m_tile_hi
		.byte 0
    m_x_scroll_tile
        .byte 0
    m_x_scroll_pxl
        .byte 0
    m_do_scroll_tile
        .byte 0
	m_temp
		.byte 0
.endsection
