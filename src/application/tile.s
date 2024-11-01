


get_x_coord
	lda m_set_x
	ldx m_set_x + 1
	rts 
; ;a
; get_tile_pixel_x
;     sta m_tile_num 
; 	lda m_tile_num
; 	cmp #20
; 	bcc _set_default_lo
; 	bra _calc_lo 
; _set_default_lo
; 	stz m_tile_low
; 	bra _end_find_tiles
; _calc_lo
; 	lda m_tile_num 
; 	sbc #20
; 	sta m_tile_low
; _end_find_tiles 
; 	lda m_x_scroll_tile
; 	cmp m_tile_low
; 	bcs _ok
	
; 	sec 
;     rts
; _ok
	
;     lda m_x_scroll_tile 
; 	cmp m_tile_num
; 	bcc _ok_hi

;     sec
;     rts
; _ok_hi

;     clc
;      lda m_tile_num
; 	 sec
;      sbc m_x_scroll_tile
;      sta $DE00
;      lda #0
; 	 sbc #0
;      sta $DE01
;      lda #16
;      sta $DE02
;      lda #0
;      sta $DE03
;      lda $DE10
;      sec
;      sbc m_x_scroll_pxl
;      sta m_set_x
;      lda $DE11
;      sbc #0
;      sta m_set_x + 1
	 
;      clc
;     rts

get_tile_x_for_pl1	
	sta $DE00
	lda #0
	sta $DE01
	lda #16
	sta $DE02
	lda #0
	sta $DE03
		 
    lda $DE11
	tax
	
    lda $DE10
	
 
    rts

get_tile_x_for_gem
    sta m_tile_num 
	lda m_tile_num
	cmp #22
	bcc _set_default_lo
	bra _calc_lo 
_set_default_lo
	stz m_tile_low
	bra _end_find_tiles
_calc_lo
	lda m_tile_num 
	sbc #22
	sta m_tile_low
_end_find_tiles 
	lda m_x_scroll_tile
	cmp m_tile_low
	bcs _ok
	
	sec 
    rts
_ok
	
    lda m_x_scroll_tile 
	cmp m_tile_num
	bcc _ok_hi

    sec
    rts
_ok_hi
    clc
     lda m_tile_num
	 sec
     sbc m_x_scroll_tile
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
	sta m_tile_gem_x
     pha
	 ;sta m_set_x
     lda $DE11
    sta m_tile_gem_x + 1
     tax; m_set_x + 1
	 pla
     clc
    rts
.section variables
    m_tile_num
        .byte 0
	m_tile_low
		.byte 0
    m_x_scroll_tile
        .byte 0
    m_x_scroll_pxl
        .byte 0
    m_do_scroll_tile
        .byte 0
	m_tile_p1_x 
		.byte 0,0
	m_tile_param_p1
		.byte 0
	m_tile_gem_x
		.byte 0,0
	m_tile_param_gem
.endsection
