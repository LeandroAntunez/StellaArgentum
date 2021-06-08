extends Node

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

# Variables
var db;
var player
var query

func set_db(database):
	db = database

func open_db():
	# Open the database
	if (not db.open_db("res://data/stella_argentum.db")):
		print("Database not found.")
		return;

func close_db():
	if (not db.query(query)):
		print("savegame: SQL Syntax error.")
		return;
	print("savegame: sql query completed")
	db.close()

func create_savegame_table():
	open_db()
	# Create table
	query = "CREATE TABLE IF NOT EXISTS savegame ("
	query += " idsave INTEGER PRIMARY KEY,"
	query += " name TEXT NOT NULL,"
	query += " level INTEGER NOT NULL,"
	query += " place TEXT NOT NULL,"
	query += " savetime TEXT NOT NULL);"
	close_db()

func save(aPlayer):
	GlobalPlayer.save_stats(aPlayer)
	insert_savegame_table()
	var savegame = load_last_savegame()
	StatsController.insert_stats_table(savegame.idsave)

func insert_savegame_table():
	open_db()
	var savetime = parse_datetime()
	var name = GlobalPlayer.character_name
	var level = GlobalPlayer.level
	var place = "Forest"
	query = "INSERT INTO savegame (name, savetime, level, place) VALUES ('"
	query += str(name, "', '", savetime, "', '", level, "', '", place, "');")
	print(query)
	var result = db.query(query)
	if (not result):
		print("sql syntax error or 0 row founded.")
		return;
	print("sql query completed")
	db.close()
	return result

func load_last_savegame():
	open_db()
	query = "SELECT * FROM savegame ORDER BY savetime DESC LIMIT 1;"
	var result = db.fetch_array(query)
	if (not result):
		print("load_last_game: sql syntax error")
		return [];
	print("load_last_game: sql query completed")
	db.close()
	print(result[0])
	return result[0]

func load_all_games():
	open_db()
	query = "SELECT * FROM savegame ORDER BY savetime DESC;"
	var result = db.fetch_array(query)
	print(result)
	if (not result):
		print("sql syntax error")
		return [];
	print("sql query completed")
	db.close()
	return result

func load_last_game():
	var loadedGame = load_last_savegame()
	print(loadedGame)
	if loadedGame:
		var loadedStats = StatsController.load_stats_table(loadedGame.idsave)
		print(loadedStats)
		return loadedStats
	return loadedGame

func load_game_with_saveid(idsave):
	open_db()
	query = str("SELECT * FROM savegame WHERE idsave = ", idsave," LIMIT 1;")
	var result = db.fetch_array(query)[0]
	if (not result):
		print("load_stats: sql syntax error")
		return;
	print("load_stats: sql query completed")
	db.close()
	print(result)

func parse_datetime():
	var datetime = OS.get_datetime()
	var res = str(datetime.year, "-", datetime.month, "-", datetime.day, " ")
	res += str(parse_time(datetime.hour), ":", parse_time(datetime.minute), ":", parse_time(datetime.second))
	return res

func parse_time(time):
	if time < 10:
		return str("0", time) 
	else:
		return time 
