extends Area2D

const Bullet = preload("res://Bullet.tscn") # pack scene
const ExplosionEffect = preload("res://ExplosionEffect.tscn")

onready var hitSound = $ShipHitSound

export(int) var VELOCITY = 100

# handles movement and shooting
func _process(delta):
	# movement
	if Input.is_action_pressed("ui_up"):
		position.y -= VELOCITY * delta
	if Input.is_action_pressed("ui_down"):
		position.y += VELOCITY * delta
	# shoot
	if Input.is_action_just_pressed("ui_accept"):
		shoot()

# shoot a bullet
func shoot():
	# instance a new bullet
	var bullet = Bullet.instance()
	# add it in the scene as a child of the root node
	var rootNode = get_tree().current_scene
	rootNode.add_child(bullet)
	# set its position
	bullet.global_position = global_position

# handles collision between the ship and an enemy
func _on_Ship_area_entered(area):
	# destroy the enemy
	area.queue_free()
	# destroy the ship
	hitSound.play()
	yield(hitSound, "finished") # wait for the sound to end
	queue_free()

# load explosion when the enemy dies
func _exit_tree():
	# instance a new explosion
	var explosionEffect = ExplosionEffect.instance()
	# add it as a child of the main node
	var mainNode = get_tree().current_scene
	mainNode.call_deferred("add_child", explosionEffect)
	# set its position
	explosionEffect.global_position = global_position
