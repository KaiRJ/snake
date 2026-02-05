class_name ItemManager 
extends Node
## Scene to manage the spawning of the items.
##
## This scene randomly picks a spawn time between min_spawn_time and 
## max_spawn_time, and after this time spawns an random item from the array
## item_types on the map.
##

@onready var spawn_timer: Timer = $SpawnTimer

## The TileMapLayer the snake is moving in
@export var tile_map_layer: TileMapLayer

## The base item type
@export var item_scene: PackedScene

## Resources for the different types of item
@export var item_types: Array[ItemResource]

## The minimum sqawn time for an item
@export var min_spawn_time: float = 5.0

## The maximum sqawn time for an item
@export var max_spawn_time: float = 10.0

## Variable to hold the total score from all the items picked up
var total_score: int = 0

## Variable to hold all the coordinents of the grid
var _all_coordinates: Array[Vector2i]


func _ready() -> void:	
	# get dimensions of tile map layer
	var tm_rect: Rect2i = tile_map_layer.get_used_rect()
	var tm_origin: Vector2i = tm_rect.position
	var tm_size: Vector2i = tm_rect.size
	
	# get the tilemap size and offset
	var tm_tile_size: Vector2i = tile_map_layer.tile_set.tile_size
	@warning_ignore("integer_division")
	var offset: Vector2i = tm_tile_size/2
	
	# get the coordinates of ALL the squares (-2 for border)
	for x: int in range(tm_size.x - tm_origin.x - 2):
		for y: int in range(tm_size.y - tm_origin.y - 2):
			var coord: Vector2i = (Vector2i(x+1,y+1) * tm_tile_size) + offset
			_all_coordinates.append(coord)
	
	# connect signals and start the spawn timer
	GameEvents.game_over.connect(_on_game_over)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	# spawn item at start of game and start the timer
	_on_spawn_timer_timeout()

## Create an array of all the free coordinates available to spawn an item in
func get_free_coordinates() -> Array[Vector2i]:
	var free_coords: Array[Vector2i] = _all_coordinates.duplicate()
	
	# remove squares with snake bodies in them
	for body: SnakeBody in get_tree().get_nodes_in_group("snake"):
		free_coords.erase(Vector2i(body.global_position))
		
	# remove squares with items in them
	for item: Item in get_tree().get_nodes_in_group("item"):
		free_coords.erase(Vector2i(item.global_position))
			
	return free_coords


## Spawn a random item in a specific location
func spawn_item(spawn_coords: Vector2i, item_type: ItemResource) -> void:
	var new_item: Item = item_scene.instantiate()
	new_item.picked_up.connect(_on_item_picked_up)
	
	add_child(new_item)
	new_item.make(item_type)
	new_item.global_position = spawn_coords
	new_item.life_time_timer.start(randf_range(min_spawn_time, max_spawn_time))


func pick_random_item() -> ItemResource:
	var sum_of_weight: int = 0
	for item: ItemResource in item_types:
		sum_of_weight += item.weight
	
	var random_item: ItemResource
	var random: int = randi_range(1, sum_of_weight-1)
	for item: ItemResource in item_types:
		if (random < item.weight):
			random_item = item
			break
		random -= item.weight
		
	return random_item


## Save all the data of the item_manager to the saved_game resource
func on_save_game(saved_game: SavedGame) -> SavedGame:
	saved_game.game_score = total_score
	return saved_game
	
	
## Load all the data from the saved_game resource
func on_load_game(saved_game: SavedGame) -> void:
	total_score = saved_game.game_score
	
	for item: SavedItem in saved_game.saved_items:
		spawn_item(item.position, item.item_type)


func _on_spawn_timer_timeout() -> void:
	var random_coords: Vector2i = get_free_coordinates().pick_random()
	var item_type: ItemResource = pick_random_item()
	spawn_item(random_coords, item_type)
	spawn_timer.start(randf_range(min_spawn_time, max_spawn_time))
	

func _on_item_picked_up(score: int) -> void:
	total_score += score
	

func _on_game_over() -> void:
	spawn_timer.stop()
