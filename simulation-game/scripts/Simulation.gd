extends Node

const BARRIER_ID := 1
const INVISIBLE_BARRIER_ID := 2

onready var ground := $GameWorld/GroundTiles

func _ready() -> void:
	# replace barrier blocks (purple) by invisible barrier blocks
	var barriers: Array = ground.get_used_cells_by_id(BARRIER_ID)
	for cell in barriers:
		ground.set_cellv(cell, INVISIBLE_BARRIER_ID)
