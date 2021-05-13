extends Sprite

var rng = RandomNumberGenerator.new()
var horizontal_velocity: float
var viewport_size: Vector2

func _ready():
	rng.randomize()
	horizontal_velocity = rng.randf_range(-100, 100)
	viewport_size = get_viewport().size

func _process(delta):
	var outside_viewport = global_position.x <= - viewport_size.x /2
	if outside_viewport:
		horizontal_velocity *= -1
	global_position.x += delta * horizontal_velocity
