class_name Item
extends Node2D
## Script to control the items in the game.
##
## The script detects if a snake picks up the item and then applys the item.
##

@onready var sprite: Sprite2D = $Sprite2D

## Resource to hold the item icon, score, and ability
var item_type: ItemResource

## Signal item has been picked up and what the score is
signal picked_up(score: int)


## Initialise an item as a type
func make(type: ItemResource) -> void:
	item_type = type
	sprite.texture = item_type.texture


## Save all the data of the item_manager to the saved_game resource
func on_save_game(saved_game: SavedGame) -> SavedGame:
	var saved_item: SavedItem = SavedItem.new()
	saved_item.position = global_position
	saved_item.item_type = item_type
	saved_game.saved_items.append(saved_item)
	return saved_game
	

## Remove item on a load game.
func on_load_game(_saved_game: SavedGame) -> void:
	queue_free()


## Apply the item's apply_item function to the snake_manager.
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		var snake_manager: SnakeManager = area.get_parent().get_parent().get_parent()
		item_type.apply_item(snake_manager)
		picked_up.emit(item_type.score)
		queue_free()


## Delete this item on the timer timeout.
func _on_life_time_timer_timeout() -> void:
	queue_free()
