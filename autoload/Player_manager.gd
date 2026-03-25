extends Node

enum player_directions {
	Up,
	Down,
	Left,
	Right
}
var saved_player_direction: Vector2
var player: Player

const PLAYER = preload("res://scenes/player/player.tscn")

func _ready() -> void:
	pass

func save_player_direction() -> void:
	var current_player = get_tree().get_first_node_in_group("player")
	if current_player:
		saved_player_direction = current_player.current_direction
