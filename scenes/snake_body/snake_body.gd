class_name SnakeBody 
extends Node2D
## Scene for individual snake body parts.
##
## This scene controls the sprite used for each body type (head, body, tail)
## and calls the game over function if the head collides with another body.
##

@onready var area: Area2D = $Area2D
@onready var body: Sprite2D = $Body

enum Type {HEAD, BODY, TAIL, CURVE_UP, CURVE_DOWN}
var type: Type = Type.HEAD

const head_texture: Texture2D = preload("res://assets/gilla/head.png")
const body_texture: Texture2D = preload("res://assets/gilla/body.png")
const tail_texture: Texture2D = preload("res://assets/gilla/tail.png")
const curve_up_texture: Texture2D = preload("res://assets/gilla/curve_up.png")
const curve_down_texture: Texture2D = preload("res://assets/gilla/curve_down.png")


func _ready() -> void:
	area.area_entered.connect(_on_area_entered)
	body.texture = body_texture


## Turn body part into a specific part
func make(t: Type) -> void:
	type = t
	match type:
		Type.HEAD:
			body.texture = head_texture
		Type.BODY:
			body.texture = body_texture
		Type.TAIL:
			body.texture = tail_texture
		Type.CURVE_UP:
			body.texture = curve_up_texture
		Type.CURVE_DOWN:
			body.texture = curve_down_texture


## Flip sprite in horizontal direction
func flip_h(flip: bool) -> void:
	body.flip_h = flip
	

## Flip sprite in vertical direction
func flip_v(flip: bool) -> void:
	body.flip_v = flip
	
	
## Delete the snake bodies on load game
func on_load_game(_saved_game: SavedGame) -> void:
	queue_free()


## If the head collides with an other snake body call the game over function
func _on_area_entered(incoming: Area2D) -> void:
	# Check if head to make sure game over is only called once
	if (incoming.get_parent() is SnakeBody) and (type == Type.HEAD): 
			GameEvents.game_over.emit()
		
