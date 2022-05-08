extends Node2D

onready var list = get_node("/root/Level/Player/GUI/Quest/Background/Paper/Scroll/List")
const MISSION = preload("res://scenes/gui/quest/Mission.tscn")

func _ready():
	new_mission("Caída del meteorito", "Busca alguna manera de llegar\na la zona de impacto", 0, "Misión cumplida")

func new_mission(title, objective, count, returnMessage):
	if is_a_new_mission(title):
		var mission = MISSION.instance()
		mission._ready()
		mission.initialize(title, objective, count, returnMessage)
		list.add_child(mission)

func update_mission(title, count):
	if exists_mission_by_title(title):
		find_mission_by_title(title).update_count(count)

func finish_mission(title):
	find_mission_by_title(title).finish_mission()

func return_mission(title):
	find_mission_by_title(title).return_mission()

func is_a_new_mission(title: String):
	return find_mission_by_title(title) == null

func find_mission_by_title(title: String):
	for mission in find_all_mission():
		if mission.title == title:
			return mission

func find_all_mission() -> Array:
	var mission_list = list.get_children()
	if mission_list.empty():
		return []
	else:
		return mission_list

func is_returning_mission(title):
	return find_mission_by_title(title).is_returning()
	

func exists_mission_by_title(title):
	return find_mission_by_title(title) != null

func change_objective(title, new_objective):
	find_mission_by_title(title).change_objective(new_objective)
