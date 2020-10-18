extends Node

const Enemy = preload("res://scenes/enemy.tscn")
const Grass1 = preload("res://assets/grass-1.png")
const Grass2 = preload("res://assets/grass-2.png")
const Grass3 = preload("res://assets/grass-3.png")
const Grass4 = preload("res://assets/grass-4.png")
const RedHeart = preload("res://assets/red-heart.png")
const GreyHeart1 = preload("res://assets/three-quarter-grey-heart.png")
const GreyHeart2 = preload("res://assets/half-grey-heart.png")
const GreyHeart3 = preload("res://assets/quarter-grey-heart.png")
const GreyHeart4 = preload("res://assets/grey-heart.png")

onready var player = $Player
onready var score_label = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/ScoreLabel
onready var heart1 = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/Heart1
onready var heart2 = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/Heart2
onready var heart3 = $CanvasLayer/MarginContainer/VBoxContainer/HBoxContainer/Heart3
onready var toofar_label = $CanvasLayer/MarginContainer/VBoxContainer/TooFarLabel
onready var animation_player = $CanvasLayer/AnimationPlayer
onready var screen_shake = $Camera2D/ScreenShake
onready var die_timer = $DieTimer

export var WORLD_SIZE = 500
export var NBR_MAMOTHS = 20
export var NBR_MAMOTHS_KILLED = 20
export var SPAWN_MIN_RADIUS = 200
export var GRASS_INSTANCES = 1000
export var EMPTY_RADIUS = 50

#var blink_timer
var enemies
var alive_enemies
var dead = false

var rng = RandomNumberGenerator.new()

func _ready():
	VisualServer.set_default_clear_color(Color("#dbb991"))
	# generate grass
	generate_grass(GRASS_INSTANCES)
	# blinking
	#blink_timer = Timer.new()
	#blink_timer.connect("timeout", self, "_on_blink_timeout")
	#var root_node = get_tree().current_scene
	#root_node.add_child(blink_timer)

func _process(_delta):
	# spawn more mamoths
	enemies = get_tree().current_scene.get_node("Enemies").get_children()
	if player.score == NBR_MAMOTHS_KILLED:
		#for x in enemies:
		#	x.queue_free()
		#for x in get_tree().current_scene.get_node("Arrows").get_children():
		#	x.queue_free()
		pass
	else:
		alive_enemies = []
		for x in enemies:
			if not x.dead:
				alive_enemies.append(x)
		if len(alive_enemies) < NBR_MAMOTHS and len(enemies) <= 30:
			spawn()
	
	# score
	score_label.text = str(player.score) + '/' + str(NBR_MAMOTHS_KILLED)
	
	# health
	var arr = update_health(player.health)
	heart1.texture = arr[0]
	heart2.texture = arr[1]
	heart3.texture = arr[2]
	
	if player.health <= 0:
		shake(0.2, 20, 6)
		animation_player.play("Die")
		if !dead:
			die_timer.start()
			dead = true
	
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")

func update_health(n):
	var red_heart = int(n / 4)
	var grey_heart = n % 4
	var arr = []
	
	for _i in range(red_heart):
		arr.append(RedHeart)
	
	match grey_heart:
		1: arr.append(GreyHeart3)
		2: arr.append(GreyHeart2)
		3: arr.append(GreyHeart1)
	
	while len(arr) < 3:
		arr.append(GreyHeart4)
	
	return arr

func generate_grass(n):
	for _i in range(n):
		rng.randomize()
		var grass = choose_grass_type(rng.randi_range(1,4))
		var root_node = get_tree().current_scene
		root_node.get_node("Grass").add_child(grass)
		grass.global_position = Vector2(rand_position(EMPTY_RADIUS, WORLD_SIZE))

func rand_position(min_radius, max_radius):
	rng.randomize()
	var rand_x
	var rand_y
	if rng.randi_range(0,1):
		if rng.randi_range(0,1):
			rand_x = rng.randf_range(-max_radius, max_radius)
			rand_y = rng.randf_range(-max_radius, -min_radius)
		else:
			rand_x = rng.randf_range(-max_radius, max_radius)
			rand_y = rng.randf_range(min_radius, max_radius)
	else:
		if rng.randi_range(0,1):
			rand_x = rng.randf_range(min_radius, max_radius)
			rand_y = rng.randf_range(-max_radius, max_radius)
		else:
			rand_x = rng.randf_range(-max_radius, -min_radius)
			rand_y = rng.randf_range(-max_radius, max_radius)
	return Vector2(rand_x, rand_y)

func choose_grass_type(n):
	var grass = Sprite.new()
	match n:
		1: grass.texture = Grass1
		2: grass.texture = Grass2
		3: grass.texture = Grass3
		4: grass.texture = Grass4
	return grass

func spawn():
	var enemy = Enemy.instance()
	enemy.add_to_group("Enemy")
	var root_node = get_tree().current_scene
	root_node.get_node("Enemies").add_child(enemy)
	enemy.global_position = Vector2(rand_spawn(SPAWN_MIN_RADIUS, WORLD_SIZE), rand_spawn(SPAWN_MIN_RADIUS, WORLD_SIZE))
	enemy.connect("attack_player", self, "_on_enemy_attacked_a_player")

func rand_spawn(min_radius, max_radius):
	rng.randomize()
	var rand_pos
	if rng.randi_range(0,1):
		rand_pos = rng.randf_range(min_radius, max_radius)
	else:
		rand_pos = rng.randf_range(-max_radius, -min_radius)
	return rand_pos

func _on_blink_timeout():
	if toofar_label.percent_visible == 1:
		toofar_label.percent_visible = 0
	else:
		toofar_label.percent_visible = 1

func start_blinking(_interval):
	toofar_label.percent_visible = 1
	#blink_timer.set_wait_time(interval)
	#blink_timer.start()

func stop_blinking():
	toofar_label.percent_visible = 0
	#blink_timer.stop()

func _on_Border_body_entered(_body):
	#if blink_timer:
	#	stop_blinking()
	pass

func _on_Border_body_exited(_body):
	start_blinking(0.5)

func _on_enemy_attacked_a_player(damage):
	player.health -= damage
	animation_player.play("Hit")
	shake(0.1, 15, 4)
	
func shake(duration, frequency, amplitude):
	screen_shake.start(duration, frequency, amplitude, 0)

func _on_DieTimer_timeout():
	var _r = get_tree().change_scene("res://scenes/deadScene.tscn")
