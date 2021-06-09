extends Node2D

onready var level_one = load("res://scenes/level/forest/Forest.tscn")
onready var main_menu = load("res://scenes/menu/mainMenu/MainMenu.tscn")
onready var input = $UI/Background/PanelInput/Input
var regEx_rule = "^(?=.{2,16}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
signal confirm

func _ready():
	input.grab_focus()

func _on_EnterName_pressed():
	var name = input.text
	var result = validate_name(name)
	if result != null:
		emit_signal("confirm", result.get_string())

func validate_name(name):
	var regex = RegEx.new()
	regex.compile(regEx_rule)
	return regex.search(name)

func _on_ConfirmCharacterButton_pressed():
	GlobalPlayer.character_name = input.text
	get_tree().change_scene_to(level_one)

func _on_Cancel_pressed():
	get_tree().change_scene_to(main_menu)

