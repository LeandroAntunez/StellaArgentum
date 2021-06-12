extends Panel

var default_texture = preload("res://assets/interface/inventory/item_slot_default_background.png")
var empty_texture = preload("res://assets/interface/inventory/item_slot_empty_background.png")

onready var inventory_node = find_parent("Inventory")
onready var default_style: StyleBoxTexture = StyleBoxTexture.new()
var empty_style: StyleBoxTexture = StyleBoxTexture.new()

var itemClass = preload("res://scenes/entities/item/equipable/weareable/weapon/sword/Sword.tscn")
var item

func _ready():
	default_style.texture = default_texture
	empty_style.texture = empty_texture
	
	if randi() %  2 == 0:
		item = itemClass.instance()
		add_child(item)
		#item.position = Vector2(10, 10)
	refresh_style()

func refresh_style():
	if item == null:
		set('custom_styles/panel', empty_style)
	else:
		set('custom_styles/panel', default_style)

func pickFromSlot():
	remove_child(item)
	inventory_node.add_child(item)
	item = null
	refresh_style()

func putIntoSlot(new_item):
	item = new_item
	item.position = Vector2(0, 0)
	inventory_node.remove_child(item)
	add_child(item)
	refresh_style()
