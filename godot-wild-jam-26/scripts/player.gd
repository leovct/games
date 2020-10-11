extends KinematicBody2D

export onready var sprite = $Sprite
export onready var animationPlayer = $AnimationPlayer
export var MOVE_SPEED = 200

func _physics_process(delta):
	var move = Vector2()
	
	if Input.is_action_pressed("ui_right"):
		move.x += 1
		sprite.flip_h = 0
	if Input.is_action_pressed("ui_left"):
		move.x -= 1
		sprite.flip_h = 1
	if Input.is_action_pressed("ui_up"):
		move.y -= 1
	if Input.is_action_pressed("ui_down"):
		move.y += 1
	move = move.normalized()
	if move != Vector2.ZERO:
		animationPlayer.play("Run")
	else:
		animationPlayer.play("Idle")
	move_and_collide(move * MOVE_SPEED * delta)
	
