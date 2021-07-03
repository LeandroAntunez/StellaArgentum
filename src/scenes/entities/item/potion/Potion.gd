extends "res://scenes/entities/item/Item.gd"

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
	else:
		$Sprite.region_rect.position.x = 0

func change_type():
	if type == Potion.HEALTH:
		type = Potion.MANA
	else:
		type = Potion.HEALTH

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
