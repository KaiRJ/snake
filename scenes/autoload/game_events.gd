extends Node


@export var game_over_screen_scene: PackedScene


func game_over():
	var game_over_screen_scene_instance := game_over_screen_scene.instantiate()
	get_tree().get_root().add_child(game_over_screen_scene_instance)
