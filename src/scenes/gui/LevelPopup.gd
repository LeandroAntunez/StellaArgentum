extends Popup

var player

func _ready():
	player = get_tree().root.get_node("Level/Player")
	set_process_input(false)

func _on_Player_player_level_up():
	set_process_input(true)
	popup()

func _input(event):
	if event is InputEventKey:
		if event.scancode == KEY_Q:
			player.health_max += 50
			player.health += 50
			player.emit_signal("player_stats_changed", player)
			hide()
			set_process_input(false)
		elif event.scancode == KEY_E:
			player.mana_max += 50
			player.mana += 50
			player.emit_signal("player_stats_changed", player)
			hide()
			set_process_input(false)
