extends Area2D

const ExplosionEffect = preload("res://ExplosionEffect.tscn")

export(int) var VELOCITY = 100
export(int) var HEALTH = 3

onready var hitSound = $HitSound

# move the enemy from the right to the left of the screen
func _process(delta):
	position.x -= VELOCITY * delta

# handles colision between an enemy and a bullet
func _on_Enemy_area_entered(_area):
	# decrease the enemy's health
	HEALTH -= 1
	hitSound.play()
	if HEALTH <= 0:
		# increase player's score
		var mainNode = get_tree().current_scene
		if mainNode.is_in_group("World"):
			mainNode.score += 10 * scale.x
		# destroy the enemy
		# instance a new explosion
		var explosionEffect = ExplosionEffect.instance()
		# add it as a child of the main node
		mainNode.call_deferred("add_child", explosionEffect)
		# set its position
		explosionEffect.global_position = global_position
		queue_free()

# destroy an enemy when it exits the screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()
