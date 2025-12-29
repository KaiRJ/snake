class_name SnakeBody 
extends Node2D
## Scene for individual snake body parts.
##
## This scene controls the sprite used for each body type (head, body, tail)
## and calls the game over function if the head collides with another body.
##

# TODO might not need this when can just check the sprites directly
var isHead := true

func _ready() -> void:
	make_head()
	$Area2D.area_entered.connect(_on_area_entered)


## Turn body part into a snake body part
func make_head():
	isHead = true
	pass


## Turn body part into a snake body part
func make_body():
	isHead = false
	pass


## Turn body part into a snake tail part
func make_tail():
	isHead = false
	pass


## If the head collides with an other snake body call the game over function.
func _on_area_entered(area: Area2D):
	if area.get_parent() is SnakeBody:
		if (isHead): # to make sure game over is only called once
			GameEvents.game_over.emit()
		
