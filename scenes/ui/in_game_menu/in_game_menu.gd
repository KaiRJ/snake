class_name InGameMenu
extends CenterContainer
## The in game menu scene for resuming, restarting, saving, and quiting the game.
##

## Signal that the game should be resumed
signal resume


func _on_resume_button_pressed() -> void:
	resume.emit()
	queue_free()


func _on_save_button_pressed() -> void:
	GameEvents.save_game.emit()


func _on_load_button_pressed() -> void:
	GameEvents.load_game.emit()


func _on_quit_button_pressed() -> void:		
	GameEvents.quit_game()
