;a
; 10 30
get_tile_pixel_x
    sta m_check_x_tile
    sta m_temp
    lda m_x_scroll_tile
    cmp m_temp
    bcc _ok
    ;lda #0
    ;ldx #0
    sec
    rts
_ok
    lda m_temp
    adc #20
    sta m_temp
    lda m_x_scroll_tile
    cmp m_temp
    bcc _ok_hi
    sec
    rts
_ok_hi
    clc
     lda m_check_x_tile
     sbc m_x_scroll_tile
     sta $DE00
     lda #0
     sta $DE01
     lda #16
     sta $DE02
     lda #0
     sta $DE01
     lda $DE10
     sec
     sbc m_x_scroll_pxl
     sta m_set_x
     lda $DE11
     sbc #0
     sta m_set_x + 1
     clc
    rts

.section variables
    m_temp
        .byte 0
    m_check_x_tile
        .byte 0
    m_x_scroll_tile
        .byte 0
    m_x_scroll_pxl
        .byte 0
    m_do_scroll_tile
        .byte 0
.endsection
