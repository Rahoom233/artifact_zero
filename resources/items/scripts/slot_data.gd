extends Resource
class_name SlotData

const MAX_STACK_SIZE = 99

@export var item_data: ItemData
@export_range(1, MAX_STACK_SIZE) var quantity: int = 1

@export var potion_allowed: bool = false
@export var gas_canisters_allowed: bool = false
@export var jewel_allowed: bool = false
@export var food_allowed: bool = false

func is_content_allowed(data: ItemData) -> bool:
	if data is ItemDataFood and food_allowed:
		return true
	elif data is ItemDataPotion and potion_allowed:
		return true
	return false
