class_name ObstacleManager
extends Node
## Manager to spawn a certain number of random obstacles at the start of the game.
## 

## The TileMapLayer the snake is moving in
@export var game_tile_map: GameTileMap

## All the obstacles to be spawned at the start of the game
@export var amount_to_spawn: int = 4

## All the obstacles to be spawned at the start of the game
@export var obstacle_scene: PackedScene


func _ready() -> void:
	# get all free coords and then shuffle to randomise them
	var random_coordinates: Array[Vector2i] = game_tile_map.get_free_coordinates()
	random_coordinates.shuffle()
	
	for i: int in range(amount_to_spawn):
		var new_obstacle: Obstacle = obstacle_scene.instantiate()
		add_child(new_obstacle)
		
		var new_coord: Vector2i = random_coordinates.pop_front()
		new_obstacle.global_position = new_coord
