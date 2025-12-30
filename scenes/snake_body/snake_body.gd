class_name SnakeBody 
extends Node2D
## Scene for individual snake body parts.
##
## This scene controls the sprite used for each body type (head, body, tail)
## and calls the game over function if the head collides with another body.
##

# TODO might not need this when can just check the sprites directly
enum Type {HEAD, BODY, TAIL}
var type: Type = Type.HEAD

func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)


## Turn body part into a specific part
func make(t: Type) -> void:
	type = t


## Delete the snake bodies on load game
func on_load_game(_saved_game: SavedGame) -> void:
	queue_free()


## If the head collides with an other snake body call the game over function
func _on_area_entered(area: Area2D) -> void:
	# Check if head to make sure game over is only called once
	if (area.get_parent() is SnakeBody) and (type == Type.HEAD): 
			GameEvents.game_over.emit()
		
