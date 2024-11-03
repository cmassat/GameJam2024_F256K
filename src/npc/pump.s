.section variables

NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
PUMPKIN_NO_FRAMES = 5
PUMPKIN_Y_MIN =  240-16; 224
PUMPKIN_Y_MAX =  240-32; 208
PUMKIN_DISTANCE = PUMPKIN_Y_MIN - PUMPKIN_Y_MAX ;16
PUMKIN_PXLS_PER_FRAME = (PUMKIN_DISTANCE / PUMPKIN_NO_FRAMES); + .05

PUMP_00_SPR_CTRL  = SPR_00_CTRL + (1 * 8)
PUMP_00_SPR_ADDR = NPC_SPR_PMK_0
PUMP_00_TILE_NUM = 12

.endsection

.section code
mac_npc_set_xy .macro sprite_ctrl, tile_num 
	lda #\tile_num
	jsr get_tile_x_for_gem
	bcc _show
	#disable_sprite \sprite_ctrl
	bra _skip
_show
	jsr sprite_set_x
	;sta m_set_x
	;stx m_set_x + 1
	lda m_pump_y
	;sta m_set_y
	ldx m_pump_y + 1
	jsr sprite_set_y
	;sta m_set_y + 1
	#set_sprite_xy \sprite_ctrl
	#set_npc \SPRITE_CTRL
_skip
.endmacro

mac_npc_set_addr .macro sprite_ctrl, frame  
	lda \frame 
	cmp #0
	beq _fr0 
	cmp #1
	beq _fr1
	cmp #2
	beq _fr2
	cmp #3
	beq _fr3
	cmp #4
	beq _fr4
	bra _skip_addr
_fr0
	#set_sprite_addr \sprite_ctrl, NPC_SPR_PMK_0
	bra _skip_addr
_fr1
	#set_sprite_addr \sprite_ctrl, NPC_SPR_PMK_1
	bra _skip_addr
_fr2
	#set_sprite_addr \sprite_ctrl, NPC_SPR_PMK_2
	bra _skip_addr
_fr3
	#set_sprite_addr \sprite_ctrl, NPC_SPR_PMK_3
	bra _skip_addr
_fr4
	#set_sprite_addr \sprite_ctrl, NPC_SPR_PMK_4
	bra _skip_addr
_skip_addr

.endmacro

mac_npc_init .macro SPRITE_CTRL, SPRITE_ADDR
	#set_npc \SPRITE_CTRL
	#set_sprite_addr \SPRITE_CTRL, \SPRITE_ADDR
.endmacro

init_pump0
		#mac_npc_init PUMP_00_SPR_CTRL, PUMP_00_SPR_ADDR
		
	rts 

init_pumpkin
	lda #PUMPKIN_Y_MIN
	sta m_pump_y_max
	sta m_pump_y
	stz m_pump_y + 1
	lda #PUMPKIN_Y_MAX
	sta m_pump_y_max
	lda #DIR_UP
	sta m_pumpkin_dir
	jsr init_pump0
	rts

handle_pumpkin
	#mac_npc_set_xy PUMP_00_SPR_CTRL, PUMP_00_TILE_NUM
	
	#mac_npc_set_addr PUMP_00_SPR_CTRL, m_pumpkin_frame
	jsr is_collision_a
	bcs _continue
	#disable_sprite PUMP_00_SPR_CTRL
	rts
_continue
	jsr handle_pump_animation
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
.endsection

.section variables
	m_pump_y_min .byte 0
	m_pump_y_max .byte 0
	m_pump_y     .byte 0,0
	m_pump_ctrl  .byte 0,0
	m_hitbox_start_x .byte 0,0
	m_hitbox_start_y .byte 0,0
	m_hitbox_end_x .byte 0,0
	m_hitbox_end_y .byte 0,0
	m_hitbox_start_x_ovlp .byte 0,0
	m_hitbox_end_x_ovlp .byte 0,0
	m_hitbox_start_y_ovlp .byte 0,0
	m_hitbox_end_y_ovlp .byte 0,0
	m_npc_n .byte 0,0
.endsection