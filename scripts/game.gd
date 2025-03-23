extends Node2D
class_name GameManager

@export var world_scene : PackedScene
@export var player_scene : PackedScene
@export var ui: UI

var world : World
var player : Player


func start_game() -> void:
	print("Game started")
	
	world = world_scene.instantiate()
	add_child(world)
	move_child(world, 0)
	
	player = player_scene.instantiate()
	add_child(player)
	player.position = world.start_position
	player.game_manager = self
	
	if !player.collected.is_connected(ui._on_collected):
		player.collected.connect(ui._on_collected)
		
func _on_ui_start_game() -> void:
	start_game()

func _on_ui_become_host() -> void:
	MuliplayerManager.become_host()

func _on_ui_join_as_player_2(ip_address: String, port: int, name: String) -> void:
	MuliplayerManager.join_as_player_2(ip_address, port, name)
