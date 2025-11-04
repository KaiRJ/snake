class_name Snake extends Node2D
## Scene to hold and manage snake body parts.
##
## TODO detailed description

## The snake body scene
@export var snake_body: PackedScene

## The starting position of the snake
@export var init_pos := Vector2(10,5)

## The starting size of the snake
@export var init_size := 3

## The size of the tiles in the grid in pixels
## TODO get this automatically
@export var tile_size := 16

## Dictionary for the directions for player input
const DIRECTIONS = {"ui_up"   : Vector2.UP,
					"ui_down" : Vector2.DOWN,
					"ui_right": Vector2.RIGHT,
					"ui_left" : Vector2.LEFT}

## The current rotation of the snake in radians
var current_rotation := 0.0

## The current direction of the snake
var current_direction := Vector2.RIGHT

## New direction set by player
var new_direction: Vector2

## Array to hold and track all the snake body parts
var _snake_body_parts: Array[SnakeBody]


func _ready() -> void:	
	# Connect timer signal
	$MovementTimer.timeout.connect(_on_movement_timer_timeout)
	
	# Set the initial position of the snake (extra is cause sprites are centered)
	global_position = Vector2(tile_size*10, tile_size*5) + Vector2(tile_size/2, tile_size/2)
	
	# Need an initial new direction
	new_direction = current_direction

	# Create the initial snake
	for i in range(init_size-1):
		print("making body")
		add_snake_body_part()
		move_snake_head()


func _physics_process(_delta: float) -> void:
	get_input()


## Get NEW_DIRECTION based on player input
func get_input() -> void:
	for input in DIRECTIONS:
		if Input.is_action_just_pressed(input):
			new_direction = DIRECTIONS[input]


## Update CURRENT_DIRECTION and CURRENT_ROTATION based on NEW_DIRECTION
func update_rotation_and_direciton() -> void:
	# Check snake can move in NEW_DIRECTION
	if (new_direction + current_direction) != Vector2.ZERO \
	and new_direction != current_direction:
		current_rotation += calculate_rotation(new_direction)
		current_direction = new_direction


## Determine the rotation of the snake based on CURRENT_DIRECTION
func calculate_rotation(new_dir: Vector2) -> float:
	if new_dir.y == 0: # moving right or left
		return -(new_dir.x * current_direction.y) * PI/2
	else: # moving up or down
		return (new_dir.y * current_direction.x) * PI/2


## Add a new snake body part at current head position
func add_snake_body_part() -> void:
	var new_body := snake_body.instantiate() as SnakeBody
	_snake_body_parts.append(new_body)
	new_body.rotation = rotation # Same rotation as the head
	new_body.global_position = global_position # Same position as the head
	$Body.add_child(new_body)


## Move the snake head by one square in CURRENT_DIRECTION
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
	update_rotation_and_direciton()
	add_snake_body_part()
	move_snake_head()
	remove_tail()
