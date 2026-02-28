class_name ItemManager 
extends Node
## Scene to manage the spawning of the items.
##
## This scene randomly picks a spawn time between min_spawn_time and 
## max_spawn_time, and after this time spawns an random item from the array
## item_types on the map.
##

## The TileMapLayer the snake is moving in
@export var game_tile_map: GameTileMap

## The base item type
@export var item_scene: PackedScene

## Resources for the different types of item
@export var item_types: Array[ItemResource]

## Variable to hold the total score from all the items picked up
var total_score: int = 0


func _ready() -> void:
	spawn_random_item()


func spawn_random_item() -> void:
	var random_coords: Vector2i = game_tile_map.get_free_coordinates().pick_random()
	var item_type: ItemResource = pick_random_item()
	spawn_item(random_coords, item_type)


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


## Spawn a random item in a specific location
func spawn_item(spawn_coords: Vector2i, item_type: ItemResource) -> void:
	var new_item: Item = item_scene.instantiate()
	new_item.picked_up.connect(_on_item_picked_up)
	
	add_child(new_item)
	new_item.make(item_type)
	new_item.global_position = spawn_coords
	new_item.life_time_timer.start(item_type.lifetime)


func _on_item_picked_up(score: int) -> void:
	total_score += score
	await get_tree().create_timer(2.0).timeout  # Waits 2 seconds
	call_deferred("spawn_random_item")
	

## Save all the data of the item_manager to the saved_game resource
func _on_save_game(saved_game: SavedGame) -> SavedGame:
	saved_game.game_score = total_score
	return saved_game
	
	
## Load all the data from the saved_game resource
func _on_load_game(saved_game: SavedGame) -> void:
	total_score = saved_game.game_score
	
	for item: SavedItem in saved_game.saved_items:
		spawn_item(item.position, item.item_type)
