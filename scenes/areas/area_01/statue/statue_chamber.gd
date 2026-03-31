extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_position_markers = get_tree().get_nodes_in_group("player_position_marker")
	var previous_dir: String = LevelManager.previous_room_direction
	#setting player position
	player_position_markers.shuffle()
	
	for i in player_position_markers:
		if i.current_position == previous_dir:
			$player.global_position = i.global_position
			$player.update_animaton()
	
	#fade in and game starting
	await Transition.fade_in()
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
