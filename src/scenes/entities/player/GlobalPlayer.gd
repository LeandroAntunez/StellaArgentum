extends Node

var character_name

var skeleton_killed = 0

# Player location
var last_direction
var x
var y
var old_position_x
var old_position_y
var exited_cave = false

# Player initial stats
var health
var health_max
var health_regeneration
var mana
var mana_max
var mana_regeneration
var armor
var attributte_points

# Player inventory
var actual_weapon
var actual_spell
var health_potions
var mana_potions
var gold

# Attack variables
var attack_cooldown_time
var next_attack_time
var attack_damage

# Fireball variables
var fireball_damage
var fireball_cooldown_time
var next_fireball_time

# Experience variables
var xp
var xp_next_level
var level
var tutorial_showed = false

func load_player(loaded_game):
	character_name = loaded_game.playerName
	x = loaded_game.positionX
	y = loaded_game.positionY
	xp = loaded_game.experience
	xp_next_level = loaded_game.experienceNextLevel
	level = loaded_game.level
	health = loaded_game.health
	health_max = loaded_game.healthMax
	health_regeneration = loaded_game.healthRegeneration
	mana = loaded_game.mana
	mana_max = loaded_game.manaMax
	mana_regeneration = loaded_game.manaRegeneration
	armor = loaded_game.armor
	attributte_points = loaded_game.attributePoints
	tutorial_ended()

func save_stats(player):
	character_name = player.character_name
	x = player.position.x
	y = player.position.y
	xp = player.xp
	xp_next_level = player.xp_next_level
	level = player.level
	health = player.health
	health_max = player.health_max
	health_regeneration = player.health_regeneration
	mana = player.mana
	mana_max = player.mana_max
	mana_regeneration = player.mana_regeneration
	armor = player.armor
	attributte_points = player.attribute_points

func load_stats(player):
	player.character_name = character_name
	player.position.x = x
	player.position.y = y 
	player.xp = xp
	player.xp_next_level = xp_next_level
	player.level = level
	player.health = health
	player.health_max = health_max
	player.health_regeneration = health_regeneration
	player.mana = mana
	player.mana_max = mana_max
	player.mana_regeneration = mana_regeneration
	player.attribute_points = attributte_points
	player.armor = armor

func save_position(player):
	old_position_x = player.position.x
	old_position_y = player.position.y + 20

func enter_cave():
	exited_cave = false

func exit_cave():
	exited_cave = true

func exit_level():
	exited_cave = false

func tutorial_ended():
	tutorial_showed = true
