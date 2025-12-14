class_name ItemResource
extends Resource

# TODO Add documentation

@export var item_name: String
@export var icon: Texture2D
@export var score: int 


func apply_item(snake_manager: SnakeManager) -> void:
	push_error("apply_item() not implemented for item: %s" % item_name)
