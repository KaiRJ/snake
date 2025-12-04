class_name Item
extends Node


func _ready() -> void:
	pass


func apply_item(snake_manager: SnakeManager) -> void:
	print("applying item")
	snake_manager.add_new_head_infront_of_head()


func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		apply_item(area.get_parent().get_parent().get_parent() as SnakeManager)
		queue_free()


func _on_life_time_timer_timeout() -> void:
	queue_free()
