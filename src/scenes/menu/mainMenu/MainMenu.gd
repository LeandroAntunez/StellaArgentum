extends Node

export (PackedScene) var scn_game
onready var new_game = load("res://scenes/menu/newPlayer/NewPlayer.tscn")
onready var load_game = load("res://scenes/menu/loadGame/LoadGame.tscn")
var dataloaded: Array = []
onready var continueButton = $Menu/HBoxContainer/VBoxContainer/VBoxContainer/Continue
onready var loadButton = $Menu/HBoxContainer/VBoxContainer/VBoxContainer/LoadGame

# Called when the node enters the scene tree for the first time.
func _ready():
	dataloaded = Gamehandler.load_all_games()
	disable_load_buttons()

func _on_Continue_pressed():
	var last_game = Gamehandler.load_last_game()
	if not last_game:
		pass
	else:
		GlobalPlayer.load_player(last_game)
		get_tree().change_scene_to(scn_game)

func _on_LoadGame_pressed():
	get_tree().change_scene_to(load_game)

func disable_load_buttons():
	if dataloaded.empty():
		continueButton.disabled = true
		loadButton.disabled = true

func _on_NewGame_pressed():
	get_tree().change_scene_to(new_game)


func _on_Exit_pressed():
	get_tree().quit()
