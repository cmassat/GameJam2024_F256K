.section code
print_scroll
    jsr print_anim
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1


    lda m_state
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C000


    lda m_state
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C001

    stz MMU_IO_CTRL
    rts

print_anim
    lda #2
    sta MMU_IO_CTRL

    lda <#hex_values
    sta POINTER_TXT
    lda >#hex_values
    sta POINTER_TXT + 1


    lda sof_semaphore
    lsr
    lsr
    lsr
    lsr
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C004


    lda sof_semaphore
    and #$0f
    tay
    lda (POINTER_TXT), y
    sta $C005

    stz MMU_IO_CTRL
    rts
.endsection
.section variables
hex_values
    .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'
.endsection
