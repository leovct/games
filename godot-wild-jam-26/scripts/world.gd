extends Node

onready var player = $Player
onready var score_label = $CanvasLayer/ScoreLabel

func _ready():
	VisualServer.set_default_clear_color(Color("#f1ca76"))

func _process(_delta):
	score_label.text = 'Score: ' + str(player.score)
