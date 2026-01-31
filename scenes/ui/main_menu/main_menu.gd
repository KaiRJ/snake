class_name MainMenu
extends CenterContainer

@onready var load_button: Button = $%LoadGameButton

@export var in_game_ui: InGameUI

func _ready() -> void:
	get_tree().paused = true;
	
	# only show load button if there is a game to load
	load_button.visible = ResourceLoader.exists(GameEvents.SAVE_FILE)


func start_game() -> void:
	in_game_ui.visible = true
	get_tree().paused = false;
	queue_free()

func _on_start_game_button_pressed() -> void:
	start_game()


func _on_load_game_button_pressed() -> void:
	GameEvents.load_game.emit()
	start_game()


func _on_leaderboard_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	get_tree().quit()
