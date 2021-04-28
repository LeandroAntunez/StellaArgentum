extends KinematicBody2D
export (int) var speed

var velocity = Vector2()

# Called during the physics processing step of the main loop.
func _physics_process(delta):
	get_input()
	
	# Moves the body along a vector.
	velocity = move_and_slide(velocity)

# Obtain the input that the player will use.
func get_input():
	velocity = Vector2()
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	
# With normalized() prevent faster diagonal movement,
# because both directions are added together.
	velocity = velocity.normalized() * speed
