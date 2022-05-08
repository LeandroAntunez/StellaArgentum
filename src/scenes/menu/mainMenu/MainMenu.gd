extends Node

export (PackedScene) var scn_game
onready var new_game = load("res://scenes/menu/newPlayer/NewPlayer.tscn")
onready var load_game = load("res://scenes/menu/loadGame/LoadGame.tscn")
onready var options = load("res://scenes/menu/options/Options.tscn")
var dataloaded: Array = []
onready var continueButton = $CanvasLayer/Continue
onready var loadButton = $CanvasLayer/LoadGame

# Called when the node enters the scene tree for the first time.
func _ready():
	handle_audio()
	dataloaded = Gamehandler.load_all_games()
	disable_load_buttons()

func _on_Continue_pressed():
	var last_game = Gamehandler.load_last_game()
	if not last_game:
		pass
	else:
		var _scene = get_tree().change_scene_to(scn_game)

func _on_LoadGame_pressed():
	var _scene = get_tree().change_scene_to(load_game)

func disable_load_buttons():
	if dataloaded.empty():
		continueButton.disabled = true
		loadButton.disabled = true

func _on_NewGame_pressed():
	var _scene = get_tree().change_scene_to(new_game)

func _on_Exit_pressed():
	get_tree().quit()

func _on_Options_pressed():
	var _scene = get_tree().change_scene_to(options)

func handle_audio():
	if Gamehandler.playMusic:
		$BGM.play()
	else:
		$BGM.stop()
