extends Node2D

onready var hotbar_slots = $HotbarSlots
onready var active_item_label = $ActiveItemLabel
onready var icon_tween: Tween = $IconTween
onready var gear_button: Button = $Gear
onready var config_button: Button = $Config
onready var quest_button: Button = $Quest
onready var inventory_button: Button = $Inventory
onready var player: Player = get_node("/root/Level/Player")
signal inventory_pressed
signal gear_pressed
signal config_pressed
signal quest_pressed

func _input(event):
	if find_parent("GUI").holding_item:
		find_parent("GUI").holding_item.global_position = get_global_mouse_position()
	if event.is_action_pressed("stadistics"):
		gear_button.pressed = !gear_button.pressed
	elif event.is_action_pressed("pause"):
		config_button.pressed = !config_button.pressed
	elif event.is_action_pressed("quest"):
		quest_button.pressed = !quest_button.pressed
	elif event.is_action_pressed("inventory"):
		inventory_button.pressed = !inventory_button.pressed

func _on_Inventory_pressed():
	emit_signal("inventory_pressed")

func _on_Config_pressed():
	emit_signal("config_pressed")

func _on_Gear_pressed():
	emit_signal("gear_pressed")
	icon_tween.stop_all()

func _on_Quest_pressed():
	emit_signal("quest_pressed")

func _on_GUI_level_up():
	icon_tween.interpolate_property($Gear, "modulate", 
	  Color(1, 1, 1, 1), Color(0.5, 0.5, 0.5, 1), 2.0, 
	  Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	icon_tween.start()

func _on_GUI_stats_changed():
	pass # Replace with function body.

func get_slot_from_index(i):
	var slots = hotbar_slots.get_children()
	return slots[i]

