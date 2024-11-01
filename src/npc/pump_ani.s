.section variables
	PUMP_SPEED = 8
	PUMP_FRAMES = 4
.endsection

.section code
mac_build_frames .macro vsync, frame, speed, num_of_frames
	lda \vsync
	cmp #\speed
	beq _update_frame 
	bra _skip_frame
_update_frame
	lda \frame 
	cmp #\num_of_frames
	bcs _reset_frame 
	inc \frame 
_reset_frame 
	stz \frame 
_skip_frame
.endmacro

mac_ani_up .macro dir 
	lda \dir
	cmp #DIR_UP
	bne _not_up
	
_not_up
.endmacro  

mac_ani_down .macro dir 
	lda \dir
	cmp #DIR_DN
	bne _not_down
	
	inc \frame 
_not_down
.endmacro 


proc_pump_ani
	#mac_build_frames m_pumpkin_v_sync, m_pumpkin_frame, PUMP_SPEED, PUMP_FRAMES
	rts 

handle_pump_animation
	jsr proc_pump_ani
	
	rts

.endsection 

.section variables
	m_pumpkin_v_sync
		.byte 0 
	m_pumpkin_frame
		.byte 0
	m_pumpkin_dir
		.byte 0
	m_pump_y 
		.byte 0
.endsection
