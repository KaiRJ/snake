class_name SnakeManager extends Node2D
## Scene to hold and manage snake body parts.
##
## TODO detailed description

## The snake body scene
@export var snake_body: PackedScene

## The TileMapLayer the snake is moving in
@export var tile_map_layer: TileMapLayer

## The starting size of the snake
@export var init_size := 3

## Dictionary for the directions for player input
const DIRECTIONS = {"ui_up"   : Vector2i.UP,
					"ui_down" : Vector2i.DOWN,
					"ui_right": Vector2i.RIGHT,
					"ui_left" : Vector2i.LEFT}

## Array to hold and track all the snake body parts
var snake_body_parts: Array[SnakeBody]

## Size of the tiles used in TILE_MAP
var _tile_size: Vector2i

## The current rotation of the snake in radians
var _current_rotation := 0.0

## The current direction of the snake
var _current_direction := Vector2i.RIGHT

## New direction set by player
var _new_direction: Vector2i


func _ready() -> void:
	# Connect timer signal
	$MovementTimer.timeout.connect(_on_movement_timer_timeout)

	if !tile_map_layer:
		# TODO should error out
		return
	
	# Get tile width (assuming squares)
	_tile_size = tile_map_layer.tile_set.tile_size
	
	# Get dimensions of tile map layer
	var tm_rect := tile_map_layer.get_used_rect()
	var tm_origin := tm_rect.position
	var tm_size := tm_rect.size
	
	# Set the initial position to center (plus offset of sprite)
	# TODO bound to be a better way of doing this
	var center = _tile_size * Vector2i(tm_size.x/2, tm_size.y/2)
	var offset = Vector2i(_tile_size/2)
	global_position = tm_origin + center + offset

	# Need an initial new direction
	_new_direction = _current_direction

	# Create the initial snake
	for i in range(init_size):
		print(i)
		add_new_head_infront_of_head()


func _physics_process(_delta: float) -> void:
	get_input()


## Get _new_direction based on player input
func get_input() -> void:
	for input in DIRECTIONS:
		if Input.is_action_just_pressed(input):
			_new_direction = DIRECTIONS[input]
	

## Update _current_direction and _current_rotation based on _new_direction
func update_rotation_and_direciton() -> void:
	# Check snake can move in _new_direction
	if (_new_direction + _current_direction) != Vector2i.ZERO \
	and _new_direction != _current_direction:
		_current_rotation += calculate_rotation(_new_direction)
		_current_direction = _new_direction


## Determine the rotation of the snake based on _current_direction
func calculate_rotation(new_dir: Vector2i) -> float:
	if new_dir.y == 0: # moving right or left
		return -(new_dir.x * _current_direction.y) * PI/2
	else: # moving up or down
		return (new_dir.y * _current_direction.x) * PI/2


## Create a new head in front of the old head
func add_new_head_infront_of_head() -> void:	
	# instatiate a new snake body part and make it a head
	var new_head := snake_body.instantiate() as SnakeBody
	$Body.add_child(new_head)
	move_part_to_front(new_head)


## Remove the current snake tail and make the new last body part a tail
func move_tail_infront_of_head() -> void:
	# make current tail the new snake head
	var new_head = snake_body_parts.pop_back()
	new_head.make_head()
	move_part_to_front(new_head)
	snake_body_parts.back().make_tail() # replace the tail


## Move an instance of a SnakeBody to the front of the snake
func move_part_to_front(new_head: SnakeBody) -> void:
	# If there is no head currently then use the position of the SnakeManager
	var origin: Vector2i = global_position
	if len(snake_body_parts) > 0:
		var current_head = snake_body_parts.front() as SnakeBody
		current_head.make_body()
		origin = current_head.global_position 
		
	# initialise new head infront of the hold one
	new_head.make_head()
	new_head.rotation = _current_rotation # Same rotation as the head
	new_head.global_position = origin + (_current_direction * _tile_size)
	snake_body_parts.push_front(new_head)


## Update the players position on timer timeout
func _on_movement_timer_timeout() -> void:
	update_rotation_and_direciton()
	move_tail_infront_of_head()
