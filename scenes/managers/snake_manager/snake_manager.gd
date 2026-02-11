class_name SnakeManager 
extends Node2D
## Scene to hold and manage snake body parts.
##
## This scene stores each snake body part and controls the movement of them in 
## the game. 
##

@onready var _body: Node = $Body

## The tile map the snake is moving in
@export var tile_map: TileMapLayer

## Initial snake size
@export var init_size: int = 4

## The snake body scene
@export var snake_body_scene: PackedScene

## Array to hold and track all the snake body parts
var snake_body_parts: Array[SnakeBody]

## Flag for if snake should grow on next move
var grow: bool = false

## Size of the tiles used in TILE_MAP
var _step_size: Vector2i

## The current rotation of the snake in radians
var _rotation: float = 0.0

## The current direction of the snake
var _direction: Vector2i = Vector2i.RIGHT


func _ready() -> void:	
	# get dimensions of tile map layer
	var tm_tile_size: Vector2 = tile_map.tile_set.tile_size
	_step_size = tm_tile_size

	# set position to centre of tilemap
	var tm_rect: Rect2i = tile_map.get_used_rect()
	var tm_origin: Vector2 = tm_rect.position
	var tm_size: Vector2 = tm_rect.size
	var center: Vector2 = tm_origin + (tm_tile_size * tm_size / 2.)
	global_position = snapped(center, Vector2(16,16)) + (_step_size/2.)

	# defaults
	_direction = Vector2i.RIGHT
	
	# instantiate the snake body parts
	for i: int in range(init_size):
		move_head()
		
	# make the last part a tail
	var tail: SnakeBody = snake_body_parts.back()
	tail.make(SnakeBody.Type.TAIL)



## Update the players position on timer timeout
func move_snake(direction: Vector2i) -> void:
	update_direction_and_rotation(direction)
	move_tail()
	move_head()
	update_neck_rotation()


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


## Either detele the tail or leave it as be (not really moving it)
func move_tail() -> void:
	if grow:
		grow = false
		return
	
	var old_tail: SnakeBody = snake_body_parts.pop_back()
	old_tail.queue_free()
	
	var new_tail: SnakeBody = snake_body_parts.back()
	new_tail.make(SnakeBody.Type.TAIL)


## Move the snake by one unit
func move_head() -> void:
	var new_head: SnakeBody = snake_body_scene.instantiate()
	
	# if there is no head currently then use the position of the SnakeManager
	var origin: Vector2i = global_position
	if len(snake_body_parts) > 0:
		var current_head: SnakeBody = snake_body_parts.front()
		current_head.make(SnakeBody.Type.BODY)
		origin = current_head.global_position
		
	_body.add_child(new_head)
		
	# initialise new head infront of the hold one
	new_head.rotation = _rotation # Same rotation as the head
	new_head.global_position = origin + (_direction * _step_size)
	snake_body_parts.push_front(new_head)
	
	new_head.make(SnakeBody.Type.HEAD)


## Check if tail and head are not aligned with the body
func update_neck_rotation() -> void:
	var head: SnakeBody = snake_body_parts.front()
	var neck: SnakeBody = snake_body_parts[1]
	if (head.rotation > neck.rotation):
		neck.make(SnakeBody.Type.CURVE_DOWN)
		neck.rotation = head.rotation
	elif (head.rotation < neck.rotation):
		neck.make(SnakeBody.Type.CURVE_UP)
		neck.rotation = head.rotation


func _on_save_game(saved_game: SavedGame) -> SavedGame:
	var saved_snake: SavedSnake = SavedSnake.new()
	saved_snake.position = global_position
	saved_snake.grow = grow
	saved_snake.rotation = _rotation
	saved_snake.direction = _direction

	for body: SnakeBody in snake_body_parts:
		var saved_body: SavedBody = SavedBody.new()
		saved_body.position = body.position
		saved_body.rotation = body.rotation
		saved_body.type = body.type
		saved_snake.body_parts.append(saved_body)
	
	saved_game.saved_snake = saved_snake
	return saved_game


func _on_load_game(saved_game: SavedGame) -> void:
	global_position = saved_game.saved_snake.position
	grow = saved_game.saved_snake.grow
	_rotation = saved_game.saved_snake.rotation
	_direction = saved_game.saved_snake.direction

	for body: SnakeBody in snake_body_parts:
		body.queue_free()
	
	snake_body_parts.clear()
	for saved_body: SavedBody in saved_game.saved_snake.body_parts:
		var new_body: SnakeBody = snake_body_scene.instantiate()
		snake_body_parts.append(new_body)
		new_body.global_position = saved_body.position
		new_body.rotation = saved_body.rotation
		_body.add_child(new_body)
		new_body.make(saved_body.type)
