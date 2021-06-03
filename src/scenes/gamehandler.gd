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
	create_player_table()

func create_player_table():
	# Open the database
	if (not db.open_db("res://data/player_stats.db")):
		return;
	# Create table
	var query = "CREATE TABLE IF NOT EXISTS savegame ("
	query += " idsave INTEGER PRIMARY KEY,"
	query += " name TEXT NOT NULL,"
	query += " x REAL NOT NULL,"
	query += " y REAL NOT NULL,"
	query += " savetime TEXT NOT NULL);"
	if (not db.query(query)):
		return;
	db.close()

func save():
	if (not db.open_db("res://data/player_stats.db")):
		return;
	var savetime = parse_datetime()
	var name = player.character_name
	var x = player.position.x
	var y = player.position.y
	var query
	query = "INSERT INTO savegame (name, x, y, savetime) VALUES ('"
	query += str(name, "', ", x, ", ", y, ", '", savetime, "');")
	print(query)
	if (not db.query(query)):
		print("sql syntax error")
		return;
	print("sql query completed")
	db.close()

func load():
	pass

func set_player(aPlayer):
	player = aPlayer

func parse_datetime():
	var datetime = OS.get_datetime()
	var res = str(datetime.year, "-", datetime.month, "-", datetime.day, " ")
	res += str(datetime.hour, ":", datetime.minute)
	return res
