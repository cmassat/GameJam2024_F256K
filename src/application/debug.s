.section code
print_scroll
    jsr print_y_hi
    jsr print_y_lo
    jsr print_pumpkin_y_hi
    jsr print_pumpkin_y_lo
    jsr print_collide_y_hi
    jsr print_collide_y_lo
    jsr print_collide
    rts

print_y_hi
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_x_start +1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000

    lda m_collide_x_start + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C001

    stz MMU_IO_CTRL
    rts

print_y_lo
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_x_start
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C002

    lda m_collide_x_start
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C003

    stz MMU_IO_CTRL
    rts

print_pumpkin_y_hi
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_x_end + 1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 5

    lda m_collide_x_end + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 6

    stz MMU_IO_CTRL
    rts

print_pumpkin_y_lo
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_x_end
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 7

    lda m_collide_x_end
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 8

    stz MMU_IO_CTRL
    rts

print_collide_y_hi
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_y_start + 1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 80

    lda m_collide_y_start + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 81

    stz MMU_IO_CTRL
    rts
print_collide_y_lo
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_y_start
    lsr
    lsra
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 82

    lda m_collide_y_start
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 83

    stz MMU_IO_CTRL
    rts

print_collide
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_y_end + 1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 85

    lda m_collide_y_end + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 86

    stz MMU_IO_CTRL
	jsr print_collide1
    rts

print_collide1
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_collide_y_end
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 87

    lda m_collide_y_end
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000 + 88

    stz MMU_IO_CTRL
    rts
.endsection
.section variables
hex_values
    .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
.endsection
