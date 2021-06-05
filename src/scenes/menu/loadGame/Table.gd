extends Control

var row = load("res://scenes/menu/loadGame/Row.tscn")
onready var table = get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer")
var sn = 0
var data
var selectedID
signal selected

func set_data(data: Dictionary):
	# Add row
	sn += 1
	var instance = row.instance()
	instance.name = str(sn)
	table.add_child(instance)
	instance.connect("pressed", self, "_on_Button_pressed")
	
	# Changing data of a row
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/idsave").text = str(data.idsave)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/name").text = data.name
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/savetime").text = data.savetime

func _on_Button_pressed(var idsave):
	emit_signal("selected", int(idsave))

func _on_LoadGame_dataLoaded(aData):
	data = aData
	for i in range(0, data.size()):
		set_data(data[i])
