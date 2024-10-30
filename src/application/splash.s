.section code
handle_splash
  ;  jsr is_sof
  ;  bcc _do_execute
  ;  rts
_do_execute
    jsr is_splash
    bcc _continue
    rts
_continue:
    lda keypress
    cmp #' '
    beq _change_state
	jsr is_joy_a_btn_0_pressed
	bcc _change_state
    rts
_change_state
    stz keypress
    jsr next_state
    jsr disable_video
    jsr vgm_stop
    rts

show_splash
    jsr is_splash
    bcc _continue
    rts
_continue:
    ;show splash
    jsr clut_load_0
    lda #$10
    sta $D002
    lda #$02
    sta $D003

    stz $D100
    stz $D108

    lda #$01
    sta $D100
    sta $D108
    sta $D110
    lda <#BMP_ADDR
    sta $D101
    sta $D109
    sta $D111
    lda >#BMP_ADDR
    sta $D102
    sta $D10A
    sta $D112
    lda `#BMP_ADDR
    sta $D103
    sta $D10B
    sta $D113
    jsr play_splash
    rts
.endsection
