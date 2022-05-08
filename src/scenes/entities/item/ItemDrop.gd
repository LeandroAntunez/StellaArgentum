extends KinematicBody2D
# Clase abstracta item drop
class_name ItemDrop

export (String) var item_name
onready var texture_path = str("res://assets/textures/item/", item_name, ".png")
onready var sprite = $Sprite

func _ready():
	init_texture()

func init_texture():
	sprite.texture = load(texture_path)

func pick_up_item(_body):
	pass

func init_item():
	pass
