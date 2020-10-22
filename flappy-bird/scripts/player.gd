extends KinematicBody2D

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var sprite: Sprite = $Sprite
onready var jump_sfx: AudioStreamPlayer2D = $JumpSFX

export var GRAVITY: int = 200
export var JUMP_FORCE: int = 10

var velocity = Vector2()
var collision = 0

func _physics_process(delta):
	if not collision:
		# apply gravity
		velocity.y += GRAVITY * delta
			
		# get player input
		if Input.is_action_just_pressed("jump"):
			velocity.y -= JUMP_FORCE
			animation_player.play("Fly")
			jump_sfx.play()

		collision = move_and_collide(velocity * delta)
	else:
		sprite.frame = 3
