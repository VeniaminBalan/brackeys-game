extends AnimatableBody2D

@export var animation_player : AnimationPlayer

func _on_player_connected(id):
	if not multiplayer.is_server():
		print("animatin player removed")
		animation_player.stop(true)
		animation_player.set_active(false)
		animation_player.queue_free()
		
func _ready() -> void:
	if not multiplayer.is_server():
		animation_player.stop(true)
		animation_player.set_active(false)
		animation_player.queue_free()
		
		
	if animation_player:
		#multiplayer.peer_connected.connect(_on_player_connected)
		pass
