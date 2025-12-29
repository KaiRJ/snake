extends Node


## When the snake enters the map bounds call the game over function.
func _on_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		GameEvents.game_over.emit()
