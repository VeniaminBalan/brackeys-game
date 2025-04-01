extends Node2D
class_name GameManager

@export var player_scene : PackedScene
@export var ui: UI

var game_manager : BaseGameManager
const MULTIPLAYER_MANAGER := preload("res://scripts/multiplayer/multiplayer_manager.tscn")


func init_manager(manager_scene: PackedScene) -> void:
	var manager = manager_scene.instantiate()
	if manager is BaseGameManager:
		game_manager = manager as BaseGameManager
		add_child(game_manager)
		move_child(game_manager, 0)
	else:
		push_error("[Game] ERROR: 'manager_scene' is not a instance of the BaseGameManager!")


func _on_ui_start_game(manager: PackedScene) -> void:
	init_manager(manager)
	game_manager.start()
	

func _on_ui_become_host(manager_scene: PackedScene) -> void:
	var manager = manager_scene.instantiate()	
	if manager is BaseGameManager:	
		var multiplayer_manager = MULTIPLAYER_MANAGER.instantiate()
		add_child(multiplayer_manager)
		move_child(multiplayer_manager, 0)
		multiplayer_manager.become_host(manager.world_scenes[0])
		multiplayer_manager.unique_name_in_owner = true

func _on_ui_join_as_player_2(ip_address: String, port: int, player_name: String) -> void:
	var multiplayer_manager = MULTIPLAYER_MANAGER.instantiate()
	add_child(multiplayer_manager)
	move_child(multiplayer_manager, 0)
	multiplayer_manager.join_as_player_2(ip_address, port, player_name)
	multiplayer_manager.unique_name_in_owner = true
