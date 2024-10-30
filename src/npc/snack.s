.section variables
SNACK_SPR_NUM_00 = 90
SNACK_FLOOR = 240 - 64
; NPC_SPR_CANDY_0 = NPC_SPR_CAULD_3 + (16 * 16)
; NPC_SPR_CANDY_1 = NPC_SPR_CANDY_0 + (16 * 16)
; NPC_SPR_CANDY_2 = NPC_SPR_CANDY_1 + (16 * 16)
; NPC_SPR_CANDY_3 = NPC_SPR_CANDY_2 + (16 * 16)
; NPC_SPR_CANDY_4 = NPC_SPR_CANDY_3 + (16 * 16)
; NPC_SPR_CANDY_5 = NPC_SPR_CANDY_4 + (16 * 16)
; NPC_SPR_CANDY_6 = NPC_SPR_CANDY_5 + (16 * 16)
NPC_SPR_CANDY_7 = NPC_SPR_CANDY_6 + (16 * 16)
NPC_SPR_CANDY_8 = NPC_SPR_CANDY_7 + (16 * 16)
NPC_SPR_CANDY_9 = NPC_SPR_CANDY_8 + (16 * 16)
NPC_SPR_CANDY_10 = NPC_SPR_CANDY_9 + (16 * 16)
NPC_SPR_CANDY_11= NPC_SPR_CANDY_10 + (16 * 16)
NPC_SPR_CANDY_12 = NPC_SPR_CANDY_11 + (16 * 16)
NPC_SPR_CANDY_13 = NPC_SPR_CANDY_12 + (16 * 16)
.endsection

.section code 

init_snack
	lda #<m_snack_table
	sta pointer 
	lda #>m_snack_table
	sta pointer + 1
	ldy #0
_loop
	;pick sprite number 
	lda (pointer)
	jsr set_sprite_number
	jsr increase_snack_pointer

	;get tile number for sprite
	;and calc x and y cordinats
	lda (pointer)
	jsr get_tile_pixel_x
	jsr set_sprite_enable16
	bcc _go 
	jsr set_sprite_disable
_go 
	lda #<SNACK_FLOOR
	ldx #>SNACK_FLOOR
	jsr set_sprite_y
	jsr set_sprite_xy

	lda #<SNACK_FLOOR
	sta m_snack_y
	lda #>SNACK_FLOOR 
	sta m_snack_y + 1

	lda m_set_x
	sta m_snack_x
	lda m_set_x + 1
	sta m_snack_x + 1
		
	;choose sprite to display
	;based where loaded in memory
	jsr increase_snack_pointer
	lda (pointer)
	pha 
	jsr increase_snack_pointer
	lda (pointer)
	tax 
	jsr increase_snack_pointer
	lda (pointer)
	tay
	pla
	jsr set_sprite_address
	jsr increase_snack_pointer
	lda #1
	sta (pointer)
	

	jsr increase_snack_pointer
	;check if all sprites are loaded
	lda pointer
	cmp #<m_end_snack_table
	bne _loop 

	lda pointer + 1
	cmp #>m_end_snack_table
	bne _loop 
rts 

handle_snack	 
	lda #<m_snack_table
	sta pointer 
	lda #>m_snack_table
	sta pointer + 1
	ldy #0
_loop
	;pick sprite number 
	lda (pointer)
	jsr set_sprite_number
	jsr increase_snack_pointer

	;get tile number for sprite
	;and calc x and y cordinats
	lda (pointer)
	jsr get_tile_pixel_x
	jsr set_sprite_enable16
	bcc _go 
	jsr set_sprite_disable
_go 
	lda #<SNACK_FLOOR
	ldx #>SNACK_FLOOR
	jsr set_sprite_y
	jsr set_sprite_xy

	lda #<SNACK_FLOOR
	sta m_snack_y
	lda #>SNACK_FLOOR 
	sta m_snack_y + 1

	lda m_set_x
	sta m_snack_x
	lda m_set_x + 1
	sta m_snack_x + 1
		
	;choose sprite to display
	;based where loaded in memory
	jsr increase_snack_pointer
	lda (pointer)
	pha 
	jsr increase_snack_pointer
	lda (pointer)
	tax 
	jsr increase_snack_pointer
	lda (pointer)
	tay
	pla
	jsr set_sprite_address
	jsr increase_snack_pointer
	lda (pointer)
	cmp  #0
	beq _turn_off_sprite
	bra _keep_on_sprite
_turn_off_sprite
	jsr set_sprite_disable
_keep_on_sprite
	jsr check_snack_collision
	
	jsr increase_snack_pointer
	;check if all sprites are loaded
	lda pointer
	cmp #<m_end_snack_table
	bne _loop 

	lda pointer + 1
	cmp #>m_end_snack_table
	bne _loop 
	rts 

check_snack_collision
	jsr create_snack_hitbox
	jsr create_player_hitbox
	jsr is_collision
	bcs _no_collission
	jsr set_sprite_disable
	lda #0
	sta (pointer)
	lda #1
	sta m_show_snack_collision
	jsr get_x_coord
	lda m_snack_collision_x
	ldx m_snack_collision_x + 1
	rts
_no_collission
	rts 


create_snack_hitbox
	;get hit box of snack
	lda m_snack_x
	clc 
	adc #16
	sta m_snack_x_end

	lda m_snack_x +1 
	adc #0
	sta m_snack_x_end + 1

	lda m_snack_y
	clc 
	adc #16
	sta m_snack_y_end

	lda m_snack_y +1
	adc #0
	sta m_snack_y_end + 1
	rts 

is_collision  
	jsr determine_collision_x_start
	jsr determine_collision_x_end 
	jsr determine_collision_y_start
	jsr determine_collision_y_end
	jsr check_hitbox_overlap
rts 

check_hitbox_overlap
	
	lda m_collide_x_start + 1
	cmp #0
	bne _end
	
	lda m_collide_x_end + 1
	cmp #0
	bne _end

	lda m_collide_y_end + 1
	cmp #0
	bne _end 

	lda m_collide_y_start + 1
	cmp #0
	bne _end
	jsr print_scroll
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
	lda m_collide_x_start 
	cmp #16
	bcc _x_collided
	lda m_collide_x_end 
	cmp #16
	bcc _x_collided
	sec  
	rts 
_x_collided
	clc
	rts 

is_y_in_range
	lda m_collide_y_start 
	cmp #16
	bcc _y_collided
	lda m_collide_y_end 
	cmp #16
	bcc _y_collided
	sec  
	rts 
_y_collided
	clc
	rts 

determine_collision_x_start
	lda m_snack_x 
	sec 
	sbc m_p1_x 
	sta m_collide_x_start

	lda m_snack_x + 1
	sbc m_p1_x + 1
	sta m_collide_x_start + 1
	lda m_collide_x_start + 1
	and #%10000000
	cmp #%10000000
	beq _is_neg
	rts
_is_neg 
	lda m_collide_x_start + 1
	eor #$ff
	sta m_collide_x_start + 1

	lda m_collide_x_start 
	eor #$ff 
	sta m_collide_x_start 
	rts 

determine_collision_x_end
	lda m_snack_x_end
	sec 
	sbc m_p1_x_end 
	sta m_collide_x_end

	lda m_snack_x_end + 1
	sbc m_p1_x_end + 1
	sta m_collide_x_end + 1
	and #%10000000
	cmp #%10000000
	beq _is_neg
	rts
_is_neg 
	lda m_collide_x_end + 1
	eor #$ff
	sta m_collide_x_end + 1

	lda m_collide_x_end 
	eor #$ff 
	sta m_collide_x_end
	rts 

determine_collision_y_start
	lda m_snack_y
	sec 
	sbc m_p1_y 
	sta m_collide_y_start

	lda m_snack_y + 1
	sbc m_p1_y + 1
	sta m_collide_y_start + 1
	lda m_collide_y_start + 1
	and #%10000000
	cmp #%10000000
	beq _is_neg
	rts
_is_neg 
	lda m_collide_y_start + 1
	eor #$ff
	sta m_collide_y_start + 1

	lda m_collide_y_start 
	eor #$ff 
	sta m_collide_y_start 
	lda m_collide_y_start
	clc 
	adc #1
	sta m_collide_y_start
	rts 

determine_collision_y_end
	lda m_snack_y_end
	sec 
	sbc m_p1_y_end
	sta m_collide_y_end

	lda m_snack_y + 1
	sbc m_p1_y_end + 1
	sta m_collide_y_end + 1
	lda m_collide_y_end + 1
	and #%10000000
	cmp #%10000000
	beq _is_neg
	rts
_is_neg 
	lda m_collide_y_end + 1
	eor #$ff
	sta m_collide_y_end + 1

	lda m_collide_y_end 
	eor #$ff 
	sta m_collide_y_end 
	lda m_collide_y_end
	clc 
	adc #1
	sta m_collide_y_end
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
m_snack_table
	.byte 30 ; sprite number
	.byte 10  ; tile number
	.byte <NPC_SPR_CANDY_6, >NPC_SPR_CANDY_6, `NPC_SPR_CANDY_6 ;sprite addr
	.byte 1 ; 0 disabled - 1 enabled

	.byte 31 ; sprite number
	.byte 12 ; tile number
	.byte <NPC_SPR_CANDY_5, >NPC_SPR_CANDY_5, `NPC_SPR_CANDY_5 ;sprite addr
	.byte 1 ; 0 disabled - 1 enabled

	;.byte 37 ; sprite number
	;.byte 15 ; tile number
	;.byte <NPC_SPR_CANDY_13, >NPC_SPR_CANDY_13, `NPC_SPR_CANDY_13 ;sprite addr
m_end_snack_table
m_snack_table_length = m_end_snack_table - m_snack_table


m_collide_x_start .byte 0,0
m_collide_x_end .byte 0,0
m_collide_y_start .byte 0,0
m_collide_y_end .byte 0,0

m_snack_x 
	.byte 0,0
m_snack_y
	.byte 0,0

m_snack_x_end
	.byte 0,0
m_snack_y_end
	.byte 0,0

m_show_snack_collision
	.byte 0
m_snack_collision_x
	.byte 0,0
m_snack_collision_y
	.byte 0,0

m_snack_loader
	.byte 0,0
.endsection