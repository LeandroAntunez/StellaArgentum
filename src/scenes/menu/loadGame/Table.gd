extends Control

var row = load("res://scenes/menu/loadGame/Row.tscn")
onready var table = get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer")
var sn = 0
var data
var selectedID
signal selected

func set_data(rowData: Dictionary):
	# Add row
	sn += 1
	var instance = row.instance()
	instance.name = str(sn)
	table.add_child(instance)
	instance.connect("pressed", self, "_on_Button_pressed")
	
	# Changing data of a row
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/idsave").text = str(rowData.idsave)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/name").text = rowData.name
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/level").text = str(rowData.level)
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/place").text = rowData.place
	get_node("VBoxContainer/PanelContainer2/ScrollContainer/VBoxContainer/"+instance.name+"/savetime").text = rowData.savetime

func _on_Button_pressed(var idsave):
	emit_signal("selected", int(idsave))

func _on_LoadGame_dataLoaded(aData):
	data = aData
	for i in range(0, data.size()):
		set_data(data[i])
