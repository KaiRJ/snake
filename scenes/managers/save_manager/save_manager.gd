class_name SaveManager
extends Node


func _ready() -> void:
	GameEvents.save_game.connect(_on_save_game)
	GameEvents.load_game.connect(_on_load_game)


func _on_save_game() -> void:
	var saved_game: SavedGame = SavedGame.new()
	for thing in get_tree().get_nodes_in_group("persist"):
		if thing.has_method("on_save_game"):
			saved_game = thing.on_save_game(saved_game)
			
	ResourceSaver.save(saved_game, GameEvents.SAVE_FILE)


func _on_load_game() -> void:	
	var saved_game: SavedGame = load(GameEvents.SAVE_FILE)
	for thing in get_tree().get_nodes_in_group("persist"):
		if thing.has_method("on_load_game"):
			thing.on_load_game(saved_game)
	
