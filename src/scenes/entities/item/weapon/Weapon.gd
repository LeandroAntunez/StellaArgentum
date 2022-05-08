extends "res://scenes/entities/item/Item.gd"
class_name Weapon

export (int) var damage_min
export (int) var damage_max

func _ready():
	._ready()

func set_item(nm, qt):
	var weapon_from_data = JsonData.item_data[nm]
	id = weapon_from_data["ID"]
	rarity = weapon_from_data["Rarity"]
	buy_value = weapon_from_data["BuyValue"]
	sell_value = weapon_from_data["SellValue"]
	description = weapon_from_data["Description"]
	damage_max = weapon_from_data["DamageMax"]
	damage_min = weapon_from_data["DamageMin"]
	.set_item(nm, qt)

func toString() -> String:
	return "Weapon"

func extra_description():
	var description_text = "Daño: " + str(damage_min) + "-" + str(damage_max)
	description_text += "\n-------------------\n"
	description_text += description
	return description_text
