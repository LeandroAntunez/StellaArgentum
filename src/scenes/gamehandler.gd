extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

# Variables
var db;
var player

func _ready():
	# Create gdsqlite instance
	db = SQLite.new();
	create_tables()

func create_tables():
	create_savegame_table()
	create_stats_table()

func create_stats_table():
	# Open the database
	if (not db.open_db("res://data/stella_argentum.db")):
		print("stats: Database not found.")
		return;
	# Create table
	var query = "CREATE TABLE IF NOT EXISTS stats ("
	query += "statsID INTEGER PRIMARY KEY, "
	query += "saveID INTEGER, "
	query += "playerName TEXT, "
	query += "positionX REAL, "
	query += "positionY REAL, "
	query += "level INTEGER, "
	query += "experience INTEGER, "
	query += "experienceNextLevel INTEGER, "
	query += "health INTEGER, "
	query += "healthMax INTEGER, "
	query += "healthRegeneration INTEGER, "
	query += "mana INTEGER, "
	query += "manaMax INTEGER, "
	query += "manaRegeneration INTEGER, "
	query += "FOREIGN KEY(saveID) REFERENCES savegame(idsave));"
	if (not db.query(query)):
		print("stats: SQL Syntax error.")
		return;
	print("sql query completed")
	db.close()

func create_savegame_table():
	# Open the database
	if (not db.open_db("res://data/stella_argentum.db")):
		print("savegame: Database not found.")
		return;
	# Create table
	var query = "CREATE TABLE IF NOT EXISTS savegame ("
	query += " idsave INTEGER PRIMARY KEY,"
	query += " name TEXT NOT NULL,"
	query += " savetime TEXT NOT NULL);"
	if (not db.query(query)):
		print("savegame: SQL Syntax error.")
		return;
	print("savegame: sql query completed")
	db.close()

func save(player):
	GlobalPlayer.save_stats(player)
	insert_savegame_table()
	var savegame = load_last_savegame()
	insert_stats_table(savegame.idsave)

func insert_savegame_table():
	if (not db.open_db("res://data/stella_argentum.db")):
		return;
	var savetime = parse_datetime()
	var name = player.character_name
	var query
	query = "INSERT INTO savegame (name, savetime) VALUES ('"
	query += str(name, "', '", savetime, "');")
	print(query)
	var result = db.query(query)
	if (not result):
		print("sql syntax error or 0 row founded.")
		return;
	print("sql query completed")
	db.close()
	return result

func insert_stats_table(idsave):
	if (not db.open_db("res://data/stella_argentum.db")):
		return;
	var query
	query = "INSERT INTO stats (saveID, playerName, positionX, positionY, "
	query += "level, experience, experienceNextLevel, health, healthMax, "
	query += "healthRegeneration, mana, manaMax, manaRegeneration) VALUES ('"
	query += str(
		idsave, "', '", GlobalPlayer.character_name, "', '", GlobalPlayer.x,
		"', '", GlobalPlayer.y, "', '", GlobalPlayer.level, "', '",
		GlobalPlayer.xp, "', '", GlobalPlayer.xp_next_level, "', '",
		GlobalPlayer.health, "', '", GlobalPlayer.health_max, "', '",
		GlobalPlayer.health_regeneration, "', '", GlobalPlayer.mana, "', '",
		GlobalPlayer.mana_max, "', '", GlobalPlayer.mana_regeneration, "');")
	print(query)
	if (not db.query(query)):
		print("sql syntax error")
		return;
	print("sql query completed")
	db.close()

func load_all_games():
	if (not db.open_db("res://data/stella_argentum.db")):
		return;
	var query = "SELECT * FROM savegame ORDER BY savetime DESC;"
	var result = db.fetch_array(query)
	print(result)
	if (not result):
		print("sql syntax error")
		return;
	print("sql query completed")
	db.close()
	return result

func load_last_game():
	var loadedGame = load_last_savegame()
	print(loadedGame)
	if loadedGame:
		var loadedStats = load_stats_table(loadedGame.idsave)
		print(loadedStats)
		return loadedStats
	return loadedGame

func load_game_with_saveid(idsave):
	if (not db.open_db("res://data/stella_argentum.db")):
		print("load_stats: DB doesnt exists")
		return;
	var query = str("SELECT * FROM savegame WHERE idsave = ", idsave," LIMIT 1;")
	var result = db.fetch_array(query)[0]
	if (not result):
		print("load_stats: sql syntax error")
		return;
	print("load_stats: sql query completed")
	db.close()
	print(result)

func load_last_savegame():
	if (not db.open_db("res://data/stella_argentum.db")):
		print("load_last_game: DB doesnt exists")
		return;
	var query = "SELECT * FROM savegame ORDER BY savetime DESC LIMIT 1;"
	var result = db.fetch_array(query)[0]
	if (not result):
		print("load_last_game: sql syntax error")
		return;
	print("load_last_game: sql query completed")
	db.close()
	print(result)
	return result

func load_stats_table(saveID):
	if (not db.open_db("res://data/stella_argentum.db")):
		print("load_stats: DB doesnt exists")
		return;
	var query = str("SELECT * FROM stats WHERE saveID = ", saveID," LIMIT 1;")
	var result = db.fetch_array(query)[0]
	if (not result):
		print("load_stats: sql syntax error")
		return;
	print("load_stats: sql query completed")
	db.close()
	print(result)
	return result

func set_player(aPlayer):
	player = aPlayer

func parse_datetime():
	var datetime = OS.get_datetime()
	var res = str(datetime.year, "-", datetime.month, "-", datetime.day, " ")
	res += str(datetime.hour, ":", datetime.minute, ":", datetime.second)
	return res
