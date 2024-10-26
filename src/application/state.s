
.section variables
STATE_SPLASH    = $0
STATE_LVL1      = $1
.endsection
.section code
init_state
    lda #STATE_SPLASH
    sta m_state
    rts

next_state
    clc
    lda m_state
    clc
    adc #1
    sta m_state
    rts

is_splash
    lda m_state
    cmp #STATE_SPLASH
    beq _yes
    sec
    rts
_yes
    clc
    rts

;A register
is_state
    cmp m_state
    beq _yes
    sec
    rts
    _yes
    clc
    rts
.endsection
.section variables
m_state
    .byte 0
.endsection
