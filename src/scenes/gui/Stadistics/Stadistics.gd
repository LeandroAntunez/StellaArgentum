extends Node2D

onready var player: Player = get_node("/root/Level/Player")
onready var info: Label = $Background/StadisticsContainer/Info
var attributePoints: int = 0
onready var healthButton = $Background/StadisticsContainer/HealthContainer/HealthButton
onready var healthActualMax = $Background/StadisticsContainer/HealthContainer/HealthActualMax
onready var manaButton = $Background/StadisticsContainer/ManaContainer/ManaButton
onready var manaActualMax = $Background/StadisticsContainer/ManaContainer/ManaActualMax
onready var attackMinMax = $Background/StadisticsContainer/AttackContainer/AttackMinMax
onready var armorPoints = $Background/StadisticsContainer/ArmorContainer/ArmorPoints
const UPGRADEPERCENTAGEVALUE = 20

func _process(delta):
	healthActualMax.text = str(round(player.health), "/", player.health_max)
	manaActualMax.text = str(round(player.mana), "/", player.mana_max)
	attackMinMax.text = str(player.min_attack, "-", player.attack_damage)
	armorPoints.text = str(player.armor)

func _input(event):
	if event.is_action_pressed("stadistics"):
		visible = !visible

func level_up():
	update_leveling_ui()

func _on_HealthButton_pressed():
	var upgradeValueToAdd: int = upgrade_value("health_max")
	player.upgrade_attribute("health_max", upgradeValueToAdd)
	update_leveling_ui()

func _on_ManaButton_pressed():
	var upgradeValueToAdd: int = upgrade_value("mana_max")
	player.upgrade_attribute("mana_max", upgradeValueToAdd)
	update_leveling_ui()

func update_leveling_ui():
	attributePoints = player.attribute_points
	if attributePoints > 0:
		show_leveling_ui()
	else:
		hide_leveling_ui()

func show_leveling_ui():
	healthButton.visible = true
	manaButton.visible = true
	info.visible = true
	info.text = str("Puntos de Atributo disponibles: ", attributePoints)

func hide_leveling_ui():
	healthButton.visible = false
	manaButton.visible = false
	info.text = ""

# Returns the upgrade value. Actually, is a 20% of the attribute used.
func upgrade_value(attributeName):
	var attributeValue = player.get(attributeName)
	return (attributeValue * UPGRADEPERCENTAGEVALUE) / attributeValue 

func _on_GUI_stats_changed():
	update_leveling_ui()
