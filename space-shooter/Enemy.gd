extends Area2D

export(int) var VELOCITY = 100

func _process(delta):
	position.x -= VELOCITY * delta
