extends CanvasLayer

var holding_item = null

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

func _on_Player_player_stats_changed(player):
	get_node("Health")._on_Player_player_stats_changed(player)
	get_node("Mana")._on_Player_player_stats_changed(player)
	get_node("GameOver")._on_Player_player_stats_changed(player)
	get_node("HealthPotions")._on_Player_player_stats_changed(player)
	get_node("ManaPotions")._on_Player_player_stats_changed(player)
	get_node("XP")._on_Player_player_stats_changed(player)

func _on_Player_player_level_up():
	get_node("LevelPopup")._on_Player_player_level_up()


func _on_Player_pause(player):
	get_node("Pause").open_pause_screen(player)

func _on_Player_inventory_open():
	$Inventory.visible = !$Inventory.visible
	$Inventory.initialize_inventory()
