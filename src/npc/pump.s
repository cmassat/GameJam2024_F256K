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

PUMP_00_SPR_CTRL  = SPR_00_CTRL + (1 * 8)
PUMP_00_SPR_ADDR = NPC_SPR_PMK_0
PUMP_00_TILE_NUM = 12

PUMP_01_SPR_CTRL  = SPR_00_CTRL + (2 * 8)
PUMP_01_SPR_ADDR = NPC_SPR_PMK_1
PUMP_01_TILE_NUM = 15

PUMP_02_SPR_CTRL  = SPR_00_CTRL + (3 * 8)
PUMP_02_SPR_ADDR = NPC_SPR_PMK_2
PUMP_02_TILE_NUM = 20
.endsection

.section code
mac_npc_set_xy .macro sprite_ctrl, tile_num
	lda #\tile_num
	jsr get_tile_x_for_gem
	bcc _mac_npc_set_xy_show
	#disable_sprite \sprite_ctrl
	rts 
	bra _mac_npc_set_xy_skip
_mac_npc_set_xy_show
	jsr sprite_set_x
	lda m_pump_y
	ldx m_pump_y + 1
	jsr sprite_set_y
	#set_sprite_xy \sprite_ctrl
	#set_npc \SPRITE_CTRL
	clc
_mac_npc_set_xy_skip
.endmacro

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
	ldx #0
_loop
	lda #PUMPKIN_Y_MIN
	sta m_pump_y_max
	sta m_pump_y
	stz m_pump_y + 1
	lda #PUMPKIN_Y_MAX
	sta m_pump_y_max
	lda #DIR_UP
	sta m_pumpkin_dir
	jsr init_pump0
	jsr init_pump1
	jsr init_pump2
	rts

mac_npc_init .macro SPRITE_CTRL, SPRITE_ADDR
	#set_npc \SPRITE_CTRL
	#set_sprite_addr \SPRITE_CTRL, \SPRITE_ADDR
.endmacro

init_pump0
	#mac_npc_init PUMP_00_SPR_CTRL, PUMP_00_SPR_ADDR
	rts

init_pump1
	#mac_npc_init PUMP_01_SPR_CTRL, PUMP_01_SPR_ADDR
	rts

init_pump2
	#mac_npc_init PUMP_02_SPR_CTRL, PUMP_02_SPR_ADDR
	rts

mac_handle_pump .macro pump_num, spr_ctrl, tile_num, frame
	ldy #\pump_num
	lda m_pump_enabled, y 
	cmp #0
	beq _continue_handle_pump
	rts
_continue_handle_pump
	#mac_npc_set_xy \spr_ctrl, \tile_num
	#mac_npc_set_addr \spr_ctrl, \frame 
	jsr is_collision_a
	bcc _continue_handle_pump_coll
	rts
_continue_handle_pump_coll
	jsr set_collison_eol
	#disable_sprite \spr_ctrl
	lda #1
	ldy #\pump_num 
	sta m_pump_enabled, y 
.endmacro

handle_pumpkin_0
	#mac_handle_pump 0,PUMP_00_SPR_CTRL, PUMP_00_TILE_NUM, m_pumpkin_frame
	rts

handle_pumpkin_1
	#mac_handle_pump 1,PUMP_01_SPR_CTRL, PUMP_01_TILE_NUM, m_pumpkin_frame
	rts

handle_pumpkin_2
	#mac_handle_pump 2,PUMP_02_SPR_CTRL, PUMP_02_TILE_NUM, m_pumpkin_frame
	rts 

handle_pumpkin
	jsr is_collision_eol
	bcc _handle_collision
	jsr handle_pump_animation
	jsr handle_pumpkin_0
	jsr handle_pumpkin_1
	jsr handle_pumpkin_2
	rts
_handle_collision
	jsr proc_pump_explosion_ani
	rts
.endsection

.section variables
	m_pump_enabled .byte 0,0,0,0,0
	m_pump_y_min .byte 0
	m_pump_y_max .byte 0
	m_pump_y     .byte 0,0
	m_pump_ctrl  .byte 0,0
	m_pump_collision_tile .byte 0
.endsection