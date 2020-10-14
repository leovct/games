extends Area2D

export(int) var SPEED = 100

func _process(delta):
	position += transform.x * SPEED * delta
	#position.x += VELOCITY * delta
	#print(get_global_mouse_position())
	#var target = get_global_mouse_position()
	#position -= (position - target).normalized()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#func _on_Bullet_area_entered(_area):
	#queue_free()
