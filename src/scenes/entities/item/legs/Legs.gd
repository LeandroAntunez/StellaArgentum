extends "res://scenes/entities/item/Item.gd"
class_name Legs

export (int) var plus_health
export (int) var plus_mana

func _ready():
	item_name = "Blue Jeans"

func set_item(nm, qt):
	var legs_armor_from_data = JsonData.item_data[nm]
	id = legs_armor_from_data["ID"]
	rarity = legs_armor_from_data["Rarity"]
	buy_value = legs_armor_from_data["BuyValue"]
	sell_value = legs_armor_from_data["SellValue"]
	description = legs_armor_from_data["Description"]
	plus_health = legs_armor_from_data["PlusHealth"]
	plus_mana = legs_armor_from_data["PlusMana"]
	.set_item(nm, qt)

func toString() -> String:
	return "Legs"
