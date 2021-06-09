extends ColorRect

func _on_Player_player_stats_changed(player):
	$Bar.rect_size.x = 240 * player.mana / player.mana_max
