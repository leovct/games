extends KinematicBody2D

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25
export (int) var GRAVITY = 250
export (int) var JUMP_FORCE = 128
export (int) var MAX_SLOPE_ANGLE = 46

onready var sprite = $Sprite
onready var spriteAnimator = $AnimationPlayer

var motion = Vector2.ZERO

func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_forces(input_vector, delta)
	jump_check()
	update_animations(input_vector)
	motion = move_and_slide(motion, Vector2.UP)

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
	#if not is_on_floor():
	motion.y += GRAVITY * delta
	motion.y = min(motion.y, JUMP_FORCE)

func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		if Input.is_action_just_released("ui_up") && motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2

func update_animations(input_vector):
	if input_vector.x != 0:
		sprite.scale.x = sign(input_vector.x)
		spriteAnimator.play("Run")
	else:
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")
