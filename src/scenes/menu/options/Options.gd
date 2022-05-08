extends Node2D

onready var mainMenu = load("res://scenes/menu/mainMenu/MainMenu.tscn")
onready var controls = load("res://scenes/menu/controls/Controls.tscn")
onready var audio = load("res://scenes/menu/audio/Audio.tscn")

func _ready():
	handle_audio()

func _on_Instructions_pressed():
	pass # Replace with function body.

func _on_Controls_pressed():
	var _scene = get_tree().change_scene_to(controls)

func _on_Audio_pressed():
	var _scene = get_tree().change_scene_to(audio)

func _on_Exit_pressed():
	var _scene = get_tree().change_scene_to(mainMenu)

func handle_audio():
	if Gamehandler.playMusic:
		$BGM.play()
	else:
		$BGM.stop()
