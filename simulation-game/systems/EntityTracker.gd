# Sub-class of the simulation that keeps track of all entities and their location using dictionary 
# keys. Emits signals when the player places or removes entities.
class_name EntityTracker
extends Reference

var entities := {}

# place_entity places an entity on the TileMap
func place_entity(entity: Node2D, cellv: Vector2) -> void:
	# If the cell is already taken, do nothing
	if is_cell_occupied(cellv):
		return
	
	entities[cellv] = entity
	Events.emit_signal("entity_placed", entity, cellv)

# remove_entity removes an entity of the TileMap
func remove_entity(cellv: Vector2) -> void:
	# If the cell is not already taken, do nothing
	if not is_cell_occupied(cellv):
		return
	
	var entity = entities[cellv]
	var _result := entities.erase(cellv)
	Events.emit_signal("entity_removed", entity, cellv)
	entity.queue_free()

# is_cell_occupied checks if there is already an entity placed on the cell
func is_cell_occupied(cellv: Vector2) -> bool:
	return entities.has(cellv)

# get_entity_at returns the entity placed on the cell (returns null if there is none)
func get_entity_at(cellv: Vector2) -> Node2D:
	if is_cell_occupied(cellv):
		return entities[cellv]
	return null
