class_name ItemResource
extends Resource
## Base resource type for all my times.
##
## This class serves as a connection between all items in my game so that I can
## easily apply items without checking types.
##

## This is the name of the item.
@export 
var item_name: String

## This is the icon for the item.
@export 
var icon: Texture2D

## This is how much score the item is worth.
@export 
var score: int = 0


## This is the template function for an item to call when it is picked up.
func apply_item(_snake_manager: SnakeManager) -> void:
	push_error("apply_item() not implemented for item: %s" % item_name)
