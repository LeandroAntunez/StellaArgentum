extends Node2D

onready var merchant_slots = get_node("TextureRect/GridContainer")
onready var gui = get_node("/root/Level/Player/GUI")
onready var player = get_node("/root/Level/Player")

func _ready():
	var slots = merchant_slots.get_children()
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = Slot.SlotType.MERCHANT
	initialize_merchant_items()

func _on_Sell_pressed():
	var item = gui.holding_item
	if can_sell(item):
		player.obtain_gold(item.sell_value * item.item_quantity)
		gui.free_holding_item()
		item.erase()

func _on_Exit_pressed():
	hide()

func _on_Buy_pressed():
	var item_selected = gui.holding_item
	if can_buy(item_selected):
		player.discount_gold(item_selected.buy_value)
		gui.free_holding_item()
		player.adquire_item(item_selected)
		item_selected.erase()
	else:
		# Devolver el item
		pass

func can_sell(item):
	if item:
		return !item_is_from_merchant(item)

func can_buy(item):
	if item:
		if item_is_from_merchant(item):
			return player.can_buy(item)

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			var anItem = get_item_from(slot)
			if find_parent("GUI").holding_item != null:
				if !anItem:
					left_click_empty_slot(slot)
				else:
					if find_parent("GUI").holding_item.item_name != anItem.item_name:
						left_click_different_item(event, slot)
					else:
						left_click_same_item(slot)
			elif anItem:
				left_click_not_holding(slot)

func get_item_from(slot):
	var items: Array = slot.get_children()
	if !items.empty():
		return items[0]

func left_click_empty_slot(slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.add_item_to_empty_slot(find_parent("GUI").holding_item, slot)
		slot.putIntoSlot(find_parent("GUI").holding_item)
		find_parent("GUI").holding_item = null

func left_click_different_item(event: InputEvent, slot: Slot):
	if able_to_put_into_slot(slot):
		PlayerInventory.remove_item(slot)
		PlayerInventory.add_item_to_empty_slot(find_parent("GUI").holding_item, slot)
		var temp_item = slot.item
		slot.pickFromSlot()
		temp_item.global_position = event.global_position
		slot.putIntoSlot(find_parent("GUI").holding_item)
		find_parent("GUI").holding_item = temp_item

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

func left_click_not_holding(slot: Slot):
	#PlayerInventory.remove_item(slot)
	find_parent("GUI").holding_item = get_item_from(slot)
	slot.pickFromSlot()
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

func item_is_from_merchant(item):
	return get_items().has(item)

func get_items() -> Array:
	var res = []
	var slots = merchant_slots.get_children()
	for s in slots:
		if slot_have_an_item(s):
			res.append(s.get_children()[0])
	return res

func slot_have_an_item(slot):
	return slot.get_child_count() > 0

func initialize_merchant_items():
	for i in get_items():
		i.set_item(i.item_name, i.item_quantity)
