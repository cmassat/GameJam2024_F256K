.section variables
	PUMP_SPEED = 15
	PUMP_FRAMES = 4
.endsection

.section code
mac_build_frames_by_dist .macro min_y, curr_y, pxls_per_frame, frame
;	clc
	lda #\min_y
	sbc \curr_y
	cmp #0
	beq _fr0
	clc
	lda #\min_y
	sbc \curr_y
	;sta m_math_n
	ldx #\pxls_per_frame
	jsr fn_divide_8bit
	sta \frame
	bra _end_frame
_fr0
	stz \frame
_end_frame
.endmacro

mac_ani_up .macro dir, max_height
	lda \dir
	cmp #DIR_UP
	bne _not_up
	lda m_pump_y
	cmp #\max_height
	bcc _move_down
	dec m_pump_y
	bra _not_up
_move_down
	lda #DIR_DN
	sta \dir
_not_up
.endmacro

mac_ani_down .macro direction, ob_height
	lda \direction
	cmp #DIR_DN
	bne _not_down
	lda m_pump_y
	cmp #\ob_height
	bcs _move_up
	inc m_pump_y
	bra _not_down
_move_up
	lda #DIR_UP
	sta \direction
_not_down
.endmacro

proc_pump_ani
	#mac_build_frames_by_dist PUMPKIN_Y_MIN, m_pump_y, PUMKIN_PXLS_PER_FRAME, m_pumpkin_frame
	#mac_ani_up m_pumpkin_dir, PUMPKIN_Y_MAX
	#mac_ani_down m_pumpkin_dir, PUMPKIN_Y_MIN
	rts

handle_pump_animation
	jsr proc_pump_ani
	jsr print_scroll
	rts
.endsection

.section variables
	m_pumpkin_v_sync
		.byte 0
	m_pumpkin_frame
		.byte 0
	m_pumpkin_dir
		.byte 0
.endsection
