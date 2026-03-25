@icon("res://node icons/icon_hurtbox.png")

extends Area2D
class_name Hurt_box

@export var min_torches_break: int #the minimum ammount of torches that can break
@export var max_torches_break: int #the maximum ammount of torches that break
@export var damage_type: String

var final_torch_breaking: int

func _on_area_entered(area: Area2D) -> void:
	#final_torch_breaking = randi_range(min_torches_break, max_torches_break)
	
	if area is Hit_box:
		area.take_damage(self, damage_type)
