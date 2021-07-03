extends AudioStreamPlayer

onready var swings = ['swing', 'swing2', 'swing3']
onready var fireballSound = load('res://assets/audio/sfx/spells/fireball/fireball_launch.wav')
onready var death = load('res://assets/audio/sfx/character/death/death.wav')
onready var level_up = load('res://assets/audio/sfx/character/levelup/levelup.wav')

func set_audio(sound):
	set_stream(sound)
	play()

func swing():
	var rand_nb = randi() % swings.size()
	var swing_sound = load('res://assets/audio/sfx/weapons/sword/' + swings[rand_nb] + '.wav')
	set_audio(swing_sound)

func _on_Player_attack(weapon):
	match weapon:
		"sword":
			swing()
		_:
			pass

func _on_Player_spell(spell):
	match spell:
		"fireball":
			fireball()
		_:
			pass

func fireball():
	set_audio(fireballSound)

func _on_Player_death():
	set_audio(death)

func _on_Player_player_level_up():
	set_audio(level_up)
