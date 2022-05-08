extends Node2D

onready var merchant_slots = get_node("BuyMenu/ScrollContainer/VBoxContainer")
onready var gui = get_node("/root/Level/Player/GUI")
onready var itemValue = $TextureRect/ItemValue
onready var player = get_node("/root/Level/Player")
onready var item_info = get_node("ItemInfo/Background")
onready var description = get_node("ItemInfo/Background/Description")
onready var mainMenu = get_node("MainMenu")
onready var buyMenu = get_node("BuyMenu")
onready var sellMenu = get_node("SellMenu")
var slots: Array
var selected_item
var selected_container: MerchantContainer

func _ready():
	slots = get_slots()
	for i in range(slots.size()):
		#slots[i].connect("gui_input", self, "slot_gui_input", [slots[i]])
		slots[i].slot_index = i
	for h in merchant_slots.get_children():
		h.connect("gui_input", self, "slot_gui_input", [h])
		h.connect("mouse_entered", self, "on_slot_mouse_entered", [h])
		h.connect("mouse_exited", self, "on_slot_mouse_exited", [h])
	initialize_merchant_items()

func _on_Exit_pressed():
	hide()

func can_sell(item):
	if item:
		return !item_is_from_merchant(item)

func can_buy(item):
	if item:
		if item_is_from_merchant(item):
			return player.can_buy(item)

func slot_gui_input(event: InputEvent, merchantContainer: MerchantContainer):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed:
			select_slot(merchantContainer)

func get_item_from(slot):
	var items: Array = slot.get_children()
	if !items.empty():
		return items[0]

func left_click_not_holding(slot):
	selected_item = get_item_from(slot)

func able_to_put_into_slot(slot):
	return !find_parent("GUI").holding_item

func item_is_from_merchant(item):
	return get_items().has(item)

func get_items() -> Array:
	var res = []
	for s in slots:
		if slot_have_an_item(s):
			res.append(s.get_children()[0])
	return res

func slot_have_an_item(slot):
	return slot.get_child_count() > 0

func initialize_merchant_items():
	for i in get_items():
		i.set_item(i.item_name, i.item_quantity)

func select_slot(merchantContainer: MerchantContainer):
	var slot = merchantContainer.get_slot()
	cancel_previous_selection()
	slot.is_selected()
	selected_container = merchantContainer
	selected_item = get_item_from(slot)
	recolor_container(Color(1.0, 1.0, 0, 1.0))

func cancel_previous_selection():
	if selected_container:
		selected_container.cancel_selection()
		selected_container = null
		selected_item = null

func on_slot_mouse_entered(merchantContainer):
	var slot: MerchantSlot = merchantContainer.get_slot()
	var item = slot.get_item()
	if  !item_info.visible && item:
		item_info.show()
		update_description(slot)
	item_info.rect_position = merchantContainer.get_global_position() + Vector2(180.0, 0.0)

func on_slot_mouse_exited(h):
	var mouse_is_inside = h.get_global_rect().has_point(h.get_global_mouse_position())
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

func get_slots():
	var res = []
	for merchantContainer in merchant_slots.get_children():
		res.append(merchantContainer.get_slot())
	return res

func recolor_container(color):
	selected_container.modulate = color

func _on_ConfirmBuy_pressed():
	if can_buy(selected_item):
		player.discount_gold(selected_item.buy_value)
		gui.free_holding_item()
		player.adquire_item(selected_item)
		selected_item.erase()
		selected_container.clean_up()

func _on_ConfirmSell_pressed():
	var item = gui.holding_item
	if can_sell(item):
		player.obtain_gold(item.sell_value * item.item_quantity)
		gui.free_holding_item()
		item.erase()

func _on_MainBuy_pressed():
	mainMenu.hide()
	buyMenu.show()

func _on_MainSell_pressed():
	mainMenu.hide()
	sellMenu.show()

func _on_MainExit_pressed():
	hide()

func _on_BackBuy_pressed():
	mainMenu.show()
	buyMenu.hide()

func _on_BackSell_pressed():
	mainMenu.show()
	sellMenu.hide()
