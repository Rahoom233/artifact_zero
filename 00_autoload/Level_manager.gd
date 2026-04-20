extends Node
# LevelManager.gd - Handles dynamic room loading without preloading

# Room type names (must match the enum order in Level.gd)
var type_names = [
	"empty",
	"locked",
	"statue",
	"resource",
	"mirror"
	# Add more as you create them
]

# Maximum variations per room type per area
# Format: area_number -> { type_index: max_variation_count }
var max_variations = {
	1: {
		0: 4,  # empty
		1: 4,  # locked
		2: 1,  # statue
		#3: 4,  # hollow
		#4: 2,  # fountain
	},
	# Add more areas as you design them
}

# Per‑area weights: area_number -> { type_index: weight }
var area_chamber_weights = {
	1: {0: 30, 1: 30, 2: 40, 3: 0, 4: 0},
	# Add more areas later
}

# Current progress tracking
var current_area: int = 1
var rooms_visited_in_area: int = 0
var previous_room_direction: String = "Right"
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()

func start_new_run():
	current_area = 1
	rooms_visited_in_area = 0
	load_first_room()

func load_first_room():
	load_room_by_type(0)  # empty chamber

func Change_level(move_direction: String):
	get_tree().paused = true
	await Transition.fade_out()
	
	update_room_on_player_luck()
	
	var next_type = get_random_chamber_type()
	PlayerManager.saved_player_direction = direction_string_to_vector(move_direction)
	load_room_by_type(next_type)
	previous_room_direction = move_direction
	rooms_visited_in_area += 1

func load_room_by_type(type_index: int):
	var area_data = max_variations.get(current_area)
	if area_data == null:
		print("Error: No variation data for area ", current_area)
		return
	var max_var = area_data.get(type_index)
	if max_var == null or max_var == 0:
		print("Error: No variations for type ", type_names[type_index], " in area ", current_area)
		return
	var variation = rng.randi_range(1, max_var)
	var type_name = type_names[type_index]
	var path = "res://scenes/areas/area_%02d/%s/%02d.tscn" % [current_area, type_name, variation]
	var scene = ResourceLoader.load(path)
	if scene == null:
		print("Error: Could not load scene at path: ", path)
		return
	#changing scene
	
	get_tree().call_deferred("change_scene_to_packed", scene)
	print("room loaded: ", type_name)


func get_random_chamber_type() -> int:
	var weights = area_chamber_weights.get(current_area)
	if weights == null:
		print("Error: No weights for area ", current_area)
		return 0
	var total_weight = 0
	for w in weights.values():
		total_weight += w
	var rand_val = rng.randi_range(1, total_weight)
	var cumulative = 0
	for type in weights:
		cumulative += weights[type]
		if rand_val <= cumulative:
			return type
	return 0

func direction_string_to_vector(dir: String) -> Vector2:
	match dir:
		"right": return Vector2.RIGHT
		"left": return Vector2.LEFT
		"up": return Vector2.UP
		"down": return Vector2.DOWN
		_: return Vector2.DOWN

func advance_to_next_area():
	current_area += 1
	rooms_visited_in_area = 0
	print("Advancing to area ", current_area)

func update_room_on_player_luck() -> void:
	if PlayerManager.player_luck_level >= 0:
		area_chamber_weights = {
			1: {0: 40, 1: 40, 2: 20, 3: 0, 4: 0},
		}
	elif PlayerManager.player_luck_level >= 2:
		area_chamber_weights = {
			1: {0: 30, 1: 30, 2: 40, 3: 0, 4: 0},
		}
