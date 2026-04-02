extends Node2D
class_name Statue_Base

enum colors {red, green, blue, yellow, brown, purple}
enum shapes {circle, square}
var my_color
var my_shape
var occupied: bool = false

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area: Area2D = $Area2D
@onready var ray_cast: RayCast2D = $RayCast2D

signal position_set

func set_base(_color: int, _shape: int):
	my_color = _color
	my_shape = _shape
	set_sprite()

func set_sprite():
	var shape_x = 8 if my_shape == shapes.circle else 24
	var color_y = my_color * 8
	
	$Sprite2D.region_enabled = true
	$Sprite2D.region_rect = Rect2(shape_x, color_y, 8, 8)

func on_statue_placed():
	occupied = true
	# Optionally change sprite to show completion
	# e.g., add a glow or a different tile
	# For now, just disable further detection (optional)
	area.monitoring = false

func _set_position(pos: Vector2) -> void:
	global_position = pos
	pass
