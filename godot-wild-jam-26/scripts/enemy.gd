extends KinematicBody2D

onready var attack_timer = $AttackTimer

export var MOVE_SPEED = 2000
var move = Vector2.ZERO
var player = null
var can_attack = false

func _physics_process(delta):
	if player:
		move = position.direction_to(player.position)
	else:
		move = Vector2.ZERO
	move = move.normalized()
	var _return = move_and_slide(move * MOVE_SPEED * delta)

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
	if can_attack:
		print("Attack !")
