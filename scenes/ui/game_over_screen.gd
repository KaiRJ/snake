class_name GameOverScreen extends CanvasLayer


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
