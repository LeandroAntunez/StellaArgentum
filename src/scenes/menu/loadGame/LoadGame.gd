extends Node2D

onready var level_one = load("res://scenes/level/forest/Forest.tscn")
onready var main_menu = load("res://scenes/menu/mainMenu/MainMenu.tscn")
var data: Array
var saveid_selected
signal dataLoaded
# Called when the node enters the scene tree for the first time.
func _ready():
	data = Gamehandler.load_all_games()
	emit_signal("dataLoaded", data)

func _on_GoBack_pressed():
	get_tree().change_scene_to(main_menu)

func _on_LoadGame_pressed():
	var game_to_load
	var stats_to_load
	for game in range(data.size()):
		if data[game].idsave == saveid_selected:
			game_to_load = data[game]
			stats_to_load = Gamehandler.load_stats_table(game_to_load.idsave)
			GlobalPlayer.load_player(stats_to_load)
			get_tree().change_scene_to(level_one)
	# BUSCAR EL QUE TENGA EL ID SELECCIONADO EN DATA

func _on_Accept_pressed():
	pass

func _on_Table_selected(saveid):
	saveid_selected = saveid
