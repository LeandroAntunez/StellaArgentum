extends Node2D

onready var main_menu = load("res://scenes/menu/mainMenu/MainMenu.tscn")

func _on_BackToMain_pressed():
	var _scene = get_tree().change_scene_to(main_menu)
