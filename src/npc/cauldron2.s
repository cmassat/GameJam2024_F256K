.section variables
CAULDRON2_SPR_NUM = SPR_CTRL_06

.endsection

.section code 
init_cauldron2
	lda #0
	sta m_cauldron2_v_sync
	sta m_cauldron2_frame
	sta m_cauldron2_x
	sta m_cauldron2_y
	sta m_cauldron2_collide
	sta m_has_displayed

	lda #60
	sta m_cauldron2_tile
	lda #16
	sta m_cauldron2_pixel
	#set_npc CAULDRON2_SPR_NUM
	
	rts 
.endsection

handle_cauldron2
	lda m_cauldron2_tile
	;jsr get_tile_pixel_x
	bcc _move
	#disable_sprite CAULDRON2_SPR_NUM
	rts 
_move
	#set_npc CAULDRON2_SPR_NUM
	jsr cauldron2_calc_movement
	jsr show_cauldron2_frames
	;lda m_has_displayed
	;cmp #0
	;beq _init_sprite
	;bra _animate
_init_sprite
	;jsr init_cauldron2_sprite
	;lda #1
	;sta m_has_displayed
_animate
	inc m_cauldron2_v_sync
	lda m_cauldron2_v_sync
	cmp #15
	beq _advance_frame 
	rts 
_advance_frame
	inc m_cauldron2_frame
	stz m_cauldron2_v_sync
	rts

show_cauldron2_frames	
	jsr get_cauldron2_xy
	jsr cualdron2_fr0
	jsr cualdron2_fr1
	jsr cualdron2_fr2
	jsr cualdron2_fr3	
	rts

get_cauldron2_xy
	lda m_cauldron2_tile
	jsr get_x_coord
	lda m_set_x
	clc  
	adc m_cauldron2_pixel
	sta m_set_x 
	sta m_cauldron2_x
	lda m_set_x + 1
	adc #0
	sta m_set_x + 1
	sta m_cauldron2_x + 1
	
	lda #<CAULDRON_FLOOR
	sta m_set_y
	sta m_cauldron2_y
	lda #>CAULDRON_FLOOR
	sta m_set_y + 1
	sta m_cauldron2_y + 1
	#set_sprite_xy CAULDRON2_SPR_NUM
	rts 

cualdron2_fr0
	lda m_cauldron2_frame
	cmp #0
	bne _do_not_show
	#set_sprite_addr CAULDRON2_SPR_NUM, NPC_SPR_CAULD_0
_do_not_show
	rts	

cualdron2_fr1
	lda m_cauldron2_frame
	cmp #1
	bne _do_not_show
	#set_sprite_addr CAULDRON2_SPR_NUM, NPC_SPR_CAULD_1
_do_not_show
	rts	

cualdron2_fr2
	lda m_cauldron2_frame
	cmp #2
	bne _do_not_show
	#set_sprite_addr CAULDRON2_SPR_NUM, NPC_SPR_CAULD_2
_do_not_show
	rts	

cualdron2_fr3
	lda m_cauldron2_frame
	cmp #3
	bne _do_not_show
	#set_sprite_addr CAULDRON2_SPR_NUM, NPC_SPR_CAULD_3
	stz m_cauldron2_frame
	_do_not_show
	rts	

cauldron2_calc_movement
;	inc m_cualdron2_speed
;	lda m_cualdron2_speed
;	cmp #60
;	beq _move
;	rts 
_move
;	stz m_cualdron2_speed
	lda m_cauldron2_pixel
	cmp #0
	beq _change_tile
	dec m_cauldron2_pixel
	rts
_change_tile
	lda #15
	sta m_cauldron2_pixel
	dec m_cauldron2_tile
	rts 

cauldron2_collision
	jsr do_reset
	bcc _do_not_check
	jsr is_collided
	beq _do_not_check
	bra _do_check
_do_not_check
	rts 
_do_check
	jsr get_cauldron2_xy
    ;lda m_cauldron2_tile
    ;;jsr get_tile_pixel_x
    ;lda m_set_x
    ;sta m_pumpkin_x
    ;lda m_set_x + 1
    ;sta m_pumpkin_x + 1


	lda m_cauldron2_x
	ldx m_cauldron2_x + 1
	jsr collide_set_x1

	lda m_p1_x
	ldx m_p1_x + 1
	jsr collide_set_x2

	lda m_cauldron2_x
	ldx m_cauldron2_x + 1
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
m_cualdron2_speed
	.byte 0
m_cauldron2_tile
    .byte 0
m_cauldron2_pixel
    .byte 0
m_cauldron2_v_sync
    .byte 0
m_cauldron2_frame
    .byte 0
m_cauldron2_x
    .byte 0,0
m_cauldron2_y
    .byte 0,0
m_cauldron2_collide
    .byte 0
.endsection