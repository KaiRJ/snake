class_name Item
extends Node

@export var items: Array[ItemResource]


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		var snake_manager = area.get_parent().get_parent().get_parent() as SnakeManager
		items.pick_random().apply_item(snake_manager)
		queue_free()


func _on_life_time_timer_timeout() -> void:
	queue_free()
