class_name Door
extends Node2D

enum directions {
	up,
	down,
	left,
	right
}

var player_touching: bool = false

@export var my_direction: directions
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("door")
	set_initial_frame()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if player_touching:
			play_animation()
			PlayerManager.update_player_luck(1, 5)
			#LevelManager.current_keys -= 1
			await animated_sprite.animation_finished
			await get_tree().create_timer(0).timeout
			queue_free()
	pass


func _on_body_entered(_body: Node2D) -> void:
	if _body is Player:
		player_touching = true
		print("player entered ", my_direction)
	pass


func _on_body_exited(_body: Node2D) -> void:
	if _body is Player:
		player_touching = false
		print("player exited ", my_direction)
	pass # Replace with function body.

func play_animation() -> void:
	if my_direction == directions.up:
		animated_sprite.play("up")
	elif my_direction == directions.down:
		animated_sprite.play("down")
	elif my_direction == directions.right:
		animated_sprite.play("right")
	elif my_direction == directions.left:
		animated_sprite.play("left")
	pass

func set_initial_frame() -> void:
	if my_direction == directions.up:
		animated_sprite.play("up")
	elif my_direction == directions.down:
		animated_sprite.play("down")
	elif my_direction == directions.right:
		animated_sprite.play("right")
	elif my_direction == directions.left:
		animated_sprite.play("left")
	
	animated_sprite.stop()
	animated_sprite.frame = 0

func delete_self() -> void:
	print("deleted")
	queue_free()

func get_direction() -> String:
	match my_direction:
		0:
			return "Up"
		1:
			return "Down"
		2:
			return "Left"
		3:
			return "Right"
	return "up"
