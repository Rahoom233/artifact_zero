extends Node
class_name HealthOxygenManager

signal health_changed(new_health, max_health)
signal oxygen_changed(remaining, max_capacity)
signal died()
signal cylinder_depleted()   # emitted when cylinder runs out

@export var max_health: int = 5
@export var oxygen_drain_per_step: int = 1

var current_health: int
var active_cylinder: ItemDataCylinder   # reference to the equipped cylinder (set by player)

var is_alive: bool = true

func _ready():
	current_health = max_health

# Called by player after equipping a cylinder
func set_active_cylinder(cylinder: ItemDataCylinder) -> void:
	active_cylinder = cylinder
	if active_cylinder:
		oxygen_changed.emit(active_cylinder.remaining_capacity, active_cylinder.max_capacity)

# Called by player when moving (one step)
func consume_oxygen() -> void:
	if not is_alive or not active_cylinder:
		return
	
	var new_remaining = active_cylinder.consume(oxygen_drain_per_step)
	oxygen_changed.emit(new_remaining, active_cylinder.max_capacity)
	
	if new_remaining <= 0:
		cylinder_depleted.emit()
		# Optionally: take damage immediately or after delay
		take_damage(1)

func take_damage(amount: int) -> void:
	if not is_alive:
		return
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	if current_health <= 0:
		die()

func heal(amount: int) -> void:
	if not is_alive:
		return
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)

func die() -> void:
	is_alive = false
	died.emit()
	# game over logic
