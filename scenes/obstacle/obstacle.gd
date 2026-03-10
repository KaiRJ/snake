class_name Obstacle
extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var textures: Array[Texture2D]


func _ready() -> void:
	sprite_2d.texture = textures.pick_random()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is SnakeBody:
		GameEvents.game_over.emit()
