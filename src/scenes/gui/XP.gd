extends ColorRect

func _on_Player_player_stats_changed(player):
	$ValueXP.text = str(player.xp) + "/" + str(player.xp_next_level)
	$ValueLVL.text = str(player.level)
