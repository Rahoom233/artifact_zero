extends Node

enum player_directions {
	Up,
	Down,
	Left,
	Right
}
var saved_player_direction: Vector2
var player: Player

var player_luck_level: int = clampi(0,0,10)

var player_inventory: InventoryData
var player_inventory_showing: bool = false

func _ready() -> void:
	pass

func save_player_direction() -> void:
	var current_player = get_tree().get_first_node_in_group("player")
	player = current_player
	if current_player:
		saved_player_direction = current_player.current_direction
		save_player_inventory()

func update_player_luck(value: int, uder_value: int) -> void:
	#if the value is less that under_value then it will work
	#its good cause we can see if the luck value is already up
	if value <= uder_value: 
		player_luck_level += value

func save_player_inventory() -> void:
	player_inventory = player.inventory

func _unhandled_input(event: InputEvent) -> void:
	if get_node_or_null("/root/1/player/CanvasLayer/inventory ui"):
		#print(get_node_or_null("/root/1/player/CanvasLayer/inventory ui"))
		return
	
	if event.is_action_pressed("inventory"):
		if player.inventory_ui.visible:
			get_tree().paused = false
		else:
			get_tree().paused = true
