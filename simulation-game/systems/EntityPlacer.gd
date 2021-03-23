extends TileMap

const MAX_PLACEMENT_DISTANCE := 300
const POSITION_OFFSET := Vector2(0,25)

onready var _stirling_engine := preload("res://entities/StirlingEngineEntity.tscn")
onready var _stirling_engine_blueprint := preload("res://entities/StirlingEngineBlueprint.tscn")

var _tracker: EntityTracker
var _ground: TileMap
var _player: KinematicBody2D
var _blueprint # TODO: Add type

# setup sets up the EntityPlacer by listing all the entities present on the TileMap
func setup(tracker: EntityTracker, ground: TileMap, player: KinematicBody2D):
	_tracker = tracker
	_ground = ground
	_player = player

	for child in get_children():
		if child is Entity:
			var map_position := world_to_map(child.global_position)
			tracker.place_entity(child, map_position)

func _unhandled_input(event: InputEvent):
	var mouse_position := get_global_mouse_position()
	
	var is_close_to_player := mouse_position.distance_to(_player.global_position) <= MAX_PLACEMENT_DISTANCE

	var cellv := world_to_map(mouse_position)
	var is_cell_occupied := _tracker.is_cell_occupied(cellv)

	var is_on_ground := _ground.get_cellv(cellv) == 0

	# Place a new entity
	if event.is_action_pressed("left_click"):
		if not is_cell_occupied and is_close_to_player and is_on_ground:
			var new_entity := _stirling_engine.instance()
			add_child(new_entity)
			new_entity.global_position = map_to_world(cellv) + POSITION_OFFSET
			_tracker.place_entity(new_entity, cellv)
	
	# Remove an entity
	elif event.is_action_pressed("right_click"):
		if is_cell_occupied and is_close_to_player and is_on_ground:
			var entity := _tracker.get_entity_at(cellv)
			entity.queue_free()
			_tracker.remove_entity(cellv)
	
	# select blueprint
	elif event.is_action_pressed("ui_accept"):
		_blueprint = _stirling_engine_blueprint.instance()
		add_child(_blueprint)
		_blueprint.global_position = map_to_world(cellv) + POSITION_OFFSET
		
		# Tint according to whether the current cell is valid or not.
		if not is_cell_occupied and is_close_to_player and is_on_ground:
			_blueprint.modulate = Color.white
		else:
			_blueprint.modulate = Color.red
		#move_blueprint(cellv, not is_cell_occupied and is_close_to_player and is_on_ground)

	# Move mouse with blueprint
	elif event is InputEventMouseMotion:
		if _blueprint != null:
			move_blueprint(cellv, not is_cell_occupied and is_close_to_player and is_on_ground)
		

func move_blueprint(cellv: Vector2, b: bool) -> void:
	_blueprint.global_position = map_to_world(cellv) + POSITION_OFFSET
		
	# Tint according to whether the current cell is valid or not.
	if b:
		_blueprint.modulate = Color.white
	else:
		_blueprint.modulate = Color.red
