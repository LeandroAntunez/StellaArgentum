extends "res://scenes/entities/item/Item.gd"
class_name Consumable

export (int) var add_health
export (int) var add_mana
var usable: bool = true
onready var cooldown = $Cooldown
onready var texture = $TextureRect
onready var player: Player = get_node("/root/Level/Player")

func set_item(nm, qt):
	var potion_from_data = JsonData.item_data[nm]
	id = potion_from_data["ID"]
	add_health = potion_from_data["AddHealth"]
	add_mana = potion_from_data["AddMana"]
	rarity = potion_from_data["Rarity"]
	buy_value = potion_from_data["BuyValue"]
	sell_value = potion_from_data["SellValue"]
	description = potion_from_data["Description"]
	.set_item(nm, qt)

func use(slotOwner):
	if usable:
		.use(slotOwner)
		usable = false
		apply_beneficts()
		update_quantity(slotOwner)

func apply_beneficts():
	player.drink_health_potion(add_health)
	player.drink_mana_potion(add_mana)

func update_quantity(slotOwner):
	decrease_item_quantity(1)
	if item_quantity > 0:
		cooldown.start()
		apply_dark_texture()
	else:
		slotOwner.free_slot()
		call_deferred("free")

func _on_Cooldown_timeout():
	usable = true
	back_to_normal_texture()

func apply_dark_texture():
	texture.modulate = Color(0.2, 0.2, 0.2, 1)

func back_to_normal_texture():
	texture.modulate = Color(1, 1, 1, 1)

func toString() -> String:
	return "Consumable"

func extra_description():
	var description_text = ""
	if add_health > 0:
		description_text += "Recupera Salud: +" + str(add_health) + "\n"
	if add_mana > 0:
		description_text += "Recupera Mana: +" + str(add_mana) + "\n"
	description_text += "-------------------\n"
	description_text += description
	return description_text
