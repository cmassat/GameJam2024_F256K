.section variables
GEM_CEILING = 240 - 64 ;$B0
GEM_START = 4

GEM_00_SPR_CTRL  = SPR_00_CTRL + (30 * 8)
GEM_00_SPR_ADDR = SPR16_ADDR + (16 * 16 * GEM_START)
GEM_00_TILE_NUM = 10

GEM_01_SPR_CTRL =  SPR_00_CTRL + (31 * 8)
GEM_01_SPR_ADDR = SPR16_ADDR + (16 * 16 * (GEM_START + 1))
GEM_01_TILE_NUM = 25

.endsection

.section code
mac_set_y .macro 
	lda #<GEM_CEILING
	sta m_set_y
	lda #>GEM_CEILING
	sta m_set_y + 1
.endmacro

mac_gem_init .macro SPRITE_CTRL, SPRITE_ADDR
	#set_npc \SPRITE_CTRL
	#set_sprite_addr \SPRITE_CTRL, \SPRITE_ADDR
.endmacro

mac_gem_handle .macro SPRITE_CTRL, TILE_NUM, SPRITE_NUM
	lda #\TILE_NUM
	jsr get_tile_x_for_gem
	sta m_gem_start_x
	stx m_gem_start_x + 1
	bcs _do_not_show
	
	lda m_gem_enabled, y
	cmp #0
	bne _do_not_show
	#set_npc \SPRITE_CTRL
	lda m_gem_start_x
	sta m_set_x
	lda m_gem_start_x + 1
	sta m_set_x + 1
	lda #<GEM_CEILING
	sta m_set_y
	lda #>GEM_CEILING
	sta m_set_y + 1
	#set_sprite_xy \SPRITE_CTRL
	bra _check_collision
_do_not_show
	#disable_sprite \SPRITE_CTRL
	inc d_do_not_show
	bra _skip
_check_collision
	
	stz d_do_not_show
	jsr is_collision
	bcc _gem_collided
	
	bra _skip
_gem_collided
	lda #1
	sta m_show_gem_collision
	lda #1
	ldy #\SPRITE_NUM
	sta m_gem_enabled, y
	lda #\TILE_NUM
	sta m_tile_gem_collision
	
_skip

.endmacro


init_gem_0
	#mac_gem_init GEM_00_SPR_CTRL, GEM_00_SPR_ADDR
	rts
init_gem_1
	#mac_gem_init GEM_01_SPR_CTRL, GEM_01_SPR_ADDR
	rts

init_gems
	ldx #0
_loop 
	lda #0
	sta m_gem_enabled,x
	inx 
	cpx #10
	bne _loop
	jsr init_gem_0
	jsr init_gem_1
	rts 

handle_gem_0
	#mac_gem_handle GEM_00_SPR_CTRL, GEM_00_TILE_NUM, 0
	rts
handle_gem_1
	#mac_gem_handle GEM_01_SPR_CTRL, GEM_01_TILE_NUM, 1
	rts 
	
handle_gems
	;jsr handle_gem_collision_animation
	jsr handle_gem_0
	jsr handle_gem_1
	jsr print_scroll
	rts

create_gem_hitbox
	;get hit box of snack
	;lda m_set_x
	lda m_gem_start_x
	clc
	adc #15
	sta m_gem_end_x

	;lda m_set_x + 1
	lda m_gem_start_x + 1
	adc #0
	sta m_gem_end_x + 1

	lda #<GEM_CEILING
	sta m_gem_start_y
	clc
	adc #15
	sta m_gem_end_y

	lda #>GEM_CEILING
	sta m_gem_start_y + 1
	adc #0
	sta m_gem_end_y + 1
	rts

is_collision
	jsr create_gem_hitbox
	jsr create_player_hitbox
	jsr determine_collision_x_start
	jsr determine_collision_x_end
	jsr determine_collision_y_start
	jsr determine_collision_y_end
	jsr check_hitbox_overlap
rts

check_hitbox_overlap
	
	lda m_gem_collide_start_x + 1
	cmp #0
	bne _end

	lda m_gem_collide_end_x + 1
	cmp #0
	bne _end

	lda m_gem_collide_end_y + 1
	cmp #0
	bne _end

	lda m_gem_start_y + 1
	cmp #0
	bne _end

	jsr is_x_in_range
	bcs _end
	jsr is_y_in_range
	bcs _end
	clc
	rts
_end
 	sec
	rts

is_x_in_range
	
	lda m_gem_collide_start_x
	cmp #15
	bcc _x_collided
	lda m_gem_collide_end_x
	cmp #15
	bcc _x_collided
	sec
	rts
_x_collided
	
	clc
	rts

is_y_in_range
	
	lda m_gem_collide_start_y
	cmp #15
	bcc _y_collided
	lda m_gem_collide_end_y
	cmp #15
	bcc _y_collided
	
	sec
	rts
_y_collided
	
	clc
	rts

m_gem_n
	.byte 0,0
m_result_n
	.byte 0,0

m_p1_n
	.byte 0,0


fn_collision
	lda m_gem_n
	sec
	sbc m_p1_n
	sta m_result_n

	lda m_gem_n + 1
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

determine_collision_x_start
	lda m_gem_start_x 
	sta m_gem_n
	lda m_gem_start_x + 1 
	sta m_gem_n + 1
	lda m_p1_x 
	sta m_p1_n
	jsr fn_collision
	sta m_gem_collide_start_x
	stx m_gem_collide_start_x + 1
;	lda m_gem_start_x
;	sec
;	sbc m_p1_x
;	sta m_gem_collide_start_x
;
;	lda m_gem_start_x + 1
;	sbc m_p1_x + 1
;	sta m_gem_collide_start_x + 1
;	lda m_gem_collide_start_x + 1
;	and #%10000000
;	cmp #%10000000
;	beq _is_neg
;	rts
;_is_neg
;	lda m_gem_collide_start_x + 1
;	eor #$ff
;	sta m_gem_collide_start_x + 1
;
;	lda m_gem_collide_start_x
;	eor #$ff
;	sta m_gem_collide_start_x
;	clc 
;	lda m_gem_collide_start_x
;	adc #1
;	sta m_gem_collide_start_x
;	rts
;
determine_collision_x_end
	lda m_gem_end_x 
	sta m_gem_n
	lda m_gem_end_x + 1 
	sta m_gem_n + 1
	lda m_p1_x_end 
	sta m_p1_n
	jsr fn_collision
	sta m_gem_collide_end_x
	stx m_gem_collide_end_x + 1
;	lda m_gem_end_x
;	sec 
;	sbc m_p1_x_end 
;	sta m_gem_collide_end_x
;
;	lda m_gem_end_x + 1
;	sbc m_p1_x_end + 1
;	sta m_gem_collide_end_x + 1
;	and #%10000000
;	cmp #%10000000
;	beq _is_neg
;	rts
;_is_neg
;	lda m_gem_collide_end_x + 1
;	eor #$ff
;	sta m_gem_collide_end_x + 1
;
;	lda m_gem_collide_end_x
;	eor #$ff
;	sta m_gem_collide_end_x
	rts

determine_collision_y_start
	lda m_gem_start_y
	sta m_gem_n
	lda m_gem_start_y + 1 
	sta m_gem_n + 1
	lda m_p1_y
	sta m_p1_n
	jsr fn_collision
	sta m_gem_collide_start_y
	stx m_gem_collide_start_y + 1
;	lda m_gem_start_y
;	sec
;	sbc m_p1_y
;	sta m_gem_collide_start_y
;
;	lda m_gem_start_y + 1
;	sbc m_p1_y + 1
;	sta m_gem_collide_start_y + 1
;	lda m_gem_collide_start_y + 1
;	and #%10000000
;	cmp #%10000000
;	beq _is_neg
;	rts
;_is_neg
;	lda m_gem_collide_start_y + 1
;	eor #$ff
;	sta m_gem_collide_start_y + 1
;
;	lda m_gem_collide_start_y
;	eor #$ff
;	sta m_gem_collide_start_y
;
;	lda m_gem_collide_start_y
;	clc
;	adc #1
;	sta m_gem_collide_start_y
	rts

determine_collision_y_end
	lda m_gem_end_y
	sta m_gem_n
	lda m_gem_end_y + 1 
	sta m_gem_n + 1
	lda m_p1_y_end
	sta m_p1_n
	jsr fn_collision
	sta m_gem_collide_end_y
	stx m_gem_collide_end_y + 1
;	sbc m_p1_y_end + 1
;	sta m_gem_collide_start_y + 1
;	lda m_gem_collide_start_y + 1
;	and #%10000000
;	cmp #%10000000
;	beq _is_neg
;	lda m_gem_collide_start_y
;	clc
;	adc #1
;	sta m_gem_collide_start_y
;	rts
;_is_neg
;	lda m_gem_collide_start_y + 1
;	eor #$ff
;	sta m_gem_collide_start_y + 1
;
;	lda m_gem_collide_start_y
;	eor #$ff
;	sta m_gem_collide_start_y
;	lda m_gem_collide_start_y
;	clc
;	adc #1
;	sta m_gem_collide_start_y
	rts

increase_snack_pointer
	lda pointer
	clc
	adc #1
	sta pointer

	lda pointer + 1
	adc #0
	sta pointer + 1
	rts
.endsection

.section variables
	m_show_gem_collision
		.byte 0
	m_tile_gem_collision
		.byte 0
	m_gem_enabled
		.byte 0,0,0,0,0,0,0,0,0,0
	m_gem_start_x  
		.byte 0,0
	m_gem_end_x
		.byte 0,0
	m_gem_start_y
		.byte 0,0
	m_gem_end_y
		.byte 0,0
	m_gem_collide_start_x
		.byte 0,0
	m_gem_collide_end_x 
		.byte 0,0
	m_gem_collide_start_y
		.byte 0,0
	m_gem_collide_end_y
		.byte 0,0
	d_do_not_show
		.byte 0
.endsection