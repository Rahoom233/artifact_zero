extends Control
class_name InventorySlot

var item_data: ItemData
var inventory_ui: InventoryUi

@export var allowed_types: Array[String] = []  # e.g., ["ItemDataJewel"]
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $Panel/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	inventory_ui = get_tree().get_first_node_in_group("inventory ui")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear_slot_item() -> void:
	label.text = ""
	texture_rect.texture = null
	item_data = null

func add_slot_item(_data: SlotData) -> void:
	item_data = _data.item_data
	texture_rect.texture = item_data.texture
	
	if _data.quantity > 1:
		label.text = str(_data.quantity)
		label.visible = true
	pass

func is_slot_empty() -> bool:
	if item_data:
		return true
	return false

func can_accept_item(item: ItemData) -> bool:
	if allowed_types.is_empty():
		return true
	return item.get_script().get_global_name() in allowed_types


func _on_mouse_entered() -> void:
	if item_data:
		inventory_ui.update_info_screen(item_data, true)


func _on_mouse_exited() -> void:
		inventory_ui.update_info_screen(item_data, false)


func _on_button_pressed() -> void:
	if item_data:
		inventory_ui.toggle_interact_for_item(item_data)
