.section variables
SPR_MASK_SIZE_32  = $0
SPR_MASK_SIZE_24  = %00100000
SPR_MASK_SIZE_16  = %01000000
SPR_MASK_SIZE_08  = %01100000
SPR_MASK_LAYER_0  = $0
SPR_MASK_LAYER_1  = %00001000
SPR_MASK_LAYER_2  = %00010000
SPR_MASK_CLUT_2   = %00000100
SPR_MASK_CLUT_3   = %00000110
SPR_MASK_ENABLE   = %00000001
SPR_MASK_DISABLE  = %00000000
.endsection
.section code
set_sprite_addr .macro SPR_NUM, SPR_ADDR
    pha
    phy

    ldy #0
    lda #<\SPR_ADDR
    sta \SPR_NUM + 1
    iny
    lda #>\SPR_ADDR
    sta \SPR_NUM + 2
    iny
    lda #`\SPR_ADDR
    sta \SPR_NUM + 3

    ply
    pla
.endmacro

;a register spritenumber
set_npc .macro SPR_NUM
    pha
    lda #SPR_MASK_SIZE_16
    ora #SPR_MASK_LAYER_0
    ora #SPR_MASK_CLUT_3
    ora #SPR_MASK_ENABLE
    sta \SPR_NUM
    pla
.endmacro

set_pc .macro SPR_NUM
    pha
    lda #SPR_MASK_SIZE_32
    ora #SPR_MASK_LAYER_0
    ora #SPR_MASK_CLUT_2
    ora #SPR_MASK_ENABLE
    sta \SPR_NUM
    pla
.endmacro
;a register spritenumber
set_npc_xy .macro SPR_NUM
    lda m_set_x
    sta \SPR_NUM + 4
    lda m_set_x + 1
    sta \SPR_NUM + 5

    lda m_set_y
    sta \SPR_NUM + 6
    lda m_set_y + 1
    sta \SPR_NUM + 7
.endmacro

init_pc1
    #set_pc SPR_CTRL_00
    ;lda #SPR_MASK_SIZE_32
    ;ora #SPR_MASK_LAYER_0
    ;ora #SPR_MASK_CLUT_2
    ;ora #SPR_MASK_ENABLE
    ;sta SPR_CTRL_00
    lda #<SPR32_ADDR
    sta SPR_CTRL_00 + 1
    lda #>SPR32_ADDR
    sta SPR_CTRL_00 + 2
    lda #`SPR32_ADDR
    sta SPR_CTRL_00 + 3
    lda #100
    sta m_set_x
    lda #0
    sta m_set_x + 1

    lda #<FLOOR_LEVEL
    sta m_set_y
    lda #>FLOOR_LEVEL
    sta m_set_y + 1
    set_npc_xy SPR_CTRL_00
    ;lda #100
    ;sta SPR_CTRL_00 + 4
    ;lda #0
    ;sta SPR_CTRL_00 + 5

    ;lda #240-32
    ;sta SPR_CTRL_00 + 6
    ;lda #0
    ;sta SPR_CTRL_00 + 7
    stz m_pc1_animation
    stz m_pc1_frames_animation
    rts

set_frames
    inc m_pc1_frames_animation
    lda m_pc1_frames_animation
    cmp #8
    beq _increase_frame
    rts
_increase_frame
    stz m_pc1_frames_animation
    inc m_pc1_animation
    rts
.endsection
.section variables
m_pc1_animation
    .byte 0
m_pc1_frames_animation
    .byte 0

m_set_x
 .byte 0,0
m_set_y
 .byte 0,0

m_sprite_table
    .word SPR_CTRL_00,SPR_CTRL_01,SPR_CTRL_02,SPR_CTRL_03,SPR_CTRL_04
    .word SPR_CTRL_05,SPR_CTRL_06,SPR_CTRL_07,SPR_CTRL_08,SPR_CTRL_09
.endsection
