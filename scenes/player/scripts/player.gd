extends CharacterBody2D
class_name Player

signal reached_new_tile

# Movement variables
@export var move_speed: float
var is_moving: bool = false
var current_direction: Vector2 = Vector2.ZERO
var target_position: Vector2 = Vector2.ZERO
var tile_size: int = 8
#player movement variables
var is_invincible: bool = false
var is_pushing: bool = false
#player inventory variables
@export var jewel_inventory: InventoryData
@export var special_inventory: InventoryData
@export var normal_inventory: InventoryData
@export var gas_canister_slot: SlotData
var inventory_visible: bool = false

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var inventory_ui: InventoryUi = $"CanvasLayer/inventory ui"
@onready var status_ui: Control = $"CanvasLayer/player status ui"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("player")
	current_direction = PlayerManager.saved_player_direction
	update_animaton()
	target_position = position
	inventory_ui.hide_ui()
	
	inventory_ui.update_jewel_slot_datas(jewel_inventory.slot_datas)
	inventory_ui.update_special_slot_datas(special_inventory.slot_datas)
	inventory_ui.update_normal_slot_datas(normal_inventory.slot_datas)

func _process(_delta: float) -> void:
	pass

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
			is_pushing = false
			
			position_reached()

func position_reached():
	reached_new_tile.emit()
	print("position reached")

func update_animaton() -> void:
	var state: String = "idle_" if !is_moving else "move_"
	if is_pushing:
		state = "push_"
		move_speed = 2 / move_speed
	
	
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
	
	if not ray_cast.is_colliding():
		# Empty tile – move player
		target_position = position + direction * tile_size
		is_moving = true
		return true
	
	var collider = ray_cast.get_collider()
	
	if collider is Level_changer:
		is_moving = true
		return true
	
		#region raycast checking statue
	if collider is Area2D:
		# It's a statue – see if we can push it
		var statue = collider.get_parent()
		if statue is Statue:
			if statue.on_base == true:
				return false
		# Move raycast to statue's position to check beyond
			ray_cast.global_position = statue.global_position
			ray_cast.target_position = direction * tile_size
			ray_cast.force_raycast_update()
		
			if not ray_cast.is_colliding():
				# Tile behind statue is free – push it
				is_pushing = true
				statue.push(direction)
				target_position = position + direction * tile_size
				is_moving = true
				ray_cast.global_position = global_position
				return true
			else:
				var next_collider = ray_cast.get_collider()
				var next_node = next_collider.get_parent()
				if next_node is Statue_Base:
					is_pushing = true
					statue.push(direction)
					target_position = position + direction * tile_size
					is_moving = true
					ray_cast.global_position = global_position
					return true
	
	ray_cast.global_position = global_position
	return false
	
	#endregion

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		if inventory_visible:
			inventory_ui.hide_ui()
			inventory_visible = false
			status_ui.visible = true
		else:
			inventory_ui.show_ui()
			inventory_visible = true
			status_ui.visible = false
