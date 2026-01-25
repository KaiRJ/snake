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
@export var init_size: int = 4

## The snake body scene
@export var snake_body_scene: PackedScene


## Array to hold and track all the snake body parts
var snake_body_parts: Array[SnakeBody]

## Move the tail to the front or create a new head
var move_tail: bool = true

## Size of the tiles used in TILE_MAP
var _step_size: Vector2i

## The current rotation of the snake in radians
var _rotation: float = 0.0

## The current direction of the snake
var _direction: Vector2i = Vector2i.RIGHT


func _ready() -> void:
	# connect signals to singleton
	GameEvents.start_game.connect(_on_start_game_signal)
	
	# get dimensions of tile map layer
	var tm_tile_size: Vector2i = tile_map.tile_set.tile_size
	_step_size = tm_tile_size


## Update the players position on timer timeout
func move(direction: Vector2i) -> void:
	update_direction_and_rotation(direction)
	
	var new_head: SnakeBody
	if move_tail: # make the current tail the head (and replace tail)
		new_head = snake_body_parts.pop_back()
		var new_tail: SnakeBody = snake_body_parts.back()
		new_tail.make(SnakeBody.Type.TAIL)
	else: # instantiate a new head
		new_head = snake_body_scene.instantiate()
		$Body.add_child(new_head)
	
	move_part_to_front(new_head)
	move_tail = true
	

## Update _direction and _rotation from a new direction
func update_direction_and_rotation(new_direction: Vector2i) -> void:
	# Check snake can move in _new_direction
	if ((new_direction + _direction) == Vector2i.ZERO) \
		or (new_direction == _direction):
		return

	if new_direction.y == 0: # moving right or left
		_rotation += -(new_direction.x * _direction.y) * PI/2
	else: # moving up or down
		_rotation += (new_direction.y * _direction.x) * PI/2
		
	_direction = new_direction


## Move an instance of a SnakeBody to the front of the snake
func move_part_to_front(new_head: SnakeBody) -> void:
	# If there is no head currently then use the position of the SnakeManager
	var origin: Vector2i = global_position
	if len(snake_body_parts) > 0:
		var current_head: SnakeBody = snake_body_parts.front()
		current_head.make(SnakeBody.Type.BODY)
		origin = current_head.global_position 
		
	# initialise new head infront of the hold one
	new_head.make(SnakeBody.Type.HEAD)
	new_head.rotation = _rotation # Same rotation as the head
	new_head.global_position = origin + (_direction * _step_size)
	snake_body_parts.push_front(new_head)
	
	
func _on_start_game_signal() -> void:
	# set position to centre of tilemap
	var tm_rect: Rect2i = tile_map.get_used_rect()
	var tm_origin: Vector2i = tm_rect.position
	var tm_size: Vector2i= tm_rect.size
	var center: Vector2i = tm_origin + (_step_size * (tm_size/2)) + _step_size/2
	global_position = center
	
	# defaults
	_direction = Vector2i.RIGHT
	
	# instantiate the snake body parts
	for i: int in range(init_size):
		var new_head: SnakeBody = snake_body_scene.instantiate()
		$Body.add_child(new_head)
		move_part_to_front(new_head)
		
	# make the last part a tail
	var tail: SnakeBody = snake_body_parts.back()
	tail.make(SnakeBody.Type.TAIL)


func on_save_game(saved_game: SavedGame) -> SavedGame:
	var saved_snake: SavedSnake = SavedSnake.new()
	saved_snake.position = global_position
	saved_snake.move_tail = move_tail
	saved_snake.rotation = _rotation
	saved_snake.direction = _direction

	for body: SnakeBody in snake_body_parts:
		var saved_body: SavedBody = SavedBody.new()
		saved_body.position = body.position
		saved_body.type = body.type
		saved_snake.body_parts.append(saved_body)
	
	saved_game.saved_snake = saved_snake
	return saved_game


func on_load_game(saved_game: SavedGame) -> void:
	global_position = saved_game.saved_snake.position
	move_tail = saved_game.saved_snake.move_tail
	_rotation = saved_game.saved_snake.rotation
	_direction = saved_game.saved_snake.direction

	snake_body_parts.clear()
	for body: SavedBody in saved_game.saved_snake.body_parts:
		var new_body: SnakeBody = snake_body_scene.instantiate()
		new_body.global_position = body.position
		new_body.make(body.type)
		snake_body_parts.append(new_body)
		$Body.add_child(new_body)
