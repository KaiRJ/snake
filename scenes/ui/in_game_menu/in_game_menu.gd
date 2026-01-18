class_name InGameMenu
extends CenterContainer
## The in game menu scene for prompting the player to resume, restart, and quit.
##
## This scene pauses the game and shows the player the in game menu, which
## they can interact with.
##


## Signal that the game should be resumed
signal resume


## Set the resume button to be visable and the label for the in game menu.
func make_in_game_menu() -> void:
	$%Label.text = "Main Menu"
	$%ResumeButton.visible = true
	

## Set the resume button to be invisable and the label for the game over menu.
func make_game_over_menu() -> void:
	$%Label.text = "Game over!"
	$%ResumeButton.visible = false
	$%LoadButton.visible = false
	$%SaveButton.visible = false


func _on_resume_button_pressed() -> void:
	resume.emit()
	queue_free()


func _on_save_button_pressed() -> void:
	GameEvents.save_game.emit()


func _on_load_button_pressed() -> void:
	GameEvents.load_game.emit()


func _on_quit_button_pressed() -> void:		
	GameEvents.quit_game()
