extends Node

onready var rocketShipAnimationPlayer: AnimationPlayer = $RocketShipAnimation
# same as onready var rocketShipAnimationPlayer = get_node("RocketShipAnimation")

func _on_LaunchButton_pressed():
	rocketShipAnimationPlayer.play("Launch")
