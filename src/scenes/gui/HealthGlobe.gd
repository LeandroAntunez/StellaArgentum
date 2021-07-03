extends Node

onready var health_globe: TextureProgress = get_node("GlobeTransparent/TextureProgress")
onready var health_globe_tween: Tween = get_node("GlobeTransparent/TextureProgress/Tween")
onready var health_amount: Label = get_node("GlobeTransparent/HealthAmount")
onready var player = get_node("/root/Level/Player")

func _ready():
	health_globe.value = player.health
	health_globe.max_value = player.health_max
	health_amount.text = str("SALUD\n", round(player.health), "/", player.health_max)

func _process(delta):
	var new_health = player.health
	health_globe_tween.interpolate_property(health_globe, 'value', health_globe.value, new_health, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	health_globe_tween.start()
	health_amount.text = str("SALUD\n", round(player.health), "/", player.health_max)

func _on_GlobeTransparent_mouse_entered():
	health_amount.visible = true

func _on_GlobeTransparent_mouse_exited():
	health_amount.visible = false
