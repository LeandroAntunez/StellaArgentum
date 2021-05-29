extends AudioStreamPlayer

onready var death = load("res://assets/audio/sfx/npc/skeleton/death.wav")
onready var attacks = ['attack', 'attack2']
onready var hurts = ['hurt', 'hurt2']

func set_audio(audio):
	set_stream(audio)
	play()

func _on_Skeleton_attack():
	var rand_nb = randi() % attacks.size()
	var attack_sound = load('res://assets/audio/sfx/npc/skeleton/' + attacks[rand_nb] + '.wav')
	set_audio(attack_sound)

func _on_Skeleton_hurt():
	var rand_nb = randi() % hurts.size()
	var hurt_sound = load('res://assets/audio/sfx/npc/skeleton/' + hurts[rand_nb] + '.wav')
	set_audio(hurt_sound)

func _on_Skeleton_death():
	set_audio(death)
