
.section variables
STATE_SPLASH    = $0
STATE_LVL1      = $1
STATE_GAME_OVER = $ff
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

set_game_over
	lda #STATE_GAME_OVER
	sta m_state 
	rts 

reset_game
	lda #STATE_SPLASH
	sta m_state
	stz m_lvl1_state
	jsr init_sprites
    jsr init_state
	jsr init_collision
    jsr init_video
    jsr clear_screen
    jsr init_events
    jsr load_sprite_npc_bin
    jsr load_sprite_npc_pal
    jsr clut_load_3
    jsr load_clut0
    jsr load_splash
    jsr show_splash
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
