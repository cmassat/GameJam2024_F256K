.section code
is_collision_a
	jsr create_hitbox_a
	jsr create_player_hitbox
	jsr determine_collision_x_start_a
	jsr determine_collision_x_end_a 
	jsr determine_collision_y_start_a 
	jsr determine_collision_y_end_a
	jsr check_hitbox_overlap_a
rts

create_hitbox_a
	jsr sprite_get_x
	sta m_hitbox_start_x
	lda m_hitbox_start_x
	clc
	adc #15
	sta m_hitbox_end_x

	;lda m_set_x + 1
	txa 
	sta m_hitbox_end_x + 1
	adc #0
	sta m_hitbox_end_x + 1

	jsr sprite_get_y 
	sta m_hitbox_start_y
	lda m_hitbox_start_y
	clc
	adc #15
	sta m_hitbox_end_y

	txa 
	sta m_hitbox_start_y + 1
	adc #0
	sta m_hitbox_end_y + 1
	rts

fn_collision_a
	lda m_npc_n
	sec
	sbc m_p1_n
	sta m_result_n

	lda m_npc_n + 1
	sbc m_p1_n + 1
	sta m_result_n + 1
	lda m_result_n + 1
	and #%10000000
	cmp #%10000000
	beq _is_neg
	bra _return
	rts
_is_neg
	lda m_result_n + 1
	eor #$ff
	sta m_result_n + 1

	lda m_result_n
	eor #$ff
	sta m_result_n
	clc 
	lda m_result_n
	adc #1
	sta m_result_n
	lda m_result_n + 1
	adc #0
	sta m_result_n + 1
_return
	lda m_result_n 
	ldx m_result_n + 1
	rts 

determine_collision_x_start_a
	lda m_hitbox_start_x 
	sta m_npc_n
	lda m_hitbox_start_x + 1 
	sta m_npc_n + 1
	lda m_p1_x 
	sta m_p1_n
	jsr fn_collision_a
	sta m_hitbox_start_x_ovlp
	stx m_hitbox_start_x_ovlp + 1
    rts

determine_collision_x_end_a
	lda m_hitbox_end_x 
	sta m_npc_n
	lda m_hitbox_end_x + 1 
	sta m_npc_n + 1
	lda m_p1_x_end 
	sta m_p1_n
	jsr fn_collision_a
	sta m_hitbox_end_x_ovlp
	stx m_hitbox_end_x_ovlp + 1
	rts

determine_collision_y_start_a
	lda m_hitbox_start_y
	sta m_npc_n
	lda m_hitbox_start_y + 1 
	sta m_npc_n + 1
	lda m_p1_y
	sta m_p1_n
	jsr fn_collision_a
	sta m_hitbox_start_y_ovlp
	stx m_hitbox_start_y_ovlp + 1
	rts

determine_collision_y_end_a
	lda m_hitbox_end_y
	sta m_npc_n
	lda m_hitbox_end_y + 1 
	sta m_npc_n + 1
	lda m_p1_y_end
	sta m_p1_n
	jsr fn_collision_a
	sta m_hitbox_end_y_ovlp
	stx m_hitbox_end_y_ovlp + 1
	rts

check_hitbox_overlap_a
	lda m_hitbox_start_x_ovlp + 1
	cmp #0
	bne _end

	lda m_hitbox_end_x_ovlp + 1
	cmp #0
	bne _end

	lda m_hitbox_end_y_ovlp + 1
	cmp #0
	bne _end

	lda m_hitbox_start_y + 1
	cmp #0
	bne _end

	jsr is_x_in_range_a 
	bcs _end
	jsr is_y_in_range_a
	bcs _end
	clc
	rts
_end
 	sec
	rts

is_x_in_range_a
	lda m_hitbox_start_x_ovlp
	cmp #15
	bcc _x_collided
	lda m_hitbox_end_x_ovlp
	cmp #15
	bcc _x_collided
	sec
	rts
_x_collided
	clc
	rts

is_y_in_range_a	
	lda m_hitbox_start_y_ovlp
	cmp #15
	bcc _y_collided
	lda m_hitbox_end_y_ovlp
	cmp #15
	bcc _y_collided
	sec
	rts
_y_collided
	clc
	rts
.endsection

.section variables
	m_hitbox_start_x .byte 0,0
	m_hitbox_start_y .byte 0,0
	m_hitbox_end_x .byte 0,0
	m_hitbox_end_y .byte 0,0
	m_hitbox_start_x_ovlp .byte 0,0
	m_hitbox_end_x_ovlp .byte 0,0
	m_hitbox_start_y_ovlp .byte 0,0
	m_hitbox_end_y_ovlp .byte 0,0
	m_npc_n .byte 0,0
	m_result_n .byte 0,0
	m_p1_n .byte 0,0
.endsection

; .section variables
; COLLISION_SPR_NUM = SPR_CTRL_21
; COLLISION_SPR_00 = SPR32_ADDR  + ($400 * 20)
; COLLISION_SPR_01 = COLLISION_SPR_00  + ($400)
; COLLISION_SPR_02 = COLLISION_SPR_01  + ($400)
; COLLISION_SPR_03 = COLLISION_SPR_02  + ($400)
; COLLISION_SPR_04 = COLLISION_SPR_03  + ($400)
; COLLISION_SPR_05 = COLLISION_SPR_04  + ($400)
; COLLISION_SPR_06 = COLLISION_SPR_05  + ($400)
; COLLISION_SPR_07 = COLLISION_SPR_06  + ($400)
; COLLISION_SPR_08 = COLLISION_SPR_07  + ($400)
; COLLISION_SPR_09 = COLLISION_SPR_08  + ($400)
; COLLISION_SPR_10 = COLLISION_SPR_09  + ($400)
; COLLISION_SPR_11 = COLLISION_SPR_10  + ($400)
; COLLISION_SPR_12 = COLLISION_SPR_11  + ($400)
; .endsection

; .section code
; do_reset
; 	lda m_collide_reset
; 	cmp #1
; 	beq _true
; 	sec
; 	rts
; _true
; 	clc
; 	rts

; collide_reset
; 	stz m_collide_reset
; 	rts

; is_collided
; 	lda m_is_collided
; 	cmp #1
; 	beq _true
; 	sec
; 	rts
; _true
; 	clc
; 	rts

; handle_collision
; 	jsr do_reset
; 	bcc _do_not_detect
; _do_not_detect
; 	bra _check_4_collision
; 	rts
; _check_4_collision
; 	lda m_is_collided
; 	cmp #1
; 	beq _boom
; 	rts
; _boom
; 	lda m_collide_frame
; 	cmp #0
; 	bne _animate
; 	jsr init_explosion_animation

; _animate
; 	inc m_collide_vsync
; 	lda m_collide_vsync
; 	cmp #10
; 	beq _increase_frame
; 	rts
; _increase_frame
; 	stz m_collide_vsync
; 	inc m_collide_frame
; 	lda m_collide_frame
; 	cmp #12
; 	beq _reset_collision
; 	jsr animate_p1_collided
; 	rts
; _reset_collision
; 	#disable_sprite COLLISION_SPR_NUM
; 	stz m_collide_vsync
; 	stz m_collide_frame
; 	stz m_is_collided
; 	lda #1
; 	sta m_collide_reset
; 	lda #0
; 	rts

; animate_p1_collided
; 	jsr animate_explosion
; 	rts

; animate_explosion
; 	jsr explosion_f01
; 	jsr explosion_f02
; 	jsr explosion_f03
; 	jsr explosion_f04
; 	jsr explosion_f05
; 	jsr explosion_f06
; 	jsr explosion_f07
; 	jsr explosion_f08
; 	jsr explosion_f09
; 	jsr explosion_f10
; 	jsr explosion_f11
; 	jsr explosion_f12
; 	rts

; set_explosion .macro frame_num, spr_location
; 	lda m_collide_frame
; 	cmp #\frame_num
; 	beq _animate
; 	bra _skip
; _animate
; 	#set_sprite_addr COLLISION_SPR_NUM, \spr_location
; 	jsr set_xy
; 	#set_sprite_xy COLLISION_SPR_NUM
; _skip
; .endmacro

; explosion_f01
; 	#set_explosion 1, COLLISION_SPR_01
; 	rts
; explosion_f02
; 	#set_explosion 2, COLLISION_SPR_02
; 	rts
; explosion_f03
; 	#set_explosion 3, COLLISION_SPR_03
; 	rts
; explosion_f04
; 	#set_explosion 4, COLLISION_SPR_04
; 	rts
; explosion_f05
; 	#set_explosion 5, COLLISION_SPR_05
; 	rts
; explosion_f06
; 	#set_explosion 6, COLLISION_SPR_06
; 	rts
; explosion_f07
; 	#set_explosion 7, COLLISION_SPR_07
; 	rts
; explosion_f08
; 	#set_explosion 8, COLLISION_SPR_08
; 	rts
; explosion_f09
; 	#set_explosion 9, COLLISION_SPR_09
; 	rts
; explosion_f10
; 	#set_explosion 10, COLLISION_SPR_10
; 	rts
; explosion_f11
; 	#set_explosion 11, COLLISION_SPR_11
; 	rts
; explosion_f12
; 	#set_explosion 12, COLLISION_SPR_12
; 	rts

; set_xy
; 	lda m_collide_x_2
; 	sta m_set_x

; 	lda m_collide_x_2 + 1
; 	sta m_set_x + 1

; 	lda m_collide_y_2
; 	sta m_set_y

; 	lda m_collide_y_2 + 1
; 	sta m_set_y + 1
; 	rts

; init_explosion_animation
; 	#set_pc COLLISION_SPR_NUM
; 	#set_sprite_addr COLLISION_SPR_NUM, COLLISION_SPR_00
; 	jsr set_xy
; 	#set_sprite_xy COLLISION_SPR_NUM
; 	rts

; check_collision
; 	jsr collision_math_x
;     jsr collision_math_y
;     jsr calculate_collided
; 	rts

; calculate_collided
;     clc
;     lda m_collide_x_diff + 1
;     cmp #0
;     beq _next_x
;     rts
; _next_x
;     lda m_collide_x_diff
;     cmp #16
;     bcc _check_y
;     rts
; _check_y
;     lda m_collide_y_diff + 1
;     cmp #0
;     beq _next_y
;     rts
; _next_y
;     lda m_collide_y_diff
;     cmp #25
;     bcc _hit
;     rts
; _hit
;     sec
;     lda #1
;     sta m_is_collided
;     rts

; collision_math_x
;     lda m_collide_x_1
;     sec
;     sbc m_collide_x_2
;     sta m_collide_x_diff

;     lda m_collide_x_1 + 1
;     sbc m_collide_x_2 + 1
;     sta m_collide_x_diff + 1
;     BPL _ok
;     bra _revers_calc
; _ok
;     rts
; _revers_calc
;     lda m_collide_x_1
;     sec
;     sbc m_collide_x_2
;     sta m_collide_x_diff

;     lda m_collide_x_1 + 1
;     sbc m_collide_x_2 + 1
;     sta m_collide_x_diff + 1
; rts

; collision_math_y
;     lda m_collide_y_1
;     sec
;     sbc m_collide_y_2
;     sta m_collide_y_diff

;     lda m_collide_y_1 + 1
;     sbc m_collide_y_2 + 1
;     sta m_collide_y_diff + 1
;     BPL _ok
;     bra _revers_calc
; _ok
;     rts
; _revers_calc
;     sec
;     lda m_collide_y_2
;     sbc m_collide_y_1
;     sta m_collide_y_diff

;     lda m_collide_y_2 + 1
;     sbc m_collide_y_1 + 1
;     sta m_collide_y_diff + 1
;     rts

; collide_set_x1
; 	sta m_collide_x_1
; 	stx m_collide_x_1 + 1
; 	rts
; collide_set_x2
; 	sta m_collide_x_2
; 	stx m_collide_x_2 + 1
; 	rts

; collide_set_y1
; 	sta m_collide_y_1
; 	stx m_collide_y_1 + 1
; 	rts
; collide_set_y2
; 	sta m_collide_y_2
; 	stx m_collide_y_2 + 1
; 	rts
; .endsection

; .section variables
; m_collide_x_1
; 	.byte 0,0
; m_collide_y_1
; 	.byte 0,0
; m_collide_x_2
; 	.byte 0,0
; m_collide_y_2
; 	.byte 0,0
; m_collide_x_diff
;     .byte 0,0
; m_collide_y_diff
;     .byte 0,0
; m_is_collided
;     .byte 0
; m_collide_vsync
; 	.byte 0
; m_collide_frame
; 	.byte 0
; m_collide_reset
; 	.byte 0
; m_collide_debug
; 	.byte 0
; .endsection