clut_load_0
    lda #5
    sta mem_bank
    jsr bank2address
    lda #CLUT_IO
    sta MMU_IO_CTRL

    lda <#$A000
    sta POINTER_CLUT_SRC

    lda >#$A000
    sta POINTER_CLUT_SRC+1

    lda <#CLUT_0_ADDR
    sta POINTER_CLUT_DEST
    lda >#CLUT_0_ADDR
    sta POINTER_CLUT_DEST+1

    ldx #0
_clut_row
    ldy #0
_clut_loop
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y

    lda POINTER_CLUT_SRC
    clc
    adc #4
    sta POINTER_CLUT_SRC

    lda POINTER_CLUT_SRC + 1
    adc #0
    sta POINTER_CLUT_SRC + 1

     lda POINTER_CLUT_DEST
    clc
    adc #4
    sta POINTER_CLUT_DEST

    lda POINTER_CLUT_DEST + 1
    adc #0
    sta POINTER_CLUT_DEST + 1

    inx
    cpx #$ff
    bne _clut_row

    stz MMU_IO_CTRL
    rts

clut_load_1
    lda #5
    sta mem_bank
    jsr bank2address
    lda #CLUT_IO
    sta MMU_IO_CTRL

    lda <#$A000
    sta POINTER_CLUT_SRC

    lda >#$A000
    sta POINTER_CLUT_SRC+1

    lda <#CLUT_1_ADDR
    sta POINTER_CLUT_DEST
    lda >#CLUT_1_ADDR
    sta POINTER_CLUT_DEST+1

    ldx #0
_clut_row
    ldy #0
_clut_loop
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y

    lda POINTER_CLUT_SRC
    clc
    adc #4
    sta POINTER_CLUT_SRC

    lda POINTER_CLUT_SRC + 1
    adc #0
    sta POINTER_CLUT_SRC + 1

        lda POINTER_CLUT_DEST
    clc
    adc #4
    sta POINTER_CLUT_DEST

    lda POINTER_CLUT_DEST + 1
    adc #0
    sta POINTER_CLUT_DEST + 1

    inx
    cpx #$ff
    bne _clut_row

    lda #0
    sta MMU_IO_CTRL
    rts

clut_load_2
    lda #5
    sta mem_bank
    jsr bank2address
    lda #CLUT_IO
    sta MMU_IO_CTRL

    lda <#$A000
    sta POINTER_CLUT_SRC

    lda >#$A000
    sta POINTER_CLUT_SRC+1

    lda <#CLUT_2_ADDR
    sta POINTER_CLUT_DEST
    lda >#CLUT_2_ADDR
    sta POINTER_CLUT_DEST+1

    ldx #0
_clut_row
    ldy #0
_clut_loop
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y
    iny
    lda (POINTER_CLUT_SRC),y
    sta (POINTER_CLUT_DEST),y

    lda POINTER_CLUT_SRC
    clc
    adc #4
    sta POINTER_CLUT_SRC

    lda POINTER_CLUT_SRC + 1
    adc #0
    sta POINTER_CLUT_SRC + 1

        lda POINTER_CLUT_DEST
    clc
    adc #4
    sta POINTER_CLUT_DEST

    lda POINTER_CLUT_DEST + 1
    adc #0
    sta POINTER_CLUT_DEST + 1

    inx
    cpx #$ff
    bne _clut_row

    lda #0
    sta MMU_IO_CTRL
    rts

    clut_load_3
        lda #5
        sta mem_bank
        jsr bank2address
        lda #CLUT_IO
        sta MMU_IO_CTRL

        lda <#$A000
        sta POINTER_CLUT_SRC

        lda >#$A000
        sta POINTER_CLUT_SRC+1

        lda <#CLUT_3_ADDR
        sta POINTER_CLUT_DEST
        lda >#CLUT_3_ADDR
        sta POINTER_CLUT_DEST+1

        ldx #0
    _clut_row
        ldy #0
    _clut_loop
        lda (POINTER_CLUT_SRC),y
        sta (POINTER_CLUT_DEST),y
        iny
        lda (POINTER_CLUT_SRC),y
        sta (POINTER_CLUT_DEST),y
        iny
        lda (POINTER_CLUT_SRC),y
        sta (POINTER_CLUT_DEST),y
        iny
        lda (POINTER_CLUT_SRC),y
        sta (POINTER_CLUT_DEST),y

        lda POINTER_CLUT_SRC
        clc
        adc #4
        sta POINTER_CLUT_SRC

        lda POINTER_CLUT_SRC + 1
        adc #0
        sta POINTER_CLUT_SRC + 1

         lda POINTER_CLUT_DEST
        clc
        adc #4
        sta POINTER_CLUT_DEST

        lda POINTER_CLUT_DEST + 1
        adc #0
        sta POINTER_CLUT_DEST + 1

        inx
        cpx #$ff
        bne _clut_row

        stz MMU_IO_CTRL
        rts
