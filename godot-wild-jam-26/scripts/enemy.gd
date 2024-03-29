extends KinematicBody2D

const DustEffect = preload("res://scenes/dustEffect.tscn")

onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var collisionShape = $CollisionShape
onready var texture_progress = $TextureProgress
onready var attack_timer = $AttackTimer
onready var attack_timer2 = $AttackTimer2

signal attack_player

export var SPEED = 6000
export var MAX_HEALTH = 1
export var DAMAGE = 1

var move = Vector2.ZERO
var player = null
var can_attack = false
var dead = false
var health = MAX_HEALTH
var attacking = false
var timer_started = false

func _ready():
	texture_progress.max_value = MAX_HEALTH

func _process(_delta):
	texture_progress.value = MAX_HEALTH - health

func _physics_process(delta):
	if health > 0:
		if !attacking:
			if player && !dead:
				move = position.direction_to(player.position)
				if move.x >= 0:
					sprite.flip_h = 0
					collisionShape.scale.x = 1
				else:
					sprite.flip_h = 1
					collisionShape.scale.x = -1
				animationPlayer.play("Run")
			else:
				move = Vector2.ZERO
			move = move.normalized()
			var _return = move_and_slide(move * SPEED * delta)
			
			if move != Vector2.ZERO:
				animationPlayer.play("Run")
			else:
				animationPlayer.play("Idle")
	else:
		animationPlayer.play("Dead")	

func _on_DetectionArea_body_entered(body):
	if body.get_name() == "Player":
		player = body

func _on_DetectionArea_body_exited(body):
	if body.get_name() == "Player":
		player = null

func _on_AttackArea_body_entered(body):
	if body.get_name() == "Player":
		can_attack = true

func _on_AttackArea_body_exited(body):
	if body.get_name() == "Player":
		can_attack = false

func _on_AttackTimer_timeout():
	if can_attack && !dead:
		animationPlayer.play("Attack")
		attacking = true
		emit_signal("attack_player", DAMAGE)
		if not timer_started:
			attack_timer2.start()
			timer_started = true

func _on_PerspectiveArea_body_entered(body):
	body.z_index = z_index + 1

func _on_PerspectiveArea_body_exited(body):
	body.z_index -= 1

func create_dust_effect():
	var dust_effect = DustEffect.instance()
	get_tree().current_scene.add_child(dust_effect)
	var dust_position = global_position
	if move.x > 0:
		dust_position.x -= 4
	else:
		dust_position.x += 4
	dust_position.y += 8
	dust_effect.position = dust_position

func _on_AttackTimer2_timeout():
	attacking = false
	timer_started = false
