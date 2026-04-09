extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	animation_player.play("RESET")
	visible = false

func show_ui() -> void:
	print("s ui")
	visible = true
	animation_player.play("show")

func hide_ui() -> void:
	print("h ui")
	animation_player.play("hide")
	await animation_player.animation_finished
	visible = false
