init_video
    lda #0
    sta MMU_IO_CTRL
    lda #0
	ora #%00000011
    ora #VCKY_GRFX
    ora #VCKY_BMP
    sta $D000
    rts

set_video_to_game_mode
    lda #0
    sta MMU_IO_CTRL
    lda #0
    ora #%00000011
    ora #VCKY_GRFX
    ora #VCKY_BMP
    ora #VCKY_TILE
    ora #VCKY_SPRT
    sta $D000
rts

disable_video
    lda #0
	ora #%00000011
    sta $D000
    rts

clear_screen
    lda #2
    sta MMU_IO_CTRL
    lda <#$C000
    sta POINTER_SRC
    lda >#$c000
    sta POINTER_SRC + 1

    ldx #0
loop_outer:
    ldy #0
loop:
    lda #' '
    sta (POINTER_SRC),y
    iny
    cpy #80
    bne loop
    lda POINTER_SRC
    clc
    adc #80
    sta POINTER_SRC

    lda POINTER_SRC + 1
    adc #0
    sta POINTER_SRC + 1
    inx
    cpx #60
    bne loop_outer
    stz MMU_IO_CTRL
    rts
