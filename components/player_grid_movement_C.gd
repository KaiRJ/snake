class_name PlayerGridMovementC extends Node
## TODO brief intro
##
## TODO detailed description

## The size of the tiles in the grid in pixels
@export var tile_size := 64

## Time to control the speed of the movement
@export var movement_timer: Timer

## Allows access to the parent of the component
@onready var parent: CharacterBody2D = get_parent()

## Dictionary for the directions for player input
const directions = {"ui_up"   : Vector2.UP,
					"ui_down" : Vector2.DOWN,
					"ui_right": Vector2.RIGHT,
					"ui_left" : Vector2.LEFT}

## The current direction
var direction := Vector2.RIGHT


func _ready() -> void:
	movement_timer.timeout.connect(_on_movement_timer_timeout)


func _physics_process(_delta: float) -> void:
	get_input()


## Get and update the direction based on player input
func get_input():
	for input in directions:
		if Input.is_action_pressed(input):
			direction = directions[input]


## Update the players position on timer timeout
func _on_movement_timer_timeout() -> void:
	parent.position += direction * tile_size
