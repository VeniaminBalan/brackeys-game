extends CanvasLayer
class_name UI

@export var main_menu_scene: PackedScene
@export var in_game_menu_scene: PackedScene

var main_menu: Control = null
var in_game_menu: Control = null

signal become_host(world_scene: PackedScene)
signal join_as_player_2(ip_address: String, port: int, name: String)
signal start_game(manager: PackedScene)


func _ready() -> void:
	_create_main_menu()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("back") and in_game_menu:
		in_game_menu.visible = true
		Engine.time_scale = 0

func _on_in_game_menu_back_to_game() -> void:
	if in_game_menu:
		in_game_menu.visible = false
		Engine.time_scale = 1

### 🚀 Create & Subscribe to Main Menu
func _create_main_menu():
	if main_menu_scene:
		main_menu = main_menu_scene.instantiate() as Control
		add_child(main_menu)

		# Subscribe to signals
		main_menu.connect("start_game", _on_main_menu_start_game)
		main_menu.connect("become_host", _on_multiplayer_menu_become_host)
		main_menu.connect("join_as_player_2", _on_multiplayer_menu_join_as_player_2)

### 🚀 Create In-Game Menu
func _create_in_game_menu():
	if in_game_menu_scene:
		in_game_menu = in_game_menu_scene.instantiate() as Control
		add_child(in_game_menu)
		in_game_menu.connect("back_to_game", _on_in_game_menu_back_to_game)

### 🚀 Toggle Menus (Destroy & Recreate)
enum MenuMode { Main, InGame }
func toggle_menus(mode: MenuMode):
	match mode:
		MenuMode.Main:
			# Remove in-game menu and recreate main menu
			if in_game_menu:
				in_game_menu.queue_free()
				in_game_menu = null
			_create_main_menu()

		MenuMode.InGame:
			# Remove main menu and create in-game menu
			if main_menu:
				main_menu.queue_free()
				main_menu = null
			_create_in_game_menu()

### 🚀 Handling Menu Transitions
func _on_main_menu_start_game(manager: PackedScene) -> void:
	print("UI start game signal emitted")
	start_game.emit(manager)
	toggle_menus(MenuMode.InGame)  # Switch to in-game menu

func _on_multiplayer_menu_become_host(world_scene: PackedScene) -> void:
	become_host.emit(world_scene)
	toggle_menus(MenuMode.InGame)

func _on_multiplayer_menu_join_as_player_2(ip_address: String, port: int, name: String) -> void:
	join_as_player_2.emit(ip_address, port, name)
	toggle_menus(MenuMode.InGame)
