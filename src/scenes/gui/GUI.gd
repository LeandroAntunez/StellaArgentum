extends CanvasLayer

var holding_item = null
onready var playerGUI  = get_node("/root/Level/Player")
onready var gear: Node2D = $Gear
onready var stadistics: Node2D = $Stadistics
onready var inventory = $Inventory
onready var equip = $Equips
onready var quest = $Quest
signal level_up
signal stats_changed

func _input(event):
	if event.is_action_pressed("scroll_up"):
		PlayerInventory.active_item_scroll_down()
	elif event.is_action_pressed("scroll_down"):
		PlayerInventory.active_item_scroll_up()

func _on_Player_player_stats_changed(player):
	get_node("GameOver")._on_Player_player_stats_changed(player)
	emit_signal("stats_changed")

func _on_Player_player_level_up():
	emit_signal("level_up")

func _on_Player_pause(player):
	get_node("Pause").open_pause_screen(player)

func _on_Player_inventory_open():
	$Inventory.visible = !$Inventory.visible
	$Inventory.initialize_inventory()

func _on_Hotbar_config_pressed():
	_on_Player_pause(playerGUI)

func _on_Hotbar_inventory_pressed():
	_on_Player_inventory_open()
	hide_quest()

func _on_Hotbar_gear_pressed():
	#gear.visible = !gear.visible
	stadistics.visible = !stadistics.visible
	hide_quest()

func free_holding_item():
	holding_item = null

func hide_all():
	equip.hide()
	inventory.hide()
	$Hotbar.hide()
	$XPBar.hide()
	quest.hide()
	$Merchant.hide()
	stadistics.hide()

func _on_GameOver_game_over():
	hide_all()

func _on_Player_quest():
	quest.visible = !quest.visible
	#hide_bag()

func hide_bag():
	hide_equip()
	hide_inventory()

func hide_equip():
	if equip.visible:
		equip.hide()

func hide_inventory():
	if inventory.visible:
		inventory.hide()

func hide_quest():
	if quest.visible:
		quest.hide()

func _on_Hotbar_quest_pressed():
	_on_Player_quest()
	
