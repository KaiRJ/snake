class_name ItemManager 
extends Node
## Scene to manage the spawning of the items.
##
## This scene randomly picks a spawn time between min_spawn_time and 
## max_spawn_time, and after this time spawns an random item from the array
## item_types on the map.
##


## The TileMapLayer the snake is moving in
@export var tile_map_layer: TileMapLayer

## The base item type
@export var item_scene: PackedScene

## Resources for the different types of item
@export var item_types: Array[ItemResource]

## The minimum sqawn time for an item
@export var min_spawn_time := 5

## The maximum sqawn time for an item
@export var max_spawn_time := 10

## Variable to hold the total score from all the items picked up
var total_score: int = 0

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
	
	# Get the coordinates of ALL the squares (-2 for border)
	for x in range(tm_size.x - tm_origin.x - 2):
		for y in range(tm_size.y - tm_origin.y - 2):
			var coord: Vector2i = (Vector2i(x+1,y+1) * tm_tile_size) + offset
			_all_coordinates.append(coord)
	
	# Connect and start the spawn timer
	$SpawnTimer.timeout.connect(_on_spawn_timer_timeout)
	$SpawnTimer.start(randf_range(min_spawn_time, max_spawn_time))


## Create an array of all the free coordinates available to spawn an item in
func get_free_coordinates() -> Array[Vector2i]:
	var free_coords := _all_coordinates.duplicate()
	
	# Remove squares with snake bodies in them
	for body in get_tree().get_nodes_in_group("snake"):
		free_coords.erase(Vector2i(body.global_position))
		
	# Remove squares with items in them
	for body in get_tree().get_nodes_in_group("item"):
		free_coords.erase(Vector2i(body.global_position))
			
	return free_coords


## Spawn a random item in a specific location
func spawn_item(spawn_coords: Vector2i, item_type: ItemResource) -> void:
	var new_item = item_scene.instantiate() as Item
	new_item.global_position = spawn_coords
	new_item.item_type = item_type
	new_item.picked_up.connect(_on_item_picked_up)
	add_child(new_item)
	

## Save all the data of the item_manager to the saved_game resource
func on_save_game(saved_game: SavedGame) -> SavedGame:
	saved_game.game_score = total_score
	return saved_game
	
	
## Load all the data from the saved_game resource
func on_load_game(saved_game: SavedGame) -> void:
	total_score = saved_game.game_score
	
	for item in saved_game.saved_items:
		spawn_item(item.position, item.item_type)


func _on_spawn_timer_timeout() -> void:
	var random_coords = get_free_coordinates().pick_random()
	var item_type = item_types.pick_random()
	spawn_item(random_coords, item_type)
	$SpawnTimer.start(randf_range(min_spawn_time, max_spawn_time))
	

func _on_item_picked_up(score):
	total_score += score
