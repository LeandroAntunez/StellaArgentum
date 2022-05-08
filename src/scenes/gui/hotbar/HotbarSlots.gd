extends GridContainer

onready var slots = get_children()
onready var active_item_label = get_node("/root/Level/Player/GUI/Hotbar/ActiveItemLabel")

func _ready():
	var _activeItem = PlayerInventory.connect("active_item_updated", self, "update_active_item_label")
	for i in range(slots.size()):
		var _refreshStyle = PlayerInventory.connect("active_item_updated", slots[i], "refresh_style")
		slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slotType = Slot.SlotType.HOTBAR
		slots[i].slot_index = i
	initialize_hotbar()
	update_active_item_label()

func update_active_item_label():
	if is_instance_valid(slots[PlayerInventory.active_item_slot].item):
		active_item_label.text = slots[PlayerInventory.active_item_slot].item.item_name
	else:
		active_item_label.text = ""

func initialize_hotbar():
	for i in range(slots.size()):
		if PlayerInventory.hotbar.has(i) && PlayerInventory.hotbar[i][0] != "Null":
			var itemName = PlayerInventory.hotbar[i][0]
			var itemQuantity = PlayerInventory.hotbar[i][1]
			var itemType = ParseItem.string_to_class(PlayerInventory.hotbar[i][2])
			slots[i].initialize_item(itemName, itemQuantity, itemType)

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
			update_active_item_label()

func left_click_empty_slot(slot: Slot):
	PlayerInventory.add_item_to_empty_slot(find_parent("GUI").holding_item, slot)
	slot.putIntoSlot(find_parent("GUI").holding_item)
	find_parent("GUI").holding_item = null
	
func left_click_different_item(event: InputEvent, slot: Slot):
	PlayerInventory.remove_item(slot)
	PlayerInventory.add_item_to_empty_slot(find_parent("GUI").holding_item, slot)
	var temp_item = slot.item
	slot.pickFromSlot()
	temp_item.global_position = event.global_position
	slot.putIntoSlot(find_parent("GUI").holding_item)
	find_parent("GUI").holding_item = temp_item

func left_click_same_item(slot: Slot):
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
