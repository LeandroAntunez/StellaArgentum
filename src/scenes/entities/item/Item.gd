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

func _ready():
	var rand_val = randi() % 3
	if rand_val == 0:
		item_name = "Iron Sword"
	elif rand_val == 1:
		item_name = "Tree Branch"
	else:
		item_name = "Slime Potion"
	
	#textureRect.texture = load("res://assets/textures/item/" + item_name + ".png")
	#var stack_size = int(JsonData.item_data[item_name]["StackSize"])
	#item_quantity = randi() % stack_size + 1
	
	#if stack_size == 1:
	#	$Label.visible = false
	#else:
	#	$Label.text = String(item_quantity)


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

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$Label.text = String(item_quantity)
	
func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$Label.text = String(item_quantity)

func toString() -> String:
	return "Item"
