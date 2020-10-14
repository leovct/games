extends KinematicBody2D

onready var attack_timer = $AttackTimer
onready var animationPlayer = $AnimationPlayer
onready var sprite = $Sprite
onready var collisionShape = $CollisionShape

export var SPEED = 2000
var move = Vector2.ZERO
var player = null
var can_attack = false
var dead = false

func _physics_process(delta):
	if player && !dead:
		move = position.direction_to(player.position)
		if move.x >= 0:
			sprite.flip_h = 0
			collisionShape.scale.x = 1
		else:
			sprite.flip_h = 1
			collisionShape.scale.x = -1
		animationPlayer.play("Move")
	else:
		move = Vector2.ZERO
	move = move.normalized()
	var _return = move_and_slide(move * SPEED * delta)
	
	if dead:
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
		print("Attack !")

func _on_PerspectiveArea_body_entered(body):
	body.z_index = z_index + 1

func _on_PerspectiveArea_body_exited(body):
	body.z_index -= 1
	
