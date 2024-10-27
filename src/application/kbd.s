is_a_pressed
    lda keypress
    cmp #'a'
    beq _yes
    sec
    rts
_yes
    clc
    rts

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

is_j_pressed
    lda keypress
    cmp #$6A
    beq _yes
    sec
    rts
_yes
    clc
    rts

is_s_pressed
    lda keypress
    cmp #'s'
    beq _yes
    sec
    rts
_yes
    clc
    rts

is_q_pressed
    lda keypress
    cmp #'s'
    beq _yes
    sec
    rts
_yes
    clc
    rts
