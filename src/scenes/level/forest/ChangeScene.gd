extends Node2D

onready var cave_scene = load("res://scenes/level/cave/Cave.tscn")
onready var end_scene = load("res://scenes/menu/endMenu/EndMenu.tscn")

func _ready():
	pass # Replace with function body.


func _on_Cave_body_entered(body):
	if body.name == "Player":
		GlobalPlayer.save_position(body)
		GlobalPlayer.enter_cave()
		var _scene = get_tree().change_scene_to(cave_scene)

func _on_EndGame_body_entered(body):
	if body.name == "Player":
		var _scene = get_tree().change_scene_to(end_scene)
