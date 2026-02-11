class_name SaveManager
extends Node


func _ready() -> void:
	GameEvents.save_game.connect(_on_save_game)
	GameEvents.load_game.connect(_on_load_game)


func _on_save_game() -> void:
	var saved_game: SavedGame = SavedGame.new()
	for persist: Node in get_tree().get_nodes_in_group("persist"):
		var save_callable: Callable = Callable(persist, "_on_save_game")
		if save_callable.is_valid():
			saved_game = save_callable.call(saved_game)
			
	ResourceSaver.save(saved_game, GameEvents.SAVE_FILE)


func _on_load_game() -> void:	
	var saved_game: SavedGame = load(GameEvents.SAVE_FILE)
	for persist: Node in get_tree().get_nodes_in_group("persist"):
		var load_callable: Callable = Callable(persist, "_on_load_game")
		if load_callable.is_valid():
			load_callable.call(saved_game)
