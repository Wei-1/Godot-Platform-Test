extends KinematicBody2D
# Constants
const DEBUG_COUNT_LIMIT = 30
const JUMP_TIME_LIMIT = 20
const GLIDE_TIME_LIMIT = 20
const UP2D = Vector2(0, -1)
# States
enum {CRASH, FLOAT, FLYKICK, STAND, RUN, GLIDE, CROUCH, WALK, SLIDE}
enum {FACE_RIGHT, FACE_LEFT}
var state = STAND
var facing = FACE_RIGHT
# Counts
var jump_count = 0
var jump_time = 0
var debug_count = 0
var glide_time = 0
# Movement Que
var mov = Vector2()
# Movement Variables
const GRAVITY = 20
const FPS = 60
const UNIT_SPEED = 5
const BASIC_RUN_SPEED = 3 * FPS
const BASIC_WALK_SPEED = 1 * FPS
const BASIC_JUMP_SPEED_1 = 0.6 * FPS * GRAVITY
const BASIC_JUMP_SPEED_2 = 0.5 * FPS * GRAVITY
const BASIC_SLIDE_SPEED = 9 * FPS
const BASIC_GLIDE_SPEED_15C = Vector2(900, 300)
const BASIC_GLIDE_SPEED_45C = Vector2(450, 600)
const BASIC_GLIDE_SPEED_90C = Vector2(0, 900)
const BASIC_FLYKICK_SPEED = 9 * FPS
# Player State and Movement
func _physics_process(delta):
	var curpos = get_position()
	var cursta = state
	var is_dir_press = false
	var is_up_press = Input.is_action_pressed("ui_up")
	# Gravity
	mov.y += GRAVITY
	# Time Pass
	if is_on_floor():
		jump_time = 0
		jump_count = 0
		match(cursta):
			FLOAT:
				state = STAND
			FLYKICK:
				state = SLIDE
	elif jump_time > 0:
		jump_time -= 1
	else:
		match(cursta):
			CRASH, STAND, RUN, CROUCH, WALK, SLIDE:
				state = FLOAT
	if cursta == GLIDE:
		if glide_time == 0:
			state = FLOAT
		else:
			glide_time -= 1
	else:
		glide_time = 0
	# Direction
	if Input.is_action_pressed("ui_right"):
		print("right")
		facing = FACE_RIGHT
		is_dir_press = true
		match(cursta):
			STAND:
				state = RUN
			CROUCH:
				state = WALK
		if state == WALK:
			if mov.x < BASIC_WALK_SPEED:
				mov.x += min(BASIC_WALK_SPEED, BASIC_WALK_SPEED - mov.x)
			else:
				mov.x -= UNIT_SPEED
		elif state == SLIDE:
			if mov.x > 0:
				mov.x -= UNIT_SPEED
			elif mov.x < 0:
				mov.x += UNIT_SPEED
		else:
			if mov.x < BASIC_RUN_SPEED:
				mov.x += min(BASIC_RUN_SPEED, BASIC_RUN_SPEED - mov.x)
			else:
				mov.x -= UNIT_SPEED
	elif Input.is_action_pressed("ui_left"):
		print("left")
		facing = FACE_LEFT
		is_dir_press = true
		match(cursta):
			STAND:
				state = RUN
			CROUCH:
				state = WALK
		if state == WALK:
			if mov.x > -BASIC_WALK_SPEED:
				mov.x -= min(BASIC_WALK_SPEED, BASIC_WALK_SPEED + mov.x)
			else:
				mov.x += UNIT_SPEED
		elif state == SLIDE:
			if mov.x > 0:
				mov.x -= UNIT_SPEED
			elif mov.x < 0:
				mov.x += UNIT_SPEED
		else:
			if mov.x > -BASIC_RUN_SPEED:
				mov.x -= min(BASIC_RUN_SPEED, BASIC_RUN_SPEED + mov.x)
			else:
				mov.x += UNIT_SPEED
	else:
		print("no dir")
		match(cursta):
			RUN:
				state = STAND
			WALK, SLIDE:
				state = CROUCH
		if cursta == FLYKICK:
			if mov.x > 0:
				mov.x -= min(mov.x, UNIT_SPEED)
			elif mov.x < 0:
				mov.x += min(-mov.x, UNIT_SPEED)
		else:
			if mov.x > 0:
				mov.x -= min(mov.x, UNIT_SPEED * GRAVITY)
			elif mov.x < 0:
				mov.x += min(-mov.x, UNIT_SPEED * GRAVITY)
	# Jump
	if Input.is_action_just_pressed("ui_jump") && jump_count < 2:
		jump_time = JUMP_TIME_LIMIT
		jump_count += 1
		match(cursta):
			FLOAT, STAND, FLYKICK, RUN, GLIDE:
				state = FLOAT
				if jump_count == 1:
					if mov.y - BASIC_JUMP_SPEED_1 > -BASIC_JUMP_SPEED_1:
						mov.y = -BASIC_JUMP_SPEED_1
					else:
						mov.y -= BASIC_JUMP_SPEED_1 # jump speed
				else:
					if mov.y - BASIC_JUMP_SPEED_2 > -BASIC_JUMP_SPEED_2:
						mov.y = -BASIC_JUMP_SPEED_2
					else:
						mov.y -= BASIC_JUMP_SPEED_2 # jump speed
			CROUCH, SLIDE, WALK:
				state = GLIDE
				glide_time = GLIDE_TIME_LIMIT
				if is_dir_press:
					if is_up_press:
						if facing == FACE_RIGHT:
							mov.x += BASIC_GLIDE_SPEED_45C.x
							mov.y -= BASIC_GLIDE_SPEED_45C.y
						elif facing == FACE_LEFT:
							mov.x -= BASIC_GLIDE_SPEED_45C.x
							mov.y -= BASIC_GLIDE_SPEED_45C.y
					else:
						if facing == FACE_RIGHT:
							mov.x += BASIC_GLIDE_SPEED_15C.x
							mov.y -= BASIC_GLIDE_SPEED_15C.y
						elif facing == FACE_LEFT:
							mov.x -= BASIC_GLIDE_SPEED_15C.x
							mov.y -= BASIC_GLIDE_SPEED_15C.y
				else:
					mov.y -= BASIC_GLIDE_SPEED_90C.y
	# Crouch
	if Input.is_action_just_pressed("ui_crouch"):
		match(cursta):
			FLOAT, GLIDE:
				state = FLYKICK
				if facing == FACE_RIGHT:
					mov.x += BASIC_FLYKICK_SPEED
				elif facing == FACE_LEFT:
					mov.x -= BASIC_FLYKICK_SPEED
			STAND:
				state = CROUCH
			RUN:
				state = SLIDE
				if facing == FACE_RIGHT:
					mov.x = BASIC_SLIDE_SPEED
				elif facing == FACE_LEFT:
					mov.x = -BASIC_SLIDE_SPEED
	elif Input.is_action_just_released("ui_crouch"):
		match(cursta):
			CROUCH:
				state = STAND
			WALK, SLIDE:
				state = RUN
	# Slide Speed Check
	if mov.x < BASIC_WALK_SPEED && mov.x > -BASIC_WALK_SPEED: # low speed check
		match(cursta):
			SLIDE:
				state = WALK
	# Moving
	mov = move_and_slide(mov, UP2D)
	print(state2string(state) + " " + String(mov))
	pass

func state2string(s):
	var outstr = "ERROR"
	match(s):
		CRASH:
			outstr = "CRASH"
		FLOAT:
			outstr = "FLOAT"
		FLYKICK:
			outstr = "FLYKICK"
		STAND:
			outstr = "STAND"
		RUN:
			outstr = "RUN"
		GLIDE:
			outstr = "GLIDE"
		CROUCH:
			outstr = "CROUCH"
		WALK:
			outstr = "WALK"
		SLIDE:
			outstr = "SLIDE"
	return outstr

