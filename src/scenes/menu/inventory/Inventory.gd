extends Node2D

onready var inventory_slots = $GridContainer
onready var equip_slots = $EquipSlots.get_children()
onready var gold = $TextureRect/Gold
onready var player = get_node("/root/Level/Player")

func _ready():
	var slots = inventory_slots.get_children()
	set_gold(player.gold)
	for i in range(slots.size()):
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
		slots[i].slotType = Slot.SlotType.INVENTORY
	
	for i in range(equip_slots.size()):
		equip_slots[i].connect("gui_input", self, "slot_gui_input", [equip_slots[i]])
		equip_slots[i].slot_index = i
	equip_slots[0].slotType = Slot.SlotType.TORSO
	equip_slots[1].slotType = Slot.SlotType.LEGS
	equip_slots[2].slotType = Slot.SlotType.SHOES
	equip_slots[3].slotType = Slot.SlotType.WEAPON

	initialize_inventory()
	initialize_equips()

func initialize_inventory():
	var slots = inventory_slots.get_children()
	for i in range(slots.size()):
		initialize_slot(slots, i)

func initialize_slot(slots, i):
	if PlayerInventory.inventory.has(i):
		var itemType: String = PlayerInventory.itemTypeOnSlot(i)
		slots[i].initialize_item(
				PlayerInventory.itemNameOnSlot(i),
				PlayerInventory.itemQuantityOnSlot(i),
				ParseItem.string_to_class(itemType))

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

func set_gold(amount: int):
	gold.text = str("ORO: ", amount)
