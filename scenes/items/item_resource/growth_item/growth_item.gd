class_name GrowthItem
extends ItemResource
## This item increases the snake size by 1.
##
## When picked up this item signals the snake to not move its tail.
##


## Signal the snake manager to not move it's tail on the next move. 
func apply_item(snake_manager: SnakeManager) -> void:
	snake_manager.move_tail = false
