class_name SnakeBody 
extends Node2D
## Scene for individual snake body parts.
##
## This scene controls the sprite used for each body type (head, body, tail)
## and calls the game over function if the head collides with another body.
##

enum Type {HEAD, BODY, TAIL}
var type: Type = Type.HEAD

var head_texture = preload("res://assets/gilla/head.png")
var body_texture = preload("res://assets/gilla/body.png")
var tail_texture = preload("res://assets/gilla/tail.png")


func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)
	$Body.texture = body_texture


## Turn body part into a specific part
func make(t: Type) -> void:
	type = t
	match type:
		Type.HEAD:
			$Body.texture = head_texture
		Type.BODY:
			$Body.texture = body_texture
		Type.TAIL:
			$Body.texture = tail_texture


## Delete the snake bodies on load game
func on_load_game(_saved_game: SavedGame) -> void:
	queue_free()


## If the head collides with an other snake body call the game over function
func _on_area_entered(area: Area2D) -> void:
	# Check if head to make sure game over is only called once
	if (area.get_parent() is SnakeBody) and (type == Type.HEAD): 
			GameEvents.game_over.emit()
		
