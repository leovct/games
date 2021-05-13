extends Node2D

var sfx_sounds: Array

func _ready():
	sfx_sounds = get_children()

func update_sfx_volume(new_value: float):
	var db_volume = int((new_value - 50) / 10) * 3
	for sfx_sound in sfx_sounds:
		var sfx_sound_position = sfx_sound.get_playback_position()
		if db_volume == -15:
			sfx_sound.volume_db = -80.0
		else:
			sfx_sound.playing = true
			sfx_sound.volume_db = db_volume
			sfx_sound.play(sfx_sound_position)
