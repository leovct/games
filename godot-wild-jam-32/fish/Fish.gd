class_name Fish
extends Node2D

onready var trail_particles: CPUParticles2D = $TrailParticles

export (int) var rarity = 0
export (int) var reward = 10
export (float) var size = 1.0
export (float) var weight = 1.0
export (int) var velocity = 100

const TIME_OF_TRAJECTORY_REEVALUATION: float = 3.0

var rng = RandomNumberGenerator.new()
var viewport_size: Vector2
var is_caught: bool = false
var timer: float
var trajectory: int = -1

func _ready():
	viewport_size = get_viewport().size
	scale = Vector2.ONE * 2 * size

func _physics_process(delta):	
	if not is_caught:
		manage_timer(delta)
		move_fish(delta)
		var outside_viewport = global_position.x <= - viewport_size.x /2
		if outside_viewport:
			queue_free()

func manage_timer(delta: float) -> void:
	timer += delta
	if timer > TIME_OF_TRAJECTORY_REEVALUATION:
		timer = 0
		update_fish_direction()

func update_fish_direction() -> void:
	if (rng.randi() % 2) == 0: # value between 0 and 1
		trajectory = -1
		scale.x = abs(scale.x)
	else:
		trajectory = 1
		scale.x *= -1

func move_fish(delta: float) -> void:
	global_position.x += trajectory * velocity * delta
