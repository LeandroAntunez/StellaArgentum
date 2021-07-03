extends "res://scenes/entities/item/Item.gd"
class_name Torso

export (int) var plus_health
export (int) var plus_mana

func _ready():
	item_name = "Brown Shirt"

func set_item(nm, qt):
	var chest_armor_from_data = JsonData.item_data[nm]
	id = chest_armor_from_data["ID"]
	rarity = chest_armor_from_data["Rarity"]
	buy_value = chest_armor_from_data["BuyValue"]
	sell_value = chest_armor_from_data["SellValue"]
	description = chest_armor_from_data["Description"]
	plus_health = chest_armor_from_data["PlusHealth"]
	plus_mana = chest_armor_from_data["PlusMana"]
	.set_item(nm, qt)

func toString() -> String:
	return "Torso"
