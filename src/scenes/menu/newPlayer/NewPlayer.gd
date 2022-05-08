extends Node2D

onready var introduction = load("res://scenes/menu/newPlayer/introduction/Introduction.tscn")
onready var main_menu = load("res://scenes/menu/mainMenu/MainMenu.tscn")
onready var input = $UI/Background/PanelInput/Input
var regEx_rule = "^(?=.{2,16}$)(?![_.])(?!.*[_.]{2})[a-zA-Z0-9._]+(?<![_.])$"
signal confirm

func _ready():
	handle_audio()
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
	var _scene = get_tree().change_scene_to(introduction)

func _on_Cancel_pressed():
	var _scene = get_tree().change_scene_to(main_menu)

func handle_audio():
	if Gamehandler.playMusic:
		$BGM.play()
	else:
		$BGM.stop()
