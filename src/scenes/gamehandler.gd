extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

# Variables
onready var db = SQLite.new()
var playMusic = true
var player
var loadedGames = []

func _ready():
	# Create gdsqlite instance
	SavegameController.set_db(db)
	StatsController.set_db(db)
	SlotController.set_db(db)
	create_tables()

func create_tables():
	SavegameController.create_table()
	StatsController.create_stats_table()
	SlotController.create_table()

func save(aPlayer):
	SavegameController.save(aPlayer)

func insert_savegame_table():
	SavegameController.insert_table(SavegameController.parse_datetime(),
	 GlobalPlayer.character_name, GlobalPlayer.level, "Forest")

func insert_stats_table(idsave):
	StatsController.insert_stats_table(idsave)

func load_all_games():
	return SavegameController.select_all()

func load_last_game():
	var loadedGame: Dictionary = SavegameController.load_last_game()
	if loadedGame:
		var loadedStats: Dictionary = StatsController.load_stats_table(loadedGame.idsave)
		GlobalPlayer.load_player(loadedStats)
		var loadedEquip: Array = SlotController.load_equip_table(loadedGame.idsave)
		var loadedInventory: Array = SlotController.load_inventory_table(loadedGame.idsave)
		var loadedHotbar: Array = SlotController.load_hotbar_table(loadedGame.idsave)
		# Aplicar el equipamento guardado al jugador
		PlayerInventory.load_equips(loadedEquip)
		PlayerInventory.load_inventory(loadedInventory)
		PlayerInventory.load_hotbar(loadedHotbar)
	return loadedGame

func load_game_with_saveid(idsave):
	return SavegameController.select_with_id(idsave)

func load_last_savegame():
	return SavegameController.select_last()

func load_stats_table(saveID):
	return StatsController.load_stats_table(saveID)

func set_player(aPlayer):
	player = aPlayer

func change_music_state():
	playMusic = !playMusic
