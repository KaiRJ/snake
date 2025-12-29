class_name SnakeManager 
extends Node2D
## Scene to hold and manage snake body parts.
##
## This scene stores each snake body part and controls the movement of them in 
## the game. 
##

## The tile map the snake is moving in
@export var tile_map: TileMapLayer

## Initial snake size
@export var init_size: int

## The snake body scene
@export var snake_body: PackedScene

## Dictionary for the directions for player input
const DIRECTIONS = {"ui_up"   : Vector2i.UP,
					"ui_down" : Vector2i.DOWN,
					"ui_right": Vector2i.RIGHT,
					"ui_left" : Vector2i.LEFT}

## Array to hold and track all the snake body parts
var snake_body_parts: Array[SnakeBody]

## Move the tail to the front or create a new head
var move_tail := true

## Size of the tiles used in TILE_MAP
var _step_size: Vector2i

## The current rotation of the snake in radians
var _current_rotation := 0.0

## The current direction of the snake
var _current_direction := Vector2i.RIGHT

## New direction set by player (gets checked at timer end)
var _new_direction: Vector2i


func _ready() -> void:
	GameEvents.start_game.connect(_on_start_game_signal)
	GameEvents.game_over.connect(_on_game_over_signal)

	
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
	new_head.global_position = origin + (_current_direction * _step_size)
	snake_body_parts.push_front(new_head)
	

## Update the players position on timer timeout
func _on_movement_timer_timeout() -> void:
	update_rotation_and_direciton()
	
	var new_head: SnakeBody
	if move_tail: # make the current tail the head
		new_head = snake_body_parts.pop_back()
		snake_body_parts.back().make_tail() # replace the tail
	else: # instantiate a new head
		new_head = snake_body.instantiate()
		$Body.add_child(new_head)
	
	move_part_to_front(new_head)
	move_tail = true


func _on_start_game_signal():
	print("statring gmae")
	# Get dimensions of tile map layer
	var tm_tile_size = tile_map.tile_set.tile_size
	var tm_rect = tile_map.get_used_rect()
	var tm_origin = tm_rect.position
	var tm_size = tm_rect.size
	var center = tm_origin + (tm_tile_size * (tm_size/2)) + tm_tile_size/2
	
	# Set new default values
	_step_size = tm_tile_size
	global_position = center
	_new_direction = Vector2i.RIGHT
	_current_direction = Vector2i.RIGHT
	
	# Instantiate a new snake body part and make it a head
	for i in range(init_size):
		var new_head := snake_body.instantiate() as SnakeBody
		$Body.add_child(new_head)
		move_part_to_front(new_head)
		
	# Start timer with new speed
	$MovementTimer.start(0.5)


func _on_game_over_signal():
	pass
	#snake_body_parts.clear()
