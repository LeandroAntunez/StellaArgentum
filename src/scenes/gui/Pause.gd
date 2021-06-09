extends Popup

onready var main_menu_scene = load("res://scenes/menu/mainMenu/MainMenu.tscn")
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
	get_tree().change_scene_to(main_menu_scene) #pasarle resultados

func _on_Save_pressed():
	Gamehandler.save(playerPaused)
