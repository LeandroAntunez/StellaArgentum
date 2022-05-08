extends Node2D
class_name Item

export (int) var id
export (String) var item_name
export (int) var item_quantity
export (int) var stack_size
enum DROPOFF { POOR, COMUN, RARE, EPIC, LEGENDARY }
export (DROPOFF) var rarity
export (int) var buy_value
export (int) var sell_value
export (String, MULTILINE) var description
onready var textureRect = $TextureRect

func set_item(nm, qt):
	item_name = nm
	item_quantity = qt
	$TextureRect.texture = load("res://assets/textures/item/" + item_name + ".png")
	stack_size = int(JsonData.item_data[item_name]["StackSize"])
	if stack_size == 1:
		$Label.visible = false
	else:
		$Label.visible = true
		$Label.text = String(item_quantity)

func use(_slotOwner):
	pass

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)

func toString() -> String:
	return "Item"

func erase():
	free_slot_owner()
	call_deferred("free")

func free_slot_owner():
	var slot = get_parent()
	if slot:
		slot.free_slot()

func extra_description():
	pass
