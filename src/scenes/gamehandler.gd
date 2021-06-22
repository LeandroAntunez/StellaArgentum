extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

# Variables
onready var db = SQLite.new()
var player
var loadedGames = []

func _ready():
	# Create gdsqlite instance
	SavegameController.set_db(db)
	StatsController.set_db(db)
	create_tables()

func create_tables():
	SavegameController.create_savegame_table()
	StatsController.create_stats_table()

func save(aPlayer):
	SavegameController.save(aPlayer)

func insert_savegame_table():
	SavegameController.insert_savegame_table()

func insert_stats_table(idsave):
	StatsController.insert_stats_table(idsave)

func load_all_games():
	return SavegameController.load_all_games()

func load_last_game():
	return SavegameController.load_last_game()

func load_game_with_saveid(idsave):
	return SavegameController.load_game_with_saveid(idsave)

func load_last_savegame():
	return SavegameController.load_last_savegame()

func load_stats_table(saveID):
	return StatsController.load_stats_table(saveID)

func set_player(aPlayer):
	player = aPlayer
