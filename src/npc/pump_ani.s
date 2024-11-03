.section variables
	COLLISION_SPR_NUM = SPR_CTRL_21
	COLLISION_SPR_00 = SPR32_ADDR  + ($400 * 20)
	COLLISION_SPR_01 = COLLISION_SPR_00  + ($400)
	COLLISION_SPR_02 = COLLISION_SPR_01  + ($400)
	COLLISION_SPR_03 = COLLISION_SPR_02  + ($400)
	COLLISION_SPR_04 = COLLISION_SPR_03  + ($400)
	COLLISION_SPR_05 = COLLISION_SPR_04  + ($400)
	COLLISION_SPR_06 = COLLISION_SPR_05  + ($400)
	COLLISION_SPR_07 = COLLISION_SPR_06  + ($400)
	COLLISION_SPR_08 = COLLISION_SPR_07  + ($400)
	COLLISION_SPR_09 = COLLISION_SPR_08  + ($400)
	COLLISION_SPR_10 = COLLISION_SPR_09  + ($400)
	COLLISION_SPR_11 = COLLISION_SPR_10  + ($400)
	COLLISION_SPR_12 = COLLISION_SPR_11  + ($400)
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

mac_build_frames_by_time .macro sync, sync_ct, frame, frame_ct
	lda \sync
	cmp #\sync_ct
	beq _update_frame
	inc \sync
	bra _sync_updated
_update_frame
	stz \sync
	lda \frame
	cmp #\frame_ct
	beq _reset_frame
	inc \frame
	bra _sync_updated
_reset_frame
	stz \frame
_sync_updated
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
; *****************************************************************************
; HIT CODE
; *****************************************************************************
 set_explosion .macro sprite_addr, tile
 	#set_pc SPR_CTRL_21
	#set_sprite_addr SPR_CTRL_21, \sprite_addr
	lda \tile
	jsr get_tile_x_for_player1
	bcs _skip
	jsr sprite_set_x
	lda #<PUMPKIN_Y_MAX
	ldx #>PUMPKIN_Y_MAX
	jsr sprite_set_y
 	#set_sprite_xy SPR_CTRL_21
_skip
.endmacro

proc_pump_explosion_ani
	#set_pc SPR_CTRL_21
	lda #PL_TILE
	sta m_pump_collision_tile
	jsr disable_player1
	jsr explosion_f00
	#mac_build_frames_by_time m_pump_hit_sync, 8, m_pump_hit_frame, 12
	; animate_explosion
 	jsr explosion_f01
 	jsr explosion_f02
 	jsr explosion_f03
 	jsr explosion_f04
 	jsr explosion_f05
 	jsr explosion_f06
 	jsr explosion_f07
 	jsr explosion_f08
 	jsr explosion_f09
 	jsr explosion_f10
 	jsr explosion_f11
 	jsr explosion_f12
	
	rts

explosion_f00
	lda m_pump_hit_frame
	cmp #0
	#set_explosion COLLISION_SPR_00, m_pump_collision_tile
	bne _end
_end
	rts
explosion_f01
	lda m_pump_hit_frame
	cmp #1
	#set_explosion COLLISION_SPR_01, m_pump_collision_tile	
	bne _end
_end
	rts
explosion_f02
	lda m_pump_hit_frame
	cmp #2
	bne _end
	#set_explosion COLLISION_SPR_02, m_pump_collision_tile
_end
	rts
explosion_f03
	lda m_pump_hit_frame
	cmp #3
	bne _end
	#set_explosion COLLISION_SPR_03, m_pump_collision_tile
_end
	rts
explosion_f04
	lda m_pump_hit_frame
	cmp #4
	bne _end
	#set_explosion COLLISION_SPR_04, m_pump_collision_tile
_end
	rts
explosion_f05
	lda m_pump_hit_frame
	cmp #5
	bne _end
	#set_explosion COLLISION_SPR_05, m_pump_collision_tile
_end
	rts
explosion_f06
	lda m_pump_hit_frame
	cmp #6
	bne _end
	#set_explosion COLLISION_SPR_06, m_pump_collision_tile
_end
	rts
explosion_f07
	lda m_pump_hit_frame
	cmp #7
	bne _end
	#set_explosion COLLISION_SPR_07, m_pump_collision_tile
_end
	rts
explosion_f08
	lda m_pump_hit_frame
	cmp #8
	bne _end
	#set_explosion COLLISION_SPR_08, m_pump_collision_tile
_end
	rts
explosion_f09
	lda m_pump_hit_frame
	cmp #9
	bne _end
	#set_explosion COLLISION_SPR_09, m_pump_collision_tile
_end
	rts
explosion_f10
	lda m_pump_hit_frame
	cmp #10
	bne _end
	#set_explosion COLLISION_SPR_10, m_pump_collision_tile
_end
	rts
explosion_f11
	lda m_pump_hit_frame
	cmp #11
	bne _end
	#set_explosion COLLISION_SPR_11, m_pump_collision_tile
_end
	rts
explosion_f12
	lda m_pump_hit_frame
	cmp #12
	bne _end
	#set_explosion COLLISION_SPR_12, m_pump_collision_tile
	jsr explosion_reset
_end
	rts

explosion_reset
	jsr reset_collision_eol
	#disable_sprite COLLISION_SPR_NUM
	jsr enable_player1
	stz m_pump_hit_frame
	stz m_pump_hit_sync
_end
	rts

handle_pump_animation

	jsr proc_pump_ani
	rts
.endsection

.section variables
	m_pumpkin_v_sync
		.byte 0
	m_pumpkin_frame
		.byte 0
	m_pumpkin_dir
		.byte 0
	m_pump_hit_sync
		.byte 0
	m_pump_hit_frame
		.byte 0
.endsection
