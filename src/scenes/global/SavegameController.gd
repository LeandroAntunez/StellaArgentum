extends Controller

onready var create_table_query = queries["savegame"]["create_table"]
onready var insert_table_query = queries["savegame"]["insert_table"]

func create_table():
	open_db()
	query = create_table_query
	close_db()

func save(aPlayer: Player):
	GlobalPlayer.save_stats(aPlayer)
	insert_table(parse_datetime(), GlobalPlayer.character_name, GlobalPlayer.level, "Forest")
	var idsave = select_last().idsave
	StatsController.insert_stats_table(idsave)
	SlotController.insert_equip_table(idsave, aPlayer)
	SlotController.insert_inventory_table(idsave, aPlayer)
	SlotController.insert_hotbar_table(idsave, aPlayer)

func insert_table(savetime, name, level, place):
	open_db()
	query = insert_table_query
	query += str(name, "', '", savetime, "', '", level, "', '", place, "');")
	close_db()

func select_last():
	.select_last()
	open_db()
	query = "SELECT * FROM savegame ORDER BY savetime DESC LIMIT 1;"
	return first_result()

func select_all():
	.select_all()
	open_db()
	query = "SELECT * FROM savegame ORDER BY savetime DESC;"
	return all_results()

func load_last_game():
	return select_last()

func select_with_id(idsave):
	.select_with_id(idsave)
	open_db()
	query = str("SELECT * FROM savegame WHERE idsave = ", idsave," LIMIT 1;")
	return first_result()

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
