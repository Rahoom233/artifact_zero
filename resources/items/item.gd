extends Resource
class_name Item

@export var id: String = ""
@export var name: String = ""
@export var icon: Texture2D
@export var stackable: bool = false
@export var max_stack: int = 1
@export_enum("general", "key_items", "jewels", "gas_canisters") var category: String = ""
