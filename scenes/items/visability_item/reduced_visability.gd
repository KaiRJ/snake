class_name ReducedVisability
extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var timer: Timer = $Timer

@export var snake: SnakeManager


func _ready() -> void:
	GameEvents.game_over.connect(_on_game_over)
	timer.timeout.connect(_on_timer_timeout)


func _process(_delta: float) -> void:
	if (is_instance_valid(snake.snake_body_parts.front())):
		var snake_head: SnakeBody = snake.snake_body_parts.front()
		var material: ShaderMaterial = color_rect.material
		material.set_shader_parameter("centre", snake_head.global_position)


func _on_game_over() -> void:
	await get_tree().create_timer(2.0).timeout  # Waits 2 seconds
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
