extends "res://addons/gut/test.gd"

var Player = preload("res://scenes/level/PlayerScript.gd")
var PlayerScene = preload("res://scenes/level/Player.tscn")

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
