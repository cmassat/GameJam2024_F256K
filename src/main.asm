

*=$1000
.dsection variables

* =$2000
.dsection code
.section code
start
    jmp main
main
    nop
    stz m_lvl1_state
    jsr init_state
    jsr init_video
    jsr clear_screen
    jsr init_events
    jsr load_clut0
    jsr load_splash
    jsr show_splash
    jsr set_frame_timer
    jsr handle_events
rts
.endsection

.include "./inc/includes.s"
.include "./application/app.s"
.include "./npc/npc.s"
