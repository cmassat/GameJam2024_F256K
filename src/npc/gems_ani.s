.section variables
	SPR_SNACK_FEEDBACK0 = SPR16_ADDR + (16 * 16 * 60)
	SPR_SNACK_FEEDBACK1 = SPR_SNACK_FEEDBACK0 + (16 * 16)
	SPR_SNACK_FEEDBACK2 = SPR_SNACK_FEEDBACK1 + (16 * 16)
	SPR_SNACK_FEEDBACK3 = SPR_SNACK_FEEDBACK2 + (16 * 16)
	GEMFB_00_SPR_CTRL  = SPR_00_CTRL + (60 * 8)
.endsection

.section code
gem_fb_init
    #set_npc GEMFB_00_SPR_CTRL
    #set_sprite_addr GEMFB_00_SPR_CTRL, SPR_SNACK_FEEDBACK0
    rts

sub_gemfb_set_xy
	stz m_ani_fb_vsync
	lda m_tile_gem_collision
	jsr get_tile_x_for_gem
	jsr sprite_set_x
	lda #<GEM_CEILING
	ldx #>GEM_CEILING
	jsr sprite_set_y
	#set_sprite_xy GEMFB_00_SPR_CTRL
rts

handle_gem_collision_animation
	lda m_show_gem_collision
	cmp #1
	beq _animate
rts
_animate
	;jsr sub_gemfb_set_xy
	lda m_init_fb_ani
	cmp #1
	beq _animate_frames
	jsr gem_fb_init
	jsr sub_gemfb_set_xy
    lda #1
	sta m_init_fb_ani
	rts
_animate_frames
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
	#set_npc GEMFB_00_SPR_CTRL
	jsr fb_ani_fr0
	jsr fb_ani_fr1
	jsr fb_ani_fr2
	jsr fb_ani_fr3
	rts
_finished
	stz m_ani_fb_frames
	stz m_ani_fb_vsync
	stz m_show_gem_collision
	stz m_init_fb_ani
	#disable_sprite GEMFB_00_SPR_CTRL

	rts
fb_ani_fr0
	lda m_ani_fb_frames
	cmp #1
	bne _end
	#set_sprite_addr GEMFB_00_SPR_CTRL, SPR_SNACK_FEEDBACK0
	rts
_end
	rts

fb_ani_fr1
	lda m_ani_fb_frames
	cmp #2
	bne _end
	#set_sprite_addr GEMFB_00_SPR_CTRL, SPR_SNACK_FEEDBACK1
	rts
_end
	rts

fb_ani_fr2
	lda m_ani_fb_frames
	cmp #3
	bne _end
	#set_sprite_addr GEMFB_00_SPR_CTRL, SPR_SNACK_FEEDBACK2
	rts
_end
	rts

fb_ani_fr3
	lda m_ani_fb_frames
	cmp #4
	bne _end
	#set_sprite_addr GEMFB_00_SPR_CTRL, SPR_SNACK_FEEDBACK3
	rts
_end
	rts
.endsection

.section variables
	m_init_fb_ani .byte 0
	m_ani_fb_vsync .byte 0
	m_ani_fb_frames .byte 0
	d_debug_gemfb
		.byte 0
.endsection
