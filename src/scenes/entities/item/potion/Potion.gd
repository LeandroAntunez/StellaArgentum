extends "res://scenes/entities/item/Item.gd"
class_name Potion

enum Potion { HEALTH, MANA }
export(Potion) var type = Potion.HEALTH

func _process(_delta):
	if Engine.editor_hint:
		if type == Potion.MANA:
			$Sprite.region_rect.position.x = 8
		else:
			$Sprite.region_rect.position.x = 0

func _ready():
	if type == Potion.MANA:
		$Sprite.region_rect.position.x = 8
		item_name = "Mana Potion"
	else:
		$Sprite.region_rect.position.x = 0
		item_name = "Health Potion"

func change_type():
	if type == Potion.HEALTH:
		type = Potion.MANA
		item_name = "Mana Potion"
	else:
		type = Potion.HEALTH
		item_name = "Health Potion"

func add_item_quantity(amount_to_add):
	item_quantity += amount_to_add
	$TextureRect/Label.text = str(item_quantity)

func decrease_item_quantity(amount_to_remove):
	item_quantity -= amount_to_remove
	$TextureRect/Label.text = str(item_quantity)

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		body.add_potion(type)
		get_tree().queue_delete(self)
