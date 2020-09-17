extends Node

onready var scoreLabel = $ScoreLabel

var score = 0 setget set_score

# update score and label using setget
func set_score(value: int):
	score = value
	scoreLabel.text = 'Score: ' + str(score)
