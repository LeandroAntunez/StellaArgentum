extends Node

signal active_item_updated

const SlotClass = preload("res://scenes/menu/inventory/Slot.gd")
const ItemClass = preload("res://scenes/entities/item/Item.gd")
const NUM_INVENTORY_SLOTS = 20
const NUM_HOTBAR_SLOTS = 8

var active_item_slot = 0

var inventory = {
	#0: ["Iron Sword", 1, "Weapon"],  #--> slot_index: [item_name, item_quantity, item_type]
	#1: ["Iron Sword", 1, "Weapon"],  #--> slot_index: [item_name, item_quantity]
	#2: ["Slime Potion", 98, "Potion"],
	#3: ["Slime Potion", 45, "Potion"],
}

var hotbar = {
	#0: ["Iron Sword", 1, "Weapon"],  #--> slot_index: [item_name, item_quantity]
	#3: ["Slime Potion", 45, "Potion"],
}

var equips = {
	#0: ["Brown Shirt", 1, "Armor"],  #--> slot_index: [item_name, item_quantity]
	#1: ["Blue Jeans", 1, "Armor"],  #--> slot_index: [item_name, item_quantity]
	#2: ["Brown Boots", 1, "Armor"],	
}

func load_equips(loaded_equip):
	for slot in loaded_equip:
		equips[slot.slotIndex] = [slot.itemName, slot.itemQuantity, slot.itemType]

# TODO: First try to add to hotbar
func add_item(itemDrop):#item_name, item_quantity):
	var item_name = itemDrop.item_name
	var item_quantity = 1
	var slot_indices: Array = inventory.keys()
	slot_indices.sort()
	for item in slot_indices:
		if inventory[item][0] == item_name:
			var stack_size = int(JsonData.item_data[item_name]["StackSize"])
			var able_to_add = stack_size - inventory[item][1]
			if able_to_add >= item_quantity:
				inventory[item][1] += item_quantity
				update_slot_visual(item, inventory[item][0], inventory[item][1], itemDrop)
				return
			else:
				inventory[item][1] += able_to_add
				update_slot_visual(item, inventory[item][0], inventory[item][1], itemDrop)
				item_quantity = item_quantity - able_to_add
	
	# item doesn't exist in inventory yet, so add it to an empty slot
	for i in range(NUM_INVENTORY_SLOTS):
		if inventory.has(i) == false:
			inventory[i] = [item_name, item_quantity, itemDrop.toString()]
			update_slot_visual(i, inventory[i][0], inventory[i][1], itemDrop)
			return

# TODO: Make compatible with hotbar as well
func update_slot_visual(slot_index, item_name, new_quantity, itemDrop):
	var slot: Slot = get_tree().root.get_node("/root/Level/Player/GUI/Inventory/GridContainer/Slot" + str(slot_index + 1))
	if slot.item != null:
		slot.item.set_item(item_name, new_quantity)
	else:
		slot.initialize_item(item_name, new_quantity, itemDrop)

func remove_item(slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar.erase(slot.slot_index)
		SlotClass.SlotType.INVENTORY:
			inventory.erase(slot.slot_index)
		_:
			equips.erase(slot.slot_index)

func add_item_to_empty_slot(item: ItemClass, slot: SlotClass):
	match slot.slotType:
		SlotClass.SlotType.HOTBAR:
			hotbar[slot.slot_index] = [item.item_name, item.item_quantity, item.toString()]
		SlotClass.SlotType.INVENTORY:
			inventory[slot.slot_index] = [item.item_name, item.item_quantity, item.toString()]
		_:
			equips[slot.slot_index] = [item.item_name, item.item_quantity, item.toString()]

func add_item_quantity(slot: SlotClass, quantity_to_add: int):
	match slot.slotType:
		SlotClass.slotType.HOTBAR:
			hotbar[slot.slot_index][1] += quantity_to_add
		SlotClass.slotType.INVENTORY:
			inventory[slot.slot_index][1] += quantity_to_add
		_:
			equips[slot.slot_index][1] += quantity_to_add

###
### Hotbar Related Functions
func active_item_scroll_up() -> void:
	active_item_slot = (active_item_slot + 1) % NUM_HOTBAR_SLOTS
	emit_signal("active_item_updated")

func active_item_scroll_down() -> void:
	if active_item_slot == 0:
		active_item_slot = NUM_HOTBAR_SLOTS - 1
	else:
		active_item_slot -= 1
	emit_signal("active_item_updated")

func itemNameOnSlot(slot) -> String:
	return inventory[slot][0]

func itemQuantityOnSlot(slot) -> int:
	return inventory[slot][1]

func itemTypeOnSlot(slot) -> String:
	return inventory[slot][2]

func itemNameOnEquip(slot) -> String:
	return equips[slot][0]

func itemQuantityOnEquip(slot) -> int:
	return equips[slot][1]

func itemTypeOnEquip(slot) -> String:
	#if !equips.empty():
	#	if !equips[slot].empty():
	#		return equips[slot][2]
	if equips.has(slot):
		return equips[slot][2]
	return "Null"
