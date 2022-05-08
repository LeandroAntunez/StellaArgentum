extends VBoxContainer
class_name SellContainer

onready var merchantSlot = get_node("ItemContainer/MerchantSlot")
onready var itemNameLabel = get_node("ItemContainer/ItemName")
onready var locationLabel = get_node("LocationContainer/Location")
onready var slotNumberLabel = get_node("LocationContainer/SlotNumber")
onready var price = get_node("ValueContainer/Price")
export (String) var location # inventory, equips, hotbar
export (int) var slotNumber
var slotItem
var slotItemFromPlayer

func _ready():
	PlayerInventory.connect("update_changes", self, "update")
	#obtain_slot_info()
	update()

func update():
	var item: Array
	var slotDictionary = PlayerInventory.get(location.to_lower())
	if slotDictionary != null:
		if slotDictionary.has(slotNumber):
			item = slotDictionary[slotNumber]
	#obtain_slot_info()
	generate_item(item)

func obtain_slot_info():
	var path = "/root/Level/Player/GUI/"+location
	var slotsContainer = get_node_or_null(path)
	slotItemFromPlayer = slotsContainer.get_slot_from_index(slotNumber)

func generate_item(item: Array):
	if item && item[0] != "Null":
		show()
		var itemName = item[0]
		var itemQuantity = item[1]
		var itemData = JsonData.item_data[itemName]
		var itemInstance = ParseItem.string_to_slot_item(itemData["ItemCategory"])
		itemInstance.set_item(itemName, itemQuantity)
		merchantSlot.add_item(itemInstance)
		slotItem = itemInstance
	else:
		hide()
	update_labels()

func slot_is_empty(slot):
	var children: Array = slot.get_children()
	return children.empty()

func update_labels():
	if slotItem:
		itemNameLabel.text = slotItem.item_name
		price.text = str(slotItem.sell_value)

func set_slot_data(aLocation, aSlotNumber):
	location = aLocation
	slotNumber = aSlotNumber
	locationLabel.text = aLocation
	slotNumberLabel.text = str(aSlotNumber+1)

func get_slot():
	return merchantSlot

func cancel_selection():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	merchantSlot.cancel_selection()

func is_selected():
	modulate = Color(1.0, 1.0, 0.0, 1.0)
	merchantSlot.is_selected()

func sell():
	var itemFromPlayer = slotItemFromPlayer.get_item()
	if itemFromPlayer:
		itemFromPlayer.erase()
		PlayerInventory.delete_item(location.to_lower(), slotNumber)
		hide()
