extends Area2D

@export var item_data: ItemData
var has_space: bool = false
var player_entered: bool = false
var player: Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Sprite2D.texture = item_data.texture

func _on_body_entered(body: Node2D) -> void:
	print("man")
	if body is Player:
		player = body
		player_entered = true


func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_entered = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player_entered:
		has_space = PlayerInventoryManager.has_space_for_item(item_data)
		if has_space:
			queue_free()
