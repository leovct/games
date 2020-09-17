extends Area2D

export(int) var VELOCITY = 100
export(int) var HEALTH = 3

# move the enemy from the right to the left of the screen
func _process(delta) -> void:
	position.x -= VELOCITY * delta

# handles colision between an enemy and a bullet
func _on_Enemy_area_entered(area) -> void:
	# destroy the bullet
	area.queue_free()
	# decrease the enemy's health
	HEALTH -= 1
	if HEALTH <= 0:
		queue_free()

# destroy an enemy when it exits the screen
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
