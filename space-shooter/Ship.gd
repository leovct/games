extends Area2D

const Bullet = preload("res://Bullet.tscn") # pack scene

export(int) var VELOCITY = 100

func _process(delta):
	# movement
	if Input.is_action_pressed("ui_up"):
		position.y -= VELOCITY * delta
	if Input.is_action_pressed("ui_down"):
		position.y += VELOCITY * delta
	# shoot
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

func shoot():
	# instance a new bullet
	var bullet = Bullet.instance()
	# add it in the scene as a child of the root node
	var rootNode = get_tree().current_scene
	rootNode.add_child(bullet)
	# set its position
	bullet.global_position = global_position


func _on_Ship_area_entered(area):
	queue_free()
	area.queue_free()
