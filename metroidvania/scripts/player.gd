extends KinematicBody2D

const DustEffect = preload('res://scenes/dustEffect.tscn')

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

onready var sprite = $Sprite
onready var spriteAnimator = $AnimationPlayer
onready var coyoteJumpTimer = $CoyoteJumpTimer # help player jump 0.2 after leaving the platform

var motion = Vector2.ZERO
var snap_vector = Vector2.ZERO
var just_jumped = false

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_forces(input_vector, delta)
	just_jumped = false
	jump_check()
	update_animations(input_vector)
	var last_position = position
	var was_on_floor = is_on_floor()
	motion = move_and_slide_with_snap(motion, snap_vector, Vector2.UP, false, 4, deg2rad(MAX_SLOPE_ANGLE))
	# just after leaving the ground
	if was_on_floor and not is_on_floor() and not just_jumped:
		coyoteJumpTimer.start()
	# small hack to prevent sliding on slopes
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		position = last_position
	# apply dust effect when landing
	if not was_on_floor and is_on_floor():
		create_dust_effect()

func get_input_vector():
	var vector = Vector2.ZERO
	vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return vector

func apply_forces(input_vector, delta):
	# apply horizontal force
	if input_vector.x != 0:
		motion.x += input_vector.x * ACCELERATION * delta
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
	# apply friction
	if input_vector.x == 0 && is_on_floor():
		motion.x = lerp(motion.x, 0, FRICTION)
	# apply gravity
	if not is_on_floor():
		motion.y += GRAVITY * delta
		motion.y = min(motion.y, JUMP_FORCE)

func jump_check():
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			snap_vector = Vector2.ZERO
			motion.y = -JUMP_FORCE
			just_jumped = true
			create_dust_effect()
	else:
		if Input.is_action_just_released("ui_up") && motion.y < -JUMP_FORCE/2:
			snap_vector = Vector2.ZERO
			motion.y = -JUMP_FORCE/2
		else:
			snap_vector = Vector2.DOWN*4

func update_animations(input_vector):
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
		spriteAnimator.play("Run")
	else:
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")

func create_dust_effect():
	var dust_position = global_position
	dust_position.x += rand_range(-4, 4)
	var dust_effect = DustEffect.instance()
	get_tree().current_scene.add_child(dust_effect)
	dust_effect.position = dust_position
