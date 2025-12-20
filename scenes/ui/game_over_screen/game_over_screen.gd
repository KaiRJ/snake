class_name GameOverScreen 
extends CanvasLayer
## The game over screen scene for prompting the player to restart/quit.
##
## This scene pauses the game and shows the player the game over screen, which
## they can interact with.
##


func _ready() -> void:
	get_tree().paused = true
	$%RestartButton.pressed.connect(_on_restart_button_pressed)
	$%QuitButton.pressed.connect(_on_quit_button_pressed)
	
	
func _on_restart_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	get_tree().paused = false
	queue_free()


func _on_quit_button_pressed():
	get_tree().quit()
