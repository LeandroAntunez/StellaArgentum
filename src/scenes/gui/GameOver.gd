extends ColorRect

func _on_Player_player_stats_changed(var player):
	if player.health <= 0:
		visible = true
		$AnimationPlayer.play("game over")
