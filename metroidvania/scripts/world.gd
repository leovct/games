extends Node

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")
