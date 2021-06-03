extends KinematicBody2D

var character_name

# Player movement speed
export var speed = 75
var last_direction = Vector2(0, 1)
var attack_playing = false

# Player initial stats
var health = 100
var health_max = 100
var health_regeneration = 1
var mana = 100
var mana_max = 100
var mana_regeneration = 2

# Player inventory
var actual_weapon = "sword"
var actual_spell = "fireball"
enum Potion { HEALTH, MANA }
var health_potions = 0
var mana_potions = 0

# Attack variables
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_damage = 30

# Fireball variables
var fireball_damage = 50
var fireball_cooldown_time = 1000
var next_fireball_time = 0

# Experience variables
var xp = 75;
var xp_next_level = 100;
var level = 1;

var fireball_scene = preload("res://scenes/entities/fireball/Fireball.tscn")

# Sub-nodes
onready var animationPlayer = $AnimationPlayer

# Signals
signal player_stats_changed
signal player_level_up
signal attack
signal spell
signal death
signal pause

func _ready():
	character_name = GlobalPlayer.character_name
	if GlobalPlayer.x:
		position.x = GlobalPlayer.x
		position.y = GlobalPlayer.y
	Gamehandler.set_player(self)
	emit_signal("player_stats_changed", self)

func _physics_process(delta):
	# Get player input
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	# If input is digital, normalize it for diagonal movement
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	# Apply movement
	var movement = speed * direction * delta
	
	# To move the player slower when move and attack simulteaneously
	if attack_playing:
		movement = 0.3 * movement
	
	move_and_collide(movement)
	
	# Animate player based on direction
	if not attack_playing:
		animates_player(direction)
	
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 16

func animates_player(direction: Vector2):
	if direction != Vector2.ZERO:
		# gradually update last_direction to counteract the bounce of the analog stick
		last_direction = 0.5 * last_direction + 0.5 * direction
		
		# Choose walk animation based on movement direction
		var animation = "walk_" + get_animation_direction(last_direction)
		
		# Play the walk animation
		$Body.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		$Body.play(animation)
	else:
		# Choose idle animation based on last movement direction and play it
		var animation = "idle_" + get_animation_direction(last_direction)
		$Body.play(animation)

func get_animation_direction(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"

func _input(event):
	if event.is_action_pressed("attack"):
	# Check if player can attack
		var now = OS.get_ticks_msec()
		emit_signal("attack", actual_weapon)
		if now >= next_attack_time:
			# What's the target?
			var target = $RayCast2D.get_collider()
			if target != null:
				if target.name.find("Skeleton") >= 0:
					# Skeleton hit!
					target.hit(attack_damage)
				# NEW CODE - START
				if target.is_in_group("NPCs"):
					# Talk to NPC
					target.talk()
					return
			# Play attack animation
			attack_playing = true
			var animation = "attack_" + get_animation_direction(last_direction)
			$Body.play(animation)
			# Add cooldown time to current time
			next_attack_time = now + attack_cooldown_time
	elif event.is_action_pressed("fireball"):
		var now = OS.get_ticks_msec()
		if mana >= 25 and now >= next_fireball_time:
			# Update mana
			mana = mana - 25
			emit_signal("player_stats_changed", self)
			# Play fireball animation
			attack_playing = true
			var animation = "fireball_" + get_animation_direction(last_direction)
			$Body.play(animation)
			emit_signal("spell", actual_spell)
			# Add cooldown time to current time
			next_fireball_time = now + fireball_cooldown_time
	elif event.is_action_pressed("drink_health"):
		drink_health_potion()
	elif event.is_action_pressed("drink_mana"):
		drink_mana_potion()
	elif event.is_action_pressed("pause"):
		emit_signal("pause")

func _on_AnimatedSprite_animation_finished():
	attack_playing = false
	if $Body.animation.begins_with("fireball_"):
		# Instantiate Fireball
		var fireball = fireball_scene.instance()
		fireball.attack_damage = fireball_damage
		fireball.direction = last_direction.normalized()
		fireball.position = position + last_direction.normalized() * 4
		get_tree().root.get_node("Level").add_child(fireball)

func _process(delta):
	# Regenerates mana
	var new_mana = min(mana + mana_regeneration * delta, mana_max)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)

	# Regenerates health
	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)

func hit(damage):
	health -= damage
	emit_signal("player_stats_changed", self)
	if health <= 0:
		set_process(false)
		play_animation("Game Over")
		emit_signal("death")
	else:
		play_animation("Hit")

func play_animation(animationName):
	animationPlayer.play(animationName)

func add_potion(type):
	if type == Potion.HEALTH:
		health_potions = health_potions + 1
	else:
		mana_potions = mana_potions + 1
	emit_signal("player_stats_changed", self)

func add_xp(value):
	xp += value
	# Has the player reached the next level?
	if xp >= xp_next_level:
		level += 1
		xp_next_level *= 2
		print("1")
		emit_signal("player_level_up")
	emit_signal("player_stats_changed", self)

func drink_health_potion():
		if health_potions > 0:
			health_potions = health_potions - 1
			health = min(health + 50, health_max)
			emit_signal("player_stats_changed", self)

func drink_mana_potion():
		if mana_potions > 0:
			mana_potions = mana_potions - 1
			mana = min(mana + 50, mana_max)
			emit_signal("player_stats_changed", self)

func generate_id():
	pass
