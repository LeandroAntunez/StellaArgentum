extends StaticBody2D

enum QuestStatus { NOT_STARTED, STARTED, COMPLETED }
enum QuestStatus2 { NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var quest_status2 = QuestStatus.NOT_STARTED
var dialogue_state = 0
var skeleton_killed_required = 5
var captain_skeleton_killed = false
var necklace_found = false
var dialoguePopup
var player
enum Potion { HEALTH, MANA }
onready var questHandler
var level
var townGuard

func _ready():
	dialoguePopup = get_tree().root.get_node("Level/Player/GUI/DialoguePopup")
	player = get_tree().root.get_node("Level/Player")
	questHandler = get_node("/root/Level/Player/GUI/Quest")
	level = get_node("/root/Level")
	set_the_townguard()

func quest_completed():
	return skeleton_killed_required <= GlobalPlayer.skeleton_killed

func set_the_townguard():
	if level.level_name == "Forest":
		townGuard = get_node("/root/Level/NPCs/Friend/Townguard")

func dismiss_townguard():
	townGuard.queue_free()

func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Anciano del Pueblo del Lago"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Bienvenido al pueblo, aventurero! Desde que\ncayo el meteorito, un mal se ha\n levantado sobre estas tierras."
					dialoguePopup.answers = "[A] Puedo pasar?"
					dialoguePopup.open()
				1:
					dialogue_state = 2
					dialoguePopup.dialogue = " Claro, pasa, puedes comprar provisiones en\nla feria. Si estas interesado, tengo\n una importante mision para ti."
					dialoguePopup.answers = "[A] Acepto. [B] No, gracias."
					dialoguePopup.open()
				2:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Seria bueno para la seguridad de\nla aldea deshacerse de esos esqueletos.\nSe han levantado del cementerio y son una amenaza."
							dialoguePopup.answers = "[A] Yo me encargo."
							dialoguePopup.open()
							$QuestSign.play("subreward")
							questHandler.new_mission("Amenaza en el cementerio", "Elimina 5 esqueletos.", 5, "Regresa con el Sabio del Pueblo del Lago.")
						"B":
							# Update dialogue tree state
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Si cambias de opinion, me encontraras aqui."
							dialoguePopup.answers = "[A] Adios"
							dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					#$Body.play("idle")
				4:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					#$Body.play("idle")
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Te encargaste de los esqueletos?"
					if questHandler.is_returning_mission("Amenaza en el cementerio"):
						dialoguePopup.answers = "[A] Si  [B] No"
					else:
						dialoguePopup.answers = "[A] No"
					dialoguePopup.open()
				1:
					if quest_completed() and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "Eres mi heroe! tienes toda mi gratitud!"
						dialoguePopup.answers = "[A] Gracias a ti"
						dialoguePopup.open()
						questHandler.finish_mission("Amenaza en el cementerio")
						$QuestSign.play("questcomplete")
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.dialogue = "Por favor, que sigan descansando en paz!"
						dialoguePopup.answers = "[A] Lo hare!"
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					#$Body.play("idle")
					# Add potion and XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					
					player.add_xp(25)
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					#$Body.play("idle")
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Gracias de nuevo, pero necesitamos un\núltimo favor. Si lo que describió Kate es cierto,\nentonces estamos en verdaderos problemas."
					dialoguePopup.answers = "[A] Dime.  [B] Tengo asuntos más importantes."
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Update dialogue tree state
							dialogue_state = 2
							# Show dialogue popup
							dialoguePopup.dialogue = "Mientras Kate huía, vió de reojo como se\nlevantaba una tumba gigante."
							dialoguePopup.answers = "[A] ¿Qué tenia de especial?"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 0
							# Show dialogue popup
							dialoguePopup.dialogue = "Si cambias de opinion, me encontraras aqui."
							dialoguePopup.answers = "[A] Adios"
							dialoguePopup.open()
				2:
					match answer:
						"A":
							dialogue_state = 3
							# Show dialogue popup
							dialoguePopup.dialogue = "Esa tumba pertenece al Gran Mariscal Alexandros,\nantiguo héroe de nacido en este pueblo."
							dialoguePopup.answers = "[A] ¿Dónde lo puedo encontrar?"
							dialoguePopup.open()
				3:
					match answer:
						"A":
							dialogue_state = 4
							dialoguePopup.dialogue = "Lo encontrarás en la vieja Caverna al sur, pasando\nel Cementerio. No dejes que el Gran Mal lo convierta\nen un poderoso enemigo, y ponle fin."
							dialoguePopup.answers = "[A] Iré ya mismo."
							quest_status2 = QuestStatus2.STARTED
							$QuestSign.play("subreward")
							questHandler.new_mission("El fin del viejo Héroe", "Elimina al Gran Mariscal Alexandros.\nSe encuentra en la Caverna al sur del Cementerio.", 1, "Regresa con el Sabio del Pueblo del Lago.")
							# Close dialogue popup
							dialoguePopup.open()
				4:
					match answer:
						"A":
							dialogue_state = 0
							dialoguePopup.close()
		QuestStatus2.STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "¿Lograste vencer a Alexandros?"
					if questHandler.is_returning_mission("El fin del viejo Héroe"):
						dialoguePopup.answers = "[A] Si"
					else:
						dialoguePopup.answers = "[A] Aún no"
					dialoguePopup.open()
				1:
					if quest_completed() and answer == "A":
						# Update dialogue tree state
						dialogue_state = 2
						# Show dialogue popup
						dialoguePopup.dialogue = "Que encuentre la paz nuevamente. En cuanto a tí, el pueblo es un lugar más seguro\n, asique ya puedes seguir tu camino hacia el este."
						dialoguePopup.answers = "[A] Gracias a su hospitalidad. Me pondre en marcha."
						dialoguePopup.open()
						questHandler.finish_mission("El fin del viejo Héroe")
						$QuestSign.play("questcomplete")
					else:
						# Update dialogue tree state
						dialogue_state = 3
						# Show dialogue popup
						dialoguePopup.dialogue = "Por favor, dale un fin honorable!"
						dialoguePopup.answers = "[A] Lo hare!"
						dialoguePopup.open()
				2:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status2 = QuestStatus2.COMPLETED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					#$Body.play("idle")
					# Add potion and XP to the player. 
					yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
					player.add_xp(25)
				3:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Fiona's animation to "idle"
					#$Body.play("idle")
		QuestStatus2.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Gracias de nuevo, siempre serás bienvenido."
					dialoguePopup.answers = "[A] Hasta pronto."
					dialoguePopup.open()
