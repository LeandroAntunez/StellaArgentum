extends Node
# ParseItem lo que hace es tomar un String, el cual
# corresponde a una subclase de Item (por ejemplo, Weapon),
# y retorna esa subclase.

var itemPath = "res://scenes/entities/item/"

func string_to_class(item: String):
	match item:
		"Weapon":
			return WeaponDrop.new()
		"Torso":
			return TorsoDrop.new()
		"Legs":
			return LegsDrop.new()
		"Consumable":
			return ConsumableDrop.new()

func item_to_itemDrop(item: Item):
	var itemClass = item.toString()
	var itemDrop
	match item.toString():
		"Weapon":
			itemDrop = WeaponDrop.new()
		"Torso":
			itemDrop = TorsoDrop.new()
		"Legs":
			itemDrop = LegsDrop.new()
		"Consumable":
			itemDrop = ConsumableDrop.new()
	itemDrop.item_name = item.item_name
	return itemDrop

func string_to_slot_item(itemCategory: String):
	var path = itemPath+itemCategory+"/"+itemCategory+".tscn"
	return load(path).instance()
