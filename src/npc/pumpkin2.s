
.section variables
PUMPKIN2_SPR_NUM = SPR_CTRL_05
;NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
;NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
;NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
;NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
;NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
;NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
pumpkin2_FLOOR =  240-16
.endsection

.section code
init_pumpkin2
    lda #0
    sta m_pumpkin2_v_sync
    sta m_pumpkin2_frame
	sta m_pumpkin2_x
	sta m_pumpkin2_y
    #set_npc PUMPKIN2_SPR_NUM
    #disable_sprite PUMPKIN2_SPR_NUM
    rts

handle_pumpkin2
    jsr animate_pumpkin2
    jsr show_pumpkin2
    rts

animate_pumpkin2
    inc m_pumpkin2_v_sync
    lda m_pumpkin2_v_sync
    cmp #15
    bcs _set_frame
    rts
_set_frame
    stz m_pumpkin2_v_sync
    lda m_pumpkin2_frame
    cmp #5
    bcc _next_frame
    stz m_pumpkin2_frame
    rts
_next_frame
    inc m_pumpkin2_frame
   rts

show_pumpkin2
    inc m_pumpkin2_v_sync
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
	
    bcc _ok
	#disable_sprite PUMPKIN2_SPR_NUM
    rts
_ok
	#set_npc PUMPKIN2_SPR_NUM
    lda #<pumpkin2_FLOOR
    sta m_set_y
    lda #>pumpkin2_FLOOR
    sta m_set_y + 1
    #set_npc PUMPKIN2_SPR_NUM
    #set_npc_xy PUMPKIN2_SPR_NUM
	lda m_pumpkin2_tile
    jsr get_tile_pixel_x
	
    jsr pumpkin2_fr0
    jsr pumpkin2_fr1
    jsr pumpkin2_fr2
    jsr pumpkin2_fr3
    jsr pumpkin2_fr4
    jsr pumpkin2_fr5
    ;jsr pumpkin2_collision
    rts

pumpkin2_fr0
    lda m_pumpkin2_frame
    cmp #0
    beq _ok
    rts
_ok
    #set_sprite_addr PUMPKIN2_SPR_NUM, NPC_SPR_PMK_0
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda #<PUMPKIN_FLOOR
    sta m_set_y
    sta m_pumpkin2_y
    lda #>PUMPKIN_FLOOR
    sta m_pumpkin2_y +1
    sta m_set_y + 1
    #set_npc_xy PUMPKIN2_SPR_NUM
    rts

pumpkin2_fr1
    lda m_pumpkin2_frame
    cmp #1
    beq _ok
    rts
_ok
     #set_sprite_addr PUMPKIN2_SPR_NUM, NPC_SPR_PMK_1
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda #<pumpkin2_FLOOR
    sec
    sbc #4
    sta m_set_y
	sta m_pumpkin2_y
    lda #>pumpkin2_FLOOR
    sbc #0
	sta m_pumpkin2_y + 1
    sta m_set_y + 1
    #set_npc_xy PUMPKIN2_SPR_NUM
    rts

pumpkin2_fr2
    lda m_pumpkin2_frame
    cmp #2
    beq _ok
    rts
_ok
    #set_sprite_addr PUMPKIN2_SPR_NUM, NPC_SPR_PMK_2
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda #<pumpkin2_FLOOR
    sec
    sbc #8
    sta m_set_y
	sta m_pumpkin2_y
    lda #>pumpkin2_FLOOR
    sbc #0
	sta m_pumpkin2_y + 1
    sta m_set_y + 1
    #set_npc_xy PUMPKIN2_SPR_NUM

    rts
pumpkin2_fr3
    lda m_pumpkin2_frame
    cmp #3
    beq _ok
    rts
_ok
    #set_sprite_addr PUMPKIN2_SPR_NUM, NPC_SPR_PMK_3
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda #<pumpkin2_FLOOR
    sec
    sbc #8
    sta m_set_y
	sta m_pumpkin2_y
    lda #>pumpkin2_FLOOR
    sbc #0
	sta m_pumpkin2_y + 1
    sta m_set_y + 1
    #set_npc_xy PUMPKIN2_SPR_NUM
    rts
pumpkin2_fr4
    lda m_pumpkin2_frame
    cmp #4
    beq _ok
    rts
_ok

    #set_sprite_addr PUMPKIN2_SPR_NUM, NPC_SPR_PMK_4
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda #<pumpkin2_FLOOR
    sec
    sbc #4
	sta m_pumpkin2_y
    sta m_set_y
    lda #>pumpkin2_FLOOR + 4
    sbc #0
	sta m_pumpkin2_y + 1
    sta m_set_y + 1
    #set_npc_xy PUMPKIN2_SPR_NUM
    rts
pumpkin2_fr5
    lda m_pumpkin2_frame
    cmp #5
    beq _ok
    rts
_ok
    #set_sprite_addr PUMPKIN2_SPR_NUM, NPC_SPR_PMK_5
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda #<pumpkin2_FLOOR
	sta m_pumpkin2_y
    sta m_set_y
    lda #>pumpkin2_FLOOR
    sta m_set_y + 1
	sta m_pumpkin2_y + 1
    #set_npc_xy PUMPKIN2_SPR_NUM
    rts

pumpkin2_collision
	jsr do_reset
	bcc _do_not_check
	jsr is_collided
	beq _do_not_check
	bra _do_check
_do_not_check
	
	rts 
_do_check
    lda m_pumpkin2_tile
    jsr get_tile_pixel_x
    lda m_set_x
    sta m_pumpkin2_x
    lda m_set_x + 1
    sta m_pumpkin2_x + 1

	lda m_pumpkin2_x
	ldx m_pumpkin2_x + 1
	jsr collide_set_x1

	lda m_p1_x
	ldx m_p1_x + 1
	jsr collide_set_x2

	lda m_pumpkin2_y
	ldx m_pumpkin2_y + 1
	jsr collide_set_y1

	lda m_p1_y
	ldx m_p1_y + 1
	jsr collide_set_y2

    jsr check_collision
	jsr is_collided
	bcc _detect_collision
	rts 
_detect_collision
	#disable_sprite PUMPKIN2_SPR_NUM
    rts
.endsection
.section variables
m_pumpkin2_tile
    .byte 50
m_pumpkin2_v_sync
    .byte 0
m_pumpkin2_frame
    .byte 0
m_pumpkin2_x
    .byte 0,0
m_pumpkin2_y
    .byte 0,0
m_pumpkin2_collide
    .byte 0
.endsection
