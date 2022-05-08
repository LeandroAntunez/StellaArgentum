extends Node2D

onready var level = get_node("/root/Level")
onready var player = get_node("/root/Level/Player")
onready var title = get_node("Background/Title")
onready var body = get_node("Background/Body")
onready var timer = get_node("Timer")

func _ready():
	if is_new_player():
		show_movements()
		timer.start()
	else:
		hide()

func is_new_player():
	return level.level_name == "Forest" && !GlobalPlayer.tutorial_showed

func show_movements():
	title.text = "Movimientos Básicos"
	body.text = "A: Izquierda\nD: Derecha\nW: Arriba\nS: Abajo"

func show_attacks():
	title.text = "Tipos de ataque"
	body.text = "Barra espaciadora: Ataque basico\nCtrl: Bola de fuego (gasta Mana)"
	timer.start()

func show_menues():
	title.text = "Atajo de menúes"
	body.text = "ESC: Pausa\nE: Equipamento\nB: Bolsa\nQ: Diario"
	timer.start()

func _on_Timer_timeout():
	if title.text == "Movimientos Básicos":
		show_attacks()
	elif title.text == "Tipos de ataque":
		show_menues()
	else:
		hide()
		GlobalPlayer.tutorial_ended()
