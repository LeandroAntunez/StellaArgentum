extends CanvasLayer

func _on_Player_player_stats_changed(player):
	get_node("Health")._on_Player_player_stats_changed(player)
	get_node("Mana")._on_Player_player_stats_changed(player)
	get_node("GameOver")._on_Player_player_stats_changed(player)
