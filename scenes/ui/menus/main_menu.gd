extends Control


@onready var buttons_v_box: VBoxContainer = %ButtonsVBox
@onready var multiplayer_menu: MultiplayerMenu = %MultiplayerMenu

signal become_host()
signal join_as_player_2(ip_address: String, port: int, name: String)

signal start_game()

func _ready() -> void:
	multiplayer_menu.hide()
	focus_button()

func _on_start_game():
	print("Start button pressed!")
	start_game.emit()
	hide()

func _on_quit_button_pressed():
	print("Exit button pressed!")
	get_tree().quit()
	
func _on_multiplayer_button_pressed():
	print("Multiplayer button pressed!")
	multiplayer_menu.show()
	pass

func _on_settings_button_pressed():
	print("Settings button pressed!")
	pass

func _on_visibility_changed():
	if visible:
		focus_button()


func focus_button() -> void:
	if buttons_v_box:
		var button: Button = buttons_v_box.get_child(0)
		if button is Button:
			button.grab_focus()


func _on_main_menu_start_game() -> void:
	start_game.emit()


func _on_multiplayer_menu_become_host() -> void:
	become_host.emit()


func _on_multiplayer_menu_join_as_player_2(ip_address: String, port: int, name: String) -> void:
	join_as_player_2.emit(ip_address, port, name)
