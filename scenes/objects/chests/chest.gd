extends Node2D

@export var loot_table: LootTable
@export var min_items: int = 1
@export var max_items: int = 3

var generated_items: Array[ItemData] = []
var opened: bool = false
var touching_player: bool = false

func _ready():
	generate_items()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and touching_player:
		print(get_loot())

func generate_items():
	generated_items.clear()
	var attempts = randi_range(min_items, max_items)
	
	for i in range(attempts):
		var chosen = pick_weighted_item()
		if chosen:
			generated_items.append(chosen)

func pick_weighted_item() -> ItemData:
	# Calculate total weight from all slots
	var total_weight = 0
	for slot in loot_table.table:
		total_weight += slot.spawning_chance   # using this as weight
	
	if total_weight <= 0:
		return null
	
	# Pick a random value between 0 and total_weight
	var roll = randf_range(0, total_weight)
	var running = 0
	for slot in loot_table.table:
		running += slot.spawning_chance
		if roll <= running:
			return slot.item
	
	return null  # fallback

# Call this when chest is opened (e.g., on interaction)
func get_loot() -> Array[ItemData]:
	return generated_items

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		touching_player = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is Player:
		touching_player = false
