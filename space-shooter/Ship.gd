extends Area2D

export(int) var VELOCITY = 100

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= VELOCITY * delta
	if Input.is_action_pressed("ui_down"):
		position.y += VELOCITY * delta
