class_name GrowthItem
extends ItemResource
##
## This item increases the snake size by 1.
##


## Signal the snake manager to not move it's tail on the next move. 
func apply_item(snake_manager: SnakeManager) -> void:
	snake_manager.grow = true
