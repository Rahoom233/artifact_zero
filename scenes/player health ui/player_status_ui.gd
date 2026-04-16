extends Control

@onready var health_bar: TextureProgressBar = $"Panel/health bar"
@onready var gas_bar: TextureProgressBar = $"Panel/gas bar"

var health: int 
var gas: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_gas_bar() -> void:
	pass
