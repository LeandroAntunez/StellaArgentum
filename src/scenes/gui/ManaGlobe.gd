extends Node

onready var mana_globe: TextureProgress = get_node("GlobeTransparent/TextureProgress")
onready var mana_globe_tween: Tween = get_node("GlobeTransparent/TextureProgress/Tween")
onready var mana_amount: Label = get_node("GlobeTransparent/ManaAmount")
onready var player = get_node("/root/Level/Player")

func _ready():
	mana_globe.value = player.mana
	mana_globe.max_value = player.mana_max
	mana_amount.text = str("MANA\n", round(player.mana), "/", player.mana_max)

func _process(delta):
	var new_mana = player.mana
	mana_globe_tween.interpolate_property(mana_globe, 'value', mana_globe.value, new_mana, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	mana_globe_tween.start()
	mana_amount.text = str("MANA\n", round(player.mana), "/", player.mana_max)

func _on_GlobeTransparent_mouse_entered():
	mana_amount.visible = true

func _on_GlobeTransparent_mouse_exited():
	mana_amount.visible = false
