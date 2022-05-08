extends Node2D

onready var options = load("res://scenes/menu/options/Options.tscn")

func _on_GoBack_pressed():
	var _scene = get_tree().change_scene_to(options)
