extends CharacterBody2D
class_name Player

signal reached_new_tile

# Movement variables
@export var move_speed: float = 40.0
var is_moving: bool = false
var current_direction: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var tile_size: int = 8
var is_invincible: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	current_direction = PlayerManager.saved_player_direction
	update_animaton()
	target_position = position

func _process(_delta: float) -> void:
	
	var _object = ray_cast.get_collider()


func _physics_process(delta):
	handle_input()
	update_animaton()
	move_player(delta)

func handle_input():
	if is_moving:
		return
	
	if Input.is_action_pressed("Move right"):
		current_direction = Vector2.RIGHT
		if can_move(current_direction):
			target_position = position + Vector2(tile_size, 0)
			is_moving = true
	elif Input.is_action_pressed("Move left"):
		current_direction = Vector2.LEFT
		if can_move(current_direction):
			target_position = position + Vector2(-tile_size, 0)
			is_moving = true
	elif Input.is_action_pressed("Move down"):
		current_direction = Vector2.DOWN
		if can_move(current_direction):
			target_position = position + Vector2(0, tile_size)
			is_moving = true
	elif Input.is_action_pressed("Move up"):
		current_direction = Vector2.UP
		if can_move(current_direction):
			target_position = position + Vector2(0, -tile_size)
			is_moving = true

func move_player(delta):
	if is_moving:
		position = position.move_toward(target_position, move_speed * delta)
		if position.distance_to(target_position) < 0.1:
			position = target_position
			is_moving = false
			position_reached()

func position_reached():
	reached_new_tile.emit()
	print("position reached")

func update_animaton() -> void:
	var state: String = "idle_" if not is_moving else "move_"
	
	match current_direction:
		Vector2.UP:
			animated_sprite_2d.play(state + "up")
		Vector2.DOWN:
			animated_sprite_2d.play(state + "down")
		Vector2.RIGHT:
			animated_sprite_2d.scale.x = 1
			animated_sprite_2d.play(state + "side")
		Vector2.LEFT:
			animated_sprite_2d.scale.x = -1
			animated_sprite_2d.play(state + "side")

func can_move(direction: Vector2) -> bool:
	ray_cast.target_position = direction * tile_size
	ray_cast.force_raycast_update()
	return not ray_cast.is_colliding()
