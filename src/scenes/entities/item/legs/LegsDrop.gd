extends "res://scenes/entities/item/ItemDrop.gd"
class_name LegsDrop

const legs = preload("res://scenes/entities/item/legs/Legs.tscn")

func _ready():
	._ready()

func pick_up_item(body):
	.pick_up_item(body)
	PlayerInventory.add_item(self)
	queue_free()

func init_item():
	.init_item()
	return legs.instance()

func toString():
	return "Legs"
