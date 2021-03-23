extends KinematicBody2D

export var movement_speed := 200.0

func _physics_process(_delta: float) -> void:
	var direction := get_direction()
	var _result = move_and_slide(direction * movement_speed)

# get_direction returns a normalized direction vector based on the key pressed by the player
func get_direction() -> Vector2:
	var horizontal_input := Input.get_action_strength("right") - Input.get_action_strength("left")
	var vertical_input := Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(horizontal_input * 2.0, vertical_input).normalized()
