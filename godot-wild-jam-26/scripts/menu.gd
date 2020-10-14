extends Node

onready var start_label = $VBoxContainer/Start

var blink_timer

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		var _r = get_tree().change_scene("res://scenes/world.tscn")
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _ready():
	blink_timer = Timer.new()
	blink_timer.connect("timeout", self, "_on_blink_timeout")
	add_child(blink_timer)
	start_blinking(0.5)

func _on_blink_timeout():
	if start_label.percent_visible == 1:
		start_label.percent_visible = 0
	else:
		start_label.percent_visible = 1

func start_blinking(interval):
	blink_timer.set_wait_time(interval)
	blink_timer.start()

func stop_blinking():
	start_label.percent_visible = 1
	blink_timer.stop()
