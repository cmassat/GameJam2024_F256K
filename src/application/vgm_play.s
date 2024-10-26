.section code
play_splash
    jsr load_splash_vgm
    jsr mmu_init ; initialize MMU library
    lda #<data_addr
    sta mmu_seekaddr
    lda #>data_addr
    sta mmu_seekaddr+1
    lda #`data_addr
    sta mmu_seekaddr+2
    jsr mmu_seek
    jsr init_vgm
    jsr vgm_start
    jsr vgm_play
    rts

play_lvl1_mus
    jsr load_lvl1_mus
    jsr mmu_init ; initialize MMU library
    lda #<data_addr
    sta mmu_seekaddr
    lda #>data_addr
    sta mmu_seekaddr+1
    lda #`data_addr
    sta mmu_seekaddr+2
    jsr mmu_seek
    jsr init_vgm
    jsr vgm_start
    jsr vgm_play
    rts

.endsection
