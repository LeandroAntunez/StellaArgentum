extends ColorRect

func _on_Player_player_stats_changed(var player):
	$ManaIcon/Amount.text = str(player.mana_potions)
