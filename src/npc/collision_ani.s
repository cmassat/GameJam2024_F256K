.section variables
	SPR_SNACK_FEEDBACK0 = SPR16_ADDR + (16 * 16 * 60)
	SPR_SNACK_FEEDBACK1 = SPR_SNACK_FEEDBACK0 + (16 * 16)
	SPR_SNACK_FEEDBACK2 = SPR_SNACK_FEEDBACK1 + (16 * 16)
	SPR_SNACK_FEEDBACK3 = SPR_SNACK_FEEDBACK2 + (16 * 16)
	SPR_NUM = 60
.endsection

.section code 
handle_gem_collision_animation
	lda m_show_gem_collision
	cmp #1
	beq _animate 
rts
_animate
	lda m_init_fb_ani
	cmp #1
	beq _animate_frames
	lda #SPR_NUM
	jsr set_sprite_number
	jsr set_sprite_enable16

	lda #<SPR_SNACK_FEEDBACK0
	ldx #>SPR_SNACK_FEEDBACK0
	ldy #`SPR_SNACK_FEEDBACK0
	jsr set_sprite_address
	inc m_init_fb_ani
_animate_frames
	jsr fb_set_tile_x_y
	#set_sprite_xy SPR_NUM
	inc m_ani_fb_vsync
	lda m_ani_fb_vsync
	cmp #8
	beq _next_frame 
	rts 
_next_frame
	stz m_ani_fb_vsync
	inc m_ani_fb_frames
	lda m_ani_fb_frames
	cmp #5
	beq _finished 
	lda #SPR_NUM
	jsr set_sprite_number
	jsr set_sprite_enable16
	jsr fb_ani_fr0
	jsr fb_ani_fr1
	jsr fb_ani_fr2
	jsr fb_ani_fr3
	rts
_finished
	stz m_ani_fb_frames
	stz m_ani_fb_vsync
	stz m_show_gem_collision
	lda #SPR_NUM
	jsr set_sprite_number
	jsr set_sprite_disable
	rts 
fb_ani_fr0
	lda m_ani_fb_frames
	cmp #1
	bne _end
	lda #SPR_NUM
	jsr set_sprite_number
	lda #<SPR_SNACK_FEEDBACK0
	ldx #>SPR_SNACK_FEEDBACK0
	ldy #`SPR_SNACK_FEEDBACK0
	jsr set_sprite_address
	rts 
_end 
	rts 

fb_set_tile_x_y
	lda m_tile_gem_collision
	;jsr get_tile_pixel_x
	lda #<GEM_CEILING
	sta m_set_y 
	lda #>GEM_CEILING
	sta m_set_y + 1
	rts 

fb_ani_fr1
	lda m_ani_fb_frames
	cmp #2
	bne _end
	lda #SPR_NUM
	jsr set_sprite_number
	lda #<SPR_SNACK_FEEDBACK1
	ldx #>SPR_SNACK_FEEDBACK1
	ldy #`SPR_SNACK_FEEDBACK1
	jsr set_sprite_address
	rts 
_end 
	rts 

fb_ani_fr2
	lda m_ani_fb_frames
	cmp #3
	bne _end 
	lda #SPR_NUM
	jsr set_sprite_number
	lda #<SPR_SNACK_FEEDBACK2
	ldx #>SPR_SNACK_FEEDBACK2
	ldy #`SPR_SNACK_FEEDBACK2
	jsr set_sprite_address
	rts 
_end 
	rts 

fb_ani_fr3
	lda m_ani_fb_frames
	cmp #4
	bne _end 
	lda #SPR_NUM
	jsr set_sprite_number
	lda #<SPR_SNACK_FEEDBACK3
	ldx #>SPR_SNACK_FEEDBACK3
	ldy #`SPR_SNACK_FEEDBACK3
	jsr set_sprite_address
	rts 
_end 
	rts 
.endsection

.section variables
	m_init_fb_ani .byte 0
	m_ani_fb_vsync .byte 0
	m_ani_fb_frames .byte 0
.endsection