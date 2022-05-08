extends Area2D
var fiona
var questHandler

func _ready():
	questHandler = get_node("/root/Level/Player/GUI/Quest")
	fiona = get_tree().root.get_node("Level/NPCs/Friend/Fiona")

func _on_Necklace_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		fiona.necklace_found = true
		questHandler.update_mission("Tesoro familiar", 1)
