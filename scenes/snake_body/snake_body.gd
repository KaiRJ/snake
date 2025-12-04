class_name SnakeBody extends Node2D
## TODO
##
## TODO detailed description

# TODO might not need this when can just check the sprites directly
var isHead := true

func _ready() -> void:
	$Area2D.area_entered.connect(_on_area_entered)


## Turn body part into a snake body part
func make_head():
	pass


## Turn body part into a snake body part
func make_body():
	pass


## Turn body part into a snake tail part
func make_tail():
	pass


func _on_area_entered(area: Area2D):
	if area.get_parent() is SnakeBody:
		GameEvents.game_over()
		
