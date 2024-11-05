.section variables
NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)		
NUMBER_OF_PUMPS = 5
PUMPKIN_NO_FRAMES = 5
PUMPKIN_Y_MIN =  240-16; 224
PUMPKIN_Y_MAX =  240-32; 208
PUMKIN_DISTANCE = PUMPKIN_Y_MIN - PUMPKIN_Y_MAX ;16
PUMKIN_PXLS_PER_FRAME = (PUMKIN_DISTANCE / PUMPKIN_NO_FRAMES); + .05

PUMP_00_SPR_CTRL  = SPR_00_CTRL + (10 * 8)
PUMP_00_SPR_ADDR = NPC_SPR_PMK_0
PUMP_00_TILE_NUM = 23

PUMP_01_SPR_CTRL  = SPR_00_CTRL + (11 * 8)
PUMP_01_SPR_ADDR = NPC_SPR_PMK_0
PUMP_01_TILE_NUM = 25

PUMP_02_SPR_CTRL  = SPR_00_CTRL + (12 * 8)
PUMP_02_SPR_ADDR = NPC_SPR_PMK_0
PUMP_02_TILE_NUM = 28

PUMP_03_SPR_CTRL  = SPR_00_CTRL + (13 * 8)
PUMP_03_SPR_ADDR = NPC_SPR_PMK_0
PUMP_03_TILE_NUM = 35

PUMP_04_SPR_CTRL  = SPR_00_CTRL + (14 * 8)
PUMP_04_SPR_ADDR = NPC_SPR_PMK_0
PUMP_04_TILE_NUM = 45

PUMP_05_SPR_CTRL  = SPR_00_CTRL + (15 * 8)
PUMP_05_SPR_ADDR = NPC_SPR_PMK_0
PUMP_05_TILE_NUM = 55

PUMP_06_SPR_CTRL  = SPR_00_CTRL + (16 * 8)
PUMP_06_SPR_ADDR = NPC_SPR_PMK_0
PUMP_06_TILE_NUM = 65
.endsection

.section code
; mac_npc_set_xy .macro sprite_ctrl, tile_num
; 	lda #\tile_num
; 	jsr get_tile_x_for_gem
; 	bcc _mac_npc_set_xy_show
; 	#disable_sprite \sprite_ctrl
; 	sec
; 	rts 
; 	bra _mac_npc_set_xy_skip
; _mac_npc_set_xy_show
; 	jsr sprite_set_x
; 	lda #<PUMPKIN_Y_MIN
; 	ldx #>PUMPKIN_Y_MIN
; 	jsr sprite_set_y
; 	#set_sprite_xy \sprite_ctrl
; 	#set_npc \sprite_ctrl
; 	clc
; _mac_npc_set_xy_skip
; .endmacro

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
	;jsr init_pump1
	;jsr init_pump2
	;jsr init_pump3
	;jsr init_pump4
	;jsr init_pump5
	;jsr init_pump6
	rts

mac_npc_init .macro SPRITE_CTRL, SPRITE_ADDR
	#set_sprite_addr \SPRITE_CTRL, \SPRITE_ADDR
.endmacro

init_pump0
	
	#mac_npc_init PUMP_00_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump1
	#set_npc PUMP_01_SPR_CTRL
	#mac_npc_init PUMP_01_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump2
	#set_npc PUMP_02_SPR_CTRL
	#mac_npc_init PUMP_02_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump3
	#set_npc PUMP_03_SPR_CTRL
	#mac_npc_init PUMP_03_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump4
	#set_npc PUMP_04_SPR_CTRL
	#mac_npc_init PUMP_04_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump5
	#set_npc PUMP_05_SPR_CTRL
	#mac_npc_init PUMP_05_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump6
	#set_npc PUMP_06_SPR_CTRL
	#mac_npc_init PUMP_06_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

mac_handle_pump .macro SPRITE_CTRL, TILE_NUM, SPRITE_NUM, frame
	ldy #\SPRITE_NUM
    lda m_pump_enabled, y
	cmp #0
	bne _do_not_show
	#set_npc \SPRITE_CTRL
	lda #\TILE_NUM
	jsr get_tile_x_npc
	bcs _do_not_show
	jsr sprite_set_x
	lda m_pump_y 
	ldx m_pump_y + 1
	jsr sprite_set_y
	jsr sprite_get_x
	sta m_debug_pump_x
	stx m_debug_pump_x + 1
	jsr sprite_get_x
	sta m_debug_pump_y
	stx m_debug_pump_y + 1
	#set_sprite_xy  \SPRITE_CTRL
	bra _check_collision
	rts
_do_not_show
	#disable_sprite \SPRITE_CTRL
	rts
	bra _skip_pump
_check_collision
	lda #\TILE_NUM
	jsr get_tile_x_for_gem
	jsr sprite_set_x
	lda m_pump_y 
	ldx m_pump_y + 1
	jsr sprite_set_y
	jsr is_collision_a

	bcc _pump_collided
	bra _skip_pump
_pump_collided
	; lda #1
	; ;sta m_show_gem_collision
	; lda #1
	; ldy #\SPRITE_NUM
	; sta m_pump_enabled, y
	; lda #\TILE_NUM
	; sta m_tile_gem_collision
	;lda #\TILE_NUM
 	;sta m_debug_pump
 	;jsr set_collison_eol
 	;#disable_sprite \SPRITE_CTRL
 	;lda #1
 	;ldy #0 
 	;sta m_pump_enabled, y
	lda #01
	jsr add2score
_skip_pump
.endmacro

; mac_handle_pump .macro pump_num, spr_ctrl, tile_num, frame
; 	ldy #\pump_num
; 	lda m_pump_enabled, y 
; 	cmp #0
; 	beq _continue_handle_pump
; 	rts
; _continue_handle_pump
; 	#mac_npc_set_xy \spr_ctrl, \tile_num
; 	#mac_npc_set_addr \spr_ctrl, \frame 
; 	lda #\tile_num
; 	jsr get_tile_x_for_gem
; 	sta m_debug_pump_x
; 	stx m_debug_pump_x + 1
; 	jsr sprite_get_y
; 	sta m_debug_pump_y
; 	stx m_debug_pump_y + 1
; 	bcc _set_coord
; 	jsr print_scroll
; 	rts 
; _set_coord
; 	jsr clear_screen
; 	jsr sprite_set_x
; 	jsr is_collision_a
; 	bcc _continue_handle_pump_coll
; 	rts
; _continue_handle_pump_coll
; 	lda #\tile_num
; 	sta m_debug_pump
; 	jsr set_collison_eol
; 	#disable_sprite \spr_ctrl
; 	lda #1
; 	ldy #\pump_num 
; 	sta m_pump_enabled, y
; 	jsr sprite_get_x
; 	sta m_debug_pump_x
; 	stx m_debug_pump_x + 1 
; 	lda #\tile_num
; 	sta m_debug_pump_tile
	
; .endmacro

handle_pumpkin_0
	#mac_handle_pump PUMP_00_SPR_CTRL, PUMP_00_TILE_NUM, 0, m_pumpkin_frame
	#mac_npc_set_addr PUMP_00_SPR_CTRL, m_pumpkin_frame
	rts

handle_pumpkin_1
	#mac_handle_pump PUMP_01_SPR_CTRL, PUMP_01_TILE_NUM, 1, m_pumpkin_frame
	rts

handle_pumpkin_2
	#mac_handle_pump PUMP_02_SPR_CTRL, PUMP_02_TILE_NUM, 2, m_pumpkin_frame
	rts 

handle_pumpkin_3
	#mac_handle_pump PUMP_03_SPR_CTRL, PUMP_03_TILE_NUM, 3, m_pumpkin_frame
	rts 

handle_pumpkin_4
	#mac_handle_pump PUMP_04_SPR_CTRL, PUMP_04_TILE_NUM, 4, m_pumpkin_frame
	rts 

handle_pumpkin_5
	#mac_handle_pump PUMP_05_SPR_CTRL, PUMP_05_TILE_NUM, 5, m_pumpkin_frame
	rts 

handle_pumpkin_6
	#mac_handle_pump PUMP_06_SPR_CTRL, PUMP_06_TILE_NUM, 6, m_pumpkin_frame
	rts 

handle_pumpkin
	jsr is_collision_eol
	bcc _handle_collision
	jsr handle_pump_animation
	jsr handle_pumpkin_0
	;jsr handle_pumpkin_1
	;jsr handle_pumpkin_2
	;jsr handle_pumpkin_3
	;jsr handle_pumpkin_4
	;jsr handle_pumpkin_5
	;jsr handle_pumpkin_6
	jsr print_scroll
	rts
_handle_collision
	jsr proc_pump_explosion_ani
	rts
.endsection

.section variables
	m_pump_enabled .byte 0,0,0,0,0,0,0,0,0,0,0,0
	m_pump_y_min .byte 0
	m_pump_y_max .byte 0
	m_pump_y     .byte 0,0
	m_pump_ctrl  .byte 0,0
	m_pump_collision_tile .byte 0
	m_debug_pump .byte 0
	m_debug_pump_x .byte 0,0
	m_debug_pump_y .byte 0,0
	m_debug_pump_tile .byte 0
.endsection