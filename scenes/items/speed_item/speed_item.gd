class_name SpeedItem
extends ItemResource
##
## This item increases the snakes speed by stacking speed increases.
##

@export var duration: float = 5.0
@export var multiplier: float = .2


## Signal the snake manager to not move it's tail on the next move. 
func apply_item(snake_manager: SnakeManager) -> void:
	var timer: Timer = snake_manager._movement_component.timer
	var speed_increase: float = multiplier * snake_manager._movement_component.wait_time
	timer.wait_time -= speed_increase
	await snake_manager.get_tree().create_timer(duration).timeout
	timer.wait_time += speed_increase
