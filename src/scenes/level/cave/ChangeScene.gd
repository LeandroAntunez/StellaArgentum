extends Node2D

onready var forest_scene = load("res://scenes/level/forest/Forest.tscn")

func _on_Cave_body_entered(body):
	if body.name == "Player":
		GlobalPlayer.exit_cave()
		var _scene = get_tree().change_scene_to(forest_scene)
