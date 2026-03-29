extends Node2D

enum color {red, green, blue, yellow, brown, purple}
enum shape {circle, square}
var my_color
var my_shape

@onready var sprite: Sprite2D = $Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_color = randi() % color.size()
	my_shape = randi() % shape.size()
	set_sprite_texture()
	

func _set_position() -> bool:
	return true

func set_sprite_texture() -> void:
	var _shape_pos: int
	
	match my_shape:
		0:
			_shape_pos = 0
		1:
			_shape_pos = 16
	
	sprite.texture.region = Rect2(_shape_pos, int(my_color * 8), 8, 8)
