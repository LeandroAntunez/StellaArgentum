extends Node2D

onready var inventory_slots = $GridContainer
onready var gold = $TextureRect/Gold
onready var player = get_node("/root/Level/Player")
onready var item_info = get_node("ItemInfo/Background")
onready var description = get_node("ItemInfo/Background/Description")
onready var merchant = get_node("/root/Level/Player/GUI/Merchant")
var selected_item
var selected_slot

func _ready():
	var slots = inventory_slots.get_children()
	set_gold(player.gold)
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].connect("mouse_entered", self, "on_slot_mouse_entered", [slots[i]])
		slots[i].connect("mouse_exited", self, "on_slot_mouse_exited", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = Slot.SlotType.INVENTORY
	initialize_inventory()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		initialize_slot(slots, i)

func initialize_slot(slots, i):
	if is_not_empty_slot(i):
		var itemType: String = PlayerInventory.itemTypeOnSlot(i)
		slots[i].initialize_item(
				PlayerInventory.itemNameOnSlot(i),
				PlayerInventory.itemQuantityOnSlot(i),
				ParseItem.string_to_class(itemType))

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			if merchant_is_open():
				select_slot(slot)
			else:
				if find_parent("GUI").holding_item != null:
					if !slot.item:
						left_click_empty_slot(slot)
					else:
						if find_parent("GUI").holding_item.item_name != slot.item.item_name:
							left_click_different_item(event, slot)
						else:
							left_click_same_item(slot)
				elif slot.item:
					left_click_not_holding(slot)

func _input(_event):
	if find_parent("GUI").holding_item:
		find_parent("GUI").holding_item.global_position = get_global_mouse_position()

func able_to_put_into_slot(slot: Slot):
	var holding_item = find_parent("GUI").holding_item
	if holding_item == null:
		return true
	var holding_item_category = JsonData.item_data[holding_item.item_name]["ItemCategory"]
	
	if slot.slotType == Slot.SlotType.TORSO:
		return holding_item_category == "Torso"
	elif slot.slotType == Slot.SlotType.LEGS:
		return holding_item_category == "Legs"
	elif slot.slotType == Slot.SlotType.SHOES:
		return holding_item_category == "Shoes"
	elif slot.slotType == Slot.SlotType.WEAPON:
		return holding_item_category == "Weapon"
	return true

func left_click_empty_slot(slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("GUI").holding_item, slot)
		slot.putIntoSlot(find_parent("GUI").holding_item)
		find_parent("GUI").holding_item = null
		PlayerInventory.emit_signal("update_changes")

func left_click_different_item(event: InputEvent, slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("GUI").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("GUI").holding_item)
		find_parent("GUI").holding_item = temp_item
		PlayerInventory.emit_signal("update_changes")

func left_click_same_item(slot: Slot):
	if able_to_put_into_slot(slot):
		var stack_size = int(JsonData.item_data[slot.item.item_name]["StackSize"])
		var able_to_add = stack_size - slot.item.item_quantity
		if able_to_add >= find_parent("GUI").holding_item.item_quantity:
			PlayerInventory.add_item_quantity(slot, find_parent("GUI").holding_item.item_quantity)
			slot.item.add_item_quantity(find_parent("GUI").holding_item.item_quantity)
			find_parent("GUI").holding_item.queue_free()
			find_parent("GUI").holding_item = null
		else:
			PlayerInventory.add_item_quantity(slot, able_to_add)
			slot.item.add_item_quantity(able_to_add)
			find_parent("GUI").holding_item.decrease_item_quantity(able_to_add)
	PlayerInventory.emit_signal("update_changes")

func left_click_not_holding(slot: Slot):
	PlayerInventory.remove_item(slot)
	find_parent("GUI").holding_item = slot.item
	find_parent("GUI").holding_item.global_position = get_global_mouse_position()
	slot.pickFromSlot()
	PlayerInventory.emit_signal("update_changes")

func set_gold(amount: int):
	gold.text = str(amount)

func is_not_empty_slot(indexItem: int):
	if PlayerInventory.inventory.has(indexItem):
		var item = PlayerInventory.inventory[indexItem]
		var itemType = item[2]
		return itemType != "Null"
	return false

func _on_GUI_stats_changed():
	gold.text = str(player.gold)

func on_slot_mouse_entered(slot: Slot):
	if !item_info.visible && !slot.get_children().empty():
		item_info.show()
		update_description(slot)
	item_info.rect_position = slot.rect_global_position + Vector2(-150.0, -30.0)

func select_slot(slot):
	cancel_previous_selection()
	slot.is_selected()
	selected_slot = slot
	selected_item = get_item_from(slot)

func cancel_previous_selection():
	if selected_slot:
		selected_slot.cancel_selection()
		selected_slot = null
		selected_item = null
		find_parent("GUI").holding_item = null

func get_item_from(slot):
	var items: Array = slot.get_children()
	if !items.empty():
		return items[0]

func on_slot_mouse_exited(slot):
	if item_info.visible:
		item_info.hide()

func update_description(slot):
	var item = slot.get_item()
	if item:
		description.text = item.item_name + "\n-------------------\n"
		description.text += "Tipo: " + item.toString() + "\n"
		description.text += "Calidad: " + item.rarity + "\n"
		description.text += "Valor de venta: " + str(item.sell_value) + " Oro\n"
		description.text += item.extra_description()

func merchant_is_open():
	return merchant.visible

func get_slot_from_index(i):
	var slots = inventory_slots.get_children()
	return slots[i]
