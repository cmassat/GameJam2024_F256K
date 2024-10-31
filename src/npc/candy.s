.section variables
CANDY_SPR_NUM = SPR_CTRL_03
candy_FLOOR = 240 - 64
NPC_SPR_CANDY_0 = NPC_SPR_CAULD_3 + (16 * 16)
NPC_SPR_CANDY_1 = NPC_SPR_CANDY_0 + (16 * 16)
NPC_SPR_CANDY_2 = NPC_SPR_CANDY_1 + (16 * 16)
NPC_SPR_CANDY_3 = NPC_SPR_CANDY_2 + (16 * 16)
NPC_SPR_CANDY_4 = NPC_SPR_CANDY_3 + (16 * 16)
NPC_SPR_CANDY_5 = NPC_SPR_CANDY_4 + (16 * 16)
NPC_SPR_CANDY_6 = NPC_SPR_CANDY_5 + (16 * 16)
.endsection

.section code
mac_init_gem .macro
.endmacro 
init_candy
	lda #0
	sta m_candy_v_sync
	sta m_candy_frame
	sta m_candy_x
	sta m_candy_y
	sta m_candy_collide
	sta m_has_displayed

	lda #10
	sta m_candy_tile
	lda #0
	sta m_candy_pixel
	#set_npc CANDY_SPR_NUM
	rts 
.endsection

handle_candy
	lda m_candy_tile
	;jsr get_tile_pixel_x
	bcc _move
	#disable_sprite CANDY_SPR_NUM
	rts 
_move
	#set_npc CANDY_SPR_NUM
	jsr candy_calc_movement
	jsr show_candy_frames
	;lda m_has_displayed
	;cmp #0
	;beq _init_sprite
	;bra _animate
_init_sprite
	;jsr init_candy_sprite
	;lda #1
	;sta m_has_displayed
_animate
	inc m_candy_v_sync
	lda m_candy_v_sync
	cmp #15
	beq _advance_frame 
	rts 
_advance_frame
	inc m_candy_frame
	stz m_candy_v_sync
	rts

show_candy_frames	
	jsr get_candy_xy
	jsr candy_fr0
	jsr candy_fr1
	jsr candy_fr2
	jsr candy_fr3	
	rts

get_candy_xy
	lda m_candy_tile
	jsr get_x_coord
	lda m_set_x
	clc  
	adc m_candy_pixel
	sta m_set_x 
	sta m_candy_x
	lda m_set_x + 1
	adc #0
	sta m_set_x + 1
	sta m_candy_x + 1
	
	lda #<candy_FLOOR
	sta m_set_y
	sta m_candy_y
	lda #>candy_FLOOR
	sta m_set_y + 1
	sta m_candy_y + 1
	#set_sprite_xy CANDY_SPR_NUM
	rts 

candy_fr0
	lda m_candy_frame
	cmp #0
	bne _do_not_show
	#set_sprite_addr CANDY_SPR_NUM, NPC_SPR_CANDY_0
_do_not_show
	rts	

candy_fr1
	lda m_candy_frame
	cmp #1
	bne _do_not_show
	#set_sprite_addr CANDY_SPR_NUM, NPC_SPR_CANDY_0
_do_not_show
	rts	

candy_fr2
	lda m_candy_frame
	cmp #2
	bne _do_not_show
	#set_sprite_addr CANDY_SPR_NUM, NPC_SPR_CANDY_0
_do_not_show
	rts	

candy_fr3
	lda m_candy_frame
	cmp #3
	bne _do_not_show
	#set_sprite_addr CANDY_SPR_NUM, NPC_SPR_CANDY_0
	stz m_candy_frame
	_do_not_show
	rts	

candy_calc_movement
;	inc m_cualdron_speed
;	lda m_cualdron_speed
;	cmp #60
;	beq _move
;	rts 
_move
;	stz m_cualdron_speed
	;lda m_candy_pixel
	;cmp #0
	;beq _change_tile
	;dec m_candy_pixel
	;rts
_change_tile
	;lda #15
	;sta m_candy_pixel
	;dec m_candy_tile
	rts 

candy_collision
	jsr do_reset
	bcc _do_not_check
	jsr is_collided
	beq _do_not_check
	bra _do_check
_do_not_check
	rts 
_do_check
	jsr get_candy_xy
    ;lda m_candy_tile
    ;;jsr get_tile_pixel_x
    ;lda m_set_x
    ;sta m_pumpkin_x
    ;lda m_set_x + 1
    ;sta m_pumpkin_x + 1


	lda m_candy_x
	ldx m_candy_x + 1
	jsr collide_set_x1

	lda m_p1_x
	ldx m_p1_x + 1
	jsr collide_set_x2

	lda m_candy_x
	ldx m_candy_x + 1
	jsr collide_set_y1

	lda m_p1_y
	ldx m_p1_y + 1
	jsr collide_set_y2

    jsr check_collision
	jsr is_collided
	bcc _detect_collision
	rts 
_detect_collision
	#disable_sprite SPR_CTRL_02
    rts
	
.section variables
m_candy_speed
	.byte 0
m_candy_tile
    .byte 0
m_candy_pixel
    .byte 0
m_candy_v_sync
    .byte 0
m_candy_frame
    .byte 0
m_candy_x
    .byte 0,0
m_candy_y
    .byte 0,0
m_candy_collide
    .byte 0
.endsection