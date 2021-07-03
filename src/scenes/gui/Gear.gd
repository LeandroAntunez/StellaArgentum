extends Node2D

onready var player: Player = get_node("/root/Level/Player")
onready var playerName: Label = $VBoxContainer/Equipment/PlayerName

func _ready():
	playerName.text = GlobalPlayer.character_name
