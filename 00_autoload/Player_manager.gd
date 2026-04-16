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

func _ready() -> void:
	var current_player = get_tree().get_first_node_in_group("player")
	player = current_player
	pass



func save_player_direction() -> void:
	var current_player = get_tree().get_first_node_in_group("player")
	player = current_player
	if current_player:
		saved_player_direction = current_player.current_direction

func update_player_luck(value: int, uder_value: int) -> void:
	#if the value is less that under_value then it will work
	#its good cause we can see if the luck value is already up
	if value <= uder_value: 
		player_luck_level += value


func _unhandled_input(event: InputEvent) -> void:
	pass
	#if event.is_action_pressed("inventory"):
		#if player.inventory_visible:
		#	get_tree().paused = true
		#else:
			#get_tree().paused = false
