class_name Snake extends CharacterBody2D
## Scene to hold and manage snake body parts
##
## TODO detailed description

## The snake body scene
@export var snake_body: PackedScene

## The starting size of the snake
@export var init_size: int = 3

## The size of the tiles in the grid in pixels
@export var tile_size := 16

## Dictionary for the directions for player input
const DIRECTIONS = {"ui_up"   : Vector2.UP,
					"ui_down" : Vector2.DOWN,
					"ui_right": Vector2.RIGHT,
					"ui_left" : Vector2.LEFT}

## The current rotation of the snake
var current_rotation := 0.0

## The current direction of the snake
var current_direction := Vector2.RIGHT

## Array to hold and track all the snake body parts
var _snake_body_parts: Array[SnakeBody]


func _ready() -> void:
	# Connect timer signal 
	$MovementTimer.timeout.connect(_on_movement_timer_timeout)
	
	# Set the initial position of the snake (extra is cause sprites are centered)
	global_position = Vector2(16*10, 16*5) + Vector2(8, 8)
	
	# Set the initial rotation of the snake
	rotation = current_rotation

	# Create the initial snake
	for i in range(init_size-1):
		add_snake_body_part()
		move_snake_head()


func _physics_process(_delta: float) -> void:
	get_input()


## Get and update the direction based on player input
func get_input() -> void:
	for input in DIRECTIONS:
		if Input.is_action_just_pressed(input) \
		and (DIRECTIONS[input] + current_direction) != Vector2.ZERO \
		and DIRECTIONS[input] != current_direction:
			current_rotation += determine_rotation(DIRECTIONS[input])
			current_direction = DIRECTIONS[input]


## Determine the rotation of the snake from the new and current direction
func determine_rotation(dir: Vector2) -> float:
	if dir.y == 0: # moving right or left
		return -(dir.x * current_direction.y) * PI/2
	else: # moving up or down
		return (dir.y * current_direction.x) * PI/2


## Add a new snake body part at current head position
func add_snake_body_part() -> void:
	var new_body := snake_body.instantiate() as SnakeBody
	_snake_body_parts.append(new_body)
	new_body.rotation = rotation # Same rotation as the head
	new_body.global_position = global_position # Same position as the head
	$Body.add_child(new_body)
	

## Move the snake head by one square in DIRECTION
func move_snake_head():
	rotation = current_rotation
	global_position += current_direction * tile_size


## Remove the current snake tail and make the new last body part a tail
func remove_tail() -> void:
	var current_tail = _snake_body_parts.pop_front()
	current_tail.queue_free()
	
	var new_tail = _snake_body_parts.front()
	new_tail.make_tail()


## Update the players position on timer timeout
func _on_movement_timer_timeout() -> void:
	add_snake_body_part()
	move_snake_head()
	remove_tail()
