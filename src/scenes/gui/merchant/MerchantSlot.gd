extends Panel
class_name MerchantSlot

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
	item = get_item()
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

func is_selected():
	selected = true
	refresh_style()

func cancel_selection():
	selected = false
	refresh_style()

func free_slot():
	remove_child(item)
	item = null
	refresh_style()

func get_item():
	if !get_children().empty():
		return get_children()[0]

func add_item(anItem):
	item = anItem
	add_child(anItem)
	refresh_style()
