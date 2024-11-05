.section code
handle_events
    jsr vgm_update
	jsr is_q_pressed
	bcs _go 
	jsr reset_game
_go 
	lda sof_semaphore
    cmp #0
    bne _wait_for_event
	lda #1
	sta sof_semaphore
	jsr handle_pumpkin
	jsr handle_joy_ports
    jsr handle_splash
    jsr handle_lvl1
	
	jsr handle_gems
	jsr show_score
	
_wait_for_event 
; Peek at the queue to see if anything is pending
    lda		kernel.args.events.pending  ; Negated count
    bpl		_done

    ; Get the next event.
    jsr		kernel.NextEvent
    bcs		_done

    ; Handle the event
    jsr		_dispatch
 _done
        ; Continue until the queue is drained.

    bra		handle_events
    rts

 _dispatch
   ; Get the event's type
   lda		event.type

   ; Call the appropriate handler
   cmp		#kernel.event.key.PRESSED
   beq		key_pressed

   cmp #kernel.event.key.RELEASED
   beq		key_released

   cmp     #kernel.event.timer.EXPIRED
   beq		handle_timer_event
   rts

key_pressed
   lda event.key.ascii
   sta keypress
   rts     ; Anything not handled can be ignored.

key_released
    lda #0
    sta keypress
    rts

handle_timer_event
    jsr sof_vgm
	stz sof_semaphore
	jsr set_frame_timer
	rts

set_frame_timer
    lda #0
	sta MMU_IO_CTRL
    lda #kernel.args.timer.FRAMES | kernel.args.timer.QUERY
    sta kernel.args.timer.units

    stz kernel.args.timer.absolute
    lda #1
    sta kernel.args.timer.cookie
    jsr kernel.Clock.SetTimer

    adc #1
    sta kernel.args.timer.absolute

    lda #kernel.args.timer.FRAMES
    sta kernel.args.timer.units

    lda #1
    sta kernel.args.timer.cookie
    jsr kernel.Clock.SetTimer
    rts

init_events
    lda     #<event
    sta     kernel.args.events+0
    lda     #>event
    sta     kernel.args.events+1
    rts

is_sof
    lda sof_semaphore
    cmp #0
    beq _lock
    clc
    rts
_lock
    sec
    rts
.endsection

.section variables
sof_semaphore
    .byte 0
keypress
    .byte 0

v_sync
    .byte 0

event	.dstruct	 kernel.event.event_t
.endsection
