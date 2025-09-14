class_name Snake extends CharacterBody2D

@export var tile_size := 64

const directions = {"ui_up"   : Vector2.UP,
					"ui_down" : Vector2.DOWN,
					"ui_right": Vector2.RIGHT,
					"ui_left" : Vector2.LEFT}

var direction := Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	get_input()


func get_input():
	for input in directions:
		if Input.is_action_pressed(input):
			direction = directions[input]


func _on_move_timer_timeout() -> void:
	position += direction * tile_size
