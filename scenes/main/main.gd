class_name MainScene
extends Node


func _ready() -> void:
	var main_menu_scene: PackedScene = load("res://scenes/ui/main_menu/main_menu.tscn")
	var main_menu_instance: MainMenu = main_menu_scene.instantiate()
	add_child(main_menu_instance)
