extends Control

signal back_to_game()

#func _process(delta: float) -> void:
	#if Input.is_action_pressed("back") and visible == true:
		#back_to_game.emit()

func _on_back_button_pressed() -> void:
	back_to_game.emit()

func _on_exit_main_menu_pressed() -> void:
	Engine.time_scale = 1
	get_tree().reload_current_scene()

func _on_exit_pressed() -> void:
	get_tree().quit()
