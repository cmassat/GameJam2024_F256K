.section code
print_scroll
	pha
	phx 
	phy
    jsr print_y_hi
    jsr print_y_lo
    jsr print_pumpkin_y_hi
    jsr print_pumpkin_y_lo
    jsr print_collide_y_hi
    jsr print_collide_y_lo
    jsr print_collide
	jsr print_collide1
	jsr print_row3_a
	jsr print_row3_b
	jsr print_row3_c
	jsr print_row3_d
	ply 
	plx 
	pla 
    rts

print_y_hi
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_hitbox_start_x_ovlp
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000

    lda m_hitbox_start_x_ovlp
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

    lda m_hitbox_end_x_ovlp
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C002

    lda m_hitbox_end_x_ovlp 
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

    lda m_debug_pump_y + 1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C005

    lda  m_debug_pump_y + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C006

    stz MMU_IO_CTRL
    rts

print_pumpkin_y_lo
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_debug_pump_y
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C007

    lda m_debug_pump_y
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C008

    stz MMU_IO_CTRL
    rts

print_collide_y_hi
   lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda m_p1_x + 1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C050

    lda  m_p1_x + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C051

    stz MMU_IO_CTRL
    rts
print_collide_y_lo
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda  m_p1_x
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C052

    lda  m_p1_x
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C053

    stz MMU_IO_CTRL
    rts

print_collide
    lda #2
    sta MMU_IO_CTRL

    lda #<hex_values
    sta POINTER_TXT
    lda #>hex_values
    sta POINTER_TXT + 1

    lda  m_pump_y + 1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C055

    lda m_pump_y + 1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C056

    stz MMU_IO_CTRL

    rts

print_collide1
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda  m_pump_y
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C057

    lda m_pump_y
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C058

    stz MMU_IO_CTRL
    rts

print_row3_a
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda  m_p1_y +1
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a0

    lda m_p1_y +1
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a1

    stz MMU_IO_CTRL
    rts

print_row3_b
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda  m_p1_y
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a2

    lda m_p1_y
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a3

    stz MMU_IO_CTRL
    rts

print_row3_c
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda  m_tile_num
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a5

    lda m_tile_num
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a6

    stz MMU_IO_CTRL
    rts

print_row3_d
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1

    lda  m_tile_num
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a7

    lda m_tile_num
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C0a8

    stz MMU_IO_CTRL
    rts
.endsection
.section variables
hex_values
    .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
.endsection
