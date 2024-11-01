.section variables

NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
PUMPKIN_Y_MIN =  240-16
PUMPKIN_Y_MAX =  240-32

PUMP_00_SPR_CTRL  = SPR_00_CTRL + (1 * 8)
PUMP_00_SPR_ADDR = NPC_SPR_PMK_0
PUMP_00_TILE_NUM = 12

.endsection

.section code
mac_npc_set_xy .macro floor, sprite_ctrl, tile_num 
	lda #\tile_num
	jsr get_tile_x_for_gem
	bcc _show
	#disable_sprite \sprite_ctrl
	bra _skip
_show
	sta m_set_x
	stx m_set_x + 1
	lda #<\floor
	sta m_set_y
	lda #>\floor
	sta m_set_y + 1
	#set_sprite_xy \sprite_ctrl
	#set_npc \SPRITE_CTRL
_skip
.endmacro

mac_npc_init .macro SPRITE_CTRL, SPRITE_ADDR
	#set_npc \SPRITE_CTRL
	#set_sprite_addr \SPRITE_CTRL, \SPRITE_ADDR
.endmacro

init_pump0
		#mac_npc_init PUMP_00_SPR_CTRL, PUMP_00_SPR_ADDR
	rts 

init_pumpkin
	lda #PUMPKIN_Y_MIN
	sta m_pump_y_max
	lda #PUMPKIN_Y_MAX
	sta m_pump_y_max
	lda DIR_UP
	sta m_pumpkin_dir
	stz m_pump_y
	jsr init_pump0
	rts

handle_pumpkin
	#mac_npc_set_xy PUMPKIN_Y_MIN, PUMP_00_SPR_CTRL, PUMP_00_TILE_NUM 
	rts 

.endsection

.section variables
	m_pump_y_min .byte 0
	m_pump_y_max .byte 0
.endsection