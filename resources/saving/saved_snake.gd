class_name SavedSnake
extends Resource

# Variables for the snake manager
@export var position: Vector2
@export var move_tail: bool
@export var rotation: float
@export var direction: Vector2i

# Array for the snake body parts
@export var body_parts: Array[SavedBody]
