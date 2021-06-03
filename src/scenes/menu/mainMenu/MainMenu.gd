extends Node

export (PackedScene) var scn_game
onready var new_game = load("res://scenes/menu/newPlayer/NewPlayer.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_New_Game_pressed():
	get_tree().change_scene_to(new_game) #pasarle resultados

func _on_Continue_pressed():
	read_last_game_from_db()
	pass # Replace with function body.

func read_last_game_from_db():
	pass
