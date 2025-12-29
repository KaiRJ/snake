class_name MainScene
extends Node


func _ready() -> void:
	# Hide UI elements
	$InGameUI.visible = false
	var main_menu_scene = load("res://scenes/ui/main_menu/main_menu.tscn")
	var main_menu_instance = main_menu_scene.instantiate()
	add_child(main_menu_instance)
