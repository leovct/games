extends Node2D

var ui: CanvasLayer
var boat: Node2D
var fishing_rod: Area2D
var camera: Camera2D
var water_shader: Sprite

onready var captain_message: Label = $CaptainMessage
onready var captain_message_timer: Timer = $CaptainMessageTimer
onready var achievement: Label = $Achievement
onready var achievement_timer: Timer = $AchievementTimer

onready var music: AudioStreamPlayer2D = $Music
onready var sfx_sounds: Node2D = $SFX
onready var money_sfx: AudioStreamPlayer2D = $SFX/CoinSFX
onready var upgrade_sfx: AudioStreamPlayer2D = $SFX/UpgradeSFX
onready var fish_caught_sfx: AudioStreamPlayer2D = $SFX/FishCaughtSFX
onready var waves_sfx: AudioStreamPlayer2D = $SFX/WavesSFX
onready var select_sfx: AudioStreamPlayer2D = $SFX/SelectFX

var money_label: Label
var depth_label: Label

var money: int = 0
var special_fish_caught: Array # from 1 to 7

var player_level: Array = [0, 0] # [length level, weight level]
var fishing_rod_length_upgrades: Array = [100, 250, 500, 1000, 2000]
var fishing_rod_length_prices: Array = [50, 1000, 2000, 5000, 20000]
var fishing_rod_weight_upgrades: Array = [0.4, 0.6, 1.0, 40, 150000]
var fishing_rod_weight_prices: Array = [250, 1000, 2000, 5000, 20000]

var game_started: bool

var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	get_nodes()
	connect_signals()

func _process(_delta):
	if not game_started:
		get_tree().paused = true
	update_background()
	update_ui()
	check_player_has_won()
	if not waves_sfx.playing:
		waves_sfx.play()

func check_player_has_won() -> void:
	if len(special_fish_caught) == 7:
		ui.display_win_screen()
		get_tree().paused = true

func get_nodes() -> void:
	ui = get_node("UI")
	boat = get_node("Boat")
	fishing_rod = get_node("FishingRod")
	
	money_label = ui.get_node("MarginContainer/VBoxContainer/HBoxContainer/MoneyLabel")
	depth_label = ui.get_node("MarginContainer/VBoxContainer/HBoxContainer/DepthLabel")
	
	camera = get_node("Camera2D")
	water_shader = get_node("WaterShader")

func connect_signals() -> void:
	var _res = fishing_rod.connect("fish_out_of_the_water", self, "on_fish_out_of_the_water")
	_res = ui.connect("upgrade_fishing_rod_length", self, "on_upgrade_fishing_rod_length")
	_res = ui.connect("upgrade_fishing_rod_weight", self, "on_upgrade_fishing_rod_weight")
	_res = ui.connect("update_sail_color", self, "on_update_sail_color")
	_res = ui.connect("update_flag_color", self, "on_update_flag_color")
	_res = ui.connect("pause", self, "on_pause")
	_res = ui.connect("update_music_volume", self, "on_update_music_volume")
	_res = ui.connect("update_sfx_volume", self, "on_update_sfx_volume")
	_res = ui.connect("menu_click", self, "on_menu_click")
	_res = ui.connect("start_game", self, "on_start_game")

func on_fish_out_of_the_water(reward, rarity) -> void:
	money += reward
	ui.display_reward_message(reward)
	money_sfx.play()
	fish_caught_sfx.play()
	
	if rng.randi() % 2 == 0:
		update_captain_message()
	if rarity > 0 and not (rarity in special_fish_caught):
		special_fish_caught.append(rarity)
		achievement.show()
		achievement_timer.start()
		upgrade_sfx.play()

func on_upgrade_fishing_rod_length() -> void:
	var fishing_rod_length_level = player_level[0]
	var upgrade_cost = fishing_rod_length_prices[fishing_rod_length_level]
	var new_fishing_rod_length = fishing_rod_length_upgrades[fishing_rod_length_level]
	if money >= upgrade_cost:
		player_level[0] += 1
		money -= upgrade_cost
		fishing_rod.LENGTH = new_fishing_rod_length
		ui.display_cost_message(upgrade_cost)
		update_ui()
		upgrade_sfx.play()

func on_upgrade_fishing_rod_weight() -> void:
	var fishing_rod_weight_level = player_level[1]
	var upgrade_cost = fishing_rod_weight_prices[fishing_rod_weight_level]
	var new_fishing_rod_weight = fishing_rod_weight_upgrades[fishing_rod_weight_level]
	if money >= upgrade_cost:
		player_level[1] += 1
		money -= upgrade_cost
		fishing_rod.WEIGHT = new_fishing_rod_weight
		ui.display_cost_message(upgrade_cost)
		update_ui()
		upgrade_sfx.play()

func on_update_sail_color(new_color: Color) -> void:
	boat.update_sail_color(new_color)
	select_sfx.play()

func on_update_flag_color(new_color: Color) -> void:
	boat.update_flag_color(new_color)
	select_sfx.play()

func on_pause() -> void:
	get_tree().paused = !get_tree().paused

func update_background() -> void:
	fishing_rod.LENGTH = 200 # TEST
	if fishing_rod.depth > 70:
		water_shader.global_position = camera.global_position
	else:
		water_shader.global_position = Vector2(350, 1570)

func update_ui() -> void:	
	if fishing_rod.depth > 0:
		ui.update_depth_label(fishing_rod.depth)
	
	ui.update_money_label(money)
	ui.update_boost_timer_progress_bar(fishing_rod.boost_timer)
	update_fish_menu()
	update_equipment_menu()

func update_fish_menu() -> void:
	for fish in special_fish_caught:
		ui.reveal_fish(fish - 1)

func update_equipment_menu() -> void:
	ui.update_fishing_rod_length(fishing_rod.LENGTH)
	ui.update_fishing_rod_weight(fishing_rod.WEIGHT)
	ui.update_fishing_rod_upgrade_length(fishing_rod_length_prices[player_level[0]], money)
	ui.update_fishing_rod_upgrade_weight(fishing_rod_weight_prices[player_level[1]], money)

func on_update_music_volume(new_value: float) -> void:
	var music_position = music.get_playback_position()
	var db_volume = int((new_value - 50) / 10) * 3
	if db_volume == -15:
		music.playing = false
	else:
		music.playing = true
		music.volume_db = db_volume
		music.play(music_position)
	select_sfx.play()

func on_update_sfx_volume(new_value: int) -> void:
	sfx_sounds.update_sfx_volume(new_value)
	select_sfx.play()

func _on_Music_finished():
	music.play()

func update_captain_message() -> void:
	var messages: Array = ["Nice catch!", "Impressive!", "Wow!", "OMG!!", "aWeSomE"]
	captain_message.text = messages[randi() % len(messages)]
	captain_message.show()
	captain_message_timer.start()
	
func _on_CaptainMessageTimer_timeout():
	captain_message.hide()

func on_menu_click() -> void:
	select_sfx.play()

func on_start_game() -> void:
	game_started = true
	get_tree().paused = false

func _on_AchievementTimer_timeout():
	achievement.hide()
