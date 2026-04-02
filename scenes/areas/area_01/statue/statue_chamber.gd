extends Node2D



@onready var tile_map_layer: TileMapLayer = $TileMapLayer

var occupied_cells: Dictionary = {} 
var empty_cells: Array

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
	
	#setting position of staties and basses
	var used_cell: Array = $TileMapLayer.get_used_cells()
	
	for cell in used_cell:
		var data = tile_map_layer.get_cell_tile_data(cell)
		var custom_data = data.get_custom_data("empty floor")
		if custom_data == true:
			empty_cells.append(cell)
	
	var stones: Array = $boulders.get_children()
	
	for s in stones:
		var random_cell = empty_cells.pick_random()
		var local_pos = tile_map_layer.map_to_local(random_cell)
		s.global_position = local_pos
		empty_cells.erase(random_cell)
	
	#region seting statues position
	var statues_and_bases: Array = $statue.get_children()
	statues_and_bases +=  $"statue base".get_children()
	
	
	for i in statues_and_bases:
		var cell_found = false
		var attempts = 0
		while not cell_found and attempts < 100:
			var random_cell = empty_cells.pick_random()
			if has_clear_sides(random_cell):
				# Reserve this cell and mark it as occupied
				occupied_cells[random_cell] = true
				# Also mark the four adjacent cells as occupied? No, we only need to prevent others from using them as center.
				# But we should also remove them from empty_cells to avoid them being chosen as center later.
				empty_cells.erase(random_cell)
				# Also remove adjacent cells from empty_cells? Optional but helps.
				var dirs = [Vector2i(0,1), Vector2i(0,-1), Vector2i(1,0), Vector2i(-1,0)]
				for dir in dirs:
					var adj = random_cell + dir
					empty_cells.erase(adj)
				# Convert cell to global position and place
				var local_pos = tile_map_layer.map_to_local(random_cell)
				var global_pos = tile_map_layer.to_global(local_pos)
				i._set_position(global_pos)
				cell_found = true
			attempts += 1
		if not cell_found:
			print("Could not place ", i.name)
	
	#endregion
	
	#fade in and game starting
	await Transition.fade_in()
	get_tree().paused = false


func is_cell_free(cell: Vector2i) -> bool:
	return empty_cells.has(cell) and not occupied_cells.has(cell)

# Helper to check four sides
func has_clear_sides(cell: Vector2i) -> bool:
	var dirs = [Vector2i(0,1), Vector2i(0,-1), Vector2i(1,0), Vector2i(-1,0)]
	for dir in dirs:
		var neighbor = cell + dir
		if not is_cell_free(neighbor):
			return false
	return true
