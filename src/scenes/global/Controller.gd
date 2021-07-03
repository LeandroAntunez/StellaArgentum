extends Node
class_name Controller

# SQLite module
const SQLite = preload("res://lib/gdsqlite.gdns");

# Variables
var db;
var player
var query
onready var queries = JsonData.LoadData("res://data/saveData.json")

func set_db(database):
	db = database

func open_db():
	# Open the database
	if (not db.open_db("res://data/stella_argentum.db")):
		print("Database not found.")
		return;

func close_db():
	if (not db.query(query)):
		print("0 results found, or SQL syntax error.")
		return;
	print("SQL query completed")
	db.close()

func create_table():
	pass

func _insert_table():
	pass

func select_all():
	pass

func select_with_id(idsave: int):
	pass

func select_last():
	pass

func first_result():
	var result: Array = handle_select_query()
	if result.empty():
		return result
	else:
		return result[0]

func all_results():
	var result = handle_select_query()
	return result

func handle_select_query():
	var result = db.fetch_array(query)
	print(result)
	if (not result):
		print("SQL query completed. 0 results found.")
		return [];
	db.close()
	print("sql query completed")
	return result
