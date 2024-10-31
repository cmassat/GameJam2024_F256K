;.section code
vgm_start
     pha                         ; save accumulator
     php 
	 jsr vgm_on                        ; save flags
    ; sei                         ; disable interrupts

    ; copy irq_sample_counter to sample_counter
    lda evt_sample_counter
    sta sample_counter
    lda evt_sample_counter+1
    sta sample_counter+1
    lda evt_sample_counter+2
    sta sample_counter+2

     plp                         ; restore flags
     pla                         ; restore accumulator
    rts

vgm_subtract_counter
    ; save flags, then disable interrupts
    php
   ; sei
    ; subtract irq_sample_counter from sample_counter into sample_diff

    sec

    lda sample_counter
    sbc evt_sample_counter
    sta sample_diff
    lda sample_counter+1
    sbc evt_sample_counter+1
    sta sample_diff+1
    lda sample_counter+2
    sbc evt_sample_counter+2
    sta sample_diff+2

    ; restore flags
    plp

    ; if high bit of high byte of sample_diff is set, result was negative
    lda sample_diff+2
    bmi _nowait

    ; if bitwise OR of all sample_diff bytes is zero, result was zero
    ora sample_diff
    ora sample_diff+1
    beq _nowait

    ; if we got here, result was positive, so signal to wait by returning
    ; non-zero in the accumulator
    lda #$ff
    bne _done

    ; if we got here, result was not positive, so signal not to wait by
    ; returning zero in the accumulator
_nowait
    lda #0

_done

    rts

vgm_update
    lda vgm_play_flag
    beq _done
    ; if (sample_counter - irq_sample_counter) > 0, return
   jsr vgm_subtract_counter
   beq _continue
_done
   rts
_continue

playloop

    jsr mmu_read
    cmp #$66
    beq rewind
    cmp #$5a
    beq opl2_cmd
    cmp #$5e
    beq opl2_cmd
    cmp #$5f
    beq opl3_cmd
    cmp #$61
    beq delay_cmd
    cmp #$62
    beq delay_735_cmd
    cmp #$63
    beq delay_882_cmd
    bra playloop

rewind
    jsr mmu_seek
    bra playloop

opl2_cmd
    jsr mmu_read
    sta OPL3_ADDR_0
    bra opl_cmd

opl3_cmd
    jsr mmu_read
    sta OPL3_ADDR_1

opl_cmd
    jsr mmu_read
    sta OPL3_DATA
    bra playloop

delay_cmd
    jsr mmu_read
    sta delay_samp
    jsr mmu_read
    sta delay_samp+1
    bra add_delay

delay_735_cmd
    lda #<735
    sta delay_samp
    lda #>735
    sta delay_samp+1
    bra add_delay

delay_882_cmd
    lda #<882
    sta delay_samp
    lda #>882
    sta delay_samp+1
    bra add_delay

add_delay
    clc
    lda sample_counter
    adc delay_samp
    sta sample_counter
    lda sample_counter+1
    adc delay_samp+1
    sta sample_counter+1
    lda sample_counter+2
    adc #0
    sta sample_counter+2
    jmp vgm_update

end
    rts

mac_key_off .macro  channel
    lda #\channel
    sta ym_reg_opl2
    nop
    nop
    nop
    nop

    lda #0
    sta ym_reg_data

    lda #\channel
    sta ym_reg_opl3
    nop
    nop
    nop
    nop

    lda #0
    sta ym_reg_data
.endmacro


mac_key_on .macro  channel
    lda #\channel
    sta ym_reg_opl2
    nop
    nop
    nop
    nop

    lda #1
    sta ym_reg_data

    lda #\channel
    sta ym_reg_opl3
    nop
    nop
    nop
    nop

    lda #1
    sta ym_reg_data
.endmacro

sof_vgm
    ;jsr init_vgm
    clc
    lda evt_sample_counter
    adc #<SAMPLES_PER_FRAME
    sta evt_sample_counter
    lda evt_sample_counter+1
    adc #>SAMPLES_PER_FRAME
    sta evt_sample_counter+1
    lda evt_sample_counter+2
    adc #`SAMPLES_PER_FRAME ; almost certainly zero, but you never know
    sta evt_sample_counter+2
    rts

init_vgm
    stz evt_sample_counter
    stz evt_sample_counter+1
    stz evt_sample_counter+2
    rts

vgm_stop
    stz vgm_play_flag

    #mac_key_off ym_ch1_frq_kon
    #mac_key_off ym_ch2_frq_kon
    #mac_key_off ym_ch3_frq_kon
    #mac_key_off ym_ch4_frq_kon
    #mac_key_off ym_ch5_frq_kon
    #mac_key_off ym_ch6_frq_kon
    #mac_key_off ym_ch7_frq_kon
    #mac_key_off ym_ch8_frq_kon
    #mac_key_off ym_ch9_frq_kon
    rts

vgm_on
    ;stz vgm_play_flag

    #mac_key_on ym_ch1_frq_kon
    #mac_key_on ym_ch2_frq_kon
    #mac_key_on ym_ch3_frq_kon
    #mac_key_on ym_ch4_frq_kon
    #mac_key_on ym_ch5_frq_kon
    #mac_key_on ym_ch6_frq_kon
    #mac_key_on ym_ch7_frq_kon
    #mac_key_on ym_ch8_frq_kon
    #mac_key_on ym_ch9_frq_kon
    rts

vgm_play
    lda #1
    sta  vgm_play_flag
    rts

;.endsection

;.section code
data_addr = $10000
evt_sample_counter
    .byte 0,0,0
delay_samp
    .byte 0, 0
sample_counter
    .byte 0, 0, 0
sample_diff
    .byte 0, 0, 0

OPL3_ADDR_0 = $d580
OPL3_DATA = $d581
OPL3_ADDR_1 = $d582
SAMPLES_60FPS = 44100 / 60
SAMPLES_70FPS = 44100 / 70
SAMPLES_PER_FRAME = SAMPLES_60FPS ; set to match framerate

vgm_play_flag
    .byte 0

;.endsection
