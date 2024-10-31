.section variables
CAULDRON_SPR_NUM = SPR_CTRL_02
CAULDRON_FLOOR = 240 - 16
NPC_SPR_CAULD_0 = SPR16_ADDR
NPC_SPR_CAULD_1 = NPC_SPR_CAULD_0 + (16 * 16)
NPC_SPR_CAULD_2 = NPC_SPR_CAULD_1 + (16 * 16)
NPC_SPR_CAULD_3 = NPC_SPR_CAULD_2 + (16 * 16)

.endsection

.section code 
init_cauldron
	lda #0
	sta m_cauldron_v_sync
	sta m_cauldron_frame
	sta m_cauldron_x
	sta m_cauldron_y
	sta m_cauldron_collide
	sta m_has_displayed

	lda #40
	sta m_cauldron_tile
	lda #16
	sta m_cauldron_pixel
	#set_npc CAULDRON_SPR_NUM
	rts 
.endsection

handle_cauldron
	lda m_cauldron_tile
	;;jsr get_tile_pixel_x
	bcc _move
	#disable_sprite CAULDRON_SPR_NUM
	
	rts 
_move
	#set_npc CAULDRON_SPR_NUM
	jsr cauldron_calc_movement
	jsr show_cauldron_frames
	;lda m_has_displayed
	;cmp #0
	;beq _init_sprite
	;bra _animate
_init_sprite
	;jsr init_cauldron_sprite
	;lda #1
	;sta m_has_displayed
_animate
	inc m_cauldron_v_sync
	lda m_cauldron_v_sync
	cmp #15
	beq _advance_frame 
	rts 
_advance_frame
	inc m_cauldron_frame
	stz m_cauldron_v_sync
	rts

show_cauldron_frames	
	jsr get_cauldron_xy
	jsr caudron_fr0
	jsr caudron_fr1
	jsr caudron_fr2
	jsr caudron_fr3	
	rts

get_cauldron_xy
	lda m_cauldron_tile
	jsr get_x_coord
	lda m_set_x
	clc  
	adc m_cauldron_pixel
	sta m_set_x 
	sta m_cauldron_x
	lda m_set_x + 1
	adc #0
	sta m_set_x + 1
	sta m_cauldron_x + 1
	
	lda #<CAULDRON_FLOOR
	sta m_set_y
	sta m_cauldron_y
	lda #>CAULDRON_FLOOR
	sta m_set_y + 1
	sta m_cauldron_y + 1
	#set_sprite_xy CAULDRON_SPR_NUM
	rts 

caudron_fr0
	lda m_cauldron_frame
	cmp #0
	bne _do_not_show
	#set_sprite_addr CAULDRON_SPR_NUM, NPC_SPR_CAULD_0
_do_not_show
	rts	

caudron_fr1
	lda m_cauldron_frame
	cmp #1
	bne _do_not_show
	#set_sprite_addr CAULDRON_SPR_NUM, NPC_SPR_CAULD_1
_do_not_show
	rts	

caudron_fr2
	lda m_cauldron_frame
	cmp #2
	bne _do_not_show
	#set_sprite_addr CAULDRON_SPR_NUM, NPC_SPR_CAULD_2
_do_not_show
	rts	

caudron_fr3
	lda m_cauldron_frame
	cmp #3
	bne _do_not_show
	#set_sprite_addr CAULDRON_SPR_NUM, NPC_SPR_CAULD_3
	stz m_cauldron_frame
	_do_not_show
	rts	

cauldron_calc_movement
;	inc m_cualdron_speed
;	lda m_cualdron_speed
;	cmp #60
;	beq _move
;	rts 
_move
;	stz m_cualdron_speed
	lda m_cauldron_pixel
	cmp #0
	beq _change_tile
	dec m_cauldron_pixel
	rts
_change_tile
	lda #15
	sta m_cauldron_pixel
	dec m_cauldron_tile
	rts 

cauldron_collision
	jsr do_reset
	bcc _do_not_check
	jsr is_collided
	beq _do_not_check
	bra _do_check
_do_not_check
	rts 
_do_check
	jsr get_cauldron_xy
    ;lda m_cauldron_tile
    ;;;jsr get_tile_pixel_x
    ;lda m_set_x
    ;sta m_pumpkin_x
    ;lda m_set_x + 1
    ;sta m_pumpkin_x + 1


	lda m_cauldron_x
	ldx m_cauldron_x + 1
	jsr collide_set_x1

	lda m_p1_x
	ldx m_p1_x + 1
	jsr collide_set_x2

	lda m_cauldron_x
	ldx m_cauldron_x + 1
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
m_cualdron_speed
	.byte 0
m_cauldron_tile
    .byte 0
m_cauldron_pixel
    .byte 0
m_cauldron_v_sync
    .byte 0
m_cauldron_frame
    .byte 0
m_cauldron_x
    .byte 0,0
m_cauldron_y
    .byte 0,0
m_cauldron_collide
    .byte 0
m_has_displayed
	.byte 0
.endsection