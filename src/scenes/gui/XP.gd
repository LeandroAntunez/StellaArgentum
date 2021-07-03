extends ColorRect

onready var player: Player = get_node("/root/Level/Player")
onready var goldenXPBar: TextureProgress = $GoldenXPBar
onready var tween: Tween = $GoldenXPBar/Tween

func _ready():
	goldenXPBar.value = player.xp
	goldenXPBar.max_value = player.xp_next_level
	$Label.text = str("EXPERIENCIA: ", player.xp, "/", player.xp_next_level)

func _on_Player_player_level_up():
	goldenXPBar.value = player.xp
	goldenXPBar.max_value = player.xp_next_level

func _process(delta):
	var new_xp = player.xp
	tween.interpolate_property(goldenXPBar, 'value', goldenXPBar.value, new_xp, 0.1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	$Label.text = str("EXPERIENCIA: ", player.xp, "/", player.xp_next_level)

func _on_XPBar_mouse_entered():
	$Label.visible = true

func _on_XPBar_mouse_exited():
	$Label.visible = false
