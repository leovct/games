extends Node

onready var player = $Player
onready var score_label = $CanvasLayer/MarginContainer/HBoxContainer/ScoreLabel

func _ready():
	VisualServer.set_default_clear_color(Color("#f1ca76"))

func _process(_delta):
	score_label.text = str(player.score)
	
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")
