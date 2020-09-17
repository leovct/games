extends Area2D

export(int) var VELOCITY = 100

# move the bullet from the left to the right of the screen
func _process(delta):
	position.x += VELOCITY * delta

# destroy a bullet when it exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

# destroy a bullet when it collides with something
func _on_Bullet_area_entered(_area):
	queue_free()
