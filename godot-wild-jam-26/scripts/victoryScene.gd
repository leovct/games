extends Node

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var _r = get_tree().change_scene("res://scenes/world.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")
