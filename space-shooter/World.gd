extends Node

onready var scoreLabel = $ScoreLabel

var score = 0 setget set_score

# update score and label using setget
func set_score(value: int):
	score = value
	scoreLabel.text = 'Score: ' + str(score)

func update_save_data():
	var data = SaveAndLoad.load_data_from_file()
	if score >  data.highscore:
		data.highscore = score
		SaveAndLoad.save_data_to_file(data)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_Ship_player_death():
	update_save_data()
	# change to the game over scene
	yield(get_tree().create_timer(1), "timeout")
	var _r = get_tree().change_scene("res://GameOver.tscn")
