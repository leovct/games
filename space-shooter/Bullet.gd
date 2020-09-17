extends Area2D

export(int) var VELOCITY = 200

# move the bullet from the left to the right of the screen
func _process(delta) -> void:
	position.x += VELOCITY * delta

# destroy a bullet when it exits the screen
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
