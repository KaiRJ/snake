extends Node


func _on_area_entered(area: Area2D) -> void:
	print("area entered")
	if area.get_parent() is SnakeBody:
		GameEvents.game_over()
