class_name SavedSnake
extends Resource

# Variables for the snake manager
@export var position: Vector2
@export var rotation: float
@export var direction: Vector2i
@export var grow: bool

# Array for the snake body parts
@export var body_parts: Array[SavedBody]
