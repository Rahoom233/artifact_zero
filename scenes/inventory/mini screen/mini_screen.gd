extends Control
class_name MiniInventoryScreen

@onready var info_panel: Control = $InfoPanel
@onready var interact_panel: Control = $InteractPanel
@onready var texture_rect: TextureRect = $InfoPanel/TextureRect
@onready var name_label: Label = $InfoPanel/name
@onready var gas_remaining_label: Label = $"InfoPanel/gas remaining"

@onready var use_button: Button = $"InteractPanel/Use button"
@onready var equip_button: Button = $"InteractPanel/equip button"
@onready var drop_button: Button = $"InteractPanel/toss button"

var current_item: ItemData = null

func _ready():
	info_panel.visible = false
	interact_panel.visible = false


func hide_all():
	info_panel.visible = false
	interact_panel.visible = false

func show_item_info(item: ItemData):
	current_item = item
	info_panel.visible = true
	interact_panel.visible = false
	# Update info content
	texture_rect.texture = item.texture
	name_label.text = "Name: " + item.name
	var item_class = item.get_script().get_global_name()
	if item_class == "ItemDataCylinder":
		gas_remaining_label.text = "Remaining gas: " + str(item.remaining_capacity)
		gas_remaining_label.visible = true
	else:
		gas_remaining_label.visible = false

func show_interact_panel(item: ItemData):
	current_item = item
	info_panel.visible = false
	interact_panel.visible = true
	update_button_labels(item)

func hide_interact_panel():
	interact_panel.visible = false
	info_panel.visible = false
	current_item = null

func hide_item_info(item: ItemData):
	if current_item == item and not interact_panel.visible:
		hide_all()

func update_button_labels(item: ItemData):
	var item_class = item.get_script().get_global_name()
	use_button.visible = false
	equip_button.visible = false
	match item_class:
		"ItemDataCylinder":
			use_button.text = "Refill"
			equip_button.text = "Equip"
			use_button.visible = true
			equip_button.visible = true
		"ItemDataPotion":
			use_button.text = "Drink"
			use_button.visible = true
		"ItemDataJewel":
			equip_button.text = "Equip"
			equip_button.visible = true
		_:
			use_button.text = "Use"
			use_button.visible = true
	drop_button.text = "Drop"

func _on_use_pressed():
	print("Use: ", current_item.name)
	# After action, you may want to close the panel
	get_parent().on_item_action_completed()  # call up to inventory_ui

func _on_equip_pressed():
	print("Equip: ", current_item.name)
	get_parent().on_item_action_completed()

func _on_drop_pressed():
	print("Drop: ", current_item.name)
	get_parent().on_item_action_completed()
