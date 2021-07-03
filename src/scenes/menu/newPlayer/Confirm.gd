extends Popup

onready var character_name = $Marco/Background/CharacterName

func _ready():
	set_process_input(false)

func _on_NewPlayer_confirm(name):
	character_name.set_text(name)
	set_process_input(true)
	popup()


func _on_CancelCharacterButton_pressed():
	set_process_input(false)
	hide()
