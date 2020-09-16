extends Area2D

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite

export var SPEED: float = 150
# with export keyword, the variable can be modified using godot's ui

var moving: bool = false

func _process(delta):
	moving = false
	if Input.is_action_pressed("ui_right"):
		move(SPEED, 0, delta)
		sprite.flip_h = false
	if Input.is_action_pressed("ui_left"):
		move(-SPEED, 0, delta)
		sprite.flip_h = true
	if Input.is_action_pressed("ui_up"):
		move(0, -SPEED, delta)
	if Input.is_action_pressed("ui_down"):
		move(0, SPEED, delta)
		
	if moving:
		animationPlayer.play("Run")
	else:
		animationPlayer.play("Idle")

func move(xVelocity: float, yVelocity: float, delta: float):
	position.x += xVelocity * delta
	position.y += yVelocity * delta
	moving = true
