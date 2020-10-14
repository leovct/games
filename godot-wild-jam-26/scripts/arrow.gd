extends Area2D

export(int) var SPEED = 200

var hit = false

func _process(delta):
	position += transform.x * SPEED * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Arrow_body_entered(body):
	if body.is_in_group("Enemy") && !hit:
		SPEED = 0
		z_index = body.z_index + 1
		body.dead = true
		hit = true
