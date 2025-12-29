class_name MainMenu
extends CanvasLayer


func _ready() -> void:
	get_tree().paused = true;

func _on_start_game_button_pressed() -> void:
	GameEvents.start_game.emit()
	get_tree().paused = false;
	queue_free()


func _on_load_game_button_pressed() -> void:
	pass # Replace with function body.


func _on_leaderboard_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
