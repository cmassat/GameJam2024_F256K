
.section variables
PUMPKIN_SPR_NUM = SPR_CTRL_01
NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
pumpkin_FLOOR =  240-16
.endsection

.section code

.section code
mac_set_y .macro 
	lda #<GEM_CEILING
	sta m_set_y
	lda #>GEM_CEILING
	sta m_set_y + 1
.endmacro

mac_gem_init .macro SPRITE_CTRL, SPRITE_ADDR
	#set_npc \SPRITE_CTRL
	#set_sprite_addr \SPRITE_CTRL, \SPRITE_ADDR
.endmacro

mac_gem_handle .macro SPRITE_CTRL, TILE_NUM, SPRITE_NUM
	lda #\TILE_NUM
	jsr get_tile_x_for_gem
	sta m_gem_start_x
	stx m_gem_start_x + 1
	bcs _do_not_show
	
	ldy #\SPRITE_NUM
    lda m_gem_enabled, y
	cmp #0
	bne _do_not_show
	#set_npc \SPRITE_CTRL
	lda m_gem_start_x
	sta m_set_x
	lda m_gem_start_x + 1
	sta m_set_x + 1
	lda #<GEM_CEILING
	sta m_set_y
	lda #>GEM_CEILING
	sta m_set_y + 1
	#set_sprite_xy \SPRITE_CTRL
	bra _check_collision
_do_not_show
	#disable_sprite \SPRITE_CTRL
	inc d_do_not_show
	bra _skip
_check_collision
	
	stz d_do_not_show
	jsr is_collision
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

init_pumpkin
    lda #0
    sta m_pumpkin_v_sync
    sta m_pumpkin_frame
	sta m_pumpkin_x
	sta m_pumpkin_y
    #set_npc SPR_CTRL_01
    #disable_sprite SPR_CTRL_01
    rts

handle_pumpkin
    jsr animate_pumpkin
    jsr show_pumpkin
    rts

animate_pumpkin
    inc m_pumpkin_v_sync
    lda m_pumpkin_v_sync
    cmp #15
    bcs _set_frame
    rts
_set_frame
    stz m_pumpkin_v_sync
    lda m_pumpkin_frame
    cmp #5
    bcc _next_frame
    stz m_pumpkin_frame
    rts
_next_frame
    inc m_pumpkin_frame
   rts

show_pumpkin
    inc m_pumpkin_v_sync
    lda m_pumpkin_tile
    ;;jsr get_tile_pixel_x
	
    bcc _ok
	#disable_sprite SPR_CTRL_01
    rts
_ok
	#set_npc SPR_CTRL_01
    lda #<pumpkin_FLOOR
    sta m_set_y
    lda #>pumpkin_FLOOR
    sta m_set_y + 1
    #set_npc SPR_CTRL_01
    #set_sprite_xy SPR_CTRL_01
	lda m_pumpkin_tile
    ;;jsr get_tile_pixel_x
	
    jsr pumpkin_fr0
    jsr pumpkin_fr1
    jsr pumpkin_fr2
    jsr pumpkin_fr3
    jsr pumpkin_fr4
    jsr pumpkin_fr5
   ;jsr pumpkin_collision
    rts

pumpkin_fr0
    lda m_pumpkin_frame
    cmp #0
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_0
    lda m_pumpkin_tile
    ;;jsr get_tile_pixel_x
    lda #<PUMPKIN_FLOOR
    sta m_set_y
    sta m_pumpkin_y
    lda #>PUMPKIN_FLOOR
    sta m_pumpkin_y +1
    sta m_set_y + 1
    #set_sprite_xy SPR_CTRL_01
    rts

pumpkin_fr1
    lda m_pumpkin_frame
    cmp #1
    beq _ok
    rts
_ok
     #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_1
    lda m_pumpkin_tile
   ;;jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #4
    sta m_set_y
	sta m_pumpkin_y
    lda #>pumpkin_FLOOR
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_sprite_xy SPR_CTRL_01
    rts

pumpkin_fr2
    lda m_pumpkin_frame
    cmp #2
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_2
    lda m_pumpkin_tile
    ;;jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #8
    sta m_set_y
	sta m_pumpkin_y
    lda #>pumpkin_FLOOR
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_sprite_xy SPR_CTRL_01

    rts
pumpkin_fr3
    lda m_pumpkin_frame
    cmp #3
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_3
    lda m_pumpkin_tile
    ;jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #8
    sta m_set_y
	sta m_pumpkin_y
    lda #>pumpkin_FLOOR
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_sprite_xy SPR_CTRL_01
    rts
pumpkin_fr4
    lda m_pumpkin_frame
    cmp #4
    beq _ok
    rts
_ok

    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_4
    lda m_pumpkin_tile
    ;jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #4
	sta m_pumpkin_y
    sta m_set_y
    lda #>pumpkin_FLOOR + 4
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_sprite_xy SPR_CTRL_01
    rts
pumpkin_fr5
    lda m_pumpkin_frame
    cmp #5
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_5
    lda m_pumpkin_tile
    ;jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
	sta m_pumpkin_y
    sta m_set_y
    lda #>pumpkin_FLOOR
    sta m_set_y + 1
	sta m_pumpkin_y + 1
    #set_sprite_xy SPR_CTRL_01
    rts

pumpkin_collision
	jsr do_reset
	bcc _do_not_check
	jsr is_collided
	beq _do_not_check
	bra _do_check
_do_not_check
	
	rts 
_do_check
    lda m_pumpkin_tile
    ;jsr get_tile_pixel_x
    lda m_set_x
    sta m_pumpkin_x
    lda m_set_x + 1
    sta m_pumpkin_x + 1

	lda m_pumpkin_x
	ldx m_pumpkin_x + 1
	jsr collide_set_x1

	lda m_p1_x
	ldx m_p1_x + 1
	jsr collide_set_x2

	lda m_pumpkin_y
	ldx m_pumpkin_y + 1
	jsr collide_set_y1

	lda m_p1_y
	ldx m_p1_y + 1
	jsr collide_set_y2

    jsr check_collision
	jsr is_collided
	bcc _detect_collision
	rts 
_detect_collision
	#disable_sprite SPR_CTRL_01
    rts
.endsection
.section variables
m_pumpkin_tile
    .byte 25
m_pumpkin_v_sync
    .byte 0
m_pumpkin_frame
    .byte 0
m_pumpkin_x
    .byte 0,0
m_pumpkin_y
    .byte 0,0
m_pumpkin_collide
    .byte 0
.endsection
