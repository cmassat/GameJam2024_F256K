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
SPR_ATTR_START = $D900
.endsection
.section code
init_sprites
	ldy #0
_loop
	lda #<SPR_CTRL_00
	sta pointer 
	lda #>SPR_CTRL_00
	sta pointer + 1
	lda #0
	sta (pointer)
	lda pointer
	clc 
	adc #8
	sta pointer 
	lda pointer + 1
	adc #0
	sta pointer + 1
	iny 
	cpy #64
	bne _loop
	rts 
;a lo
;x med
;y hi
set_sprite_address
	pha 
	lda m_sprite_attr
	sta POINTER_SPR
	lda m_sprite_attr + 1
	sta POINTER_SPR + 1
	jsr sprite_inc_pointer
	pla 
	sta (POINTER_SPR)
	jsr sprite_inc_pointer
	txa 
	sta (POINTER_SPR)
	jsr sprite_inc_pointer
	tya 
	sta (POINTER_SPR)
rts

sprite_get_attr_addr
	lda m_sprite_attr
	sta POINTER_SPR
	lda m_sprite_attr + 1
	sta POINTER_SPR + 1
	rts 

sprite_inc_pointer 
	lda POINTER_SPR
	clc 
	adc #1
	sta POINTER_SPR

	lda POINTER_SPR + 1
	adc #0
	sta POINTER_SPR + 1
	rts

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

disable_sprite .macro SPR_NUM
	lda #0
	sta \SPR_NUM
.endmacro

;a register spritenumber
set_sprite_xy .macro SPR_NUM
    lda m_set_x
    sta \SPR_NUM + 4
    lda m_set_x + 1
    sta \SPR_NUM + 5

    lda m_set_y
    sta \SPR_NUM + 6
    lda m_set_y + 1
    sta \SPR_NUM + 7
.endmacro

sprite_set_x
	sta m_set_x 
	stx m_set_x + 1
	rts

sprite_set_y
	sta m_set_y
	stx m_set_y + 1
	rts 

sprite_get_x
	lda m_set_x 
	ldx m_set_x + 1
	rts 
sprite_get_y
	lda m_set_y
	ldx m_set_y + 1
	rts 

.endsection
.section variables
m_pc1_animation
    .byte 0
m_pc1_frames_animation
    .byte 0

m_sprite_attr
	.byte 0, 0
m_set_x
 .byte 0,0
m_set_y
 .byte 0,0

m_sprite_table
    .word SPR_CTRL_00,SPR_CTRL_01,SPR_CTRL_02,SPR_CTRL_03,SPR_CTRL_04
    .word SPR_CTRL_05,SPR_CTRL_06,SPR_CTRL_07,SPR_CTRL_08,SPR_CTRL_09
.endsection
