extends Node2D
class_name Statue

enum color {red, green, blue, yellow, brown, purple}
enum shape {circle, square}
var my_color
var my_shape
var on_base: bool # it means is sattue is on its base

@onready var sprite_2d: Sprite2D = $Sprite2D


@export var my_base: Statue_Base
@export var my_num: int

signal position_set

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_color = randi() % color.size()
	my_shape = randi() % shape.size()
	set_sprite_texture()
	if my_base is Statue_Base:
		my_base.set_base(my_color, my_shape)

func _set_position(pos: Vector2) -> void:
	global_position = pos
	position_set.emit()

func set_sprite_texture() -> void:
	var shape_x = 0 if my_shape == shape.circle else 16
	var color_y = my_color * 8
	
	if on_base:
		shape_x = 48
	
	sprite_2d.region_enabled = true
	sprite_2d.region_rect = Rect2(shape_x, color_y, 8, 8)

func _on_area_entered(area: Area2D) -> void:
	if on_base:
		return
	
	var base = area.get_parent() as Statue_Base
	if not base:
		return
	
	if base != my_base:
		return
	
	if my_color == base.my_color and my_shape == base.my_shape:
		place_on_base()
	else:
		 # Wrong statue on this base – maybe trigger a visual feedback
		print("Wrong statue!")

func place_on_base():
	on_base = true
	set_sprite_texture()
	# Snap to base's position
	global_position = my_base.global_position
	# Disable further movement (you'll need to handle this in your movement system)
	# Emit signal so the base knows it's occupied
	my_base.on_statue_placed()

func push(direction: Vector2):
	if on_base:
		return
	# Move statue by one tile (size 8)
	for i in 4:
		global_position += direction * 2
		await get_tree().create_timer(0.1).timeout

	#dane nahi hoa
