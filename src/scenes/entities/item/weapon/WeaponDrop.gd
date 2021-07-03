extends "res://scenes/entities/item/ItemDrop.gd"
class_name WeaponDrop

const weapon = preload("res://scenes/entities/item/weapon/Weapon.tscn")

func pick_up_item(body):
	.pick_up_item(body)
	PlayerInventory.add_item(self)
	queue_free()

func init_item():
	.init_item()
	return weapon.instance()

func toString():
	return "Weapon"
