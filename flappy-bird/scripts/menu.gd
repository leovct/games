extends Node

const Start1 = preload("res://assets/sprites/ui/tap-bird-1.png")
const Start2 = preload("res://assets/sprites/ui/tap-bird-2.png")

onready var tap_bird: TextureRect = $MarginContainer/VBoxContainer/VBoxContainer/TapBird
onready var tap_bird_timer: Timer = $TapBirdTimer
onready var click_sfx: AudioStreamPlayer2D = $ClickSFX
onready var music: AudioStreamPlayer2D = $Music

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func _on_Play_pressed():
	click_sfx.play()
	var _r = get_tree().change_scene("res://scenes/world.tscn")

func _on_Rate_pressed():
	click_sfx.play()

func _on_TapBirdTimer_timeout():
	tap_bird_timer.start()
	# change the illustration texture
	if tap_bird.texture == Start1:
		tap_bird.texture = Start2
	else:
		tap_bird.texture = Start1

func _on_Music_finished():
	music.play()
