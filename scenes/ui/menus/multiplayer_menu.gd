extends Control
class_name MultiplayerMenu

signal become_host()
signal join_as_player_2(ip_address: String, port: int, name: String)


func _process(delta: float) -> void:
	if Input.is_action_pressed("back"):
		hide()

func _on_host_game_pressed() -> void:
	become_host.emit()

func _on_join_as_player_2_pressed() -> void:
	join_as_player_2.emit("127.0.0.1", 7777, "Player 2")

func _on_back_button_pressed() -> void:
	hide()
