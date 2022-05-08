extends Node2D

onready var options = load("res://scenes/menu/options/Options.tscn")

func _ready():
	$CanvasLayer/Music.pressed = Gamehandler.playMusic

func _on_Music_pressed():
	Gamehandler.change_music_state()


func _on_Exit_pressed():
	var _scene = get_tree().change_scene_to(options)
