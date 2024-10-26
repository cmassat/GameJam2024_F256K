.section code
;A = lo_file_name
;X = hi_file_name
fopen
	sty mem_bank
	sta POINTER_FILE
	stx POINTER_FILE + 1
	jsr bank2address

	ldy #0
_file_len_lp
	lda (POINTER_FILE),y
	beq _set_len
	iny
	bra _file_len_lp
_set_len
	sty kernel.args.file.open.fname_len

	lda POINTER_FILE
	sta kernel.args.file.open.fname
    lda POINTER_FILE + 1
	sta kernel.args.file.open.fname + 1


    lda #0 ; read
    sta kernel.args.file.open.mode
    lda #0 ; drive number 0 = sd card
    sta kernel.args.file.open.drive

_try_again
    jsr kernel.File.Open
    sta file_handle
    bcc _it_opened
   ; jsr print_open_err
    rts
_it_opened
_event_open_loop
        jsr     kernel.NextEvent
        bcs     _event_open_loop

        lda event.type
        cmp     #kernel.event.file.OPENED
        beq     _fread
        cmp     #kernel.event.file.NOT_FOUND
        beq     _file_open_error
        cmp     #kernel.event.file.ERROR
        beq     _file_open_error
        bra _event_open_loop
_file_open_error
       ; jsr print_open_err
    rts
_fread
   ; jsr print_open_ok
   ; jsr print_file_handle
    lda file_handle
    sta kernel.args.file.read.stream
    lda     #<event
    sta     kernel.args.events
    lda     #>event
    sta     kernel.args.events+1

    lda #<$a000
    sta kernel.args.recv.buf
    lda #>$a000
    sta kernel.args.recv.buf + 1
    jsr reset_dest

    lda #f_buffer
    sta kernel.args.buflen

    lda  #f_buffer ; just going to read 1 byte at a time
    sta kernel.args.file.read.buflen

    lda file_handle
    sta kernel.args.file.read.stream
_try_read
    jsr kernel.File.Read
    bcs _close_file

_event_loop
    ; Get the next event.
    jsr		kernel.NextEvent
    bcs		_event_loop

    lda event.type
    cmp #kernel.event.file.EOF
    beq _eof
    ; cmp #kernel.event.file.OPENED
    ; beq _eof
    cmp #kernel.event.file.ERROR
    beq _read_error
    cmp #kernel.event.file.DATA
    beq _read_success
    bra _event_loop
_done_done
_no_more_events
    ;jsr print_done
    rts
_eof
   ; jsr sum_bytes_read
    jsr kernel.ReadData
   ; jsr print_data
   ; jsr print_eof
    jsr fclose
    rts

_close_file
   ; jsr print_close_early
    jsr fclose
    rts

_read_success
    ;jsr sum_bytes_read
  ;  jsr print_read_ok
   ; jsr print_read_file_handle
    jsr kernel.ReadData
    ;jsr reset_buffer
   ; jsr print_mmu
	jsr sum_bytes_read
    lda bytes_received
    sta kernel.args.recv.buf
    lda bytes_received + 1
    sta kernel.args.recv.buf + 1
   ; inc m_reads
   ; cmp #2
   ; beq _end_read_test
   bra _try_read
_end_read_test
    rts
_read_error
    ;jsr print_read_err
    ;jsr print_read_file_handle
    jsr fclose

    rts

fclose
    lda file_handle
    sta kernel.args.file.close.stream
    jmp kernel.File.Close
    rts


sum_bytes_read
    lda bytes_received
	clc
	adc kernel.args.recv.buflen
	sta bytes_received

	lda bytes_received + 1
	adc #0
	sta bytes_received + 1


	lda bytes_received + 1
	cmp #$c0
	beq _change_banks
    rts
_change_banks
    inc change_bank_count
	inc mem_bank
	jsr bank2address
	jsr reset_dest
	rts

reset_buffer
 ;   lda #<$7FC0
 ;   sta kernel.args.buf
 ;   lda #>$7FC0
 ;   sta kernel.args.buf + 1
rts
reset_dest
	lda #<$a000
    sta bytes_received
    lda #>$a000
    sta bytes_received + 1
	rts

bank2address
	lda #$b3
	sta MMU_MEM_CTRL
	lda mem_bank
	sta $0D ; A0000
	rts

block2bank
	tay
	lda #>tbl_block_bank
	lda POINTER_MMU
	lda #<tbl_block_bank
	lda POINTER_MMU + 1
	lda (POINTER_MMU),y
	sta mem_bank
	rts
.endsection

.section variables
f_buffer = 64
mem_block_size = $2000
num_bytes_to_read = $40 ; 64 best for iec compatibility
tbl_block_bank
	;user space
	.byte $00, $08, $10, $18, $20, $28, $30, $38
	; flash space
	.byte $40, $48, $50, $58, $60, $68, $70, $78
	; hi ram
	.byte $80, $88, $90, $98



bytes_received
    .byte 0,0
change_bank_count
    .byte 0
mem_bank
	.byte 0
mem_block
	.byte 0
bytes_read
    .byte 0,0
event_count
    .byte 0
splash
    .text "rick.bin"
splash_end
splash_len
    .byte splash_end - splash

file_handle
    .byte 0
.endsection