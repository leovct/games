extends Node

const Enemy = preload("res://scenes/enemy.tscn")
const Grass1 = preload("res://assets/grass-1.png")
const Grass2 = preload("res://assets/grass-2.png")
const Grass3 = preload("res://assets/grass-3.png")
const Grass4 = preload("res://assets/grass-4.png")
const Wood1 = preload("res://assets/wood-1.png")
const Wood2 = preload("res://assets/wood-2.png")
const Wood3 = preload("res://assets/wood-3.png")
const DeadTree = preload("res://assets/dead-tree.png")
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
onready var animation_player = $CanvasLayer/AnimationPlayer
onready var screen_shake = $Camera2D/ScreenShake
onready var die_timer = $DieTimer
onready var victory_timer = $VictoryTimer

export var WORLD_SIZE = 500
export var NBR_MAMOTHS = 20
export var NBR_MAMOTHS_KILLED = 20
export var SPAWN_MIN_RADIUS = 200
export var GRASS_INSTANCES = 1000
export var WOOD_INSTANCES = 100
export var EMPTY_RADIUS = 50

var enemies
var alive_enemies
var dead = false
var boss
var boss_spawned = false
var boss_dead = false
var victory = false

var rng = RandomNumberGenerator.new()

func _ready():
	VisualServer.set_default_clear_color(Color("#dbb991"))
	# generate grass
	generate_grass(GRASS_INSTANCES)
	generate_wood(WOOD_INSTANCES)

func _process(_delta):
	enemies = get_tree().current_scene.get_node("Enemies").get_children()
	alive_enemies = []
	for x in enemies:
		if not x.dead:
			alive_enemies.append(x)
	
	if player.score >= NBR_MAMOTHS_KILLED:
		# spawn boss mamoth
		if !boss_spawned:
			for _i in range(5):
				shake(2, 20, 6)
				animation_player.play("Die")
			spawn_boss()
			spawn_boss()
			boss_spawned = true
		else:
			shake(0.1, 15, 4)
			if boss.dead && not victory:
				victory_timer.start()
				victory = true
	
	# spawn small mamoths
	if len(alive_enemies) < NBR_MAMOTHS and len(enemies) <= 40:
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

func generate_wood(n):
	for _i in range(n):
		rng.randomize()
		var wood = choose_wood_type(rng.randi_range(1,4))
		var root_node = get_tree().current_scene
		root_node.get_node("Wood").add_child(wood)
		wood.global_position = Vector2(rand_position(EMPTY_RADIUS, WORLD_SIZE))

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

func choose_wood_type(n):
	var wood = Sprite.new()
	match n:
		1: wood.texture = Wood1
		2: wood.texture = Wood2
		3: wood.texture = Wood3
		4: wood.texture = DeadTree
	return wood

func spawn():
	var enemy = Enemy.instance()
	enemy.add_to_group("Enemy")
	var root_node = get_tree().current_scene
	root_node.get_node("Enemies").add_child(enemy)
	enemy.global_position = Vector2(rand_spawn(SPAWN_MIN_RADIUS, WORLD_SIZE), rand_spawn(SPAWN_MIN_RADIUS, WORLD_SIZE))
	enemy.connect("attack_player", self, "_on_enemy_attacked_a_player")

func spawn_boss():
	boss = Enemy.instance()
	boss.add_to_group("Enemy")
	var root_node = get_tree().current_scene
	root_node.get_node("Enemies").add_child(boss)
	boss.global_position = Vector2(rand_spawn(SPAWN_MIN_RADIUS, WORLD_SIZE), rand_spawn(SPAWN_MIN_RADIUS, WORLD_SIZE))
	boss.scale = Vector2.ONE * 5
	boss.SPEED = 3000
	boss.DAMAGE = 4
	boss.MAX_HEALTH = 10
	boss.health = 10
	boss.texture_progress.max_value = 10
	boss.connect("attack_player", self, "_on_enemy_attacked_a_player")

func rand_spawn(min_radius, max_radius):
	rng.randomize()
	var rand_pos
	if rng.randi_range(0,1):
		rand_pos = rng.randf_range(min_radius, max_radius)
	else:
		rand_pos = rng.randf_range(-max_radius, -min_radius)
	return rand_pos

func _on_enemy_attacked_a_player(damage):
	player.health -= damage
	animation_player.play("Hit")
	shake(0.1, 15, 4)
	
func shake(duration, frequency, amplitude):
	screen_shake.start(duration, frequency, amplitude, 0)

func _on_DieTimer_timeout():
	var _r = get_tree().change_scene("res://scenes/deadScene.tscn")

func _on_VictoryTimer_timeout():
	var _r = get_tree().change_scene("res://scenes/victoryScene.tscn")
