class_name SavedSnake
extends Resource

# Variables for the snake manager
@export var position: Vector2
@export var move_tail: bool
@export var current_rotation: float
@export var current_direction: Vector2i
@export var new_direction: Vector2i

# Array for the snake body parts
@export var body_parts: Array[SavedBody]
