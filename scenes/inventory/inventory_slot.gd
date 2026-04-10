extends Control
class_name InventorySlot

var item_data: ItemData

@export var allowed_types: Array[String] = []  # e.g., ["ItemDataJewel"]
@onready var label: Label = $Label
@onready var texture_rect: TextureRect = $Panel/TextureRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func clear_slot_item() -> void:
	label.text = ""
	texture_rect.texture = null
	item_data = null

func add_slot_item(_data: SlotData) -> void:
	var item = _data.item_data
	texture_rect.texture = item.texture
	
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
