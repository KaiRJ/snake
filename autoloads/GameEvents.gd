extends Node
##
##
##

## This signal is used to signal that a new game is starting.
#signal start_game

## This signal is used to signal that the game has ended.
@warning_ignore("unused_signal")
signal game_over

## This signal is used to signal to load the currently saved game.
@warning_ignore("unused_signal")
signal load_game

## This signal is used to signal to load the currently saved game.
@warning_ignore("unused_signal")
signal save_game


const SAVE_FILE: String = "user://savegame.tres"

## Go back to main menu
func quit_game() -> void:
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
