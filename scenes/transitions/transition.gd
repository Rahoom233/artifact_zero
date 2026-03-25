extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func fade_in() -> bool:
	if animation_player:
		animation_player.play("fade_in")
		await animation_player.animation_finished
	return true

func fade_out() -> bool:
	if animation_player:
		animation_player.play("fade_out")
		await animation_player.animation_finished
	return true
