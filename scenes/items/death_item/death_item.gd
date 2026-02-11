class_name DeathItem
extends ItemResource
##
## This item kills the player.
##


## Signal the snake manager to not move it's tail on the next move. 
func apply_item(_snake_manager: SnakeManager) -> void:
	GameEvents.game_over.emit()
