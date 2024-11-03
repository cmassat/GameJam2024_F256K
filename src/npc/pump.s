.section variables
NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
PUMPKIN_NO_FRAMES = 5
PUMPKIN_Y_MIN =  240-16; 224
PUMPKIN_Y_MAX =  240-32; 208
PUMKIN_DISTANCE = PUMPKIN_Y_MIN - PUMPKIN_Y_MAX ;16
PUMKIN_PXLS_PER_FRAME = (PUMKIN_DISTANCE / PUMPKIN_NO_FRAMES); + .05

PUMP_00_SPR_CTRL  = SPR_00_CTRL + (1 * 8)
PUMP_00_SPR_ADDR = NPC_SPR_PMK_0
PUMP_00_TILE_NUM = 12
.endsection

.section code
mac_npc_set_xy .macro sprite_ctrl, tile_num 
	lda #\tile_num
	jsr get_tile_x_for_gem
	bcc _show
	#disable_sprite \sprite_ctrl
	bra _skip
_show
	jsr sprite_set_x
	lda m_pump_y
	ldx m_pump_y + 1
	jsr sprite_set_y
	#set_sprite_xy \sprite_ctrl
	#set_npc \SPRITE_CTRL
_skip
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
	sta m_pump_y
	stz m_pump_y + 1
	lda #PUMPKIN_Y_MAX
	sta m_pump_y_max
	lda #DIR_UP
	sta m_pumpkin_dir
	jsr init_pump0
	rts

handle_pumpkin
	#mac_npc_set_xy PUMP_00_SPR_CTRL, PUMP_00_TILE_NUM	
	#mac_npc_set_addr PUMP_00_SPR_CTRL, m_pumpkin_frame
	jsr is_collision_a
	bcs _continue
	#disable_sprite PUMP_00_SPR_CTRL
	rts
_continue
	jsr handle_pump_animation
	rts 
.endsection

.section variables
	m_pump_y_min .byte 0
	m_pump_y_max .byte 0
	m_pump_y     .byte 0,0
	m_pump_ctrl  .byte 0,0
.endsection