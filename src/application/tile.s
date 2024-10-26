;a
; 10
get_tile_pixel

    lda #$ff


    rts
.section variables
    m_x_scroll_tile
        .byte 0
    m_x_scroll_pxl
        .byte 0
    m_do_scroll_tile
        .byte 0
.endsection
