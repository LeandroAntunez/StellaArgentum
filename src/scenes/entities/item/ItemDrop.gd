extends KinematicBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var velocity = Vector2.ZERO
var item_name

func _ready():
	item_name = "Slime Potion"

func pick_up_item(body):
	PlayerInventory.add_item(item_name, 1)
	queue_free()
