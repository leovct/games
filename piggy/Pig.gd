extends Area2D

export var SPEED: float = 3.5
# with export keyword, the variable can be modified using godot's ui

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		move(SPEED,0)
	if Input.is_action_pressed("ui_left"):
		move(-SPEED,0)
	if Input.is_action_pressed("ui_up"):
		move(0,-SPEED)
	if Input.is_action_pressed("ui_down"):
		move(0,SPEED)

func move(xVelocity: float, yVelocity: float):
	position.x += xVelocity
	position.y += yVelocity
	
