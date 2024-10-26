
.section variables
NPC_SPR_PMK_0 = SPR16_ADDR + (16 * 16 * 40)
NPC_SPR_PMK_1 = NPC_SPR_PMK_0 + (16 * 16)
NPC_SPR_PMK_2 = NPC_SPR_PMK_1 + (16 * 16)
NPC_SPR_PMK_3 = NPC_SPR_PMK_2 + (16 * 16)
NPC_SPR_PMK_4 = NPC_SPR_PMK_3 + (16 * 16)
NPC_SPR_PMK_5 = NPC_SPR_PMK_4 + (16 * 16)
PUMKIN_FLOOR =  240-16
.endsection

.section code
init_pumkin
    lda #0
    sta m_pumkin_v_sync
    sta m_pumkin_frame
    rts

handle_pumkin
    jsr animate_pumkin
    jsr show_pumkin
    rts

animate_pumkin
    inc m_pumkin_v_sync
    lda m_pumkin_v_sync
    cmp #15
    bcs _set_frame
    rts
_set_frame
    stz m_pumkin_v_sync
    lda m_pumkin_frame
    cmp #5
    bcc _next_frame
    stz m_pumkin_frame
    rts
_next_frame
    inc m_pumkin_frame
   rts

show_pumkin
    inc m_pumkin_v_sync
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    bcc _ok
    rts
_ok
    lda #<PUMKIN_FLOOR
    sta m_set_y
    lda #>PUMKIN_FLOOR
    sta m_set_y + 1
    #set_npc SPR_CTRL_01
    ;#set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_4
    #set_npc_xy SPR_CTRL_01
    jsr pumkin_fr0
    jsr pumkin_fr1
    jsr pumkin_fr2
    jsr pumkin_fr3
    jsr pumkin_fr4
    jsr pumkin_fr5
    rts

pumkin_fr0
    lda m_pumkin_frame
    cmp #0
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_0
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    lda #<PUMKIN_FLOOR
    sta m_set_y
    lda #>PUMKIN_FLOOR
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts

pumkin_fr1
    lda m_pumkin_frame
    cmp #1
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_1
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    lda #<PUMKIN_FLOOR
    sec
    sbc #4
    sta m_set_y
    lda #>PUMKIN_FLOOR
    sbc #0
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts

pumkin_fr2
    lda m_pumkin_frame
    cmp #2
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_2
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    lda #<PUMKIN_FLOOR
    sec
    sbc #8
    sta m_set_y
    lda #>PUMKIN_FLOOR
    sbc #0
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01

    rts
pumkin_fr3
    lda m_pumkin_frame
    cmp #3
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_3
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    lda #<PUMKIN_FLOOR
    sec
    sbc #8
    sta m_set_y
    lda #>PUMKIN_FLOOR
    sbc #0
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts
pumkin_fr4
    lda m_pumkin_frame
    cmp #4
    beq _ok
    rts
_ok

    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_4
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    lda #<PUMKIN_FLOOR
    sec
    sbc #4
    sta m_set_y
    lda #>PUMKIN_FLOOR + 4
    sbc #0
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts
pumkin_fr5
    lda m_pumkin_frame
    cmp #5
    beq _ok
    rts
_ok
    #set_sprite_addr SPR_CTRL_01, NPC_SPR_PMK_5
    lda m_pumkin_tile
    jsr get_tile_pixel_x
    lda #<PUMKIN_FLOOR
    sta m_set_y
    lda #>PUMKIN_FLOOR
    sta m_set_y + 1
    #set_npc_xy SPR_CTRL_01
    rts

.endsection
.section variables
m_pumkin_tile
    .byte 25
m_pumkin_v_sync
    .byte 0
m_pumkin_frame
    .byte 0
.endsection
