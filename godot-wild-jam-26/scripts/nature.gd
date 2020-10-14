extends Area2D

func _on_Nature_body_entered(body):
	body.z_index = z_index + 1

func _on_Nature_body_exited(body):
	body.z_index -= 1
