.section code
load_clut0
    lda #<splash_pal
    ldx #>splash_pal
    ldy #$05
    jsr fopen
    rts

load_splash
    lda #<splash_bin
    ldx #>splash_bin
    ldy #BMP_BANK
    jsr fopen
    rts

load_splash_vgm
    lda #<splash_vgm
    ldx #>splash_vgm
    ldy #VGM_BANK
    jsr fopen
    rts

load_lvl1_set
    lda <#lvl1_set
    ldx >#lvl1_set
    ldy #SET_BANK
    jsr fopen
    rts

load_lvl1_pal
    lda <#lvl1_pal
    ldx >#lvl1_pal
    ldy #PAL_BANK
    jsr fopen
    rts

load_lvl1_map
    lda <#lvl1_map
    ldx >#lvl1_map
    ldy #MAP_BANK
    jsr fopen
    rts

load_lvl1_bak_pal
    lda <#lvl1_bak_pal
    ldx >#lvl1_bak_pal
    ldy #$05
    jsr fopen
    rts

load_lvl1_bak_bin
    lda <#lvl1_bak_bin
    ldx >#lvl1_bak_bin
    ldy #BMP_BANK
    jsr fopen
    rts

load_lvl1_mus
    lda <#lvl1_mus
    ldx >#lvl1_mus
    ldy #VGM_BANK
    jsr fopen
    rts

load_sprite_bin
    lda <#sprite_bin
    ldx >#sprite_bin
    ldy #SPR_BANK
    jsr fopen
    rts

load_sprite_pal
    lda <#sprite_pal
    ldx >#sprite_pal
    ldy #PAL_BANK
    jsr fopen
    rts
.endsection

.section variables
splash_bin
    .text "splash.bin",0

splash_pal
    .text "splash.pal",0
splash_vgm
    .text "hallow.mus",0
lvl1_set
    .text "lvl1.set",0

lvl1_pal
    .text "lvl1.pal",0

lvl1_map
    .text "lvl1.map",0

lvl1_bak_pal
    .text "bak.pal",0

lvl1_mus
    .text "beetle.mus",0

lvl1_bak_bin
    .text "bak.bin",0
sprite_bin
    .text "sprite.bin",0

sprite_pal
    .text "sprite.pal",0
.endsection
