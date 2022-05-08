extends StaticBody2D

var dialogue_state = 0
var dialoguePopup
var player
var questHandler

func _ready():
	dialoguePopup = get_tree().root.get_node("Level/Player/GUI/DialoguePopup")
	player = get_tree().root.get_node("Level/Player")
	questHandler = get_node("/root/Level/Player/GUI/Quest")

func talk(answer = ""):
	# Set dialoguePopup npc to Merchant
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Miliciano"
	
	match dialogue_state:
		0:
			# Update dialogue tree state
			dialogue_state = 1
			# Show dialogue popup
			dialoguePopup.dialogue = "No te puedo dejar pasar hasta que los caminos sean mas seguros."
			dialoguePopup.answers = "[A] Entendido."
			dialoguePopup.open()
		1:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 0
					dialoguePopup.close()
