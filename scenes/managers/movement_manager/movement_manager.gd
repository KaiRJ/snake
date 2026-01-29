class_name MovementManager
extends Node
## Scene to manage the player input
##

@onready var timer: Timer = $MovementTimer

@export var snake_manager: SnakeManager

@export var timer_wait_time: float = 0.5

## Signal to emit which direction the player whats to move
signal move(direction: Vector2i)

## Dictionary for the directions for player input
const DIRECTIONS: Dictionary = {"ui_up"   : Vector2i.UP,
								"ui_down" : Vector2i.DOWN,
								"ui_right": Vector2i.RIGHT,
								"ui_left" : Vector2i.LEFT}
					
## Stores the direction the player whats to more
var direction: Vector2i


func _ready() -> void:
	GameEvents.start_game.connect(_on_start_game_signal)
	move.connect(snake_manager.move_snake)


func _physics_process(_delta: float) -> void:
	get_input()


## Get _new_direction based on player input
func get_input() -> void:
	for input: String in DIRECTIONS:
		if Input.is_action_just_pressed(input):
			direction = DIRECTIONS[input]


func _on_start_game_signal() -> void:
	direction = Vector2i.RIGHT
	timer.start(timer_wait_time)


func _on_movement_timer_timeout() -> void:
	move.emit(direction)
