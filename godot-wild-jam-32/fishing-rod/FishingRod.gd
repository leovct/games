extends Node2D

signal fish_out_of_the_water(reward, rarity)

export (float) var LENGTH = 50.0 # meters
export (float) var WEIGHT = 0.2 # kilograms
export (float) var GRAVITY = 6
export (Vector2) var ROD_SPEED = Vector2(200, 10)
export (Vector2) var BOOST_SPEED = Vector2(100, 400)
export (Vector2) var REWIND_SPEED = Vector2(200, 400)
export (float) var BOOST_TIME = 2.0

onready var hammer_head: Sprite = $HammerHead
onready var fish_catch: Node2D = $FishCatch

onready var depth_message: Label = $DepthMessage
onready var weight_message: Label = $WeightMessage
onready var message_timer: Timer = $MessageTimer

var rng = RandomNumberGenerator.new()
var initial_position: Vector2
var initial_color: Color = Color(0, 0, 0)
var boost_color: Color = Color(255, 0, 0)
var rewind_color: Color = Color(0, 255, 0)
var active_color: Color

var boost_timer: float = BOOST_TIME
var is_rewind_engaged: bool
var is_rod_full: bool
var fish_caught: Area2D
var depth: int

func _ready():
	rng.randomize()
	initial_position = global_position

func _physics_process(delta):
	update() # update fishing rod line
	change_rod_color(initial_color)
	
	var horizontal_input: float = get_horizontal_input()
	move_rod_horizontaly(delta, horizontal_input)
	update_boost_value(delta)
	
	depth = int((global_position.y - initial_position.y) * 0.1)
	
	check_if_rewind_is_engaged_by_player()
	if is_rewind_engaged:
		var fishin_rod_not_fully_rewound: bool = global_position.y >= initial_position.y
		if fishin_rod_not_fully_rewound:
			rewind(delta)
			if fish_caught != null:
				move_fish_with_rod()	
		else:
			if fish_caught != null:
				empty_rod()
				emit_signal("fish_out_of_the_water", fish_caught.reward, fish_caught.rarity)
			is_rewind_engaged = false
	else:
		if depth < LENGTH:
			apply_speed_boost_if_activated_by_player(delta, horizontal_input)
			apply_gravity(delta)
	
	if depth >= LENGTH - 5:
		depth_message.show()
		weight_message.hide()
		message_timer.start()

func _draw():
	if int(WEIGHT) > 1:
		draw_line(Vector2.ZERO, initial_position - global_position, active_color, 10)
	else:
		draw_line(Vector2.ZERO, initial_position - global_position, active_color, int(WEIGHT))
	

func get_horizontal_input() -> float:
	return Input.get_action_strength("move_right") - Input.get_action_strength("move_left")

func move_rod_horizontaly(delta, horizontal_input: float) -> void:
	global_position.x += horizontal_input * ROD_SPEED.x * delta
		
func check_if_rewind_is_engaged_by_player() -> void:
	if Input.is_action_just_pressed("rewind"):
		is_rewind_engaged = true

func rewind(delta: float) -> void:
	global_position.y -= REWIND_SPEED.y * delta
	#change_rod_color(rewind_color)

func move_fish_with_rod() -> void:
	fish_caught.global_position = fish_catch.global_position

func empty_rod() -> void:
	is_rewind_engaged = true
	is_rod_full = false
	fish_caught.queue_free()

func apply_gravity(delta: float) -> void:
	global_position.y += GRAVITY * ROD_SPEED.y * delta		

func apply_speed_boost_if_activated_by_player(delta, horizontal_input: float) -> void:
	if Input.is_action_pressed("speed_boost") and boost_timer > 0:
		boost_timer -= delta
		global_position.x += horizontal_input * BOOST_SPEED.x * delta
		global_position.y += BOOST_SPEED.y * delta

func update_boost_value(delta: float):
	if boost_timer < BOOST_TIME: # and not Input.is_action_pressed("speed_boost"):
		boost_timer += delta * 0.1

func change_rod_color(new_color: Color) -> void:
	hammer_head.modulate = new_color
	active_color = new_color

func _on_FishingRod_area_entered(fish: Area2D):
	if not is_rod_full and WEIGHT >= fish.weight:
		is_rewind_engaged = true
		is_rod_full = true
		fish_caught = fish
		fish.is_caught = true
	else:
		#global_position.y = initial_position.y
		depth_message.hide()
		weight_message.show()
		message_timer.start()

func _on_MessageTimer_timeout():
	depth_message.hide()
	weight_message.hide()
		
