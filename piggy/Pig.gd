extends Area2D

export var SPEED: float = 150
# with export keyword, the variable can be modified using godot's ui

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		move(SPEED, 0, delta)
	if Input.is_action_pressed("ui_left"):
		move(-SPEED, 0, delta)
	if Input.is_action_pressed("ui_up"):
		move(0, -SPEED, delta)
	if Input.is_action_pressed("ui_down"):
		move(0, SPEED, delta)

func move(xVelocity: float, yVelocity: float, delta: float):
	position.x += xVelocity * delta
	position.y += yVelocity * delta
	
