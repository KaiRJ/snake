class_name Snake extends Node2D
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

## Size of the tiles used in TILE_MAP
var tile_size: Vector2i

## The current rotation of the snake in radians
var current_rotation := 0.0

## The current direction of the snake
var current_direction := Vector2i.RIGHT

## New direction set by player
var _new_direction: Vector2i

## Array to hold and track all the snake body parts
var _snake_body_parts: Array[SnakeBody]


func _ready() -> void:
	# Connect timer signal
	$MovementTimer.timeout.connect(_on_movement_timer_timeout)

	# Set the initial position to center (extra is cause sprites are centered)
	if !tile_map_layer:
		return
		
	var tm_rect := tile_map_layer.get_used_rect()
	var tm_origin := tm_rect.position
	var tm_size := tm_rect.size
	tile_size = tile_map_layer.tile_set.tile_size
	
	global_position = tm_origin + (tile_size * (tm_size + Vector2i.ONE)/2)
	
	# Need an initial new direction
	_new_direction = current_direction

	# Create the initial snake
	for i in range(init_size-1):
		print("making body")
		add_snake_body_part()
		move_snake_head()


func _physics_process(_delta: float) -> void:
	get_input()


## Get _new_direction based on player input
func get_input() -> void:
	for input in DIRECTIONS:
		if Input.is_action_just_pressed(input):
			_new_direction = DIRECTIONS[input]


## Update CURRENT_DIRECTION and CURRENT_ROTATION based on _new_direction
func update_rotation_and_direciton() -> void:
	# Check snake can move in _new_direction
	if (_new_direction + current_direction) != Vector2i.ZERO \
	and _new_direction != current_direction:
		current_rotation += calculate_rotation(_new_direction)
		current_direction = _new_direction


## Determine the rotation of the snake based on CURRENT_DIRECTION
func calculate_rotation(new_dir: Vector2i) -> float:
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
	global_position += Vector2(current_direction * tile_size)


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
