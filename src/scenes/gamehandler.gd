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
	if (not db.open_db("res://data/player_stats.db")):
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
	if (not db.open_db("res://data/player_stats.db")):
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
	insert_stats_table()

func insert_savegame_table():
	if (not db.open_db("res://data/player_stats.db")):
		return;
	var savetime = parse_datetime()
	var name = player.character_name
	var query
	query = "INSERT INTO savegame (name, savetime) VALUES ('"
	query += str(name, "', '", savetime, "');")
	print(query)
	if (not db.query(query)):
		print("sql syntax error")
		return;
	print("sql query completed")
	db.close()

func insert_stats_table():
	var last_game = load_last_game()
	if (not db.open_db("res://data/player_stats.db")):
		return;
	var saveID = last_game.idsave
	var query
	query = "INSERT INTO stats (saveID, playerName, positionX, positionY, "
	query += "level, experience, experienceNextLevel, health, healthMax, "
	query += "healthRegeneration, mana, manaMax, manaRegeneration) VALUES ('"
	query += str(
		saveID, "', '", GlobalPlayer.character_name, "', '", GlobalPlayer.x,
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
	if (not db.open_db("res://data/player_stats.db")):
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
	if (not db.open_db("res://data/player_stats.db")):
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

func set_player(aPlayer):
	player = aPlayer

func parse_datetime():
	var datetime = OS.get_datetime()
	var res = str(datetime.year, "-", datetime.month, "-", datetime.day, " ")
	res += str(datetime.hour, ":", datetime.minute, ":", datetime.second)
	return res
