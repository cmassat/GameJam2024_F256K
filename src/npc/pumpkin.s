
.section variables
NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
pumpkin_FLOOR =  240-16
.endsection

.section code
init_pumpkin
    lda #0
    sta m_pumpkin_v_sync
    sta m_pumpkin_frame
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
    jsr get_tile_pixel_x
    bcc _ok
    rts
_ok
    lda #<pumpkin_FLOOR
    sta m_set_y
    lda #>pumpkin_FLOOR
    sta m_set_y + 1
    #set_npc SPR_CTRL_01
    ;#set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_4
    #set_npc_xy SPR_CTRL_01
    jsr pumpkin_fr0
    jsr pumpkin_fr1
    jsr pumpkin_fr2
    jsr pumpkin_fr3
    jsr pumpkin_fr4
    jsr pumpkin_fr5
    jsr pumpkin_collision
    rts

pumpkin_fr0
    lda m_pumpkin_frame
    cmp #0
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_0
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda #<PUMPKIN_FLOOR
    sta m_set_y
    sta m_pumpkin_y
    lda #>PUMPKIN_FLOOR
    sta m_pumpkin_y +1
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts

pumpkin_fr1
    lda m_pumpkin_frame
    cmp #1
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_1
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #4
	sta m_pumpkin_y
    sta m_set_y
    lda #>pumpkin_FLOOR
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts

pumpkin_fr2
    lda m_pumpkin_frame
    cmp #2
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_2
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #8
    sta m_set_y
	sta m_pumpkin_y
    lda #>pumpkin_FLOOR
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01

    rts
pumpkin_fr3
    lda m_pumpkin_frame
    cmp #3
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_3
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #8
    sta m_set_y
	sta m_pumpkin_y
    lda #>pumpkin_FLOOR
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts
pumpkin_fr4
    lda m_pumpkin_frame
    cmp #4
    beq _ok
    rts
_ok

    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_4
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
    sec
    sbc #4
	sta m_pumpkin_y
    sta m_set_y
    lda #>pumpkin_FLOOR + 4
    sbc #0
	sta m_pumpkin_y + 1
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts
pumpkin_fr5
    lda m_pumpkin_frame
    cmp #5
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_5
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda #<pumpkin_FLOOR
	sta m_pumpkin_y
    sta m_set_y
    lda #>pumpkin_FLOOR
    sta m_set_y + 1
	sta m_pumpkin_y + 1
    #set_npc_xy SPR_CTRL_01
    rts

pumpkin_collision
    lda m_pumpkin_tile
    jsr get_tile_pixel_x
    lda m_set_x
    sta m_pumpkin_x
    lda m_set_x + 1
    sta m_pumpkin_x + 1
    jsr collision_math_x
    jsr collision_math_y
    jsr is_collided

    rts

is_collided
    clc
    lda m_collide_x_diff + 1
    cmp #0
    beq _next_x
    rts
_next_x
    lda m_collide_x_diff
    cmp #16
    bcc _check_y
    rts
_check_y
    lda m_collide_y_diff + 1
    cmp #0
    beq _next_y
    rts
_next_y
    lda m_collide_y_diff
    cmp #25
    bcc _hit
    rts
_hit
    sec
    lda #1
    sta m_is_collided
    rts

collision_math_x
    lda m_p1_x
    sec
    sbc m_pumpkin_x
    sta m_collide_x_diff

    lda m_p1_x + 1
    sbc m_pumpkin_x
    sta m_collide_x_diff + 1
    BPL _ok
    bra _revers_calc
_ok
    rts
_revers_calc
    lda m_pumpkin_x
    sec
    sbc m_p1_x
    sta m_collide_x_diff

    lda m_pumpkin_x + 1
    sbc m_p1_x + 1
    sta m_collide_x_diff + 1
rts

collision_math_y
    lda m_p1_y
    sec
    sbc m_pumpkin_y
    sta m_collide_y_diff

    lda m_p1_y + 1
    sbc m_pumpkin_y + 1
    sta m_collide_y_diff + 1
    BPL _ok
    bra _revers_calc
_ok
    rts
_revers_calc
    sec
    lda m_pumpkin_y
    sbc m_p1_y
    sta m_collide_y_diff

    lda m_pumpkin_y + 1
    sbc m_p1_y + 1
    sta m_collide_y_diff + 1
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
m_collide_x_diff
    .byte 0,0
m_collide_y_diff
    .byte 0,0
m_is_collided
    .byte 0
.endsection
