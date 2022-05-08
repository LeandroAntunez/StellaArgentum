extends Popup

onready var load_menu_scene = load("res://scenes/menu/loadGame/LoadGame.tscn")
onready var main_menu_scene = load("res://scenes/menu/mainMenu/MainMenu.tscn")
onready var level = get_node("/root/Level")
onready var saveTween: Tween = $SaveTween
var playerPaused

func _ready():
	set_process_input(false)

func open_pause_screen(player):
	playerPaused = player
	popup()
	set_process_input(true)
	get_tree().paused = true
	
func _on_Continue_pressed():
	hide()
	get_tree().paused = false

func _on_Exit_pressed():
	get_tree().paused = false
	exit_level()
	var _scene = get_tree().change_scene_to(main_menu_scene) #pasarle resultados

func _on_Save_pressed():
	Gamehandler.save(playerPaused)
	$SaveMessage.visible = true
	saveTween.interpolate_property($SaveMessage, "modulate", 
	  Color(1, 1, 1, 1), Color(0.5, 0.5, 0.5, 0), 3.0, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	saveTween.start()

func _on_Load_pressed():
	get_tree().paused = false
	exit_level()
	var _scene = get_tree().change_scene_to(load_menu_scene) #pasarle resultados

func exit_level():
	if level.level_name == "Forest":
		GlobalPlayer.exit_level()
