extends Entity

const BOOTUP_TIME := 6.0

onready var animation_player := $AnimationPlayer
onready var tween := $Tween
onready var piston_shaft := $PistonShaft

func _ready() -> void:
	animation_player.play("Piston running")
	
	# Tween controls the speed of the animation and the color of the piston shaft
	tween.interpolate_property(animation_player, "playback_speed", 0, 1, BOOTUP_TIME)
	tween.interpolate_property(piston_shaft, "modulate", Color.white, Color(0.5, 1, 0.5), BOOTUP_TIME)
	tween.start()
