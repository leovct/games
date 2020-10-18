extends Node

onready var text = $CenterContainer/VBoxContainer/Text

var space_pressed = 0

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if not space_pressed:
			text.text = "Move: Arrows\nShoot: Right Click"
			space_pressed += 1
		else:
			var _r = get_tree().change_scene("res://scenes/world.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")
