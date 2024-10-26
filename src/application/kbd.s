is_d_pressed
    lda keypress
    cmp #$64
    beq _yes
    sec
    rts
_yes
    clc
    rts

is_shft_d_pressed
    lda keypress
    cmp #$44
    beq _yes
    sec
    rts
_yes
    clc
    rts
