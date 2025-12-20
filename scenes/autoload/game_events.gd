extends Node
## This node controls the game wide events.


## The game over screen
@export var game_over_screen_scene: PackedScene


## Instantiate the game over screen and add it to the tree
func game_over():
	var game_over_screen_scene_instance := game_over_screen_scene.instantiate()
	get_tree().get_root().add_child(game_over_screen_scene_instance)
