extends CanvasLayer
## In game UI to display the score, game size, and menu button.
##
## TODO
## 

## Reference to the item manager scene to get the score in the game.
@export var item_manager: ItemManager

## Reference to the snake manager scene to get the size of the snake.
@export var snake_manager: SnakeManager

## Reference to the snake size label in the UI.
@onready var snake_size_label = $%SnakeSize

## Reference to the score label in the UI.
@onready var score_label = $%Score


func _process(_delta: float) -> void:
	if item_manager == null:
		return 
	score_label.text = str(item_manager.total_score)
	
	if snake_manager == null:
		return
	snake_size_label.text = str(snake_manager.snake_body_parts.size())
