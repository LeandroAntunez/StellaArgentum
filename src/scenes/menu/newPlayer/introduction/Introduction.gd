extends Node2D

export (PackedScene) var scn_game
onready var fx: AudioStreamPlayer = $Audio/FX
onready var tween: Tween = $ColorRect/History/Tween
onready var history: RichTextLabel = $ColorRect/History
var text_speed = 0.1

func _ready():
	handle_audio()
	tween.start()

func _process(_delta):
	pass#var total_words = history.text.length()
	#var tween_duration = text_speed * total_words
	#history.percent_visible = 0
	#tween.interpolate_property(history, "percent_visible", 0, 1, tween_duration,
	#Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)

func _on_BeginButton_pressed():
	var _scene = get_tree().change_scene_to(scn_game)

func _on_MeteorSoundTimer_timeout():
	if Gamehandler.playMusic:
		fx.play()

func handle_audio():
	if Gamehandler.playMusic:
		$Audio/BGM.play()
	else:
		$Audio/BGM.stop()

func _on_NarratorSoundTimer_timeout():
	if Gamehandler.playMusic:
		$Audio/Narrator.play()
