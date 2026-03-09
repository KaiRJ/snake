class_name VisabilityItem
extends ItemResource
##
## This item reduces the players visability.
##

@export var reduced_visability_scene: PackedScene

## 
func apply_item(snake_manager: SnakeManager) -> void:
	var reduced_visability: ReducedVisability = reduced_visability_scene.instantiate()
	reduced_visability.snake = snake_manager
	snake_manager.add_child(reduced_visability)
