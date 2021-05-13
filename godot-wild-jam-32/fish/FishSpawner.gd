extends Node2D

export (int) var fish_type = 1
export (float) var SPAWN_RADIUS = 200.0
export (float) var SPAWN_TIMER = 3.0
export (int) var NUMBER_OF_ENTITIES = 10

onready var spawn_timer: Timer = $SpawnTimer

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	spawn_timer.wait_time = SPAWN_TIMER

func _on_SpawnTimer_timeout():
	if get_child_count() < NUMBER_OF_ENTITIES:
		spawn_fish()

func spawn_fish() -> void:
	var new_fish = load("res://fish/Fish" + str(fish_type) + ".tscn").instance()
	self.add_child(new_fish)
	var x_pos = rng.randf_range(-SPAWN_RADIUS, SPAWN_RADIUS)
	var y_pos = rng.randf_range(-SPAWN_RADIUS, SPAWN_RADIUS)
	new_fish.global_position += Vector2(x_pos, y_pos)
