extends Node2D


@export var teleport_target = Node2D

var teleport_target_position : Vector2:
	get:
		return teleport_target.global_position

func _ready() -> void:
	if teleport_target == null:
		print("Warning! Not set a Teleport target position")
	else:
		print("Teleport target set!")

func _on_body_entered(body: Node2D) -> void:
	if teleport_target == null:
		print("Warning! Not set a teleport position")
	
	if body.has_method("teleport_to"):
		body.teleport_to(teleport_target_position)
	else:
		print("Warning! body has no method: 'teleport_to' attached")
	
