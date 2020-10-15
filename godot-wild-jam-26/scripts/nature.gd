extends Area2D

func _on_Nature_body_entered(body):
	z_index = body.z_index - 1

func _on_Nature_body_exited(body):
	z_index = body.z_index + 1
