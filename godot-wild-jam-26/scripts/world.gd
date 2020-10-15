extends Node

onready var player = $Player
onready var score_label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
onready var toofar_label = $CanvasLayer/MarginContainer/VBoxContainer/TooFarLabel

var blink_timer = null

func _ready():
	VisualServer.set_default_clear_color(Color("#dbb991"))
	# blinking
	blink_timer = Timer.new()
	blink_timer.connect("timeout", self, "_on_blink_timeout")
	add_child(blink_timer)

func _process(_delta):
	score_label.text = str(player.score)
	
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")

func _on_blink_timeout():
	if toofar_label.percent_visible == 1:
		toofar_label.percent_visible = 0
	else:
		toofar_label.percent_visible = 1

func start_blinking(interval):
	toofar_label.percent_visible = 1
	blink_timer.set_wait_time(interval)
	blink_timer.start()

func stop_blinking():
	toofar_label.percent_visible = 0
	blink_timer.stop()

func _on_Border_body_entered(_body):
	if blink_timer:
		stop_blinking()

func _on_Border_body_exited(_body):
	start_blinking(0.5)
