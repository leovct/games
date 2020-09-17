extends Area2D

const ExplosionEffect = preload("res://ExplosionEffect.tscn")

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

# load explosion when the enemy dies
func _exit_tree() -> void:
	# instance a new explosion
	var explosionEffect = ExplosionEffect.instance()
	# add it as a child of the main node
	var mainNode: Node = get_tree().current_scene
	mainNode.add_child(explosionEffect)
	# set its position
	explosionEffect.global_position = global_position
	# scale the explosion by 4
	explosionEffect.scale *= 4
