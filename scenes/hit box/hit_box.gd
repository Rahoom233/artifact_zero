@icon("res://node icons/icon_hitbox.png")

extends Area2D
class_name Hit_box

signal Take_damage(Hurt_box: Hurt_box,_damage_type: String)

# Called when the node enters the scene tree for the first time.
func take_damage(hurt_box: Hurt_box,_damage_type: String) -> void:
	Take_damage.emit(hurt_box,_damage_type)
