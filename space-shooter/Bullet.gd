extends Area2D

export(int) var VELOCITY = 200

func _process(delta):
	position.x += VELOCITY * delta
