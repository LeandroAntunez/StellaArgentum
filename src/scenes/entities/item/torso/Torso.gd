extends "res://scenes/entities/item/Item.gd"
class_name Torso

export (int) var plus_health
export (int) var plus_mana
export (int) var armor

func set_item(nm, qt):
	var chest_armor_from_data = JsonData.item_data[nm]
	id = chest_armor_from_data["ID"]
	rarity = chest_armor_from_data["Rarity"]
	buy_value = chest_armor_from_data["BuyValue"]
	sell_value = chest_armor_from_data["SellValue"]
	description = chest_armor_from_data["Description"]
	plus_health = chest_armor_from_data["PlusHealth"]
	plus_mana = chest_armor_from_data["PlusMana"]
	armor = chest_armor_from_data["ArmorPoints"]
	.set_item(nm, qt)

func toString() -> String:
	return "Torso"

func extra_description():
	var description_text = "Armadura: " + str(armor) + "\n"
	if plus_health > 0:
		description_text += "Salud Extra: +" + str(plus_health) + "\n"
	if plus_mana > 0:
		description_text += "Mana Extra: +" + str(plus_mana) + "\n"
	description_text += "-------------------\n"
	description_text += description
	return description_text
