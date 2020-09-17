extends Node

onready var scoreLabel: Label = $ScoreLabel

var score: int = 0 setget set_score

# update score and label using setget
func set_score(value: int) -> void:
	score = value
	scoreLabel.text = 'Score: ' + str(score)
