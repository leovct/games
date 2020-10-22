extends Node

onready var player: KinematicBody2D = $Player
onready var tile_map: TileMap = $TileMap
onready var screenshake: Node2D = $Camera2D/ScreenShake

onready var score_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/Score
onready var game_over_label: Label = $CanvasLayer/MarginContainer/VBoxContainer/GameOver/GameOver2
onready var game_over: VBoxContainer = $CanvasLayer/MarginContainer/VBoxContainer/GameOver
onready var game_over_score: Label = $CanvasLayer/MarginContainer/VBoxContainer/GameOver/Summary/VBoxContainer/Score/Value
onready var game_over_best: Label = $CanvasLayer/MarginContainer/VBoxContainer/GameOver/Summary/VBoxContainer/Best/Value
onready var hit_sfx: AudioStreamPlayer2D = $HitSFX
onready var click_sfx: AudioStreamPlayer2D = $ClickSFX
onready var clap_sfx: AudioStreamPlayer2D = $ClapSFX
onready var music: AudioStreamPlayer2D = $Music

const SAVE_DATA_PATH = "user://data.json"

export var STARTING_LEVEL_SPEED: int = 100
export var SPEED_MULTIPLIER: int = 2
export var ROWS_OF_PIPES_GENERATED: int = 100
export var ROWS_GAP: int = 6

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var score: int = 0
var best: int = 0
var speed: int = 0
var player_dead: bool = false
var music_stopped: bool = false
var increase_speed: bool = true
var data

func _ready():
	game_over.hide()
	
	# generate rows of pipes
	for rows in range(1, ROWS_OF_PIPES_GENERATED):
		generate_row_pipes(rows * ROWS_GAP)
		
	# load highscore
	data = load_data_from_file()
	best = data.highscore

func _process(_delta):
	# update score label
	score = abs(- tile_map.position.x / (32 * ROWS_GAP))
	score_label.text = str(score)
	
	# increase the speed of the level
	speed = STARTING_LEVEL_SPEED + score * SPEED_MULTIPLIER
	
	# turn red the color of the score
	if score >  best:
		score_label.add_color_override("font_color", "#c21818")
	
	# escape the game
	if Input.is_action_just_pressed("ui_cancel"):
		var _r = get_tree().change_scene("res://scenes/menu.tscn")

func _physics_process(delta):
	# detect collision between the player and the pipes
	if player.collision:
		end_game()
	
	# move the tilemap to the left of the screen
	if not player_dead:
		tile_map.position.x -= speed * delta 

func generate_row_pipes(y):
	# generate the level
	rng.randomize()
	var space = rng.randi_range(2, 6)
	var y_space = rng.randi_range(1, 8 - space)
	for i in range(0,10):
		if i < y_space:
			tile_map.set_cell(y, i, 3)
		elif i == y_space:
			tile_map.set_cell(y, i, 4)
		elif i == y_space + space + 1:
			 tile_map.set_cell(y, i, 1)
		elif i > y_space + space + 1:
			tile_map.set_cell(y, i, 2)

func _on_BottomArea_body_entered(body):
	# check if the player has reached the bottom of the screen
	if body.name == "Player":
		end_game()

func _on_TopArea_body_entered(body):
	# check if the player has reached the top of the screen
	if body.name == "Player":
		end_game()

func end_game():
	player_dead = true
	player.collision = 1
	player.sprite.frame = 3
	screenshake.start(0.1, 15, 4, 0)
	
	if not music_stopped:
		music.stop()
		hit_sfx.play()
		music_stopped = true
	
	# load game over panel and save data
	if score >  best:
		best = score
		data.highscore = score
		save_data_to_file(data)
		game_over_best.text = str(score)
		game_over_label.text = "New\nHighscore"
		clap_sfx.play()
	else:
		game_over_best.text = str(data.highscore)
	game_over_score.text = str(score)
	game_over.show()
	score_label.hide()

func _on_Play_pressed():
	click_sfx.play()
	var _r = get_tree().change_scene("res://scenes/world.tscn")

func save_data_to_file(_data):
	var json_string = to_json(_data)
	var file = File.new()
	file.open(SAVE_DATA_PATH, File.WRITE)
	file.store_line(json_string)
	file.close()

func load_data_from_file():
	var file = File.new()
	if not file.file_exists(SAVE_DATA_PATH):
		return { 
			highscore = 0
		}
	file.open(SAVE_DATA_PATH, File.READ)
	var _data = parse_json(file.get_as_text())
	file.close()
	return _data

func _on_Music_finished():
	music.play()
