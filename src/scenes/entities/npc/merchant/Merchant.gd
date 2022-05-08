extends KinematicBody2D

var dialogue_state = 0
var dialoguePopup
var player
var merchantWindow

func _ready():
	dialoguePopup = get_tree().root.get_node("Level/Player/GUI/DialoguePopup")
	player = get_tree().root.get_node("Level/Player")
	merchantWindow = get_node("/root/Level/Player/GUI/Merchant")

func talk(answer = ""):
	# Set dialoguePopup npc to Merchant
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Merchant"
	
	match dialogue_state:
		0:
			# Update dialogue tree state
			dialogue_state = 1
			# Show dialogue popup
			dialoguePopup.dialogue = "Hola aventurero! Tengo articulos\ninteresantes en venta"
			dialoguePopup.answers = "[A] Dejame ver.  [B] No, gracias."
			dialoguePopup.open()
		1:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 0
					dialoguePopup.close()
					merchantWindow.show()
				"B":
					# Update dialogue tree state
					dialogue_state = 0
					# Show dialogue popup
					dialoguePopup.dialogue = "Si cambias de opinion, me encontraras aqui."
					dialoguePopup.answers = "[A] Adios."
					dialoguePopup.open()

func _on_Area2D_body_exited(body):
	if body.name == "Player":
		merchantWindow.hide()
