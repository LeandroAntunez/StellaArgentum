extends KinematicBody2D

export (int) var speed
var velocity = Vector2()
var facingDir = Vector2()
onready var anim = $AnimatedSprite

# Called during the physics processing step of the main loop.
func _physics_process(delta):
	get_input()
	manage_animations()
	
	# Moves the body along a vector.
	velocity = move_and_slide(velocity)

# Obtain the input that the player will use.
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('up'):
		velocity.y -= 1
		facingDir = Vector2(0, -1)
	elif Input.is_action_pressed('down'):
		velocity.y += 1
		facingDir = Vector2(0, 1)
	elif Input.is_action_pressed('right'):
		velocity.x += 1
		facingDir = Vector2(-1, 0)
	elif Input.is_action_pressed('left'):
		velocity.x -= 1
		facingDir = Vector2(1, 0)
	else:
		$AnimationPlayer.stop()
	
# With normalized() prevent faster diagonal movement,
# because both directions are added together.
	velocity = velocity.normalized() * speed

func manage_animations ():
	
	if velocity.x > 0:
		play_animation("walk_right")
	elif velocity.x < 0:
		play_animation("walk_left")
	elif velocity.y < 0:
		play_animation("walk_up")
	elif velocity.y > 0:
		play_animation("walk_down")
	elif facingDir.x == -1:
		play_animation("idle_right")
	elif facingDir.x == 1:
		play_animation("idle_left")
	elif facingDir.y == -1:
		play_animation("idle_up")
	elif facingDir.y == 1:
		play_animation("idle_down")

func play_animation (anim_name):
	if anim.animation != anim_name:
		anim.play(anim_name)
