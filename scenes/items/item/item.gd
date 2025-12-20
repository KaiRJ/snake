class_name Item
extends Node
## Script to control the items in the game.
##
## The script detects if a snake picks up the item and then applys the item.
##


## Resource to hold the item icon, score, and ability
@export var item_type: ItemResource

## Signal item has been picked up and what the score is
signal picked_up(score)


## Apply the item's apply_item function to the snake_manager.
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		var snake_manager = area.get_parent().get_parent().get_parent() as SnakeManager
		item_type.apply_item(snake_manager)
		picked_up.emit(item_type.score)
		queue_free()


## Delete this item on the timer timeout.
func _on_life_time_timer_timeout() -> void:
	queue_free()
