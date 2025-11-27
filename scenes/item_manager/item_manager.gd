class_name ItemManager extends Node
## Scene to manage the spawning of the items.
##
## TODO detailed description

## Array to hold all the different item types
@export var items: Array[PackedScene]

## The TileMapLayer the snake is moving in
@export var tile_map_layer: TileMapLayer

## The snake manager to add items around
@export var snake_manager: SnakeManager

## The minimum sqawn time for an item
@export var min_spawn_time := 5

## The maximum sqawn time for an item
@export var max_spawn_time := 10

## Variable to hold all the coordinents of the grid
var _all_coordinates: Array[Vector2i]


func _ready() -> void:
	# Get dimensions of tile map layer
	var tm_rect := tile_map_layer.get_used_rect()
	var tm_origin := tm_rect.position
	var tm_size := tm_rect.size
	
	# Get the tilemap size and offset
	var tm_tile_size := tile_map_layer.tile_set.tile_size
	var offset = tm_tile_size/2
	
	
	# Get the coordinates of ALL the squares
	for x in range(tm_size.x - tm_origin.x):
		for y in range(tm_size.y - tm_origin.y):
			var coord: Vector2i = (Vector2i(x,y) * tm_tile_size) + offset
			_all_coordinates.append(coord)
	
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start(randf_range(min_spawn_time, max_spawn_time))
	

## Create an array of all the free coordinates available to spawn an item in
func get_free_coordinates():
	var snake_body_coords := snake_manager.get_snake_body_coordinates()
	var free_coords = _all_coordinates.filter(
		func(c): 
			return not snake_body_coords.has(c)
			)
			
	return free_coords
	

## Spawn a random item in a specific location
func spawn_random_item(spawn_coords: Vector2i) -> void:
	print("Spawning item")
	print(spawn_coords)
	


func _on_spawn_timer_timeout():
	var free_squares: Array[Vector2i] = get_free_coordinates()
	spawn_random_item(free_squares.pick_random())
	$SpawnTimer.start(randf_range(min_spawn_time, max_spawn_time))
