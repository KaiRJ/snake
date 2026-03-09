class_name MainMenu
extends CanvasLayer

@onready var load_button: Button = $%LoadGameButton

signal start_game
signal spawn_leaderboard


func _ready() -> void:
	# only show load button if there is a game to load
	load_button.visible = ResourceLoader.exists(GameEvents.SAVE_FILE)


func _on_start_game_button_pressed() -> void:
	start_game.emit()
	queue_free()


func _on_load_game_button_pressed() -> void:
	GameEvents.load_game.emit()
	start_game.emit()
	queue_free()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_leaderboard_button_pressed() -> void:
	spawn_leaderboard.emit()
	self.queue_free()
