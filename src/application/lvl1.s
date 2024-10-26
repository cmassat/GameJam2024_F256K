LVL1_INIT_STATE = $0
LVL1_LOAD_DATA_STATE = $1
LVL1_SCROLL_MAP_STATE = $2

handle_lvl1
    lda #STATE_LVL1
    jsr is_state
    bcc _yes
    rts
_yes
    lda sof_semaphore
    cmp #0
    beq _continue
    rts
_continue
    lda #1
    sta sof_semaphore
   ; lda m_lvl1_semaphore
   ; cmp #0
    ;beq _execute
    ;rts
;_execute
 ;   lda #1
 ;   sta m_lvl1_semaphore
    lda m_lvl1_state
    cmp #LVL1_INIT_STATE
    bne _load_map
    jsr lvl1_disable_video
    inc m_lvl1_state
    rts
_load_map
    lda m_lvl1_state
    cmp #LVL1_LOAD_DATA_STATE
    bne _ctrl_map
    jsr lvl1_load_data
    inc m_lvl1_state
    rts
_ctrl_map
    lda m_lvl1_state
    cmp #LVL1_SCROLL_MAP_STATE
    bne _end
    jsr scroll_lvl1_map
_end
    rts

lvl1_disable_video
    lda m_lvl1_state
    beq _yes
    rts
_yes:
    jsr disable_video
    rts

lvl1_load_data
    ;init variables
    jsr init_pumkin
    lda #0
    sta m_x_scroll_tile
    sta v_sync
    sta m_x_scroll_pxl
    sta TILE_MAP1_ATTR
    sta TILE_MAP2_ATTR
    sta m_do_scroll_tile
    ;load data
    jsr load_lvl1_set
    jsr load_lvl1_pal
    jsr clut_load_0
    jsr load_lvl1_map
    jsr load_lvl1_bak_bin
    jsr load_lvl1_bak_pal
    jsr clut_load_1
    jsr load_sprite_bin
    jsr load_sprite_pal
    jsr clut_load_2
    jsr init_pc1
    jsr play_lvl1_mus
;	jsr set_frame_timer
    lda #0
    sta MMU_IO_CTRL
    ;SET Layers
    lda #$04
    sta $D002
    lda #$04
    sta $D003

    jsr set_video_to_game_mode
    lda #0
    sta MMU_IO_CTRL

    ;SETUP bmp location
    lda #%00000011
    sta $D100
    lda <#BMP_ADDR
    sta $D101
    lda >#BMP_ADDR
    sta $D102
    lda `#BMP_ADDR
    sta $D103

    lda #$01
    sta TILE_MAP0_ATTR
    lda <#MAP_ADDR
    sta TILE_MAP0_ATTR + 1
    lda >#MAP_ADDR
    sta TILE_MAP0_ATTR + 2
    lda `#MAP_ADDR
    sta TILE_MAP0_ATTR + 3
    lda #255
    sta TILE_MAP0_ATTR + 4
    lda #15
    sta TILE_MAP0_ATTR + 6
    lda #0
    sta TILE_MAP0_ATTR + 8
    sta TILE_MAP0_ATTR + 9
    sta TILE_MAP0_ATTR + 10
    sta TILE_MAP0_ATTR + 11


    lda <#SET_ADDR
    sta $D280
    lda >#SET_ADDR
    sta $D281
    lda `#SET_ADDR
    sta $D282
    lda #%00001000
    sta $D283


    ;lda #%00001000
    ;sta MMU_IO_CTRL
    jsr set_frame_timer
    rts

scroll_lvl1_map
    jsr handle_jump
    jsr  handle_pumkin
    jsr is_joy_a_right_pressed
    bcc _move_right
    jsr is_d_pressed
    bcc _move_right
    jsr is_shft_d_pressed
    bcc _move_double_right
    jsr is_joy_a_left_pressed
    bcc _move_left
    rts
_move_right
    lda #DIR_RT
    sta m_p1_direction
    jsr move_right
    rts
_move_double_right
    jsr move_right
    jsr move_right
    rts
_move_left
    lda #DIR_LF
    sta m_p1_direction
    jsr move_left
    rts

move_left
    lda m_x_scroll_tile
    cmp #0
    bne _ok_to_scroll
    rts
_ok_to_scroll
    jsr handle_pc1_animation
    lda #0
    sta MMU_IO_CTRL
    lda m_lvl1_state
    cmp #LVL1_SCROLL_MAP_STATE
    beq _yes
    rts
_yes:
    lda v_sync
    clc
    adc #1
    sta v_sync
    lda v_sync
    cmp #1
    beq _scroll
    rts
_scroll:
    jsr scroll_pixels_left
    lda m_do_scroll_tile
    cmp #1
    bne _move
    lda m_x_scroll_tile
    sec
    sbc #1
    sta m_x_scroll_tile
    stz m_do_scroll_tile
_move:
    lda m_x_scroll_tile
    asl
    asl
    asl
    asl
    ora m_x_scroll_pxl
    sta TILE_MAP0_X_SC

    lda m_x_scroll_tile
    lsr
    lsr
    lsr
    lsr
    sta TILE_MAP0_X_SC_u
    stz v_sync

    lda m_x_scroll_tile
    rts

move_right
    jsr handle_pc1_animation
    lda #0
    sta MMU_IO_CTRL
    lda m_lvl1_state
    cmp #LVL1_SCROLL_MAP_STATE
    beq _yes
    rts
_yes:
    lda v_sync
    clc
    adc #1
    sta v_sync
    lda v_sync
    cmp #1
    beq _scroll
    rts
_scroll:
    jsr scroll_pixel
    lda m_do_scroll_tile
    cmp #1
    bne _move
    lda m_x_scroll_tile
    clc
    adc #1
    sta m_x_scroll_tile
    stz m_do_scroll_tile
_move:
    lda m_x_scroll_tile
    asl
    asl
    asl
    asl
    ora m_x_scroll_pxl
    sta TILE_MAP0_X_SC

    lda m_x_scroll_tile
    lsr
    lsr
    lsr
    lsr
    sta TILE_MAP0_X_SC_u
    stz v_sync

    lda m_x_scroll_tile
    rts

scroll_pixels_left
    stz MMU_IO_CTRL
    jsr print_scroll
    lda m_x_scroll_pxl
    cmp #0
    bne _do_scroll
    lda #15
    sta m_x_scroll_pxl
    lda #1
    sta m_do_scroll_tile
    rts
_do_scroll:
    lda m_x_scroll_pxl
    sbc #1
    sta m_x_scroll_pxl
    rts

scroll_pixel
    stz MMU_IO_CTRL
    jsr print_scroll
    lda m_x_scroll_pxl
    cmp #15
    bne _do_scroll
    stz m_x_scroll_pxl
    lda #1
    sta m_do_scroll_tile
    rts
_do_scroll:
    lda m_x_scroll_pxl
    clc
    adc #1
    sta m_x_scroll_pxl
    rts
.section variables
m_lvl1_semaphore
    .byte 0
m_lvl1_state
    .byte 0

.endsection