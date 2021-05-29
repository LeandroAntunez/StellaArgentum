extends Node

export (PackedScene) var scn_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Continue_mouse_entered():
	# hacer consulta
	get_tree().change_scene_to(scn_game) #pasarle resultados
