class_name MainMenu
extends CenterContainer


func _ready() -> void:
	get_tree().paused = true;
	
	# only show load button if there is a game to load
	$%LoadGameButton.visible = ResourceLoader.exists(GameEvents.SAVE_FILE)
	

func start_game() -> void:
	GameEvents.start_game.emit()
	get_tree().paused = false;
	queue_free()
	
	
func load_game() -> void:
	GameEvents.load_game.emit()
	

func _on_start_game_button_pressed() -> void:
	start_game()


func _on_load_game_button_pressed() -> void:
	load_game()
	start_game()


func _on_leaderboard_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
