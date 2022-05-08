extends Controller

onready var create_table_query = queries["slot"]["create_table"]

func create_table():
	open_db()
	query = create_table_query
	close_db()

# ToDo: Hacer foreach slot
func insert_equip_table(idsave, aPlayer: Player):
	var equip_slots: Array = aPlayer.equip
	for index in range(equip_slots.size()):
		var slot: Slot = equip_slots[index]
		var item: Item = slot.item
		var itemName = null
		var itemQuantity = null
		var itemType = null
		if item != null:
			itemName = item.item_name
			itemQuantity = item.item_quantity
			itemType = item.toString()
		open_db()
		query = "INSERT INTO slot (saveID, slotType, slotIndex, itemName, "
		query += "itemQuantity, itemType) VALUES ('"
		query += str(
			idsave, "', '", "EQUIP', '", index,  "', '", itemName,
			"', '", itemQuantity, "', '", itemType, "');")
		close_db()

func insert_inventory_table(idsave, aPlayer):
	var inventory_slots: Array = aPlayer.inventory
	for index in range(inventory_slots.size()):
		var slot: Slot = inventory_slots[index]
		var item: Item = slot.item
		var itemName = null
		var itemQuantity = null
		var itemType = null
		if item != null:
			itemName = item.item_name
			itemQuantity = item.item_quantity
			itemType = item.toString()
		open_db()
		query = "INSERT INTO slot (saveID, slotType, slotIndex, itemName, "
		query += "itemQuantity, itemType) VALUES ('"
		query += str(
			idsave, "', '", "INVENTORY', '", index,  "', '", itemName,
			"', '", itemQuantity, "', '", itemType, "');")
		close_db()

func insert_hotbar_table(idsave, aPlayer):
	var hotbar_slots: Array = aPlayer.hotbar
	for index in range(hotbar_slots.size()):
		var slot: Slot = hotbar_slots[index]
		var item: Item = slot.item
		var itemName = null
		var itemQuantity = null
		var itemType = null
		if item != null:
			itemName = item.item_name
			itemQuantity = item.item_quantity
			itemType = item.toString()
		open_db()
		query = "INSERT INTO slot (saveID, slotType, slotIndex, itemName, "
		query += "itemQuantity, itemType) VALUES ('"
		query += str(
			idsave, "', '", "HOTBAR', '", index,  "', '", itemName,
			"', '", itemQuantity, "', '", itemType, "');")
		close_db()

func load_equip_table(saveID):
	open_db()
	query = str("SELECT * FROM slot WHERE saveID = ", saveID," AND slotType = 'EQUIP';")
	print(query)
	var result = db.fetch_array(query)
	if (not result):
		print("load_slot: sql syntax error")
		return;
	print("load_slot: sql query completed")
	db.close()
	print(result)
	return result

func load_inventory_table(saveID):
	open_db()
	query = str("SELECT * FROM slot WHERE saveID = ", saveID," AND slotType = 'INVENTORY';")
	print(query)
	var result = db.fetch_array(query)
	if (not result):
		print("load_slot: sql syntax error")
		return;
	print("load_slot: sql query completed")
	db.close()
	return result

func load_hotbar_table(saveID):
	open_db()
	query = str("SELECT * FROM slot WHERE saveID = ", saveID," AND slotType = 'HOTBAR';")
	print(query)
	var result = db.fetch_array(query)
	if (not result):
		print("load_slot: sql syntax error")
		return;
	print("load_slot: sql query completed")
	db.close()
	print(result)
	return result
