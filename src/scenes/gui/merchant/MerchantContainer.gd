extends VBoxContainer
class_name MerchantContainer

export (String) var itemName
export (int) var itemQuantity
onready var slot: MerchantSlot = $ItemContainer/Slot
onready var nameLabel = $ItemContainer/ItemName
onready var itemPrice = $ValueContainer/Price
onready var coin = $ValueContainer/Coin
onready var item

func _ready():
	slot.slotType = Slot.SlotType.MERCHANT
	initialize_item()
	nameLabel.text = itemName

func initialize_item():
	if itemName:
		var item_data = JsonData.item_data[itemName]
		item = ParseItem.string_to_slot_item(item_data["ItemCategory"])
		item.set_item(itemName, itemQuantity)
		slot.add_child(item)
		set_price()
	
func set_price():
	itemPrice.text = str(item.buy_value)

func get_slot():
	return slot

func cancel_selection():
	modulate = Color(1.0, 1.0, 1.0, 1.0)
	if slot:
		slot.cancel_selection()

func is_selected():
	modulate = Color(1.0, 1.0, 0.0, 1.0)
	if slot:
		slot.is_selected()

func clean_up():
	itemPrice.text = ""
	nameLabel.text = ""
	hide()
