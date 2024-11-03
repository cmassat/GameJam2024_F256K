.section code
init_collision
	stz m_collision_state
	rts 

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

set_collison_eol
	lda #1
	sta m_collision_state
	rts

reset_collision_eol
	stz m_collision_state
	dec m_player_lives
	lda m_player_lives 
	cmp #0
	beq _game_over 
	rts 
_game_over 
	jsr set_game_over
	rts 

is_collision_eol
	lda m_collision_state
	cmp #1
	beq _eol
	sec
	rts  
_eol
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
	m_collision_state .byte 0
.endsection
