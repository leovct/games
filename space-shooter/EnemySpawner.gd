extends Node

const Enemy = preload("res://Enemy.tscn")

onready var spawnPoints = $SpawnPoints

# get a random spawn point out of all the spawn points
func get_spawn_point() -> Vector2:
	var points: Array = spawnPoints.get_children()
	points.shuffle()
	return points[0].global_position

# spawn an enemy on the screen
func spawn_enemy() -> void:
	# instance a new enemy
	var enemy = Enemy.instance()
	# add it has a child of the main node
	var mainNode = get_tree().get_current_scene()
	mainNode.add_child(enemy)
	# set its position to one of the spawn points
	enemy.global_position = get_spawn_point()
	# scale the enemy by 4
	enemy.scale *= 4

# timer called every x seconds
func _on_Timer_timeout() -> void:
	spawn_enemy()
