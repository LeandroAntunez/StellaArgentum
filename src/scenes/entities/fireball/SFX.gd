extends AudioStreamPlayer

onready var explodes = load("res://assets/audio/sfx/spells/fireball/fireball_explodes.wav")

func set_audio(audio):
	set_stream(audio)
	play()

func _on_Fireball_explode():
	set_audio(explodes)
