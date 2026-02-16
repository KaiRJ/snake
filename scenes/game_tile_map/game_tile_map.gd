class_name GameTileMap
extends TileMapLayer
## Holds methods to get the free tiles in the game map.
##


## Create an array of all the free coordinates available to spawn an item in
func get_free_coordinates() -> Array[Vector2i]:
	var free_coords: Array[Vector2i] = get_all_coordinates()
	
	# remove squares with snake bodies in them
	for body: SnakeBody in get_tree().get_nodes_in_group("snake"):
		free_coords.erase(Vector2i(body.global_position))
		
	# remove squares with items in them
	for item: Item in get_tree().get_nodes_in_group("item"):
		free_coords.erase(Vector2i(item.global_position))
	
	# remove squares with obstacles in them
	for obstacle: Obstacle in get_tree().get_nodes_in_group("obstacle"):
		free_coords.erase(Vector2i(obstacle.global_position))

	return free_coords


## Get all the coordinates on the tile map
func get_all_coordinates() -> Array[Vector2i]:
	# get dimensions of tile map layer
	var tm_rect: Rect2i = get_used_rect()
	var tm_origin: Vector2i = tm_rect.position
	var tm_size: Vector2i = tm_rect.size
	
	# get the tilemap size and offset
	var tm_tile_size: Vector2i = tile_set.tile_size
	@warning_ignore("integer_division")
	var offset: Vector2i = tm_tile_size/2
	
	# get the coordinates of ALL the squares (-2 for border)
	var all_coordinates: Array[Vector2i] 
	for x: int in range(tm_size.x - tm_origin.x - 2):
		for y: int in range(tm_size.y - tm_origin.y - 2):
			var coord: Vector2i = (Vector2i(x+1,y+1) * tm_tile_size) + offset
			all_coordinates.append(coord)
			
	return all_coordinates


##
func get_center() -> Vector2i:
	# get dimensions of tile_map_layer
	var tm_rect: Rect2i = get_used_rect()
	var tm_origin: Vector2 = tm_rect.position
	var tm_size: Vector2 = tm_rect.size
	
	# get individual tile size
	var tm_tile_size: Vector2 = tile_set.tile_size
	var tile_size: Vector2 = tm_tile_size
	
	var center: Vector2 = tm_origin + (tm_tile_size * tm_size / 2.)
	return snapped(center, Vector2(16,16)) + (tile_size/2.)
