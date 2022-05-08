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
	dialoguePopup.npc_name = "Capitan Viktor"
	
	match dialogue_state:
		0:
			# Update dialogue tree state
			dialogue_state = 1
			# Show dialogue popup
			dialoguePopup.dialogue = "Alto ahi! No puedes seguir avanzando. Es una zona\nrestringida."
			dialoguePopup.answers = "[A] Necesito llegar al crater.  [B] Entendido."
			dialoguePopup.open()
		1:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 2
					# Show dialogue popup
					dialoguePopup.dialogue = "Eso no va a suceder, es un suicidio. \nA duras penas estamos conteniendo\na las criaturas que despertó ese meteorito."
					dialoguePopup.answers = "[A] ¿Puedo ser de ayuda?.  [B] Lo que digas."
					dialoguePopup.open()
				"B":
					# Update dialogue tree state
					dialogue_state = 0
					dialoguePopup.close()
		2:
			match answer:
				"A":
					# Update dialogue tree state
					dialogue_state = 3
					# Show dialogue popup
					dialoguePopup.dialogue = "Si, necesitamos toda la ayuda posible. Hay un pueblo\nal sur, siguiendo el lago, que se encuentra en\napuros y no tenemos guardias suficientes."
					dialoguePopup.answers = "[A] Iré allí entonces <<pero llegaré al crater>>."
					dialoguePopup.open()
					$QuestSign.hide()
					questHandler.change_objective("Caída del meteorito", "Debo ayudar al pueblo del lago,\n quizás así llegue al crater.")
		3:
			match answer:
				"A":
					#dialoguePopup.dialogue = "¿Qué estas mirando?, cada segundo que pasa,\n el mal seguirá creciendo."
					#dialoguePopup.answers = "[A] Ire alli entonces (pero llegare al crater)."
					dialoguePopup.close()
