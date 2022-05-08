extends Controller

onready var create_table_query = queries["stats"]["create_table"]
onready var insert_table_query = queries["stats"]["insert_table"]

func create_stats_table():
	# Open the database
	open_db()
	# Create table
	query = create_table_query
	close_db()

func insert_stats_table(idsave):
	open_db()
	query = insert_table_query
	query += str(
		idsave, "', '", GlobalPlayer.character_name, "', '",
		GlobalPlayer.x, "', '", GlobalPlayer.y, "', '",
		GlobalPlayer.level, "', '", GlobalPlayer.xp, "', '",
		GlobalPlayer.xp_next_level, "', '", GlobalPlayer.health,
		"', '", GlobalPlayer.health_max, "', '",
		GlobalPlayer.health_regeneration, "', '", GlobalPlayer.mana, "', '",
		GlobalPlayer.mana_max, "', '", GlobalPlayer.mana_regeneration,
		"', '", GlobalPlayer.attributte_points, "', '",
		GlobalPlayer.armor, "');")
	close_db()

func load_stats_table(saveID):
	open_db()
	query = str("SELECT * FROM stats WHERE saveID = ", saveID,";")
	return first_result()
