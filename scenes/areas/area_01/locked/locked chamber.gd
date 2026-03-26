extends Node

var doors: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#--------------setting player starting position--------------------------------------
	var player_position_markers = get_tree().get_nodes_in_group("player_position_marker")
	var previous_dir: String = LevelManager.previous_room_direction
	#setting player position
	player_position_markers.shuffle()
	
	for i in player_position_markers:
		if i.current_position == previous_dir:
			$player.global_position = i.global_position
			$player.update_animaton()
			
	#--------------setting player starting position--------------------------------------
	#====================================================================================
	#-----------------------------------setting doors---------------------------------------
	doors = get_tree().get_nodes_in_group("door")
	print(doors)
	# deleting the door on the wall
	for d in doors:
		var dir_name = d.get_direction()
		if dir_name == LevelManager.previous_room_direction:
			d.delete_self()
			
	
	doors = get_tree().get_nodes_in_group("door")
	var rand_door = doors.pick_random()
	rand_door.delete_self()
	#----------------------------------setting doors---------------------------------------
	
	#fade in and game starting
	await Transition.fade_in()
	get_tree().paused = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
