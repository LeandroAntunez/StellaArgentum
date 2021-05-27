extends CanvasLayer

func _on_Player_player_stats_changed(player):
	get_node("Health")._on_Player_player_stats_changed(player)
	get_node("Mana")._on_Player_player_stats_changed(player)
	get_node("GameOver")._on_Player_player_stats_changed(player)
	get_node("HealthPotions")._on_Player_player_stats_changed(player)
	get_node("ManaPotions")._on_Player_player_stats_changed(player)
	get_node("XP")._on_Player_player_stats_changed(player)

func _on_Player_player_level_up():
	print("2")
	get_node("LevelPopup")._on_Player_player_level_up()
