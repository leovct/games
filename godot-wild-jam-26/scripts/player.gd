extends KinematicBody2D

export onready var sprite = $Sprite
export onready var animationPlayer = $AnimationPlayer
export onready var collisionShape = $CollisionPolygon2D

export var MOVE_SPEED = 200

enum States {IDLE, RUN, SHOOT}
var state

func _ready():
	state = States.IDLE

func _physics_process(delta):
	match state:
		States.IDLE:
			idle()
		States.RUN:
			run(delta)
		States.SHOOT:
			animationPlayer.play("Shoot")

func idle():
	animationPlayer.play("Idle")
	if Input.is_action_just_pressed("shoot"):
		state = States.SHOOT
	elif Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up") or Input.is_action_pressed("ui_down"):
		state = States.RUN

func run(delta):
	var move = Vector2()
	if Input.is_action_pressed("ui_right"):
		move.x += 1
		sprite.flip_h = 0
		collisionShape.scale.x = 1
	if Input.is_action_pressed("ui_left"):
		move.x -= 1
		sprite.flip_h = 1
		collisionShape.scale.x = -1
	if Input.is_action_pressed("ui_up"):
		move.y -= 1
	if Input.is_action_pressed("ui_down"):
		move.y += 1
	move = move.normalized()
	
	if Input.is_action_just_pressed("shoot"):
			state = States.SHOOT
	
	if move != Vector2.ZERO:
		animationPlayer.play("Run")
	else:
		state = States.IDLE
	
	var _return = move_and_collide(move * MOVE_SPEED * delta)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Shoot":
		state = States.IDLE
