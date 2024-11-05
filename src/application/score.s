.section variables
ALPHA_START = 80
NUM_00_SPR_CTRL  = SPR_00_CTRL + (40 * 8)
NUM_01_SPR_CTRL =  SPR_00_CTRL + (41 * 8)
NUM_02_SPR_CTRL =  SPR_00_CTRL + (42 * 8)
NUM_03_SPR_CTRL =  SPR_00_CTRL + (43 * 8)
NUM_04_SPR_CTRL =  SPR_00_CTRL + (44 * 8)
NUM_05_SPR_CTRL =  SPR_00_CTRL + (45 * 8)
NUM_06_SPR_CTRL =  SPR_00_CTRL + (46 * 8)

NUM_00_SPR_ADDR = SPR16_ADDR + (16 * 16 * ALPHA_START)
NUM_01_SPR_ADDR = SPR16_ADDR + (16 * 16 * 81)
NUM_02_SPR_ADDR = SPR16_ADDR + (16 * 16 * 82)
NUM_03_SPR_ADDR = SPR16_ADDR + (16 * 16 * 83)
NUM_04_SPR_ADDR = SPR16_ADDR + (16 * 16 * 84)
NUM_05_SPR_ADDR = SPR16_ADDR + (16 * 16 * 85)
NUM_06_SPR_ADDR = SPR16_ADDR + (16 * 16 * 86)
NUM_07_SPR_ADDR = SPR16_ADDR + (16 * 16 * 87)
NUM_08_SPR_ADDR = SPR16_ADDR + (16 * 16 * 88)
NUM_09_SPR_ADDR = SPR16_ADDR + (16 * 16 * 89)

SCORE_POS6_START = 40
SCORE_POS5_START = SCORE_POS6_START + 8
SCORE_POS4_START = SCORE_POS5_START + 8 
SCORE_POS3_START = SCORE_POS4_START + 8 
SCORE_POS2_START = SCORE_POS3_START + 8 
SCORE_POS1_START = SCORE_POS2_START + 8 
SCORE_POS0_START = SCORE_POS1_START + 8 
.endsection

.section code
set_score_y
	lda #40
	ldx #0
	jsr sprite_set_y
	rts 
init_score
	;ldy #0
	;lda #0
	;sta m_score
	;inx 
	;sta m_score, y 
	;inx 
	;sta m_score, y 
	;inx 
	;sta m_score, y 
	;inx 
	;sta m_score, y 
	;inx 
	;sta m_score, y

	#set_npc  NUM_00_SPR_CTRL
	#set_npc  NUM_01_SPR_CTRL
	#set_npc  NUM_02_SPR_CTRL
	#set_npc  NUM_03_SPR_CTRL
	#set_npc  NUM_04_SPR_CTRL
	#set_npc  NUM_05_SPR_CTRL
	#set_npc  NUM_06_SPR_CTRL
	
	jsr set_score_y
	
	lda #SCORE_POS0_START
	jsr sprite_set_x
	#set_sprite_xy NUM_00_SPR_CTRL
	#set_sprite_addr NUM_00_SPR_CTRL, NUM_00_SPR_ADDR
	
	lda #SCORE_POS1_START
	jsr sprite_set_x
	#set_sprite_addr NUM_01_SPR_CTRL, NUM_00_SPR_ADDR
	#set_sprite_xy NUM_01_SPR_CTRL

	lda #SCORE_POS2_START
	jsr sprite_set_x
	#set_sprite_addr NUM_02_SPR_CTRL, NUM_00_SPR_ADDR
	#set_sprite_xy NUM_02_SPR_CTRL

	lda #SCORE_POS3_START
	jsr sprite_set_x
	#set_sprite_addr NUM_03_SPR_CTRL, NUM_00_SPR_ADDR
	#set_sprite_xy NUM_03_SPR_CTRL

	lda #SCORE_POS4_START
	jsr sprite_set_x
	#set_sprite_addr NUM_04_SPR_CTRL, NUM_00_SPR_ADDR
	#set_sprite_xy NUM_04_SPR_CTRL

	lda #SCORE_POS5_START
	jsr sprite_set_x
	#set_sprite_addr NUM_05_SPR_CTRL, NUM_00_SPR_ADDR
	#set_sprite_xy NUM_05_SPR_CTRL

	lda #SCORE_POS6_START
	jsr sprite_set_x
	#set_sprite_addr NUM_06_SPR_CTRL, NUM_00_SPR_ADDR
	#set_sprite_xy NUM_06_SPR_CTRL
	rts 

mac_choose_digit .macro sprite_ctrl, digit
	lda \digit
	ldx #3 ;bytes per address 
	jsr  fn_multiply_8bit 
	tay 
	lda m_digit_address, y
	sta m_lo 
	iny 
	lda m_digit_address, y
	sta m_med 
	iny 
	lda m_digit_address, y
	sta m_hi
	#set_sprite_addr_lmh \sprite_ctrl, m_lo, m_med, m_hi 
.endmacro
m_temp_score
 .byte 0
show_digit_0
	lda m_score 
	and #$0f
	sta m_temp_score
	#mac_choose_digit NUM_00_SPR_CTRL,m_temp_score
	rts
show_digit_1
	lda m_score 
	lsr 
	lsr 
	lsr 
	lsr
	sta m_temp_score
	#mac_choose_digit NUM_01_SPR_CTRL, m_temp_score
	rts
show_digit_2
	lda m_score_1
	and #$0f
	sta m_temp_score
	#mac_choose_digit NUM_02_SPR_CTRL, m_temp_score
	rts
show_digit_3
	lda m_score_1 
	lsr 
	lsr 
	lsr 
	lsr
	sta m_temp_score
	#mac_choose_digit NUM_03_SPR_CTRL, m_temp_score
	rts
show_digit_4
	lda m_score_2
	and #$0f
	sta m_temp_score
	#mac_choose_digit NUM_04_SPR_CTRL, m_temp_score
	rts
show_digit_5
	lda m_score_2
	lsr 
	lsr 
	lsr 
	lsr
	sta m_temp_score
	#mac_choose_digit NUM_05_SPR_CTRL, m_temp_score
	rts
show_digit_6
	lda m_score_3	
	and #$0f
	sta m_temp_score
	#mac_choose_digit NUM_06_SPR_CTRL, m_temp_score
	rts

show_score
	jsr show_digit_0
	jsr show_digit_1
	jsr show_digit_2
	jsr show_digit_3
	jsr show_digit_4
	jsr show_digit_5
	jsr show_digit_6
	rts

;a register is score to add
add2score
	clc
	sed
	adc m_score
	sta m_score

	lda m_score + 1
	adc #0
	sta m_score + 1

	lda m_score + 2
	adc #0
	sta m_score + 2

	lda m_score + 3
	adc #0
	sta m_score + 3
	
	lda m_score + 4
	adc #0
	sta m_score + 4

	lda m_score + 5
	adc #0
	sta m_score + 5
	cld 
	rts

.endsection

.section variables
m_score
m_score_0
 	.byte 5
m_score_1
 	.byte 0
m_score_2
 	.byte 0
m_score_3
 	.byte 0
m_score_4
 	.byte 0
m_score_5
 	.byte 0
m_score_6
 	.byte 0
m_lo 
	.byte 0
m_med 
	.byte 0
m_hi 
	.byte 0
m_digit_address
.byte <NUM_00_SPR_ADDR, >NUM_00_SPR_ADDR, `NUM_00_SPR_ADDR
.byte <NUM_01_SPR_ADDR, >NUM_01_SPR_ADDR, `NUM_01_SPR_ADDR
.byte <NUM_02_SPR_ADDR, >NUM_02_SPR_ADDR, `NUM_02_SPR_ADDR
.byte <NUM_03_SPR_ADDR, >NUM_03_SPR_ADDR, `NUM_03_SPR_ADDR
.byte <NUM_04_SPR_ADDR, >NUM_04_SPR_ADDR, `NUM_04_SPR_ADDR
.byte <NUM_05_SPR_ADDR, >NUM_05_SPR_ADDR, `NUM_05_SPR_ADDR
.byte <NUM_06_SPR_ADDR, >NUM_06_SPR_ADDR, `NUM_06_SPR_ADDR
.byte <NUM_07_SPR_ADDR, >NUM_07_SPR_ADDR, `NUM_07_SPR_ADDR
.byte <NUM_08_SPR_ADDR, >NUM_08_SPR_ADDR, `NUM_08_SPR_ADDR
.byte <NUM_09_SPR_ADDR, >NUM_09_SPR_ADDR, `NUM_09_SPR_ADDR
.endsection

