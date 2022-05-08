extends KinematicBody2D
class_name Player

var character_name

# Player movement speed
export var speed = 75
var last_direction = Vector2(0, 1)
var attack_playing = false

# Player initial stats
var health = 100
var health_max = 100
var health_regeneration = 0
var mana = 100
var mana_max = 100
var mana_regeneration = 0
var armor = 0
var attribute_points = 0

# Player inventory
var actual_weapon = "sword"
var actual_spell = "fireball"
export (int) var gold

# Attack variables
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_damage = 30
var min_attack = 0

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
onready var equip = $GUI/Equips/Equipment/EquipSlot.get_children()
onready var inventory = $GUI/Inventory/GridContainer.get_children()
onready var hotbar = $GUI/Hotbar/HotbarSlots.get_children()

# Signals
signal player_stats_changed
signal player_level_up
signal attack
signal spell
signal death
signal pause
signal inventory_open
signal quest

func _ready():
	character_name = GlobalPlayer.character_name
	
	if GlobalPlayer.x:
		GlobalPlayer.load_stats(self)
	elif GlobalPlayer.exited_cave:
		position.x = GlobalPlayer.old_position_x
		position.y = GlobalPlayer.old_position_y
	else:
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
	
	var _movement = move_and_collide(movement)
	
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
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)
	elif event.is_action_pressed("attack"):
		attack()
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
	elif event.is_action_pressed("pause"):
		emit_signal("pause", self)
	elif event.is_action_pressed("quest"):
		emit_signal("quest")

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

func add_xp(value):
	xp += value
	# Has the player reached the next level?
	check_level_up()
	emit_signal("player_stats_changed", self)

func check_level_up():
	if xp >= xp_next_level:
		level += 1
		xp = xp - xp_next_level
		xp_next_level *= 2
		attribute_points += 1
		emit_signal("player_level_up")

func drink_health_potion(amount):
	health += amount
	emit_signal("player_stats_changed", self)

func drink_mana_potion(amount):
	mana += amount
	emit_signal("player_stats_changed", self)

func generate_id():
	pass

func _on_item_entered(item):
	$PickupZone._on_PickupZone_body_entered(item)

func _on_item_exited(item):
	$PickupZone._on_PickupZone_body_exited(item)

func upgrade_attribute(attributeName: String, amount: int):
	attribute_points -= 1
	var newValue: int = get(attributeName) + amount
	set(attributeName, newValue)

func obtain_gold(amount: int):
	gold += amount
	emit_signal("player_stats_changed", self)

func discount_gold(amount: int):
	gold -= amount
	emit_signal("player_stats_changed", self)

func can_buy(item):
	return gold >= item.buy_value

func adquire_item(item):
	var itemDrop: ItemDrop = ParseItem.item_to_itemDrop(item)
	itemDrop.pick_up_item(self)

func attack():
# Check if player can attack
	var now = OS.get_ticks_msec()
	emit_signal("attack", actual_weapon)
	if now >= next_attack_time:
		# What's the target?
		var target = $RayCast2D.get_collider()
		if target != null:
			if target.is_in_group("Enemy"):
			#if target.name.find("Skeleton") >= 0:
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
