extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var gpu_particles: GPUParticles2D = $GPUParticles2D

@export var sprite: Sprite2D

func _ready() -> void:
	GameEvents.game_over.connect(_on_game_over)


func _on_game_over() -> void:
	var spawn_position: Vector2 = (owner as Node2D).global_position
	gpu_particles.texture = sprite.texture
	
	var body_node: Node = get_parent().get_parent() 
	get_parent().remove_child(self)
	body_node.add_child(self)
	
	global_position = spawn_position
	
	animation_player.play("default")
	
