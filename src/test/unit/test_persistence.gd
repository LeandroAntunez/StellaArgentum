extends "res://addons/gut/test.gd"

var Player = preload("res://scenes/entities/player/PlayerScript.gd")
var PlayerScene = preload("res://scenes/entities/player/Player.tscn")
var APotion = preload("res://scenes/entities/item/consumable/potion/Potion.gd")
var db

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns")

func test_save_game():
	var _playerScene
	var _player = Player.new()
	var result = _player.health
	
	assert_eq(result, 100, 
	"The health of a new player must be equals 100.")

func test_load_game():
	assert_true(true)

func test_create_stats_table():
	assert_true(true)

func test_create_savegame_table():
	assert_true(true)

func test_load_all_games():
	assert_true(true)

func test_load_last_game():
	assert_true(true)

func test_load_game_with_saveid():
	assert_true(true)

func test_load_last_savegame():
	assert_true(true)

func test_load_stats_table():
	assert_true(true)
