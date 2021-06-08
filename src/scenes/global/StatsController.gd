extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns")

# Variables
var db
var player
var query
func set_db(database):
	db = database

func create_stats_table():
	# Open the database
	if (not db.open_db("res://data/stella_argentum.db")):
		print("stats: Database not found.")
		return;
	# Create table
	query = "CREATE TABLE IF NOT EXISTS stats ("
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

func insert_stats_table(idsave):
	if (not db.open_db("res://data/stella_argentum.db")):
		return;
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

func load_stats_table(saveID):
	if (not db.open_db("res://data/stella_argentum.db")):
		print("load_stats: DB doesnt exists")
		return;
	query = str("SELECT * FROM stats WHERE saveID = ", saveID,";")
	var result = db.fetch_array(query)
	result = result[0]
	if (not result):
		print("load_stats: sql syntax error")
		return;
	print("load_stats: sql query completed")
	db.close()
	print(result)
	return result
