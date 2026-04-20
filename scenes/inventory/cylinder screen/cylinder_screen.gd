extends TextureRect

@export var cylinder_slot: SlotData 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var item: ItemDataCylinder = cylinder_slot.item_data
	$TextureProgressBar.value = item.get_percentage()
