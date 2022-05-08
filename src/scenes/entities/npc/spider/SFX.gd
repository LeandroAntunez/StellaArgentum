extends AudioStreamPlayer

onready var death = load("res://assets/audio/sfx/npc/spider/death.wav")
onready var attacks = ['attack', 'attack2']
onready var hurt = 'hurt'

func set_audio(audio):
	set_stream(audio)
	play()

func _on_Spider_attack():
	var rand_nb = randi() % attacks.size()
	var attack_sound = load('res://assets/audio/sfx/npc/spider/' + attacks[rand_nb] + '.wav')
	set_audio(attack_sound)

func _on_Spider_death():
	set_audio(death)

func _on_Spider_hurt():
	var hurt_sound = load('res://assets/audio/sfx/npc/spider/' + hurt + '.wav')
	set_audio(hurt_sound)
