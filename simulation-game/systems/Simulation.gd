extends Node

const BARRIER_ID := 1
const INVISIBLE_BARRIER_ID := 2

# _x means private variable
var _tracker := EntityTracker.new()

onready var _ground := $GameWorld/GroundTiles
onready var _entity_placer := $GameWorld/YSort/EntityPlacer
onready var _player := $GameWorld/YSort/Player

func _ready() -> void:
	# replace barrier blocks (purple) by invisible barrier blocks
	var barriers: Array = _ground.get_used_cells_by_id(BARRIER_ID)
	for cell in barriers:
		_ground.set_cellv(cell, INVISIBLE_BARRIER_ID)
	
	_entity_placer.setup(_tracker, _ground, _player)
