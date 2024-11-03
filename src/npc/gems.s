.section variables
GEM_CEILING = 240 - 64 ;$B0
GEM_START = 4

GEM_00_SPR_CTRL  = SPR_00_CTRL + (30 * 8)
GEM_00_SPR_ADDR = SPR16_ADDR + (16 * 16 * GEM_START)
GEM_00_TILE_NUM = 10

GEM_01_SPR_CTRL =  SPR_00_CTRL + (31 * 8)
GEM_01_SPR_ADDR = SPR16_ADDR + (16 * 16 * 5)
GEM_01_TILE_NUM = 25

GEM_02_SPR_CTRL =  SPR_00_CTRL + (32 * 8)
GEM_02_SPR_ADDR = SPR16_ADDR + (16 * 16 * 6)
GEM_02_TILE_NUM = 15

.endsection

.section code
mac_set_y .macro
	lda #<GEM_CEILING
	sta m_set_y
	lda #>GEM_CEILING
	sta m_set_y + 1
.endmacro

mac_gem_handle .macro SPRITE_CTRL, TILE_NUM, SPRITE_NUM
	ldy #\SPRITE_NUM
    lda m_gem_enabled, y
	cmp #0
	bne _do_not_show
	#set_npc \SPRITE_CTRL
	lda #\TILE_NUM
	jsr get_tile_x_for_gem
	jsr sprite_set_x
	bcs _do_not_show
	lda #<GEM_CEILING
	ldx #>GEM_CEILING
	jsr sprite_set_y
	#set_sprite_xy \SPRITE_CTRL
	bra _check_collision
_do_not_show
	#disable_sprite \SPRITE_CTRL
	inc d_do_not_show
	bra _skip
_check_collision

	stz d_do_not_show
	jsr is_collision_a
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
	#mac_npc_init GEM_00_SPR_CTRL, GEM_00_SPR_ADDR
	rts
init_gem_1
	#mac_npc_init GEM_01_SPR_CTRL, GEM_01_SPR_ADDR
	rts

init_gem_2
	#mac_npc_init GEM_02_SPR_CTRL, GEM_02_SPR_ADDR
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
	jsr init_gem_2
	rts

handle_gem_0
	#mac_gem_handle GEM_00_SPR_CTRL, GEM_00_TILE_NUM, 0
	rts
handle_gem_1
	#mac_gem_handle GEM_01_SPR_CTRL, GEM_01_TILE_NUM, 1
	jsr sprite_get_x
	sta m_gem_debug
	stx m_gem_debug + 1
	rts
handle_gem_2
	#mac_gem_handle GEM_02_SPR_CTRL, GEM_02_TILE_NUM, 2
	rts
handle_gems
	jsr handle_gem_collision_animation
	jsr handle_gem_0
	jsr handle_gem_1
	jsr handle_gem_2
	rts
.endsection

.section variables
	m_show_gem_collision
		.byte 0
	m_tile_gem_collision
		.byte 0
	m_gem_enabled
		.byte 0,0,0,0,0,0,0,0,0,0
	d_do_not_show
		.byte 0
	m_gem_debug .byte 0,0
.endsection
