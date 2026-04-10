extends Node

var player: Player
var inventory_ui: InventoryUi
var jewel_inventory: InventoryData
var special_inventory: InventoryData
var normal_inventory: InventoryData
var gas_canister_slot: SlotData

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")
	inventory_ui = player.inventory_ui
	jewel_inventory = player.jewel_inventory
	special_inventory = player.special_inventory
	normal_inventory = player.normal_inventory
	gas_canister_slot = player.gas_canister_slot


func add_item(_data: ItemData, _index: int, _quantity: int = 1) -> bool:
	var item_class = _data.get_script().get_global_name()
	inventory_ui = player.inventory_ui
	
	if item_class == "ItemDataJewel":
		var slot = jewel_inventory.slot_datas[_index]
		if slot == null:
			jewel_inventory.slot_datas[_index] = SlotData.new()
			var new_slot: SlotData = jewel_inventory.slot_datas[_index]
			new_slot.item_data = _data
			inventory_ui.update_jewel_slot_datas(jewel_inventory.slot_datas)
			return true
		elif slot.item_data != null and slot.item_data.id == _data.id:
			slot.item_data = _data
			inventory_ui.update_jewel_slot_datas(jewel_inventory.slot_datas)
			return true
	
	if item_class == "ItemDataPotion":
		var slot = special_inventory.slot_datas[_index]
		if slot == null:
			special_inventory.slot_datas[_index] = SlotData.new()
			var new_slot: SlotData = special_inventory.slot_datas[_index]
			new_slot.item_data = _data
			inventory_ui.update_special_slot_datas(special_inventory.slot_datas)
			return true
		elif slot.item_data != null and slot.item_data.id == _data.id:
			slot.item_data = _data
			inventory_ui.update_special_slot_datas(special_inventory.slot_datas)
			return true
	
	if item_class == "ItemDataFood":
		var slot = normal_inventory.slot_datas[_index]
		if slot == null:
			normal_inventory.slot_datas[_index] = SlotData.new()
			var new_slot: SlotData = normal_inventory.slot_datas[_index]
			new_slot.item_data = _data
			inventory_ui.update_normal_slot_datas(normal_inventory.slot_datas)
			return true
		elif slot.item_data != null and slot.item_data.id == _data.id:
			slot.item_data = _data
			inventory_ui.update_normal_slot_datas(normal_inventory.slot_datas)
			return true
	
	return false


func remove_item(_data: ItemData) -> void:
	pass

func has_space_for_item(_data: ItemData)-> bool:
	var item_class = _data.get_script().get_global_name()
	print(item_class)
	inventory_ui = player.inventory_ui
	
	if item_class == "ItemDataJewel":
		for i in range(jewel_inventory.slot_datas.size()):
			var slot: SlotData = jewel_inventory.slot_datas[i]
			if slot != null and slot.item_data.id == _data.id and slot.quantity < _data.max_stack:
				slot.quantity += 1
				add_item(_data,i)
				return true
		for i in range(jewel_inventory.slot_datas.size()):
			var slot: SlotData = jewel_inventory.slot_datas[i]
			if slot == null:
				add_item(_data, i)
				return true
	
	elif item_class == "ItemDataPotion":
		for i in range(special_inventory.slot_datas.size()):
			var slot: SlotData = special_inventory.slot_datas[i]
			if slot != null and slot.item_data.id == _data.id and slot.quantity < _data.max_stack:
				print(_data.name)
				slot.quantity += 1
				add_item(_data,i)
				return true
		for i in range(special_inventory.slot_datas.size()):
			var slot: SlotData = special_inventory.slot_datas[i]
			if slot == null:
				add_item(_data, i)
				return true
	
	
	elif item_class == "ItemDataFood":
		print(_data.id)
		for i in range(normal_inventory.slot_datas.size()):
			var slot: SlotData = normal_inventory.slot_datas[i]
			if slot != null and slot.item_data.id == _data.id and slot.quantity < _data.max_stack:
				slot.quantity += 1
				add_item(_data, i)
				return true
		for i in range(normal_inventory.slot_datas.size()):
			var slot: SlotData = normal_inventory.slot_datas[i]
			if slot == null or slot.quantity == _data.max_stack:
				add_item(_data, i)
				return true
	
	return false
