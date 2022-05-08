extends TabContainer

onready var inventoryTexture = load("res://assets/interface/GUI/BagIcon.png")
onready var gearTexture = load("res://assets/interface/GUI/GearIcon.png")
onready var hotbarTexture = load("res://assets/interface/GUI/BagIcon.png")
onready var item_info = get_node("ItemInfo/Background")
onready var description = get_node("ItemInfo/Background/Description")
onready var equipment: Tabs = $E
onready var inventoryContainer = get_node("Inventory/ScrollContainer/VBoxContainer")
onready var equipsContainer = get_node("E/ScrollContainer/VBoxContainer")
onready var hotbarContainer = get_node("B/HotbarLabel/ScrollContainer/VBoxContainer")
onready var player = get_node("/root/Level/Player")
onready var gui = get_node("/root/Level/Player/GUI")
const SELL_CONTAINER = preload("res://scenes/gui/merchant/sellContainer/SellContainer.tscn")

var selected_item
var selected_container: SellContainer

func _ready():
	adjust_tabs()
	initialize_inventory()
	initialize_equips()
	initialize_hotbar()

func adjust_tabs():
	set_tab_icon(0, inventoryTexture)
	set_tab_title(0, "")
	set_tab_icon(1, gearTexture)
	set_tab_title(1, "")
	set_tab_icon(2, hotbarTexture)
	set_tab_title(2, "")
	current_tab = 1
	current_tab = 0

func initialize_inventory():
	for i in range(PlayerInventory.NUM_INVENTORY_SLOTS):
		var sellContainerInstance = SELL_CONTAINER.instance()
		sellContainerInstance._ready()
		connect_signals(sellContainerInstance)
		sellContainerInstance.set_slot_data("Inventory", i)
		inventoryContainer.add_child(sellContainerInstance)
		sellContainerInstance.obtain_slot_info()

func initialize_equips():
	for i in range(PlayerInventory.NUM_EQUIPS_SLOTS):
		var sellContainerInstance = SELL_CONTAINER.instance()
		sellContainerInstance._ready()
		connect_signals(sellContainerInstance)
		sellContainerInstance.set_slot_data("Equips", i)
		equipsContainer.add_child(sellContainerInstance)
		sellContainerInstance.obtain_slot_info()

func initialize_hotbar():
	for i in range(PlayerInventory.NUM_EQUIPS_SLOTS):
		var sellContainerInstance = SELL_CONTAINER.instance()
		sellContainerInstance._ready()
		connect_signals(sellContainerInstance)
		sellContainerInstance.set_slot_data("Hotbar", i)
		hotbarContainer.add_child(sellContainerInstance)
		sellContainerInstance.obtain_slot_info()

func connect_signals(aSellContainer):
	aSellContainer.connect("gui_input", self, "slot_gui_input", [aSellContainer])
	aSellContainer.connect("mouse_entered", self, "on_slot_mouse_entered", [aSellContainer])
	aSellContainer.connect("mouse_exited", self, "on_slot_mouse_exited", [aSellContainer])

func slot_gui_input(event: InputEvent, sellContainer):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			select_slot(sellContainer)

func select_slot(sellContainer):
	var slot = sellContainer.get_slot()
	cancel_previous_selection()
	slot.is_selected()
	selected_container = sellContainer
	selected_item = get_item_from(slot)
	recolor_container(Color(1.0, 1.0, 0, 1.0))

func cancel_previous_selection():
	if selected_container:
		selected_container.cancel_selection()
		selected_container = null
		selected_item = null

func get_item_from(slot):
	var items: Array = slot.get_children()
	if !items.empty():
		return items[0]

func recolor_container(color):
	selected_container.modulate = color

func on_slot_mouse_entered(sellContainer):
	var slot: MerchantSlot = sellContainer.get_slot()
	var item = slot.get_item()
	if  !item_info.visible && item:
		item_info.show()
		update_description(slot)
	item_info.rect_position = sellContainer.get_global_position() + Vector2(250.0, 0.0)

func on_slot_mouse_exited(sellContainer):
	var mouse_is_inside = sellContainer.get_global_rect().has_point(sellContainer.get_global_mouse_position())
	if item_info.visible && !mouse_is_inside:
		item_info.hide()

func update_description(slot):
	var item = slot.get_item()
	if item:
		description.text = item.item_name + "\n-------------------\n"
		description.text += "Tipo: " + item.toString() + "\n"
		description.text += "Calidad: " + item.rarity + "\n"
		description.text += "Valor: " + str(item.buy_value) + "\n"
		description.text += item.extra_description()

func _on_ConfirmSell_pressed():
	if can_sell(selected_item):
		player.obtain_gold(selected_item.sell_value * selected_item.item_quantity)
		gui.free_holding_item()
		selected_item.erase()
		selected_container.sell()

func can_sell(item):
	return item != null
