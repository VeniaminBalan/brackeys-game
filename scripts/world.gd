extends Node2D

class_name World

@export var start_node: Node2D

var start_position: Vector2:
	get:
		return start_node.position

func _ready() -> void:
	if start_position == null:
		print("Warning, this world has no starting position")
