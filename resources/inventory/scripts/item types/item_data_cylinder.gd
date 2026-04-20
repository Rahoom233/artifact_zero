extends ItemData
class_name ItemDataCylinder


@export var max_capacity: int
@export var remaining_capacity: int
@export_enum("common", "uncommon", "rare") var rarity: String

func consume(amount: int) -> int:
	remaining_capacity = max(0, remaining_capacity - amount)
	return remaining_capacity

func refill(amount: int = -1) -> int:
	if amount == -1:
		remaining_capacity = max_capacity
	else:
		remaining_capacity = min(max_capacity, remaining_capacity + amount)
	return remaining_capacity

func is_empty() -> bool:
	return remaining_capacity <= 0

func get_percentage() -> float:
	return float(remaining_capacity) / float(max_capacity) * 100
