class_name InGameUI
extends CanvasLayer
## In game UI to display the score, game size, and menu button.
##
## TODO
##

## Reference to the item manager scene to get the score in the game.
@export var in_game_menu: PackedScene

## Reference to the item manager scene to get the score in the game.
@export var item_manager: ItemManager

## Reference to the snake manager scene to get the size of the snake.
@export var snake_manager: SnakeManager

## Reference to the snake size label in the UI.
@onready var snake_size_label = $%SnakeSize

## Reference to the score label in the UI.
@onready var score_label = $%Score


func _ready() -> void:
	GameEvents.start_game.connect(_on_start_game_signal)
	GameEvents.game_over.connect(_on_game_over_signal)


func _process(_delta: float) -> void:
	if item_manager == null:
		return 
	score_label.text = str(item_manager.total_score)
	
	if snake_manager == null:
		return
	snake_size_label.text = str(snake_manager.snake_body_parts.size())


func _on_menu_button_pressed() -> void:
	var in_game_menu_instance = in_game_menu.instantiate() as InGameMenu
	in_game_menu_instance.make_in_game_menu()
	add_child(in_game_menu_instance)
	

func _on_start_game_signal() -> void:
	visible = true
	

func _on_game_over_signal() -> void:
	print("Game over")
	var in_game_menu_instance = in_game_menu.instantiate() as InGameMenu
	in_game_menu_instance.make_game_over_menu()
	add_child(in_game_menu_instance)
	visible = false
	
