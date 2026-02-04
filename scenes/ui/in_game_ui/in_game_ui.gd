class_name InGameUI
extends CanvasLayer
## In game UI to display the score, game size, and menu button.

@onready var score_label: Label = $%Score
@onready var snake_size_label: Label = $%SnakeSize

## Reference to the in game menu scene.
@export var in_game_menu_scene: PackedScene

## Reference to the item manager scene to get the score in the game.
@export var item_manager: ItemManager

## Reference to the snake manager scene to get the size of the snake.
@export var snake_manager: SnakeManager


func _ready() -> void:
	visible = false
	GameEvents.game_over.connect(_on_game_over_signal)


func _process(_delta: float) -> void:
	if item_manager == null:
		return 
	score_label.text = str(item_manager.total_score)
	
	if snake_manager == null:
		return
	snake_size_label.text = str(snake_manager.snake_body_parts.size())


func _on_menu_button_pressed() -> void:
	get_tree().paused = true;
	visible = false
	
	var in_game_menu: InGameMenu = in_game_menu_scene.instantiate()
	in_game_menu.resume.connect(_on_in_game_menu_resume)
	get_parent().add_child(in_game_menu)
	in_game_menu.make_in_game_menu()


func _on_game_over_signal() -> void:
	#get_tree().paused = true;
	visible = false
	
	var in_game_menu: InGameMenu = in_game_menu_scene.instantiate()
	get_parent().add_child(in_game_menu)
	in_game_menu.make_game_over_menu()


func _on_in_game_menu_resume() -> void:
	visible = true
	get_tree().paused = false;
