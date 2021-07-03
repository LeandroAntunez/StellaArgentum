extends ItemDrop
class_name TorsoDrop

const torso = preload("res://scenes/entities/item/torso/Torso.tscn")

func _ready():
	._ready()

func pick_up_item(body):
	.pick_up_item(body)
	PlayerInventory.add_item(self)
	queue_free()

func init_item():
	.init_item()
	return torso.instance()

func toString():
	return "Torso"
