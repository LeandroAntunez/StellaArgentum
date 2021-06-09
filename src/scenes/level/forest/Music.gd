extends AudioStreamPlayer

onready var forest = load("res://assets/audio/music/level/forest/RPG - The Secret Within The Silent Woods.ogg")
onready var game_over = load("res://assets/audio/music/gameover/Death Is Just Another Path.ogg")

func _ready():
	set_audio(forest)

func set_audio(music):
	set_stream(music)
	play()

func _on_Player_death():
	set_audio(game_over)
