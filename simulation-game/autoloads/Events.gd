extends Node

# entity_placed is emitted when the player places an entity
signal entity_placed(entity, cellv)

# entity_removed is emitted when the player removes an entity
signal entity_removed(entity, cellv)
