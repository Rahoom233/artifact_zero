extends Control
class_name InventoryUi

@export var test_inv: InventoryData

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var jewel_slots: Array
var special_slots: Array
var cylinder_slot: InventorySlot
var normal_slots: Array


func _ready() -> void:
	
	animation_player.play("RESET")
	visible = false
	
	jewel_slots = $"jewel slots".get_children()
	special_slots = $"special item slots".get_children()
	normal_slots = $"normal slots".get_children()
	cylender_slot = $"cylinder slot/cylinder slot"
	
	

func show_ui() -> void:
	visible = true
	animation_player.play("show")

func hide_ui() -> void:
	animation_player.play("hide")
	await animation_player.animation_finished
	visible = false

# inventory_ui.gd
func update_jewel_slot_datas(slot_datas: Array[SlotData]) -> void:
	for i in range(slot_datas.size()):
		if i < jewel_slots.size():
			var slot = jewel_slots[i]
			if slot_datas[i]:
				slot.add_slot_item(slot_datas[i])
			else:
				slot.clear_slot_item()

func update_special_slot_datas(slot_datas: Array[SlotData]) -> void:
	for i in range(slot_datas.size()):
		if i < special_slots.size():
			var slot = special_slots[i]
			if slot_datas[i]:
				slot.add_slot_item(slot_datas[i])
			else:
				slot.clear_slot_item()

func update_normal_slot_datas(slot_datas: Array[SlotData]) -> void:
	for i in range(slot_datas.size()):
		if i < normal_slots.size():
			var slot = normal_slots[i]
			if slot_datas[i]:
				slot.add_slot_item(slot_datas[i])
			else:
				slot.clear_slot_item()

func update_cylinder_slot_datas(slot_datas: Array[SlotData]) -> void:
	
