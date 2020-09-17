extends Node

onready var highscoreLabel = $HighscoreLabel

func _ready():
	var data = SaveAndLoad.load_data_from_file()
	highscoreLabel.text = 'Highscore: ' + str(data.highscore)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var _r = get_tree().change_scene("res://World.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
