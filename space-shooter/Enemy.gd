extends Area2D

export(int) var VELOCITY = 100
export(int) var HEALTH = 3

func _process(delta):
	position.x -= VELOCITY * delta


func _on_Enemy_area_entered(area):
	area.queue_free()
	HEALTH -= 1
	if HEALTH <= 0:
		queue_free()


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
