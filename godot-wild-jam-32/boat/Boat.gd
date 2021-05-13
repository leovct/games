extends Node2D

onready var sail: Sprite = $Sail
onready var flag: Sprite = $Flag

func update_sail_color(new_color: Color):
	sail.modulate = new_color

func update_flag_color(new_color: Color):
	flag.modulate = new_color
