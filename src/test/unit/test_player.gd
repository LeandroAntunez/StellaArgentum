extends "res://addons/gut/test.gd"

var Player = preload("res://scenes/entities/player/PlayerScript.gd")
var PlayerScene = preload("res://scenes/entities/player/Player.tscn")
var APotion = preload("res://scenes/entities/item/potion/Potion.gd")

func test_player_initial_health_is_100():
	var _playerScene
	var _player = Player.new()
	var result = _player.health
	
	assert_eq(result, 100, 
	"The health of a new player must be equals 100.")

func test_player_receives_20_damage_then_health_is_equals_80():
	var _player = partial_double(Player).new()
	stub(_player, 'play_animation').to_do_nothing()
	_player.hit(20)
	var result_health = _player.health
	
	assert_eq(result_health, 80,
	"The remaining health after 20 damage must be 80.")

func test_player_receives_100_experience_points_then_level_up():
	var _player = partial_double(Player).new()
	assert_eq(_player.level, 1, "The initial Player level must be 1.")
	_player.add_xp(100)
	
	assert_eq(_player.level, 2, "The next Player level must be 2.")

func test_when_player_obtain_a_health_potion_then_have_one_health_potion():
	var _player = partial_double(Player).new()
	var _health_potion = APotion.new()
	_player.add_potion(_health_potion.type)
	assert_eq(_player.health_potions, 1, "The Player must have 1 health potion.")

func test_when_player_obtain_a_mana_potion_then_have_one_mana_potion():
	var _player = partial_double(Player).new()
	var _mana_potion = APotion.new()
	_mana_potion.change_type()
	_player.add_potion(_mana_potion.type)
	assert_eq(_player.mana_potions, 1, "The Player must have 1 mana potion.")

func test_then_player_drink_a_health_potion_then_dont_have_health_potions():
	var _player = partial_double(Player).new()
	var _health_potion = APotion.new()
	_player.add_potion(_health_potion.type)
	_player.drink_health_potion()
	assert_eq(_player.health_potions, 0, "The Player must have 0 health potion.")

func test_then_player_drink_a_mana_potion_then_dont_have_health_potions():
	var _player = partial_double(Player).new()
	var _mana_potion = APotion.new()
	_mana_potion.change_type()
	_player.add_potion(_mana_potion.type)
	_player.drink_mana_potion()
	assert_eq(_player.mana_potions, 0, "The Player must have 0 mana potion.")
