.section variables
PC1_SPR_WLK_0 = SPR32_ADDR
PC1_SPR_WLK_1 = PC1_SPR_WLK_0 + $400
PC1_SPR_WLK_2 = PC1_SPR_WLK_1 + $400
PC1_SPR_WLK_3 = PC1_SPR_WLK_2 + $400
PC1_SPR_WLK_4 = PC1_SPR_WLK_3 + $400
PC1_SPR_WLK_5 = PC1_SPR_WLK_4 + $400

SPR_MASK_SIZE_32  = $0
SPR_MASK_LAYER_0  = $0
SPR_MASK_LAYER_1  = %00001000
SPR_MASK_LAYER_2  = %00010000
SPR_MASK_CLUT_2   = %00000100
SPR_MASK_ENABLE   = %00000001
SPR_MASK_DISABLE  = %00000000
.endsection

set_sprite .macro SPR_NUM, SPR_ADDR
    pha
    phy
    ;lda #\SPR_NUM
    ;clc
    ;adc #\SPR_NUM
    ;tay
    ;lda #<m_sprite_table
    ;sta POINTER_SPR
    ;lda #>m_sprite_table
    ;sta POINTER_SPR + 1
    ;lda (POINTER_SPR), y
    ;sta POINTER_SPR_N
    ;iny
    ;lda (POINTER_SPR), y
    ;sta POINTER_SPR_N + 1

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

init_pc1
    lda #SPR_MASK_SIZE_32
    ora #SPR_MASK_LAYER_0
    ora #SPR_MASK_CLUT_2
    ora #SPR_MASK_ENABLE
    sta SPR_CTRL_00
    lda #<SPR32_ADDR
    sta SPR_CTRL_00 + 1
    lda #>SPR32_ADDR
    sta SPR_CTRL_00 + 2
    lda #`SPR32_ADDR
    sta SPR_CTRL_00 + 3

    lda #100
    sta SPR_CTRL_00 + 4
    lda #0
    sta SPR_CTRL_00 + 5

    lda #240-32
    sta SPR_CTRL_00 + 6
    lda #0
    sta SPR_CTRL_00 + 7
    stz m_pc1_animation
    stz m_pc1_frames_animation
    rts

handle_pc1_animation
    jsr set_frames
    lda m_pc1_animation
    cmp #5
    bne _animate
    lda #0
    sta m_pc1_animation
    rts
_animate
    lda m_pc1_animation
    cmp #0
    beq _fr0
    cmp #1
    beq _fr1
    cmp #2
    beq _fr2
    cmp #3
    beq _fr3
    cmp #4
    beq _fr4
    cmp #5
    beq _fr5
    rts
_fr0
    #set_sprite SPR_CTRL_00,  PC1_SPR_WLK_0
    rts
_fr1
    #set_sprite SPR_CTRL_00,  PC1_SPR_WLK_1
    rts
_fr2
    #set_sprite SPR_CTRL_00,  PC1_SPR_WLK_2
    rts
_fr3
    #set_sprite SPR_CTRL_00,  PC1_SPR_WLK_3
    rts
_fr4
    #set_sprite SPR_CTRL_00,  PC1_SPR_WLK_4
_fr5
    #set_sprite SPR_CTRL_00,  PC1_SPR_WLK_5
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
.section variables
m_pc1_animation
    .byte 0
m_pc1_frames_animation
    .byte 0

m_sprite_table
    .word SPR_CTRL_00,SPR_CTRL_01,SPR_CTRL_02,SPR_CTRL_03,SPR_CTRL_04
    .word SPR_CTRL_05,SPR_CTRL_06,SPR_CTRL_07,SPR_CTRL_08,SPR_CTRL_09
.endsection
