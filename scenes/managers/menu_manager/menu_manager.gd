extends Control

@export var in_game_ui: InGameUI
@export var main_menu_scene: PackedScene
@export var leaderboard_scene: PackedScene


func _ready() -> void:
	GameEvents.game_over.connect(_on_game_over)
	
	in_game_ui.hide()
	
	get_tree().paused = true
	spawn_main_menu()


func spawn_main_menu() -> void:
	var main_menu: MainMenu = main_menu_scene.instantiate()
	add_child(main_menu)
	main_menu.start_game.connect(_on_start_game)
	main_menu.spawn_leaderboard.connect(spawn_leaderboard)


func spawn_leaderboard() -> Leaderboard:
	var leaderboard: Leaderboard = leaderboard_scene.instantiate()
	add_child(leaderboard)
	return leaderboard


func _on_start_game() -> void:
	in_game_ui.visible = true
	get_tree().paused = false;


func _on_game_over() -> void:
	in_game_ui.visible = false
	var leaderboard: Leaderboard = spawn_leaderboard()
	var score: int = int(in_game_ui.score_label.text)
	leaderboard.pass_score(score)
