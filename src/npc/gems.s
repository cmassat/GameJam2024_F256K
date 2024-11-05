.section variables
GEM_CEILING = 240 - 64 ;$B0
GEM_START = 4

GEM_00_SPR_CTRL  = SPR_00_CTRL + (20 * 8)
GEM_00_SPR_ADDR = SPR16_ADDR + (16 * 16 * GEM_START)
GEM_00_TILE_NUM = 10

GEM_01_SPR_CTRL = SPR_00_CTRL + (21 * 8)
GEM_01_SPR_ADDR = SPR16_ADDR + (16 * 16 * 5)
GEM_01_TILE_NUM = 25

GEM_02_SPR_CTRL = SPR_00_CTRL + (22 * 8)
GEM_02_SPR_ADDR = SPR16_ADDR + (16 * 16 * 6)
GEM_02_TILE_NUM = 30

GEM_03_SPR_CTRL = SPR_00_CTRL + (23 * 8)
GEM_03_SPR_ADDR = SPR16_ADDR + (16 * 16 * 7)
GEM_03_TILE_NUM = 35

GEM_04_SPR_CTRL = SPR_00_CTRL + (24 * 8)
GEM_04_SPR_ADDR = SPR16_ADDR + (16 * 16 * 8)
GEM_04_TILE_NUM = 40

GEM_05_SPR_CTRL = SPR_00_CTRL + (25 * 8)
GEM_05_SPR_ADDR = SPR16_ADDR + (16 * 16 * 9)
GEM_05_TILE_NUM = 45

GEM_06_SPR_CTRL = SPR_00_CTRL + (26 * 8)
GEM_06_SPR_ADDR = SPR16_ADDR + (16 * 16 * 10)
GEM_06_TILE_NUM = 50

GEM_07_SPR_CTRL = SPR_00_CTRL + (27 * 8)
GEM_07_SPR_ADDR = SPR16_ADDR + (16 * 16 * 11)
GEM_07_TILE_NUM = 55
.endsection

.section code
mac_set_y .macro
	lda #<GEM_CEILING
	sta m_set_y
	lda #>GEM_CEILING
	sta m_set_y + 1
.endmacro

;a tile_number
set_gem_coordinates 
	jsr get_tile_x_for_gem
	jsr sprite_set_x
	lda #<GEM_CEILING
	ldx #>GEM_CEILING
	jsr sprite_set_y
rts 

mac_gem_handle .macro SPRITE_CTRL, TILE_NUM, SPRITE_NUM
	ldy #\SPRITE_NUM
    lda m_gem_enabled, y
	cmp #0
	bne _do_not_show
	#set_npc \SPRITE_CTRL
	
	lda #\TILE_NUM
	jsr get_tile_x_for_gem
	bcs _do_not_show
	jsr sprite_set_x
	lda #<GEM_CEILING
	ldx #>GEM_CEILING
	jsr sprite_set_y
	#set_sprite_xy \SPRITE_CTRL
	bra _check_collision
_do_not_show
	#disable_sprite \SPRITE_CTRL
	rts
_check_collision
	lda #\TILE_NUM
	jsr get_tile_x_for_gem
	jsr sprite_set_x
	lda #<GEM_CEILING
	ldx #>GEM_CEILING
	jsr sprite_set_y
	jsr is_collision_a
	bcc _gem_collided
	rts
_gem_collided
	lda #1
	sta m_show_gem_collision
	lda #1
	ldy #\SPRITE_NUM
	sta m_gem_enabled, y
	lda #\TILE_NUM
	sta m_tile_gem_collision
	lda #$99
	jsr add2score
	lda #$01
	jsr add2score
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

init_gem_3
	#mac_npc_init GEM_03_SPR_CTRL, GEM_03_SPR_ADDR
	rts

init_gem_4
	#mac_npc_init GEM_04_SPR_CTRL, GEM_04_SPR_ADDR
	rts

init_gem_5
	#mac_npc_init GEM_05_SPR_CTRL, GEM_05_SPR_ADDR
	rts

init_gem_6
	#mac_npc_init GEM_06_SPR_CTRL, GEM_06_SPR_ADDR
	rts

init_gem_7
	#mac_npc_init GEM_07_SPR_CTRL, GEM_07_SPR_ADDR
	rts

init_gems
	jsr init_gem_0
	jsr init_gem_1
	jsr init_gem_2
	jsr init_gem_3
	jsr init_gem_4
	jsr init_gem_5
	jsr init_gem_6
	jsr init_gem_7
	rts

handle_gem_0
	#mac_gem_handle GEM_00_SPR_CTRL, GEM_00_TILE_NUM, 0
	rts

handle_gem_1
	#mac_gem_handle GEM_01_SPR_CTRL, GEM_01_TILE_NUM, 1
	rts

handle_gem_2
	#mac_gem_handle GEM_02_SPR_CTRL, GEM_02_TILE_NUM, 2
	rts

handle_gem_3
	#mac_gem_handle GEM_03_SPR_CTRL, GEM_03_TILE_NUM, 3
	rts

handle_gem_4
	#mac_gem_handle GEM_04_SPR_CTRL, GEM_04_TILE_NUM, 4
	rts

handle_gem_5
	#mac_gem_handle GEM_05_SPR_CTRL, GEM_05_TILE_NUM, 5
	rts

handle_gem_6
	#mac_gem_handle GEM_06_SPR_CTRL, GEM_06_TILE_NUM, 6
	rts

handle_gem_7		
	#mac_gem_handle GEM_07_SPR_CTRL, GEM_07_TILE_NUM, 7
	rts

handle_gems
	jsr handle_gem_collision_animation
	jsr handle_gem_0
	jsr handle_gem_1
	jsr handle_gem_2
	jsr handle_gem_3
	jsr handle_gem_4
	jsr handle_gem_5
	jsr handle_gem_6
	jsr handle_gem_7
	rts
.endsection

.section variables
	m_show_gem_collision
		.byte 0
	m_tile_gem_collision
		.byte 0
	m_gem_enabled
		.byte 0,0,0,0,0,0,0,0,0,0,0,0
	d_do_not_show
		.byte 0
.endsection
