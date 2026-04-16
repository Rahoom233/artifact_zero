extends Control
class_name MiniInventoryScreen

enum display_mode {item_info, item_interact}
@export var current_display_mode: display_mode 

@onready var texture_rect: TextureRect = $"item info/TextureRect"

func show_item_info(_data: ItemData) -> void:
	texture_rect.texture = _data.texture
	$"item info/name".text = str("Name: ", _data.name)
	texture_rect.visible = true

func hide_item_info(_data: ItemData) -> void:
	texture_rect.texture = null
	$"item info/name".text = str("")
	texture_rect.visible = false
