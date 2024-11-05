.section variables
PC1_SPR_WLK_R0 = SPR32_ADDR
PC1_SPR_WLK_R1 = PC1_SPR_WLK_R0 + $400
PC1_SPR_WLK_R2 = PC1_SPR_WLK_R1 + $400
PC1_SPR_WLK_R3 = PC1_SPR_WLK_R2 + $400
PC1_SPR_WLK_R4 = PC1_SPR_WLK_R3 + $400
PC1_SPR_WLK_R5 = PC1_SPR_WLK_R4 + $400

PC1_SPR_WLK_L0 = SPR32_ADDR + ($400 *10)
PC1_SPR_WLK_L1 = PC1_SPR_WLK_L0 + $400
PC1_SPR_WLK_L2 = PC1_SPR_WLK_L1 + $400
PC1_SPR_WLK_L3 = PC1_SPR_WLK_L2 + $400
PC1_SPR_WLK_L4 = PC1_SPR_WLK_L3 + $400
PC1_SPR_WLK_L5 = PC1_SPR_WLK_L4 + $400
FLOOR_LEVEL = 208 ; $d0
PL_TILE = 5
.endsection

.section code

disable_player1
	#disable_sprite SPR_CTRL_00
	rts
 
enable_player1
	#set_pc SPR_CTRL_00
	rts 

get_player1_x
	lda m_p1_x
	ldx m_p1_x + 1
	rts 

get_player1_y
	lda m_p1_y
	ldx m_p1_y + 1
	rts 

init_pc1
	lda #3
	sta m_player_lives
    #set_pc SPR_CTRL_00
	#set_sprite_addr SPR_CTRL_00, SPR32_ADDR
	lda #PL_TILE
	jsr get_tile_x_for_player1
	jsr sprite_set_x
    sta m_p1_x
    stx m_p1_x + 1

    lda #<FLOOR_LEVEL
    sta m_set_y
    sta m_p1_y
    lda #>FLOOR_LEVEL
    sta m_set_y + 1
    sta m_p1_y +1
    #set_sprite_xy SPR_CTRL_00

    stz m_pc1_animation
    stz m_pc1_frames_animation
    rts

set_frames
    inc m_pc1_frames_animation
    lda m_pc1_frames_animation
    cmp #8
    beq _increase_frame
    rts
_increase_frame
    stz m_pc1_frames_animation
    inc m_pc1_animation
    rts

handle_player_move
; 	lda  m_jump_lock
;     cmp #1
; 	bne _continue 
; 	jsr handle_jump
; 	rts
; _continue 
    jsr handle_jump
    ;jsr is_joy_a_right_pressed
    ;bcc _move_right
    jsr is_d_pressed
    bcc _move_right

    jsr is_a_pressed
    bcc _move_left
   ; jsr is_joy_a_left_pressed
   ; bcc _move_left
    lda #DIR_DN
    sta m_p1_direction
    rts
_move_right
    lda #DIR_RT
    sta m_p1_direction
    rts
_move_left
    lda #DIR_LF
    sta m_p1_direction
    rts

handle_jump
    lda  m_jump_lock
    cmp #1
    beq _jumping
    ;jsr is_joy_a_btn_0_pressed
    ;bcc _jump
    jsr is_j_pressed
    bcc _jump
    rts
_jump
    lda m_jump_lock
    cmp #0

    beq _ok_to_jump
    rts
_ok_to_jump
    lda #1
    sta m_jump_lock

    stz m_jump_vsync
    stz m_jump_frame
    rts
_jumping
    jsr set_jump_frames
    jsr jump_frm_0
    jsr jump_frm_1
    jsr jump_frm_2
    jsr jump_frm_3
    jsr jump_frm_4
    jsr jump_frm_5
    jsr jump_frm_6
    jsr jump_frm_7
    jsr jump_frm_8
    jsr jump_frm_9
    jsr jump_frm_10
    jsr jump_frm_11
    jsr jump_frm_12
    jsr jump_frm_13
    jsr jump_frm_14
    jsr jump_frm_15
    jsr jump_frm_16
    jsr jump_frm_17
    jsr jump_frm_18
	lda #PL_TILE
	jsr get_tile_x_for_player1
    jsr sprite_set_x
	sta m_p1_x
	stx m_p1_x + 1
	jsr sprite_set_x
    #set_sprite_xy SPR_CTRL_00
    rts

set_jump_frames
    inc m_jump_vsync
    lda m_jump_vsync
    cmp #3
    beq _increase_frame
    rts
_increase_frame
    stz m_jump_vsync
    inc m_jump_frame
    rts

jump_frame .macro distance, frame
    lda m_jump_frame
    cmp #\frame
    beq _show_frame
    bra _skip
_show_frame
    lda #<FLOOR_LEVEL
    sec
    sbc #\distance
    sta m_set_y
    sta m_p1_y
    lda #>FLOOR_LEVEL
    sbc #0
    sta m_set_y + 1
    sta m_p1_y + 1
_skip
.endmacro

jump_frm_0
    #jump_frame 5, 0
    rts
jump_frm_1
    #jump_frame 10, 1
    rts
jump_frm_2
    #jump_frame 20, 2
    rts
jump_frm_3
    #jump_frame 30, 3
    rts
jump_frm_4
    #jump_frame 35, 4
    rts
jump_frm_5
    #jump_frame 35, 5
    rts
jump_frm_6
    #jump_frame 35, 6
rts
jump_frm_7
    #jump_frame 35, 7
rts
jump_frm_8
    #jump_frame 30, 8
rts
jump_frm_9
    #jump_frame 25, 9
rts
jump_frm_10
    #jump_frame 20, 10
rts
jump_frm_11
    #jump_frame 15, 11
rts
jump_frm_12
    #jump_frame 10, 12
rts
jump_frm_13
    #jump_frame 5, 13
rts
jump_frm_14
    #jump_frame 4, 14
rts
jump_frm_15
    #jump_frame 3, 15
rts
jump_frm_16
    #jump_frame 2, 16
rts
jump_frm_17
    #jump_frame 1, 17
rts
jump_frm_18
    #jump_frame 0, 18
    lda m_jump_frame
    cmp #18
    beq _reset
    rts
_reset
    stz m_jump_lock
    stz m_jump_frame
    rts

handle_pc1_animation
    jsr set_frames
    lda m_pc1_animation
    cmp #5
    bne _animate
    lda #0
    sta m_pc1_animation
    rts
_animate
    lda m_pc1_animation
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
    cmp #5
    beq _fr5
    rts
_fr0
    jsr player_fr0
    rts
_fr1
    jsr player_fr1
    rts
_fr2
    jsr player_fr2
    rts
_fr3
    jsr player_fr3
    rts
_fr4
    jsr player_fr4
_fr5
    jsr player_fr4
    rts

player_fr0
    lda m_p1_direction
    cmp #DIR_RT
    beq _right
    cmp #DIR_LF
    beq _left
    rts
_right
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_R0
    rts
_left
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_L0
    rts

player_fr1
    lda m_p1_direction
    cmp #DIR_RT
    beq _right
    cmp #DIR_LF
    beq _left
    rts
_right
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_R1
    rts
_left
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_L1
    rts

player_fr2
    lda m_p1_direction
    cmp #DIR_RT
    beq _right
    cmp #DIR_LF
    beq _left
    rts
_right
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_R2
    rts
_left
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_L2
    rts

player_fr3
    lda m_p1_direction
    cmp #DIR_RT
    beq _right
    cmp #DIR_LF
    beq _left
    rts
_right
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_R3
    rts
_left
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_L3
    rts

player_fr4
    lda m_p1_direction
    cmp #DIR_RT
    beq _right
    cmp #DIR_LF
    beq _left
    rts
_right
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_R4
    rts
_left
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_L4
    rts

player_fr5
    lda m_p1_direction
    cmp #DIR_RT
    beq _right
    cmp #DIR_LF
    beq _left
    rts
_right
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_R5
    rts
_left
    #set_sprite_addr SPR_CTRL_00,  PC1_SPR_WLK_L5
    rts

create_player_hitbox
	;get hit box of snack
	lda m_p1_x
	clc 
	adc #15
	sta m_p1_x_end

	lda m_p1_x + 1
	adc #0
	sta m_p1_x_end + 1

	lda m_p1_y
	clc 
	adc #31
	sta m_p1_y_end

	lda m_p1_y +1
	adc #0
	sta m_p1_y_end + 1
	rts 
.endsection
.section variables
m_p1_direction
    .byte 0
m_p1_x
    .byte 0,0
m_p1_y
    .byte 0,0
m_p1_x_end 
    .byte 0,0
m_p1_y_end
    .byte 0,0
m_jump_lock
    .byte 0
m_jump_vsync
    .byte 0
m_jump_frame
    .byte 0
m_jump_animation_frame
    .byte 0
m_player_lives
	.byte 0
.endsection
