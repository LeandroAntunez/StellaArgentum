extends Node

var character_name

# Player location
var last_direction
var x
var y

# Player initial stats
var health
var health_max
var health_regeneration
var mana
var mana_max
var mana_regeneration

# Player inventory
var actual_weapon
var actual_spell
var health_potions
var mana_potions

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

func load_player(loaded_game):
	character_name = loaded_game.name
	x = loaded_game.x
	y = loaded_game.y

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

