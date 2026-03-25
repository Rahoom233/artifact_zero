extends Area2D
class_name Level_changer



enum level_changer_direction{
	Up,
	Down,
	Left,
	Right}
#select the opposite direction of self . if on right then target position == left
@export var target_direction: level_changer_direction
@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	var dir: String
	
	match target_direction:
		0:
			dir = "Up"
		1:
			dir = "Down"
		2:
			dir = "Left"
		3:
			dir = "Right"
	
	if dir == LevelManager.previous_room_direction:
		update_wall_texture()
		$Sprite2D.visible = true
		$StaticBody2D.set_collision_layer_value(1,true)
	else:
		$StaticBody2D.set_collision_layer_value(1,false)


func _on_body_entered(body: Node2D) -> void:

	if body is Player:
		var Dir = direction_to_string(target_direction)
		LevelManager.Change_level(Dir)
		PlayerManager.save_player_direction()

func direction_to_string(t_d) -> String:
	match t_d:
		0:
			return "Down"
		1:
			return "Up"
		2:
			return "Right"
		3:
			return "Left"
	
	return "Up"

func update_wall_texture() -> void:
	match target_direction:
		0:
			sprite_2d.texture.region = Rect2(8, 0, 8, 8)
		1:
			sprite_2d.texture.region = Rect2(8, 16, 8, 8)
		2:
			sprite_2d.texture.region = Rect2(0, 8, 8, 8)
		3:
			sprite_2d.texture.region = Rect2(16, 8, 8, 8)
