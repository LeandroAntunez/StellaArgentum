extends Node2D

onready var player: Player = get_node("/root/Level/Player")
onready var playerName: Label = $Equipment/PlayerName
onready var slots = $Equipment/EquipSlot
onready var equip_slots: Array = $Equipment/EquipSlot.get_children()
onready var level = $Equipment/Level
onready var item_info = get_node("ItemInfo/Background")
onready var description = get_node("ItemInfo/Background/Description")

func _ready():
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].connect("mouse_entered", self, "on_slot_mouse_entered", [equip_slots[i]])
		equip_slots[i].connect("mouse_exited", self, "on_slot_mouse_exited", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slotType = Slot.SlotType.TORSO
	equip_slots[1].slotType = Slot.SlotType.LEGS
	equip_slots[2].slotType = Slot.SlotType.SHOES
	equip_slots[3].slotType = Slot.SlotType.WEAPON
	initialize_equips()

func _input(event):
	if event.is_action_pressed("stadistics"):
		visible = !visible

func initialize_equips():
	for i in range(equip_slots.size()):
		var itemType: String = PlayerInventory.itemTypeOnEquip(i)
		if PlayerInventory.equips.has(i) && itemType != "Null":
			equip_slots[i].initialize_item(
				PlayerInventory.itemNameOnEquip(i),
				PlayerInventory.itemQuantityOnEquip(i),
				ParseItem.string_to_class(itemType))

func slot_gui_input(event: InputEvent, slot: Slot):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
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
		PlayerInventory.emit_signal("update_changes")

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
	PlayerInventory.remove_item(slot)
	find_parent("GUI").holding_item = slot.item
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

func _on_GUI_stats_changed():
	level.text = str("Nivel ", player.level)
	playerName.text = "Test"

func on_slot_mouse_entered(slot: Slot):
	if !item_info.visible && !slot.get_children().empty():
		item_info.show()
		update_description(slot)
	item_info.rect_position = slot.get_global_position() + Vector2(-180.0, -10.0)

func on_slot_mouse_exited(slot):
	#var mouse_is_inside = slot.get_global_rect().has_point(slot.get_global_mouse_position())
	if item_info.visible:# && !mouse_is_inside:
		item_info.hide()

func update_description(slot):
	var item = slot.get_item()
	if item:
		description.text = item.item_name + "\n-------------------\n"
		description.text += "Tipo: " + item.toString() + "\n"
		description.text += "Calidad: " + item.rarity + "\n"
		description.text += "Valor de venta: " + str(item.sell_value) + " Oro\n"
		description.text += item.extra_description()

func get_slot_from_index(i):
	var gear_slots = slots.get_children()
	return gear_slots[i]
