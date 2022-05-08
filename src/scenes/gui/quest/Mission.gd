extends VBoxContainer
class_name Mission

var title: String
var objective: String
var currentCount: int = 0
var count: int
var returnMessage: String
enum Status {
	ACTIVE,
	RETURNING,
	FINISHED
}
var currentStatus = Status.ACTIVE
onready var titleLabel = get_node("Title")
onready var objectiveLabel = get_node("Details/Objective")
onready var countLabel = get_node("Details/Count")

func _ready():
	pass

func initialize(aTitle, anObjective, aCount, aReturnMessage):
	title = aTitle
	objective = anObjective
	count = aCount
	returnMessage = aReturnMessage
	update_labels()

func update_labels():
	if currentStatus == Status.ACTIVE:
		titleLabel.text = title
		objectiveLabel.text = objective
		countLabel.text = str(currentCount) + "/" + str(count)
		check_count()
	elif currentStatus == Status.RETURNING:
		objectiveLabel.text = returnMessage
	else:
		hide()

func update_count(newCount):
	if currentStatus == Status.ACTIVE:
		currentCount += newCount
		if currentCount >= count:
			countLabel.hide()
			return_mission()
		update_labels()

func return_mission():
	currentStatus = Status.RETURNING

func finish_mission():
	currentStatus = Status.FINISHED
	update_labels()

func is_returning():
	return currentStatus == Status.RETURNING

func change_objective(new_objective):
	objectiveLabel.text = new_objective

func check_count():
	if count < 1:
		countLabel.hide()
