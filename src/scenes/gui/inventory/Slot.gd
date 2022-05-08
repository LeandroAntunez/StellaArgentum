extends Panel
class_name Slot

var default_tex = preload("res://assets/interface/inventory/item_slot_default_background.png")
var empty_tex = preload("res://assets/interface/inventory/item_slot_empty_background.png")
var selected_tex = preload("res://assets/interface/inventory/item_slot_selected_background.png")

var default_style: StyleBoxTexture = null
var empty_style: StyleBoxTexture = null
var selected_style: StyleBoxTexture = null

var ItemClass = preload("res://scenes/entities/item/Item.tscn")
var item = null
var slot_index
var selected = false

enum SlotType {
	HOTBAR = 0,
	INVENTORY,
	TORSO,
	LEGS,
	SHOES,
	WEAPON,
	MERCHANT
}

var slotType = null

func _ready():
	default_style = StyleBoxTexture.new()
	empty_style = StyleBoxTexture.new()
	selected_style = StyleBoxTexture.new()
	default_style.texture = default_tex
	empty_style.texture = empty_tex
	selected_style.texture = selected_tex
	refresh_style()

func refresh_style():
	if selected:
		set('custom_styles/panel', selected_style)
	elif item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func pickFromSlot():
	find_parent("GUI").add_child(item)
	free_slot()

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	find_parent("GUI").remove_child(item)
	add_child(item)
	refresh_style()

func initialize_item(item_name, item_quantity, itemDrop):
	if item == null:
		item = itemDrop.init_item()
		item.set_item(item_name, item_quantity)
		add_child(item)
	else:
		item.set_item(item_name, item_quantity)
	refresh_style()

func _input(event):
	if is_in_group(event.as_text()) && is_instance_valid(item):
		item.use(self)

func free_slot():
	remove_child(item)
	item = null
	refresh_style()

func get_item():
	if !get_children().empty():
		return get_children()[0]

func is_selected():
	selected = true
	refresh_style()

func cancel_selection():
	selected = false
	refresh_style()
