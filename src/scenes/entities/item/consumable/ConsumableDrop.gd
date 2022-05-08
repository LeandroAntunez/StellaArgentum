extends "res://scenes/entities/item/ItemDrop.gd"
class_name ConsumableDrop

const consumable = preload("res://scenes/entities/item/consumable/Consumable.tscn")

func _ready():
	._ready()

func pick_up_item(body):
	.pick_up_item(body)
	PlayerInventory.add_item(self)
	queue_free()

func init_item():
	.init_item()
	return consumable.instance()

func toString():
	return "Consumable"
